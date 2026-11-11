const aiClientPromise = import("@google/genai").then(({ GoogleGenAI }) => {
    return new GoogleGenAI({
        apiKey: process.env.GEMINI_API_KEY
    });
});

const PRIMARY_MODEL = process.env.GEMINI_MODEL || "gemini-3.8-flash";
const MAX_FALLBACKS = 3;
const TIMEOUT_MS = 15000;
const STICKY_MS = 5 * 60 * 1000;
// In errors par agle model ko try karte hain
const NEXT_MODEL_STATUSES = [404, 429, 500, 502, 503, 504];

const SYSTEM_PROMPT = `
You are ScamShield, an expert at detecting online shopping scams.

Analyze seller listings and chats from Instagram, Facebook, WhatsApp and online marketplaces, especially in South Asia.

IMPORTANT LANGUAGE RULE:
- Generate the entire response in clear, simple English ONLY.
- Every string value in the JSON must be written in English.
- Do not use Urdu or Roman Urdu anywhere.
- Even fields ending in "_ur" must contain English text.
- Keep all existing JSON field names exactly as provided.

Look for:
- Prices far below normal market price.
- Urgency or pressure to buy immediately.
- Advance payment through bank transfer, Easypaisa, JazzCash or crypto.
- Refusal of cash on delivery or protected payment.
- New accounts, few followers or no reviews.
- Suspicious product photos.
- Attempts to move conversations off-platform.
- Vague product details or unrealistic claims.

Also identify positive signals:
- Long account history.
- Genuine reviews.
- Clear return policy.
- Protected payment options.
- Detailed product information.

Rules:
- Never invent facts.
- Never claim certainty without evidence.
- If information is insufficient, give a score near 50.
- Trust score: 0 means highly suspicious, 100 means looks trustworthy.
- Return ONLY valid JSON.
- Do not include Markdown or explanations outside the JSON.

Use exactly this JSON structure:
{
  "trust_score": 50,
  "summary": "One sentence in English",
  "summary_ur": "Same summary in English",
  "red_flags": [
    {
      "title": "Warning title in English",
      "detail": "Explanation in English",
      "detail_ur": "Same explanation in English",
      "severity": "low"
    }
  ],
  "green_flags": [
    {
      "title": "Positive signal in English",
      "detail": "Explanation in English",
      "detail_ur": "Same explanation in English"
    }
  ],
  "questions_for_seller": [
    "Question 1 in English",
    "Question 2 in English",
    "Question 3 in English"
  ],
  "safe_advice": "Advice in English",
  "safe_advice_ur": "Same advice in English"
}
`;

function extractJson(raw) {
    const cleaned = raw
        .replace(/```json/gi, "")
        .replace(/```/g, "")
        .trim();

    const start = cleaned.indexOf("{");
    const end = cleaned.lastIndexOf("}");

    if (start === -1 || end === -1) {
        throw new Error("AI did not return valid JSON");
    }

    return JSON.parse(cleaned.slice(start, end + 1));
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

function withTimeout(promise, ms) {
    let timer;

    const timeout = new Promise((_, reject) => {
        timer = setTimeout(() => {
            const err = new Error(`Gemini timed out after ${ms} ms`);
            err.status = 504;
            reject(err);
        }, ms);
    });

    return Promise.race([promise, timeout]).finally(() => clearTimeout(timer));
}

// ---------- Backup models khud dhoondhna ----------

function versionOf(name) {
    const m = name.match(/^gemini-(\d+(?:\.\d+)?)/);
    return m ? parseFloat(m[1]) : 0;
}

async function discoverFallbacks(ai) {
    try {
        const found = [];

        for await (const m of await ai.models.list()) {
            const name = String(m.name || "").replace("models/", "");

            const isTextFlash =
                /^gemini-\d/.test(name) &&
                /flash/i.test(name) &&
                !/image|tts|live|embed|audio|robotics|computer|native|exp|vision|thinking/i.test(name);

            if (isTextFlash && name !== PRIMARY_MODEL) {
                found.push(name);
            }
        }

        // Naya version pehle, "lite" baad me
        found.sort((a, b) => {
            const diff = versionOf(b) - versionOf(a);
            if (diff !== 0) return diff;
            return /lite/i.test(a) - /lite/i.test(b);
        });

        const picked = found.slice(0, MAX_FALLBACKS);
        console.log(`Gemini primary: ${PRIMARY_MODEL} | fallbacks: ${picked.join(", ") || "none"}`);
        return picked;
    } catch (e) {
        console.warn(`Could not list Gemini models: ${String(e.message).slice(0, 100)}`);
        return [];
    }
}

// Server start hote hi list tayyar kar lo, taake pehli request tez rahe
const fallbackModelsPromise = aiClientPromise.then(discoverFallbacks);

let lastGood = null;
let lastGoodAt = 0;

async function modelOrder() {
    const fallbacks = await fallbackModelsPromise;
    const all = [PRIMARY_MODEL, ...fallbacks];

    let order = all;

    if (lastGood && Date.now() - lastGoodAt < STICKY_MS && all.includes(lastGood)) {
        order = [lastGood, ...all.filter((m) => m !== lastGood)];
    }

    // Agar sirf ek model hai to usi ko do baar try karo
    return order.length === 1 ? [order[0], order[0]] : order;
}

function configFor(model) {
    const config = {
        systemInstruction: SYSTEM_PROMPT,
        responseMimeType: "application/json",
        maxOutputTokens: 2048
    };

    if (/^gemini-3/.test(model)) {
        config.thinkingConfig = { thinkingLevel: "low" };
    } else if (/^gemini-2\.5/.test(model)) {
        config.thinkingConfig = { thinkingBudget: 0 };
    }

    return config;
}

// Model badalte hue jawab ka parse kiya hua JSON wapas deta hai
async function generateWithFallback(ai, parts) {
    const models = await modelOrder();
    let lastError;

    for (let i = 0; i < models.length; i++) {
        const model = models[i];
        const started = Date.now();

        try {
            console.log(`Gemini [${model}] started`);

            const response = await withTimeout(
                ai.models.generateContent({
                    model,
                    contents: [{ role: "user", parts }],
                    config: configFor(model)
                }),
                TIMEOUT_MS
            );

            const raw = response.text || "";

            if (!raw.trim()) {
                const err = new Error("Gemini returned empty text");
                err.status = 502;
                throw err;
            }

            let parsed;
            try {
                parsed = extractJson(raw);
            } catch (parseErr) {
                const err = new Error("Gemini returned invalid JSON");
                err.status = 502;
                throw err;
            }

            console.log(`Gemini [${model}] ok in ${Date.now() - started} ms`);
            lastGood = model;
            lastGoodAt = Date.now();

            return { result: parsed, model };
        } catch (e) {
            lastError = e;

            console.warn(
                `Gemini [${model}] failed after ${Date.now() - started} ms: ` +
                `status=${e.status} ${String(e.message).slice(0, 100)}`
            );

            // Key ya request ka masla har model par wahi rahega, isliye ruk jao
            if (!NEXT_MODEL_STATUSES.includes(e.status)) {
                throw e;
            }

            if (i < models.length - 1) {
                console.log("Switching to the next model...");
                await sleep(300);
            }
        }
    }

    throw lastError;
}

async function analyzeListing({ text, imageBase64, mediaType }) {
    const ai = await aiClientPromise;

    const parts = [];

    if (imageBase64) {
        const cleanBase64 = imageBase64.replace(
            /^data:image\/[^;]+;base64,/,
            ""
        );

        parts.push({
            inlineData: {
                mimeType: mediaType || "image/jpeg",
                data: cleanBase64
            }
        });
    }

    parts.push({
        text: text && text.trim()
            ? `Analyze this seller listing or chat:\n\n${text}`
            : "Analyze the seller listing or chat shown in this screenshot."
    });

    const { result, model } = await generateWithFallback(ai, parts);

    let score = Math.round(Number(result.trust_score));

    if (Number.isNaN(score)) {
        score = 50;
    }

    score = Math.max(0, Math.min(100, score));

    let verdict = "caution";

    if (score >= 70) {
        verdict = "safe";
    } else if (score < 40) {
        verdict = "risky";
    }

    return {
        trust_score: score,
        verdict,
        can_pay: verdict !== "risky",
        summary: result.summary || "",
        summary_ur: result.summary_ur || "",
        red_flags: result.red_flags || [],
        green_flags: result.green_flags || [],
        questions_for_seller: result.questions_for_seller || [],
        safe_advice: result.safe_advice || "",
        safe_advice_ur: result.safe_advice_ur || "",
        model_used: model
    };
}

module.exports = { analyzeListing };
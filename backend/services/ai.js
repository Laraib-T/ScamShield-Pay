
const aiClientPromise = import("@google/genai").then(({ GoogleGenAI }) => {
    return new GoogleGenAI({
        apiKey: process.env.GEMINI_API_KEY
    });
});

const MODEL = "gemini-3.8-flash";

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

async function analyzeListing({ text, imageBase64, mediaType }) {
    const ai = await aiClientPromise;

    const contents = [];

    if (imageBase64) {
        const cleanBase64 = imageBase64.replace(
            /^data:image\/[^;]+;base64,/,
            ""
        );

        contents.push({
            inlineData: {
                mimeType: mediaType || "image/jpeg",
                data: cleanBase64
            }
        });
    }

    contents.push({
        text: text && text.trim()
            ? `Analyze this seller listing or chat:\n\n${text}`
            : "Analyze the seller listing or chat shown in this screenshot."
    });

    const response = await ai.models.generateContent({
        model: MODEL,
        contents: [{ role: "user", parts: contents }],
        config: {
            systemInstruction: SYSTEM_PROMPT,
            responseMimeType: "application/json",
            maxOutputTokens: 2048,
            thinkingConfig: { thinkingBudget: 0 }
        }
    });

    const raw = response.text || "";

    if (!raw.trim()) {
        throw new Error("Gemini returned empty text");
    }

    const result = extractJson(raw);

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
        safe_advice_ur: result.safe_advice_ur || ""
    };
}

module.exports = { analyzeListing };

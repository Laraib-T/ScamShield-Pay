
const crypto = require("crypto");

const BASE = process.env.PAYPAL_BASE_URL ||
    "https://api-m.sandbox.paypal.com";

async function getAccessToken() {
    const auth = Buffer.from(
        `${process.env.PAYPAL_CLIENT_ID}:${process.env.PAYPAL_CLIENT_SECRET}`
    ).toString("base64");

    const res = await fetch(`${BASE}/v1/oauth2/token`, {
        method: "POST",
        headers: {
            Authorization: `Basic ${auth}`,
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "grant_type=client_credentials"
    });

    const data = await res.json();

    if (!res.ok) {
        throw new Error(`PayPal auth failed: ${JSON.stringify(data)}`);
    }

    return data.access_token;
}

async function createOrder({ amount, description }) {
    const value = Number(amount);

    if (!value || value <= 0) {
        throw new Error("Invalid amount");
    }

    const token = await getAccessToken();
    const appUrl = process.env.APP_BASE_URL ||
        "http://localhost:3000";

    const res = await fetch(`${BASE}/v2/checkout/orders`, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "PayPal-Request-Id": crypto.randomUUID()
        },
        body: JSON.stringify({
            intent: "CAPTURE",
            purchase_units: [
                {
                    description: description ||
                        "ScamShield Pay purchase",
                    amount: {
                        currency_code: "USD",
                        value: value.toFixed(2)
                    }
                }
            ],
            payment_source: {
                paypal: {
                    experience_context: {
                        brand_name: "ScamShield Pay",
                        user_action: "PAY_NOW",
                        shipping_preference: "NO_SHIPPING",
                        return_url: `${appUrl}/paypal/return`,
                        cancel_url: `${appUrl}/paypal/cancel`
                    }
                }
            }
        })
    });

    const data = await res.json();

    if (!res.ok) {
        throw new Error(
            `PayPal create order failed: ${JSON.stringify(data)}`
        );
    }

    const link =
        data.links.find((l) => l.rel === "payer-action") ||
        data.links.find((l) => l.rel === "approve");

    return {
        orderId: data.id,
        status: data.status,
        approveUrl: link ? link.href : null
    };
}

async function captureOrder(orderId) {
    const token = await getAccessToken();

    const res = await fetch(
        `${BASE}/v2/checkout/orders/${orderId}/capture`,
        {
            method: "POST",
            headers: {
                Authorization: `Bearer ${token}`,
                "Content-Type": "application/json",
                "PayPal-Request-Id": crypto.randomUUID()
            }
        }
    );

    const data = await res.json();

    if (!res.ok) {
        throw new Error(
            `PayPal capture failed: ${JSON.stringify(data)}`
        );
    }

    const capture =
        data.purchase_units?.[0]?.payments?.captures?.[0];

    return {
        orderId: data.id,
        status: data.status,
        captureId: capture?.id,
        amount: capture?.amount?.value,
        currency: capture?.amount?.currency_code
    };
}

module.exports = { createOrder, captureOrder };

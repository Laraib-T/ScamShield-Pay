
const braintree = require("braintree");

const gateway = new braintree.BraintreeGateway({
    environment: braintree.Environment.Sandbox,
    merchantId: process.env.BRAINTREE_MERCHANT_ID,
    publicKey: process.env.BRAINTREE_PUBLIC_KEY,
    privateKey: process.env.BRAINTREE_PRIVATE_KEY
});

// Generate Client Token
async function generateClientToken() {
    const response = await gateway.clientToken.generate({});
    return response.clientToken;
}

// Create Payment Transaction
async function createTransaction({ amount, paymentMethodNonce }) {
    const value = Number(amount);

    if (!Number.isFinite(value) || value <= 0) {
        throw new Error("Invalid payment amount");
    }

    if (!paymentMethodNonce) {
        throw new Error("Payment method nonce is required");
    }

    const result = await gateway.transaction.sale({
        amount: value.toFixed(2),
        paymentMethodNonce,
        options: {
            submitForSettlement: true
        }
    });

    if (!result.success) {
        throw new Error(result.message);
    }

    return {
        transactionId: result.transaction.id,
        status: result.transaction.status,
        amount: result.transaction.amount
    };
}

module.exports = {
    generateClientToken,
    createTransaction
};

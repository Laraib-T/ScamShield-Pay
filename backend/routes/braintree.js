
const express = require("express");

const router = express.Router();

const {
    generateClientToken,
    createTransaction
} = require("../services/braintree");

// Get Client Token
router.get("/client-token", async (req, res) => {
    try {
        const clientToken = await generateClientToken();

        res.json({
            success: true,
            clientToken
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

// Process Payment
router.post("/checkout", async (req, res) => {
    try {
        const { amount, paymentMethodNonce } = req.body;

        const result = await createTransaction({
            amount,
            paymentMethodNonce
        });

        res.json({
            success: true,
            message: "Payment processed successfully",
            payment: result
        });

    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
});

module.exports = router;

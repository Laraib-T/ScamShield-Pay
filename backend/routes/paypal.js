
const express = require("express");

const {
    createOrder,
    captureOrder
} = require("../services/paypal");

const router = express.Router();

// Create PayPal Order
router.post("/create-order", async (req, res) => {
    try {
        const { amount, description } = req.body;

        const order = await createOrder({
            amount,
            description
        });

        res.json(order);

    } catch (err) {
        console.error("Create order error:", err.message);

        res.status(500).json({
            error: err.message
        });
    }
});

// Capture PayPal Payment
router.post("/capture-order", async (req, res) => {
    try {
        const { orderId } = req.body;

        if (!orderId) {
            return res.status(400).json({
                error: "orderId is required"
            });
        }

        const result = await captureOrder(orderId);

        res.json(result);

    } catch (err) {
        console.error("Capture error:", err.message);

        res.status(500).json({
            error: err.message
        });
    }
});

// PayPal Return
router.get("/return", (req, res) => {
    res.send("<h2>Payment approved. You can go back to the app.</h2>");
});

// PayPal Cancel
router.get("/cancel", (req, res) => {
    res.send("<h2>Payment cancelled. You can go back to the app.</h2>");
});

module.exports = router;

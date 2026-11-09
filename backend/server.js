
require("dotenv").config();

const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json({ limit: "10mb" }));

// Home / Health Check
app.get("/", (req, res) => {
    res.json({
        status: "ok",
        app: "ScamShield Pay backend"
    });
});

// AI Analysis Route
app.use("/analyze", require("./routes/analyze"));

// PayPal Routes
app.use("/paypal", require("./routes/paypal"));
app.use("/braintree", require("./routes/braintree"));

// Start Server
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`ScamShield backend running on port ${PORT}`);
});


const express = require("express");
const { analyzeListing } = require("../services/ai");

const router = express.Router();

router.post("/", async (req, res) => {
    try {
        const { text, imageBase64, mediaType } = req.body;

        if ((!text || !text.trim()) && !imageBase64) {
            return res.status(400).json({
                error: "Please send text or a screenshot."
            });
        }

        const result = await analyzeListing({
            text,
            imageBase64,
            mediaType
        });

        res.json(result);

    } catch (err) {
        console.error("Analyze error:", err);

        res.status(500).json({
            error: "Analysis failed. Please try again."
        });
    }
});

module.exports = router;

const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from public directory
app.use(express.static("public"));

// Health check endpoint
app.get("/health", (req, res) => {
    res.json({
        status: "UP",
        application: "NID3",
        version: "1.0.0"
    });
});

// API endpoint
app.get("/api/info", (req, res) => {
    res.json({
        name: "NID3",
        message: "Welcome to the NID3 DevOps Project!",
        environment: process.env.NODE_ENV || "development"
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`NID3 application running on port ${PORT}`);
});

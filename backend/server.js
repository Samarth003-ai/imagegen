const express = require("express");
const FormData = require("form-data");
const cors = require("cors");
require("dotenv").config(); // used to load env variables
const https = require("https"); // used to make secure HTTPS requests

console.log(process.env.STABILITY_API_KEY);
const app = express();

//



app.use(cors());
app.use(express.json());  // if req  is json convert it in req.body

// create end point

app.post("/generate-image", (req, res) => {
    try {
        const prompt = req.body.prompt;

        if (!prompt) {
            return res.status(400).json({ error: "Prompt is required" });
        }
        console.log("Prompt", prompt);

        const form = new FormData(); // stabilty accepts data in form
        form.append("prompt", prompt);
        form.append("output_format", "png");

        //create stability request
        const options = {        // describes how the http request should be sent
            hostname: "api.stability.ai",
            path: "/v2beta/stable-image/generate/core",
            method: "POST",
            headers: {
                Authorization:
                    `Bearer ${process.env.STABILITY_API_KEY}`,
                Accept: "image/*",
                ...form.getHeaders(),  // generates boundary in form as from needs boundary in different types
            },
        };

        const stabilityRequest = https.request(options,  // node reads options and knows where to send request.... stuffs
            (stabilityResponse) => {
                let chunks = [];
                stabilityResponse.on("data", (chunk) => {
                    chunks.push(chunk);
                });

                stabilityResponse.on("end", () => {   //when response ends from stability ai
                    const imageBuffer = Buffer.concat(chunks); // cocncats image bytes
                    if (stabilityResponse.statusCode !== 200) {
                        console.error("Stability Error:", stabilityResponse.statusCode, imageBuffer.toString());
                        return res.status(500).json({ error: "Failed to generate image" });
                    }

                    //if image is valid
                    const imageBase64 = imageBuffer.toString("base64");

                    res.json({
                        image: imageBase64,
                    });

                });
            }
        );
        stabilityRequest.on("error", (err) => {
            console.error(err);

            res.status(500).json({
                error: "Failed to generate image",
            });
        });

        form.pipe(stabilityRequest);  // it sends all the form daata ininto hTTP requests
    } catch (error) {
        console.error("Server error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
});

app.listen(5000, () => {
    console.log("server running");
})


const fs = require('fs');
const path = require('path');

function getBase64Image(imagePath) {
    const imageBuffer = fs.readFileSync(imagePath);
    return imageBuffer.toString('base64');
}

function generateHTMLTemplate(subject, content) {
    const imagePath = path.join(__dirname, '..', 'src', 'img', 'giphy.webp');
    const base64Image = getBase64Image(imagePath);

    return `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${subject}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    line-height: 1.6;
                    color: #333;
                }
                .container {
                    background-color: #fff;
                    max-width: 600px;
                    margin: 0 auto;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 5px;
                }
                h1 {
                    color: #000;
                }
                .email-image {
                    max-width: 100%;
                    height: auto;
                    display: block;
                    margin: 20px auto;
                }
                b {
                    font-size: 20px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>${subject}</h1>
                ${content}
                <img src="data:image/webp;base64,${base64Image}" alt="Email Image" class="email-image">
            </div>
        </body>
        </html>
    `;
}

module.exports = { generateHTMLTemplate };

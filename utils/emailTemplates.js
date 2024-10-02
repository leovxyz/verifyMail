// Reusable HTML template for emails

function generateHTMLTemplate(subject, content) {
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
                    max-width: 600px;
                    margin: 0 auto;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 5px;
                }
                h1 {
                    color: #4a4a4a;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>${subject}</h1>
                ${content}
            </div>
        </body>
        </html>
    `;
}

module.exports = { generateHTMLTemplate };

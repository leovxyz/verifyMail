const { transporter } = require('../config/mailConfig');

function generateHTMLTemplate(subject, message) {
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
                <p>${message}</p>
            </div>
        </body>
        </html>
    `;
}

function sendTokenVerifiedEmail(to) {
    const subject = 'Email Verification Successful';
    const message = 'Your email has been successfully verified. Thank you for completing the verification process.';
    const htmlContent = generateHTMLTemplate(subject, message);

    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: to,
        subject: subject,
        html: htmlContent
    };

    return transporter.sendMail(mailOptions);
}

module.exports = { sendTokenVerifiedEmail };

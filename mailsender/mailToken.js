const nodemailer = require('nodemailer');
const { generateAndStoreToken } = require('../token/tokenGeneration'); // Import the new function
const { promptForVerification } = require('../token/tokenVerification');
const { sendTokenVerifiedEmail } = require('./tokenVerifiedEmail');
const { transporter } = require('../config/mailConfig');

function generateHTMLTemplate(subject, message) {
    const htmlEmailTemplate = `
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
    return htmlEmailTemplate;
}

// Send an email with a verification code and then prompt for verification
function sendMailAndVerify(to, subject, msg) {
    // Generate and store a new token, and get the verification code
    const { verificationCode } = generateAndStoreToken(to);
    
    // Create the email content with the verification code
    const htmlContent = generateHTMLTemplate(subject, msg + verificationCode);
    
    // Send the email
    transporter.sendMail({
        to: to,
        subject: subject,
        html: htmlContent
    }, (error, info) => {
        if (error) {
            console.error("Error sending email:", error);
        } else {
            console.log(`Email sent to: ${to}`);
            // After sending the email, prompt for verification
            promptForVerification(to);
        }
    });
}

// Example usage (you may want to remove or modify this based on your needs)
sendMailAndVerify('leov3@pm.me', 'Verification Code', 'Your verification code is: ');

module.exports = { sendMailAndVerify, transporter };


// run this command in terminal to send mail
// node mailsender\mailToken.js

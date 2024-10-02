const nodemailer = require('nodemailer');
const { generateAndStoreToken } = require('../token/tokenGeneration');
const { handleVerification } = require('../token/tokenVerification');
const { transporter } = require('../config/mailConfig');
const readline = require('readline');

// Generate an HTML template for the verification email
function generateHTMLTemplate(verificationCode) {
    return `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Verification Code</title>
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
                <h1>Verification Code</h1>
                <p>Your verification code is: ${verificationCode}</p>
            </div>
        </body>
        </html>
    `;
}

// Prompt the user to enter their email address
function askForEmail() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
        terminal: false
    });

    return new Promise((resolve) => {
        const promptEmail = () => {
            rl.question('Enter your email: ', (email) => {
                if (email.includes('@')) {
                    rl.close();
                    resolve(email);
                } else {
                    console.log('Invalid email. Please include "@" in your email address.');
                    promptEmail();
                }
            });
        };
        promptEmail();
    });
}

// Prompt the user to enter the verification code they received
function askForVerificationCode() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    return new Promise((resolve) => {
        rl.question('Enter the verification code you received: ', (code) => {
            rl.close();
            resolve(code.trim());
        });
    });
}

// Main function to send verification email and verify the code
async function sendMailAndVerify() {
    // Get the recipient's email address
    const recipientEmail = await askForEmail();
    
    // Generate and store a verification token
    const { verificationCode } = generateAndStoreToken(recipientEmail);
    
    // Prepare the email options
    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: recipientEmail,
        subject: 'Verification Code',
        html: generateHTMLTemplate(verificationCode)
    };
    
    try {
        // Send the verification email
        await transporter.sendMail(mailOptions);
        console.log(`Verification email sent to: ${recipientEmail}`);
        
        // Prompt the user to enter the verification code
        const userInputCode = await askForVerificationCode();
        
        // Verify the entered code
        const isVerified = await handleVerification(recipientEmail, userInputCode);
        
        // Display the verification result
        if (isVerified) {
            console.log("Verification process completed successfully!");
        } else {
            console.log("Verification process failed.");
        }
    } catch (error) {
        console.error("Error sending email or verifying:", error);
    }
}

async function main() {
    await sendMailAndVerify();
    // Add a small delay before exiting to ensure all console messages are displayed
    await new Promise(resolve => setTimeout(resolve, 100));
    process.exit(0);
}

main().catch(console.error);

module.exports = { sendMailAndVerify };

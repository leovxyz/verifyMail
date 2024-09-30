const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport(
    {
        secure: false,
        host: 'smtp.gmail.com',
        port: 587,
        auth: {
            user: 'user.authentication2k@gmail.com',
            pass: 'irmvfxzwpjcoqlir'
        }
    }
);

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

function sendMail(to, subject, msg) {
    const htmlContent = generateHTMLTemplate(subject, msg);
    
    transporter.sendMail({
        to: to,
        subject: subject,
        html: htmlContent
    }, (error, info) => {
        if (error) {
            console.error("Error sending email:", error);
        } else {
            console.log("Email sent:", info.response);
        }
    });
}

sendMail('leov3@pm.me', 'Welcome to Our Service', 'Thank you for registering with us. We hope you enjoy using our platform!');

// run this command in terminal to send mail
// node mailsender\mailSender.js

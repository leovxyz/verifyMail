const { transporter } = require('../config/mailConfig');
const { generateHTMLTemplate } = require('../utils/emailTemplates');

// Function to send an email when the token is verified
function sendTokenVerifiedEmail(to) {
    const subject = 'Email Verification Successful';
    const content = '<p>Your email has been successfully verified. Thank you for completing the verification process.</p>';
    const htmlContent = generateHTMLTemplate(subject, content);

    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: to,
        subject: subject,
        html: htmlContent
    };

    return transporter.sendMail(mailOptions);
}

module.exports = { sendTokenVerifiedEmail };

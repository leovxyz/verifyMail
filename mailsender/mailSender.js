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

function sendMail(to, subject, msg) {
    transporter.sendMail({
        to: 'leov3@pm.me',
        subject: subject,
        html: msg
    });

    console.log("Email sent");
}

sendMail('user.authentication2k@gmail.com', 'This is a subject', 'This is a test message');
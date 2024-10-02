const jwt = require('jsonwebtoken');

// Generate a 6-digit random code
const generateVerificationCode = () => {
  return Math.floor(100000 + Math.random() * 900000); // Generates a 6-digit code
};

const verificationCode = generateVerificationCode();

// Create a JWT token containing the code that expires in 10 minutes
const token = jwt.sign({ code: verificationCode }, 'yourSecretKey', { expiresIn: '10m' });
// console.log(verificationCode);

// Export the verificationCode
module.exports = { verificationCode };


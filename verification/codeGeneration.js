const jwt = require('jsonwebtoken');
const { storeToken } = require('../memoryStore/verificationCodeStore'); // Import the storeToken function

// Generate a 6-digit verification code
function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000);
}

// Generate a token and store it in memory
function generateAndStoreToken(email) {
  const verificationCode = generateVerificationCode();
  // Use the environment variable here
  const token = jwt.sign({ code: verificationCode }, process.env.JWT_SECRET_KEY, { expiresIn: '10m' });
  storeToken(email, token); // Store the token in memory
  return { verificationCode, token };
}

module.exports = { generateAndStoreToken };


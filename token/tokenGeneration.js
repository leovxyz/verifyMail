const jwt = require('jsonwebtoken');
const { storeToken } = require('../storage/tokenStorage'); // Import the storeToken function

// Generate a 6-digit verification code
function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000);
}

// Generate a token and store it in memory
function generateAndStoreToken(email) {
  const verificationCode = generateVerificationCode();
  // Create a JWT token with the verification code, expiring in 10 minutes
  const token = jwt.sign({ code: verificationCode }, 'yourSecretKey', { expiresIn: '10m' });
  storeToken(email, token); // Store the token in memory
  return { verificationCode, token };
}

module.exports = { generateAndStoreToken };


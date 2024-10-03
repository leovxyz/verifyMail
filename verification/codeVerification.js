const jwt = require('jsonwebtoken');
const { getToken, removeToken } = require('../memoryStore/verificationCodeStore');
const { sendTokenVerifiedEmail } = require('../email/verificationSuccessEmail');

// Function to verify the token
async function verifyToken(email, userCode) {
  const token = getToken(email);
  if (!token) {
    console.log('No valid token found for this email.');
    return false;
  }

  try {
    // Use the environment variable here
    const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
    if (decoded.code === parseInt(userCode)) {
      console.log('Verification successful!');
      removeToken(email);
      try {
        await sendTokenVerifiedEmail(email);
        console.log('Verification success email sent');
      } catch (error) {
        console.error('Error sending verification success email:', error);
      }
      return true;
    } else {
      console.log('Incorrect verification code.');
      return false;
    }
  } catch (error) {
    console.log('Token verification failed:', error.message);
    return false;
  }
}

// Function to handle verification
async function handleVerification(email, userCode) {
  const isVerified = await verifyToken(email, userCode);
  if (isVerified) {
    console.log('Your email has been verified.');
    return true;
  } else {
    return false;
  }
}
module.exports = { handleVerification };

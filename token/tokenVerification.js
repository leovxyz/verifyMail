const readline = require('readline');
const jwt = require('jsonwebtoken');
const { getToken, removeToken } = require('../storage/tokenStorage');
const { sendTokenVerifiedEmail } = require('../mailsender/tokenVerifiedEmail');

// Create readline interface for user input
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Function to verify the token
function verifyToken(email, userCode) {
  const token = getToken(email);
  if (!token) {
    console.log('No valid token found for this email.');
    return false;
  }

  try {
    const decoded = jwt.verify(token, 'yourSecretKey');
    if (decoded.code === parseInt(userCode)) {
      console.log('Verification successful!');
      removeToken(email);
      sendTokenVerifiedEmail(email)
        .then(() => console.log('Verification success email sent'))
        .catch(error => console.error('Error sending verification success email:', error));
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

// Function to prompt for verification code
function promptForVerification(email) {
  rl.question('Please enter the verification code sent to your email: ', (userCode) => {
    const isVerified = verifyToken(email, userCode);
    if (isVerified) {
      console.log('Your email has been verified.');
    
    } else {
      console.log('Verification failed. Requesting new code...');
    }
    rl.close();
  });
}

// Export the function to be used in other parts of your application
module.exports = { promptForVerification };

// Example usage (you can remove or comment this out if you're calling it from another file)
// promptForVerification('leov3@pm.me');

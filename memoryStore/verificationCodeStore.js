// In-memory storage for tokens using a Map
const tokenStore = new Map();

// Store a token for a given email
function storeToken(email, token) {
  tokenStore.set(email, {
    token,
    expiresAt: Date.now() + 600000 // Token expires after 10 minutes (600000 milliseconds)
  });
}

// Retrieve a token for a given email
function getToken(email) {
  const storedToken = tokenStore.get(email);
  if (storedToken && storedToken.expiresAt > Date.now()) {
    return storedToken.token; // Return the token if it exists and hasn't expired
  }
  tokenStore.delete(email); // Remove expired token
  return null; // Return null if token doesn't exist or has expired
}

// Remove a token for a given email
function removeToken(email) {
  tokenStore.delete(email);
}

module.exports = { storeToken, getToken, removeToken };

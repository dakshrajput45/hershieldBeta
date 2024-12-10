const admin = require("firebase-admin");
require("dotenv").config();

// Parse the service account credentials from the environment variable
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

// Initialize Firebase Admin SDK with parsed credentials
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.databaseURL, // Retrieve the database URL from the service account
});

console.log("firebase connect");

// Export Firebase services
const db = admin.firestore();

module.exports = {db};
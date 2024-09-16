const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

// Remova a configuração de emulação, se não for necessária
admin.initializeApp();

exports.setUserClaims = onCall(async (request) => {
  const data = request.data;
  const context = request.auth;

  if (!context) {
    throw new Error("User must be authenticated to call this function.");
  }

  const uid = data.uid;
  const role = data.role !== undefined ? data.role : 1;
  const status = data.status !== undefined ? data.status : 0;

  await admin.auth().setCustomUserClaims(uid, {
    role: role,
    status: status,
  });

  return {
    message: `Success! User with UID ${uid} registered with role' +
      ' ${role} and status ${status}.`,
  };
});


const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

// Inicializa o Firebase Admin App
if (process.env.FUNCTIONS_EMULATOR === "true") {
  admin.initializeApp({
    projectId: "delivery-16712", // Coloque seu Project ID
  });
} else {
  admin.initializeApp();
}

// Se estiver usando o emulador do Firestore, configure o emulador
const db = admin.firestore();
if (process.env.FUNCTIONS_EMULATOR === "true") {
  db.settings({
    host: "localhost:8080",
    ssl: false,
  });
}

exports.setUserClaims = onCall(async (request) => {
  const data = request.data;
  const context = request.auth;

  // Verificar se o usuário está autenticado
  if (!context) {
    console.log("Usuário não autenticado no emulador");
    throw new Error(
        "User must be authenticated to call this function.",
    );
  } else {
    console.log("Usuário autenticado no emulador: ", context);
  }

  // Obter UID do usuário que está sendo registrado
  const uid = data.uid;
  // Checar se o role e status foram passados, senão, usar valores padrão
  const role = data.role !== undefined ? data.role : 1; // 1 = business
  const status = data.status !== undefined ? data.status : 0; // 0 = offline

  // Verificar se existem outros usuários no banco de dados
  const usersSnapshot = await db.collection("users").get();

  // Verifica se é o primeiro usuário; se sim, torna-o administrador
  if (usersSnapshot.empty) {
    console.log("Primeiro usuário, tornando-o admin");
    await admin.auth().setCustomUserClaims(uid, {
      role: 0, // 0 = admin
      status: status,
    });

    // Remova a gravação no Firestore, pois você não deseja salvar
    // na coleção `users`
    return {
      message: `Success! First user with UID ${uid} registered as ` +
        `admin (role 0).`,
    };
  }

  // Caso contrário, definir os claims baseados no `role` e `status` fornecidos
  console.log("Definindo claims para o usuário");
  await admin.auth().setCustomUserClaims(uid, {
    role: role,
    status: status,
  });

  return {
    message: `Success! User with UID ${uid} registered with role ${role} ` +
      `and status ${status}.`,
  };
});


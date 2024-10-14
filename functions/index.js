const {onCall} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

// Remova a configuração de emulação, se não for necessária
admin.initializeApp();
const {FieldValue} = require("firebase-admin/firestore");

exports.setUserClaims = onCall(
    {
      region: "southamerica-east1", // Define a região
    },

    async (request) => {
      const data = request.data;
      const context = request.auth;

      if (!context) {
        throw new Error("User must be authenticated to call this function.");
      }

      const uid = data.uid;
      const role = data.role !== undefined ? data.role : 1;
      const status = data.status !== undefined ? data.status : 0;
      const managerId = data.managerId !== undefined ? data.managerId : "";

      const customClaims = {
        role: role,
        status: status,
      };

      if (managerId) {
        customClaims.managerId = managerId;
      }

      await admin.auth().setCustomUserClaims(uid, customClaims);

      return {
        message: `Success! User with UID ${uid} registered with role' +
          ' ${role}, status ${status}, and managerId "${managerId}".`,
      };
    },
);

// Função para verificar e resetar entregas reservadas há mais de 5 minutos
exports.checkReservedDeliveries = onSchedule(
    {
      schedule: "every 5 minutes",
      region: "southamerica-east1",
    },
    async (event) => {
      const now = new Date();
      const fiveMinutesAgo = new Date(now.getTime() - 5 * 60000);

      try {
        // Consultar todas as entregas com status `orderReservedForPickup`
        // e `updatedAt` menor que 5 minutos atrás
        const deliveriesSnapshot = await admin.firestore()
            .collection("deliveries")
            .where("status", "==", 1) // 1 corresponde a orderReservedForPickup
            .where("updatedAt", "<", fiveMinutesAgo)
            .get();

        const batch = admin.firestore().batch();

        deliveriesSnapshot.forEach((doc) => {
          const deliveryRef = doc.ref;

          // Atualizar status para `orderRegisteredForPickup` e remover os
          // atributos de entrega
          batch.update(deliveryRef, {
            status: 0, // 0 corresponde a `orderRegisteredForPickup`
            deliveryId: null,
            deliveryName: null,
            deliveryPhone: null,
            updatedAt: FieldValue.serverTimestamp(),
          });
        });

        await batch.commit();
        const delShot = deliveriesSnapshot.size;
        console.log(
            `Successfully updated ${delShot} reserved deliveries.`,
        );
      } catch (error) {
        console.error("Error checking reserved deliveries: ", error);
      }

      return null;
    },
);

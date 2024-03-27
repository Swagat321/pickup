import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK
admin.initializeApp();

// Cloud Function to send notification on game creation
exports.sendGameInvitation = functions.firestore
  .document("games/{gameId}")
  .onCreate(async (snap) => {
    // Getting the new game data
    const newValue = snap.data();

    if (!newValue) {
      console.log("No data found for the new game.");
      return null;
    }

    // Constructing the notification message
    const message: admin.messaging.Message = {
      notification: {
        title: "PickUp",
        body: `${newValue.chatName} is inviting you to play soccer...`,
      },
      topic: "games",
    };

    // Sending the notification
    try {
      const response = await admin.messaging().send(message);
      console.log("Successfully sent message:", response);
    } catch (error) {
      console.error("Error sending message:", error);
    }
    return null;
  });

const admin = require("firebase-admin");

const sendNotifications = async (tokens, sosData) => {
    if (!tokens || tokens.length === 0) {
        console.log("⚠️ No tokens provided, skipping notification.");
        return;
    }
    console.log("sosData",sosData);
    const message = {
        notification: {
            title: "🚨 SOS Alert!",
            body: "Someone nearby needs help. Tap to view location.",
        },
        data: sosData, // Custom payload
        android: {
            priority: "high",
            notification: {
                sound: "siren",  // Ensure siren.mp3 is in res/raw
                click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
        },
        apns: {
            payload: {
                aps: {
                    sound: "siren.caf", // Ensure siren.caf exists in iOS project
                    contentAvailable: true,
                },
            },
        },
        tokens, // ✅ Correctly passing FCM tokens
    };

    try {
        // ✅ Correct usage of sendEachForMulticast
        const response = await admin.messaging().sendEachForMulticast(message);

        console.log(`📩 Notification sent! Success: ${response.successCount}, Failures: ${response.failureCount}`);

        // Log failed tokens for debugging
        if (response.failureCount > 0) {
            response.responses.forEach((res, idx) => {
                if (!res.success) {
                    console.error(`❌ Error for token ${tokens[idx]}: ${res.error}`);
                }
            });
        }
    } catch (error) {
        console.error("❌ Error sending notification:", error);
    }
};

module.exports = { sendNotifications };

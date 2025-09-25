import { messaging } from "firebase-admin";

export const notify = (fcmToken: string, title: string, body: string, data: messaging.DataMessagePayload) => {
    const payload: messaging.MessagingPayload = {
        notification: {
            title,
            body,
        },
        data,
    };

    messaging().sendToDevice(fcmToken, payload, {
        contentAvailable: true,
        priority: "high"
    });
}
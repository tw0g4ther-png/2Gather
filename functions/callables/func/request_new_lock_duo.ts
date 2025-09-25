import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {

        const user = admin.firestore().collection("users").doc(params.userId);
        const userData = await user.get();
        const friend = admin.firestore().collection("users").doc(params.friendId);
        const friendData = (await friend.get()).data()!;

        await friend.collection("notifications").add({
            notificationType: "duoRequest",
            isComplete: false,
            isRead: false,
            message: `souhaite devenir ton LockDuo.`,
            notificationUser: {
                id: user.id,
                firstname: userData.data()?.firstname,
                lastname: userData.data()?.lastname,
                pictures: userData.data()?.profilImages,
            },
            receivedAt: admin.firestore.Timestamp.now(),
        });

        if (friendData.fcmToken !== undefined && friendData.fcmToken !== "") {
            await admin.messaging().sendMulticast({
              tokens: [friendData.fcmToken],
              notification: {
                title: "Tu as reçu une nouvelle demande de LockDuo.",
                body: `${userData.data()?.firstname} souhaite devenir ton LockDuo.`,
              },
            });
          }

        return true;
    } catch (e) {
        f.logger.error("[Error] requestNewLockDuo: ", e);
        return { error: e };
    }
}

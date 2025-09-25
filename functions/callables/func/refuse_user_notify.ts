import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const fiesta = admin.firestore().collection("fiesta").doc(params.fiestaId);
        const fiestaData = (await fiesta.get()).data()!;
        const user = admin.firestore().collection("users").doc(params.userId);
        const userData = (await user.get()).data()!;
        const duo = admin.firestore().collection("users").doc(params.duoRef);
        const duoData = (await duo.get()).data()!;

        await user.collection("notifications").add({
            notificationType: "message",
            isComplete: false,
            isRead: false,
            message: `Désolé, l'Host à refuser votre Duo Lock avec ${duoData.firstname} pour aller à la Fiesta "${fiestaData.title}"`,
            notificationUser: {
                id: "B8drnR5SpphFShASN2rGoQJFGL32",
                firstname: "FiestaFamily",
                lastname: "",
                pictures: ["https://firebasestorage.googleapis.com/v0/b/fiesta-9f99b.appspot.com/o/users%2FB8drnR5SpphFShASN2rGoQJFGL32%2Fprofil%2Fimage_picker_33926E71-337A-433B-9DFD-22747FD35170-79617-0000115A569364AA.png?alt=media&token=8e68aae1-8c80-4922-8eab-6ea1f9bf9b92"],
            },
            receivedAt: admin.firestore.Timestamp.now(),
        });


        await duo.collection("notifications").add({
            notificationType: "message",
            isComplete: false,
            isRead: false,
            message: `Désolé, l'Host à refuser votre Duo Lock avec ${userData.firstname} pour aller à la Fiesta "${fiestaData.title}"`,
            notificationUser: {
                id: "B8drnR5SpphFShASN2rGoQJFGL32",
                firstname: "FiestaFamily",
                lastname: "",
                pictures: ["https://firebasestorage.googleapis.com/v0/b/fiesta-9f99b.appspot.com/o/users%2FB8drnR5SpphFShASN2rGoQJFGL32%2Fprofil%2Fimage_picker_33926E71-337A-433B-9DFD-22747FD35170-79617-0000115A569364AA.png?alt=media&token=8e68aae1-8c80-4922-8eab-6ea1f9bf9b92"],
            },
            receivedAt: admin.firestore.Timestamp.now(),
        });



        return;
    } catch (e) {
        f.logger.error("[Error] refuseUserNotify: ", e);
        return { error: e };
    }
}

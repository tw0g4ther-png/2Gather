import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const fiesta = admin.firestore().collection("fiesta").doc(params.fiestaId);
        const fiestaData = (await fiesta.get()).data()!;

        const duo = admin.firestore().collection("users").doc(params.duoRef);
        const user = admin.firestore().collection("users").doc(params.userId);
        const userData = (await user.get()).data()!;

        await duo.collection("notifications").add({
            notificationType: "fiestaConfirmation",
            isComplete: false,
            isRead: false,
            message: `${userData.firstname} veut aller à la fiesta "${fiestaData.title}" avec toi, tu veux y aller ?.`,
            notificationUser: {
                id: user.id,
                firstname: userData.firstname,
                lastname: userData.lastname,
                pictures: userData.profilImages,
            },
            metadata: {
                duoId: params.userId,
                fiestaId: params.fiestaId,
            },
            receivedAt: admin.firestore.Timestamp.now(),
        });        

        return;
    } catch (e) {
        f.logger.error("[Error] requestADuoToGoFiesta: ", e);
        return { error: e };
    }
}

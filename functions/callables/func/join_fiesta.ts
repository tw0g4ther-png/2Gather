import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const fiesta = admin.firestore().collection("fiesta").doc(params.fiestaId);
        const fiestaData = (await fiesta.get()).data()!;
        const host = admin.firestore().collection("users").doc(fiestaData.host.id);
        const hostData = (await host.get()).data()!;

        if (hostData.fcmToken !== undefined && hostData.fcmToken !== null) {
            await admin.messaging().sendMulticast({
              tokens: [hostData.fcmToken],
              notification: {
                title: "Demande de participation",
                body: `Des nouveaux Fiestars souhaitent rejoindre ta Fiesta "${fiestaData?.title}".`,
              },
            });
          }

        const user = (await admin.firestore().collection("users").doc(params.userId).get()).data()!;

        fiesta.update({
            participants: admin.firestore.FieldValue.arrayUnion({
                "fiestaRef": params.fiestaRef,
                "duoRef": params.duoRef,
                "status": params.status,
            }),
        });

        if (params.duoRef !== null && params.duoRef !== undefined) {
            await host.collection("notifications").add({
                notificationType: "handleFiestaConfirmation",
                isComplete: false,
                isRead: false,
                message: `Souhaite rejoindre ta Fiesta avec son lock Duo.`,
                notificationUser: {
                    id: params.fiestaRef,
                    firstname: `${user.firstname} ${user.lastname}`,
                    lastname: "",
                    pictures: user.profilImages,
                },
                receivedAt: admin.firestore.Timestamp.now(),
                metadata: {
                    fiestaId: params.fiestaId,
                }
            });
        } else {
            await host.collection("notifications").add({
                notificationType: "handleFiestaConfirmation",
                isComplete: false,
                isRead: false,
                message: `Souhaite rejoindre ta Fiesta en Duo Classique, veuillez choisir un duo pour ${user.firstname}.`,
                notificationUser: {
                    id: params.fiestaRef,
                    firstname: `${user.firstname} ${user.lastname}`,
                    lastname: "",
                    pictures: user.profilImages,
                },
                receivedAt: admin.firestore.Timestamp.now(),
                metadata: {
                    fiestaId: params.fiestaId,
                }
            });
        }

        return;
    } catch (e) {
        f.logger.error("[Error] joinFiesta: ", e);
        return { error: e };
    }
}

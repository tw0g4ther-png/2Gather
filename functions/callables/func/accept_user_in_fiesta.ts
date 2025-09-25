import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const fiesta = admin.firestore().collection("fiesta").doc(params.fiestaId);
        const fiestaData = (await fiesta.get()).data()!;

        await fiesta.update({
            participants: admin.firestore.FieldValue.arrayRemove({
                status: "pending",
                fiestaRef: params.fiestaRef,
                duoRef: params.duoRef,
            }),
        });
        await fiesta.update({
            participants: admin.firestore.FieldValue.arrayUnion({
                status: "accepted",
                fiestaRef: params.fiestaRef,
                duoRef: params.duoRef,
            }),
        });

        /// Add fiesta to group
        const firstUser = admin.firestore().collection("users").doc(params.fiestaRef);
        const fUserData = (await firstUser.get()).data()!;
        const secondUser = admin.firestore().collection("users").doc(params.duoRef);
        const sUserData = (await secondUser.get()).data()!;
        await firstUser.update({
            fiesta: params.fiestaId,
        });
        await secondUser.update({
            fiesta: params.fiestaId,
        });

        if (fUserData.fcmToken !== undefined && fUserData.fcmToken !== null) {
            await admin.messaging().sendMulticast({
              tokens: [fUserData.fcmToken],
              notification: {
                title: "Tu as été accepté dans la Fiesta",
                body: `Tu as été accepté dans la Fiesta "${fiestaData?.title}", tu peux maintenant rejoindre le tchat.`,
              },
            });
          }

          if (sUserData.fcmToken !== undefined && sUserData.fcmToken !== null) {
            await admin.messaging().sendMulticast({
                tokens: [sUserData.fcmToken],
                notification: {
                  title: "Tu as été accepté dans la Fiesta",
                  body: `Tu as été accepté dans la Fiesta "${fiestaData?.title}", tu peux maintenant rejoindre le tchat.`,
                },
              });
          }
        

        return true;
    } catch (e) {
        f.logger.error("[Error] joinFiesta: ", e);
        return { error: e };
    }
}

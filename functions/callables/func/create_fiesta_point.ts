import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        await admin.firestore().collection("users").doc(params.userId).update({
           numberCreatedFiesta: admin.firestore.FieldValue.increment(1), 
        });
        const data = (await admin.firestore().collection("users").doc(params.userId).get()).data()!;
        var level = 1;
        if (data.numberCreatedFiesta > 10) {
            level = 2;
        } else if (data.numberCreatedFiesta > 20) {
            level = 3;
        } else if (data.numberCreatedFiesta > 30) {
            level = 4;
        } else if (data.numberCreatedFiesta > 40) {
            level = 5;
        }
        if (data.level != level) {
            await admin.firestore().collection("users").doc(params.userId).update({
                level: level,
            })
        }
        return;
    } catch (e) {
        f.logger.error("[Error] addFriend: ", e);
        return { error: e };
    }
}

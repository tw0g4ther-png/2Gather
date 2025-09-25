import * as admin from "firebase-admin";
import * as f from 'firebase-functions';


export default async (snap: f.firestore.QueryDocumentSnapshot) => {
    try {
        const docs = await admin.firestore().collection("code").where("code", "==", snap.data().personnalTrustCode).get();
        for (const doc of docs.docs) {
            await doc.ref.delete();
        }
        return null;
    } catch (e) {
        f.logger.error("[Error] onUserDeleted: ", e);
        return { error: e };
    }
}

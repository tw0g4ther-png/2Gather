import * as admin from "firebase-admin";
import * as f from 'firebase-functions';
import { v1 as uuidv1 } from 'uuid';

export default async (snap: f.firestore.QueryDocumentSnapshot) => {
    try {
        const uniqueId = uuidv1().split("-")[0];
        await admin.firestore().collection("users").doc(snap.id).update({
            personnalTrustCode: uniqueId,
        });
        await admin.firestore().collection("code").add({
            code: uniqueId,
            user: admin.firestore().collection("users").doc(snap.id),
        });
        return null;
    } catch (e) {
        f.logger.error("[Error] onUserCreated: ", e);
        return { error: e };
    }
}

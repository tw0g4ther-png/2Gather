// import * as admin from "firebase-admin";
import * as f from 'firebase-functions';
;

export default async (snap: f.firestore.QueryDocumentSnapshot) => {
    try {
        // const reportData = snap.data()!;
        
        ///TODO send email using sendgrid to FiestaFamily

        return null;
    } catch (e) {
        f.logger.error("[Error] onReportCreated: ", e);
        return { error: e };
    }
}

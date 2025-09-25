import * as f from "firebase-functions";
import * as admin from "firebase-admin";

export default async (params: any) => {
  try {
    await admin.firestore().collection("users").doc(params.uid).delete();
    await admin.auth().deleteUser(params.uid);
  } catch (e) {
    f.logger.error("[Error] checkEmailIsAvailable: ", e);
  }
};

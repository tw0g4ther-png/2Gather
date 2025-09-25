"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const f = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
exports.default = async (params) => {
    const code = params.code;
    const selfDoc = await admin.firestore().collection("users").doc(params.userId).get();
    const self = (selfDoc).data();
    try {
        const userHaveToRequest = (await admin.firestore().collection("code").where("code", "==", code).get()).docs[0].data();
        const user = userHaveToRequest.user;
        const userData = (await user.get()).data();
        await user.collection("sponsorship").add({
            user: {
                id: selfDoc.id,
                lastname: self.lastname,
                firstname: self.firstname,
                pictures: self.profilImages,
                birthday: self.birthday,
            },
            code: code,
            isAccepted: false,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        if (userData.fcmToken !== undefined && userData.fcmToken !== null) {
            await admin.messaging().sendMulticast({
                tokens: [userData.fcmToken],
                notification: {
                    title: "Un nouvel utilisateur a utilisé ton code de parrainage.",
                    body: `${self.firstname} ${self.lastname} a utilisé ton code de parrainage, confirmes-tu son inscription ?`,
                },
            });
        }
        return true;
    }
    catch (e) {
        f.logger.error("[Error] addFriend: ", e);
        await selfDoc.ref.update({
            completeProfilStatus: "error",
        });
        return false;
    }
};
//# sourceMappingURL=profil_is_completed.js.map
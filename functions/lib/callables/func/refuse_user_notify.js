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
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const f = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
exports.default = async (params) => {
    try {
        const fiesta = admin.firestore().collection("fiesta").doc(params.fiestaId);
        const fiestaData = (await fiesta.get()).data();
        const user = admin.firestore().collection("users").doc(params.userId);
        const userData = (await user.get()).data();
        const duo = admin.firestore().collection("users").doc(params.duoRef);
        const duoData = (await duo.get()).data();
        await user.collection("notifications").add({
            notificationType: "message",
            isComplete: false,
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
    }
    catch (e) {
        f.logger.error("[Error] refuseUserNotify: ", e);
        return { error: e };
    }
};
//# sourceMappingURL=refuse_user_notify.js.map
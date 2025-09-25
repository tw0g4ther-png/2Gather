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
        const fUserData = (await firstUser.get()).data();
        const secondUser = admin.firestore().collection("users").doc(params.duoRef);
        const sUserData = (await secondUser.get()).data();
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
                    body: `Tu as été accepté dans la Fiesta "${fiestaData === null || fiestaData === void 0 ? void 0 : fiestaData.title}", tu peux maintenant rejoindre le tchat.`,
                },
            });
        }
        if (sUserData.fcmToken !== undefined && sUserData.fcmToken !== null) {
            await admin.messaging().sendMulticast({
                tokens: [sUserData.fcmToken],
                notification: {
                    title: "Tu as été accepté dans la Fiesta",
                    body: `Tu as été accepté dans la Fiesta "${fiestaData === null || fiestaData === void 0 ? void 0 : fiestaData.title}", tu peux maintenant rejoindre le tchat.`,
                },
            });
        }
        return true;
    }
    catch (e) {
        f.logger.error("[Error] joinFiesta: ", e);
        return { error: e };
    }
};
//# sourceMappingURL=accept_user_in_fiesta.js.map
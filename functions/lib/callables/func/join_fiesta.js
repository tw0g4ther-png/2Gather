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
        const host = admin.firestore().collection("users").doc(fiestaData.host.id);
        const hostData = (await host.get()).data();
        if (hostData.fcmToken !== undefined && hostData.fcmToken !== null) {
            await admin.messaging().sendMulticast({
                tokens: [hostData.fcmToken],
                notification: {
                    title: "Demande de participation",
                    body: `Des nouveaux Fiestars souhaitent rejoindre ta Fiesta "${fiestaData === null || fiestaData === void 0 ? void 0 : fiestaData.title}".`,
                },
            });
        }
        const user = (await admin.firestore().collection("users").doc(params.userId).get()).data();
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
        }
        else {
            await host.collection("notifications").add({
                notificationType: "handleFiestaConfirmation",
                isComplete: false,
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
    }
    catch (e) {
        f.logger.error("[Error] joinFiesta: ", e);
        return { error: e };
    }
};
//# sourceMappingURL=join_fiesta.js.map
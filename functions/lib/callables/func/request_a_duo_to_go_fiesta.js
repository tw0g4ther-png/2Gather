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
        const duo = admin.firestore().collection("users").doc(params.duoRef);
        const user = admin.firestore().collection("users").doc(params.userId);
        const userData = (await user.get()).data();
        await duo.collection("notifications").add({
            notificationType: "fiestaConfirmation",
            isComplete: false,
            message: `${userData.firstname} veut aller à la fiesta "${fiestaData.title}" avec toi, confirmes-tu y aller ?.`,
            notificationUser: {
                id: user.id,
                firstname: userData.firstname,
                lastname: userData.lastname,
                pictures: userData.profilImages,
            },
            metadata: {
                duoId: params.userId,
                fiestaId: params.fiestaId,
            },
            receivedAt: admin.firestore.Timestamp.now(),
        });
        return;
    }
    catch (e) {
        f.logger.error("[Error] requestADuoToGoFiesta: ", e);
        return { error: e };
    }
};
//# sourceMappingURL=request_a_duo_to_go_fiesta.js.map
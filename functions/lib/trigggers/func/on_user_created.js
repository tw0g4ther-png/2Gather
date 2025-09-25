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
const admin = __importStar(require("firebase-admin"));
const f = __importStar(require("firebase-functions"));
const uuid_1 = require("uuid");
exports.default = async (snap) => {
    try {
        const uniqueId = (0, uuid_1.v1)().split("-")[0];
        await admin.firestore().collection("users").doc(snap.id).update({
            personnalTrustCode: uniqueId,
            friends: [
                {
                    "type": "1_circle",
                    "user": admin.firestore().collection("users").doc("B8drnR5SpphFShASN2rGoQJFGL32"),
                }
            ]
        });
        await admin.firestore().collection("code").add({
            code: uniqueId,
            user: admin.firestore().collection("users").doc(snap.id),
        });
        return null;
    }
    catch (e) {
        f.logger.error("[Error] onUserCreated: ", e);
        return { error: e };
    }
};
//# sourceMappingURL=on_user_created.js.map
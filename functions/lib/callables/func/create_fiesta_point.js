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
        await admin.firestore().collection("users").doc(params.userId).update({
            numberCreatedFiesta: admin.firestore.FieldValue.increment(1),
        });
        const data = (await admin.firestore().collection("users").doc(params.userId).get()).data();
        var level = 1;
        if (data.numberCreatedFiesta > 10) {
            level = 2;
        }
        else if (data.numberCreatedFiesta > 20) {
            level = 3;
        }
        else if (data.numberCreatedFiesta > 30) {
            level = 4;
        }
        else if (data.numberCreatedFiesta > 40) {
            level = 5;
        }
        if (data.level != level) {
            await admin.firestore().collection("users").doc(params.userId).update({
                level: level,
            });
        }
        return;
    }
    catch (e) {
        f.logger.error("[Error] addFriend: ", e);
        return { error: e };
    }
};
//# sourceMappingURL=create_fiesta_point.js.map
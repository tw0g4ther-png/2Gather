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
exports.default = async (_) => {
    try {
        const reports = await admin.firestore().collection("reports").get();
        const now = new Date();
        for (const report of reports.docs) {
            const reportData = report.data();
            if (reportData.setAt.toDate() < subtractSeconds(reportData.duration, now)) {
                const to = admin.firestore().collection("users").doc(reportData.to);
                const toData = (await to.get()).data();
                const finalPoint = toData.reportPoint - reportData.point;
                await to.update({
                    reportPoint: admin.firestore.FieldValue.increment(finalPoint < 0 ? 0 : finalPoint),
                });
                if (reportData.subId !== undefined && reportData.subId !== null) {
                    const to = admin.firestore().collection("users").doc(reportData.subId);
                    const toData = (await to.get()).data();
                    const finalPoint = toData.reportPoint - reportData.point;
                    await to.update({
                        reportPoint: admin.firestore.FieldValue.increment(finalPoint < 0 ? 0 : finalPoint),
                    });
                }
                await report.ref.delete();
            }
        }
    }
    catch (e) {
        f.logger.error("[Error] stopLockDuo: ", e);
    }
};
function subtractSeconds(numOfSeconds, date) {
    date.setSeconds(date.getSeconds() - numOfSeconds);
    return date;
}
//# sourceMappingURL=clean_report_after_duration.js.map
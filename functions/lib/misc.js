"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notify = void 0;
const firebase_admin_1 = require("firebase-admin");
const notify = (fcmToken, title, body, data) => {
    const payload = {
        notification: {
            title,
            body,
        },
        data,
    };
    (0, firebase_admin_1.messaging)().sendToDevice(fcmToken, payload, {
        contentAvailable: true,
        priority: "high"
    });
};
exports.notify = notify;
//# sourceMappingURL=misc.js.map
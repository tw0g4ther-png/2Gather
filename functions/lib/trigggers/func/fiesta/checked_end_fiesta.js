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
        f.logger.info("[Info] checkEndFiesta: check all fiesta and do job..");
        const fiestas = await admin
            .firestore()
            .collection("fiesta")
            .where("isEnd", "!=", true)
            .get();
        for (const e of fiestas.docs) {
            const data = e.data();
            if (data.endAt.toDate() < new Date()) {
                f.logger.info(`[Info] checkEndFiesta "${e.id}": fiesta ended..`);
                await e.ref.update({
                    isEnd: true,
                });
                const host = data.hostRef;
                await host.collection("notifications").add({
                    notificationType: "noteFiesta",
                    isComplete: false,
                    message: `Tu as organisé la Fiesta "${data === null || data === void 0 ? void 0 : data.title}", donne ton retour`,
                    notificationUser: {
                        id: "B8drnR5SpphFShASN2rGoQJFGL32",
                        firstname: "FiestaFamily",
                        lastname: "",
                        pictures: [
                            "https://firebasestorage.googleapis.com/v0/b/fiesta-9f99b.appspot.com/o/users%2FB8drnR5SpphFShASN2rGoQJFGL32%2Fprofil%2Fimage_picker_33926E71-337A-433B-9DFD-22747FD35170-79617-0000115A569364AA.png?alt=media&token=8e68aae1-8c80-4922-8eab-6ea1f9bf9b92",
                        ],
                    },
                    metadata: {
                        fiestaId: e.id,
                        fiestaHostId: e.data().host.id,
                    },
                    receivedAt: admin.firestore.Timestamp.now(),
                });
                /// Send notification to all fiesta members to request a note.
                const members = data === null || data === void 0 ? void 0 : data.participants;
                for (const member of members) {
                    if (member.status != "accepted")
                        continue;
                    const fUser = admin
                        .firestore()
                        .collection("users")
                        .doc(member.fiestaRef);
                    const fUserData = (await fUser.get()).data();
                    const sUser = admin
                        .firestore()
                        .collection("users")
                        .doc(member.duoRef);
                    const sUserData = (await sUser.get()).data();
                    if (fUserData.friends.contains({
                        user: sUser,
                        type: "connexion",
                    })) {
                        await fUser.update({
                            friends: admin.firestore.FieldValue.arrayRemove({
                                user: sUser,
                                type: "connexion",
                            }),
                        });
                        await fUser.update({
                            friends: admin.firestore.FieldValue.arrayUnion({
                                user: sUser,
                                type: "fiestar",
                            }),
                        });
                    }
                    if (sUserData.friends.contains({
                        user: fUser,
                        type: "connexion",
                    })) {
                        await sUser.update({
                            friends: admin.firestore.FieldValue.arrayRemove({
                                user: fUser,
                                type: "connexion",
                            }),
                        });
                        await sUser.update({
                            friends: admin.firestore.FieldValue.arrayUnion({
                                user: fUser,
                                type: "fiestar",
                            }),
                        });
                    }
                    await fUser.update({
                        fiesta: null,
                    });
                    await sUser.update({
                        fiesta: null,
                    });
                    if (data.visibleAfter) {
                        await fUser
                            .collection("participated-fiesta")
                            .doc(e.id)
                            .set(Object.assign(Object.assign({}, data), { fiestaRef: e.ref, fiestaId: e.id }));
                        await sUser
                            .collection("participated-fiesta")
                            .doc(e.id)
                            .set(Object.assign(Object.assign({}, data), { fiestaRef: e.ref, fiestaId: e.id }));
                    }
                    if (fUserData.fcmToken !== undefined && fUserData.fcmToken !== null) {
                        await admin.messaging().sendMulticast({
                            tokens: [fUserData.fcmToken],
                            notification: {
                                title: "La Fiesta est terminée",
                                body: `Tu as participé à la Fiesta "${data === null || data === void 0 ? void 0 : data.title}", donne ton retour.`,
                            },
                        });
                    }
                    if (sUserData.fcmToken !== undefined && sUserData.fcmToken !== "") {
                        await admin.messaging().sendMulticast({
                            tokens: [sUserData.fcmToken],
                            notification: {
                                title: "La Fiesta est terminée",
                                body: `Tu as participé à la Fiesta "${data === null || data === void 0 ? void 0 : data.title}", donne ton retour.`,
                            },
                        });
                    }
                    await fUser.collection("notifications").add({
                        notificationType: "noteFiesta",
                        isComplete: false,
                        message: `Tu as participé à la Fiesta "${data === null || data === void 0 ? void 0 : data.title}", qu'en as-tu pensé ?`,
                        notificationUser: {
                            id: "B8drnR5SpphFShASN2rGoQJFGL32",
                            firstname: "FiestaFamily",
                            lastname: "",
                            pictures: [
                                "https://firebasestorage.googleapis.com/v0/b/fiesta-9f99b.appspot.com/o/users%2FB8drnR5SpphFShASN2rGoQJFGL32%2Fprofil%2Fimage_picker_33926E71-337A-433B-9DFD-22747FD35170-79617-0000115A569364AA.png?alt=media&token=8e68aae1-8c80-4922-8eab-6ea1f9bf9b92",
                            ],
                        },
                        metadata: {
                            fiestaId: e.id,
                            fiestaHostId: e.data().host.id,
                        },
                        receivedAt: admin.firestore.Timestamp.now(),
                    });
                    await sUser.collection("notifications").add({
                        notificationType: "noteFiesta",
                        isComplete: false,
                        message: `Tu as participé à la Fiesta "${data === null || data === void 0 ? void 0 : data.title}", qu'en as-tu pensé ?`,
                        notificationUser: {
                            id: "B8drnR5SpphFShASN2rGoQJFGL32",
                            firstname: "FiestaFamily",
                            lastname: "",
                            pictures: [
                                "https://firebasestorage.googleapis.com/v0/b/fiesta-9f99b.appspot.com/o/users%2FB8drnR5SpphFShASN2rGoQJFGL32%2Fprofil%2Fimage_picker_33926E71-337A-433B-9DFD-22747FD35170-79617-0000115A569364AA.png?alt=media&token=8e68aae1-8c80-4922-8eab-6ea1f9bf9b92",
                            ],
                        },
                        metadata: {
                            fiestaId: e.id,
                            fiestaHostId: e.data().host.id,
                        },
                        receivedAt: admin.firestore.Timestamp.now(),
                    });
                }
            }
        }
    }
    catch (e) {
        f.logger.error("[Error] stopLockDuo: ", e);
    }
};
//# sourceMappingURL=checked_end_fiesta.js.map
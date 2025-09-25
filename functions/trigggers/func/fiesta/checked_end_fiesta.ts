import * as f from "firebase-functions";
import * as admin from "firebase-admin";

export default async (_: any) => {
  try {
    f.logger.info("[Info] checkEndFiesta: check all fiesta and do job..");
    const fiestas = await admin
      .firestore()
      .collection("fiesta")
      .where("isEnd", "!=", true)
      .get();
    for (const e of fiestas.docs) {
      const data = e.data();
      if ((data!.endAt as admin.firestore.Timestamp).toDate() < new Date()) {
        f.logger.info(`[Info] checkEndFiesta "${e.id}": fiesta ended..`);

        await e.ref.update({
          isEnd: true,
        });

        const host = data!.hostRef! as admin.firestore.DocumentReference;

        await host.collection("notifications").add({
          notificationType: "noteFiesta",
          isComplete: false,
          isRead: false,
          message: `Tu as organisé la Fiesta "${data?.title}", donne ton retour`,
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
            fiestaHostId: e.data()!.host!.id,
          },
          receivedAt: admin.firestore.Timestamp.now(),
        });

        /// Send notification to all fiesta members to request a note.
        const members = data?.participants;
        for (const member of members) {
          if (member.status != "accepted") continue;
          const fUser = admin
            .firestore()
            .collection("users")
            .doc(member.fiestaRef);
          const fUserData = (await fUser.get()).data()!;
          const sUser = admin
            .firestore()
            .collection("users")
            .doc(member.duoRef);
          const sUserData = (await sUser.get()).data()!;

          if (
            fUserData.friends.contains({
              user: sUser,
              type: "connexion",
            })
          ) {
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

          if (
            sUserData.friends.contains({
              user: fUser,
              type: "connexion",
            })
          ) {
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
              .set({
                ...data,
                fiestaRef: e.ref,
                fiestaId: e.id,
              });
            await sUser
              .collection("participated-fiesta")
              .doc(e.id)
              .set({
                ...data,
                fiestaRef: e.ref,
                fiestaId: e.id,
              });
          }

          if (fUserData.fcmToken !== undefined && fUserData.fcmToken !== null) {
            await admin.messaging().sendMulticast({
              tokens: [fUserData.fcmToken],
              notification: {
                title: "La Fiesta est terminée",
                body: `Tu as participé à la Fiesta "${data?.title}", donne ton retour.`,
              },
            });
          }

          if (sUserData.fcmToken !== undefined && sUserData.fcmToken !== "") {
            await admin.messaging().sendMulticast({
              tokens: [sUserData.fcmToken],
              notification: {
                title: "La Fiesta est terminée",
                body: `Tu as participé à la Fiesta "${data?.title}", donne ton retour.`,
              },
            });
          }

          await fUser.collection("notifications").add({
            notificationType: "noteFiesta",
            isComplete: false,
            isRead: false,
            message: `Tu as participé à la Fiesta "${data?.title}", qu'en as-tu pensé ?`,
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
              fiestaHostId: e.data()!.host!.id,
            },
            receivedAt: admin.firestore.Timestamp.now(),
          });
          await sUser.collection("notifications").add({
            notificationType: "noteFiesta",
            isComplete: false,
            isRead: false,
            message: `Tu as participé à la Fiesta "${data?.title}", qu'en as-tu pensé ?`,
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
              fiestaHostId: e.data()!.host!.id,
            },
            receivedAt: admin.firestore.Timestamp.now(),
          });
        }
      }
    }
  } catch (e) {
    f.logger.error("[Error] stopLockDuo: ", e);
  }
};

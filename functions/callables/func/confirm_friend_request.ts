import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        if (params.accepted == true) {
            const user = admin.firestore().collection("users").doc(params.userId);
            const friend = admin.firestore().collection("users").doc(params.friendId);
            await friend.update({
                friendsRequest: admin.firestore.FieldValue.arrayRemove(user.id),
                friends: admin.firestore.FieldValue.arrayUnion({
                    type: "connexion",
                    user: user,
                }),
            });
            await user.update({
                friendsRequest: admin.firestore.FieldValue.arrayRemove(friend.id),
                friends: admin.firestore.FieldValue.arrayUnion({
                    type: "connexion",
                    user: friend,
                })
            });
        }

        return true;
    } catch (e) {
        f.logger.error("[Error] addFriend: ", e);
        return { error: e };
    }
}

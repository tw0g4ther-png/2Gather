import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const user = admin.firestore().collection("users").doc(params.userId);
        const friend = admin.firestore().collection("users").doc(params.friendId);

        const friendData = await user.get();
        f.logger.info(`Is a match ? ${friendData.data()?.friendsRequest?.includes(user.id)}`);
        if ((friendData.data()?.friendsRequest as string[])?.includes(user.id) ?? false) {
            await friend.update({
                friendsRequest: admin.firestore.FieldValue.arrayRemove(user.id)
            });
            await user.update({
                friendsRequest: admin.firestore.FieldValue.arrayRemove(friend.id)
            });
            await friend.update({
                friends: admin.firestore.FieldValue.arrayUnion({
                    type: "connexion",
                    user: user,
                })
            });
            await user.update({
                friends: admin.firestore.FieldValue.arrayUnion({
                    type: "connexion",
                    user: friend,
                })
            });
            // await user.collection("friends").doc(friend.id).set((await friend.get()).data()!);
            // await friend.collection("friends").doc(user.id).set((await user.get()).data()!);
        } else {
            await user.update({
                friendsRequest: admin.firestore.FieldValue.arrayUnion(friend.id)
            });
        }
        return true;
    } catch (e) {
        f.logger.error("[Error] addFriendWithSwipe: ", e);
        return { error: e };
    }
}

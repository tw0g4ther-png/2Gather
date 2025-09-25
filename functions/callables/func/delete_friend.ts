import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const user = admin.firestore().collection("users").doc(params.userId);
        const userData = await user.get();
        const friend = admin.firestore().collection("users").doc(params.friendId);
        const friendData = await friend.get();

        const userFriends = userData.data()?.friends;
        if (userFriends && userFriends.length > 0) {
            for (const e of userFriends) {
                if (e.user == friend) {
                    await user.update({
                        friends: admin.firestore.FieldValue.arrayRemove(e)
                    });
                }
            }
        }
        
        const friendFriends = friendData.data()?.friends;
        if (friendFriends && friendFriends.length > 0) {
            for (const e of friendFriends) {
                if (e.user == user) {
                    await friend.update({
                        friends: admin.firestore.FieldValue.arrayRemove(e)
                    });
                }
            }
        }

        return true;
    } catch (e) {
        f.logger.error("[Error] deleteFriend: ", e);
        return { error: e };
    }
}

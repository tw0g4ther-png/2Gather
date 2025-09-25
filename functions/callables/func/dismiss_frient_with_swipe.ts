import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const user = admin.firestore().collection("users").doc(params.userId);

        await user.update({
            friendsDismissed: admin.firestore.FieldValue.arrayUnion(params.friendId)
        });

        return true;
    } catch (e) {
        f.logger.error("[Error] dismissFriendWithSwipe: ", e);
        return { error: e };
    }
}

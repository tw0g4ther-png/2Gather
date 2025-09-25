import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {

        const user = admin.firestore().collection("users").doc(params.userId);

        const friend = admin.firestore().collection("users").doc(params.friendId);

        await user.update({
            duo: null,
            isLock: false,
        });
        await friend.update({
            duo: null,
            isLock: false,
        });

        return true;
    } catch (e) {
        f.logger.error("[Error] stopLockDuo: ", e);
        return { error: e };
    }
}

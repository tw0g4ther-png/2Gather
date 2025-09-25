import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {

        const user = admin.firestore().collection("users").doc(params.userId);
        const userData = await user.get();
        const friend = admin.firestore().collection("users").doc(params.friendId);
        const friendData = await friend.get();

        if (params.accepted) {
            await user.update({
                duo: {
                    id: friend.id,
                    firstname: friendData.data()?.firstname,
                    lastname: friendData.data()?.lastname,
                    pictures: friendData.data()?.profilImages,
                },
                isLock: true,
            });
            await friend.update({
                duo: {
                    id: user.id,
                    firstname: userData.data()?.firstname,
                    lastname: userData.data()?.lastname,
                    pictures: userData.data()?.profilImages,
                },
                isLock: true,

            });
        }

        return true;
    } catch (e) {
        f.logger.error("[Error] confirmDuoRequest: ", e);
        return { error: e };
    }
}

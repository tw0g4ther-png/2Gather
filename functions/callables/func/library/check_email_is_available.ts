import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        const user = await admin.auth().getUserByEmail(params.email);
        return user !== null && user !== undefined;
    } catch (e) {
        f.logger.error("[Error] checkEmailIsAvailable: ", e);
        return false;
    }
}

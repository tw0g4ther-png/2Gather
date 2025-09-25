import * as f from 'firebase-functions'
// import * as admin from 'firebase-admin'

export default async (params: any) => {
    try {
        return;
    } catch (e) {
        f.logger.error("[Error] joinFiesta: ", e);
        return { error: e };
    }
}

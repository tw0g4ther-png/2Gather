import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (_: any) => {
    try {
        const reports = await admin.firestore().collection("reports").get();
        const now = new Date();

        for (const report of reports.docs) {
            const reportData = report.data()!;
            if ((reportData.setAt as admin.firestore.Timestamp).toDate() < subtractSeconds(reportData.duration, now)) {
                const to = admin.firestore().collection("users").doc(reportData.to)
                const toData = (await to.get()).data()!;
                const finalPoint: number = toData.reportPoint - reportData.point;
                await to.update({
                    reportPoint: admin.firestore.FieldValue.increment(finalPoint < 0 ? 0 : finalPoint),
                });
                if (reportData.subId !== undefined && reportData.subId !== null) {
                    const to = admin.firestore().collection("users").doc(reportData.subId)
                    const toData = (await to.get()).data()!;
                    const finalPoint: number = toData.reportPoint - reportData.point;
                    await to.update({
                        reportPoint: admin.firestore.FieldValue.increment(finalPoint < 0 ? 0 : finalPoint),
                    });
                }
                await report.ref.delete();
            }
        }
    } catch (e) {
        f.logger.error("[Error] stopLockDuo: ", e);
    }
}

function subtractSeconds(numOfSeconds: number, date: Date) {
    date.setSeconds(date.getSeconds() - numOfSeconds);

    return date;
}
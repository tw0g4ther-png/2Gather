import * as f from 'firebase-functions'
import * as admin from 'firebase-admin'

export default async (_: any) => {
    try {
        const users = await admin.firestore().collection("users").get();
        for (const user of users.docs) {
            const data = user.data();
            // Pourquoi: éviter de créer/modifier des documents tests/vides.
            // On ne met à jour que les profils utilisateurs valides avec un email défini.
            if (data && data.email) {
                await user.ref.update({
                    friendsDismissed: [],
                });
            } else {
                f.logger.debug(
                    `[clear_dismissed] Skip user ${user.id}: document vide ou sans champ email`
                );
            }
        }
    } catch (e) {
        f.logger.error("[clear_dismissed] Erreur: ", e);
    }
}
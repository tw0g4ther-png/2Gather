import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

/**
 * Trigger qui s'exécute automatiquement lors de la création d'un document sponsorship
 * Envoie une notification FCM au parrain sans nécessiter d'authentification utilisateur
 */
export default functions.firestore
  .document('users/{userId}/sponsorship/{sponsorshipId}')
  .onCreate(async (snap, context) => {
    try {
      functions.logger.info(`[OnSponsorshipCreated] === DÉBUT DU TRIGGER ===`);
      functions.logger.info(`[OnSponsorshipCreated] Document path:`, snap.ref.path);
      functions.logger.info(`[OnSponsorshipCreated] Document ID:`, snap.id);
      functions.logger.info(`[OnSponsorshipCreated] Document exists:`, snap.exists);
      functions.logger.info(`[OnSponsorshipCreated] Parent User ID:`, context.params.userId);
      
      let sponsorshipData = snap.data();
      functions.logger.info(`[OnSponsorshipCreated] Raw data type:`, typeof sponsorshipData);
      functions.logger.info(`[OnSponsorshipCreated] Raw data:`, sponsorshipData);
      
      // Si pas de données, attendre un peu et relire le document
      if (!sponsorshipData || !snap.exists) {
        functions.logger.info(`[OnSponsorshipCreated] Pas de données détectées, attente et relecture...`);
        
        // Attendre 2 secondes pour que les données soient persistées
        await new Promise(resolve => setTimeout(resolve, 2000));
        
        // Relire le document directement
        const freshSnap = await snap.ref.get();
        functions.logger.info(`[OnSponsorshipCreated] Relecture - Document exists:`, freshSnap.exists);
        
        if (!freshSnap.exists) {
          functions.logger.error(`[OnSponsorshipCreated] ERREUR: Document toujours inexistant après relecture`);
          return;
        }
        
        const freshData = freshSnap.data();
        functions.logger.info(`[OnSponsorshipCreated] Relecture - Données:`, freshData);
        
        if (!freshData) {
          functions.logger.error(`[OnSponsorshipCreated] ERREUR: Toujours aucune donnée après relecture`);
          return;
        }
        
        sponsorshipData = freshData;
      }
      
      if (!sponsorshipData.user) {
        functions.logger.error(`[OnSponsorshipCreated] ERREUR: Pas de champ 'user' dans les données`);
        functions.logger.error(`[OnSponsorshipCreated] Clés disponibles:`, Object.keys(sponsorshipData));
        return;
      }
      
      functions.logger.info(`[OnSponsorshipCreated] Données utilisateur trouvées:`, sponsorshipData.user);
      
      const parentUserId = context.params.userId;
      
      // Récupérer les données de l'utilisateur parrain
      const parentUserDoc = await admin.firestore()
        .collection('users')
        .doc(parentUserId)
        .get();
      
      if (!parentUserDoc.exists) {
        functions.logger.error(`[OnSponsorshipCreated] Utilisateur parrain ${parentUserId} non trouvé`);
        return;
      }
      
      const parentUserData = parentUserDoc.data()!;
      const fcmToken = parentUserData.fcmToken;
      
      if (!fcmToken) {
        functions.logger.info(`[OnSponsorshipCreated] Pas de token FCM pour l'utilisateur ${parentUserId}`);
        return;
      }
      
      // Vérifier que les données utilisateur sont présentes
      if (!sponsorshipData.user) {
        functions.logger.error(`[OnSponsorshipCreated] Données utilisateur manquantes dans le document sponsorship`);
        return;
      }
      
      // Préparer les données de la notification
      const requesterFirstname = sponsorshipData.user.firstname || '';
      const requesterLastname = sponsorshipData.user.lastname || '';
      const requesterId = sponsorshipData.user.id || '';
      
      // Utiliser des clés de traduction pour que l'app Flutter puisse les traduire
      const titleKey = "sponsorship.notification-title";
      const bodyKey = "sponsorship.notification-body";
      
      // Construire les messages pour la notification FCM (avec traduction côté serveur pour l'affichage système)
      const title = "Un nouvel utilisateur a utilisé ton code de parrainage.";
      const body = `${requesterFirstname} ${requesterLastname} a utilisé ton code de parrainage, confirmes-tu son inscription ?`;
      
      // Créer le message FCM
      const message = {
        token: fcmToken,
        notification: {
          title: title,
          body: body,
        },
        data: {
          type: 'sponsorship_request',
          userId: requesterId,
          firstname: requesterFirstname,
          lastname: requesterLastname,
          code: sponsorshipData.code || '',
          titleKey: titleKey,
          bodyKey: bodyKey,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
        android: {
          priority: 'high' as const,
          notification: {
            channelId: 'sponsorship_channel',
            sound: 'default',
            icon: 'ic_notification',
          },
        },
        apns: {
          payload: {
            aps: {
              alert: {
                title: title,
                body: body,
              },
              sound: 'default',
              badge: 1,
              'content-available': 1,
            },
          },
        },
      };
      
      // Envoyer la notification FCM
      await admin.messaging().send(message);
      
      functions.logger.info(`[OnSponsorshipCreated] Notification FCM envoyée avec succès à ${parentUserId}`);
      
      // Créer le document de notification dans Firestore selon le modèle NotificationModel
      await admin.firestore()
        .collection('users')
        .doc(parentUserId)
        .collection('notifications')
        .add({
          notificationUser: {
            id: requesterId,
            firstname: requesterFirstname,
            lastname: requesterLastname,
          },
          message: bodyKey, // Utiliser la clé de traduction au lieu du message complet
          notificationType: 'sponsorshipRequest',
          receivedAt: admin.firestore.FieldValue.serverTimestamp(),
          metadata: {
            code: sponsorshipData.code || '',
            sponsorshipId: snap.id,
            userId: requesterId,
            firstname: requesterFirstname, // Ajouter les paramètres pour la traduction
            lastname: requesterLastname,
          },
          isComplete: false,
          isRead: false,
        });
      
      functions.logger.info(`[OnSponsorshipCreated] Document de notification créé pour ${parentUserId}`);
      
    } catch (error) {
      functions.logger.error(`[OnSponsorshipCreated] Erreur lors de l'envoi de la notification:`, error);
      // Ne pas relancer l'erreur pour ne pas faire échouer le trigger
    }
  });

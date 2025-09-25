"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const functions = __importStar(require("firebase-functions"));
/**
 * Trigger de test pour diagnostiquer le problème avec les données sponsorship
 */
exports.default = functions.firestore
    .document('users/{userId}/sponsorship/{sponsorshipId}')
    .onCreate(async (snap, context) => {
    functions.logger.info(`[TestSponsorshipCreated] === TRIGGER DE TEST ===`);
    functions.logger.info(`[TestSponsorshipCreated] Document path:`, snap.ref.path);
    functions.logger.info(`[TestSponsorshipCreated] Document ID:`, snap.id);
    functions.logger.info(`[TestSponsorshipCreated] Document exists:`, snap.exists);
    functions.logger.info(`[TestSponsorshipCreated] Parent User ID:`, context.params.userId);
    functions.logger.info(`[TestSponsorshipCreated] Sponsorship ID:`, context.params.sponsorshipId);
    const rawData = snap.data();
    functions.logger.info(`[TestSponsorshipCreated] Raw data type:`, typeof rawData);
    functions.logger.info(`[TestSponsorshipCreated] Raw data is null:`, rawData === null);
    functions.logger.info(`[TestSponsorshipCreated] Raw data is undefined:`, rawData === undefined);
    if (rawData) {
        functions.logger.info(`[TestSponsorshipCreated] Raw data keys:`, Object.keys(rawData));
        functions.logger.info(`[TestSponsorshipCreated] Raw data:`, JSON.stringify(rawData, null, 2));
    }
    else {
        functions.logger.error(`[TestSponsorshipCreated] AUCUNE DONNÉE TROUVÉE !`);
    }
    // Essayer de relire le document directement
    try {
        const directRead = await snap.ref.get();
        functions.logger.info(`[TestSponsorshipCreated] Direct read exists:`, directRead.exists);
        if (directRead.exists) {
            const directData = directRead.data();
            functions.logger.info(`[TestSponsorshipCreated] Direct read data:`, JSON.stringify(directData, null, 2));
        }
    }
    catch (error) {
        functions.logger.error(`[TestSponsorshipCreated] Erreur lors de la lecture directe:`, error);
    }
    functions.logger.info(`[TestSponsorshipCreated] === FIN DU TRIGGER DE TEST ===`);
});
//# sourceMappingURL=test_sponsorship_created.js.map
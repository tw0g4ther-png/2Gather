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
const admin = __importStar(require("firebase-admin"));
const f = __importStar(require("firebase-functions"));
exports.default = async (params) => {
    var _a, _b, _c, _d, _e, _f, _g, _h, _j;
    try {
        f.logger.info('[sendNotification] Début envoi notification', {
            token: params.token ? 'présent' : 'absent',
            title: params.title,
            type: (_a = params.data) === null || _a === void 0 ? void 0 : _a.type
        });
        // Validation des paramètres requis
        if (!params.token) {
            throw new Error('Token FCM manquant');
        }
        if (!params.title || !params.body) {
            throw new Error('Titre ou corps de la notification manquant');
        }
        // Construction du message FCM
        const message = {
            token: params.token,
            notification: {
                title: params.title,
                body: params.body,
            },
            data: params.data || {},
            android: {
                priority: 'high',
                notification: {
                    channelId: ((_c = (_b = params.android) === null || _b === void 0 ? void 0 : _b.notification) === null || _c === void 0 ? void 0 : _c.channel_id) || 'sponsorship_channel',
                    sound: 'default',
                    priority: 'high',
                    icon: ((_e = (_d = params.android) === null || _d === void 0 ? void 0 : _d.notification) === null || _e === void 0 ? void 0 : _e.icon) || 'ic_launcher',
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                }
            },
            apns: {
                payload: {
                    aps: {
                        alert: {
                            title: params.title,
                            body: params.body,
                        },
                        sound: 'default',
                        badge: ((_h = (_g = (_f = params.apns) === null || _f === void 0 ? void 0 : _f.payload) === null || _g === void 0 ? void 0 : _g.aps) === null || _h === void 0 ? void 0 : _h.badge) || 1,
                        'content-available': 1, // Pour les notifications en arrière-plan
                    }
                }
            }
        };
        // Envoi de la notification
        const response = await admin.messaging().send(message);
        f.logger.info('[sendNotification] Notification envoyée avec succès', {
            messageId: response,
            token: params.token.substring(0, 10) + '...'
        });
        return {
            success: true,
            messageId: response,
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        };
    }
    catch (error) {
        f.logger.error('[sendNotification] Erreur lors de l\'envoi', {
            error: (error === null || error === void 0 ? void 0 : error.message) || 'Erreur inconnue',
            stack: error === null || error === void 0 ? void 0 : error.stack,
            params: {
                hasToken: !!params.token,
                title: params.title,
                type: (_j = params.data) === null || _j === void 0 ? void 0 : _j.type
            }
        });
        // Retourner l'erreur pour debugging côté client
        return {
            success: false,
            error: (error === null || error === void 0 ? void 0 : error.message) || 'Erreur inconnue lors de l\'envoi de la notification',
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        };
    }
};
//# sourceMappingURL=send_notification.js.map
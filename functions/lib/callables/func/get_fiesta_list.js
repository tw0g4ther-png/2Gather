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
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const f = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
exports.default = async (params, context) => {
    var _a;
    try {
        // Vérifier que l'utilisateur est authentifié
        if (!context.auth) {
            f.logger.error('[getFiestaList] Utilisateur non authentifié');
            throw new f.https.HttpsError('unauthenticated', 'Vous devez être connecté pour accéder à cette fonction');
        }
        const authenticatedUserId = context.auth.uid;
        f.logger.info(`[getFiestaList] Appel authentifié pour l'utilisateur: ${authenticatedUserId}`);
        // Vérifier que l'utilisateur authentifié correspond à celui demandé
        if (authenticatedUserId !== params.userId) {
            f.logger.error(`[getFiestaList] Tentative d'accès non autorisée: ${authenticatedUserId} essaie d'accéder aux données de ${params.userId}`);
            throw new f.https.HttpsError('permission-denied', 'Vous ne pouvez accéder qu\'à vos propres données');
        }
        const metadata = params.metadata;
        f.logger.info(params);
        const userDoc = await admin.firestore().collection("users").doc(params.userId).get();
        // Vérifier que le document utilisateur existe
        if (!userDoc.exists) {
            f.logger.error(`[getFiestaList] Document utilisateur ${params.userId} n'existe pas`);
            throw new f.https.HttpsError('not-found', 'Document utilisateur non trouvé');
        }
        const userData = userDoc.data();
        f.logger.info(userData);
        var userPosition = null;
        if (userData.position !== undefined)
            userPosition = userData.position;
        if (metadata && metadata["location"] !== null && metadata["location"] !== undefined) {
            userPosition = metadata["location"];
        }
        var d = new Date();
        d.setDate(d.getDate() - 2);
        const fiestaList = await admin.firestore().collection("fiesta").where("isEnd", "!=", false).get();
        var fiestaCardList = [];
        for (const item of fiestaList.docs) {
            const itemData = item.data();
            if (canShowFiestaForUser(params.userId, userData, item.id, itemData) && await fiestaVisibilityIsOkay(params.userId, userData, item.id, itemData)) {
                var totalPoint = 0;
                /// Calculate distance
                const friendPosition = itemData.address.geopoint;
                var dist = 0;
                if (userPosition !== null)
                    dist = distance(userPosition.latitude, userPosition.longitude, friendPosition.latitude, friendPosition.longitude, "K");
                const maxDistance = (((_a = metadata === null || metadata === void 0 ? void 0 : metadata["visibilty"]) !== null && _a !== void 0 ? _a : 50) * 1000);
                if (dist < (maxDistance / 10)) {
                    totalPoint += 100 + (maxDistance - dist);
                }
                else if (dist < (maxDistance / 5)) {
                    totalPoint += 50 + (maxDistance - dist);
                }
                else if (dist < (maxDistance / 2)) {
                    totalPoint += 20 + (maxDistance - dist);
                }
                else if (dist < maxDistance) {
                    totalPoint += 10 + (maxDistance - dist);
                }
                else {
                    totalPoint -= (200 + (dist - maxDistance));
                }
                /// Check category of Fiesta
                if (metadata && itemData.category == metadata["category"]) {
                    totalPoint += 20;
                }
                fiestaCardList.push({
                    fiesta: Object.assign(Object.assign({}, item.data()), { id: item.id }),
                    point: totalPoint,
                });
            }
        }
        fiestaCardList = fiestaCardList.sort((a, b) => {
            return a.point > b.point ? -1 : 1;
        });
        var ret = [];
        for (const item of fiestaCardList) {
            ret.push(item.fiesta);
        }
        return ret;
    }
    catch (e) {
        f.logger.error("[Error] getFiestaList: ", e);
        return { error: e };
    }
};
function canShowFiestaForUser(userId, userData, fiestaId, fiestaData) {
    if (userData.fiestaDismissed !== undefined && userData.fiestaDismissed !== null && userData.fiestaDismissed.indexOf(fiestaId) !== -1)
        return false;
    if (fiestaData.host.id === userId)
        return false;
    const userInFiesta = fiestaData.participants;
    if (userInFiesta && userInFiesta.length > 0) {
        for (const item of userInFiesta) {
            if (userData.bloquedUser !== undefined && userData.bloquedUser !== null && userData.bloquedUser.indexOf(item.userRef) !== -1)
                return false;
            if (userData.bloquedUser !== undefined && userData.bloquedUser !== null && userData.bloquedUser.indexOf(item.duoRef) !== -1)
                return false;
            if (item.userRef === userId)
                return false;
            if (item.duoRef === userId)
                return false;
        }
    }
    return true;
}
async function fiestaVisibilityIsOkay(userId, userData, fiestaId, fiestaData) {
    var _a, _b, _c;
    const connexion = (_a = fiestaData.visibleByConnexion) !== null && _a !== void 0 ? _a : true;
    const fiestar = (_b = fiestaData.visibleByFiestar) !== null && _b !== void 0 ? _b : true;
    const fCircle = (_c = fiestaData.visibleByFirstCircle) !== null && _c !== void 0 ? _c : true;
    const hostData = (await admin.firestore().collection("users").doc(fiestaData.host.id).get()).data();
    if (hostData.friends && hostData.friends.length > 0) {
        for (const friend of hostData.friends) {
            if (friend.user.id == userId) {
                if (friend.type == "fiestar" && fiestar)
                    return true;
                if (friend.type == "connexion" && connexion)
                    return true;
                if (friend.type == "1_circle" && fCircle)
                    return true;
            }
        }
    }
    return false;
}
function distance(lat1, lon1, lat2, lon2, unit) {
    if ((lat1 == lat2) && (lon1 == lon2)) {
        return 0;
    }
    else {
        var radlat1 = Math.PI * lat1 / 180;
        var radlat2 = Math.PI * lat2 / 180;
        var theta = lon1 - lon2;
        var radtheta = Math.PI * theta / 180;
        var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
        if (dist > 1) {
            dist = 1;
        }
        dist = Math.acos(dist);
        dist = dist * 180 / Math.PI;
        dist = dist * 60 * 1.1515;
        if (unit == "K") {
            dist = dist * 1.609344;
        }
        if (unit == "N") {
            dist = dist * 0.8684;
        }
        return dist;
    }
}
//# sourceMappingURL=get_fiesta_list.js.map
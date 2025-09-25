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
    var _a, _b, _c;
    try {
        // Vérifier que l'utilisateur est authentifié
        if (!context.auth) {
            f.logger.error('[getUserCardList] Utilisateur non authentifié');
            throw new f.https.HttpsError('unauthenticated', 'Vous devez être connecté pour accéder à cette fonction');
        }
        const authenticatedUserId = context.auth.uid;
        f.logger.info(`[getUserCardList] Appel authentifié pour l'utilisateur: ${authenticatedUserId}`);
        var userList = (await admin.firestore().collection("users").where("email", "!=", `${params["email"]}`).get()).docs;
        const metadata = params.metadata;
        userList = userList.filter((user) => {
            return "contact@fiesta.family" != user.data().email;
        });
        if (metadata !== null && metadata !== undefined) {
            const friendEmailList = metadata["friendEmailList"];
            if (friendEmailList !== undefined && metadata !== null && friendEmailList.length > 0) {
                userList = userList.filter((user) => {
                    return friendEmailList != user.data().email;
                });
            }
        }
        // Vérifier que l'utilisateur authentifié correspond à celui demandé
        if (authenticatedUserId !== params.userId) {
            f.logger.error(`[getUserCardList] Tentative d'accès non autorisée: ${authenticatedUserId} essaie d'accéder aux données de ${params.userId}`);
            throw new f.https.HttpsError('permission-denied', 'Vous ne pouvez accéder qu\'à vos propres données');
        }
        const userDoc = await admin.firestore().collection("users").doc(params.userId).get();
        // Vérifier que le document utilisateur existe et n'est pas vide
        if (!userDoc.exists) {
            f.logger.error(`[getUserCardList] Document utilisateur ${params.userId} n'existe pas`);
            return { error: "Document utilisateur non trouvé" };
        }
        const userData = userDoc.data();
        // Vérifier que le document n'est pas vide
        if (!userData || Object.keys(userData).length === 0) {
            f.logger.error(`[getUserCardList] Document utilisateur ${params.userId} est vide`);
            return { error: "Document utilisateur vide" };
        }
        // Vérifier que les champs essentiels existent
        if (!userData.position) {
            f.logger.error(`[getUserCardList] Position manquante pour l'utilisateur ${params.userId}`);
            return { error: "Position utilisateur manquante" };
        }
        var userPosition = userData.position;
        if (metadata && metadata["location"] !== null && metadata["location"] !== undefined) {
            userPosition = metadata["location"];
        }
        var userCardList = [];
        for (var i = 0; i < userList.length; i++) {
            if (params.userId !== userList[i].id && _isOkayToShow(userData.friendsDismissed, userData.friends, userList[i].id, userData.bloquedUser, userData.friendsRequest)) {
                const user = userList[i];
                var userCard = user.data();
                userCard["id"] = user.id;
                /// calculate points of user
                var totalPoint = 0;
                /// Calculate distance
                const friendPosition = userCard.position;
                const dist = distance(userPosition.latitude, userPosition.longitude, friendPosition.latitude, friendPosition.longitude, "K");
                const maxDistance = (((_a = metadata === null || metadata === void 0 ? void 0 : metadata["visibilty"]) !== null && _a !== void 0 ? _a : 50) * 1000);
                if (dist < (maxDistance / 10)) {
                    totalPoint += 100;
                }
                else if (dist < (maxDistance / 5)) {
                    totalPoint += 50;
                }
                else if (dist < (maxDistance / 2)) {
                    totalPoint += 20;
                }
                else if (dist < maxDistance) {
                    totalPoint += 10;
                }
                else {
                    totalPoint -= (200 + (dist - maxDistance));
                }
                /// Calculate age
                const userAge = getAge(userCard.birthday);
                const maxAge = (_b = metadata === null || metadata === void 0 ? void 0 : metadata["age_max"]) !== null && _b !== void 0 ? _b : 70;
                const minAge = (_c = metadata === null || metadata === void 0 ? void 0 : metadata["age_min"]) !== null && _c !== void 0 ? _c : 18;
                if (userAge >= minAge && userAge <= maxAge) {
                    totalPoint += 20;
                }
                userCardList.push({
                    point: totalPoint,
                    user: userCard
                });
            }
        }
        userCardList = userCardList.sort((a, b) => {
            return a.point > b.point ? -1 : 1;
        });
        var ret = [];
        for (const item of userCardList) {
            ret.push(item.user);
        }
        return ret;
    }
    catch (e) {
        f.logger.error("[Error] getUserCardList: ", e);
        return { error: e };
    }
};
function _isOkayToShow(dismissedFriends, friends, friendId, bloquesFriend, requestedFriends) {
    // Vérifier les amis rejetés (friendsDismissed)
    if (Array.isArray(dismissedFriends) && dismissedFriends.indexOf(friendId) !== -1)
        return false;
    // Vérifier les demandes d'amis en attente
    if (Array.isArray(requestedFriends) && requestedFriends.indexOf(friendId) !== -1)
        return false;
    // Vérifier les utilisateurs bloqués
    if (Array.isArray(bloquesFriend) && bloquesFriend.indexOf(friendId) !== -1)
        return false;
    // Vérifier les amis existants
    if (Array.isArray(friends)) {
        for (const e of friends) {
            if (e && e.user && e.user.id == friendId)
                return false;
        }
    }
    return true;
}
function getAge(dateString) {
    var today = new Date();
    var birthDate = dateString.toDate();
    var age = today.getFullYear() - birthDate.getFullYear();
    var m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
        age--;
    }
    return age;
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
//# sourceMappingURL=get_user_card_list.js.map
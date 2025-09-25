"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteUser = exports.checkEmailIsAvailable = exports.createFiestaPoint = exports.refuseUserNotify = exports.requestADuoToGoFiesta = exports.acceptUserInFiesta = exports.deleteUserInFiesta = exports.deleteFiesta = exports.joinFiesta = exports.stopLockDuo = exports.confirmDuoRequest = exports.requestNewLockDuo = exports.confirmFriendRequest = exports.dismissFriendWithSwipe = exports.deleteFriend = exports.addFriend = exports.addFriendWithSwipe = void 0;
const lazy_1 = __importDefault(require("../lazy"));
const firebase_functions_1 = require("firebase-functions");
// Cloud functions supprimées et remplacées par des services directs côté client :
// - verifyTrustCode → verifyTrustCodeDirect côté client
// - getUserCardList → UserCardService côté client  
// - getFiestaList → FiestaService côté client
// - profilIsCompleted → createSponsorshipDirect côté client
// - sendNotification → trigger onSponsorshipCreated côté serveur
exports.addFriendWithSwipe = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/add_friend_with_swipe'));
exports.deleteFriend = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/delete_friend'));
exports.dismissFriendWithSwipe = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/dismiss_frient_with_swipe'));
exports.confirmFriendRequest = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/confirm_friend_request'));
exports.requestNewLockDuo = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/request_new_lock_duo'));
exports.confirmDuoRequest = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/confirm_duo_request'));
exports.stopLockDuo = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/stop_lock_duo'));
exports.joinFiesta = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/join_fiesta'));
exports.deleteFiesta = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/delete_fiesta'));
exports.deleteUserInFiesta = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/delete_user_in_fiesta'));
exports.acceptUserInFiesta = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/accept_user_in_fiesta'));
exports.requestADuoToGoFiesta = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/request_a_duo_to_go_fiesta'));
exports.refuseUserNotify = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/refuse_user_notify'));
// profilIsCompleted supprimée - remplacée par createSponsorshipDirect côté client
exports.createFiestaPoint = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/create_fiesta_point'));
// sendNotification supprimée - remplacée par le trigger onSponsorshipCreated
////////////////// LIBRARY //////////////////
exports.checkEmailIsAvailable = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/library/check_email_is_available'));
exports.deleteUser = firebase_functions_1.https.onCall((0, lazy_1.default)('./callables/func/library/delete_user'));
//# sourceMappingURL=index.js.map
import lazy from '../lazy'
import { https } from 'firebase-functions'

// Cloud functions supprimées et remplacées par des services directs côté client :
// - verifyTrustCode → verifyTrustCodeDirect côté client
// - getUserCardList → UserCardService côté client  
// - getFiestaList → FiestaService côté client
// - profilIsCompleted → createSponsorshipDirect côté client
// - sendNotification → trigger onSponsorshipCreated côté serveur

export const addFriendWithSwipe = https.onCall(lazy('./callables/func/add_friend_with_swipe'));
export const deleteFriend = https.onCall(lazy('./callables/func/delete_friend'));
export const dismissFriendWithSwipe = https.onCall(lazy('./callables/func/dismiss_frient_with_swipe'));
export const confirmFriendRequest = https.onCall(lazy('./callables/func/confirm_friend_request'));

export const requestNewLockDuo = https.onCall(lazy('./callables/func/request_new_lock_duo'));
export const confirmDuoRequest = https.onCall(lazy('./callables/func/confirm_duo_request'));
export const stopLockDuo = https.onCall(lazy('./callables/func/stop_lock_duo'));

export const joinFiesta = https.onCall(lazy('./callables/func/join_fiesta'));
export const deleteFiesta = https.onCall(lazy('./callables/func/delete_fiesta'));

export const deleteUserInFiesta = https.onCall(lazy('./callables/func/delete_user_in_fiesta'));
export const acceptUserInFiesta = https.onCall(lazy('./callables/func/accept_user_in_fiesta'));
export const requestADuoToGoFiesta = https.onCall(lazy('./callables/func/request_a_duo_to_go_fiesta'));
export const refuseUserNotify = https.onCall(lazy('./callables/func/refuse_user_notify'));

// profilIsCompleted supprimée - remplacée par createSponsorshipDirect côté client
export const createFiestaPoint = https.onCall(lazy('./callables/func/create_fiesta_point'));
// sendNotification supprimée - remplacée par le trigger onSponsorshipCreated

////////////////// LIBRARY //////////////////
export const checkEmailIsAvailable = https.onCall(lazy('./callables/func/library/check_email_is_available'));
export const deleteUser = https.onCall(lazy('./callables/func/library/delete_user'));

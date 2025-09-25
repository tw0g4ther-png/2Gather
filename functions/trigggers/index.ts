import lazy from '../lazy'
import { firestore, pubsub } from 'firebase-functions'

export const onUserCreated = firestore.document("users/{userId}").onCreate(lazy("./trigggers/func/on_user_created"));
export const onUserDeleted = firestore.document("users/{userId}").onCreate(lazy("./trigggers/func/on_user_deleted"));

export const onSponsorshipCreated = firestore.document("users/{userId}/sponsorship/{sponsorshipId}").onCreate(lazy("./trigggers/func/on_sponsorship_created"));
// testSponsorshipCreated supprimé - trigger de test non nécessaire en production


export const onReportCreated = firestore.document("users/{userId}").onCreate(lazy("./trigggers/func/report/on_report_created"));
///* 4 * * *
export const checkEndFiesta = pubsub.schedule("every 5 minutes").onRun(lazy("./trigggers/func/fiesta/checked_end_fiesta"));
export const clearReportAfterDuration = pubsub.schedule("every 12 hours").onRun(lazy("./trigggers/func/report/clean_report_after_duration"));
export const clearDismissed = pubsub.schedule("every 96 hours").onRun(lazy("./trigggers/func/clear_dismissed"));
"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.clearDismissed = exports.clearReportAfterDuration = exports.checkEndFiesta = exports.onReportCreated = exports.onFriendRequestCreated = exports.onSponsorshipCreated = exports.onUserDeleted = exports.onUserCreated = void 0;
const lazy_1 = __importDefault(require("../lazy"));
const firebase_functions_1 = require("firebase-functions");
exports.onUserCreated = firebase_functions_1.firestore.document("users/{userId}").onCreate((0, lazy_1.default)("./trigggers/func/on_user_created"));
exports.onUserDeleted = firebase_functions_1.firestore.document("users/{userId}").onCreate((0, lazy_1.default)("./trigggers/func/on_user_deleted"));
exports.onSponsorshipCreated = firebase_functions_1.firestore.document("users/{userId}/sponsorship/{sponsorshipId}").onCreate((0, lazy_1.default)("./trigggers/func/on_sponsorship_created"));
// testSponsorshipCreated supprimé - trigger de test non nécessaire en production
exports.onReportCreated = firebase_functions_1.firestore.document("users/{userId}").onCreate((0, lazy_1.default)("./trigggers/func/report/on_report_created"));
///* 4 * * *
exports.checkEndFiesta = firebase_functions_1.pubsub.schedule("every 5 minutes").onRun((0, lazy_1.default)("./trigggers/func/fiesta/checked_end_fiesta"));
exports.clearReportAfterDuration = firebase_functions_1.pubsub.schedule("every 12 hours").onRun((0, lazy_1.default)("./trigggers/func/report/clean_report_after_duration"));
exports.clearDismissed = firebase_functions_1.pubsub.schedule("every 96 hours").onRun((0, lazy_1.default)("./trigggers/func/clear_dismissed"));
//# sourceMappingURL=index.js.map
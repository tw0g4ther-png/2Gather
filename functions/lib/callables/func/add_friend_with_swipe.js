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
exports.default = async (params) => {
    var _a, _b, _c, _d, _e;
    try {
        const user = admin.firestore().collection("users").doc(params.userId);
        const friend = admin.firestore().collection("users").doc(params.friendId);
        const friendData = await user.get();
        f.logger.info(`Is a match ? ${(_b = (_a = friendData.data()) === null || _a === void 0 ? void 0 : _a.friendsRequest) === null || _b === void 0 ? void 0 : _b.includes(user.id)}`);
        if ((_e = (_d = (_c = friendData.data()) === null || _c === void 0 ? void 0 : _c.friendsRequest) === null || _d === void 0 ? void 0 : _d.includes(user.id)) !== null && _e !== void 0 ? _e : false) {
            await friend.update({
                friendsRequest: admin.firestore.FieldValue.arrayRemove(user.id)
            });
            await user.update({
                friendsRequest: admin.firestore.FieldValue.arrayRemove(friend.id)
            });
            await friend.update({
                friends: admin.firestore.FieldValue.arrayUnion({
                    type: "connexion",
                    user: user,
                })
            });
            await user.update({
                friends: admin.firestore.FieldValue.arrayUnion({
                    type: "connexion",
                    user: friend,
                })
            });
            // await user.collection("friends").doc(friend.id).set((await friend.get()).data()!);
            // await friend.collection("friends").doc(user.id).set((await user.get()).data()!);
        }
        else {
            await user.update({
                friendsRequest: admin.firestore.FieldValue.arrayUnion(friend.id)
            });
        }
        return true;
    }
    catch (e) {
        f.logger.error("[Error] addFriendWithSwipe: ", e);
        return { error: e };
    }
};
//# sourceMappingURL=add_friend_with_swipe.js.map
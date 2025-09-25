import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twogather/model/passion/passion_listing.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class FiestarUserModel extends UserModel {
  final String? trustCode;
  final String? personnalTrustCode;
  final String? gender;
  final DateTime? birthday;
  final List<String?>? nationality;
  final List<String?>? languages;
  final PassionListing? favorite;
  final String? smoker;
  final String? description;
  final List<String>? profilImages;
  final String? completeProfilStatus;
  final List<String>? friendsRequest;
  final List<Map<String, dynamic>>? friends;
  final AppUserModel? duo;

  final GeoPoint? position;
  final String? locality;

  final int? level;
  final double? rating;
  final int? numberRecommandations;
  final double? numberFiesta;
  final double? numberFiestaCreated;
  final bool? superHost;
  final String? signalement;
  final bool? isHost;

  final String? fiesta;
  final double? reportPoint;

  final DateTime? createdAt;
  final DateTime? lastSeen;

  FiestarUserModel({
    super.id,
    super.email,
    super.firstname,
    super.lastname,
    super.enablePushNotification,
    super.enableEmailNotification,
    super.fcmToken,
    super.phone,
    super.profilImage,
    super.stripeId,
    super.language,
    super.cguAccepted,
    super.profilCompleted,
    super.isFirstLogin,
    String? userType,
    this.trustCode,
    this.personnalTrustCode,
    this.birthday,
    this.description,
    this.favorite,
    this.completeProfilStatus,
    this.gender,
    this.languages,
    this.nationality,
    this.profilImages,
    this.smoker,
    this.isHost,
    this.level,
    this.numberFiesta,
    this.numberFiestaCreated,
    this.numberRecommandations,
    this.rating,
    this.signalement,
    this.superHost,
    this.locality,
    this.position,
    this.friendsRequest,
    this.friends,
    this.duo,
    this.fiesta,
    this.reportPoint,
    this.createdAt,
    this.lastSeen,
  }) : super(userType: userType ?? "default");

  @override
  factory FiestarUserModel.fromJson(Map<String, dynamic> json) {
    return FiestarUserModel(
      email: json["email"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      enablePushNotification: json["enablePushNotification"],
      enableEmailNotification: json["enableEmailNotification"],
      fcmToken: json["fcmToken"],
      phone: json["phone"],
      profilImage: json["profilImage"],
      stripeId: json["stripeId"],
      language: json["language"],
      cguAccepted: json["cguAccepted"],
      profilCompleted: json["profilCompleted"],
      trustCode: json["trustCode"],
      isFirstLogin: json["isFirstLogin"],
      userType: json["userType"] ?? "default",
      birthday: (json["birthday"] as Timestamp?)?.toDate(),
      description: json["description"],
      favorite: json["favorite"] != null
          ? PassionListing.fromJson(json["favorite"])
          : null,
      completeProfilStatus: json["completeProfilStatus"],
      gender: json["gender"],
      languages: (json["languages"] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      nationality: (json["nationality"] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      profilImages: (json["profilImages"] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      smoker: json["smoker"],
      isHost: json["isHost"] ?? false,
      level: json["level"],
      numberFiesta: json["numberFiesta"],
      numberFiestaCreated: json["numberFiestaCreated"],
      numberRecommandations: json["numberRecommandations"],
      rating: json["rating"],
      signalement: json["signalement"],
      superHost: json["superHost"] ?? false,
      personnalTrustCode: json["personnalTrustCode"],
      locality: json["locality"],
      position: json["position"],
      friendsRequest: (json["friendsRequest"] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      friends: (json["friends"] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList(),
      duo: json["duo"] != null ? AppUserModel.fromJson(json["duo"]) : null,
      fiesta: json["fiesta"],
      reportPoint: json["reportPoint"],
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
      lastSeen: (json["lastSeen"] as Timestamp?)?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "enablePushNotification": enablePushNotification,
      "enableEmailNotification": enableEmailNotification,
      "fcmToken": fcmToken,
      "phone": phone,
      "profilImage": profilImage,
      "stripeId": stripeId,
      "language": language,
      "trustCode": trustCode,
      "profilCompleted": profilCompleted,
      "cguAccepted": cguAccepted,
      "isFirstLogin": isFirstLogin,
      "userType": userType,
      "birthday": birthday,
      "description": description,
      "favorite": favorite,
      "completeProfilStatus": completeProfilStatus,
      "gender": gender,
      "smoker": smoker,
      "languages": languages,
      "nationality": nationality,
      "profilImages": profilImages,
      "numberRecommandations": numberRecommandations,
      "numberFiesta": numberFiesta,
      "numberFiestaCreated": numberFiestaCreated,
      "superHost": superHost,
      "rating": rating,
      "signalement": signalement,
      "isHost": isHost,
      "level": level,
      "personnalTrustCode": personnalTrustCode,
      "locality": locality,
      "position": position,
      "friendsRequest": friendsRequest,
      "friends": friends,
      "duo": duo,
      "fiesta": fiesta,
      "reportPoint": reportPoint,
      "createdAt": createdAt ?? DateTime.now(),
      "lastSeen": lastSeen ?? DateTime.now(),
    };
  }

  @override
  FiestarUserModel copyWith({
    String? id,
    String? email,
    String? firstname,
    String? lastname,
    bool? enablePushNotification,
    bool? enableEmailNotification,
    String? fcmToken,
    String? profilImage,
    String? phone,
    String? stripeId,
    String? language,
    bool? cguAccepted,
    bool? profilCompleted,
    bool? isFirstLogin,
    String? userType,
    // Paramètres spécifiques à FiestarUserModel
    String? trustCode,
    String? gender,
    DateTime? birthday,
    List<String?>? nationality,
    List<String?>? languages,
    PassionListing? favorite,
    String? smoker,
    String? description,
    List<String>? profilImages,
    String? completeProfilStatus,
    int? level,
    double? rating,
    int? numberRecommandations,
    double? numberFiesta,
    double? numberFiestaCreated,
    bool? superHost,
    String? signalement,
    bool? isHost,
    String? personnalTrustCode,
    String? locality,
    GeoPoint? position,
    List<String>? friendsRequest,
    List<Map<String, dynamic>>? friends,
    AppUserModel? duo,
    String? fiesta,
    double? reportPoint,
    DateTime? createdAt,
    DateTime? lastSeen,
  }) {
    return FiestarUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      enablePushNotification:
          enablePushNotification ?? this.enablePushNotification,
      enableEmailNotification:
          enableEmailNotification ?? this.enableEmailNotification,
      fcmToken: fcmToken ?? this.fcmToken,
      phone: phone ?? this.phone,
      profilImage: profilImage ?? this.profilImage,
      stripeId: stripeId ?? this.stripeId,
      language: language ?? this.language,
      trustCode: trustCode ?? this.trustCode,
      profilCompleted: profilCompleted ?? this.profilCompleted,
      cguAccepted: cguAccepted ?? this.cguAccepted,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      userType: userType ?? this.userType,
      birthday: birthday ?? this.birthday,
      description: description ?? this.description,
      favorite: favorite ?? this.favorite,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      languages: languages ?? this.languages,
      smoker: smoker ?? this.smoker,
      profilImages: profilImages ?? this.profilImages,
      completeProfilStatus: completeProfilStatus ?? this.completeProfilStatus,
      level: level ?? this.level,
      rating: rating ?? this.rating,
      numberRecommandations:
          numberRecommandations ?? this.numberRecommandations,
      numberFiesta: numberFiesta ?? this.numberFiesta,
      numberFiestaCreated: numberFiestaCreated ?? this.numberFiestaCreated,
      superHost: superHost ?? this.superHost,
      signalement: signalement ?? this.signalement,
      isHost: isHost ?? this.isHost,
      personnalTrustCode: personnalTrustCode ?? this.personnalTrustCode,
      locality: locality ?? this.locality,
      position: position ?? this.position,
      friendsRequest: friendsRequest ?? this.friendsRequest,
      friends: friends ?? this.friends,
      duo: duo ?? this.duo,
      fiesta: fiesta ?? this.fiesta,
      reportPoint: reportPoint ?? this.reportPoint,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}

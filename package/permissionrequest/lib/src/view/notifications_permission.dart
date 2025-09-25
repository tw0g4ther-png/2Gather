import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permissionrequest/src/view/blank_permission.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';

class NotificationsPermission extends StatefulWidget {
  const NotificationsPermission({
    super.key,
    required this.userCollection,
    this.pageController,
    this.validateText = 'Activer les notifications',
    this.onBack,
    this.onSkip,
    this.onValidate,
    this.skipText = 'Passer',
    this.asset = 'assets/notification.png',
    this.title = 'Notifications Push',
    this.subtitle =
        'Souhaitez-vous activer notre service de notifications Push ? Il vous aidera à exploiter tout le potentiel de notre application.',
    this.isBackground = false,
    this.isSafeArea = true,
    this.backgroundColor,
    this.titleStyle,
    this.package = 'permissionrequest',
    this.assetSize,
    this.subtitleStyle,
    this.validateButtonPadding,
    this.backButtonPadding,
    this.skipButtonPadding,
    this.themeBack,
    this.themeNameBack,
    this.themeSkip,
    this.themeNameSkip,
    this.themeValidate,
    this.themeNameValidate,
    this.assetChild,
  });

  final String userCollection;
  final PageController? pageController;
  final VoidCallback? onValidate;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final String validateText;
  final String? skipText;
  final String? title;
  final String? subtitle;
  final String? asset;
  final Color? backgroundColor;
  final bool isBackground;
  final String? package;
  final bool isSafeArea;
  final EdgeInsets? validateButtonPadding;
  final EdgeInsets? backButtonPadding;
  final EdgeInsets? skipButtonPadding;
  final Size? assetSize;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final CtaThemeData? themeBack;
  final String? themeNameBack;
  final CtaThemeData? themeValidate;
  final String? themeNameValidate;
  final CtaThemeData? themeSkip;
  final String? themeNameSkip;
  final Widget? assetChild;

  @override
  State<NotificationsPermission> createState() =>
      _NotificationsPermissionState();
}

class _NotificationsPermissionState extends State<NotificationsPermission> {
  @override
  Widget build(BuildContext context) {
    return BlankPermission(
      subtitle: widget.subtitle,
      validateText: widget.validateText,
      asset: widget.asset,
      package: widget.package,
      title: widget.title,
      themeBack: widget.themeBack,
      themeSkip: widget.themeSkip,
      assetChild: widget.assetChild,
      onValidate: widget.onValidate ??
          (() async {
            try {
              FirebaseMessaging messaging = FirebaseMessaging.instance;
              NotificationSettings settings = await messaging.requestPermission(
                alert: true,
                announcement: false,
                badge: true,
                carPlay: false,
                criticalAlert: false,
                provisional: false,
                sound: true,
              );
              
              if (settings.authorizationStatus == AuthorizationStatus.authorized ||
                  settings.authorizationStatus == AuthorizationStatus.provisional) {
                // Permission accordée - sauvegarder le token
                FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
                final token = await firebaseMessaging.getToken();
                if (FirebaseAuth.instance.currentUser != null) {
                  await FirebaseFirestore.instance
                      .collection(widget.userCollection)
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "fcmToken": token,
                    "enablePushNotification": true,
                  });
                }
                printInDebug("[NotificationsPermission] Permission accordée et token sauvegardé");
              } else {
                // Permission refusée - afficher un message d'erreur
                printInDebug("[NotificationsPermission] Permission de notifications refusée - Statut: ${settings.authorizationStatus}");
                
                if (context.mounted) {
                  // Afficher un message d'erreur à l'utilisateur
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Les notifications sont bloquées. Vous pouvez les activer dans les paramètres de votre appareil.",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 4),
                      action: SnackBarAction(
                        label: "Paramètres",
                        textColor: Colors.white,
                        onPressed: () {
                          // Optionnel : ouvrir les paramètres de l'appareil
                          printInDebug("[NotificationsPermission] Redirection vers les paramètres demandée");
                        },
                      ),
                    ),
                  );
                }
              }
              
              // Dans tous les cas, fermer la page sans rediriger vers les paramètres
              if (!context.mounted) return;
              Navigator.pop(context);
            } catch (e) {
              printInDebug("[NotificationsPermission] Erreur lors de la demande de permission: $e");
              
              if (context.mounted) {
                // Afficher un message d'erreur en cas de problème technique
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Erreur lors de la configuration des notifications. Veuillez réessayer.",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              
              // En cas d'erreur, fermer la page
              if (!context.mounted) return;
              Navigator.pop(context);
            }
          }),
      onBack: widget.onBack ??
          (() {
            if (widget.pageController != null) {
              if (widget.pageController!.page != 0) {
                widget.pageController!.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            }
          }),
      onSkip: widget.onSkip ??
          (() {
            // Pour la page de notifications (dernière page), fermer le flux complet
            if (!context.mounted) return;
            Navigator.pop(context);
          }),
      skipText: widget.skipText,
      backgroundColor: widget.backgroundColor,
      isBackground: widget.isBackground,
      isSafeArea: widget.isSafeArea,
      validateButtonPadding: widget.validateButtonPadding,
      backButtonPadding: widget.backButtonPadding,
      skipButtonPadding: widget.skipButtonPadding,
      assetSize: widget.assetSize,
      titleStyle: widget.titleStyle,
      subtitleStyle: widget.subtitleStyle,
    );
  }
}

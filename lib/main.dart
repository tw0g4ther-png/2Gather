// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/chat/widgets/messages/text_message.dart';
import 'package:twogather/chat/riverpods/salon_river.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/pages/complete_profil/complete_profil.dart';
import 'package:twogather/pages/home/settings/share_trust_code.dart';
import 'package:twogather/pages/home/settings/update_description.dart';
import 'package:twogather/pages/home/settings/update_profil_picture.dart';
import 'package:twogather/pages/home/settings/update_supply_info.dart';
import 'package:twogather/pages/home/settings/update_tags.dart';
import 'package:twogather/provider/fiesta_swipe_pref_provider.dart';
import 'package:twogather/provider/fiesta_swipe_provider.dart';
import 'package:twogather/provider/notification_provider.dart';
import 'package:twogather/provider/sponsoship_provider.dart';
import 'package:twogather/provider/user_fiesta_provider.dart';
import 'package:twogather/provider/user_swipe_pref_provider.dart';
import 'package:twogather/provider/user_swipe_provider.dart';
import 'package:twogather/routes/app_router.dart';
import 'package:twogather/widgets/multi_item_selector/theme.dart';
import 'package:twogather/widgets/multiple_dropdown_selection/theme.dart';
import 'package:twogather/widgets/toggle_swicth/theme.dart';
import 'package:permissionrequest/permissons_package.dart' as permissions;
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_kosmos/settings_kosmos.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:timeago/timeago.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';
import 'package:ui_kosmos_v4/form/theme.dart';

Directory? directory;

final notificationProvider = ChangeNotifierProvider<NotificationProvider>((
  ref,
) {
  return NotificationProvider();
});

final userSwipeProvider = ChangeNotifierProvider<UserSwipeProvider>((ref) {
  return UserSwipeProvider();
});

final userSwipePrefProvider = ChangeNotifierProvider<UserSwipePrefProvider>((
  ref,
) {
  return UserSwipePrefProvider();
});

final fiestaSwipeProvider = ChangeNotifierProvider<FiestaSwipeProvider>((ref) {
  return FiestaSwipeProvider();
});

final fiestaSwipePrefProvider = ChangeNotifierProvider<FiestaSwipePrefProvider>(
  (ref) {
    return FiestaSwipePrefProvider();
  },
);

final userFiestaProvider = ChangeNotifierProvider<UserFiestaProvider>((ref) {
  return UserFiestaProvider();
});

final sponsorshipProvider = ChangeNotifierProvider<SponsorshipProvider>((ref) {
  return SponsorshipProvider();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Ensure Translations is correctly initialized
  await EasyLocalization.ensureInitialized();
  setLocaleMessages('fr', FrShortMessagesKosmos());

  // requestPermission() supprimé car obsolète dans flutter_local_notifications
  // Les permissions sont maintenant gérées via le système de permissions standard

  directory = await getApplicationDocumentsDirectory();

  final appModel = ApplicationDataModel<FiestarUserModel>(
    userTypeProvider: FiestarUserModel(),
    userConstructorProvider: FiestarUserModel.fromJson,
    clearUserSessionOnDebugMode: false,
    appLogo: 'assets/images/app_logo.png',
    logoFormat: SmartImageType.assetImage,
    appTitle: "2Gather",
    mainRouteName: "/dashboard/home",
    supportedLocales: [const Locale('en', 'UK'), const Locale('fr', 'FR')],
    mainRoute: const DashboardRoute(),
    dashboardInitialiser: (context, ref) async {
      if (FirebaseAuth.instance.currentUser == null) return;

      // Vérifier si l'utilisateur est sur CompleteProfilPage pour éviter les conflits
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != null && currentRoute.contains('complete-profil')) {
        printInDebug(
          "[DashboardInitialiser] Utilisateur sur CompleteProfilPage - Arrêt de l'initialisation pour éviter les conflits",
        );
        return;
      }

      // Capturer l'UID de l'utilisateur au début pour détecter les changements
      final initialUserId = FirebaseAuth.instance.currentUser!.uid;
      printInDebug(
        "[DashboardInitialiser] Début de l'initialisation pour l'utilisateur: $initialUserId",
      );

      // Initialiser immédiatement les providers avec des listes vides pour éviter l'écran blanc
      try {
        ref.read(fiestaSwipeProvider).initializeEmpty();
        ref.read(userSwipeProvider).initializeEmpty();
        printInDebug(
          "[DashboardInitialiser] Providers initialisés avec des listes vides",
        );
      } catch (e) {
        printInDebug(
          "[DashboardInitialiser] Erreur lors de l'initialisation vide des providers: $e",
        );
      }

      // Fonction utilitaire pour vérifier si l'utilisateur a changé
      bool hasUserChanged() {
        if (FirebaseAuth.instance.currentUser?.uid != initialUserId) {
          printInDebug(
            "[DashboardInitialiser] Utilisateur changé ($initialUserId → ${FirebaseAuth.instance.currentUser?.uid}) - Arrêt",
          );
          return true;
        }
        return false;
      }

      // Fonction utilitaire pour vérifier si on peut continuer l'initialisation
      bool canContinueInitialization() {
        return !hasUserChanged();
      }

      // Fonction utilitaire pour vérifier si on peut utiliser le contexte
      bool canUseContext() {
        if (!context.mounted) {
          printInDebug(
            "[DashboardInitialiser] Contexte non monté - Certaines initialisations seront différées",
          );
          return false;
        }
        return true;
      }

      // Fonction utilitaire pour utiliser ref de manière sécurisée
      T? safeRefRead<T>(ProviderBase<T> provider) {
        try {
          if (!canContinueInitialization()) return null;
          return ref.read(provider);
        } catch (e) {
          if (e.toString().contains(
            'Cannot use "ref" after the widget was disposed',
          )) {
            printInDebug(
              "[DashboardInitialiser] Widget disposé lors de l'accès au provider - Arrêt",
            );
            return null;
          }
          rethrow;
        }
      }

      try {
        // ÉTAPE 1: Attendre que l'authentification soit complètement stabilisée
        printInDebug(
          "[DashboardInitialiser] Attente de la stabilisation de l'authentification...",
        );
        await FirebaseAuth.instance.authStateChanges().first;

        if (!canContinueInitialization()) return;

        // ÉTAPE 2: Recharger l'utilisateur pour s'assurer que toutes les données sont à jour
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          printInDebug(
            "[DashboardInitialiser] Utilisateur déconnecté pendant l'initialisation",
          );
          return;
        }

        await currentUser.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser == null) {
          printInDebug(
            "[DashboardInitialiser] Utilisateur déconnecté après reload",
          );
          return;
        }

        if (!canContinueInitialization()) return;

        // ÉTAPE 3: Rafraîchir le token d'authentification pour éviter les erreurs unauthenticated
        printInDebug(
          "[DashboardInitialiser] Rafraîchissement du token d'authentification...",
        );
        await refreshedUser.getIdToken(true);
        printInDebug("[DashboardInitialiser] Token rafraîchi avec succès");

        if (!canContinueInitialization()) return;

        // ÉTAPE 3.5: Attendre que le token soit propagé dans Firebase
        printInDebug(
          "[DashboardInitialiser] Attente de la propagation du token...",
        );
        await Future.delayed(const Duration(milliseconds: 500));
        printInDebug("[DashboardInitialiser] Propagation terminée");

        if (!canContinueInitialization()) return;

        // ÉTAPE 4: Initialiser les providers avec authentification stabilisée
        printInDebug("[DashboardInitialiser] Initialisation des providers...");

        // Initialiser userSwipePrefProvider
        final userSwipePrefProv = safeRefRead(userSwipePrefProvider);
        if (userSwipePrefProv == null) return;
        userSwipePrefProv.init();

        if (!canContinueInitialization()) return;

        // Initialiser userSwipeProvider
        final userSwipeProv = safeRefRead(userSwipeProvider);
        final userSwipePrefProvForMetadata = safeRefRead(userSwipePrefProvider);
        if (userSwipeProv == null || userSwipePrefProvForMetadata == null) {
          return;
        }

        // Vérifier que l'utilisateur a un document complet avant d'appeler getUsersList
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection(
                GetIt.instance<ApplicationDataModel>().userCollectionPath,
              )
              .doc(refreshedUser.uid)
              .get();

          if (!userDoc.exists ||
              userDoc.data() == null ||
              userDoc.data()!.isEmpty) {
            printInDebug(
              "[DashboardInitialiser] Document utilisateur vide ou inexistant - Saut de getUsersList",
            );
          } else if (userDoc.data()!['position'] == null) {
            printInDebug(
              "[DashboardInitialiser] Position utilisateur manquante - Saut de getUsersList",
            );
          } else {
            // Document utilisateur valide, procéder à l'appel
            await userSwipeProv.getUsersList(
              refreshedUser.email!,
              metadata: userSwipePrefProvForMetadata.getMetadata(),
            );
          }
        } catch (e) {
          printInDebug(
            "[DashboardInitialiser] Erreur lors de la vérification du document utilisateur: $e",
          );
        }

        if (!canContinueInitialization()) return;

        // Initialiser fiestaSwipePrefProvider
        final fiestaSwipePrefProv = safeRefRead(fiestaSwipePrefProvider);
        if (fiestaSwipePrefProv == null) return;
        fiestaSwipePrefProv.init();

        if (!canContinueInitialization()) return;

        // Initialiser fiestaSwipeProvider
        final fiestaSwipeProv = safeRefRead(fiestaSwipeProvider);
        final fiestaSwipePrefProvForMetadata = safeRefRead(
          fiestaSwipePrefProvider,
        );
        if (fiestaSwipeProv == null || fiestaSwipePrefProvForMetadata == null) {
          return;
        }

        await fiestaSwipeProv.getFiestaList(
          refreshedUser.uid,
          metadata: fiestaSwipePrefProvForMetadata.getMetadata(),
        );

        if (!canContinueInitialization()) return;

        // Initialiser notificationProvider
        final notifProv = safeRefRead(notificationProvider);
        if (notifProv == null) return;

        await notifProv.init(refreshedUser.uid);

        if (!canContinueInitialization()) return;

        // Initialiser userFiestaProvider
        final userFiestaProv = safeRefRead(userFiestaProvider);
        if (userFiestaProv == null) return;

        await userFiestaProv.init(refreshedUser.uid);

        if (!canContinueInitialization()) return;

        // Initialiser le sponsorshipProvider (avec vérification du contexte)
        if (canUseContext()) {
          printInDebug(
            "[DashboardInitialiser] Initialisation du sponsorshipProvider...",
          );
          final sponsorshipProv = safeRefRead(sponsorshipProvider);
          if (sponsorshipProv != null) {
            if (!context.mounted) return;
            await sponsorshipProv.init(refreshedUser.uid, context);
          }
        } else {
          printInDebug(
            "[DashboardInitialiser] Contexte non monté pour sponsorshipProvider - Initialisation différée",
          );
        }

        printInDebug(
          "[DashboardInitialiser] Initialisation terminée avec succès",
        );
      } catch (e) {
        // Gestion des erreurs d'initialisation Firebase
        printInDebug(
          "[DashboardInitialiser] Erreur lors de l'initialisation du dashboard: $e",
        );

        // Vérifier si l'utilisateur s'est déconnecté pendant l'initialisation
        if (FirebaseAuth.instance.currentUser == null) {
          printInDebug(
            "[DashboardInitialiser] Utilisateur déconnecté pendant l'initialisation - Arrêt silencieux",
          );
          return;
        }

        // Vérifier si c'est un problème d'authentification
        if (e.toString().contains('unauthenticated') ||
            e.toString().contains('Unauthenticated') ||
            e.toString().toLowerCase().contains('user-not-found') ||
            e.toString().toLowerCase().contains('no user record')) {
          printInDebug(
            "[DashboardInitialiser] Erreur d'authentification détectée - L'utilisateur sera redirigé vers la connexion",
          );

          // Déconnecter l'utilisateur et rediriger vers login
          if (context.mounted) {
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            // Vider complètement la pile de navigation
            final router = AutoRouter.of(context);
            router.popUntilRoot();
            router.pushNamed("/login");
          }
          return;
        }

        // Vérifier si c'est un problème de permissions (utilisateur déconnecté)
        if (e.toString().contains('PERMISSION_DENIED') ||
            e.toString().contains('Missing or insufficient permissions')) {
          printInDebug(
            "[DashboardInitialiser] Erreur de permissions détectée - Utilisateur probablement déconnecté",
          );

          // Rediriger vers la page de connexion pour éviter tout accès non autorisé
          if (context.mounted) {
            try {
              // Tenter une déconnexion défensive puis réinitialiser la navigation
              await FirebaseAuth.instance.signOut();
            } catch (_) {}
            if (!context.mounted) return;
            final router = AutoRouter.of(context);
            router.popUntilRoot();
            router.pushNamed("/login");
          }
          return;
        }

        // Vérifier si c'est un problème de connectivité
        if (e.toString().contains('UNAVAILABLE') ||
            e.toString().contains('Unable to resolve host') ||
            e.toString().contains('No address associated with hostname')) {
          printInDebug(
            "[DashboardInitialiser] Problème de connectivité détecté - L'application continuera en mode dégradé",
          );
        }

        // Vérifier si le widget a été disposé
        if (e.toString().contains(
          'Cannot use "ref" after the widget was disposed',
        )) {
          printInDebug(
            "[DashboardInitialiser] Widget disposé pendant l'initialisation - Tentative d'initialisation de fallback",
          );

          // Essayer d'initialiser au moins les providers essentiels pour éviter l'écran blanc
          try {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null && !hasUserChanged()) {
              printInDebug(
                "[DashboardInitialiser] Initialisation de fallback des providers essentiels...",
              );

              // Initialiser les providers de base sans context
              final userSwipePrefProv = ref.read(userSwipePrefProvider);
              userSwipePrefProv.init();

              final fiestaSwipePrefProv = ref.read(fiestaSwipePrefProvider);
              fiestaSwipePrefProv.init();

              // Initialiser avec des listes vides pour éviter les null
              await ref
                  .read(userSwipeProvider)
                  .getUsersList(
                    currentUser.email!,
                    metadata: userSwipePrefProv.getMetadata(),
                  );

              await ref
                  .read(fiestaSwipeProvider)
                  .getFiestaList(
                    currentUser.uid,
                    metadata: fiestaSwipePrefProv.getMetadata(),
                  );

              printInDebug(
                "[DashboardInitialiser] Initialisation de fallback réussie",
              );
            }
          } catch (fallbackError) {
            printInDebug(
              "[DashboardInitialiser] Échec de l'initialisation de fallback: $fallbackError",
            );
          }
          return;
        }

        // L'application continue de fonctionner même en cas d'erreur
        // Les providers ont déjà été initialisés avec des listes vides
      }
    },
    dashboardInitialiserWithUserData: (_, ref) async {},

    /// Firebase Settings
    firebaseIsEnabled: true,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    firebaseFunctionsUri: "us-central1-gather-10f2b.cloudfunctions.net",

    gmapKey: "AIzaSyAfZ-Bansx5wqdfVjpV-64WrzN6MjTima4",

    /// Skeleton Settings
    applicationConfig: AppConfigModel(
      applicationNeedsPermission:
          false, // Désactivé - permissions gérées dans HomePage
      permissonWidgets: [], // Vide - permissions déplacées vers HomePage
      showAppBarOnMobile: false,
      emailMustBeVerified: true,
      mobileBottomBarBuilder: (context, child) =>
          const SizedBox(height: 0, width: 0),
      enableConnexionWithPhone: false,
      bottomNavigationBarInMobile: false,
      logoOnAuthenticationPage: true,
      whereNavigationItem: NavigationPosition.sidebar,
      completeProfilPopup: const CompleteProfilPage(),
      navigationItems: const [dz.Tuple2("default", [])],
      typeOfLogin: LoginType.email,
      settingsNodes: [
        dz.Tuple2("Modifier profil", [
          SettingsNode(
            tag: "personnnal",
            type: SettingsType.personnalData,
            children: [
              dz.Tuple2("Modifier", [
                SettingsNode(
                  tag: "description",
                  type: SettingsType.custom,
                  data: SettingsData(
                    childBuilder: (context, child) => const UpdateDescription(),
                    title: "Description",
                    subTitle: "Description de ton compte",
                  ),
                ),
                SettingsNode(
                  tag: "favorites",
                  type: SettingsType.custom,
                  data: SettingsData(
                    childBuilder: (context, child) => const UpdateTagsPage(),
                    title: "Mes passions",
                    subTitle: "voir mes passions",
                  ),
                ),
                SettingsNode(
                  tag: "additional_data",
                  type: SettingsType.custom,
                  data: SettingsData(
                    childBuilder: (context, child) => const UpdateSupplyInfo(),
                    title: "Informations additionnelles",
                    subTitle: "Fumeur, langue parlées..",
                  ),
                ),
                SettingsNode(
                  tag: "profil_picture",
                  type: SettingsType.custom,
                  data: SettingsData(
                    childBuilder: (context, child) =>
                        const UpdateProfilPictures(),
                    title: "Photos de profil",
                    subTitle: "Voir mes photos",
                  ),
                ),
              ]),
            ],
          ),
          SettingsNode(
            tag: "security",
            type: SettingsType.security,
            children: [
              dz.Tuple2("Sécurité", [
                SettingsNode(
                  tag: "email",
                  type: SettingsType.custom,
                  data: SettingsData(
                    childBuilder: (context, child) =>
                        SettingsBuilder.generateDefaultSettings(
                          type: GeneralSettingsType.email,
                        ),
                    title: "Adresse e-mail",
                    subTitle: "Modifier mon adresse e-mail",
                  ),
                ),
                SettingsNode(
                  tag: "password",
                  type: SettingsType.custom,
                  data: SettingsData(
                    childBuilder: (context, child) =>
                        SettingsBuilder.generateDefaultSettings(
                          type: GeneralSettingsType.password,
                        ),
                    title: "Mot de passe",
                    subTitle: "Modifier mon mot de passe",
                  ),
                ),
                SettingsNode(
                  tag: "phone",
                  type: SettingsType.custom,
                  data: SettingsData(
                    childBuilder: (context, child) =>
                        SettingsBuilder.generateDefaultSettings(
                          type: GeneralSettingsType.phone,
                        ),
                    title: "Numéro de téléphone",
                    subTitle: "Modifier mon numéro de téléphone",
                  ),
                ),
              ]),
            ],
          ),
          SettingsNode(
            tag: "sponsor_friend",
            type: SettingsType.custom,
            data: SettingsData(
              childBuilder: (context, child) => const ShareTrustCode(),
              title: "Code de confiance",
              subTitle: "Afficher mon code de confiance",
              prefix: Center(
                child: SvgPicture.asset(
                  "assets/svg/ic_share.svg",
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 14,
                ),
              ),
            ),
          ),
        ]),
        dz.Tuple2("Paramètres", [
          SettingsNode(
            tag: "parameters",
            type: SettingsType.switcher,
            data: SettingsData(
              activeSwitchColor: AppColor.mainColor,
              switchValue: (ref) =>
                  ref
                      .watch(userChangeNotifierProvider)
                      .userData
                      ?.enablePushNotification ??
                  false,
              onSwicth: ((context, ref, val) async {
                printInDebug("[Main] Switch notifications changé vers: $val");

                if (val) {
                  // Activation : afficher la fenêtre de permission
                  printInDebug(
                    "[Main] Activation des notifications - Affichage de la fenêtre de permission",
                  );

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PopScope(
                        canPop: false,
                        child: Scaffold(
                          body: permissions.NotificationsPermission(
                            userCollection: "/users",
                            title: "Notifications Push",
                            subtitle:
                                "Souhaitez-vous activer notre service de notifications Push ? Il vous aidera à exploiter tout le potentiel de notre application.",
                            validateText: "Activer les notifications",
                            skipText: "Passer",
                            asset:
                                "assets/images/img_permission_push_notif.png",
                            // Ne pas surcharger onValidate et onSkip
                            // Laisser NotificationsPermission gérer la logique de permission
                            // Les callbacks par défaut gèrent automatiquement :
                            // - La demande de permission système
                            // - La sauvegarde du token FCM
                            // - La fermeture de la page
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Désactivation : mettre à jour directement
                  printInDebug("[Main] Désactivation des notifications");
                  await FirebaseFirestore.instance
                      .collection(
                        GetIt.I<ApplicationDataModel>().userCollectionPath,
                      )
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                        "enablePushNotification": false,
                        "fcmToken": null, // Supprimer le token FCM
                      });
                }
              }),
              title: "Notifications Push",
              subTitle: "Activez les notifications push",
              prefix: Center(
                child: SvgPicture.asset(
                  "assets/svg/ic_notification.svg",
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 14,
                ),
              ),
            ),
          ),
        ]),
        dz.Tuple2("Autres", [
          SettingsNode(
            tag: "help",
            type: SettingsType.help,
            data: SettingsData(
              title: "Centre d'aide personnalisé",
              onTap: (context, ref) {
                //TODO : Page d'aide
              },
            ),
          ),
          SettingsNode(
            tag: "share",
            type: SettingsType.share,
            data: SettingsData(
              title: "Partager",
              onTap: (context, ref) {
                if (Platform.isAndroid) {
                  //TODO : liens de l'app
                } else if (Platform.isIOS) {}
              },
            ),
          ),
        ]),
        dz.Tuple2("Liens", [
          SettingsNode(
            tag: "privacy_policy",
            type: SettingsType.link,
            data: SettingsData(
              title: "Politique de confidentialité",
              onTap: (context, ref) {
                //TODO : lien de la politique de confidentialité
              },
            ),
          ),
          SettingsNode(
            tag: "cgu",
            type: SettingsType.link,
            data: SettingsData(
              title: "Conditions générales de ventes et d'utilisations",
              onTap: (context, ref) {
                //TODO : lien de la cgu
              },
            ),
          ),
          SettingsNode(
            tag: "legal_notice",
            type: SettingsType.link,
            data: SettingsData(
              title: "Mentions légales",
              onTap: (context, ref) {
                //TODO : lien des mentions légales
              },
            ),
          ),
          SettingsNode(
            tag: "about",
            type: SettingsType.link,
            data: SettingsData(
              title: "À propos",
              onTap: (context, ref) {
                //TODO : lien de la page à propos
              },
            ),
          ),
        ]),
        dz.Tuple2("Réseaux sociaux", [
          SettingsNode(
            tag: "instagram",
            type: SettingsType.instagram,
            data: SettingsData(
              onTap: (context, ref) {
                //TODO : lien de instagram
              },
            ),
          ),
          SettingsNode(
            tag: "tiktok",
            type: SettingsType.tiktok,
            data: SettingsData(
              onTap: (context, ref) {
                //TODO : lien de tiktok
              },
            ),
          ),
        ]),
      ],
    ),

    /// Fonction de déconnexion personnalisée qui nettoie tous les providers
    logoutFunction: (context, ref) async {
      try {
        printInDebug(
          "[Main] ========== DÉBUT DÉCONNEXION DEPUIS SETTINGS ==========",
        );
        printInDebug("[Main] Context monté au début: ${context.mounted}");
        printInDebug(
          "[Main] Utilisateur actuel: ${FirebaseAuth.instance.currentUser?.uid ?? 'null'}",
        );
        printInDebug(
          "[Main] Type de widget context: ${context.widget.runtimeType}",
        );

        // Nettoyer TOUS les providers avec des listeners Firestore AVANT la déconnexion
        // Ceci évite les erreurs PERMISSION_DENIED après déconnexion

        // 1. Provider utilisateur principal
        printInDebug("[Main] Nettoyage provider utilisateur...");
        ref.read(userChangeNotifierProvider).clear();
        printInDebug("[Main] ✓ Provider utilisateur nettoyé");

        // 2. Provider notifications
        printInDebug("[Main] Nettoyage provider notifications...");
        ref.read(notificationProvider).clear();
        printInDebug("[Main] ✓ Provider notifications nettoyé");

        // 3. Provider sponsorship
        printInDebug("[Main] Nettoyage provider sponsorship...");
        ref.read(sponsorshipProvider).clear();
        printInDebug("[Main] ✓ Provider sponsorship nettoyé");

        // 4. Provider user fiesta
        printInDebug("[Main] Nettoyage provider user fiesta...");
        ref.read(userFiestaProvider).clear();
        printInDebug("[Main] ✓ Provider user fiesta nettoyé");

        // 5. Autres providers de swipe (au cas où ils auraient des listeners)
        printInDebug("[Main] Nettoyage providers swipe...");
        ref.read(userSwipeProvider).clear();
        ref
            .read(userSwipePrefProvider)
            .reset(); // Utilise reset() au lieu de clear()
        ref.read(fiestaSwipeProvider).clear();
        ref
            .read(fiestaSwipePrefProvider)
            .reset(); // Utilise reset() au lieu de clear()
        printInDebug("[Main] ✓ Providers swipe nettoyés");

        // 6. Nettoyage des listeners Firestore dans les pages de chat
        printInDebug("[Main] Nettoyage des listeners Firestore chat...");
        try {
          // Nettoyer le SalonNotifier qui gère les listeners Salons et LastDeletedCompos
          ref.read(messageFirestoreRiver).clear();
          printInDebug("[Main] ✓ SalonNotifier nettoyé");

          // Nettoyer également le SalonMessagesNotifier
          ref.read(salonMessagesNotifier).clear();
          printInDebug("[Main] ✓ SalonMessagesNotifier nettoyé");

          // Attendre un court délai pour s'assurer que les listeners sont bien annulés
          await Future.delayed(const Duration(milliseconds: 200));

          // Annuler tous les listeners Firestore actifs
          // Ceci évite les erreurs PERMISSION_DENIED sur les collections Salons et LastDeletedCompos
          try {
            await FirebaseFirestore.instance.clearPersistence();
            printInDebug("[Main] ✓ Cache Firestore nettoyé");
          } catch (clearError) {
            printInDebug(
              "[Main] ⚠️ Erreur clearPersistence (non critique): $clearError",
            );
            // clearPersistence peut échouer si des listeners sont encore actifs
            // Ce n'est pas critique car les listeners ont déjà été annulés
          }

          printInDebug("[Main] ✓ Listeners Firestore chat nettoyés");
        } catch (e) {
          printInDebug("[Main] ⚠️ Erreur lors du nettoyage Firestore: $e");
        }

        // Vérifier l'état du contexte avant la déconnexion Firebase
        printInDebug(
          "[Main] Context monté avant déconnexion Firebase: ${context.mounted}",
        );

        // 6. Déconnexion Firebase Auth APRÈS le nettoyage des providers
        printInDebug("[Main] Déconnexion Firebase Auth en cours...");
        await FirebaseAuth.instance.signOut();
        printInDebug("[Main] ✓ Déconnexion Firebase Auth réussie");
        printInDebug(
          "[Main] Utilisateur après déconnexion: ${FirebaseAuth.instance.currentUser?.uid ?? 'null'}",
        );

        // Vérifier l'état du contexte avant la navigation
        printInDebug(
          "[Main] Context monté avant navigation: ${context.mounted}",
        );

        // 7. Rediriger vers la page de login
        if (context.mounted) {
          printInDebug("[Main] Tentative de redirection vers /login...");
          try {
            AutoRouter.of(context).replaceNamed("/login");
            printInDebug(
              "[Main] ✓ Redirection vers login effectuée avec succès",
            );
          } catch (navError) {
            printInDebug("[Main] ❌ Erreur lors de la navigation: $navError");
            printInDebug(
              "[Main] Type d'erreur navigation: ${navError.runtimeType}",
            );
            // Essayer une navigation alternative
            try {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
              printInDebug("[Main] ✓ Navigation alternative réussie");
            } catch (altNavError) {
              printInDebug(
                "[Main] ❌ Navigation alternative échouée: $altNavError",
              );
            }
          }
        } else {
          printInDebug("[Main] ❌ Context non monté - impossible de naviguer");
          if (context.mounted) {
            printInDebug("[Main] État du widget: ${context.widget}");
          }
        }

        printInDebug(
          "[Main] ========== FIN DÉCONNEXION DEPUIS SETTINGS ==========",
        );
      } catch (e) {
        printInDebug("[Main] ❌ ERREUR CRITIQUE lors de la déconnexion: $e");
        printInDebug("[Main] Type d'erreur: ${e.runtimeType}");
        printInDebug("[Main] Stack trace: ${StackTrace.current}");
        printInDebug(
          "[Main] Context monté lors de l'erreur: ${context.mounted}",
        );

        // En cas d'erreur, forcer la redirection vers login
        if (context.mounted) {
          try {
            printInDebug(
              "[Main] Tentative de redirection d'urgence vers /login...",
            );
            AutoRouter.of(context).replaceNamed("/login");
            printInDebug("[Main] ✓ Redirection d'urgence réussie");
          } catch (emergencyNavError) {
            printInDebug(
              "[Main] ❌ Redirection d'urgence échouée: $emergencyNavError",
            );
            // Dernière tentative avec Navigator classique
            try {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
              printInDebug("[Main] ✓ Navigation d'urgence alternative réussie");
            } catch (finalNavError) {
              printInDebug(
                "[Main] ❌ Toutes les tentatives de navigation ont échoué: $finalNavError",
              );
            }
          }
        } else {
          printInDebug(
            "[Main] ❌ Context non monté lors de l'erreur - impossible de naviguer",
          );
        }
      }
    },
  );

  final appThemeInitializer = (context) {
    final appTheme = AppTheme(
      themeData: ThemeData(
        fontFamily: "Poppins",
        primaryColor: AppColor.mainColor,
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoWillPopScopePageTransionsBuilder(),
            TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
          },
        ),
        sliderTheme: SliderThemeData(
          thumbColor: AppColor.mainColor,
          activeTrackColor: AppColor.mainColor,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColor.mainColor,
          circularTrackColor: AppColor.mainColor.withValues(alpha: 0.2),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        ),
      ),
    );

    appTheme.addTheme(
      "authentication_page",
      AuthenticationPageThemeData(
        cliquableTextStyle: TextStyle(
          fontSize: sp(14),
          color: Colors.black,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );

    appTheme.addTheme(
      "primary_button",
      CtaThemeData(
        widthInWeb: 370,
        widthInMobile: 317,
        height: formatHeight(54),
        gradient: AppColor.mainGradient,
        borderRadius: formatHeight(27),
        textButtonStyle: TextStyle(
          color: Colors.white,
          fontSize: sp(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    appTheme.addTheme(
      "primary_white",
      CtaThemeData(
        widthInWeb: 370,
        widthInMobile: 317,
        height: formatHeight(54),
        backgroundColor: Colors.white,
        borderRadius: formatHeight(27),
        textButtonStyle: TextStyle(
          color: Colors.black,
          fontSize: sp(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    appTheme.addTheme(
      "primary_border_white",
      CtaThemeData(
        widthInWeb: 370,
        widthInMobile: 317,
        height: formatHeight(54),
        backgroundColor: Colors.transparent,
        border: Border.all(
          color: Colors.white.withValues(alpha: .39),
          width: .5,
        ),
        borderRadius: formatHeight(27),
        textButtonStyle: TextStyle(
          color: Colors.white,
          fontSize: sp(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    appTheme.addTheme(
      "red_button",
      CtaThemeData(
        widthInWeb: 370,
        widthInMobile: 317,
        height: formatHeight(54),
        backgroundColor: const Color(0xFFF03333),
        borderRadius: formatHeight(27),
        textButtonStyle: TextStyle(
          color: Colors.white,
          fontSize: sp(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    appTheme.addTheme(
      "main_button",
      CtaThemeData(
        widthInWeb: 370,
        widthInMobile: 317,
        heightInMobile: formatHeight(34),
        height: formatHeight(34),
        backgroundColor: AppColor.mainColor,
        borderRadius: 100,
        textButtonStyle: TextStyle(
          color: Colors.white,
          fontSize: sp(12),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    appTheme.addTheme(
      "secondary_button",
      CtaThemeData(
        widthInWeb: 370,
        widthInMobile: 317,
        height: formatHeight(54),
        borderRadius: formatHeight(27),
        textButtonStyle: TextStyle(
          color: AppColor.mainColor,
          fontSize: sp(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    appTheme.addTheme(
      "back_button",
      const CtaThemeData(backgroundColor: Colors.transparent),
    );

    appTheme.addTheme(
      "toggle_switch",
      ToggleSwitchThemeData(
        activeColor: AppColor.mainColor,
        itemStyle: AppTextStyle.gray(12, FontWeight.w500),
        itemActiveStyle: AppTextStyle.white(12, FontWeight.w600),
      ),
    );

    appTheme.addTheme(
      "dropdown_multi_select",
      DropDownMultiSelectThemeData(
        childActiveDecoration: BoxDecoration(gradient: AppColor.mainGradient),
        childActiveTextStyle: TextStyle(
          color: Colors.white,
          fontSize: sp(11),
          fontWeight: FontWeight.w500,
        ),
        childTextStyle: TextStyle(
          color: Colors.black,
          fontSize: sp(11),
          fontWeight: FontWeight.w500,
        ),
        checkedColor: Colors.white,
      ),
    );

    appTheme.addTheme(
      "multi_item_selector",
      MultiItemSelectorThemeData(
        itemStyle: TextStyle(
          color: AppColor.mainColor,
          fontSize: sp(11),
          fontWeight: FontWeight.w500,
        ),
        itemActiveStyle: TextStyle(
          color: Colors.white,
          fontSize: sp(11),
          fontWeight: FontWeight.w500,
        ),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 1, color: AppColor.mainColor),
        ),
        itemActiveDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: AppColor.mainGradient,
        ),
        itemPadding: EdgeInsets.symmetric(
          horizontal: formatWidth(14),
          vertical: formatHeight(5.5),
        ),
      ),
    );

    appTheme.addTheme(
      "input_field",
      CustomFormFieldThemeData(
        fieldPostRedirectionStyle: TextStyle(
          color: AppColor.mainColor,
          fontSize: sp(12),
          fontWeight: FontWeight.w600,
        ),
        fieldNameStyle: TextStyle(
          fontSize: sp(12),
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: formatWidth(22),
          vertical: formatHeight(16),
        ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(formatHeight(27)),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(formatHeight(27)),
          borderSide: const BorderSide(color: Colors.red, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(formatHeight(27)),
          borderSide: const BorderSide(color: Colors.redAccent, width: 0.5),
        ),
      ),
    );

    appTheme.addTheme(
      "skeleton_page_padding_phone",
      EdgeInsets.symmetric(horizontal: formatWidth(22)),
    );
    appTheme.addTheme(
      "skeleton_page_padding_tablet",
      EdgeInsets.symmetric(horizontal: formatWidth(22)),
    );
    appTheme.addTheme("skeleton_icon_size_phone_width", formatWidth(83));

    // Couleur de fond pour les pages d'authentification
    appTheme.addTheme("skeleton_authentication_scaffold_color", Colors.white);

    // Couleur de fond pour les cartes personnalisées
    appTheme.addTheme("custom_card_background_color", Colors.white);

    return appTheme;
  };

  return await LaunchApplication.launch(
    applicationModel: appModel,
    appRouter: AppRouter(
      loginGuard: LoginGuard(),
      alreadyLoggedGuard: AlreadyLoggedGuard(),
      logoutGuard: LogoutGuard(),
    ),
    initTheme: appThemeInitializer,
  );
}

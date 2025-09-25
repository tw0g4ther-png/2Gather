import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:twogather/controller/complete_profil_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/pages/complete_profil/chart.dart';
import 'package:twogather/pages/complete_profil/choose_passion.dart';
import 'package:twogather/pages/complete_profil/profil_data.dart';
import 'package:twogather/pages/complete_profil/second_profil_data.dart';
import 'package:twogather/pages/complete_profil/trust_code.dart';
import 'package:twogather/pages/home/upload_images/choose_images_page.dart';
import 'package:twogather/pages/home/upload_images/upload_identity_card_page.dart';
import 'package:twogather/provider/complete_profil_provider.dart';
import 'package:twogather/services/storage.dart';
import 'package:twogather/services/trust_code_rate_limiter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
import 'dart:io';

// Imports pour les providers nécessaires au nettoyage lors de la déconnexion
import 'package:twogather/main.dart';
import 'package:twogather/chat/riverpods/salon_river.dart';

final completeProfilProvider =
    ChangeNotifierProvider.autoDispose<CompleteProfilProvider>(
      (_) => CompleteProfilProvider(),
    );

@RoutePage()
class CompleteProfilPage extends StatefulHookConsumerWidget {
  const CompleteProfilPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompleteProfilPageState();
}

class _CompleteProfilPageState extends ConsumerState<CompleteProfilPage> {
  final appModel = GetIt.I<ApplicationDataModel>();

  // État pour gérer le flux d'upload des images
  int _currentImageUploadStep =
      0; // 0: images profil, 1: carte identité, 2: terminé

  // StreamSubscription pour écouter les changements d'authentification
  StreamSubscription<User?>? _authStateSubscription;
  String? _lastKnownUserId;

  @override
  void initState() {
    ref.read(completeProfilProvider);
    _initAuthStateListener();
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  /// Initialise l'écoute des changements d'état d'authentification
  void _initAuthStateListener() {
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      if (user != null) {
        final currentUserId = user.uid;

        // Si c'est une reconnexion (utilisateur différent OU même utilisateur après déconnexion)
        if (_lastKnownUserId != null && _lastKnownUserId != currentUserId) {
          printInDebug(
            "[CompleteProfilPage] Changement d'utilisateur détecté: $_lastKnownUserId → $currentUserId",
          );
          _handleUserReconnection(currentUserId);
        } else if (_lastKnownUserId == null) {
          printInDebug(
            "[CompleteProfilPage] Reconnexion détectée pour l'utilisateur: $currentUserId",
          );
          _handleUserReconnection(currentUserId);
        }

        _lastKnownUserId = currentUserId;
      } else {
        // Utilisateur déconnecté
        printInDebug("[CompleteProfilPage] Déconnexion détectée");
        _lastKnownUserId = null;
      }
    });
  }

  /// Gère la reconnexion d'un utilisateur
  Future<void> _handleUserReconnection(String userId) async {
    try {
      printInDebug(
        "[CompleteProfilPage] Gestion de la reconnexion pour l'utilisateur: $userId",
      );

      // Vérifier le statut actuel de l'utilisateur dans Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection(appModel.userCollectionPath)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final currentStatus = userData['completeProfilStatus'] as String?;

        printInDebug(
          "[CompleteProfilPage] Statut actuel de l'utilisateur reconnecté: $currentStatus",
        );

        // Vérifier si le profil est déjà complet
        final isProfileCompleted =
            userData['profilCompleted'] as bool? ?? false;
        if (isProfileCompleted) {
          printInDebug(
            "[CompleteProfilPage] Profil déjà complet - Redirection vers le dashboard",
          );
          if (mounted) {
            AutoRouter.of(context).replaceNamed("/dashboard/home");
          }
          return;
        }

        // Si l'utilisateur était en erreur, vérifier s'il peut reprendre le processus
        if (currentStatus == "error") {
          printInDebug(
            "[CompleteProfilPage] Utilisateur en erreur - Vérification des données pour reprise possible",
          );

          // Vérifier si l'utilisateur a des données de base (email, nom, etc.)
          final hasBasicData =
              userData['email'] != null &&
              userData['firstname'] != null &&
              userData['lastname'] != null;

          if (hasBasicData) {
            // Réinitialiser le statut pour permettre la reprise du processus
            await FirebaseFirestore.instance
                .collection(appModel.userCollectionPath)
                .doc(userId)
                .update({
                  "completeProfilStatus":
                      null, // Remettre à null pour reprendre le flux normal
                });

            printInDebug(
              "[CompleteProfilPage] Statut réinitialisé - L'utilisateur peut reprendre le processus",
            );

            // Forcer le rebuild de l'interface après un court délai
            if (mounted) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  setState(() {});
                  printInDebug(
                    "[CompleteProfilPage] Interface mise à jour après reconnexion",
                  );
                }
              });
            }
          } else {
            printInDebug(
              "[CompleteProfilPage] Données de base manquantes - Maintien du statut d'erreur",
            );
          }
        }
      }
    } catch (e) {
      printInDebug(
        "[CompleteProfilPage] Erreur lors de la gestion de la reconnexion: $e",
      );
    }
  }

  /// Vérifie si les images de profil sont manquantes ou vides
  bool _areProfileImagesMissing(FiestarUserModel userData) {
    return userData.profilImages?.isEmpty ?? true;
  }

  /// Vérifie si la carte d'identité est manquante
  /// Note: Le champ identityCard n'existe pas encore dans le modèle,
  /// on vérifie via Firestore directement
  Future<bool> _isIdentityCardMissing() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(appModel.userCollectionPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      final data = doc.data();
      final identityCard = data?['identityCard'] as String?;
      return identityCard?.isEmpty ?? true;
    } catch (e) {
      printInDebug(
        "[CompleteProfilPage] Erreur lors de la vérification de la carte d'identité: $e",
      );
      return true; // En cas d'erreur, considérer comme manquante
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry dPadding = getResponsiveValue(
      context,
      defaultValue: EdgeInsets.zero,
      phone: loadThemeData(
        null,
        "skeleton_page_padding_phone",
        () => EdgeInsets.zero,
      ),
      tablet: loadThemeData(
        null,
        "skeleton_page_padding_tablet",
        () => EdgeInsets.zero,
      ),
    )!;

    if ((ref.watch(userChangeNotifierProvider).userData as FiestarUserModel)
            .profilCompleted ??
        false) {
      execAfterBuild(() {
        if (!mounted) return;
        Navigator.pop(context);
      });
    }

    final userData =
        ref.watch(userChangeNotifierProvider).userData as FiestarUserModel;
    printInDebug(
      "[CompleteProfilPage] Build() appelé - Statut actuel: ${userData.completeProfilStatus}",
    );
    printInDebug(
      "[CompleteProfilPage] ProfilCompleted: ${userData.profilCompleted}",
    );

    if (userData.completeProfilStatus == "waiting") {
      printInDebug(
        "[CompleteProfilPage] Condition 'waiting' = TRUE - Vérification des images manquantes",
      );

      // Vérifier si des images sont manquantes
      final bool profileImagesMissing = _areProfileImagesMissing(userData);

      return FutureBuilder<bool>(
        future: _isIdentityCardMissing(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichage du loader pendant la vérification
            return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final bool identityCardMissing = snapshot.data ?? true;

          // Si des images sont manquantes, afficher le flux d'upload
          if (profileImagesMissing || identityCardMissing) {
            printInDebug(
              "[CompleteProfilPage] Images manquantes détectées - Images profil: $profileImagesMissing, Carte identité: $identityCardMissing",
            );
            return _buildImageUploadFlow(
              profileImagesMissing,
              identityCardMissing,
            );
          }

          // Sinon, afficher la page d'attente normale
          printInDebug(
            "[CompleteProfilPage] Toutes les images sont présentes - Affichage de la page d'attente normale",
          );
          return _buildWaitingPage();
        },
      );
    } else if (userData.completeProfilStatus == "error") {
      printInDebug(
        "[CompleteProfilPage] Condition 'error' = TRUE - Affichage de la page d'erreur",
      );
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                sh(20),
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: ImageWithSmartFormat(
                              path: "assets/images/img_logo.png",
                              type: appModel.logoFormat,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: IconButton(
                          icon: const Icon(Icons.logout_rounded),
                          color: Colors.black,
                          iconSize: formatWidth(25),
                          onPressed: () => _logoutUser(context, ref),
                        ),
                      ),
                    ),
                  ],
                ),
                sh(40),
                Text(
                  "app.error-title".tr(),
                  style: AppTextStyle.black(24),
                  textAlign: TextAlign.center,
                ),
                sh(14),
                Text(
                  "app.bad-code".tr(),
                  style: AppTextStyle.black(16, FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                sh(12),
                Text(
                  "app.bad-code-desc".tr(),
                  style: TextStyle(color: Colors.black, fontSize: sp(13)),
                  textAlign: TextAlign.center,
                ),
                sh(60),
                CTA.primary(
                  textButton: "app.try-with-other-code".tr(),
                  onTap: () async {
                    _reopenTrustCode(context, dPadding);
                  },
                ),
                sh(15),
                CTA.secondary(
                  textButton: "app.no-trust-code".tr(),
                  onTap: () {
                    // TODO : Action pour "Je n'ai pas de code de confiance"
                  },
                ),
                sh(12),
              ],
            ),
          ),
        ),
      );
    }

    printInDebug(
      "[CompleteProfilPage] Aucune condition spéciale - Affichage du flux normal de complétion de profil",
    );
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            sh(12),
            Padding(
              padding: dPadding,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: formatHeight(12)),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: SizedBox(
                          height: formatHeight(90),
                          child: ImageWithSmartFormat(
                            path: appModel.appLogo,
                            type: appModel.logoFormat,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (ref.watch(completeProfilProvider).pageIndex != 0)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () =>
                            ref.read(completeProfilProvider).prevPage(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(25),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            sh(40),
            ExpandablePageView(
              controller: ref.read(completeProfilProvider).pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: dPadding,
                  child: TrustCodePage(
                    onSubmit: () => ref.read(completeProfilProvider).nextPage(),
                  ),
                ),
                Padding(
                  padding: dPadding,
                  child: ProfilData(
                    onSubmit: () => ref.read(completeProfilProvider).nextPage(),
                  ),
                ),
                Padding(
                  padding: dPadding,
                  child: ChoosePassion(
                    onSubmit: () => ref.read(completeProfilProvider).nextPage(),
                  ),
                ),
                Padding(
                  padding: dPadding,
                  child: SecondProfilData(
                    onSubmit: () => ref.read(completeProfilProvider).nextPage(),
                  ),
                ),
                // Étapes d'images supprimées: elles sont désormais gérées dans HomePage
                Padding(
                  padding: dPadding,
                  child: FiestChart(
                    onSubmit: () async {
                      try {
                        final code = ref.read(completeProfilProvider).trustCode;

                        // 1. Vérifier si l'utilisateur peut tenter une validation
                        final canAttempt =
                            await TrustCodeRateLimiter.canAttemptValidation();
                        if (!canAttempt) {
                          final remainingMinutes =
                              await TrustCodeRateLimiter.getRemainingBlockTimeMinutes();
                          final formattedTime =
                              TrustCodeRateLimiter.formatRemainingTime(
                                remainingMinutes,
                              );

                          if (context.mounted) {
                            NotifBanner.showToast(
                              context: context,
                              fToast: FToast().init(context),
                              title: "Trop de tentatives !",
                              subTitle:
                                  "Vous avez fait trop de tentatives échouées. Réessayez dans $formattedTime.",
                              backgroundColor: Colors.red,
                            );
                          }
                          return;
                        }

                        // 2. Valider le code de confiance
                        printInDebug(
                          "[CompleteProfilPage] Validation du code de confiance: $code",
                        );
                        final isValid = code == null
                            ? false
                            : await CompleteProfilController.verifyTrustCodeDirect(
                                code,
                              );

                        if (!isValid) {
                          // Enregistrer la tentative échouée
                          await TrustCodeRateLimiter.recordFailedAttempt();

                          // Vérifier si l'utilisateur est maintenant bloqué
                          final isNowBlocked =
                              !await TrustCodeRateLimiter.canAttemptValidation();
                          final attemptsCount =
                              await TrustCodeRateLimiter.getRecentFailedAttemptsCount();

                          String title = "Code invalide !";
                          String subtitle =
                              "Ce code de confiance n'existe pas ou n'est plus valide.";

                          if (isNowBlocked) {
                            title = "Compte temporairement bloqué !";
                            subtitle =
                                "Trop de tentatives échouées (5/5). Votre compte est bloqué pendant 3 heures.";
                          } else {
                            subtitle +=
                                " Tentatives restantes: ${5 - attemptsCount}/5";
                          }

                          if (context.mounted) {
                            NotifBanner.showToast(
                              context: context,
                              fToast: FToast().init(context),
                              title: title,
                              subTitle: subtitle,
                              backgroundColor: isNowBlocked
                                  ? Colors.red
                                  : Colors.orange,
                            );
                          }

                          // Afficher l'écran d'erreur: marquer le profil en erreur et stopper ici
                          await FirebaseFirestore.instance
                              .collection(
                                GetIt.instance<ApplicationDataModel>()
                                    .userCollectionPath,
                              )
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({"completeProfilStatus": "error"});
                          return;
                        }

                        // Code valide - réinitialiser les tentatives
                        await TrustCodeRateLimiter.resetAttempts();

                        // 2. Créer le document sponsorship (code valide garanti ici)
                        final success =
                            await CompleteProfilController.createSponsorshipDirect(
                              code,
                            );
                        if (!success) {
                          throw Exception(
                            "Échec de la création du document sponsorship",
                          );
                        }

                        // 3. Mettre à jour le statut dans Firestore ET dans le provider local
                        await FirebaseFirestore.instance
                            .collection(
                              GetIt.instance<ApplicationDataModel>()
                                  .userCollectionPath,
                            )
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({"completeProfilStatus": "waiting"});

                        // 4. Forcer la mise à jour du UserProvider avec le nouveau statut
                        final userProvider = ref.read(
                          userChangeNotifierProvider,
                        );
                        if (userProvider.userData != null) {
                          final updatedUserData =
                              userProvider.userData as FiestarUserModel;
                          // Créer une nouvelle instance avec le statut mis à jour
                          final newUserData = updatedUserData.copyWith(
                            completeProfilStatus: 'waiting',
                          );
                          // Mettre à jour le provider avec les nouvelles données
                          userProvider.userData = newUserData;
                          printInDebug(
                            "[CompleteProfilPage] UserProvider mis à jour avec statut 'waiting'",
                          );
                        }

                        // 5. Marquer aussi dans le completeProfilProvider pour cohérence
                        ref
                            .read(completeProfilProvider)
                            .addFieldToData("completeProfilStatus", "waiting");

                        printInDebug(
                          "[CompleteProfilPage] Profil finalisé avec succès - Les images seront demandées dans FriendHomePage",
                        );

                        // 6. Déclencher un rebuild pour afficher l'interface "waiting"
                        if (context.mounted && mounted) {
                          printInDebug(
                            "[CompleteProfilPage] Déclenchement du rebuild pour afficher l'interface 'waiting'",
                          );

                          // Forcer le rebuild du widget pour que la condition "waiting" soit réévaluée
                          setState(() {});
                          printInDebug(
                            "[CompleteProfilPage] Rebuild déclenché - Interface 'waiting' devrait s'afficher",
                          );
                        }
                      } catch (e) {
                        // Gestion d'erreur spécifique selon le type d'erreur
                        String title = "Erreur !";
                        String subtitle =
                            "Une erreur s'est produite lors de la finalisation de votre profil.";

                        if (e.toString().contains(
                          "Code de confiance invalide",
                        )) {
                          title = "Code invalide !";
                          subtitle =
                              "Ce code de confiance n'existe pas ou n'est plus valide.";
                        } else if (e.toString().contains(
                          "Échec de la création du document sponsorship",
                        )) {
                          title = "Erreur de parrainage !";
                          subtitle =
                              "Impossible de créer la demande de parrainage. Veuillez réessayer.";
                        }

                        // Marquer le profil en erreur
                        await FirebaseFirestore.instance
                            .collection(
                              GetIt.instance<ApplicationDataModel>()
                                  .userCollectionPath,
                            )
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({"completeProfilStatus": "error"});

                        // Afficher l'erreur à l'utilisateur
                        if (context.mounted) {
                          NotifBanner.showToast(
                            context: context,
                            fToast: FToast().init(context),
                            title: title,
                            subTitle: subtitle,
                          );
                        }

                        printInDebug(
                          "[CompleteProfilPage] Erreur lors de la finalisation du profil: $e",
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            sh(12),
          ],
        ),
      ),
    );
  }

  void _reopenTrustCode(BuildContext context, EdgeInsetsGeometry dPadding) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                primary: false,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    sh(12),
                    Padding(
                      padding: dPadding,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: ImageWithSmartFormat(
                                    path: "assets/images/img_logo.png",
                                    type: appModel.logoFormat,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.black,
                                size: formatWidth(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sh(40),
                    Padding(
                      padding: dPadding,
                      child: TrustCodePage(
                        onSubmit: () async {
                          try {
                            final code = ref
                                .read(completeProfilProvider)
                                .data["trustCode"];

                            // 1. Vérifier si l'utilisateur peut tenter une validation
                            final canAttempt =
                                await TrustCodeRateLimiter.canAttemptValidation();
                            if (!canAttempt) {
                              final remainingMinutes =
                                  await TrustCodeRateLimiter.getRemainingBlockTimeMinutes();
                              final formattedTime =
                                  TrustCodeRateLimiter.formatRemainingTime(
                                    remainingMinutes,
                                  );

                              if (context.mounted) {
                                NotifBanner.showToast(
                                  context: context,
                                  fToast: FToast().init(context),
                                  title: "Trop de tentatives !",
                                  subTitle:
                                      "Vous avez fait trop de tentatives échouées. Réessayez dans $formattedTime.",
                                  backgroundColor: Colors.red,
                                );
                              }
                              return;
                            }

                            // 2. Valider le code de confiance avant de continuer
                            printInDebug(
                              "[CompleteProfilPage] Validation du code de confiance: $code",
                            );
                            final isValid =
                                await CompleteProfilController.verifyTrustCodeDirect(
                                  code,
                                );

                            if (!isValid) {
                              // Enregistrer la tentative échouée
                              await TrustCodeRateLimiter.recordFailedAttempt();

                              // Vérifier si l'utilisateur est maintenant bloqué
                              final isNowBlocked =
                                  !await TrustCodeRateLimiter.canAttemptValidation();
                              final attemptsCount =
                                  await TrustCodeRateLimiter.getRecentFailedAttemptsCount();

                              String title = "Code invalide !";
                              String subtitle =
                                  "Ce code de confiance n'existe pas ou n'est plus valide.";

                              if (isNowBlocked) {
                                title = "Compte temporairement bloqué !";
                                subtitle =
                                    "Trop de tentatives échouées (5/5). Votre compte est bloqué pendant 3 heures.";
                              } else {
                                subtitle +=
                                    " Tentatives restantes: ${5 - attemptsCount}/5";
                              }

                              if (context.mounted) {
                                NotifBanner.showToast(
                                  context: context,
                                  fToast: FToast().init(context),
                                  title: title,
                                  subTitle: subtitle,
                                  backgroundColor: isNowBlocked
                                      ? Colors.red
                                      : Colors.orange,
                                );
                              }

                              // Afficher l'écran d'erreur en marquant le statut à error
                              await FirebaseFirestore.instance
                                  .collection(
                                    GetIt.instance<ApplicationDataModel>()
                                        .userCollectionPath,
                                  )
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({"completeProfilStatus": "error"});
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              return;
                            }

                            // Code valide - réinitialiser les tentatives
                            await TrustCodeRateLimiter.resetAttempts();

                            // Créer le document sponsorship d'abord
                            final success =
                                await CompleteProfilController.createSponsorshipDirect(
                                  code,
                                );
                            if (!success) {
                              throw Exception(
                                "Échec de la création du document sponsorship",
                              );
                            }

                            // Mettre à jour le statut dans Firestore
                            await FirebaseFirestore.instance
                                .collection(
                                  GetIt.instance<ApplicationDataModel>()
                                      .userCollectionPath,
                                )
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                                  "trustCode": code,
                                  "completeProfilStatus": "waiting",
                                });

                            // Forcer la mise à jour du UserProvider avec le nouveau statut
                            final userProvider = ref.read(
                              userChangeNotifierProvider,
                            );
                            if (userProvider.userData != null) {
                              final updatedUserData =
                                  userProvider.userData as FiestarUserModel;
                              final newUserData = updatedUserData.copyWith(
                                completeProfilStatus: 'waiting',
                                trustCode: code,
                              );
                              userProvider.userData = newUserData;
                              printInDebug(
                                "[CompleteProfilPage] UserProvider mis à jour depuis _reopenTrustCode avec statut 'waiting'",
                              );
                            }

                            printInDebug(
                              "[CompleteProfilPage] Profil finalisé avec succès depuis _reopenTrustCode - Statut mis à 'waiting'",
                            );

                            if (!context.mounted) return;
                            Navigator.of(context).pop();

                            // Forcer le rebuild de la page principale après fermeture du dialog
                            if (mounted) {
                              printInDebug(
                                "[CompleteProfilPage] Appel de setState() pour forcer le rebuild",
                              );
                              setState(() {});
                            }

                            printInDebug(
                              "[CompleteProfilPage] Interface mise à jour - Affichage de la page d'attente",
                            );
                          } catch (e) {
                            // En cas d'erreur technique, marquer aussi en erreur
                            await FirebaseFirestore.instance
                                .collection(
                                  GetIt.instance<ApplicationDataModel>()
                                      .userCollectionPath,
                                )
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({"completeProfilStatus": "error"});

                            printInDebug(
                              "Erreur lors de la réouverture du code de confiance: $e",
                            );
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    sh(12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construit la page d'attente normale (sans images manquantes)
  Widget _buildWaitingPage() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              sh(12),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: ImageWithSmartFormat(
                            path: "assets/images/img_logo.png",
                            type: appModel.logoFormat,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: IconButton(
                        icon: const Icon(Icons.logout_rounded),
                        color: Colors.black,
                        iconSize: formatWidth(25),
                        onPressed: () => _logoutUser(context, ref),
                      ),
                    ),
                  ),
                ],
              ),
              sh(40),
              const Spacer(),
              LoaderClassique(radius: formatWidth(15)),
              sh(14),
              Text(
                "app.await-validate".tr(),
                style: AppTextStyle.black(24),
                textAlign: TextAlign.center,
              ),
              sh(9),
              Text(
                "app.godfather-must-accept".tr(),
                style: AppTextStyle.darkGray(13, FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CTA.primary(
                textButton: "utils.update".tr(),
                onTap: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
              ),
              sh(12),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit le flux d'upload des images manquantes
  Widget _buildImageUploadFlow(
    bool profileImagesMissing,
    bool identityCardMissing,
  ) {
    printInDebug(
      "[CompleteProfilPage] _buildImageUploadFlow appelé - Images profil manquantes: $profileImagesMissing, Carte identité manquante: $identityCardMissing, Étape actuelle: $_currentImageUploadStep",
    );

    // Déterminer quelle étape afficher en premier
    if (profileImagesMissing && _currentImageUploadStep == 0) {
      return _buildProfileImagesUpload();
    } else if (identityCardMissing &&
        (_currentImageUploadStep == 1 || !profileImagesMissing)) {
      return _buildIdentityCardUpload();
    } else {
      // Toutes les images ont été uploadées, retourner à la page d'attente
      return _buildWaitingPage();
    }
  }

  /// Construit la page d'upload des images de profil
  Widget _buildProfileImagesUpload() {
    return ChooseImagesPage(
      onSubmit: (List<File> images) async {
        try {
          printInDebug(
            "[CompleteProfilPage] Upload des images de profil: ${images.length} images",
          );

          // Upload des images vers Firebase Storage
          final List<String> uploadedUrls = [];
          for (final image in images) {
            final url = await StorageController.uploadToStorage(
              image,
              "users/${FirebaseAuth.instance.currentUser!.uid}/profil/",
            );
            if (url != null) {
              uploadedUrls.add(url);
            }
          }

          if (uploadedUrls.isNotEmpty) {
            // Mettre à jour Firestore avec les nouvelles images
            await FirebaseFirestore.instance
                .collection(appModel.userCollectionPath)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
                  "profilImages": uploadedUrls,
                  "profilImage": uploadedUrls
                      .first, // La première image devient l'image principale
                });

            printInDebug(
              "[CompleteProfilPage] Images de profil sauvegardées avec succès",
            );

            // Passer à l'étape suivante
            setState(() {
              _currentImageUploadStep = 1;
            });
          }
        } catch (e) {
          printInDebug(
            "[CompleteProfilPage] Erreur lors de l'upload des images de profil: $e",
          );
          if (mounted) {
            NotifBanner.showToast(
              context: context,
              fToast: FToast().init(context),
              title: "Erreur",
              subTitle:
                  "Impossible d'uploader les images de profil. Veuillez réessayer.",
            );
          }
        }
      },
    );
  }

  /// Construit la page d'upload de la carte d'identité
  Widget _buildIdentityCardUpload() {
    return UploadIdentityCardPage(
      onSubmit: (File identityCard) async {
        try {
          printInDebug("[CompleteProfilPage] Upload de la carte d'identité");

          // Upload de la carte d'identité vers Firebase Storage
          final url = await StorageController.uploadToStorage(
            identityCard,
            "users/${FirebaseAuth.instance.currentUser!.uid}/identity/",
          );

          if (url != null) {
            // Mettre à jour Firestore avec la carte d'identité
            await FirebaseFirestore.instance
                .collection(appModel.userCollectionPath)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({"identityCard": url});

            printInDebug(
              "[CompleteProfilPage] Carte d'identité sauvegardée avec succès",
            );

            // Terminer le flux d'upload
            setState(() {
              _currentImageUploadStep = 2;
            });
          }
        } catch (e) {
          printInDebug(
            "[CompleteProfilPage] Erreur lors de l'upload de la carte d'identité: $e",
          );
          if (mounted) {
            NotifBanner.showToast(
              context: context,
              fToast: FToast().init(context),
              title: "Erreur",
              subTitle:
                  "Impossible d'uploader la carte d'identité. Veuillez réessayer.",
            );
          }
        }
      },
    );
  }

  /// Déconnecte l'utilisateur et le redirige vers la page de login
  Future<void> _logoutUser(BuildContext context, WidgetRef ref) async {
    // Afficher un dialogue de confirmation avant la déconnexion
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "authentication.logout.confirm-title".tr(),
            style: AppTextStyle.black(18, FontWeight.w600),
          ),
          content: Text(
            "authentication.logout.confirm-message".tr(),
            style: AppTextStyle.darkGray(16),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CTA.secondary(
                    textButton: "authentication.logout.confirm-no".tr(),
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CTA.primary(
                    textButton: "authentication.logout.confirm-yes".tr(),
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    // Si l'utilisateur confirme la déconnexion
    if (shouldLogout == true) {
      try {
        printInDebug(
          "[CompleteProfilPage] Début de la déconnexion - nettoyage des providers",
        );

        // Nettoyer TOUS les providers avec des listeners Firestore AVANT la déconnexion
        // Ceci évite les erreurs PERMISSION_DENIED après déconnexion

        // 1. Provider utilisateur principal
        ref.read(userChangeNotifierProvider).clear();
        printInDebug("[CompleteProfilPage] Provider utilisateur nettoyé");

        // 2. Provider notifications
        ref.read(notificationProvider).clear();
        printInDebug("[CompleteProfilPage] Provider notifications nettoyé");

        // 3. Provider sponsorship
        ref.read(sponsorshipProvider).clear();
        printInDebug("[CompleteProfilPage] Provider sponsorship nettoyé");

        // 4. Provider user fiesta
        ref.read(userFiestaProvider).clear();
        printInDebug("[CompleteProfilPage] Provider user fiesta nettoyé");

        // 5. Autres providers de swipe (au cas où ils auraient des listeners)
        ref.read(userSwipeProvider).clear();
        ref
            .read(userSwipePrefProvider)
            .reset(); // Utilise reset() au lieu de clear()
        ref.read(fiestaSwipeProvider).clear();
        ref
            .read(fiestaSwipePrefProvider)
            .reset(); // Utilise reset() au lieu de clear()
        printInDebug("[CompleteProfilPage] Providers swipe nettoyés");

        // 6. Nettoyage des listeners Firestore dans les pages de chat
        printInDebug(
          "[CompleteProfilPage] Nettoyage des listeners Firestore chat...",
        );
        try {
          // Nettoyer le SalonNotifier qui gère les listeners Salons et LastDeletedCompos
          ref.read(messageFirestoreRiver).clear();
          printInDebug("[CompleteProfilPage] ✓ SalonNotifier nettoyé");

          // Nettoyer également le SalonMessagesNotifier
          ref.read(salonMessagesNotifier).clear();
          printInDebug("[CompleteProfilPage] ✓ SalonMessagesNotifier nettoyé");

          // Attendre un court délai pour s'assurer que les listeners sont bien annulés
          await Future.delayed(const Duration(milliseconds: 200));

          // Annuler tous les listeners Firestore actifs
          // Ceci évite les erreurs PERMISSION_DENIED sur les collections Salons et LastDeletedCompos
          try {
            await FirebaseFirestore.instance.clearPersistence();
            printInDebug("[CompleteProfilPage] ✓ Cache Firestore nettoyé");
          } catch (clearError) {
            printInDebug(
              "[CompleteProfilPage] ⚠️ Erreur clearPersistence (non critique): $clearError",
            );
            // clearPersistence peut échouer si des listeners sont encore actifs
            // Ce n'est pas critique car les listeners ont déjà été annulés
          }

          printInDebug(
            "[CompleteProfilPage] ✓ Listeners Firestore chat nettoyés",
          );
        } catch (e) {
          printInDebug(
            "[CompleteProfilPage] ⚠️ Erreur lors du nettoyage Firestore: $e",
          );
        }

        // 6. Déconnexion Firebase Auth APRÈS le nettoyage des providers
        await FirebaseAuth.instance.signOut();
        printInDebug("[CompleteProfilPage] Déconnexion Firebase Auth réussie");

        // 7. Rediriger vers la page de login en vidant toute la pile de navigation
        if (context.mounted) {
          // Vider complètement la pile de navigation
          final router = AutoRouter.of(context);
          // Supprimer toutes les routes jusqu'à la racine
          router.popUntilRoot();
          // Puis naviguer vers login
          router.pushNamed("/login");
          printInDebug(
            "[CompleteProfilPage] Redirection vers login effectuée avec pile vidée",
          );
        }
      } catch (e) {
        printInDebug("[CompleteProfilPage] Erreur lors de la déconnexion: $e");
        // En cas d'erreur, forcer la redirection vers login avec pile vidée
        if (context.mounted) {
          final router = AutoRouter.of(context);
          router.popUntilRoot();
          router.pushNamed("/login");
        }
      }
    }
  }
}

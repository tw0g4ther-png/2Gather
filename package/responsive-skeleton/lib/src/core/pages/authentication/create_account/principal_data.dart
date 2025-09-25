// ignore_for_file: must_call_super

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
import 'package:universal_io/io.dart';

// Provider pour la création de compte
final createAccountProvider = ChangeNotifierProvider<CreateAccountProvider>(
  (ref) => CreateAccountProvider(ref),
);

class PrincipalData extends StatefulHookConsumerWidget {
  final bool haveRepeatPassword;
  final bool isLoginById;
  final bool isLast;
  final bool createAccount;
  final PageController controller;

  const PrincipalData({
    super.key,
    required this.controller,
    this.haveRepeatPassword = true,
    this.isLoginById = false,
    this.isLast = false,
    this.createAccount = true,
  });

  @override
  ConsumerState<PrincipalData> createState() => _PrincipalDataState();
}

class _PrincipalDataState extends ConsumerState<PrincipalData>
    with AutomaticKeepAliveClientMixin<PrincipalData> {
  String? email;
  String? password;
  String? repeatPassword;
  bool _isLoadingGoogle = false;
  bool _isLoadingApple = false;

  final fToast = FToast();
  final GlobalKey<FormState> key = GlobalKey();

  //Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController rPassController = TextEditingController();

  //FocusNode
  final FocusNode emailNode = FocusNode();
  final FocusNode passNode = FocusNode();
  final FocusNode rPassNode = FocusNode();

  final appModel = GetIt.instance<ApplicationDataModel>();
  late final AuthenticationPageThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = loadThemeData(
      null,
      "authentication_page",
      () => const AuthenticationPageThemeData(),
    )!;
    fToast.init(context);

    // Réinitialiser les loaders au démarrage
    _isLoadingGoogle = false;
    _isLoadingApple = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    emailNode.dispose();
    passController.dispose();
    passNode.dispose();
    rPassController.dispose();
    rPassNode.dispose();
    super.dispose();
  }

  /// Inscription avec Google
  Future<void> _signInWithGoogle() async {
    if (!mounted) return;

    // Vérifier si un processus est déjà en cours
    if (_isLoadingGoogle) return;

    setState(() => _isLoadingGoogle = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      // Nettoyer toute session précédente pour éviter les conflits d'état
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Utiliser _createAccount pour la logique commune
      await _createAccount(authType: 'google', userCredential: userCredential);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion Google: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingGoogle = false);
      }
    }
  }

  /// Inscription avec Apple
  Future<void> _signInWithApple() async {
    if (!mounted) return;

    // Vérifier si un processus est déjà en cours
    if (_isLoadingApple) return;

    setState(() => _isLoadingApple = true);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(oauthCredential);

      // Utiliser _createAccount pour la logique commune
      await _createAccount(authType: 'apple', userCredential: userCredential);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion Apple: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingApple = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              "authentication.create-account.title".tr(),
              style:
                  (theme.titleStyle ??
                  TextStyle(
                    fontSize: sp(22),
                    color: const Color(0xFF021C36),
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          sh(20),

          // Boutons de connexion sociale
          ElevatedButton(
            onPressed: _isLoadingGoogle ? null : _signInWithGoogle,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: _isLoadingGoogle
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/Google_logo.png', height: 24),
                      const SizedBox(width: 10),
                      const Text('Se connecter avec Google'),
                    ],
                  ),
          ),

          if (Platform.isIOS || Platform.isMacOS) ...[
            sh(16),
            ElevatedButton(
              onPressed: _isLoadingApple ? null : _signInWithApple,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoadingApple
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.apple, size: 24),
                        SizedBox(width: 10),
                        Text('Se connecter avec Apple'),
                      ],
                    ),
            ),
          ],
          sh(28),

          // Divider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 130,
                child: Divider(height: .5, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "ou",
                  style:
                      theme.titleStyle?.copyWith(fontSize: sp(17)) ??
                      TextStyle(
                        fontSize: sp(17),
                        color: const Color(0xFF021C36),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(
                width: 130,
                child: Divider(height: .5, color: Colors.grey),
              ),
            ],
          ),
          sh(20),

          if (appModel.applicationConfig.createAccountNeedEmail) ...[
            FormGenerator.generateField(
              context,
              FieldFormModel(
                tag: widget.isLoginById ? "id" : "email",
                type: FormFieldType.email,
                onChanged: (val) => email = val,
                validator: (val) => AuthValidator.validEmail(val)?.tr(),
                placeholder:
                    (widget.isLoginById ? "field.id.hint" : "field.email.hint")
                        .tr(),
                fieldName:
                    (widget.isLoginById
                            ? "field.id.title"
                            : "field.email.title")
                        .tr(),
              ),
            ),
            sh(14),
          ],
          FormGenerator.generateField(
            context,
            FieldFormModel(
              tag: "password",
              type: FormFieldType.password,
              onChanged: (val) => password = val,
              validator: (val) => AuthValidator.validPassword(val)?.tr(),
              placeholder: "field.password.hint".tr(),
              fieldName: "field.password.title".tr(),
            ),
          ),
          if (widget.haveRepeatPassword) ...[
            sh(14),
            FormGenerator.generateField(
              context,
              FieldFormModel(
                tag: "repeatPassword",
                type: FormFieldType.password,
                onChanged: (val) => repeatPassword = val,
                validator: (val) =>
                    AuthValidator.validSamePassword(val, password)?.tr(),
                fieldName: "field.password.repeat-title".tr(),
                placeholder: "field.password.hint".tr(),
              ),
            ),
          ],
          sh(37),
          CTA.primary(
            textButton: "utils.continue-to-next".tr(),
            onTap: () async {
              await _createAccount();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createAccount({
    String authType = 'email',
    UserCredential? userCredential,
  }) async {
    // Pour l'authentification sociale, pas besoin de validation de formulaire
    if (authType == 'email' && !(key.currentState?.validate() ?? false)) {
      return;
    }

    // Vérification email existant seulement pour l'auth email
    if (authType == 'email') {
      try {
        if (await AuthService.emailDoesExist(email!)) {
          if (mounted) {
            NotifBanner.showToast(
              context: context,
              fToast: fToast,
              subTitle: "field.form-validator.firebase.email-already-in-use"
                  .tr(),
            );
          }
          return;
        }
      } catch (e) {
        printInDebug("Erreur lors de la vérification de l'email: $e");
        // En cas d'erreur de vérification, on continue quand même
        // Firebase gérera l'erreur "email-already-in-use" si nécessaire
      }

      ref.read(createAccountProvider).addFieldData("email", email);
      ref.read(createAccountProvider).addFieldData("password", password);

      ref.read(createAccountProvider).email = email;
      ref.read(createAccountProvider).password = password;
    }

    // Afficher le modal CGU pour tous les types d'authentification
    if (!mounted) return;
    if (getResponsiveValue(
      context,
      defaultValue: false,
      tablet: true,
      phone: true,
    )) {
      ValueNotifier<bool> notifier = ValueNotifier<bool>(false);
      ValueNotifier<bool> cguError = ValueNotifier<bool>(false);

      final rep = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxHeight: formatHeight(800),
          minHeight: formatHeight(650),
        ),
        isScrollControlled: true,
        builder: (_) {
          return Container(
            padding: EdgeInsets.fromLTRB(29.w, 16.h, 29.w, 69.h),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(55),
                topRight: Radius.circular(55),
              ),
            ),
            constraints: BoxConstraints(
              maxHeight: formatHeight(800),
              minHeight: formatHeight(650),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 43.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          theme.resetPasswordEncocheColor ??
                          const Color(0xFFDBDBDB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  sh(20),
                  SizedBox(
                    width: 280.w,
                    child: Text(
                      "authentication.cgu.title".tr(),
                      style:
                          theme.titleStyle ??
                          TextStyle(
                            fontSize: sp(17),
                            color: const Color(0xFF021C36),
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  sh(17),
                  SizedBox(
                    height: 310.h,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      primary: false,
                      child: Text(
                        // TODO: CGU
                        appModel.applicationConfig.cguContent,
                        style:
                            theme.subTitleStyle ??
                            TextStyle(
                              color: const Color(
                                0xFF02132B,
                              ).withValues(alpha: 0.35),
                              fontSize: sp(13),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                  sh(16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: notifier,
                        builder: (_, bool val, _) {
                          return CustomCheckbox.square(
                            isChecked: val,
                            size: 26,
                            selectedColor: Theme.of(context).primaryColor,
                            onTap: () => notifier.value = !notifier.value,
                          );
                        },
                      ),
                      sw(14),
                      Expanded(
                        child: InkWell(
                          onTap: () => notifier.value = !notifier.value,
                          child: ValueListenableBuilder(
                            valueListenable: cguError,
                            builder: (_, bool val, _) {
                              return Text(
                                "authentication.cgu.accept".tr(),
                                style: TextStyle(
                                  color: const Color(0xFF02132B),
                                  fontSize: sp(13),
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  sh(33),
                  ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (_, bool isChecked, _) {
                      return CTA.primary(
                        textButton: "utils.continue-to-next".tr(),
                        isEnabled: isChecked,
                        onTap: () async {
                          Navigator.of(context).pop(true);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
      if (rep != true) {
        // Si l'utilisateur refuse les CGU, supprimer le compte créé
        if (authType == 'google' || authType == 'apple') {
          try {
            await FirebaseAuth.instance.currentUser?.delete();
          } catch (e) {
            printInDebug("Erreur lors de la suppression du compte: $e");
          }
        }
        if (mounted) {
          NotifBanner.showToast(
            context: context,
            fToast: fToast,
            subTitle: "authentication.cgu.required".tr(),
          );
        }
        return;
      }
    }

    // Traitement selon le type d'authentification
    if (authType == 'email') {
      // Authentification par email/mot de passe
      if (widget.createAccount) {
        try {
          final rep = await AuthService.signUpWithEmail(email!, password!);
          if (rep.type == "error") {
            if (mounted) {
              NotifBanner.showToast(
                context: context,
                fToast: fToast,
                subTitle: rep.message.tr(),
              );
            }
            passController.clear();
            rPassController.clear();
            return;
          }

          // Vérifier que l'utilisateur est bien créé avant de continuer
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            printInDebug(
              "Erreur: Aucun utilisateur créé après signUpWithEmail",
            );
            if (mounted) {
              NotifBanner.showToast(
                context: context,
                fToast: fToast,
                subTitle:
                    "Une erreur est survenue lors de la création du compte",
              );
            }
            return;
          }

          await FirebaseFirestore.instance
              .collection(appModel.userCollectionPath)
              .doc(currentUser.uid)
              .set({
                "email": email,
                "cguAccepted": true,
                "profilCompleted": false,
                "emailVerified": false, // Nouveau champ
                "createdAt": Timestamp.now(),
              });

          // Envoyer l'email de vérification
          try {
            await currentUser.sendEmailVerification();
            printInDebug("Email de vérification envoyé avec succès");
          } catch (e) {
            printInDebug(
              "Erreur lors de l'envoi de l'email de vérification: $e",
            );
            // Ne pas bloquer le processus pour cette erreur
          }

          // DÉCONNECTER l'utilisateur immédiatement
          await FirebaseAuth.instance.signOut();

          // Notification à l'utilisateur
          if (mounted) {
            NotifBanner.showToast(
              context: context,
              fToast: fToast,
              title: "Compte créé avec succès !",
              subTitle:
                  "Email envoyé à $email. Vérifiez puis connectez-vous.",
              backgroundColor: const Color(0xff30DE8F),
            );

            // Redirection vers login
            AutoRouter.of(context).replaceNamed("/login");
          }
          return; // Arrêter le processus ici
        } catch (e) {
          printInDebug("Erreur lors de la création du compte: $e");
          if (mounted) {
            NotifBanner.showToast(
              context: context,
              fToast: fToast,
              subTitle: "Une erreur inattendue est survenue",
            );
          }
          passController.clear();
          rPassController.clear();
          return;
        }
      }
    } else if (authType == 'google' || authType == 'apple') {
      // Authentification sociale (Google/Apple)
      if (userCredential != null) {
        final userDoc = FirebaseFirestore.instance
            .collection(appModel.userCollectionPath)
            .doc(userCredential.user!.uid);

        // Vérifier si l'utilisateur existe déjà
        final docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          if (!mounted) return;
          // Utilisateur existant - juste se connecter
          await ref
              .read(userChangeNotifierProvider)
              .init(userCredential.user!.uid, context);
          if (!mounted) return;
          AutoRouter.of(context).pushAndPopUntil(
            GetIt.I<ApplicationDataModel>().mainRoute,
            predicate: (_) => false,
          );
        } else {
          // Nouvel utilisateur - créer le profil
          await userDoc.set({
            "email": userCredential.user!.email,
            "cguAccepted": true,
            "profilCompleted": false,
            "createdAt": Timestamp.now(),
          });

          if (!mounted) return;
          // Initialiser le provider utilisateur et naviguer
          await ref
              .read(userChangeNotifierProvider)
              .init(userCredential.user!.uid, context);

          if (!mounted) return;
          AutoRouter.of(context).pushAndPopUntil(
            GetIt.I<ApplicationDataModel>().mainRoute,
            predicate: (_) => false,
          );
        }
        return;
      }
    }

    // Navigation finale pour l'authentification email
    if (authType == 'email') {
      if (!widget.isLast) {
        widget.controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      } else if (GetIt.I<ApplicationDataModel>()
          .applicationConfig
          .emailMustBeVerified) {
        try {
          if (!mounted) return;
          final r = await showGeneralDialog(
            context: context,
            pageBuilder: (_, _, _) {
              return const Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(child: VerificationEmailSendPage.mobile()),
              );
            },
          );
          if (r == true) {
            printInDebug("end create account");
            if (!mounted) return;
            AutoRouter.of(context).pushAndPopUntil(
              GetIt.I<ApplicationDataModel>().mainRoute,
              predicate: (_) => false,
            );
          } else {
            if (!mounted) return;
            AutoRouter.of(context).replaceNamed("/login");
          }
        } catch (e) {
          printInDebug(
            "Erreur lors de la navigation après création de compte: $e",
          );
          // Navigation de fallback
          if (!mounted) return;
          AutoRouter.of(context).replaceNamed("/login");
        }
        return;
      } else {
        // Si l'email n'a pas besoin d'être vérifié, naviguer directement
        try {
          if (!mounted) return;
          AutoRouter.of(context).pushAndPopUntil(
            GetIt.I<ApplicationDataModel>().mainRoute,
            predicate: (_) => false,
          );
        } catch (e) {
          printInDebug(
            "Erreur lors de la navigation vers la page principale: $e",
          );
          if (!mounted) return;
          AutoRouter.of(context).replaceNamed("/login");
        }
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}

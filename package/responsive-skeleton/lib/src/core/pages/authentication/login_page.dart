import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  GlobalKey<FormState> key = GlobalKey();
  List<FocusNode> nodes = [];
  List<TextEditingController> controllers = [];
  final fToast = FToast();

  final GlobalKey<FormState> resetPasswordKey = GlobalKey();

  final PanelController panelController = PanelController();
  String? resetEmail;

  final appModel = GetIt.instance<ApplicationDataModel>();
  late final AuthenticationPageThemeData theme;
  bool _isLoadingGoogle = false;
  bool _isLoadingApple = false;

  @override
  void initState() {
    theme = loadThemeData(
      null,
      "authentication_page",
      () => const AuthenticationPageThemeData(),
    )!;
    ref.read(userChangeNotifierProvider).clear();
    fToast.init(context);
    // Créer les contrôleurs pour email/id et mot de passe
    nodes.add(FocusNode()); // Pour email/id
    nodes.add(FocusNode()); // Pour mot de passe
    controllers.add(TextEditingController()); // Pour email/id
    controllers.add(TextEditingController()); // Pour mot de passe

    // Vérifier si un utilisateur est connecté avec email non vérifié
    _checkAndHandleUnverifiedUser();

    super.initState();
  }

  /// Vérifier et gérer les utilisateurs connectés avec email non vérifié
  Future<void> _checkAndHandleUnverifiedUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && appModel.applicationConfig.emailMustBeVerified) {
      // Vérifier si c'est une authentification email/mot de passe
      final isEmailPasswordAuth = currentUser.providerData.any(
        (provider) => provider.providerId == 'password',
      );

      if (isEmailPasswordAuth) {
        // Recharger pour avoir le statut à jour
        await currentUser.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser != null && !refreshedUser.emailVerified) {
          printInDebug(
            "Utilisateur connecté avec email non vérifié - déconnexion automatique",
          );

          // Déconnecter l'utilisateur pour éviter la boucle infinie
          await FirebaseAuth.instance.signOut();

          // Afficher un message informatif
          if (mounted) {
            NotifBanner.showToast(
              context: context,
              fToast: fToast,
              title: "Email non vérifié",
              subTitle:
                  "Email non vérifié. Vérifiez votre boîte mail.",
              backgroundColor: Colors.orange,
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    for (final e in nodes) {
      e.dispose();
    }
    for (final e in controllers) {
      e.dispose();
    }
    super.dispose();
  }

  /// Connexion avec Google
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

      // Vérifier si l'utilisateur a un document
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Supprimer le compte et afficher message
        await userCredential.user!.delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'authentication.error.must-create-account-first'.tr(),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (!mounted) return;
        // Continuer la navigation normale
        await ref
            .read(userChangeNotifierProvider)
            .init(userCredential.user!.uid, context);
        if (!mounted) return;
        AutoRouter.of(context).pushAndPopUntil(
          GetIt.I<ApplicationDataModel>().mainRoute,
          predicate: (_) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${'authentication.error.connection-error'.tr()}: $e',
            ),
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

  /// Connexion avec Apple
  Future<void> _signInWithApple() async {
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

      // Vérifier si l'utilisateur a un document
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Supprimer le compte et afficher message
        await userCredential.user!.delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'authentication.error.must-create-account-first'.tr(),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (!mounted) return;
        // Continuer la navigation normale
        await ref
            .read(userChangeNotifierProvider)
            .init(userCredential.user!.uid, context);
        if (!mounted) return;
        AutoRouter.of(context).pushAndPopUntil(
          GetIt.I<ApplicationDataModel>().mainRoute,
          predicate: (_) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${'authentication.error.connection-error'.tr()}: $e',
            ),
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
    // ignore: deprecated_member_use_from_same_package
    if (appModel.applicationConfig.loginCustomPage != null) {
      // ignore: deprecated_member_use_from_same_package
      return appModel.applicationConfig.loginCustomPage!;
    }

    final Color color = loadThemeData(
      null,
      "skeleton_authentication_scaffold_color",
      () => Theme.of(context).scaffoldBackgroundColor,
    )!;

    if (appModel.applicationConfig.appBarOnAuthenticationPage && kIsWeb) {
      return ScaffoldWithLogo(
        showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
        color: color,
        showBackButton: false,
        child: _buildLoginForm(context, theme),
      );
    }

    if (appModel.applicationConfig.bottomBarOnAuthenticationPage && kIsWeb) {
      return ScaffoldWithLogo(
        showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
        color: color,
        showBackButton: false,
        child: _buildLoginForm(context, theme),
      );
    }

    return ScaffoldWithLogo(
      showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
      color: color,
      showBackButton: false,
      child: getResponsiveValue(
        context,
        defaultValue: Center(
          child: CustomCard(
            maxWidth: theme.formWidth ?? formatWidth(536),
            child: _buildLoginForm(context, theme),
          ),
        ),
        phone: _buildLoginForm(context, theme, true),
      ),
    );
  }

  Container _buildResetPassword(BuildContext context, BuildContext oldCtx) {
    return Container(
      padding: EdgeInsets.fromLTRB(29.w, 16.h, 29.w, 39.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(55),
          topRight: Radius.circular(55),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Form(
        key: resetPasswordKey,
        child: Column(
          children: [
            Container(
              width: 43.w,
              height: 4,
              decoration: BoxDecoration(
                color:
                    theme.resetPasswordEncocheColor ?? const Color(0xFFDBDBDB),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            sh(20),
            Text(
              "authentication.forgot-password.title".tr(),
              style:
                  theme.titleStyle?.copyWith(fontSize: sp(17)) ??
                  TextStyle(
                    fontSize: sp(17),
                    color: const Color(0xFF021C36),
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            sh(17),
            Text(
              "authentication.reset-password.subtitle".tr(),
              style:
                  theme.subTitleStyle?.copyWith(fontSize: sp(14)) ??
                  TextStyle(
                    fontSize: sp(14),
                    color: const Color(0xFFA7ADB5),
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            sh(35),
            TextFormUpdated.classic(
              fieldName: "field.email.title".tr(),
              hintText: "field.email.hint".tr(),
              onChanged: (val) => resetEmail = val,
              validator: (val) => AuthValidator.validEmail(val)?.tr(),
            ),
            sh(43),
            CTA.primary(
              textButton: "authentication.forgot-password.reset-button".tr(),
              onTap: () async {
                if (resetPasswordKey.currentState?.validate() ?? false) {
                  try {
                    // Envoyer directement l'email de réinitialisation
                    // Firebase gère automatiquement le cas où l'utilisateur n'existe pas
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: resetEmail!,
                    );

                    if (!context.mounted) return;
                    // Toujours afficher un message de succès pour des raisons de sécurité
                    // même si l'utilisateur n'existe pas
                    NotifBanner.showToast(
                      context: oldCtx,
                      fToast: FToast().init(oldCtx),
                      subTitle: "reset-password-update".tr(),
                      backgroundColor: const Color(0xff30DE8F),
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                  } catch (e) {
                    printInDebug(e);
                    if (!context.mounted) return;

                    // Gérer les différents types d'erreurs
                    String errorMessage = "authentication.error.generic".tr();
                    if (e is FirebaseAuthException) {
                      switch (e.code) {
                        case 'invalid-email':
                          errorMessage = "authentication.error.invalid-email"
                              .tr();
                          break;
                        case 'too-many-requests':
                          errorMessage =
                              "authentication.error.too-many-requests".tr();
                          break;
                        case 'user-not-found':
                          // Pour des raisons de sécurité, on affiche le même message que pour un succès
                          // afin de ne pas révéler si l'email existe ou non
                          if (!context.mounted) return;
                          NotifBanner.showToast(
                            context: oldCtx,
                            fToast: FToast().init(oldCtx),
                            subTitle: "reset-password-update".tr(),
                            backgroundColor: const Color(0xff30DE8F),
                          );
                          if (!mounted) return;
                          Navigator.pop(context);
                          return;
                        default:
                          errorMessage = "authentication.error.generic".tr();
                      }
                    }

                    NotifBanner.showToast(
                      context: oldCtx,
                      fToast: FToast().init(oldCtx),
                      subTitle: errorMessage,
                      backgroundColor: Colors.red,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    AuthenticationPageThemeData theme, [
    bool isMobileSize = false,
  ]) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: execInCaseOfPlatfom(() => 200, () => 280.w),
            ),
            child: Text(
              "authentication.login.login-title".tr(),
              style:
                  (theme.titleStyle ??
                  TextStyle(
                    fontSize: sp(22),
                    color: const Color(0xFF021C36),
                    fontWeight: FontWeight.w600,
                  )),
              textAlign: TextAlign.center,
            ),
          ),
          sh(theme.titleSpacing ?? 20),

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
                      Text('authentication.connect-with-google'.tr()),
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.apple, size: 24),
                        const SizedBox(width: 10),
                        Text('authentication.connect-with-apple'.tr()),
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
                  "utils.or".tr(),
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

          Form(
            key: key,
            child: Column(
              children: [
                FormGenerator.generateField(
                  context,
                  FieldFormModel(
                    tag:
                        appModel.applicationConfig.typeOfLogin ==
                            LoginType.email
                        ? "email"
                        : "id",
                    type:
                        appModel.applicationConfig.typeOfLogin ==
                            LoginType.email
                        ? FormFieldType.email
                        : FormFieldType.text,
                    placeholder:
                        appModel.applicationConfig.typeOfLogin ==
                            LoginType.email
                        ? "field.email.hint".tr()
                        : "field.id.hint".tr(),
                    fieldName:
                        appModel.applicationConfig.typeOfLogin ==
                            LoginType.email
                        ? "field.email.title".tr()
                        : "field.id.title".tr(),
                    validator:
                        appModel.applicationConfig.typeOfLogin ==
                            LoginType.email
                        ? (val) => AuthValidator.validEmail(val)?.tr()
                        : (val) => AuthValidator.fieldNotEmpty(val)?.tr(),
                    onChanged: (val) {
                      if (controllers.isNotEmpty) {
                        controllers[0].text = val?.toString() ?? '';
                      }
                    },
                  ),
                ),
                sh(14),
                FormGenerator.generateField(
                  context,
                  FieldFormModel(
                    tag: "password",
                    type: FormFieldType.password,
                    placeholder: "field.password.hint".tr(),
                    fieldName: "field.password.title".tr(),
                    validator: (val) => AuthValidator.fieldNotEmpty(val)?.tr(),
                    onChanged: (val) {
                      if (controllers.length > 1) {
                        controllers[1].text = val?.toString() ?? '';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          sh(20),
          if (appModel.applicationConfig.enableForgotPassword) ...[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "authentication.forgot-password-message".tr(),
                    style:
                        theme.richTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36).withValues(alpha: .35),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: "authentication.forgot-password-link".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        execInCaseOfPlatfom(
                          () => AutoRouter.of(
                            context,
                          ).replaceNamed("/forgot-password"),
                          () async => await showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Theme.of(
                              context,
                            ).scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(55),
                                topRight: Radius.circular(55),
                              ),
                            ),
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildResetPassword(context, context),
                                sh(MediaQuery.of(context).viewInsets.bottom),
                              ],
                            ),
                          ),
                        );
                      },
                    style:
                        theme.cliquableTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ],
              ),
            ),
          ],
          sh(44),
          CTA.primary(
            textButton: "utils.connexion".tr(),
            onTap: () async {
              // Vérifier la validité du formulaire avant de procéder
              if (key.currentState?.validate() == true) {
                if (appModel.applicationConfig.typeOfLogin == LoginType.email) {
                  await _loginByEmail();
                } else if (appModel.applicationConfig.typeOfLogin ==
                    LoginType.id) {
                  await _loginById();
                }
              } else {
                // Forcer l'affichage des validators en cas d'échec de validation
                key.currentState?.validate();
              }
            },
          ),
          if (appModel.applicationConfig.enableCreateAccount) ...[
            sh(33),
            const SizedBox(width: 40, child: Divider(height: .5)),
            sh(26),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "authentication.no-account-yet".tr(),
                      style:
                          theme.richTextStyle ??
                          TextStyle(
                            fontSize: sp(15),
                            color: const Color(
                              0xFF021C36,
                            ).withValues(alpha: .35),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    TextSpan(
                      text: "authentication.create-account-now".tr(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          kIsWeb
                              ? AutoRouter.of(
                                  context,
                                ).navigateNamed("/create-account")
                              : AutoRouter.of(
                                  context,
                                ).replaceNamed("/create-account");
                        },
                      style:
                          theme.cliquableTextStyle ??
                          TextStyle(
                            fontSize: sp(15),
                            color: const Color(0xFF021C36),
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (appModel.applicationConfig.enableNoConnexion) ...[
            sh(33),
            const SizedBox(width: 40, child: Divider(height: .5)),
            sh(26),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "authentication.no-need-connexion".tr(),
                    style:
                        theme.richTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36).withValues(alpha: .35),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: "authentication.no-connexion-start-now".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Vérifier la validité du formulaire avant de naviguer
                        if (key.currentState?.validate() == true) {
                          if (appModel.noConnexionRoute != null) {
                            kIsWeb
                                ? AutoRouter.of(
                                    context,
                                  ).replaceNamed(appModel.noConnexionRoute!)
                                : AutoRouter.of(
                                    context,
                                  ).navigateNamed(appModel.noConnexionRoute!);
                          }
                        }
                      },
                    style:
                        theme.cliquableTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _loginById() async {
    // Les indices sont fixes maintenant : 0 pour id/email, 1 pour password
    const idIndex = 0;
    const passwordIndex = 1;

    if (controllers.length < 2) {
      NotifBanner.showToast(
        context: context,
        fToast: fToast,
        subTitle: "field.invalid-field-contact-developper".tr(),
      );
      return;
    }

    final emailValue = controllers[idIndex].value.text.trim();
    final passValue = controllers[passwordIndex].value.text.trim();

    // Vérifier que les champs ne sont pas vides
    if (emailValue.isEmpty) {
      NotifBanner.showToast(
        context: context,
        fToast: fToast,
        subTitle: "field.validation.email-or-id-required".tr(),
      );
      return;
    }

    if (passValue.isEmpty) {
      NotifBanner.showToast(
        context: context,
        fToast: fToast,
        subTitle: "field.validation.password-required".tr(),
      );
      return;
    }

    final isEmail = AuthValidator.validEmail(emailValue) == null;

    if (isEmail) {
      final rep = await AuthService.signInWithEmail(emailValue, passValue);
      if (rep.type == "error") {
        if (!mounted) return;
        NotifBanner.showToast(
          context: context,
          fToast: fToast,
          subTitle: rep.message.tr(),
        );
        return;
      }
    } else {
      final cFunction = FirebaseFunctions.instance.httpsCallable(
        "getEmailFromIdentifier",
      );
      final cfrep = await cFunction.call({
        "identifier": controllers[idIndex].value.text,
      });
      if (cfrep.data["error"] != null) {
        if (!mounted) return;
        NotifBanner.showToast(
          context: context,
          fToast: fToast,
          subTitle: cfrep.data["error"].tr(),
        );
        return;
      }
      final rep = await AuthService.signInWithEmail(
        cfrep.data["email"],
        passValue,
      );
      if (rep.type == "error") {
        if (!mounted) return;
        NotifBanner.showToast(
          context: context,
          fToast: fToast,
          subTitle: rep.message.tr(),
        );
        return;
      }
    }

    if (appModel.applicationConfig.emailMustBeVerified) {
      final currentUser = FirebaseAuth.instance.currentUser!;

      // Vérifier le type de provider - pas de vérification email pour Google/Apple
      final isEmailPasswordAuth = currentUser.providerData.any(
        (provider) => provider.providerId == 'password',
      );

      if (isEmailPasswordAuth) {
        // Seulement pour l'authentification email/mot de passe
        // Recharger pour avoir le statut à jour
        await currentUser.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser!;

        if (!refreshedUser.emailVerified) {
          // Email NON vérifié - Bloquer l'accès

          // Essayer d'envoyer un email de vérification avec gestion d'erreur
          String notificationMessage =
              "Vérifiez votre email pour vous connecter.";
          try {
            await refreshedUser.sendEmailVerification();
            notificationMessage +=
                " Nouvel email envoyé.";
            printInDebug(
              "[LoginPage] Email de vérification envoyé avec succès",
            );
          } catch (e) {
            printInDebug(
              "[LoginPage] Erreur lors de l'envoi de l'email de vérification: $e",
            );

            if (e.toString().contains('too-many-requests')) {
              notificationMessage +=
                  " Trop de demandes. Attendez avant de réessayer.";
            } else {
              notificationMessage +=
                  " Impossible d'envoyer un email pour le moment.";
            }
          }

          // Déconnecter l'utilisateur
          await FirebaseAuth.instance.signOut();

          if (!mounted) return;
          NotifBanner.showToast(
            context: context,
            fToast: fToast,
            title: "Email non vérifié",
            subTitle: notificationMessage,
            backgroundColor: Colors.orange,
          );
          return; // STOP - Pas d'accès
        } else {
          // Email VÉRIFIÉ - Autoriser l'accès
          await FirebaseFirestore.instance
              .collection(appModel.userCollectionPath)
              .doc(refreshedUser.uid)
              .update({"emailVerified": true});
          // Continuer le processus normal
        }
      }
      // Pour Google/Apple, on continue sans vérification
    }

    if (!mounted) return;
    await ref
        .read(userChangeNotifierProvider)
        .init(FirebaseAuth.instance.currentUser!.uid, context);
    if (!mounted) return;
    AutoRouter.of(context).pushAndPopUntil(
      GetIt.I<ApplicationDataModel>().mainRoute,
      predicate: (_) => false,
    );
  }

  Future<void> _loginByEmail() async {
    // Les indices sont fixes maintenant : 0 pour email, 1 pour password
    const emailIndex = 0;
    const passwordIndex = 1;

    if (controllers.length < 2) {
      NotifBanner.showToast(
        context: context,
        fToast: fToast,
        subTitle: "field.invalid-field-contact-developper".tr(),
      );
      return;
    }

    final emailValue = controllers[emailIndex].value.text.trim();
    final passValue = controllers[passwordIndex].value.text.trim();

    // Vérifier que les champs ne sont pas vides
    if (emailValue.isEmpty) {
      NotifBanner.showToast(
        context: context,
        fToast: fToast,
        subTitle: "field.validation.email-required".tr(),
      );
      return;
    }

    if (passValue.isEmpty) {
      NotifBanner.showToast(
        context: context,
        fToast: fToast,
        subTitle: "field.validation.password-required".tr(),
      );
      return;
    }

    final rep = await AuthService.signInWithEmail(emailValue, passValue);
    if (rep.type == "error") {
      if (!mounted) return;
      NotifBanner.showToast(
        context: context,
        fToast: fToast,
        subTitle: rep.message.tr(),
      );
      return;
    }

    if (appModel.applicationConfig.emailMustBeVerified) {
      final currentUser = FirebaseAuth.instance.currentUser!;

      // Vérifier le type de provider - pas de vérification email pour Google/Apple
      final isEmailPasswordAuth = currentUser.providerData.any(
        (provider) => provider.providerId == 'password',
      );

      if (isEmailPasswordAuth) {
        // Seulement pour l'authentification email/mot de passe
        // Recharger pour avoir le statut à jour
        await currentUser.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser!;

        if (!refreshedUser.emailVerified) {
          // Email NON vérifié - Bloquer l'accès

          // Essayer d'envoyer un email de vérification avec gestion d'erreur
          String notificationMessage =
              "Vérifiez votre email pour vous connecter.";
          try {
            await refreshedUser.sendEmailVerification();
            notificationMessage +=
                " Nouvel email envoyé.";
            printInDebug(
              "[LoginPage] Email de vérification envoyé avec succès",
            );
          } catch (e) {
            printInDebug(
              "[LoginPage] Erreur lors de l'envoi de l'email de vérification: $e",
            );

            if (e.toString().contains('too-many-requests')) {
              notificationMessage +=
                  " Trop de demandes. Attendez avant de réessayer.";
            } else {
              notificationMessage +=
                  " Impossible d'envoyer un email pour le moment.";
            }
          }

          // Déconnecter l'utilisateur
          await FirebaseAuth.instance.signOut();

          if (!mounted) return;
          NotifBanner.showToast(
            context: context,
            fToast: fToast,
            title: "Email non vérifié",
            subTitle: notificationMessage,
            backgroundColor: Colors.orange,
          );
          return; // STOP - Pas d'accès
        } else {
          // Email VÉRIFIÉ - Autoriser l'accès
          await FirebaseFirestore.instance
              .collection(appModel.userCollectionPath)
              .doc(refreshedUser.uid)
              .update({"emailVerified": true});
          // Continuer le processus normal
        }
      }
      // Pour Google/Apple, on continue sans vérification
    }

    if (!mounted) return;
    await ref
        .read(userChangeNotifierProvider)
        .init(FirebaseAuth.instance.currentUser!.uid, context);
    if (!mounted) return;
    AutoRouter.of(context).pushAndPopUntil(
      GetIt.I<ApplicationDataModel>().mainRoute,
      predicate: (_) => false,
    );
  }
}

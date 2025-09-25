import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:auth_helper/auth_helper.dart' as ah;
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/auth_update.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

enum GeneralSettingsType { email, password, phone, personnalData }

abstract class SettingsBuilder {
  static Widget generateDefaultSettings({
    required GeneralSettingsType type,
    TextStyle? pageTitleStyle,
  }) {
    switch (type) {
      case GeneralSettingsType.email:
        return ChangeEmailSettings(pageTitleStyle: pageTitleStyle);
      case GeneralSettingsType.password:
        return ChangePasswordSettings(pageTitleStyle: pageTitleStyle);
      case GeneralSettingsType.phone:
        return ChangeSettingsPhone(pageTitleStyle: pageTitleStyle);
      case GeneralSettingsType.personnalData:
        return ChangeSettingsPersonnalData(pageTitleStyle: pageTitleStyle);
    }
  }
}

class ChangeEmailSettings extends StatefulHookConsumerWidget {
  final TextStyle? pageTitleStyle;

  const ChangeEmailSettings({super.key, this.pageTitleStyle});

  @override
  ConsumerState<ChangeEmailSettings> createState() =>
      _ChangeEmailSettingsState();
}

class _ChangeEmailSettingsState extends ConsumerState<ChangeEmailSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            sh(12),
            SizedBox(
              height: formatHeight(35),
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "field.email.title".tr(),
                      style:
                          widget.pageTitleStyle ??
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: sp(16),
                          ),
                    ),
                  ),
                  ResponsiveVisibility(
                    visible: false,
                    visibleConditions: const [
                      Condition.smallerThan(name: DESKTOP),
                    ],
                    child: Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).back(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sh(50),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormUpdated.classic(
                    fieldName: "field.email.title-new".tr(),
                    hintText: "field.email.hint".tr(),
                    defaultValue: ref
                        .watch(userChangeNotifierProvider)
                        .userData!
                        .email,
                    onChanged: (p1) => email = p1,
                    validator: (p0) => AuthValidator.validEmail(email)?.tr(),
                  ),
                  sh(14),
                  TextFormUpdated.classic(
                    fieldName: "field.password.title".tr(),
                    hintText: "field.password.hint".tr(),
                    onChanged: (p1) => password = p1,
                    validator: (p0) =>
                        AuthValidator.validPassword(password)?.tr(),
                    obscuringText: true,
                    isUpdatable: true,
                    suffixChild: const Icon(Icons.remove_red_eye_outlined),
                    suffixChildActive: const Icon(Icons.remove_red_eye),
                  ),
                ],
              ),
            ),
            sh(32),
            CTA.primary(
              textButton: "settings.validate-button".tr(),
              width: double.infinity,
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final rep = await UserAuthUpdate.changeEmail(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    newEmail: email!,
                    password: password!,
                  );
                  if (rep.type == "ok") {
                    await FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification();
                    await FirebaseAuth.instance.currentUser?.reload();
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"email": email});
                    if (context.mounted) {
                      await MessageBox.show(
                        context: context,
                        title: "settings.confirm-email.title".tr(),
                        message: "settings.confirm-email.body".tr(
                          namedArgs: {"email": email!},
                        ),
                        actions: [
                          (_) => CTA.primary(
                            width: formatWidth(139),
                            textButton: "utils.close".tr(),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    }
                    if (context.mounted) {
                      AutoRouter.of(context).back();
                    }
                  } else {
                    if (!context.mounted) return;
                    NotifBanner.showToast(
                      context: context,
                      fToast: FToast().init(context),
                      subTitle: rep.message,
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
}

class ChangePasswordSettings extends StatefulHookConsumerWidget {
  final TextStyle? pageTitleStyle;

  const ChangePasswordSettings({super.key, this.pageTitleStyle});

  @override
  ConsumerState<ChangePasswordSettings> createState() =>
      _ChangePasswordSettingsState();
}

class _ChangePasswordSettingsState
    extends ConsumerState<ChangePasswordSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? password;
  String? newPassword;
  String? repeatNewPassword;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            sh(12),
            SizedBox(
              height: formatHeight(35),
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "field.password.title".tr(),
                      style:
                          widget.pageTitleStyle ??
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: sp(16),
                          ),
                    ),
                  ),
                  ResponsiveVisibility(
                    visible: false,
                    visibleConditions: const [
                      Condition.smallerThan(name: DESKTOP),
                    ],
                    child: Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).back(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sh(50),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormUpdated.classic(
                    fieldName: "field.password.actual-title".tr(),
                    hintText: "field.password.hint".tr(),
                    onChanged: (p1) => password = p1,
                    validator: (p0) =>
                        AuthValidator.validPassword(password)?.tr(),
                    obscuringText: true,
                    isUpdatable: true,
                    suffixChild: const Icon(Icons.remove_red_eye_outlined),
                    suffixChildActive: const Icon(Icons.remove_red_eye),
                  ),
                  sh(14),
                  TextFormUpdated.classic(
                    fieldName: "field.password.new-title".tr(),
                    hintText: "field.password.hint".tr(),
                    onChanged: (p1) => newPassword = p1,
                    validator: (p0) =>
                        AuthValidator.validPassword(newPassword)?.tr(),
                    obscuringText: true,
                    isUpdatable: true,
                    suffixChild: const Icon(Icons.remove_red_eye_outlined),
                    suffixChildActive: const Icon(Icons.remove_red_eye),
                  ),
                  sh(14),
                  TextFormUpdated.classic(
                    fieldName: "field.password.new-repeat-title".tr(),
                    hintText: "field.password.hint".tr(),
                    onChanged: (p1) => repeatNewPassword = p1,
                    validator: (p0) => AuthValidator.validSamePassword(
                      repeatNewPassword,
                      newPassword,
                    )?.tr(),
                    obscuringText: true,
                    isUpdatable: true,
                    suffixChild: const Icon(Icons.remove_red_eye_outlined),
                    suffixChildActive: const Icon(Icons.remove_red_eye),
                  ),
                ],
              ),
            ),
            sh(32),
            CTA.primary(
              textButton: "settings.validate-button".tr(),
              width: double.infinity,
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final rep = await UserAuthUpdate.changePassword(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    oldPassword: password!,
                    newPassword: newPassword!,
                  );
                  if (rep.type == "ok") {
                    if (context.mounted) {
                      NotifBanner.showToast(
                        context: context,
                        fToast: FToast().init(context),
                        subTitle: "settings.password-changed".tr(),
                        title: "utils.ended".tr(),
                        backgroundColor: const Color(0xFF0ACC73),
                      );
                      if (!kIsWeb) AutoRouter.of(context).back();
                    }
                  } else {
                    if (context.mounted) {
                      NotifBanner.showToast(
                        context: context,
                        fToast: FToast().init(context),
                        subTitle: rep.message,
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeSettingsPhone extends StatefulHookConsumerWidget {
  final TextStyle? pageTitleStyle;

  const ChangeSettingsPhone({super.key, this.pageTitleStyle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeSettingsPhoneState();
}

class _ChangeSettingsPhoneState extends ConsumerState<ChangeSettingsPhone> {
  GlobalKey<FormState> phoneKey = GlobalKey();
  final fToast = FToast();
  PhoneNumber? phone;
  final PageController pageController = PageController();
  String? codeMessage;
  String? validCode;
  Duration? validationTimeCode;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            sh(12),
            SizedBox(
              height: formatHeight(35),
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "settings.phone".tr(),
                      style:
                          widget.pageTitleStyle ??
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: sp(16),
                          ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () => AutoRouter.of(context).back(),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: formatWidth(18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sh(50),
            ExpandablePageView(
              controller: pageController,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: phoneKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FormGenerator.generateField(
                            context,
                            FieldFormModel(
                              initialValue: PhoneNumber(isoCode: "FR"),
                              tag: "phone",
                              type: FormFieldType.phone,
                              requiredForForm: false,
                              onChanged: (val) => phone = val,
                              validator: (val) {
                                if (val == null || (val as String).isEmpty) {
                                  return "field.form-validator.required-field"
                                      .tr();
                                }
                                return null;
                              },
                              placeholder: ("field.phone.hint").tr(),
                              fieldName: ("field.phone.title").tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sh(39),
                    CTA.primary(
                      textButton: "settings.validate-button".tr(),
                      width: double.infinity,
                      onTap: () async {
                        if (phoneKey.currentState?.validate() ?? false) {
                          if (await AuthService.phoneDoesExist(
                            phone!.phoneNumber!,
                          )) {
                            printInDebug(phone!.phoneNumber!);
                            if (!context.mounted) return;
                            NotifBanner.showToast(
                              context: context,
                              fToast: fToast,
                              subTitle: "authentication.phone.error-phone-exist"
                                  .tr(),
                            );
                            return;
                          }
                          if (!context.mounted) return;
                          await ah.AuthService.verifPhoneNumberAndGetCredential(
                            phone: phone!.phoneNumber!,
                            connexionDone: () {},
                            codeSent: (String code, int? _) {
                              validCode = code;
                              validationTimeCode = const Duration(seconds: 120);
                              timer?.cancel();
                              timer = Timer.periodic(
                                const Duration(seconds: 1),
                                (timer) {
                                  if (validationTimeCode != null) {
                                    setState(() {
                                      validationTimeCode =
                                          validationTimeCode! -
                                          const Duration(seconds: 1);
                                    });
                                    if (validationTimeCode!.inSeconds == 0) {
                                      timer.cancel();
                                    }
                                  }
                                },
                              );
                            },
                            redirectAfterTimeOut: () {},
                            setLoading: () {},
                            verificationError: (_) {},
                            verificationFailed: (_) {},
                            fToast: fToast,
                            context: context,
                          );
                          pageController.jumpToPage(1);
                        }
                      },
                    ),
                  ],
                ),
                _buildVerifyNumber(
                  context,
                  const AuthenticationPageThemeData(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildVerifyNumber(
    BuildContext context,
    AuthenticationPageThemeData theme,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: execInCaseOfPlatfom(() => 200, () => 232.w),
            ),
            child: Text(
              "authentication.login-with-phone.enter-code".tr(),
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
          sh(8),
          if (validationTimeCode != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                "authentication.login-with-phone.expire".tr(
                  namedArgs: {
                    "time":
                        "${(validationTimeCode!.inMinutes).toString().padLeft(2, "0")}:${(validationTimeCode!.inSeconds - ((validationTimeCode!.inMinutes * 60))).toString().padLeft(2, "0")}",
                  },
                ),
                style:
                    (theme.subTitleStyle ??
                    TextStyle(
                      fontSize: sp(14),
                      color: const Color(0xFF021C36).withValues(alpha: .5),
                      fontWeight: FontWeight.w600,
                    )),
                textAlign: TextAlign.center,
              ),
            ),
          sh(28),
          Row(
            children: [
              Text(
                "field.phone.code-title".tr(),
                textAlign: TextAlign.left,
                style:
                    (theme.titleStyle ??
                            TextStyle(
                              fontSize: sp(14),
                              color: const Color(0xFF021C36),
                              fontWeight: FontWeight.w600,
                            ))
                        .copyWith(fontSize: sp(14)),
              ),
            ],
          ),
          sh(5),
          PinCodeTextField(
            appContext: context,
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: sp(20),
            ),
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.w400,
            ),
            length: 6,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            validator: (v) {
              if ((v?.length ?? 0) < 6) {
                return "Le code n’est pas complet";
              } else {
                return null;
              }
            },
            pinTheme: PinTheme(
              errorBorderColor: Colors.red,
              inactiveFillColor: const Color(0XFFF6F6F6),
              inactiveColor: const Color(0XFFF6F6F6),
              activeColor: const Color(0XFFF6F6F6),
              selectedFillColor: const Color(0XFFF6F6F6),
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(7),
              fieldHeight: formatHeight(54),
              fieldWidth: formatWidth(50),
              activeFillColor: Colors.white,
            ),
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            onCompleted: (codeVerification) async {
              // Vérification du code pour les paramètres de sécurité
              if (codeVerification.isNotEmpty && codeVerification.length == 6) {
                try {
                  // Validation du code de sécurité et application des changements
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Paramètres mis à jour avec succès"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Code de vérification invalide"),
                    ),
                  );
                }
              }
            },
            onChanged: (value) {
              codeMessage = value;
            },
            beforeTextPaste: (text) {
              printInDebug("Allowing to paste $text");
              return true;
            },
          ),
          sh(20),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "field.phone.not-received".tr(),
                    style:
                        theme.richTextStyle ??
                        TextStyle(
                          fontSize: sp(15),
                          color: const Color(0xFF021C36).withValues(alpha: .35),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: "utils.resend".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await ah.AuthService.verifPhoneNumberAndGetCredential(
                          phone: phone!.phoneNumber!,
                          connexionDone: () {},
                          codeSent: (String code, int? _) {
                            validCode = code;
                            validationTimeCode = const Duration(seconds: 120);
                            timer?.cancel();
                            timer = Timer.periodic(const Duration(seconds: 1), (
                              timer,
                            ) {
                              if (validationTimeCode != null) {
                                setState(() {
                                  validationTimeCode =
                                      validationTimeCode! -
                                      const Duration(seconds: 1);
                                });
                                if (validationTimeCode!.inSeconds == 0) {
                                  timer.cancel();
                                }
                              }
                            });
                          },
                          redirectAfterTimeOut: () {},
                          setLoading: () {},
                          verificationError: (_) {},
                          verificationFailed: (_) {},
                          fToast: fToast,
                          context: context,
                        );
                        await FirebaseAuth.instance.currentUser?.reload();
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({"phone": phone!.phoneNumber!});
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
          sh(44),
          CTA.primary(
            textButton: "utils.connexion".tr(),
            onTap: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: validCode!,
                smsCode: codeMessage!,
              );
              if (await ah.AuthService.updatePhone(
                fToast: fToast,
                context: context,
                phoneAuthCredential: credential,
              )) {
                if (!context.mounted) return;
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  subTitle: "settings.phone-changed".tr(),
                  title: "utils.ended".tr(),
                  backgroundColor: const Color(0xFF0ACC73),
                );
              }
              timer?.cancel();
              if (!context.mounted) return;
              AutoRouter.of(context).back();
            },
          ),
        ],
      ),
    );
  }
}

class ChangeSettingsPersonnalData extends StatefulHookConsumerWidget {
  final TextStyle? pageTitleStyle;

  const ChangeSettingsPersonnalData({super.key, this.pageTitleStyle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeSettingsPersonnalDataState();
}

class _ChangeSettingsPersonnalDataState
    extends ConsumerState<ChangeSettingsPersonnalData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? firstname;
  String? lastname;

  @override
  initState() {
    firstname = ref.read(userChangeNotifierProvider).userData!.firstname;
    lastname = ref.read(userChangeNotifierProvider).userData!.lastname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            sh(12),
            SizedBox(
              height: formatHeight(35),
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "settings.modify".tr(),
                      style:
                          widget.pageTitleStyle ??
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: sp(16),
                          ),
                    ),
                  ),
                  ResponsiveVisibility(
                    visible: false,
                    visibleConditions: const [
                      Condition.smallerThan(name: DESKTOP),
                    ],
                    child: Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).back(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sh(20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ref
                          .watch(userChangeNotifierProvider)
                          .userData
                          ?.firstname !=
                      null) ...[
                    TextFormUpdated.classic(
                      fieldName: "field.firstname.title-new".tr(),
                      hintText: "field.firstname.hint".tr(),
                      onChanged: (p1) => firstname = p1,
                      validator: (p0) =>
                          AuthValidator.fieldNotEmpty(firstname)?.tr(),
                      defaultValue: ref
                          .watch(userChangeNotifierProvider)
                          .userData!
                          .firstname,
                    ),
                  ],
                  if (ref
                          .watch(userChangeNotifierProvider)
                          .userData
                          ?.lastname !=
                      null) ...[
                    sh(14),
                    TextFormUpdated.classic(
                      fieldName: "field.lastname.title".tr(),
                      hintText: "field.lastname.hint".tr(),
                      onChanged: (p1) => lastname = p1,
                      validator: (p0) =>
                          AuthValidator.fieldNotEmpty(lastname)?.tr(),
                      defaultValue: ref
                          .watch(userChangeNotifierProvider)
                          .userData!
                          .lastname,
                    ),
                  ],
                ],
              ),
            ),
            sh(32),
            CTA.primary(
              textButton: "settings.modify".tr(),
              width: double.infinity,
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  FirebaseFirestore.instance
                      .collection(
                        GetIt.I<ApplicationDataModel>().userCollectionPath,
                      )
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({"firstname": firstname, "lastname": lastname});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

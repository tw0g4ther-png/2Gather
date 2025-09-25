import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/core/pages/authentication/create_account_page.dart';
import 'package:skeleton_kosmos/src/services/authentication/index.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

/// Page Template montrant les CGU et demandant à l'utilisateur de les accepter. (uniquement en Web)
///
/// {@category Page}
/// {@category Core}
class CgvuPage extends ConsumerStatefulWidget {
  final String cgu;
  final bool isLast;
  final bool createAccount;
  final PageController controller;

  const CgvuPage({
    super.key,
    required this.cgu,
    required this.controller,
    this.isLast = false,
    this.createAccount = true,
  });

  @override
  ConsumerState<CgvuPage> createState() => _CgvuPageState();
}

class _CgvuPageState extends ConsumerState<CgvuPage> {
  bool isAccepted = false;
  final fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = loadThemeData(null, "authentication_page",
        () => const AuthenticationPageThemeData())!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text("authentication.create-account.title".tr(),
              style: (theme.titleStyle ??
                  TextStyle(
                    fontSize: sp(22),
                    color: const Color(0xFF021C36),
                    fontWeight: FontWeight.w600,
                  ))),
        ),
        sh(28),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 410),
          child: SingleChildScrollView(
            primary: false,
            physics: const BouncingScrollPhysics(),
            child: Text(
              widget.cgu,
              style: theme.subTitleStyle ??
                  TextStyle(
                    fontSize: sp(16),
                    color: const Color(0xFF021C36).withValues(alpha: .5),
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ),
        sh(17),
        Selector(
          content: "authentication.cgu.accept".tr(),
          defaultChecked: isAccepted,
          onChanged: (val) {
            printInDebug(val);
            isAccepted = val;
          },
        ),
        sh(17),
        CTA.primary(
          textButton: "utils.continue-to-next".tr(),
          onTap: () async {
            if (isAccepted != true) {
              NotifBanner.showToast(
                  context: context,
                  fToast: fToast,
                  subTitle: "authentication.cgu.required".tr());
              return;
            }

            if (widget.createAccount) {
              final rep = await AuthService.signUpWithEmail(
                  ref.read(createAccountProvider).email!,
                  ref.read(createAccountProvider).password!);
              if (rep.type == "error") {
                if (!context.mounted) return;
                NotifBanner.showToast(
                    context: context,
                    fToast: fToast,
                    subTitle: rep.message.tr());
                return;
              }

              await FirebaseFirestore.instance
                  .collection(
                      GetIt.I<ApplicationDataModel>().userCollectionPath)
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .set({
                "email": ref.read(createAccountProvider).email,
                "phone": null,
                "cguAccepted": true,
                "profilCompleted": false,
                "createdAt": Timestamp.now(),
              });
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
            }

            if (widget.isLast &&
                GetIt.I<ApplicationDataModel>()
                    .applicationConfig
                    .emailMustBeVerified) {
              if (!context.mounted) return;
              final r = await showGeneralDialog(
                context: context,
                pageBuilder: (_, _, _) {
                  return const Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(child: VerificationEmailSendPage.mobile()),
                  );
                },
              );
              if (!context.mounted) return;
              if (r == true) {
                printInDebug("end create account");
                AutoRouter.of(context).pushAndPopUntil(
                    GetIt.I<ApplicationDataModel>().mainRoute,
                    predicate: (_) => false);
              } else {
                AutoRouter.of(context).replaceNamed("/login");
              }
              return;
            }

            if (!mounted) return;
            widget.controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear);
          },
        ),
      ],
    );
  }
}

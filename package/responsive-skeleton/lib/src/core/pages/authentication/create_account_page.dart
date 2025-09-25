import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:fluttertoast/fluttertoast.dart';

final createAccountProvider = ChangeNotifierProvider<CreateAccountProvider>(
    (ref) => CreateAccountProvider(ref));

/// Template affichant une page permettant de créer son profil.
///
/// {@category Page}
/// {@category Core}
@RoutePage()
class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  GlobalKey<FormState> key = GlobalKey();

  final fToast = FToast();
  final appModel = GetIt.instance<ApplicationDataModel>();
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    ref.read(createAccountProvider).init(0);
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color color = loadThemeData(
        null,
        "skeleton_authentication_scaffold_color",
        () => Theme.of(context).scaffoldBackgroundColor)!;
    final theme = loadThemeData(null, "authentication_page",
        () => const AuthenticationPageThemeData())!;

    if (appModel.applicationConfig.appBarOnAuthenticationPage) {
      return ScaffoldWithLogo.withBar(
        showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
        color: color,
        showBackButton: false,
        child: getResponsiveValue(
          context,
          defaultValue: Center(
            child: CustomCard(
              maxWidth: theme.formWidth ?? formatWidth(536),
              useIntrisict: false,
              child: _buildLoginForm(context, theme),
            ),
          ),
          phone: _buildLoginForm(context, theme),
        ),
      );
    }

    return ScaffoldWithLogo(
      showLogo: appModel.applicationConfig.logoOnAuthenticationPage,
      color: color,
      showBackButton: true,
      onBackButtonPressed: () {
        if (!ref.read(createAccountProvider).controller.hasClients) {
          AutoRouter.of(context).replaceNamed("/");
          return;
        }
        if (ref.read(createAccountProvider).controller.page == 0) {
          AutoRouter.of(context).replaceNamed("/");
        } else {
          ref.read(createAccountProvider).controller.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      },
      child: getResponsiveValue(
        context,
        defaultValue: Center(
          child: CustomCard(
            maxWidth: theme.formWidth ?? formatWidth(536),
            useIntrisict: false,
            child: _buildLoginForm(context, theme),
          ),
        ),
        phone: _buildLoginForm(context, theme),
      ),
    );
  }

  Widget _buildLoginForm(
      BuildContext context, AuthenticationPageThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      primary: false,
      child: ExpandablePageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          Column(
            children: [
              // Contenu de PrincipalData intégré ici
              PrincipalData(
                isLoginById:
                    appModel.applicationConfig.typeOfLogin == LoginType.id,
                controller: controller,
                createAccount: getResponsiveValue(context,
                    defaultValue: false, phone: true, tablet: true),
                isLast: getResponsiveValue(context,
                    defaultValue: false, phone: true, tablet: true),
              ),
            ],
          ),
          if (getResponsiveValue(context,
              defaultValue: true, phone: false, tablet: false))
            CgvuPage(
              cgu: appModel.applicationConfig.cguContent,
              controller: controller,
              createAccount: true,
              isLast: getResponsiveValue(context,
                  defaultValue: true, phone: false, tablet: false),
            ),
          if (getResponsiveValue(context,
              defaultValue: true, phone: false, tablet: false))
            const VerificationEmailSendPage(),
        ],
      ),
    );
  }
}

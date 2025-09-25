import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class MainPage extends ConsumerWidget {
  final RootStackRouter appRouter;

  const MainPage({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();
    final appTheme = GetIt.instance<AppTheme>();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: GetMaterialApp.router(
        title: appModel.appTitle,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: [
          ...context.localizationDelegates,
          CountryLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        builder: (_, child) {
          return child!;
        },
        theme: appTheme.themeData ??
            ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
      ),
    );
  }
}

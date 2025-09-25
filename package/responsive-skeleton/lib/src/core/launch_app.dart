// ignore_for_file: provide_deprecation_message

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeleton_kosmos/src/core/pages/main_page.dart';
import 'package:skeleton_kosmos/src/model/app_model.dart';
import 'package:url_strategy/url_strategy.dart';

/// {@category Core}
///
/// Point d'entrée de l'application.
/// Cette classe est responsable de l'initialisation de l'application.
/// Elle est responsable de l'initialisation des services de l'application et du lancement en fonction de la platforme (IOS / Android ou Web).
///
/// ![An image of function](./doc/images/LaunchApplication_launch.png)
///
abstract class LaunchApplication {
  static Future<void> _registerAppModel({
    required ApplicationDataModel appModel,
    AppTheme? customTheme,
  }) async {
    GetIt.instance.registerSingleton(appModel);
    if (customTheme != null) {
      GetIt.instance.registerSingleton(customTheme);
    }
  }

  static Future<void> _launchFirebaseService(
      {required ApplicationDataModel appModel}) async {
    if (!appModel.firebaseIsEnabled) return;
    if (kIsWeb) {
      await Firebase.initializeApp(options: appModel.firebaseOptions);
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    } else {
      final r = await Firebase.initializeApp();
      printInDebug(r);
    }

    if (appModel.clearUserSessionOnDebugMode) {
      if (!kReleaseMode && FirebaseAuth.instance.currentUser != null) {
        printInDebug("[Debug] clear user session");
        await FirebaseAuth.instance.signOut();
      }
    }

    // Gestion utilisateur Firebase - implémentation actuelle fonctionnelle
    // await getFirebaseUser();
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    firebaseUser ??= await FirebaseAuth.instance.authStateChanges().first;
  }

  /// Lance l'application.
  ///
  static Future<void> launch({
    required ApplicationDataModel applicationModel,
    required RootStackRouter appRouter,
    @Deprecated(
        "customTheme was deprecated from v3.3.0, use initTheme arguments (you can use screenUtil and ResponsiveFramework inside).")
    AppTheme? customTheme,
    String translationsPath = "assets/translations",
    AppTheme Function(BuildContext)? initTheme,
  }) async {
    /// Be sure all widget and flutter system are initialized
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb) {
      setPathUrlStrategy();
    }

    /// Ensure Translations is correctly initialized
    await EasyLocalization.ensureInitialized();

    /// Register model and data via Get_it package
    await _registerAppModel(
        appModel: applicationModel, customTheme: customTheme);

    /// Initialize services
    /// Firebase
    await _launchFirebaseService(appModel: applicationModel);

    return runApp(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: applicationModel.supportedLocales,
          fallbackLocale: applicationModel.defaultLocale,
          startLocale: applicationModel.initialLocale,
          path: translationsPath,
          child: ScreenUtilInit(
            designSize: applicationModel.designSize,
            builder: ((context, child) {
              if (!GetIt.instance.isRegistered<AppTheme>() &&
                  initTheme != null) {
                GetIt.instance.registerSingleton(initTheme(context));
              }
              return ResponsiveBreakpoints.builder(
                child: BouncingScrollWrapper(child: child!),
                breakpoints: const [
                  Breakpoint(start: 0, end: 450, name: PHONE),
                  Breakpoint(start: 451, end: 800, name: TABLET),
                  Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
                ],
              );
            }),
            child: MainPage(appRouter: appRouter),
          ),
        ),
      ),
    );
  }
}

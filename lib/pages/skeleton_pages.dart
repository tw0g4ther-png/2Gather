// Pages wrapper pour les pages du skeleton
// Ces pages sont nécessaires pour que auto_route puisse les générer correctement

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart' as skeleton;

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const skeleton.DashboardPage();
  }
}

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const skeleton.LoginPage();
  }
}

@RoutePage()
class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const skeleton.CreateAccountPage();
  }
}

@RoutePage()
class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SelectableText(
          "authentication.logout.content".tr(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const skeleton.ProfilePage();
  }
}

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return skeleton.SettingsPage();
  }
}

@RoutePage()
class ResponsiveSettingsPage extends StatelessWidget {
  final String? nodeTag;

  const ResponsiveSettingsPage({super.key, @PathParam('nodeTag') this.nodeTag});

  @override
  Widget build(BuildContext context) {
    return skeleton.ResponsiveSettingsPage(nodeTag: nodeTag ?? '');
  }
}

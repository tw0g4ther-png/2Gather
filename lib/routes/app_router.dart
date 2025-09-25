import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart'
    hide
        DashboardPage,
        LoginPage,
        CreateAccountPage,
        ProfilePage,
        SettingsPage,
        ResponsiveSettingsPage;

// Import des pages wrapper du skeleton
import 'package:twogather/pages/skeleton_pages.dart';

// Import des modèles nécessaires
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';

// Import des pages de l'application
import 'package:twogather/pages/complete_profil/complete_profil.dart';
import 'package:twogather/pages/home/fiesta/fiesta_detail.dart';
import 'package:twogather/pages/home/fiesta/fiesta_info_page.dart';
import 'package:twogather/pages/home/fiesta/handle_duo.dart';
import 'package:twogather/pages/home/fiesta/note_fiesta_page.dart';
import 'package:twogather/pages/home/fiesta_form/fiesta_form.dart';
import 'package:twogather/pages/home/fiesta_form/fiesta_update_form_page.dart';
import 'package:twogather/pages/home/friend/friend_info_page.dart';
import 'package:twogather/pages/home/friend/friend_profil_page.dart';
import 'package:twogather/pages/home/friend/is_match_page.dart';
import 'package:twogather/pages/home/friend/user_profil_page.dart';
import 'package:twogather/pages/home/gamification/level_page.dart';
import 'package:twogather/pages/home/host_form/host_form_page.dart';
import 'package:twogather/pages/home/host_level/host_level.dart';
import 'package:twogather/pages/home/network/request_network_page.dart';
import 'package:twogather/pages/home/network/search_network_page.dart';
import 'package:twogather/pages/home/notification/notification_page.dart';
import 'package:twogather/pages/home/report/report_page.dart';
import 'package:twogather/pages/home/report/report_succes_page.dart';
import 'package:twogather/pages/home_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final LoginGuard loginGuard;
  final AlreadyLoggedGuard alreadyLoggedGuard;
  final LogoutGuard logoutGuard;

  AppRouter({
    required this.loginGuard,
    required this.alreadyLoggedGuard,
    required this.logoutGuard,
  });

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/dashboard',
      page: DashboardRoute.page,
      initial: true,
      guards: [loginGuard],
      children: [
        /// Home Page
        AutoRoute(path: 'home', page: HomeRoute.page, initial: true),

        /// Network Page
        AutoRoute(path: 'network/search', page: SearchNetworkRoute.page),
        AutoRoute(path: 'network/request', page: RequestNetworkRoute.page),

        /// HostForm Page
        AutoRoute(path: 'host/form', page: HostFormRoute.page),

        /// FiestaForm Page
        AutoRoute(path: 'fiesta/form', page: FiestaFormRoute.page),
        AutoRoute(path: 'fiesta/update', page: FiestaUpdateFormRoute.page),

        /// Notification Page
        AutoRoute(path: 'notif', page: NotificationRoute.page),

        /// Users info page
        AutoRoute(path: 'users', page: FriendInfoRoute.page),
        AutoRoute(path: 'match', page: IsMatchRoute.page),

        /// Fiesta info page
        AutoRoute(path: 'fiesta', page: FiestaInfoRoute.page),
        AutoRoute(path: 'fiesta/detail/:id', page: FiestaDetailRoute.page),
        AutoRoute(path: 'fiesta/host/:id', page: FiestaHandleDuoRoute.page),
        AutoRoute(
          path: 'fiesta/:fiestaId/note/:hostId',
          page: NoteFiestaRoute.page,
        ),

        /// Friend Page
        AutoRoute(path: 'friend/profil/:id', page: FriendProfilRoute.page),
        AutoRoute(path: 'user/profil/:id', page: UserProfilRoute.page),

        /// Report Page
        AutoRoute(path: 'report/:userId', page: ReportRoute.page),
        AutoRoute(
          path: 'report/response/success/',
          page: ReportSuccessRoute.page,
        ),

        /// Gamification Page
        AutoRoute(path: 'leveling', page: LevelRoute.page),

        /// Profil Page
        AutoRoute(
          path: 'profile',
          page: ProfileRoute.page,
          children: [
            /// HostLevel Page
            AutoRoute(path: 'level', page: HostLevelRoute.page),
            AutoRoute(
              path: 'settings/:nodeTag',
              page: ResponsiveSettingsRoute.page,
            ),
            AutoRoute(path: 'settings', page: SettingsRoute.page),
          ],
        ),
      ],
    ),
    AutoRoute(
      path: '/login',
      page: LoginRoute.page,
      guards: [alreadyLoggedGuard],
    ),
    AutoRoute(
      path: '/create-account',
      page: CreateAccountRoute.page,
      guards: [alreadyLoggedGuard],
    ),
    AutoRoute(
      path: '/complete-profil',
      page: CompleteProfilRoute.page,
      guards: [loginGuard],
    ),
    AutoRoute(path: '/logout', page: LogoutRoute.page, guards: [logoutGuard]),
    RedirectRoute(path: '*', redirectTo: '/dashboard'),
  ];
}

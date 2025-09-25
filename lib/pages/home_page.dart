import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:permissionrequest/permissons_package.dart' as permissions;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twogather/chat/repertoire/indexRepertoire.dart';
import 'package:twogather/chat/riverpods/me_notifier.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/pages/home/fiesta_home.dart';
import 'package:twogather/pages/home/friend_home.dart';
import 'package:twogather/pages/home/network_home.dart';
import 'package:twogather/pages/home/profil_home.dart';
import 'package:twogather/provider/geoloc_provider.dart';
import 'package:twogather/main.dart';
import 'package:twogather/widgets/badge/notification_badge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

final geolocProvider = ChangeNotifierProvider<GeolocProvider>((ref) {
  return GeolocProvider();
});

final homeControllerProvider = Provider<PageController>((ref) {
  return PageController(initialPage: 2);
});

/// Provider pour gérer l'index actif du bottom navigation bar
final bottomNavigationIndexProvider = StateProvider<int>((ref) => 2);

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _permissionsChecked = false;
  bool _showingPermissions = false;

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'default_channel',
    'notif',
    importance: Importance.high,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      printInDebug(message.notification);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      } else if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
              presentBadge: true,
            ),
          ),
        );
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    printInDebug(message.data);
  }

  /// Vérifie si l'utilisateur est approuvé (completeProfilStatus == "approved")
  Future<bool> _isUserApproved() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return false;

      final appModel = GetIt.instance<ApplicationDataModel>();
      final doc = await FirebaseFirestore.instance
          .collection(appModel.userCollectionPath)
          .doc(currentUser.uid)
          .get();

      if (!doc.exists) return false;

      final data = doc.data();
      final status = data?['completeProfilStatus'] as String?;

      printInDebug("[HomePage] Statut utilisateur: $status");
      return status == "approved";
    } catch (e) {
      printInDebug("[HomePage] Erreur lors de la vérification du statut: $e");
      return false;
    }
  }

  /// Vérifie si les permissions ont déjà été demandées pour cet utilisateur
  Future<bool> _arePermissionsAlreadyRequested() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return true; // Considérer comme déjà demandées si pas d'utilisateur
      }

      final prefs = await SharedPreferences.getInstance();
      final requestedUsers =
          prefs.getStringList("permissions_requested_users") ?? [];

      final alreadyRequested = requestedUsers.contains(currentUser.uid);
      printInDebug(
        "[HomePage] Permissions déjà demandées pour ${currentUser.uid}: $alreadyRequested",
      );

      return alreadyRequested;
    } catch (e) {
      printInDebug(
        "[HomePage] Erreur lors de la vérification des permissions: $e",
      );
      return true; // En cas d'erreur, considérer comme déjà demandées
    }
  }

  /// Marque les permissions comme demandées pour l'utilisateur actuel
  Future<void> _markPermissionsAsRequested() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final prefs = await SharedPreferences.getInstance();
      final requestedUsers =
          prefs.getStringList("permissions_requested_users") ?? [];

      if (!requestedUsers.contains(currentUser.uid)) {
        requestedUsers.add(currentUser.uid);
        await prefs.setStringList(
          "permissions_requested_users",
          requestedUsers,
        );
        printInDebug(
          "[HomePage] Permissions marquées comme demandées pour ${currentUser.uid}",
        );
      }
    } catch (e) {
      printInDebug(
        "[HomePage] Erreur lors de la sauvegarde des permissions: $e",
      );
    }
  }

  /// Affiche les permissions si nécessaire
  Future<void> _checkAndShowPermissions() async {
    if (_permissionsChecked || _showingPermissions) return;

    _permissionsChecked = true;

    // Vérifier si l'utilisateur est approuvé
    final isApproved = await _isUserApproved();
    if (!isApproved) {
      printInDebug(
        "[HomePage] Utilisateur non approuvé - Permissions non affichées",
      );
      return;
    }

    // Vérifier si les permissions ont déjà été demandées
    final alreadyRequested = await _arePermissionsAlreadyRequested();
    if (alreadyRequested) {
      printInDebug("[HomePage] Permissions déjà demandées - Pas d'affichage");
      return;
    }

    // Afficher les permissions
    _showingPermissions = true;
    printInDebug(
      "[HomePage] Affichage des permissions pour utilisateur approuvé",
    );

    await _showPermissionsFlow();

    _showingPermissions = false;
  }

  /// Affiche le flux de permissions
  Future<void> _showPermissionsFlow() async {
    final PageController controller = PageController(initialPage: 0);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PopScope(
            canPop: false,
            child: Scaffold(
              body: permissions.PermissionsPageViewCustom(
                pages: [
                  // 1. Géolocalisation
                  permissions.GeolocPermission(
                    validateText: "Activer la géolocalisation",
                    title: "Géolocalisation",
                    subtitle:
                        "Pour utiliser pleinement notre application mobile, tu dois accepter la géolocalisation.",
                    pageController: controller,
                    asset: "assets/images/img_permission_geoloc.png",
                    package: null,
                  ),
                  // 2. Notifications Push
                  permissions.NotificationsPermission(
                    pageController: controller,
                    userCollection: "/users",
                    title: "Notifications Push",
                    subtitle:
                        "Souhaites-tu activer notre service de notifications Push ? Il t'aidera à exploiter tout le potentiel de notre application.",
                    validateText: "Activer les notifications",
                    asset: "assets/images/img_permission_push_notif.png",
                    package: null,
                  ),
                ],
                pageController: controller,
              ),
            ),
          );
        },
      ),
    );

    // Marquer les permissions comme demandées après fermeture
    await _markPermissionsAsRequested();
    printInDebug("[HomePage] Flux de permissions terminé");
  }

  @override
  void initState() {
    printInDebug("[HomePage] InitState appelé");

    // Vérifier que l'utilisateur est connecté avant d'initialiser
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      printInDebug(
        "[HomePage] Utilisateur non connecté dans initState - Initialisation différée",
      );
      super.initState();
      return;
    }

    printInDebug(
      "[HomePage] Initialisation pour l'utilisateur: ${currentUser.uid}",
    );

    ref.read(geolocProvider).loadPosition();
    init();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Double vérification que l'utilisateur est toujours connecté
      final currentUserCallback = FirebaseAuth.instance.currentUser;
      if (currentUserCallback != null) {
        printInDebug(
          "[HomePage] Configuration meModelChangeNotifier pour: ${currentUserCallback.uid}",
        );
        ref.read(meModelChangeNotifier).setMyUid(currentUserCallback.uid);

        // Vérifier et afficher les permissions si nécessaire
        _checkAndShowPermissions();
      } else {
        printInDebug(
          "[HomePage] Utilisateur non connecté dans addPostFrameCallback",
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printInDebug("[HomePage] Build appelé");

    // Vérifier que l'utilisateur est connecté avant de construire les pages
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      printInDebug(
        "[HomePage] Utilisateur non connecté - Affichage d'un loader",
      );
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    printInDebug(
      "[HomePage] Construction des pages pour l'utilisateur: ${currentUser.uid}",
    );

    // Afficher directement l'interface normale
    return MobilePageView(
      pageController: ref.read(homeControllerProvider),
      pages: [
        IndexRepertoire(meId: currentUser.uid),
        const NetworkHomePage(),
        const FiestaHomePage(),
        const FriendHomePage(),
        const ProfilHomePage(),
      ],
      bottomBarBuilder: (context, child, page) => Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          formatWidth(26),
          0,
          formatWidth(26),
          (MediaQuery.of(context).padding.bottom),
        ),
        height: formatHeight(77) + (MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 8,
              spreadRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final val = ref.watch(bottomNavigationIndexProvider);
            final unreadNotif = ref.watch(notificationProvider).unreadCount;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    ref.read(homeControllerProvider).jumpToPage(0);
                    ref.read(bottomNavigationIndexProvider.notifier).state = 0;
                  },
                  child: SvgPicture.asset(
                    "assets/svg/ic_nav_tchat.svg",
                    colorFilter: val == 0
                        ? ColorFilter.mode(AppColor.mainColor, BlendMode.srcIn)
                        : null,
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(homeControllerProvider).jumpToPage(1);
                    ref.read(bottomNavigationIndexProvider.notifier).state = 1;
                  },
                  child: NotificationBadge(
                    count: unreadNotif,
                    child: SvgPicture.asset(
                      "assets/svg/ic_nav_network.svg",
                      colorFilter: val == 1
                          ? ColorFilter.mode(
                              AppColor.mainColor,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(homeControllerProvider).jumpToPage(2);
                    ref.read(bottomNavigationIndexProvider.notifier).state = 2;
                  },
                  child: SizedBox(
                    height: formatWidth(50),
                    width: formatWidth(50),
                    child: Image.asset("assets/images/app_logo.png"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(homeControllerProvider).jumpToPage(3);
                    ref.read(bottomNavigationIndexProvider.notifier).state = 3;
                  },
                  child: SvgPicture.asset(
                    "assets/svg/ic_nav_friend.svg",
                    colorFilter: val == 3
                        ? ColorFilter.mode(AppColor.mainColor, BlendMode.srcIn)
                        : null,
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(homeControllerProvider).jumpToPage(4);
                    ref.read(bottomNavigationIndexProvider.notifier).state = 4;
                  },
                  child: SvgPicture.asset(
                    "assets/svg/ic_nav_profil.svg",
                    colorFilter: val == 4
                        ? ColorFilter.mode(AppColor.mainColor, BlendMode.srcIn)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

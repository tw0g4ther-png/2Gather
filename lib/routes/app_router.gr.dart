// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CompleteProfilPage]
class CompleteProfilRoute extends PageRouteInfo<void> {
  const CompleteProfilRoute({List<PageRouteInfo>? children})
    : super(CompleteProfilRoute.name, initialChildren: children);

  static const String name = 'CompleteProfilRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CompleteProfilPage();
    },
  );
}

/// generated route for
/// [CreateAccountPage]
class CreateAccountRoute extends PageRouteInfo<void> {
  const CreateAccountRoute({List<PageRouteInfo>? children})
    : super(CreateAccountRoute.name, initialChildren: children);

  static const String name = 'CreateAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateAccountPage();
    },
  );
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardPage();
    },
  );
}

/// generated route for
/// [FiestaDetailPage]
class FiestaDetailRoute extends PageRouteInfo<FiestaDetailRouteArgs> {
  FiestaDetailRoute({
    Key? key,
    required String fiestaId,
    List<PageRouteInfo>? children,
  }) : super(
         FiestaDetailRoute.name,
         args: FiestaDetailRouteArgs(key: key, fiestaId: fiestaId),
         rawPathParams: {'id': fiestaId},
         initialChildren: children,
       );

  static const String name = 'FiestaDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<FiestaDetailRouteArgs>(
        orElse: () =>
            FiestaDetailRouteArgs(fiestaId: pathParams.getString('id')),
      );
      return FiestaDetailPage(key: args.key, fiestaId: args.fiestaId);
    },
  );
}

class FiestaDetailRouteArgs {
  const FiestaDetailRouteArgs({this.key, required this.fiestaId});

  final Key? key;

  final String fiestaId;

  @override
  String toString() {
    return 'FiestaDetailRouteArgs{key: $key, fiestaId: $fiestaId}';
  }
}

/// generated route for
/// [FiestaFormPage]
class FiestaFormRoute extends PageRouteInfo<void> {
  const FiestaFormRoute({List<PageRouteInfo>? children})
    : super(FiestaFormRoute.name, initialChildren: children);

  static const String name = 'FiestaFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FiestaFormPage();
    },
  );
}

/// generated route for
/// [FiestaHandleDuoPage]
class FiestaHandleDuoRoute extends PageRouteInfo<FiestaHandleDuoRouteArgs> {
  FiestaHandleDuoRoute({
    Key? key,
    required String fiestaId,
    FiestaModel? data,
    List<PageRouteInfo>? children,
  }) : super(
         FiestaHandleDuoRoute.name,
         args: FiestaHandleDuoRouteArgs(
           key: key,
           fiestaId: fiestaId,
           data: data,
         ),
         rawPathParams: {'id': fiestaId},
         initialChildren: children,
       );

  static const String name = 'FiestaHandleDuoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<FiestaHandleDuoRouteArgs>(
        orElse: () =>
            FiestaHandleDuoRouteArgs(fiestaId: pathParams.getString('id')),
      );
      return FiestaHandleDuoPage(
        key: args.key,
        fiestaId: args.fiestaId,
        data: args.data,
      );
    },
  );
}

class FiestaHandleDuoRouteArgs {
  const FiestaHandleDuoRouteArgs({this.key, required this.fiestaId, this.data});

  final Key? key;

  final String fiestaId;

  final FiestaModel? data;

  @override
  String toString() {
    return 'FiestaHandleDuoRouteArgs{key: $key, fiestaId: $fiestaId, data: $data}';
  }
}

/// generated route for
/// [FiestaInfoPage]
class FiestaInfoRoute extends PageRouteInfo<FiestaInfoRouteArgs> {
  FiestaInfoRoute({
    Key? key,
    required FiestaModel data,
    bool showAdress = false,
    List<PageRouteInfo>? children,
  }) : super(
         FiestaInfoRoute.name,
         args: FiestaInfoRouteArgs(
           key: key,
           data: data,
           showAdress: showAdress,
         ),
         initialChildren: children,
       );

  static const String name = 'FiestaInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FiestaInfoRouteArgs>();
      return FiestaInfoPage(
        key: args.key,
        data: args.data,
        showAdress: args.showAdress,
      );
    },
  );
}

class FiestaInfoRouteArgs {
  const FiestaInfoRouteArgs({
    this.key,
    required this.data,
    this.showAdress = false,
  });

  final Key? key;

  final FiestaModel data;

  final bool showAdress;

  @override
  String toString() {
    return 'FiestaInfoRouteArgs{key: $key, data: $data, showAdress: $showAdress}';
  }
}

/// generated route for
/// [FiestaUpdateFormPage]
class FiestaUpdateFormRoute extends PageRouteInfo<FiestaUpdateFormRouteArgs> {
  FiestaUpdateFormRoute({
    Key? key,
    required String fiestaId,
    List<PageRouteInfo>? children,
  }) : super(
         FiestaUpdateFormRoute.name,
         args: FiestaUpdateFormRouteArgs(key: key, fiestaId: fiestaId),
         initialChildren: children,
       );

  static const String name = 'FiestaUpdateFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FiestaUpdateFormRouteArgs>();
      return FiestaUpdateFormPage(key: args.key, fiestaId: args.fiestaId);
    },
  );
}

class FiestaUpdateFormRouteArgs {
  const FiestaUpdateFormRouteArgs({this.key, required this.fiestaId});

  final Key? key;

  final String fiestaId;

  @override
  String toString() {
    return 'FiestaUpdateFormRouteArgs{key: $key, fiestaId: $fiestaId}';
  }
}

/// generated route for
/// [FriendInfoPage]
class FriendInfoRoute extends PageRouteInfo<FriendInfoRouteArgs> {
  FriendInfoRoute({
    Key? key,
    required AppUserModel user,
    List<PageRouteInfo>? children,
  }) : super(
         FriendInfoRoute.name,
         args: FriendInfoRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'FriendInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FriendInfoRouteArgs>();
      return FriendInfoPage(key: args.key, user: args.user);
    },
  );
}

class FriendInfoRouteArgs {
  const FriendInfoRouteArgs({this.key, required this.user});

  final Key? key;

  final AppUserModel user;

  @override
  String toString() {
    return 'FriendInfoRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [FriendProfilPage]
class FriendProfilRoute extends PageRouteInfo<FriendProfilRouteArgs> {
  FriendProfilRoute({
    Key? key,
    required String id,
    AppUserModel? userModel,
    List<PageRouteInfo>? children,
  }) : super(
         FriendProfilRoute.name,
         args: FriendProfilRouteArgs(key: key, id: id, userModel: userModel),
         rawPathParams: {'id': id},
         initialChildren: children,
       );

  static const String name = 'FriendProfilRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<FriendProfilRouteArgs>(
        orElse: () => FriendProfilRouteArgs(id: pathParams.getString('id')),
      );
      return FriendProfilPage(
        key: args.key,
        id: args.id,
        userModel: args.userModel,
      );
    },
  );
}

class FriendProfilRouteArgs {
  const FriendProfilRouteArgs({this.key, required this.id, this.userModel});

  final Key? key;

  final String id;

  final AppUserModel? userModel;

  @override
  String toString() {
    return 'FriendProfilRouteArgs{key: $key, id: $id, userModel: $userModel}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [HostFormPage]
class HostFormRoute extends PageRouteInfo<void> {
  const HostFormRoute({List<PageRouteInfo>? children})
    : super(HostFormRoute.name, initialChildren: children);

  static const String name = 'HostFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HostFormPage();
    },
  );
}

/// generated route for
/// [HostLevelPage]
class HostLevelRoute extends PageRouteInfo<void> {
  const HostLevelRoute({List<PageRouteInfo>? children})
    : super(HostLevelRoute.name, initialChildren: children);

  static const String name = 'HostLevelRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HostLevelPage();
    },
  );
}

/// generated route for
/// [IsMatchPage]
class IsMatchRoute extends PageRouteInfo<IsMatchRouteArgs> {
  IsMatchRoute({
    Key? key,
    required AppUserModel user,
    List<PageRouteInfo>? children,
  }) : super(
         IsMatchRoute.name,
         args: IsMatchRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'IsMatchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IsMatchRouteArgs>();
      return IsMatchPage(key: args.key, user: args.user);
    },
  );
}

class IsMatchRouteArgs {
  const IsMatchRouteArgs({this.key, required this.user});

  final Key? key;

  final AppUserModel user;

  @override
  String toString() {
    return 'IsMatchRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [LevelPage]
class LevelRoute extends PageRouteInfo<void> {
  const LevelRoute({List<PageRouteInfo>? children})
    : super(LevelRoute.name, initialChildren: children);

  static const String name = 'LevelRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LevelPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [LogoutPage]
class LogoutRoute extends PageRouteInfo<void> {
  const LogoutRoute({List<PageRouteInfo>? children})
    : super(LogoutRoute.name, initialChildren: children);

  static const String name = 'LogoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LogoutPage();
    },
  );
}

/// generated route for
/// [NoteFiestaPage]
class NoteFiestaRoute extends PageRouteInfo<NoteFiestaRouteArgs> {
  NoteFiestaRoute({
    Key? key,
    required String fiestaId,
    required String hostId,
    List<PageRouteInfo>? children,
  }) : super(
         NoteFiestaRoute.name,
         args: NoteFiestaRouteArgs(
           key: key,
           fiestaId: fiestaId,
           hostId: hostId,
         ),
         rawPathParams: {'fiestaId': fiestaId, 'hostId': hostId},
         initialChildren: children,
       );

  static const String name = 'NoteFiestaRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<NoteFiestaRouteArgs>(
        orElse: () => NoteFiestaRouteArgs(
          fiestaId: pathParams.getString('fiestaId'),
          hostId: pathParams.getString('hostId'),
        ),
      );
      return NoteFiestaPage(
        key: args.key,
        fiestaId: args.fiestaId,
        hostId: args.hostId,
      );
    },
  );
}

class NoteFiestaRouteArgs {
  const NoteFiestaRouteArgs({
    this.key,
    required this.fiestaId,
    required this.hostId,
  });

  final Key? key;

  final String fiestaId;

  final String hostId;

  @override
  String toString() {
    return 'NoteFiestaRouteArgs{key: $key, fiestaId: $fiestaId, hostId: $hostId}';
  }
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [ReportPage]
class ReportRoute extends PageRouteInfo<ReportRouteArgs> {
  ReportRoute({
    Key? key,
    required String userId,
    String? reportedSubUser,
    List<PageRouteInfo>? children,
  }) : super(
         ReportRoute.name,
         args: ReportRouteArgs(
           key: key,
           userId: userId,
           reportedSubUser: reportedSubUser,
         ),
         rawPathParams: {'userId': userId},
         rawQueryParams: {'subUserId': reportedSubUser},
         initialChildren: children,
       );

  static const String name = 'ReportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<ReportRouteArgs>(
        orElse: () => ReportRouteArgs(
          userId: pathParams.getString('userId'),
          reportedSubUser: queryParams.optString('subUserId'),
        ),
      );
      return ReportPage(
        key: args.key,
        userId: args.userId,
        reportedSubUser: args.reportedSubUser,
      );
    },
  );
}

class ReportRouteArgs {
  const ReportRouteArgs({this.key, required this.userId, this.reportedSubUser});

  final Key? key;

  final String userId;

  final String? reportedSubUser;

  @override
  String toString() {
    return 'ReportRouteArgs{key: $key, userId: $userId, reportedSubUser: $reportedSubUser}';
  }
}

/// generated route for
/// [ReportSuccessPage]
class ReportSuccessRoute extends PageRouteInfo<void> {
  const ReportSuccessRoute({List<PageRouteInfo>? children})
    : super(ReportSuccessRoute.name, initialChildren: children);

  static const String name = 'ReportSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReportSuccessPage();
    },
  );
}

/// generated route for
/// [RequestNetworkPage]
class RequestNetworkRoute extends PageRouteInfo<void> {
  const RequestNetworkRoute({List<PageRouteInfo>? children})
    : super(RequestNetworkRoute.name, initialChildren: children);

  static const String name = 'RequestNetworkRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RequestNetworkPage();
    },
  );
}

/// generated route for
/// [ResponsiveSettingsPage]
class ResponsiveSettingsRoute
    extends PageRouteInfo<ResponsiveSettingsRouteArgs> {
  ResponsiveSettingsRoute({
    Key? key,
    String? nodeTag,
    List<PageRouteInfo>? children,
  }) : super(
         ResponsiveSettingsRoute.name,
         args: ResponsiveSettingsRouteArgs(key: key, nodeTag: nodeTag),
         rawPathParams: {'nodeTag': nodeTag},
         initialChildren: children,
       );

  static const String name = 'ResponsiveSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ResponsiveSettingsRouteArgs>(
        orElse: () => ResponsiveSettingsRouteArgs(
          nodeTag: pathParams.optString('nodeTag'),
        ),
      );
      return ResponsiveSettingsPage(key: args.key, nodeTag: args.nodeTag);
    },
  );
}

class ResponsiveSettingsRouteArgs {
  const ResponsiveSettingsRouteArgs({this.key, this.nodeTag});

  final Key? key;

  final String? nodeTag;

  @override
  String toString() {
    return 'ResponsiveSettingsRouteArgs{key: $key, nodeTag: $nodeTag}';
  }
}

/// generated route for
/// [SearchNetworkPage]
class SearchNetworkRoute extends PageRouteInfo<void> {
  const SearchNetworkRoute({List<PageRouteInfo>? children})
    : super(SearchNetworkRoute.name, initialChildren: children);

  static const String name = 'SearchNetworkRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchNetworkPage();
    },
  );
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}

/// generated route for
/// [UserProfilPage]
class UserProfilRoute extends PageRouteInfo<UserProfilRouteArgs> {
  UserProfilRoute({Key? key, required String id, List<PageRouteInfo>? children})
    : super(
        UserProfilRoute.name,
        args: UserProfilRouteArgs(key: key, id: id),
        rawPathParams: {'id': id},
        initialChildren: children,
      );

  static const String name = 'UserProfilRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserProfilRouteArgs>(
        orElse: () => UserProfilRouteArgs(id: pathParams.getString('id')),
      );
      return UserProfilPage(key: args.key, id: args.id);
    },
  );
}

class UserProfilRouteArgs {
  const UserProfilRouteArgs({this.key, required this.id});

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'UserProfilRouteArgs{key: $key, id: $id}';
  }
}

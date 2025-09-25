import 'widgets/messages/text_message.dart';
import 'package:flutter/services.dart';
import 'repertoire/for_testing.dart';
import 'services/cacheManager/index_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase est déjà initialisé par le framework core_kosmos dans main.dart

  // Add french messages
  setLocaleMessages('fr', FrShortMessagesKosmos());

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

VideoControllerService servicePlayer = CachedVideoControllerService(
  DefaultCacheManager(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', '')],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
      home: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: const ChooseUser(),
        ),
      ),
    );
  }
}

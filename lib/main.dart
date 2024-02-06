import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/helpers/auth_helpers.dart';
import 'package:krishanthmart_new/utils/other_config.dart';
import 'package:krishanthmart_new/utils/push_notification_service.dart';
import 'package:krishanthmart_new/utils/routes.dart';
import 'package:krishanthmart_new/utils/shared_value.dart';
import 'package:krishanthmart_new/utils/themes.dart';
import 'package:krishanthmart_new/views/auth/splash_screen.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_value/shared_value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'helpers/business_settings_helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // // AddonsHelper().setAddonsData();
  // BusinessSettingHelper().setBusinessSettingData();
  // app_language.load();
  // app_mobile_language.load();
  // app_language_rtl.load();
  // // is_logged_in.load();
  //
  // access_token.load().whenComplete(() {
  //   AuthHelper().fetch_and_set();
  // });
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(SharedValue.wrapApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then(
      (value) async {
        Firebase.initializeApp().then((value) {
          if (OtherConfig.USE_PUSH_NOTIFICATION) {
            Future.delayed(Duration(milliseconds: 10), () async {
              PushNotificationService().initialise();
            });
          }
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(360, 690),
      // minTextAdapt: true,
      // splitScreenMode: true,
      // ensureScreenSize: true,
      builder: (_, child) {
        return GetMaterialApp(
            title: 'KrishanthMart',
            builder: OneContext().builder,
            navigatorKey: OneContext().navigator.key,
            debugShowCheckedModeBanner: false,
            theme: theme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('en'),
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            initialRoute: Routes.mainPage,
            getPages: getPages,
            home: const SplashScreen());
      },
    );
  }
}

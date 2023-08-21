import 'dart:async';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/localization_controller.dart';
import 'package:zawadicash_app/controller/theme_controller.dart';
import 'package:zawadicash_app/helper/notification_helper.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/theme/dark_theme.dart';
import 'package:zawadicash_app/theme/light_theme.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/messages.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:zawadicash_app/helper/get_di.dart' as di;

import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late List<CameraDescription> cameras;

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();

  Map<String, Map<String, String>> languages = await di.init();

  int? orderID;
  try {
    if (GetPlatform.isMobile) {
      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        orderID = notificationAppLaunchDetails
                    ?.notificationResponse?.payload !=
                null
            ? int.parse(
                notificationAppLaunchDetails!.notificationResponse!.payload!)
            : null;
      }

      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {debugPrint(e.toString());}

  runApp(MyApp(languages: languages, orderID: orderID));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent.withOpacity(0.3)));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final int? orderID;
  const MyApp({Key? key, required this.languages, required this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: Get.find<ThemeController>(tag: getClassName<ThemeController>()),
      tag: getClassName<ThemeController>(),
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          init: Get.find<LocalizationController>(tag: getClassName<LocalizationController>()),
          tag: getClassName<LocalizationController>(),
          builder: (localizeController) {
            return GetMaterialApp(
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(),
              title: AppConstants.APP_NAME,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              theme: themeController.darkTheme ? dark : light,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                  AppConstants.languages[0].countryCode),
              initialRoute: RouteHelper.getSplashRoute(),
              getPages: RouteHelper.routes,
              defaultTransition: Transition.topLevel,
              transitionDuration: const Duration(milliseconds: 500),
            );
          },
        );
      },
    );
  }
}

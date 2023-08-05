import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawadicash_app/utils/constants.dart';
import 'package:zawadicash_app/utils/pallete.dart';
import 'package:zawadicash_app/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Add this

  await FaceCamera.initialize(); //Add this

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));

  runApp(
    ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zawadicash App',
        theme: ThemeData(
          primarySwatch: Palette.primaryPaletteColor,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: primaryColor,
            selectionColor: primaryColor,
            selectionHandleColor: primaryColor,
          ),
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: RouteGenerator.splashPage,
        onGenerateRoute: RouteGenerator.generateRoute);
  }
}

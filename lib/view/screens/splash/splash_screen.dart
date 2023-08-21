// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  StreamSubscription<ConnectivityResult>? _onConnectivityChanged;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    _onConnectivityChanged = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {

      if (await ApiChecker.isVpnActive()) {
        showCustomSnackBar('you are using vpn',
            isVpn: true, duration: const Duration(minutes: 10));
      }

      bool isNotConnected = result != ConnectivityResult.wifi &&
          result != ConnectivityResult.mobile;

      showCustomSnackBar(
        isNotConnected ? 'no_connection'.tr : 'connected'.tr,
        duration: Duration(seconds: isNotConnected ? 6000 : 3),
        isError: isNotConnected,
      );

      if (!isNotConnected) {
        _route();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged!.cancel();
  }

  void _route() {
    Get.find<SplashController>(tag: getClassName<SplashController>()).getConfigData().then((value) {
      debugPrint('config call ');
      if (value.isOk) {
        Timer(const Duration(seconds: 1), () async {
          Get.find<SplashController>(tag: getClassName<SplashController>()).initSharedData().then((value) {
            (Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerName().isNotEmpty &&
                    (Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.companyName !=
                        null))
                ? Get.offNamed(RouteHelper.getLoginRoute(
                    countryCode:
                        Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerCountryCode(),
                    phoneNumber:
                        Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerNumber()))
                : Get.offNamed(RouteHelper.getChoseLoginRegRoute());
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.logo, height: 175),
          ],
        ),
      ),
    );
  }
}

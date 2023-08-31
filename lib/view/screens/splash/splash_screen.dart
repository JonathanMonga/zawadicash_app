import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/model/response/user_data.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    _onConnectivityChanged = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      if(await ApiChecker.isVpnActive()) {
        showCustomSnackBar('you are using vpn', isVpn: true, duration: const Duration(minutes: 10));
      }
      await _route();

    });

  }


  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  Future<void> _route() async {
    await  Get.find<TransactionMoneyController>().fetchContact().then((_){
      Get.find<SplashController>().getConfigData().then((value) {
        if(value.isOk) {
          Timer(const Duration(seconds: 1), () async {
            Get.find<SplashController>().initSharedData().then((value) {
              UserData? userData = Get.find<AuthController>().getUserData();

              if(userData != null && (Get.find<SplashController>().configModel!.companyName != null)){
                Get.offNamed(RouteHelper.getLoginRoute(
                  countryCode: userData.countryCode,phoneNumber: userData.phone,
                ));
              }else{
                Get.offNamed(RouteHelper.getChoseLoginRegRoute());
              }
            });

          });
        }
      });

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

import 'dart:io';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/data/model/body/error_body.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(Response response) {

    if(response.statusCode == 401) {
      if(Get.currentRoute != RouteHelper.loginScreen) {
        Get.find<AuthController>(tag: getClassName<AuthController>()).removeCustomerToken();
        Get.offAllNamed(
          RouteHelper.getLoginRoute(
            countryCode: Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerCountryCode(),
            phoneNumber: Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerNumber(),
          ),
        );

        showCustomSnackBar(response.body['message'] ?? 'unauthorized'.tr, isIcon: true);

      }

    }
    else if(response.statusCode == 429) {
      showCustomSnackBar('to_money_login_attempts'.tr);

    } else if(response.statusCode == -1){
      Get.find<AuthController>(tag: getClassName<AuthController>()).removeCustomerToken();
      Get.offAllNamed(RouteHelper.getLoginRoute(
        countryCode: Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerCountryCode(),
        phoneNumber: Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerNumber(),
      ));
      showCustomSnackBar('you are using vpn', isVpn: true, duration: const Duration(minutes: 10));

    }
    else {
      showCustomSnackBar(response.body!['message'] ?? ErrorBody.fromJson(response.body).errors!.first.message ?? '', isError: true);
    }
  }

  static Future<bool> isVpnActive() async {
    bool isVpnActive;
    List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, type: InternetAddressType.any);
    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) =>
    interface.name.contains("tun") ||
        interface.name.contains("ppp") ||
        interface.name.contains("pptp"))
        : isVpnActive = false;

    return isVpnActive;
  }
}

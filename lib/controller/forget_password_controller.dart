import 'package:country_code_picker/country_code.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassController extends GetxController implements GetxService {
  late String _countryCode/*= Get.find<LoginController>().countryCode*/;
  String get countryCode => _countryCode;
  late String _initNumber;
  String get initNumber => _initNumber;
  late String _otp;
  setOtp(String otp) {
    _otp = otp;
  }

  setInitialCode(String code) {
    _countryCode = code;
    update();
  }

  setCountryCode(CountryCode code) {
    _countryCode = code.toString();
    update();
  }

  // setInitialNumber(){
  //   // _initNumber = Get.find<LoginController>().phoneController.text;
  //   //
  //   // phoneNumberController.text = _initNumber == null ? null : _initNumber;
  //   // update();
  //
  // }

  resetPassword(TextEditingController newPassController,
      TextEditingController confirmPassController, String phoneNumber) {
    if (newPassController.text.isEmpty || confirmPassController.text.isEmpty) {
      showCustomSnackBar('please_enter_your_valid_pin'.tr, isError: true);
    } else if (newPassController.text.length < 4) {
      showCustomSnackBar('pin_should_be_4_digit'.tr, isError: true);
    } else if (newPassController.text == confirmPassController.text) {
      // write code
      String number = phoneNumber;
      debugPrint("phone : $number");
      debugPrint("otp : $_otp");
      debugPrint("pass : ${newPassController.text}");
      debugPrint("Confirm pass : ${confirmPassController.text}");
      Get.find<AuthController>().resetPassword(
          number, _otp, newPassController.text, confirmPassController.text);
    } else {
      showCustomSnackBar('pin_not_matched'.tr, isError: true);
    }
  }

  sendForOtpResponse(
      {required BuildContext context, required String phoneNumber}) async {
    String number = phoneNumber;
    if (number.isEmpty) {
      showCustomSnackBar('please_give_your_phone_number'.tr, isError: true);
    } else if (number.contains(RegExp(r'[A-Z]'))) {
      showCustomSnackBar('phone_number_not_contain_characters'.tr,
          isError: true);
    } else if (number.contains(RegExp(r'[a-z]'))) {
      showCustomSnackBar('phone_number_not_contain_characters'.tr,
          isError: true);
    } else if (number.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      showCustomSnackBar('phone_number_not_contain_spatial_characters'.tr,
          isError: true);
    } else {
      String phoneNumber = _countryCode + number;
      Get.find<AuthController>().otpForForgetPass(phoneNumber, context);

      debugPrint('=====Phone=====>$phoneNumber');
    }
  }
}

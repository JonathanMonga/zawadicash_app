import 'package:country_code_picker/country_code_picker.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController implements GetxService {
  String _countryCode = Get.find<SplashController>(tag: getClassName<SplashController>()).getCountryCode();
  late String _phoneNumber;

  String get countryCode => _countryCode;
  String get phoneNumber => _phoneNumber;

  setCountryCode(CountryCode code) {
    _countryCode = code.toString();
    update();
  }

  setPhoneNumber(String phone) {
    _phoneNumber = phone;
    update();
  }

  setInitCountryCode(String code) {
    _countryCode = code;
  }

  sendOtpResponse({required String number}) {
    String number0 = number;
    if (number0.isEmpty) {
      showCustomSnackBar('please_give_your_phone_number'.tr, isError: true);
    } else if (number0.contains(RegExp(r'[A-Z]'))) {
      showCustomSnackBar('phone_number_not_contain_characters'.tr,
          isError: true);
    } else if (number0.contains(RegExp(r'[a-z]'))) {
      showCustomSnackBar('phone_number_not_contain_characters'.tr,
          isError: true);
    } else if (number0.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      showCustomSnackBar('phone_number_not_contain_spatial_characters'.tr,
          isError: true);
    } else {
      setPhoneNumber(number);
      Get.find<AuthController>(tag: getClassName<AuthController>()).checkPhone(number);
    }
  }
}

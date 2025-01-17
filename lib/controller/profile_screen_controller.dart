import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/bootom_slider_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/theme_controller.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/model/response/user_info.dart';
import 'package:zawadicash_app/data/repository/profile_repo.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/animated_custom_dialog.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/base/logout_dialog.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  final BottomSliderController bottomSliderController =
      Get.find<BottomSliderController>(tag: getClassName<BottomSliderController>());
  UserInfo? _userInfo;
  bool _isLoading = false;

  UserInfo? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String _gender = 'Male';
  String get gender => _gender;
  // String _occupation = occupationData[1]['title'];
  // String get occupation => _occupation;
  int select = 0;

  set setUserInfo(UserInfo value) {
    _userInfo = value;
  }

  Future<void> profileData({bool reload = false, bool isUpdate = false}) async {
    if (reload) {
      _userInfo = null;
      _isLoading = true;
      if (isUpdate) {
        update();
      }
    }

    if (_userInfo == null) {
      Response response = await profileRepo.getProfileDataApi();
      if (response.statusCode == 200) {
        _userInfo = UserInfo.fromJson(response.body);
        Get.find<AuthController>(tag: getClassName<AuthController>())
            .setCustomerName('${_userInfo!.fName} ${_userInfo!.lName}');
        Get.find<AuthController>(tag: getClassName<AuthController>()).setCustomerQrCode(_userInfo!.qrCode!);
        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
    }
    update();
  }

  Future<void> changePin(
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    if ((oldPassword.length < 4) ||
        (newPassword.length < 4) ||
        (confirmPassword.length < 4)) {
      showCustomSnackBar('please_input_4_digit_pin'.tr);
    } else if (newPassword != confirmPassword) {
      showCustomSnackBar('pin_not_matched'.tr);
    } else {
      _isLoading = true;
      update();
      Response response = await profileRepo.changePinApi(
          oldPin: oldPassword,
          newPin: newPassword,
          confirmPin: confirmPassword);
      if (response.statusCode == 200) {
        await Get.find<AuthController>(tag: getClassName<AuthController>()).updatePin(newPassword);

        Get.offAllNamed(RouteHelper.getLoginRoute(
            countryCode: Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerCountryCode(),
            phoneNumber: Get.find<AuthController>(tag: getClassName<AuthController>()).getCustomerNumber()));
      } else {
        // Get.back();
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
  }

  Future<Response> pinVerify(
      {required String getPin, bool isUpdateTwoFactor = true}) async {
    bottomSliderController.setIsLoading = true;
    final Response response = await profileRepo.pinVerifyApi(pin: getPin);

    if (response.statusCode == 200) {
      bottomSliderController.isPinVerified = true;
      bottomSliderController.setIsLoading = false;
      if (isUpdateTwoFactor) {
        updateTwoFactor();
      }
      bottomSliderController.resetPinField();
    } else {
      bottomSliderController.isPinVerified = false;
      bottomSliderController.setIsLoading = false;
      bottomSliderController.resetPinField();
      Get.back();
      showCustomSnackBar('message');
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> updateTwoFactor() async {
    _isLoading = true;
    update();
    Response response = await profileRepo.updateTwoFactorApi();
    await profileData(reload: true);
    if (response.statusCode == 200) {
      showCustomSnackBar(response.body['message'], isError: false);
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
      _isLoading = false;
    }
    update();
  }

  void routeToTwoFactorAuthScreen(String getPin) {
    pinVerify(getPin: getPin);
  }

  Future twoFactorOnTap() async {
    await pinVerify(getPin: bottomSliderController.pin);
  }

  void twoFactorOnChange() async {
    await updateTwoFactor();
    await profileData(reload: true);
  }

  ///Change theme..
  bool _isSwitched = Get.find<ThemeController>(tag: getClassName<ThemeController>()).darkTheme;
  var textValue = 'Switch is OFF';

  bool get isSwitched => _isSwitched;

  void toggleSwitch(bool value) {
    if (_isSwitched == false) {
      _isSwitched = true;
      textValue = 'Switch Button is ON';
      debugPrint('Switch Button is ON');
      Get.find<ThemeController>(tag: getClassName<ThemeController>()).toggleTheme();
      update();
    } else {
      _isSwitched = false;
      textValue = 'Switch Button is OFF';
      debugPrint('Switch Button is OFF');
      Get.find<ThemeController>(tag: getClassName<ThemeController>()).toggleTheme();
      update();
    }
  }

  void logOut(BuildContext context) {
    showAnimatedDialog(
        context,
        CustomDialog(
          icon: Icons.logout,
          title: 'logout'.tr,
          description: 'are_you_sure_you_want_to_logout'.tr,
          onTapFalseText: 'clear_logout'.tr,
          onTapTrueText: 'logout'.tr,
          isFailed: true,
          onTapFalse: () {
            Get.find<AuthController>(tag: getClassName<AuthController>()).removeBiometricPin().then((value) {
              Get.find<AuthController>(tag: getClassName<AuthController>()).change(0);
              Get.find<AuthController>(tag: getClassName<AuthController>()).logout();
              Get.find<SplashController>(tag: getClassName<SplashController>()).removeSharedData();
              Navigator.pop(context);
            });
          },
          onTapTrue: () {
            Get.find<AuthController>(tag: getClassName<AuthController>()).logout();
            Navigator.of(context).pop(true);
          },
        ),
        dismissible: false,
        isFlip: true);
  }

  setGender(String select) {
    _gender = select;
    update();
  }
  // setSelect(int index, String occupation){
  //   select = index;
  //   _occupation = occupation;
  //   update();
  // }
}

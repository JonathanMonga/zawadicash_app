import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_number/phone_number.dart';
import 'package:zawadicash_app/controller/bootom_slider_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/verification_controller.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/data/model/body/signup_body.dart';
import 'package:zawadicash_app/data/model/response/response_model.dart';
import 'package:zawadicash_app/data/repository/auth_repo.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  
  AuthController({required this.authRepo}) {
    _biometric = authRepo.isBiometricEnabled();
    checkBiometricSupport();
  }

    bool _isLoading = false;
    bool _isVerifying = false;
    bool _biometric = true;
    bool _isBiometricSupported = false;
    List<BiometricType> _bioList = [];
    List<BiometricType> get bioList => _bioList;

    bool get isLoading => _isLoading;
    bool get isVerifying => _isVerifying;
    bool get biometric => _biometric;
    bool get isBiometricSupported => _isBiometricSupported;
    
    Future<void> _callSetting() async {
      final LocalAuthentication bioAuth = LocalAuthentication();
      _bioList = await bioAuth.getAvailableBiometrics();
      if(_bioList.isEmpty){
        try{
          AppSettings.openLockAndPasswordSettings();
        }catch(e){
          debugPrint(e.toString());
        }
      }
    }

    Future<void> updatePin(String pin) async {
      await authRepo.writeSecureData(AppConstants.BIOMETRIC_PIN, pin);
    }

    bool setBiometric(bool isActive) {
      _callSetting().then((value) {
        _callSetting();
      });

      final String pin = Get.find<BottomSliderController>().pin;
      Get.find<ProfileController>().pinVerify(getPin: pin, isUpdateTwoFactor: false).then((response) async {
        if(response.statusCode == 200 && response.body != null) {
          _biometric = isActive;
          authRepo.setBiometric(isActive && _bioList.isNotEmpty);
          try{
            await authRepo.writeSecureData(AppConstants.BIOMETRIC_PIN, pin);
          } catch(e) {
            debugPrint(e.toString());
          }
          Get.back(closeOverlays: true);
          update();
        }
      });

    return _biometric;
  }

  Future<String> biometricPin() async {
      return await  authRepo.readSecureData(AppConstants.BIOMETRIC_PIN) ?? '';
  }
  Future<void> removeBiometricPin() async {
    return await  authRepo.deleteSecureData(AppConstants.BIOMETRIC_PIN);
  }

  checkBiometricWithPin() async {
    if(_biometric && (await biometricPin() == ''))  {
      authRepo.setBiometric(false).then((value) => _biometric = authRepo.isBiometricEnabled());
    }
  }

  Future<void> authenticateWithBiometric(bool autoLogin, String pin) async {
    final LocalAuthentication bioAuth = LocalAuthentication();
    _bioList = await bioAuth.getAvailableBiometrics();
    if((await bioAuth.canCheckBiometrics || await bioAuth.isDeviceSupported()) && authRepo.isBiometricEnabled()) {
      final List<BiometricType> availableBiometrics = await bioAuth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty && (!autoLogin || await biometricPin() != '')) {
        try {
          final bool didAuthenticate = await bioAuth.authenticate(
            localizedReason: autoLogin ? 'please_authenticate_to_login'.tr : 'please_authenticate_to_easy_access_for_next_time'.tr,
            options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
          );
          if(didAuthenticate) {
            if(autoLogin) {
              login(code: getCustomerCountryCode(), phone: getCustomerNumber(), password: await biometricPin());
            }else{
              authRepo.writeSecureData(AppConstants.BIOMETRIC_PIN, pin);
            }
          }else{
            authRepo.setBiometric(false);
          }
        } catch(e) {
          debugPrint(e.toString());
        }
      }else{
       checkBiometricWithPin();
      }
    }
  }
  void checkBiometricSupport() async {
    final LocalAuthentication bioAuth = LocalAuthentication();
    _isBiometricSupported = await bioAuth.canCheckBiometrics || await bioAuth.isDeviceSupported();
  }

  Future<Response> checkPhone(String phoneNumber) async{
      _isLoading = true;
      update();
      Response response = await authRepo.checkPhoneNumber(phoneNumber: phoneNumber);
      if(response.statusCode == 200){
        if(!Get.find<SplashController>().configModel.phoneVerification) {
          requestCameraPermission(fromEditProfile: false);
        }else if(response.body['otp'] == "active"){
          Get.find<VerificationController>().startTimer();
          Get.toNamed(RouteHelper.getVerifyRoute());
        }
        _isLoading = false;
        update();
      }
      else if(response.statusCode == 403){
        late String countryCode;
        late String nationalNumber;
        try{
          PhoneNumber number = await PhoneNumberUtil().parse(phoneNumber);
           countryCode = '+${number.countryCode}';
           nationalNumber = number.nationalNumber;
        }
        catch(e){
          debugPrint(e.toString());
        }
        authRepo.setBiometric(false);
        Get.offNamed(RouteHelper.getLoginRoute(countryCode: countryCode,phoneNumber: nationalNumber));
        _isLoading = false;

      }
      else{
        ApiChecker.checkApi(response);
      }
      update();
      return response;
    }
  Future<Response> resendOtp({required String phoneNumber}) async{
    _isLoading = true;
    update();
    Response response = await authRepo.resendOtp(phoneNumber: phoneNumber);
    if(response.statusCode == 200){
      _isLoading = false;
    }
    else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> requestCameraPermission({required bool fromEditProfile}) async {
    var serviceStatus = await Permission.camera.status;

    if(serviceStatus.isGranted && GetPlatform.isAndroid){
      Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
    }else{
      if(GetPlatform.isIOS){
        Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
      }else{
        final status = await Permission.camera.request();
        if (status == PermissionStatus.granted) {
          Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
        } else if (status == PermissionStatus.denied) {
          Get.find<CameraScreenController>().showDeniedDialog(fromEditProfile: fromEditProfile);
        } else if (status == PermissionStatus.permanentlyDenied) {
          Get.find<CameraScreenController>().showPermanentlyDeniedDialog(fromEditProfile: fromEditProfile);
        }
      }
    }
  }

    //Phone Number verification
  Future<ResponseModel> phoneVerify(String phoneNumber,String otp) async{
    debugPrint('==number==> $phoneNumber==otp==>$otp');
    _isLoading = true;
    update();
    Response response = await authRepo.verifyPhoneNumber(phoneNumber: phoneNumber, otp: otp);

    ResponseModel responseModel;
    if(response.statusCode == 200){
      debugPrint(response.body['message']);
      responseModel = ResponseModel(true, response.body["message"]);
      Get.find<VerificationController>().cancelTimer();
      showCustomSnackBar(responseModel.message, isError: false);
      requestCameraPermission(fromEditProfile: false);
    }
    else{
      debugPrint(response.body['errors'][0]['message']);
      responseModel = ResponseModel(false, response.body['errors'][0]['message']);
      showCustomSnackBar(
          responseModel.message,
          isError: true);
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  // registration ..
  Future<Response> registration(SignUpBody signUpBody,List<MultipartBody> multipartBody) async{
      _isLoading = true;
      update();
      Map<String, String> allCustomerInfo = {
        'f_name': signUpBody.fName,
        'l_name': signUpBody.lName,
        'phone': signUpBody.phone,
        'dial_country_code': signUpBody.dialCountryCode,
        'password': signUpBody.password,
        'gender': signUpBody.gender,
        'occupation': signUpBody.occupation,
      };

      allCustomerInfo.addAll({'otp': signUpBody.otp});
      if(signUpBody.email != '') {
        allCustomerInfo.addAll({'email': signUpBody.email});
      }

      Response response = await authRepo.registration(allCustomerInfo,multipartBody);
      debugPrint('error is');
      if (response.statusCode == 200) {
        Get.find<CameraScreenController>().removeImage();
        late String countryCode, nationalNumber;
        try{
          PhoneNumber phoneNumber = await PhoneNumberUtil().parse(signUpBody.phone);
           countryCode = '+${phoneNumber.countryCode}';
           nationalNumber = phoneNumber.nationalNumber;
        }catch(e){
          debugPrint(e.toString());
        }
        setCustomerCountryCode(countryCode);
        setCustomerNumber(nationalNumber);
        Get.offAllNamed(RouteHelper.getWelcomeRoute(
          countryCode: getCustomerCountryCode(),phoneNumber: getCustomerNumber(), password: signUpBody.password
        ));
        // authenticateWithBiometric(false, signUpBody.password).then((value) {
        //   Future.delayed(Duration(seconds: 1)).then((value) {
        //     _callSetting();
        //
        //   });
        // });
      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
      return response;
  }

  Future<Response> login({required String code, required String phone, required String password}) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone: code+phone, password: password);

    if (response.body['response_code'] == 'auth_login_200' && response.body['content'] != null) {
       authRepo.saveUserToken(response.body['content']).then((value) async {
         await authRepo.updateToken();
       });
      setCustomerCountryCode(code);
      setCustomerNumber(phone);
      Get.offAllNamed(RouteHelper.getNavBarRoute(), arguments: true);
      _isLoading = false;
    }
    else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future removeUser() async {

    _isLoading = true;
    update();
    Get.back();
    Response response = await authRepo.deleteUser();
    debugPrint('user del : ${response.body}');

    if (response.statusCode == 200) {
      Get.find<SplashController>().removeSharedData().then((value) {
        showCustomSnackBar('your_account_remove_successfully'.tr);
        Get.offAllNamed(RouteHelper.getSplashRoute());
      });
    }else{
      Get.back();
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<Response> checkOtp()async{
      _isLoading = true;
      update();
      Response  response = await authRepo.checkOtpApi();
      if(response.statusCode == 200){
        _isLoading = false;
      }else{
        _isLoading = false;
        ApiChecker.checkApi(response);
      }
      update();
      return response;
  }

  Future<Response> verifyOtp(String otp)async{
    _isVerifying = true;
    update();
    Response  response = await authRepo.verifyOtpApi(otp: otp);
    if(response.statusCode == 200){
      _isVerifying = false;
      Get.back();
    }else{
      Get.back();
      ApiChecker.checkApi(response);
      _isVerifying = false;
    }
    _isVerifying = false;
    update();
    return response;
  }


  Future<Response> logout() async {
    _isLoading = true;
    update();
    Response response = await authRepo.logout();
    debugPrint('logout body : ${response.statusCode} || ${response.body}');
    if (response.statusCode == 200) {

      Get.offAllNamed(RouteHelper.getSplashRoute());
      _isLoading = false;
    }
    else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> otpForForgetPass(String phoneNumber, BuildContext context) async{
    _isLoading = true;
    update();
    Response response = await authRepo.forgetPassOtp(phoneNumber: phoneNumber);

    debugPrint(response.statusCode.toString());

    if(response.statusCode == 200){
      _isLoading = false;
      Get.toNamed(RouteHelper.getFVeryficationRoute(phoneNumber: phoneNumber));
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();

    return response;
  }

  Future<Response> verificationForForgetPass(String phoneNumber, String otp) async{
    _isLoading = true;
    update();
    Response response = await authRepo.forgetPassVerification(phoneNumber: phoneNumber,otp: otp);
    if(response.statusCode == 200){
      _isLoading = false;
      Get.offNamed(RouteHelper.getFResetPassRoute(phoneNumber: phoneNumber));
    }
    else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> resetPassword(String phoneNumber, String otp, String newPass, String confirmPass) async{
    _isLoading = true;
    update();
    Response response = await authRepo.forgetPassReset(phoneNumber: phoneNumber,otp: otp,password: newPass,confirmPass: confirmPass);
    if(response.statusCode == 200){
      _isLoading = false;
      String countryCode , nationalNumber;
      try{
        PhoneNumber num = await PhoneNumberUtil().parse(phoneNumber);
        countryCode = '+${num.countryCode}';
        nationalNumber = num.nationalNumber;
       await updatePin(newPass);
        Get.offAllNamed(RouteHelper.getLoginRoute(countryCode: countryCode,phoneNumber: nationalNumber));
      }catch(e){
        showCustomSnackBar('something_error_in_your_phone_number'.tr, isError: false);
      }
    }else{
      _isLoading = false;
     ApiChecker.checkApi(response);
    }

    update();
    return response;
  }

  String getAuthToken() {
    return authRepo.getUserToken();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  void setCustomerName(String name){
      authRepo.saveCustomerName(name);
  }
  void setCustomerCountryCode(String code){
    authRepo.saveCustomerCountryCode(code);
  }
  void setCustomerNumber(String number){
    authRepo.saveCustomerNumber(number);
  }
  void setCustomerQrCode(String qrCode){
    authRepo.saveCustomerQrCode(qrCode);
  }
  String getCustomerName(){
      return authRepo.getCustomerName();
  }
  String getCustomerNumber(){
    return authRepo.getCustomerNumber();
  }
  String getCustomerCountryCode(){
    return authRepo.getCustomerCountryCode();
  }
  String getCustomerQrCode(){
    return authRepo.getCustomerQrCode();
  }
  void removeCustomerName() {
     authRepo.removeCustomerName();
  }
  void removeCustomerNumber() {
    authRepo.removeCustomerNumber();
  }
  void removeCustomerQrCode() {
    authRepo.removeCustomerQrCode();
  }

  void removeCustomerToken() {
    authRepo.removeCustomerToken();
  }

  PageController pageController = PageController();
  int _page = 0;

  int get page => _page;
  change(int a) {
    _page = a;
    update();
  }
}

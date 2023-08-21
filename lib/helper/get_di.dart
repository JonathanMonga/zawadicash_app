import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:zawadicash_app/controller/banner_controller.dart';
import 'package:zawadicash_app/controller/create_account_controller.dart';
import 'package:zawadicash_app/controller/edit_profile_controller.dart';
import 'package:zawadicash_app/controller/faq_controller.dart';
import 'package:zawadicash_app/controller/forget_password_controller.dart';
import 'package:zawadicash_app/controller/bootom_slider_controller.dart';
import 'package:zawadicash_app/controller/add_money_controller.dart';
import 'package:zawadicash_app/controller/kyc_verify_controller.dart';
import 'package:zawadicash_app/controller/menus_controller.dart';
import 'package:zawadicash_app/controller/notification_controller.dart';
import 'package:zawadicash_app/controller/qr_code_scanner_controller.dart';
import 'package:zawadicash_app/controller/screen_shot_widget_controller.dart';
import 'package:zawadicash_app/controller/requested_money_controller.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/controller/home_controller.dart';
import 'package:zawadicash_app/controller/language_controller.dart';
import 'package:zawadicash_app/controller/localization_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/theme_controller.dart';
import 'package:zawadicash_app/controller/transaction_history_controller.dart';
import 'package:zawadicash_app/controller/verification_controller.dart';
import 'package:zawadicash_app/controller/websitelink_controller.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/data/repository/add_money_repo.dart';
import 'package:zawadicash_app/data/repository/auth_repo.dart';
import 'package:zawadicash_app/data/repository/banner_repo.dart';
import 'package:zawadicash_app/data/repository/faq_repo.dart';
import 'package:zawadicash_app/data/repository/language_repo.dart';
import 'package:zawadicash_app/data/repository/notification_repo.dart';
import 'package:zawadicash_app/data/repository/profile_repo.dart';
import 'package:zawadicash_app/data/repository/requested_money_repo.dart';
import 'package:zawadicash_app/data/repository/transaction_repo.dart';
import 'package:zawadicash_app/data/repository/transaction_history_repo.dart';
import 'package:zawadicash_app/data/repository/websitelink_repo.dart';
import 'package:zawadicash_app/data/repository/splash_repo.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/data/model/response/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:unique_identifier/unique_identifier.dart';

import 'package:zawadicash_app/data/repository/kyc_verify_repo.dart';
import 'package:zawadicash_app/util/get_class_name.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;

  Get.lazyPut<SharedPreferences>(() => sharedPreferences, tag: getClassName<SharedPreferences>());
  Get.lazyPut<BaseDeviceInfo>(() => deviceInfo, tag: getClassName<BaseDeviceInfo>());

  late String uniqueId;
  try {
    uniqueId = (await UniqueIdentifier.serial)!;
  } catch (error) {
    debugPrint('error is : $error');
  }

  Get.lazyPut<String>(() => uniqueId, tag: getClassName<String>());

  Get.lazyPut<ApiClient>(
      () => ApiClient(
            appBaseUrl: AppConstants.BASE_URL,
            sharedPreferences: Get.find<SharedPreferences>(tag: getClassName<SharedPreferences>()),
            uniqueId: Get.find<String>(tag: getClassName<String>()),
            deiceInfo: Get.find<BaseDeviceInfo>(tag: getClassName<BaseDeviceInfo>()),
          ),
      tag: getClassName<ApiClient>());

  // Repository
  Get.lazyPut(
      () => SplashRepo(
          sharedPreferences: Get.find(tag: getClassName<SharedPreferences>()),
          apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<SplashRepo>());
  Get.lazyPut(() => LanguageRepo(), tag: getClassName<LanguageRepo>());
  Get.lazyPut(
      () => TransactionRepo(
          apiClient: Get.find(tag: getClassName<ApiClient>()),
          sharedPreferences: Get.find(tag: getClassName<SharedPreferences>())),
      tag: getClassName<TransactionRepo>());
  Get.lazyPut(
      () => AuthRepo(
          apiClient: Get.find(tag: getClassName<ApiClient>()),
          sharedPreferences: Get.find(tag: getClassName<SharedPreferences>())),
      tag: getClassName<AuthRepo>());
  Get.lazyPut(
      () => ProfileRepo(apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<ProfileRepo>());
  Get.lazyPut(
      () =>
          WebsiteLinkRepo(apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<WebsiteLinkRepo>());
  Get.lazyPut(
      () => BannerRepo(apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<BannerRepo>());
  Get.lazyPut(
      () => AddMoneyRepo(apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<AddMoneyRepo>());
  Get.lazyPut(
      () => FaqRepo(apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<FaqRepo>());
  Get.lazyPut(
      () =>
          NotificationRepo(apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<NotificationRepo>());
  Get.lazyPut(
      () => RequestedMoneyRepo(
          apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<RequestedMoneyRepo>());
  Get.lazyPut(
      () => TransactionHistoryRepo(
          apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<TransactionHistoryRepo>());
  Get.lazyPut(
      () => KycVerifyRepo(apiClient: Get.find(tag: getClassName<ApiClient>())),
      tag: getClassName<KycVerifyRepo>());

  // Controller
  Get.lazyPut(
      () => SplashController(
          splashRepo: Get.find(tag: getClassName<SplashRepo>())),
      tag: getClassName<SplashController>());
  Get.lazyPut(
      () => ThemeController(
          sharedPreferences: Get.find(tag: getClassName<SharedPreferences>())),
      tag: getClassName<ThemeController>());
  Get.lazyPut(
      () => LocalizationController(
          sharedPreferences: Get.find(tag: getClassName<SharedPreferences>())),
      tag: getClassName<LocalizationController>());
  Get.lazyPut(
      () => LanguageController(
          sharedPreferences: Get.find(tag: getClassName<SharedPreferences>())),
      tag: getClassName<LanguageController>());
  Get.lazyPut(
      () => TransactionMoneyController(
          transactionRepo: Get.find(tag: getClassName<TransactionRepo>()),
          authRepo: Get.find(tag: getClassName<AuthRepo>())),
      tag: getClassName<TransactionMoneyController>());
  Get.lazyPut(
      () => AddMoneyController(
          addMoneyRepo: Get.find(tag: getClassName<AddMoneyRepo>())),
      tag: getClassName<AddMoneyController>());
  Get.lazyPut(
      () => NotificationController(
          notificationRepo: Get.find(tag: getClassName<NotificationRepo>())),
      tag: getClassName<NotificationController>());
  Get.lazyPut(
      () => ProfileController(
          profileRepo: Get.find(tag: getClassName<ProfileRepo>())),
      tag: getClassName<ProfileController>());
  Get.lazyPut(
      () => FaqController(faqrepo: Get.find(tag: getClassName<FaqRepo>())),
      tag: getClassName<FaqController>());

  Get.lazyPut(() => BottomSliderController(),
      tag: getClassName<BottomSliderController>());
  Get.lazyPut(() => MenusController(), tag: getClassName<MenusController>());
  Get.lazyPut(
      () => AuthController(authRepo: Get.find(tag: getClassName<AuthRepo>())),
      tag: getClassName<AuthController>());
  Get.lazyPut(() => HomeController(), tag: getClassName<HomeController>());
  Get.lazyPut(() => CreateAccountController(),
      tag: getClassName<CreateAccountController>());
  Get.lazyPut(
      () => VerificationController(
          authRepo: Get.find(tag: getClassName<AuthRepo>())),
      tag: getClassName<VerificationController>());
  Get.lazyPut(() => CameraScreenController(),
      tag: getClassName<CameraScreenController>());
  Get.lazyPut(() => ForgetPassController(),
      tag: getClassName<ForgetPassController>());
  Get.lazyPut(
      () => WebsiteLinkController(
          websiteLinkRepo: Get.find(tag: getClassName<WebsiteLinkRepo>())),
      tag: getClassName<WebsiteLinkController>());
  Get.lazyPut(() => QrCodeScannerController(),
      tag: getClassName<QrCodeScannerController>());
  Get.lazyPut(
      () => BannerController(
          bannerRepo: Get.find(tag: getClassName<BannerRepo>())),
      tag: getClassName<BannerController>());
  Get.lazyPut(
      () => TransactionHistoryController(
          transactionHistoryRepo:
              Get.find(tag: getClassName<TransactionHistoryRepo>())),
      tag: getClassName<TransactionHistoryController>());
  Get.lazyPut(
      () => EditProfileController(
          authRepo: Get.find(tag: getClassName<AuthRepo>())),
      tag: getClassName<EditProfileController>());
  Get.lazyPut(
      () => RequestedMoneyController(
          requestedMoneyRepo:
              Get.find(tag: getClassName<RequestedMoneyRepo>())),
      tag: getClassName<RequestedMoneyController>());
  Get.lazyPut(() => ScreenShootWidgetController());
  Get.lazyPut(
      () => KycVerifyController(
          kycVerifyRepo: Get.find(tag: getClassName<KycVerifyRepo>())),
      tag: getClassName<KycVerifyController>());

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};

    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });

    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }

  return languages;
}

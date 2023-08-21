import 'dart:convert';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/data/model/response/contact_model.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/screens/add_money/web_screen.dart';
import 'package:zawadicash_app/view/screens/auth/create_account/create_account_screen.dart';
import 'package:zawadicash_app/view/screens/auth/login/login_screen.dart';
import 'package:zawadicash_app/view/screens/auth/other_info/other_info_screen.dart';
import 'package:zawadicash_app/view/screens/auth/pin_set/pin_set_screen.dart';
import 'package:zawadicash_app/view/screens/auth/selfie_capture/camera_screen.dart';
import 'package:zawadicash_app/view/screens/auth/varification/varification_screen.dart';
import 'package:zawadicash_app/view/screens/dashboard/nav_bar_screen.dart';
import 'package:zawadicash_app/view/screens/forget_password/widget/forget_password.dart';
import 'package:zawadicash_app/view/screens/forget_password/widget/phone_verification.dart';
import 'package:zawadicash_app/view/screens/history/history_screen.dart';
import 'package:zawadicash_app/view/screens/home/home_screen.dart';
import 'package:zawadicash_app/view/screens/more/change_language_screen.dart';
import 'package:zawadicash_app/view/screens/onboarding/chose_login_registration/choice_screen.dart';
import 'package:zawadicash_app/view/screens/notification/notification_screen.dart';
import 'package:zawadicash_app/view/screens/profile/widget/change_pin_screen.dart';
import 'package:zawadicash_app/view/screens/profile/widget/edit_profile_screen.dart';
import 'package:zawadicash_app/view/screens/profile/profile_screen.dart';
import 'package:zawadicash_app/view/screens/profile/widget/faq_screen.dart';
import 'package:zawadicash_app/view/screens/profile/widget/html_view_screen.dart';
import 'package:zawadicash_app/view/screens/profile/widget/qr_code_download_or_share.dart';
import 'package:zawadicash_app/view/screens/profile/widget/support_screen.dart';
import 'package:zawadicash_app/view/screens/forget_password/widget/reset_password_screen.dart';
import 'package:zawadicash_app/view/screens/splash/splash_screen.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_screen.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_balance_input.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_confirmation.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/share_statement_widget.dart';
import 'package:zawadicash_app/view/screens/welcome_screen/welcome_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String navbar = '/navbar';
  static const String history = '/history';
  static const String notification = '/notification';
  static const String themeAndLanguage = '/themeAndLanguage';
  static const String profile = '/profile';
  static const String changePinScreen = '/change_pin_screen';
  static const String verifyOtpScreen = '/verify_otp_screen';
  static const String noInternetScreen = '/no_internet_screen';
  static const String sendMoney = '/send_money';
  static const String choseLoginOrRegScreen = '/chose_login_or_reg';
  static const String createAccountScreen = '/create_account';
  static const String verifyScreen = '/verify_account';
  static const String selfieScreen = '/selfie_screen';
  static const String otherInfoScreen = '/other_info_screen';
  static const String pinSetScreen = '/pin_set_screen';
  static const String welcomeScreen = '/welcome_screen';
  static const String loginScreen = '/login_screen';
  static const String fPhoneNumberScreen = '/f_phone_number';
  static const String fVerificationScreen = '/f_verification_screen';
  static const String fResetPassScreen = '/f_reset_pass_screen';

  static const String qrCodeScannerScreen = '/qr_code_scanner_screen';
  static const String showWebViewScreen = '/show_web_view_screen';

  static const String sendMoneyBalanceInput =
      '/send_money_balance_inputsend_money_balance_input';
  static const String sendMoneyConfirmation =
      '/transaction_money_confirmation.dart';

  static const String requestMoney = '/request_money';
  static const String requestMoneyBalanceInput = '/requestMoney_balance_input';
  static const String requestMoneyConfirmation = '/requestMoney_confirmation';

  static const String cashOut = '/cash_out';
  static const String cashOutBalanceInput = '/cash_out_balance_input';
  static const String cashOutConfirmation = '/cash_out_confirmation';

  static const String addMoney = '/add_money';
  static const String addMoneyInput = '/add_money_input';
  static const String bankSelect = '/bank_select';
  static const String bankList = '/bank_listbank_list';
  static const String addMoneySuccessful = '/add_money_successful';
  static const String addMoneyWeb = '/add_money_web';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String faq = '/faq';
  static const String aboutUs = '/about_us';
  static const String terms = '/terms';
  static const String privacy = '/privacy_policy';
  static const String requestedMoney = '/requested_money';
  static const String shareStatement = '/share_statement';
  static const String support = '/support';
  static const String choseLanguageScreen = '/chose_language_screen';
  static const String qrCodeDownloadOrShare = '/qr_code_download_or_share';

  static getSplashRoute() => splash;
  static String getHomeRoute(String name) => '$home?name=$name';

  static getLoginRoute(
      {required String countryCode, required String phoneNumber}) {
    return '$loginScreen?country-code=$countryCode&phone-number=$phoneNumber';
  }

  static getRegistrationRoute() => createAccountScreen;
  static getVerifyRoute() => verifyScreen;

  static getWelcomeRoute(
      {String? countryCode, String? phoneNumber, String? password}) {
    return '$welcomeScreen?country-code=$countryCode&phone-number=$phoneNumber&password=$password';
  }

  static getSelfieRoute({required bool fromEditProfile}) =>
      '$selfieScreen?page=${fromEditProfile ? 'edit-profile' : 'verify'}';
  static getNavBarRoute() => navbar;
  static getOtherInformationRoute() => otherInfoScreen;
  static getPinSetRoute(
          {required String occupation,
          required String fName,
          required String lName,
          String? email}) =>
      '$pinSetScreen?occupation=$occupation&f-name=$fName&l-name=$lName&email=$email';
  static getRequestMoneyRoute({String? phoneNumber, required bool fromEdit}) =>
      '$requestMoney?phone-number=$phoneNumber&from-edit=${fromEdit ? 'edit-number' : 'home'}';
  static getForgetPassRoute(
          {required String countryCode, required String phoneNumber}) =>
      '$fPhoneNumberScreen?country-code=$countryCode&phone-number=$phoneNumber';
  static getRequestMoneyBalanceInputRoute() => requestMoneyBalanceInput;
  static getRequestMoneyConfirmationRoute({required String inputBalanceText}) =>
      '$requestMoneyConfirmation?input-balance=$inputBalanceText';
  static getNoInternetRoute() => noInternetScreen;
  static getChoseLoginRegRoute() => choseLoginOrRegScreen;
  static getSendMoneyRoute({String? phoneNumber, required bool fromEdit}) =>
      '$sendMoney?phone-number=$phoneNumber&from-edit=${fromEdit ? 'edit-number' : 'home'}';
  static getSendMoneyInputRoute({required String transactionType}) =>
      '$sendMoneyBalanceInput?transaction-type=$transactionType';
  static getSendMoneyConfirmationRoute(
          {required String inputBalanceText,
          required String transactionType}) =>
      '$sendMoneyConfirmation?input-balance=$inputBalanceText&transaction-type=$transactionType';
  static getChoseLanguageRoute() => choseLanguageScreen;
  static getCashOutScreenRoute({String? phoneNumber, required bool fromEdit}) =>
      '$cashOut?phone-number=$phoneNumber&from-edit=${fromEdit ? 'edit-number' : 'home'}';
  static getCashOutBalanceInputRoute() => cashOutBalanceInput;
  static getFResetPassRoute({required String phoneNumber}) =>
      '$fResetPassScreen?phone-number=$phoneNumber';
  static getEditProfileRoute() => editProfileScreen;
  static getChangePinRoute() => changePinScreen;
  static getAddMoneyInputRoute() => addMoneyInput;
  static getFVeryficationRoute({required String phoneNumber}) =>
      '$fVerificationScreen?phone-number=$phoneNumber';

  static getSupportRoute() => support;
  static getCashOutConfirmationRoute({required String inputBalanceText}) =>
      '$cashOutConfirmation?input-balance=$inputBalanceText';
  static getShareStatementRoute(
      {required String amount,
      required String transactionType,
      required ContactModel contactModel}) {
    String data =
        base64Url.encode(utf8.encode(jsonEncode(contactModel.toJson())));
    String transactionType0 = base64Url.encode(utf8.encode(transactionType));
    return '$shareStatement?amount=$amount&transaction-type=$transactionType0&contact=$data';
  }

  static getQrCodeDownloadOrShareRoute(
      {required String qrCode, required String phoneNumber}) {
    String qrCode0 = base64Url.encode(utf8.encode(qrCode));
    String phoneNumber0 = base64Url.encode(utf8.encode(phoneNumber));

    return '$qrCodeDownloadOrShare?qr-code=$qrCode0&phone-number=$phoneNumber0';
  }

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: navbar, page: () => const NavBarScreen()),
    GetPage(
        name: shareStatement,
        page: () => ShareStatementWidget(
            amount: Get.parameters['amount']!,
            charge: null,
            trxId: null,
            transactionType: utf8.decode(base64Url.decode(
                Get.parameters['transaction-type']!.replaceAll(' ', '+'))),
            contactModel: ContactModel.fromJson(jsonDecode(
                utf8.decode(base64Url.decode(Get.parameters['contact']!)))))),

    GetPage(name: history, page: () => const HistoryScreen()),
    GetPage(name: notification, page: () => const NotificationScreen()),
    // GetPage(name: themeAndLanguage, page: () => ThemeAndLanguage()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: changePinScreen, page: () => const ChangePinScreen()),
    GetPage(
        name: sendMoney,
        page: () => TransactionMoneyScreen(
            phoneNumber: Get.parameters['phone-number'],
            fromEdit: Get.parameters['from-edit'] == 'edit-number')),
    GetPage(
        name: sendMoneyBalanceInput,
        page: () => TransactionMoneyBalanceInput(
            transactionType: Get.parameters['transaction-type'])),
    GetPage(
        name: sendMoneyConfirmation,
        page: () => TransactionMoneyConfirmation(
            inputBalance: double.tryParse(Get.parameters['input-balance']!),
            transactionType: Get.parameters['transaction-type'])),
    GetPage(name: addMoneyWeb, page: () => const WebScreen()),

    GetPage(name: choseLoginOrRegScreen, page: () => const ChoiceScreen()),
    GetPage(name: createAccountScreen, page: () => const CreateAccountScreen()),
    GetPage(name: verifyScreen, page: () => const VerificationScreen()),
    GetPage(
        name: selfieScreen,
        page: () => CameraScreen(
            fromEditProfile: Get.parameters['page'] == 'edit-profile')),
    GetPage(name: otherInfoScreen, page: () => const OtherInfoScreen()),
    GetPage(
        name: pinSetScreen,
        page: () => PinSetScreen(
              occupation: Get.parameters['occupation'],
              fName: Get.parameters['f-name'],
              lName: Get.parameters['l-name'],
              email: Get.parameters['email'],
            )),
    GetPage(
        name: welcomeScreen,
        page: () => WelcomeScreen(
              countryCode: Get.parameters['country-code']!.replaceAll(' ', '+'),
              phoneNumber: Get.parameters['phone-number']!,
              password: Get.parameters['password']!,
            )),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(
          countryCode: Get.parameters['country-code']!.replaceAll(' ', '+'),
          phoneNumber: Get.parameters['phone-number']!),
    ),
    GetPage(
        name: fPhoneNumberScreen,
        page: () => ForgetPassword(
              countryCode: Get.parameters['country-code']!.replaceAll(' ', '+'),
              phoneNumber: Get.parameters['phone-number']!,
            )),
    GetPage(
        name: fVerificationScreen,
        page: () => PhoneVerification(
              phoneNumber: Get.parameters['phone-number']!.replaceAll(' ', '+'),
            )),
    GetPage(
        name: fResetPassScreen,
        page: () => ResetPasswordScreen(
              phoneNumber: Get.parameters['phone-number']!.replaceAll(' ', '+'),
            )),
    GetPage(
        name: choseLanguageScreen, page: () => const ChooseLanguageScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    // GetPage(name: requested_money, page: () => RequestedMoneyListScreen(isOwn: Get.parameters['from'] == 'won' ? true : false)),
    // GetPage(name: faq, page: () => FaqScreen(title: 'FAQ')),
    // GetPage(name: terms, page: () => HtmlViewScreen(title: 'Terms & Condition', url: Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.termsAndConditions)),
    // GetPage(name: privacy, page: () => HtmlViewScreen(title: 'Privacy Policy', url: Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.privacyPolicy)),
    GetPage(name: faq, page: () => FaqScreen(title: 'faq'.tr)),
    GetPage(
        name: terms,
        page: () => HtmlViewScreen(
            title: 'terms'.tr,
            url: Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.termsAndConditions!)),
    GetPage(
        name: aboutUs,
        page: () => HtmlViewScreen(
            title: 'about_us'.tr,
            url: Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.aboutUs!)),
    GetPage(
        name: privacy,
        page: () => HtmlViewScreen(
            title: 'privacy_policy'.tr,
            url: Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.privacyPolicy!)),
    GetPage(name: support, page: () => const SupportScreen()),
    GetPage(
        name: qrCodeDownloadOrShare,
        page: () => QrCodeDownloadOrShareScreen(
              qrCode: utf8.decode(base64Url
                  .decode(Get.parameters['qr-code']!.replaceAll(' ', '+'))),
              phoneNumber: utf8.decode(base64Url.decode(
                  Get.parameters['phone-number']!.replaceAll(' ', '+'))),
            )),
  ];
}

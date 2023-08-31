import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/menu_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/data/model/response/user_data.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/appbar_stack_view.dart';
import 'package:zawadicash_app/view/base/custom_country_code_picker.dart';
import 'package:zawadicash_app/view/base/custom_password_field.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/screens/auth/login/widget/login_qr_popup_card.dart';
import 'package:zawadicash_app/view/screens/home/widget/animated_card/custom_rect_tween.dart';
import 'package:zawadicash_app/view/screens/home/widget/animated_card/hero_dialogue_route.dart';


class LoginScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;

  const LoginScreen({Key? key, this.phoneNumber, this.countryCode}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  TextEditingController phoneController = TextEditingController();
  TextEditingController  passwordController = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  final String _heroQrTag = 'hero-qr-tag';
  String? _countryCode;
  UserData? userData;


  void setCountryCode(String code){
    _countryCode = code;
  }
  void setInitialCountryCode(String? code){
    _countryCode = code;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(GetPlatform.isAndroid && state == AppLifecycleState.resumed){
      Get.find<AuthController>().authenticateWithBiometric(true,  null);
    }
  }
  @override
  void initState() {
    super.initState();

    userData = Get.find<AuthController>().getUserData();
    if(widget.phoneNumber != userData?.phone) {
      Get.find<AuthController>().removeUserData();
      userData = null;
    }

    Get.find<AuthController>().authenticateWithBiometric(true, null);
    WidgetsBinding.instance.addObserver(this);
    setInitialCountryCode(widget.countryCode);
    phoneController.text = widget.phoneNumber!;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController) => AbsorbPointer(
        absorbing: authController.isLoading,
        child: Stack(children: [
          Column(children: [
            Expanded(flex: 5, child: Container(color: Theme.of(context).primaryColor)),

            Expanded(flex: 5, child: Container(color: Theme.of(context).cardColor))
          ]),

          const Positioned(
            top: Dimensions.paddingSizeOverLarge,
            left: 0, right: 0,
            child: AppbarStackView(),
          ),
            Positioned(
              top: 135,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraExtraLarge, right: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeExtraExtraLarge,),
                width: double.infinity,
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSizeExtraExtraLarge), topRight: Radius.circular(Dimensions.radiusSizeExtraExtraLarge),),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GetBuilder<AuthController>(builder: (controller){
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('welcome_back'.tr, textAlign: TextAlign.center,
                                  style: rubikLight.copyWith(color: Theme.of(context).textTheme.titleLarge!.color,
                                    fontSize: Dimensions.fontSizeLarge,),),

                                userData?.name != null ?
                                SizedBox(width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    userData!.name!,
                                    textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: rubikMedium.copyWith(color: Theme.of(context).textTheme.titleLarge!.color, fontSize: Dimensions.fontSizeExtraOverLarge,),

                                  ),
                                ) : Text('user'.tr,
                                  overflow: TextOverflow.clip, textAlign: TextAlign.center,
                                  style: rubikMedium.copyWith(color: Theme.of(context).textTheme.titleLarge!.color, fontSize: Dimensions.fontSizeExtraOverLarge,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            SizedBox(height: 50, width: 50, child: Stack(children: [
                              GetBuilder<AuthController>(builder: (controller){
                                return userData?.qrCode != null ? InkWell(
                                    onTap: ()=> Navigator.of(context).push(HeroDialogRoute(builder: (_)=> const LoginQrPopupCard())),
                                    child: Hero(
                                      tag: _heroQrTag,
                                      createRectTween: (begin, end)=> CustomRectTween(begin: begin,end: end),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        color: Colors.white,
                                        child: SvgPicture.string(userData!.qrCode!),
                                      ),
                                    )
                                ) : Container();

                              }),

                            ])),

                          ],
                        );
                      }),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Row(
                        children: [
                          Text('account'.tr, style: rubikLight.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.9), fontSize: Dimensions.fontSizeLarge)),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              focusNode: phoneFocus,
                              onSubmitted: (value) {
                                FocusScope.of(context).requestFocus(passFocus);
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(top: 14),
                                  prefixIcon: CustomCountryCodePiker(
                                    initSelect: widget.countryCode,
                                    onChanged: (countryCode)=> setCountryCode(countryCode.dialCode!),
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.4),
                        height: 0.5,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeExtraExtraLarge,
                            right: Dimensions.paddingSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('4_digit_pin'.tr, style: rubikMedium.copyWith(color: Theme.of(context).textTheme.titleLarge!.color, fontSize: Dimensions.fontSizeLarge,),),
                            const SizedBox(height: Dimensions.paddingSizeLarge,),
                            CustomPasswordField(
                              hint: '＊＊＊＊',
                              controller: passwordController,
                              focusNode: passFocus,
                              isShowSuffixIcon: true,
                              isPassword: true,
                              isIcon: false,
                              textAlign: TextAlign.center,

                            ),
                            InkWell(
                              onTap: ()=> Get.toNamed(RouteHelper.getForgetPassRoute(
                                countryCode: _countryCode,
                                phoneNumber: phoneController.text.trim(),
                              )),
                              child: Text('${'forget_pin'.tr}?', style: rubikRegular.copyWith(color: Theme.of(context).colorScheme.error.withOpacity(0.7), fontSize: Dimensions.fontSizeLarge,),),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 10),
          child: GetBuilder<AuthController>(builder: (controller) {
              return FloatingActionButton(
                onPressed: () {
                  _login(context);
                },
                elevation: 0, backgroundColor: Theme.of(context).secondaryHeaderColor,
                child: controller.isLoading
                    ? CircularProgressIndicator(color: Theme.of(context).textTheme.bodyLarge!.color,)
                    : SizedBox(child: Icon(Icons.arrow_forward,color: ColorResources.blackColor,size: 28,),),
              );
            },
          )),
    );
  }

  Future<void> _login( BuildContext context) async {
    Get.find<MenuItemController>().resetNavBar();
    String? code = _countryCode;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    if (phone.isEmpty) {
      showCustomSnackBar('please_give_your_phone_number'.tr,  isError: true);
    } else if (password.isEmpty) {
      showCustomSnackBar('please_enter_your_valid_pin'.tr,  isError: true);
    } else if (password.length != 4) {
      showCustomSnackBar('pin_should_be_4_digit'.tr, isError: true);
    } else {

      try{
        await  Get.find<AuthController>().setUserData(UserData(phone: phone, countryCode: _countryCode));

        Get.find<AuthController>().login(code: code!, phone: phone,password: password).then((value) async{
          if(value.isOk){
            await Get.find<ProfileController>().profileData(reload: true);
          }
        });
      }catch(e){
        showCustomSnackBar('please_input_your_valid_number'.tr,isError: true);
      }
    }
  }
}

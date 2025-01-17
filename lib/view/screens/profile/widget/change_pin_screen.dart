import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_loader.dart';
import 'package:zawadicash_app/view/base/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({Key? key}) : super(key: key);

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _oldPinFocus = FocusNode();
  final FocusNode _newPinFocus = FocusNode();
  final FocusNode _confirmPinFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: Get.find<ProfileController>(tag: getClassName<ProfileController>()),
      tag: getClassName<ProfileController>(),
      builder: (controller) {
        return ModalProgressHUD(
          inAsyncCall: controller.isLoading,
          progressIndicator: CustomLoader(
            color: Theme.of(context).textTheme.titleLarge!.color!,
          ),
          child: Scaffold(
              backgroundColor: ColorResources.getBackgroundColor(),
              appBar: CustomAppbar(title: 'pin_change'.tr),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE),
                        child: Text(
                          'set_your_4_digit'.tr,
                          textAlign: TextAlign.center,
                          style: rubikMedium.copyWith(
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                              fontSize: Dimensions.FONT_SIZE_EXTRA_OVER_LARGE),
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE,
                      ),
                      CustomPasswordField(
                        controller: _oldPasswordController,
                        focusNode: _oldPinFocus,
                        isPassword: true,
                        isShowSuffixIcon: true,
                        isIcon: false,
                        hint: 'old_password'.tr,
                        letterSpacing: 10.0,
                        nextFocus: _newPinFocus,
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                      ),
                      CustomPasswordField(
                        controller: _newPasswordController,
                        focusNode: _newPinFocus,
                        nextFocus: _confirmPinFocus,
                        hint: 'new_password'.tr,
                        isShowSuffixIcon: true,
                        isPassword: true,
                        isIcon: false,
                        textAlign: TextAlign.start,
                        letterSpacing: 10.0,
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                      ),
                      CustomPasswordField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPinFocus,
                        textInputAction: TextInputAction.done,
                        hint: 'confirm_password'.tr,
                        isShowSuffixIcon: true,
                        isPassword: true,
                        isIcon: false,
                        letterSpacing: 10.0,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE),
                    ],
                  ),
                ),
              ),
              floatingActionButton:
                  GetBuilder<ProfileController>(
                      init: Get.find<ProfileController>(tag: getClassName<ProfileController>()),
                      tag: getClassName<ProfileController>(),
                      builder: (controller) {
                return FloatingActionButton(
                  elevation: 0,
                  onPressed: () => controller.changePin(
                      oldPassword: _oldPasswordController.text,
                      confirmPassword: _confirmPasswordController.text,
                      newPassword: _newPasswordController.text),
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  child: Icon(
                    Icons.arrow_forward,
                    color: ColorResources.blackColor,
                  ),
                );
              })),
        );
      },
    );
  }
}

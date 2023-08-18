// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';

import 'package:zawadicash_app/view/screens/profile/widget/confirm_pin_bottom_sheet.dart';

class StatusMenu extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final bool? isAuth;

  const StatusMenu({
    Key? key,
    this.title,
    this.leading,
    this.isAuth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final authController = Get.find<AuthController>();

    debugPrint('biomatic in view : ${authController.biometric}');
    return CustomInkWell(
      onTap: () => Get.defaultDialog(
        barrierDismissible: false,
        title: '4digit_pin'.tr,
        content: ConfirmPinBottomSheet(
          callBack: isAuth!
              ? authController.setBiometric
              : profileController.twoFactorOnTap,
          isAuth: isAuth!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_SMALL,
            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: Row(
          children: [
            leading!,
            const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
            Text(title!,
                style: rubikRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE)),
            const Spacer(),
            GetBuilder<AuthController>(builder: (authController) {
              return GetBuilder<ProfileController>(builder: (profController) {
                bool? isOn = isAuth!
                    ? (authController.biometric &&
                            authController.bioList.isNotEmpty)
                    : profController.userInfo.twoFactor;
                return profController.isLoading
                    ? Center(child: Text('off'.tr))
                    : Text(isOn! ? 'on'.tr : 'off'.tr);
              });
            })
          ],
        ),
      ),
    );
  }
}

class TwoFactorShimmer extends StatelessWidget {
  const TwoFactorShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Shimmer.fromColors(
        baseColor: ColorResources.shimmerBaseColor!,
        highlightColor: ColorResources.shimmerLightColor!,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.PADDING_SIZE_SMALL,
              horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          child: Row(
            children: [
              Image.asset(Images.two_factor_authentication, width: 28.0),
              const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
              Text('two_factor_authentication'.tr,
                  style: rubikRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE)),
              const Spacer(),
              GetBuilder<ProfileController>(
                  builder: (profController) => profController.isLoading
                      ? Center(child: Text('off'.tr))
                      : Text(profController.userInfo.twoFactor!
                          ? 'on'.tr
                          : 'off'.tr)),
              //Image.asset(Images.arrow_right_logo,width: 32.0,)
            ],
          ),
        ),
      ),
    );
  }
}

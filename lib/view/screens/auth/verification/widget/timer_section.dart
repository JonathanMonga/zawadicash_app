// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/create_account_controller.dart';
import 'package:zawadicash_app/controller/verification_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';

class TimerSection extends StatelessWidget {
  const TimerSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
        init: Get.find<VerificationController>(
            tag: getClassName<VerificationController>()),
        tag: getClassName<VerificationController>(),
        builder: (controller) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: controller.visibility == true ? true : false,
                child: InkWell(
                  onTap: () {
                    controller.startTimer();
                    controller.setVisibility(false);
                    Get.find<AuthController>(
                            tag: getClassName<AuthController>())
                        .resendOtp(
                            phoneNumber:
                        Get.find<CreateAccountController>(tag: getClassName<CreateAccountController>()).phoneNumber);
              },
              child: Text(
                'resend'.tr,
                style: rubikMedium.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Visibility(
            visible: controller.visibility == true ? false : true,
            child: Text(
              'resend_otp_in'.tr +
                  '${controller.maxSecond}' +
                  " " +
                  'seconds'.tr,
              style: rubikRegular.copyWith(
                  color: ColorResources.getOnboardGreyColor(),
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    });
  }
}

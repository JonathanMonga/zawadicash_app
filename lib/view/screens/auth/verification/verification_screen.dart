import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/create_account_controller.dart';
import 'package:zawadicash_app/controller/verification_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_pin_code_field.dart';
import 'package:zawadicash_app/view/screens/auth/verification/widget/information_section.dart';
import 'package:zawadicash_app/view/screens/auth/verification/widget/timer_section.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getWhiteAndBlack(),
      appBar: CustomAppbar(
          title: 'phone_verification'.tr,
          onTap: () {
            Get.find<VerificationController>(tag: getClassName<VerificationController>()).cancelTimer();
            Get.back();
          }),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  const InformationSection(),
                  const SizedBox(height: Dimensions.PADDING_SIZE_OVER_LARGE),
                  GetBuilder<VerificationController>(
                      init: Get.find<VerificationController>(
                          tag: getClassName<VerificationController>()),
                      tag: getClassName<VerificationController>(),
                      builder: (getController) {
                        return CustomPinCodeField(
                          padding: Dimensions.PADDING_SIZE_OVER_LARGE,
                          onCompleted: (pin) {
                            getController.setOtp(pin);
                            String phoneNumber = Get.find<
                                        CreateAccountController>(
                                    tag:
                                        getClassName<CreateAccountController>())
                                .phoneNumber;
                            Get.find<AuthController>(
                                    tag: getClassName<AuthController>())
                                .phoneVerify(phoneNumber, pin);
                          },
                        );
                      }),
                  // const DemoOtpHint(),
                  // const SizedBox(
                  //   height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                  // ),
                  const TimerSection(),
                ],
              ),
            ),
          ),
          GetBuilder<AuthController>(
              init:
                  Get.find<AuthController>(tag: getClassName<AuthController>()),
              tag: getClassName<AuthController>(),
              builder: (controller) => SizedBox(
                    height: 100,
                    child: controller.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor),
                          )
                        : Container(),
                  ))
        ],
      ),
    );
  }
}

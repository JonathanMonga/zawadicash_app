// ignore_for_file: library_private_types_in_public_api

import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/forget_password_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_pin_code_field.dart';
import 'package:zawadicash_app/view/base/demo_otp_hint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'information_view.dart';

class PhoneVerification extends StatefulWidget {
  final String? phoneNumber;
  const PhoneVerification({Key? key, this.phoneNumber}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getWhiteAndBlack(),
      appBar: CustomAppbar(title: 'phone_verification'.tr),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  InformationView(phoneNumber: widget.phoneNumber),
                  const SizedBox(height: Dimensions.PADDING_SIZE_OVER_LARGE),
                  CustomPinCodeField(
                    padding: Dimensions.PADDING_SIZE_OVER_LARGE,
                    onCompleted: (pin) {
                      Get.find<ForgetPassController>(tag: getClassName<ForgetPassController>()).setOtp(pin);
                      String phoneNumber = widget.phoneNumber!;
                      Get.find<AuthController>(tag: getClassName<AuthController>())
                          .verificationForForgetPass(phoneNumber, pin);
                    },
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  const DemoOtpHint(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: GetBuilder<AuthController>(
              builder: (controller) {
                return controller.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor))
                    : const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}

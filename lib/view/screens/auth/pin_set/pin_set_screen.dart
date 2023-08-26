import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/controller/create_account_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/verification_controller.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/data/model/body/signup_body.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/custom_country_code_picker.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/screens/auth/pin_set/widget/appbar_view.dart';
import 'package:zawadicash_app/view/screens/auth/pin_set/widget/pin_view.dart';

class PinSetScreen extends StatelessWidget {
  final String? occupation, fName, lName, email;
  PinSetScreen({Key? key, this.occupation, this.fName, this.lName, this.email})
      : super(key: key);

  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Theme.of(context).cardColor,
                    ),
                  )
                ],
              ),
              const Positioned(
                top: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
                left: 0,
                right: 0,
                child: AppbarView(
                  isLogin: false,
                ),
              ),
              Positioned(
                top: 135,
                left: 0,
                right: 0,
                bottom: 0,
                child: PinView(
                  passController: passController,
                  confirmPassController: confirmPassController,
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: FloatingActionButton(
              onPressed: () {
                if (passController.text.isEmpty ||
                    confirmPassController.text.isEmpty) {
                  showCustomSnackBar('enter_your_pin'.tr, isError: true);
                } else {
                  if (passController.text.length < 4) {
                    showCustomSnackBar('pin_should_be_4_digit'.tr,
                        isError: true);
                  } else {
                    if (passController.text == confirmPassController.text) {
                      String password = passController.text;
                      String gender = Get.find<ProfileController>(
                              tag: getClassName<ProfileController>())
                          .gender;
                      String countryCode = getCountryCode(
                          Get.find<CreateAccountController>(
                                  tag: getClassName<CreateAccountController>())
                              .phoneNumber);
                      String phoneNumber = Get.find<CreateAccountController>(
                              tag: getClassName<CreateAccountController>())
                          .phoneNumber
                          .replaceAll(countryCode, '');
                      File? image = Get.find<CameraScreenController>(
                              tag: getClassName<CameraScreenController>())
                          .getImage;
                      String otp = Get.find<VerificationController>(
                              tag: getClassName<VerificationController>())
                          .otp;

                      SignUpBody signUpBody = SignUpBody(
                          fName: fName,
                          lName: lName,
                          gender: gender,
                          occupation: occupation,
                          email: email,
                          phone: phoneNumber,
                          otp: otp,
                          password: password,
                          dialCountryCode: countryCode);

                      List<MultipartBody> multipartBody;
                      if (image != null) {
                        multipartBody = [MultipartBody('image', image)];
                      } else {
                        multipartBody = [];
                      }

                      Get.find<AuthController>(
                              tag: getClassName<AuthController>())
                          .registration(signUpBody, multipartBody);
                    } else {
                      showCustomSnackBar('pin_not_matched'.tr, isError: true);
                    }
                  }
                }
              },
              elevation: 0,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              child: GetBuilder<AuthController>(
                  init: Get.find<AuthController>(tag: getClassName<AuthController>()),
                  tag: getClassName<AuthController>(),
                  builder: (controller) {
                  return !controller.isLoading
                      ? SizedBox(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            size: 28,
                          ),
                        )
                      : Center(
                          child: SizedBox(
                              height: 20.33,
                              width: 20.33,
                              child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor)));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

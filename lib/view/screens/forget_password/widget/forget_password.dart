// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, use_build_context_synchronously

import 'package:phone_number/phone_number.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/forget_password_controller.dart';
import 'package:zawadicash_app/helper/phone_cheker.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_country_code_picker.dart';
import 'package:zawadicash_app/view/base/custom_logo.dart';
import 'package:zawadicash_app/view/base/custom_large_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';

class ForgetPassword extends StatefulWidget {
  final String? phoneNumber, countryCode;
  const ForgetPassword({Key? key, this.phoneNumber, this.countryCode})
      : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<ForgetPassController>(tag: getClassName<ForgetPassController>())
        .setInitialCode(widget.countryCode!);
    phoneNumberController.text = widget.phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'forget_password_appbar'.tr,
        ),
        body: Column(
          children: [
            Expanded(
              // flex: 10,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
                    ),
                    const CustomLogo(
                      height: Dimensions.BIG_LOGO,
                      width: Dimensions.BIG_LOGO,
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      child: Text(
                        'forget_pass_long_text'.tr,
                        style: rubikRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                    ),
                    Container(
                      height: 52,
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Center(
                        child: TextField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SIZE_SMALL),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SIZE_SMALL),
                              borderSide: BorderSide(
                                color: ColorResources.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                            prefixIcon: CustomCountryCodePiker(
                              onInit: (code) {},
                              initSelect: Get.find<ForgetPassController>(
                                      tag: getClassName<ForgetPassController>())
                                  .countryCode,
                              onChanged: (code) {
                                debugPrint(code.toString());
                                Get.find<ForgetPassController>(
                                        tag: getClassName<
                                            ForgetPassController>())
                                    .setCountryCode(code);
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GetBuilder<AuthController>(
                init: Get.find<AuthController>(
                    tag: getClassName<AuthController>()),
                tag: getClassName<AuthController>(),
                builder: (controller) {
                  return SizedBox(
                    height: 110,
                    child: !controller.isLoading
                        ? CustomLargeButton(
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            text: 'Send_for_otp'.tr,
                            onTap: () async {
                              String phoneNumber =
                                  Get.find<ForgetPassController>(
                                              tag: getClassName<
                                                  ForgetPassController>())
                                          .countryCode +
                                      phoneNumberController.text;
                              PhoneNumber number =
                                  await PhoneChecker.isNumberValid(phoneNumber);
                              debugPrint('f number-------->: $number');

                              if (number != null) {
                                Get.find<ForgetPassController>(
                                        tag: getClassName<
                                            ForgetPassController>())
                                    .sendForOtpResponse(
                                        context: context,
                                        phoneNumber:
                                            phoneNumberController.text);
                              } else {
                                showCustomSnackBar(
                                    'please_input_your_valid_number'.tr,
                                    isError: true);
                              }
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor),
                          ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

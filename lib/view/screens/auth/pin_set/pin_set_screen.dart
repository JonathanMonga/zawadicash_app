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
import 'package:zawadicash_app/view/base/appbar_stack_view.dart';
import 'package:zawadicash_app/view/base/custom_country_code_picker.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/screens/auth/pin_set/widget/pin_view.dart';

class PinSetScreen extends StatefulWidget {
  final SignUpBody signUpBody;
  const PinSetScreen({Key? key, required this.signUpBody}) : super(key: key);

  @override
  State<PinSetScreen> createState() => _PinSetScreenState();
}

class _PinSetScreenState extends State<PinSetScreen> {
  final TextEditingController passController = TextEditingController();

  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(children: [
          Expanded(flex: 6, child: Container(color: Theme.of(context).primaryColor)),

          Expanded(flex: 5, child: Container(color: Theme.of(context).cardColor)),
        ]),

        const Positioned(
          top: Dimensions.paddingSizeOverLarge,
          left: 0, right: 0,
          child: AppbarStackView(),
        ),

        Positioned(top: context.height * 0.18, left: 0, right: 0, bottom: 0, child: PinView(
          passController: passController,
          confirmPassController: confirmPassController,
        )),
      ]),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeLarge,
          horizontal: Dimensions.paddingSizeSmall,
        ),
        child: FloatingActionButton(
          onPressed: () {
            String password =  passController.text.trim();
            String confirmPassword =  confirmPassController.text.trim();

            if(password.isEmpty  || confirmPassword.isEmpty){
              showCustomSnackBar('enter_your_pin'.tr);
            }else if(password.length < 4 ){
              showCustomSnackBar('pin_should_be_4_digit'.tr);
            }else if(password != confirmPassword){
              showCustomSnackBar('pin_not_matched'.tr);
            }else{
              String gender =  Get.find<ProfileController>().gender;
              String countryCode = CustomCountryCodePiker.getCountryCode(Get.find<CreateAccountController>().phoneNumber)!;
              String phoneNumber = Get.find<CreateAccountController>().phoneNumber!.replaceAll(countryCode, '');
              File? image =  Get.find<CameraScreenController>().getImage;
              String? otp =  Get.find<VerificationController>().otp;

              SignUpBody signUpBody = SignUpBody(
                  fName: widget.signUpBody.fName,
                  lName: widget.signUpBody.lName,
                  gender: gender,
                  occupation: widget.signUpBody.occupation,
                  email: widget.signUpBody.email,
                  phone: phoneNumber,
                  otp: otp,
                  password: password,
                  dialCountryCode: countryCode
              );

              MultipartBody multipartBody = MultipartBody('image',image );
              Get.find<AuthController>().registration(signUpBody,[multipartBody]);
            }

          },
          elevation: 0,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: GetBuilder<AuthController>(builder: (controller){
            return !controller.isLoading ? SizedBox(

              child:  Icon(Icons.arrow_forward,color: Theme.of(context).textTheme.bodyLarge!.color,size: 28,),
            ) : Center(child: SizedBox(height: 20.33,
                width: 20.33,
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor)));
          },),
        ) ,
      ),
    );
  }
}

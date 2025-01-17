// ignore_for_file: library_private_types_in_public_api

import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/forget_password_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/screens/auth/pin_set/widget/appbar_view.dart';
import 'package:zawadicash_app/view/screens/forget_password/widget/pin_field_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? phoneNumber;
  const ResetPasswordScreen({Key? key, this.phoneNumber}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPassController = TextEditingController();
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
                    flex: 5,
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
                child: PinFieldView(
                  newPassController: newPassController,
                  confirmPassController: confirmPassController,
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: FloatingActionButton(
              onPressed: () {
                Get.find<ForgetPassController>(tag: getClassName<ForgetPassController>()).resetPassword(
                    newPassController,
                    confirmPassController,
                    widget.phoneNumber!);
              },
              elevation: 0,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              child: GetBuilder<AuthController>(
                init: Get.find<AuthController>(
                    tag: getClassName<AuthController>()),
                tag: getClassName<AuthController>(),
                builder: (controller) => !controller.isLoading
                    ? Center(
                        child: Icon(
                        Icons.arrow_forward,
                        color: ColorResources.blackColor,
                        size: 28,
                      ))
                    : SizedBox(
                        height: 20.33,
                        width: 20.33,
                        child: CircularProgressIndicator(
                            color:
                                Theme.of(context).textTheme.titleLarge!.color)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

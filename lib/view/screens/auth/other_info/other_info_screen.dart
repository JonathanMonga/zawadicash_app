import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/animated_custom_dialog.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_large_button.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/base/my_dialog.dart';
import 'package:zawadicash_app/view/screens/auth/other_info/widget/gender_view.dart';
import 'package:zawadicash_app/view/screens/auth/other_info/widget/input_section.dart';

class OtherInfoScreen extends StatefulWidget {
  const OtherInfoScreen({Key? key}) : super(key: key);

  @override
  State<OtherInfoScreen> createState() => _OtherInfoScreenState();
}

class _OtherInfoScreenState extends State<OtherInfoScreen> {
  TextEditingController occupationTextController = TextEditingController();
  TextEditingController fNameTextController = TextEditingController();
  TextEditingController lNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onWillPop(context);
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'information'.tr,
          onTap: () {
            _onWillPop(context);
          },
        ),
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GenderView(),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_LARGE,
                    ),
                    //OccupationSelectionSection(),
                    InputSection(
                      occupationController: occupationTextController,
                      fNameController: fNameTextController,
                      lNameController: lNameTextController,
                      emailController: emailTextController,
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE,
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<ProfileController>(
                init: Get.find<ProfileController>(tag: getClassName<ProfileController>()),
                tag: getClassName<ProfileController>(),
                builder: (getController) {
              return SizedBox(
                height: 110,
                child: CustomLargeButton(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  text: 'proceed'.tr,
                  onTap: () {
                    if (fNameTextController.text == '' ||
                        lNameTextController.text == '') {
                      showCustomSnackBar('first_name_or_last_name'.tr,
                          isError: true);
                    } else {
                      if (emailTextController.text != '') {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailTextController.text);
                        if (!emailValid) {
                          showCustomSnackBar('please_provide_valid_email'.tr,
                              isError: true);
                        } else {
                          Get.toNamed(RouteHelper.getPinSetRoute(
                            fName: fNameTextController.text,
                            lName: lNameTextController.text,
                            email: emailTextController.text,
                            occupation: occupationTextController.text,
                          ));
                        }
                      } else {
                        debugPrint('without email');
                        Get.toNamed(RouteHelper.getPinSetRoute(
                          fName: fNameTextController.text,
                          lName: lNameTextController.text,
                          email: emailTextController.text,
                          occupation: occupationTextController.text,
                        ));
                      }
                    }
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    showAnimatedDialog(
      context,
      MyDialog(
          icon: Icons.clear,
          title: 'alert'.tr,
          description: 'your_information_will_remove'.tr,
          isFailed: true,
          showTwoBtn: true,
          onTap: () {
            Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).removeImage();
            Get.find<AuthController>(tag: getClassName<AuthController>()).change(0);
            Get.offAllNamed(RouteHelper.getChoseLoginRegRoute());
          }),
      dismissible: false,
      isFlip: true,
    );

    return true;
  }
}

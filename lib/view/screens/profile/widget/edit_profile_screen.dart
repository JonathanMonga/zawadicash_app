// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/controller/edit_profile_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/data/model/body/edit_profile_body.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';
import 'package:zawadicash_app/view/base/custom_small_button.dart';
import 'package:zawadicash_app/view/screens/auth/other_info/widget/gender_view.dart';
import 'package:zawadicash_app/view/screens/auth/other_info/widget/input_section.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController occupationTextController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ProfileController profileController = Get.find<ProfileController>(tag: getClassName<ProfileController>());
    occupationTextController.text = profileController.userInfo!.occupation ?? '';
    firstNameController.text = profileController.userInfo!.fName ?? '';
    lastNameController.text = profileController.userInfo!.lName ?? '';
    emailController.text = profileController.userInfo!.email ?? '';
    Get.find<EditProfileController>(tag: getClassName<EditProfileController>())
        .setGender(profileController.userInfo!.gender ?? 'Male');
    Get.find<EditProfileController>(tag: getClassName<EditProfileController>())
        .setImage(profileController.userInfo!.image ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
        init: Get.find<EditProfileController>(tag: getClassName<EditProfileController>()),
        tag: getClassName<EditProfileController>(),
        builder: (controller) {
      return ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        progressIndicator:
            CircularProgressIndicator(color: Theme.of(context).primaryColor),
        child: WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
            appBar: CustomAppbar(
                title: 'edit_profile'.tr,
                onTap: () {
                  Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).removeImage();
                  Get.back();
                }),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GetBuilder<CameraScreenController>(
                              init: Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()),
                              tag: getClassName<CameraScreenController>(),
                              builder: (imageController) {
                                return imageController.getImage == null
                                    ? GetBuilder<ProfileController>(
                                    init: Get.find<ProfileController>(tag: getClassName<ProfileController>()),
                                    tag: getClassName<ProfileController>(),
                                        builder: (proController) {
                                        return proController.isLoading
                                            ? const SizedBox()
                                            : Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CustomImage(
                                                      placeholder:
                                                          Images.avatar,
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                      image:
                                                          '${Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.baseUrls!.customerImageUrl}/${proController.userInfo!.image ?? ''}'),
                                                ),
                                              );
                                      })
                                    : Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color!,
                                                width: 2),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                File(imageController
                                                    .getImage.path),
                                              ),
                                            )),
                                      );
                              },
                            ),
                            Positioned(
                              bottom: 5,
                              right: -5,
                              child: InkWell(
                                onTap: () => Get.find<AuthController>(tag: getClassName<AuthController>())
                                    .requestCameraPermission(
                                        fromEditProfile: true),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorResources.getShadowColor()
                                              .withOpacity(0.08),
                                          blurRadius: 20,
                                          offset: const Offset(0, 3),
                                        )
                                      ]),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE),
                          child: GenderView(fromEditProfile: true),
                        ),
                        InputSection(
                          occupationController: occupationTextController,
                          fNameController: firstNameController,
                          lNameController: lastNameController,
                          emailController: emailController,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: Dimensions.PADDING_SIZE_DEFAULT,
                    right: Dimensions.PADDING_SIZE_DEFAULT,
                    bottom: Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomSmallButton(
                          onTap: () => _saveProfile(controller),
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          text: 'save'.tr,
                          textColor:
                              Theme.of(context).textTheme.bodyLarge!.color!,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).getImage != null) {
      Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).removeImage();
      debugPrint('====> Remove image from controller');
      Get.back();

      return true;
    } else {
      Get.back();
      return true;
    }
  }

  _saveProfile(EditProfileController controller) {
    String fName = firstNameController.text;
    String lName = lastNameController.text;
    String email = emailController.text;
    String gender = controller.gender;
    String occupation = occupationTextController.text;
    File image = Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).getImage;

    List<MultipartBody> multipartBody;
    if (image != null) {
      multipartBody = [MultipartBody('image', image)];
    } else {
      multipartBody = [];
    }

    EditProfileBody editProfileBody = EditProfileBody(
      fName: fName,
      lName: lName,
      gender: gender,
      occupation: occupation,
      email: email,
    );
    controller.updateProfileData(editProfileBody, multipartBody).then((value) {
      if (value) {
        Get.find<ProfileController>(tag: getClassName<ProfileController>()).profileData();
      }
    });
  }
}

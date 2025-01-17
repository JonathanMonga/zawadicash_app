import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/kyc_verify_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_button.dart';
import 'package:zawadicash_app/view/base/custom_drop_down_button.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/base/custom_text_field.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';

class KycVerifyScreen extends StatefulWidget {
  const KycVerifyScreen({Key? key}) : super(key: key);

  @override
  State<KycVerifyScreen> createState() => _KycVerifyScreenState();
}

class _KycVerifyScreenState extends State<KycVerifyScreen> {
  final TextEditingController _identityNumberController =
      TextEditingController();

  @override
  void initState() {
    Get.find<KycVerifyController>(tag: getClassName<KycVerifyController>()).initialSelect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'kyc_verification'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.FONT_SIZE_DEFAULT,
            vertical: Dimensions.PADDING_SIZE_LARGE),
        child: GetBuilder<KycVerifyController>(
            init: Get.find<KycVerifyController>(
                tag: getClassName<KycVerifyController>()),
            tag: getClassName<KycVerifyController>(),
            builder: (kycVerifyController) {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownButton(
                        value: kycVerifyController.dropDownSelectedValue,
                        itemList: kycVerifyController.dropList,
                        onChanged: kycVerifyController.dropDownChange,
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_DEFAULT),
                      CustomTextField(
                        controller: _identityNumberController,
                        fillColor: Theme.of(context).cardColor,
                        isShowBorder: true,
                        maxLines: 1,
                        hintText: 'identity_number'.tr,
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_DEFAULT),
                      Text('upload_your_image'.tr, style: rubikRegular),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              kycVerifyController.identityImage.length + 1,
                          itemBuilder: (BuildContext context, index) {
                            if (index + 1 ==
                                kycVerifyController.identityImage.length + 1) {
                              return _borderWidget(null);
                            }
                            return kycVerifyController.identityImage.isNotEmpty
                                ? Row(
                                    children: [
                                      Stack(
                                        children: [
                                          _borderWidget(kycVerifyController
                                              .identityImage[index].path),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: InkWell(
                                              onTap: () => kycVerifyController
                                                  .removeImage(index),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.red
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  Dimensions
                                                                      .PADDING_SIZE_DEFAULT))),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                      size: 16,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          width:
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                    ],
                                  )
                                : const SizedBox();
                          },
                        ),
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      Center(
                        child: kycVerifyController.isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: 200,
                                height: 50,
                                child: CustomButton(
                                    buttonText: 'upload'.tr,
                                    onTap: () {
                                      if (_identityNumberController
                                          .text.isEmpty) {
                                        showCustomSnackBar(
                                            'identity_number_is_empty'.tr);
                                      } else if (kycVerifyController
                                          .identityImage.isEmpty) {
                                        showCustomSnackBar(
                                            'please_upload_identity_image'.tr);
                                      } else if (kycVerifyController
                                              .dropDownSelectedValue ==
                                          kycVerifyController.dropList[0]) {
                                        showCustomSnackBar(
                                            'select_identity_type'.tr);
                                      } else {
                                        kycVerifyController
                                            .kycVerify(
                                                _identityNumberController.text)
                                            .then((value) => Get.find<
                                                        ProfileController>(
                                                    tag: getClassName<
                                                        ProfileController>())
                                                .profileData(
                                                    isUpdate: true,
                                                    reload: true));
                                      }
                                    },
                                    color: Theme.of(context).primaryColor),
                              ),
                      ),
                    ]),
              );
            }),
      ),
    );
  }

  Widget _borderWidget(String? path) {
    return DottedBorder(
      dashPattern: const [10],
      borderType: BorderType.RRect,
      strokeWidth: 0.5,
      color: Theme.of(Get.context!).hintColor,
      child: CustomInkWell(
        onTap: path != null
            ? () {}
            : () => Get.find<KycVerifyController>(tag: getClassName<KycVerifyController>()).pickImage(false),
        child: path != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Dimensions.PADDING_SIZE_SMALL)),
                  child: Image.file(
                    File(path),
                    width: 160,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : SizedBox(
                height: 100,
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(Images.camera_icon),
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/logout_dialog.dart';

class LoaderDialog extends StatelessWidget {
  const LoaderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraScreenController>(
        init: Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()),
        tag: getClassName<CameraScreenController>(),
        builder: (cameraScreenController) {
      return cameraScreenController.isSuccess == 0
          ? const Center(child: CircularProgressIndicator())
          : cameraScreenController.isSuccess == 1
              ? CustomDialog(
                  icon: Icons.done,
                  title: '',
                  description: 'face_scanning_successful'.tr,
                  onTapFalse: () {
                    Navigator.pop(Get.context!);
                  },
                  onTapTrue: () {},
                )
              : CustomDialog(
                  icon: Icons.cancel_outlined,
                  title: '',
                  description: 'sorry_your_face_could_not_detect'.tr,
                  onTapTrueText: 'retry'.tr,
                  onTapFalseText: 'cancel'.tr,
                  isFailed: true,
                  onTapFalse: () {
                    cameraScreenController.fromEditProfile
                        ? Get.offNamed(RouteHelper.getNavBarRoute())
                        : Get.offAllNamed(RouteHelper.getSplashRoute());
                  },
                  onTapTrue: () {
                    cameraScreenController.valueInitialize(
                        cameraScreenController.fromEditProfile);
                    Get.back();
                    cameraScreenController.startLiveFeed();
                  },
                );
    });
  }
}

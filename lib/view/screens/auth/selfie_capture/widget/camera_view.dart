// ignore_for_file: library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/util/get_class_name.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {


// @override
  // void initState() {
  //   super.initState();
  //   // Get.find<CameraScreenController>().startLiveFeed(fromEditProfile: widget.fromEditProfile, isQrCodeScan: widget.isQrCodeScan);
  // }
  //
  // @override
  // void dispose() {
  //   Get.find<CameraScreenController>().stopLiveFeed();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraScreenController>(
        init: Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()),
        tag: getClassName<CameraScreenController>(),
      builder: (cameraController) {
        if (cameraController.controller.value.isInitialized == false) {
          return const SizedBox();
        }

        final size = MediaQuery.of(context).size;
        return Container(
          color: Colors.black,
          height: size.height * 0.7,
          width: size.width,
          child: AspectRatio(
            aspectRatio: cameraController.controller.value.aspectRatio,
            child: CameraPreview(cameraController.controller),
          ),
        );
      }
    );
  }
}
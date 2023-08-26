import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/screens/auth/other_info/other_info_screen.dart';
import 'package:zawadicash_app/view/screens/auth/selfie_capture/widget/camera_view.dart';
import 'package:zawadicash_app/view/screens/profile/widget/edit_profile_screen.dart';

class CameraScreen extends StatefulWidget {
  final bool fromEditProfile;
  final bool isBarCodeScan;
  final bool isHome;
  final String transactionType;
  const CameraScreen({
    Key? key,
    required this.fromEditProfile,
    this.isBarCodeScan = false,
    this.isHome = false,
    this.transactionType = '',
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void dispose() {
    Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).stopLiveFeed();
    debugPrint('dispose method call');
    super.dispose();
  }

  @override
  void initState() {
    Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).valueInitialize(widget.fromEditProfile);
    Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()).startLiveFeed(
      isQrCodeScan: widget.isBarCodeScan,
      isHome: widget.isHome,
      transactionType: widget.transactionType,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          title: widget.isBarCodeScan ? 'scanner'.tr : 'face_verification'.tr,
          isSkip: (!widget.isBarCodeScan && true && !widget.fromEditProfile),
          function: () {
            if (widget.fromEditProfile) {
              Get.off(() => const EditProfileScreen());
            } else {
              Get.off(() => const OtherInfoScreen());
            }
          }),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Stack(
              children: [
                const CameraView(),
                FractionallySizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: DottedBorder(
                      strokeWidth: 3,
                      borderType: BorderType.Rect,
                      dashPattern: const [10],
                      color: Colors.white,
                      child: const FractionallySizedBox(
                          heightFactor: 0.7, widthFactor: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: _hintView(widget.isBarCodeScan),
          ),
        ],
      ),
    );
  }

  Widget _hintView(bool isBarCodeScan) {
    return GetBuilder<CameraScreenController>(
        init: Get.find<CameraScreenController>(tag: getClassName<CameraScreenController>()),
        tag: getClassName<CameraScreenController>(),
        builder: (cameraScreenController) {
      return SingleChildScrollView(
        child: isBarCodeScan
            ? Center(
                child: Image.asset(Images.qr_scan_animation,
                    width: 200,
                    fit: BoxFit.contain,
                    alignment: Alignment.center),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 5.0,
                    percent: cameraScreenController.eyeBlink / 3,
                    center: Image.asset(Images.eye_icon, width: 40),
                    progressColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Text(
                      cameraScreenController.eyeBlink < 3
                          ? 'straighten_your_face'.tr
                          : 'processing_image'.tr,
                      style: rubikRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      );
    });
  }
}

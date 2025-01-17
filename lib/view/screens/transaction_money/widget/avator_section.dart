// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/bootom_slider_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';

class AvatarSection extends StatefulWidget {
  final String image;
  const AvatarSection({Key? key, required this.image}) : super(key: key);

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  @override
  void initState() {
    Get.find<BottomSliderController>(tag: getClassName<BottomSliderController>()).isStopFun();
    Get.find<BottomSliderController>(tag: getClassName<BottomSliderController>()).changeAlignmentValue();
    super.initState();
  }

  @override
  void dispose() {
    Get.find<BottomSliderController>(tag: getClassName<BottomSliderController>()).isStopFun();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        GetBuilder<BottomSliderController>(
            init: Get.find<BottomSliderController>(tag: getClassName<BottomSliderController>()),
            tag: getClassName<BottomSliderController>(),
            builder: (controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Dimensions.RADIUS_SIZE_OVER_LARGE,
                height: Dimensions.RADIUS_SIZE_OVER_LARGE,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Dimensions.RADIUS_SIZE_VERY_SMALL),
                  ),
                  child: CustomImage(
                    fit: BoxFit.cover,
                    image:
                        "${Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.baseUrls!.customerImageUrl}/${Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo == null ? '' : Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo!.image}",
                    placeholder: Images.avatar,
                  ),
                ),
              ),
              AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  alignment: controller.alinmentRightIndicator
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  width: 60.0,
                  child: Image.asset(
                    Images.slide_right_icon,
                    height: 10,
                    width: 10,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  )),
              SizedBox(
                width: Dimensions.RADIUS_SIZE_OVER_LARGE,
                height: Dimensions.RADIUS_SIZE_OVER_LARGE,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Dimensions.RADIUS_SIZE_VERY_SMALL),
                  ),
                  child: CustomImage(
                    fit: BoxFit.cover,
                    image: widget.image,
                    placeholder: Images.avatar,
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(
          height: 28.0 / 1.7,
        ),
      ],
    );
  }
}

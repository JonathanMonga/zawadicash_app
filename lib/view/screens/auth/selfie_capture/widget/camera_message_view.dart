import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';

class CameraMessageView extends StatelessWidget {
  const CameraMessageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
              Dimensions.radiusSizeVerySmall)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'take_a_selfie'.tr,
            style: rubikRegular.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeExtraLarge,
            ),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          Text(
            'place_your_face_inside_the_frame'.tr,
            style: rubikLight.copyWith(
              color: ColorResources.getOnboardGreyColor(),
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        ],
      ),
    );
  }
}

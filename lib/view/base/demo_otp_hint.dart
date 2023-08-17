import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';

class DemoOtpHint extends StatelessWidget {
  const DemoOtpHint({super.key});

  @override
  Widget build(BuildContext context) {
    return AppConstants.DEMO
        ? Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL),
            child: Text(
              'for_demo_1234'.tr,
              style: rubikMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                  color: Theme.of(context).highlightColor),
            ),
          )
        : const SizedBox();
  }
}

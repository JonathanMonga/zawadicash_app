import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';

class InputFieldShimmer extends StatelessWidget {
  const InputFieldShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey[200]!,
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                        bottom: Dimensions.PADDING_SIZE_LARGE),
                    child: TextField(
                      enabled: false,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      style: rubikMedium.copyWith(
                          fontSize: 34,
                          color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: PriceConverter.balanceInputHint(),
                          hintStyle: rubikMedium.copyWith(
                              fontSize: 34,
                              color: Theme.of(context).primaryColor)),
                    ),
                  ),
                  Center(
                      child: Text(
                          '${'available_balance'.tr} ${PriceConverter.availableBalance()}',
                          style: rubikRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.getGreyBaseGray1()))),
                  const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                ],
              ),
              Positioned(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                  child: Image.asset(Images.logo, width: 50.0)),
              Positioned(
                  right: 10,
                  bottom: 5,
                  child: Image.asset(Images.input_stack_desing,
                      width: 150.0, filterQuality: FilterQuality.high)),
            ],
          ),
          Container(height: Dimensions.DIVIDER_SIZE_MEDIUM),
        ],
      ),
    );
  }
}

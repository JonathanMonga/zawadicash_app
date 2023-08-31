import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  const ScanButton({Key? key,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeOverLarge),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: CustomInkWell(
        onTap: onTap,
        radius: Dimensions.radiusSizeOverLarge,
        child: DottedBorder(
          strokeWidth: 1.0,
          color: Theme.of(context).primaryColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(Dimensions.radiusSizeOverLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(Images.qrCode, width: Dimensions.paddingSizeDefault),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text('scan_qr_code'.tr, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.blackColor),),
                )
              ],
            ),
          )),
      ),
    );
  }
}
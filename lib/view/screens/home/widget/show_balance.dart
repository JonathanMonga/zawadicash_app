// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';

class ShowBalance extends StatelessWidget {
  final ProfileController? profileController;
  const ShowBalance({Key? key, this.profileController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        profileController!.userInfo != null
            ? Text(
                PriceConverter.balanceWithSymbol(
                    balance: profileController!.userInfo!.balance.toString()),
                style: rubikMedium.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                ))
            : Text(PriceConverter.balanceWithSymbol(balance: '0.0'),
                style: rubikMedium.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                )),
        const SizedBox(
          height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
        Text('available_balance'.tr,
            style: rubikLight.copyWith(
                fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Colors.white)),
        const SizedBox(
          height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
        profileController!.userInfo != null
            ? Text(
                '(${'sent'.tr} ${PriceConverter.balanceWithSymbol(balance: profileController!.userInfo!.pendingBalance.toString())} ${'withdraw_req'.tr})',
                style: rubikMedium.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                ))
            : const SizedBox(),
      ],
    );
  }
}

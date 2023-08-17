import 'package:flutter/material.dart';
import 'package:zawadicash_app/helper/functions.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';

class CustomLargeButton extends StatelessWidget {
  final String? text;
  final OnTapFunction? onTap;
  final Color? backgroundColor;
  final double? bottomPadding;
  const CustomLargeButton({
    super.key,
    this.backgroundColor,
    this.onTap,
    this.text,
    this.bottomPadding = Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
        right: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
        bottom: bottomPadding!,
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          minimumSize: MediaQuery.of(context).size,
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.PADDING_SIZE_DEFAULT),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
          ),
        ),
        child: Text(
          text!,
          style: rubikRegular.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
          ),
        ),
      ),
    );
  }
}

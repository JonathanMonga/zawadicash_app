import 'package:flutter/material.dart';
import 'package:zawadicash_app/helper/functions.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';

class CustomGenderCard extends StatelessWidget {
  final String? icon, text;
  final Color? color;
  final OnTapFunction? onTap;
  const CustomGenderCard(
      {super.key, this.icon, this.text, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 76,
        width: 94,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(icon!),
            ),
            const SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            Text(
              text!,
              style: rubikRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

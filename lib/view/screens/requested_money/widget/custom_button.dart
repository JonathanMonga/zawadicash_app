import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/theme_controller.dart';
import 'package:zawadicash_app/helper/functions.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';

class CustomButton extends StatelessWidget {
  final OnTapFunction? onTap;
  final String? btnTxt;
  final Color? backgroundColor;
  const CustomButton(
      {super.key, this.onTap, required this.btnTxt, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: onTap == null
            ? ColorResources.getGreyColor()
            : backgroundColor ?? Theme.of(context).primaryColor,
      ),
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorResources.getAcceptBtn(),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 1)), // changes position of shadow
            ],
            gradient: (Get.find<ThemeController>(tag: getClassName<ThemeController>()).darkTheme)
                ? null
                : LinearGradient(colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ]),
            borderRadius: BorderRadius.circular(10)),
        child: Text(btnTxt!,
            style: rubikMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Colors.white)),
      ),
    );
  }
}

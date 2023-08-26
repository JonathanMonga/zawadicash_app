import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/images.dart';

class CustomLogo extends StatelessWidget {
  final double? height, width;
  final Image? logo;
  const CustomLogo({Key? key, this.height, this.width, this.logo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: logo ?? Image.asset(Images.logo),
    );
  }
}

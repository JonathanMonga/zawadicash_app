import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/images.dart';

class CustomLogo extends StatelessWidget {
  final double? height, width;
  final Image? image;

  const CustomLogo({Key? key, this.height, this.width, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: image ?? Image.asset(Images.logo),
    );
  }
}

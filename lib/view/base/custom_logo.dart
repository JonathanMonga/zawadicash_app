
import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/images.dart';

class CustomLogo extends StatelessWidget {
  final double height,width;
  const CustomLogo({super.key, 
    this.height,this.width
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.asset(Images.logo),

    );
  }
}

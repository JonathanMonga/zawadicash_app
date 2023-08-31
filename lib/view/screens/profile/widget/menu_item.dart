import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.image,
    required this.title,
    this.iconData,
  }) : super(key: key);
  final String? image;
  final String title;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeDefault),
      child: Row(children: [
        SizedBox(
          width: Dimensions.fontSizeOverOverLarge,
          height: Dimensions.fontSizeOverOverLarge,
          child: image != null ?
          Image.asset(image!,fit: BoxFit.contain) : Icon(iconData),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Text(title,style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const Spacer(),

        const Icon(Icons.arrow_forward_ios_rounded,size: Dimensions.radiusSizeDefault,),
      ],),
    );
  }
}
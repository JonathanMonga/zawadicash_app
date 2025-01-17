import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/theme_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';

class CustomPersistentHeader extends StatefulWidget {
  final VoidCallback? onTap;
  const CustomPersistentHeader({Key? key, this.onTap}) : super(key: key);

  @override
  State<CustomPersistentHeader> createState() => _CustomPersistentHeaderState();
}

class _CustomPersistentHeaderState extends State<CustomPersistentHeader> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE),
              topRight: Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE),
            ),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                  color: ColorResources.getBlackAndWhite().withOpacity(0.2),
                  blurRadius: Get.find<ThemeController>(
                              tag: getClassName<ThemeController>())
                          .darkTheme
                      ? 0
                      : 20,
                  offset: const Offset(0, 0)),
            ]),
        child: Center(
          child: Container(
            height: 5,
            width: 32,
            margin: const EdgeInsets.only(
              top: Dimensions.PADDING_SIZE_DEFAULT,
              bottom: Dimensions.PADDING_SIZE_SMALL,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: ColorResources.nevDefaultColor,
            ),
          ),
        ),
      ),
    );
  }
}

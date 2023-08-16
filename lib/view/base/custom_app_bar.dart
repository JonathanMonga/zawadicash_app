import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/base/roundedButton.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onTap;
  final bool isSkip;
  final Function function;
  const CustomAppbar({super.key, required this.title, this.onTap,this.isSkip = false, this.function});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomInkWell(
                  onTap: onTap ?? () {
                    Get.back();
                  },
                  radius: Dimensions.RADIUS_SIZE_SMALL,
                  child: Container(
                    height: 40,width: 40,
                    // padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.7), width: 0.5),
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new, size: Dimensions.ARROW_ICON_SIZE, color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                Text(title, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.white),
                ),

                isSkip ? const Spacer() : const SizedBox(),

                isSkip ? SizedBox(child: RoundedButton(buttonText: 'skip'.tr, onTap: function, isSkip: true,)) : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, Dimensions.APPBAR_HIGHT_SIZE);
}

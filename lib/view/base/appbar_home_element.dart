import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';

class AppbarHomeElement extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppbarHomeElement({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: rubikSemiBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_DEFAULT,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 60.0);
}

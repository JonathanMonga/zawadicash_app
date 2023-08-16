import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/localization_controller.dart';
import 'package:zawadicash_app/helper/route_helper.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/view/base/custom_logo.dart';

import '../../../../base/roundedButton.dart';

class AppbarView extends StatelessWidget {
  final bool isLogin;
  const AppbarView({Key key,@required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
        right: Dimensions.PADDING_SIZE_LARGE,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomLogo(
            height: Dimensions.SMALL_LOGO,
            width: Dimensions.SMALL_LOGO,
          ),
          isLogin
              ? RoundedButton(onTap: (){
            Get.toNamed(RouteHelper.getChoseLanguageRoute());
          }, buttonText: AppConstants.languages[Get.find<LocalizationController>().selectedIndex].languageName,)
          : Container(),
        ],
      ),
    );
  }
}




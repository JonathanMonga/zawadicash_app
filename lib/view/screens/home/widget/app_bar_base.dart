// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/home_controller.dart';
import 'package:zawadicash_app/controller/menus_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/helper/transaction_type.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';
import 'package:zawadicash_app/view/screens/home/widget/animated_card/custom_rect_tween.dart';
import 'package:zawadicash_app/view/screens/home/widget/animated_card/hero_dialogue_route.dart';
import 'package:zawadicash_app/view/screens/home/widget/animated_card/qr_popup_card.dart';
import 'package:zawadicash_app/view/screens/home/widget/show_balance.dart';
import 'package:zawadicash_app/view/screens/home/widget/show_name.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_balance_input.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/animated_button.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init:
            Get.find<ProfileController>(tag: getClassName<ProfileController>()),
        tag: getClassName<ProfileController>(),
        builder: (profileController) {
          return SingleChildScrollView(
              child: Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.only(
                top: 54,
                left: Dimensions.PADDING_SIZE_LARGE,
                right: Dimensions.PADDING_SIZE_LARGE,
                bottom: Dimensions.PADDING_SIZE_SMALL,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft:
                      Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.find<MenusController>(
                                tag: getClassName<MenusController>())
                            .selectProfilePage(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: Dimensions.RADIUS_SIZE_OVER_LARGE,
                          width: Dimensions.RADIUS_SIZE_OVER_LARGE,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: profileController.userInfo == null
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(Images.avatar,
                                          fit: BoxFit.cover),
                                    ),
                                  )
                                : CustomImage(
                                    image:
                                        '${Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.baseUrls!.customerImageUrl}/${profileController.userInfo!.image ?? ''}',
                                    fit: BoxFit.cover,
                                    placeholder: Images.avatar,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Get.find<SplashController>(
                                      tag: getClassName<SplashController>())
                                  .configModel
                                  .themeIndex ==
                              '1'
                          ? const ShowName()
                          : ShowBalance(profileController: profileController),
                    ],
                  ),

                  // const Spacer(),

                  Row(
                    children: [
                      AnimatedButtonView(
                        onTap: () =>
                            Get.to(() => const TransactionMoneyBalanceInput(
                                  transactionType:
                                      TransactionType.WITHDRAW_REQUEST,
                                )),
                      ),
                      const SizedBox(
                        width: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(HeroDialogRoute(
                            builder: (_) => const QrPopupCard())),
                        child: Hero(
                          tag: Get.find<HomeController>(
                                  tag: getClassName<HomeController>())
                              .heroShowQr,
                          createRectTween: (begin, end) =>
                              CustomRectTween(begin: begin!, end: end!),
                          child: Container(
                            width: Get.width * 0.10,
                            height: Get.width * 0.10,
                            padding: EdgeInsets.all(Get.width * 0.025),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                            ),
                            child: profileController.userInfo != null
                                ? SvgPicture.string(
                                    profileController.userInfo!.qrCode!,
                                    height: Dimensions.PADDING_SIZE_LARGE,
                                    width: Dimensions.PADDING_SIZE_LARGE,
                                  )
                                : SizedBox(
                                    height: Dimensions.PADDING_SIZE_LARGE,
                                    width: Dimensions.PADDING_SIZE_LARGE,
                                    child: Image.asset(Images.qrCode),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
        });
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 200);
}

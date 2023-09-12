import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/home_controller.dart';
import 'package:zawadicash_app/controller/menu_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/helper/transaction_type.dart';
import 'package:zawadicash_app/util/dimensions.dart';
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
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          padding: const EdgeInsets.only(
            top: 54,
            left: Dimensions.paddingSizeLarge,
            right: Dimensions.paddingSizeLarge,
            bottom: Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.radiusSizeExtraLarge),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        Get.find<MenuItemController>().selectProfilePage(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: Dimensions.radiusSizeOverLarge,
                      width: Dimensions.radiusSizeOverLarge,
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
                                    '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${profileController.userInfo!.image ?? ''}',
                                fit: BoxFit.cover,
                                placeholder: Images.avatar,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Get.find<SplashController>().configModel!.themeIndex == 1
                      ? const ShowName()
                      : ShowBalance(profileController: profileController),
                ],
              ),

              // const Spacer(),

              Row(
                children: [
                  GetBuilder<SplashController>(builder: (splashController) {
                    bool isRequestMoney = splashController
                        .configModel!.systemFeature!.withdrawRequestStatus!;
                    return isRequestMoney
                        ? AnimatedButtonView(
                            onTap: () =>
                                Get.to(() => const TransactionMoneyBalanceInput(
                                      transactionType:
                                          TransactionType.withdrawRequest,
                                    )),
                          )
                        : const SizedBox();
                  }),
                  const SizedBox(
                    width: Dimensions.paddingSizeSmall,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        HeroDialogRoute(builder: (_) => const QrPopupCard())),
                    child: Hero(
                      tag: Get.find<HomeController>().heroShowQr,
                      createRectTween: (begin, end) =>
                          CustomRectTween(begin: begin, end: end),
                      child: Container(
                        width: Get.width * 0.11,
                        height: Get.width * 0.11,
                        padding: EdgeInsets.all(Get.width * 0.025),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                        ),
                        child: profileController.userInfo != null
                            ? SvgPicture.string(
                                profileController.userInfo!.qrCode!,
                                height: Dimensions.paddingSizeLarge,
                                width: Dimensions.paddingSizeLarge,
                              )
                            : SizedBox(
                                height: Dimensions.paddingSizeLarge,
                                width: Dimensions.paddingSizeLarge,
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
      );
    });
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 200);
}

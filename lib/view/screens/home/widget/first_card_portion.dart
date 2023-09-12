import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/helper/transaction_type.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/screens/home/widget/banner_view.dart';
import 'package:zawadicash_app/view/screens/home/widget/custom_card.dart';
import 'package:zawadicash_app/view/screens/requested_money/requested_money_list_screen.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_balance_input.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_screen.dart';

class FirstCardPortion extends StatelessWidget {
  const FirstCardPortion({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return Stack(children: [
        Container(
          height: 180.0,
          color: Theme.of(context).primaryColor,
        ),
        Positioned(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80.0,
              margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge,
                vertical: Dimensions.paddingSizeLarge,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSizeLarge),
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge,
                    ),
                    child: GetBuilder<ProfileController>(
                        builder: (profileController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'your_balance'.tr,
                            style: rubikLight.copyWith(
                              color: ColorResources.getBalanceTextColor(),
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall,
                          ),
                          profileController.userInfo != null
                              ? Text(
                                  PriceConverter.balanceWithSymbol(
                                      balance: profileController
                                          .userInfo!.balance
                                          .toString()),
                                  style: rubikMedium.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                  ),
                                )
                              : Text(
                                  PriceConverter.convertPrice(0.00),
                                  style: rubikMedium.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                  ),
                                ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          profileController.userInfo != null
                              ? Text(
                                  '(${'sent'.tr} ${PriceConverter.balanceWithSymbol(balance: profileController.userInfo!.pendingBalance != null ? profileController.userInfo!.pendingBalance.toString() : 0 as String?)} ${'withdraw_req'.tr})',
                                  style: rubikMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                  ))
                              : const SizedBox(),
                        ],
                      );
                    }),
                  ),
                  const Spacer(),
                  if (splashController
                      .configModel!.systemFeature!.addMoneyStatus!)
                    Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSizeLarge),
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      child: CustomInkWell(
                        onTap: () => Get.to(const TransactionMoneyBalanceInput(
                            transactionType: 'add_money')),
                        radius: Dimensions.radiusSizeLarge,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 34,
                                  child: Image.asset(Images.walletLogo)),
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall,
                              ),
                              Text(
                                'add_money'.tr,
                                style: rubikRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Cards...
            SizedBox(
              height: 120.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.fontSizeExtraSmall),
                child: Row(
                  children: [
                    if (splashController
                        .configModel!.systemFeature!.sendMoneyStatus!)
                      Expanded(
                          child: CustomCard(
                        image: Images.sendMoneyLogo,
                        text: 'send_money'.tr.replaceAll(' ', '\n'),
                        color: Theme.of(context).secondaryHeaderColor,
                        onTap: () => Get.to(() => const TransactionMoneyScreen(
                              fromEdit: false,
                              transactionType: TransactionType.sendMoney,
                            )),
                      )),
                    if (splashController
                        .configModel!.systemFeature!.cashOutStatus!)
                      Expanded(
                          child: CustomCard(
                        image: Images.cashOutLogo,
                        text: 'cash_out'.tr.replaceAll(' ', '\n'),
                        color: ColorResources.getCashOutCardColor(),
                        onTap: () => Get.to(() => const TransactionMoneyScreen(
                              fromEdit: false,
                              transactionType: TransactionType.cashOut,
                            )),
                      )),
                    if (splashController
                        .configModel!.systemFeature!.sendMoneyRequestStatus!)
                      Expanded(
                          child: CustomCard(
                        image: Images.requestMoneyLogo,
                        text: 'request_money'.tr,
                        color: ColorResources.getRequestMoneyCardColor(),
                        onTap: () => Get.to(() => const TransactionMoneyScreen(
                              fromEdit: false,
                              transactionType: TransactionType.requestMoney,
                            )),
                      )),
                    if (splashController
                        .configModel!.systemFeature!.sendMoneyRequestStatus!)
                      Expanded(
                        child: CustomCard(
                          image: Images.requestListImage2,
                          text: 'requests'.tr,
                          color: ColorResources.getReferFriendCardColor(),
                          onTap: () => Get.to(() =>
                              const RequestedMoneyListScreen(
                                  requestType: RequestType.request)),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const BannerView(),
          ],
        )),
      ]);
    });
  }
}

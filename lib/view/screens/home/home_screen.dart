import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/banner_controller.dart';
import 'package:zawadicash_app/controller/home_controller.dart';
import 'package:zawadicash_app/controller/notification_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/requested_money_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/controller/transaction_history_controller.dart';
import 'package:zawadicash_app/controller/websitelink_controller.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/view/screens/home/widget/app_bar_base.dart';
import 'package:zawadicash_app/view/screens/home/widget/bottom_sheet/expandable_contant.dart';
import 'package:zawadicash_app/view/screens/home/widget/bottom_sheet/persistent_header.dart';
import 'package:zawadicash_app/view/screens/home/widget/first_card_portion.dart';
import 'package:zawadicash_app/view/screens/home/widget/linked_website.dart';
import 'package:zawadicash_app/view/screens/home/widget/secend_card_portion.dart';
import 'package:zawadicash_app/view/screens/home/widget/shimmer/web_site_shimmer.dart';
import 'package:zawadicash_app/view/screens/home/widget/third_card_portion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true;
  Future<void> _loadData(BuildContext context, bool reload) async {
    Get.find<ProfileController>().profileData(reload: reload);
    Get.find<BannerController>().getBannerList(reload);
    Get.find<RequestedMoneyController>()
        .getRequestedMoneyList(1, reload: reload);
    Get.find<RequestedMoneyController>()
        .getOwnRequestedMoneyList(1, reload: reload);
    Get.find<TransactionHistoryController>()
        .getTransactionData(1, reload: reload);
    Get.find<WebsiteLinkController>().getWebsiteList();
    Get.find<NotificationController>().getNotificationList();
    Get.find<TransactionMoneyController>().getPurposeList();
    Get.find<TransactionMoneyController>().fetchContact();
    Get.find<TransactionMoneyController>().getWithdrawMethods(isReload: reload);
    Get.find<RequestedMoneyController>().getWithdrawHistoryList();
  }

  @override
  void initState() {
    _loadData(context, false);
    isFirst = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: const AppBarBase(),
        body: ExpandableBottomSheet(
            enableToggle: true,
            background: RefreshIndicator(
              onRefresh: () async {
                await _loadData(context, true);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child:
                    GetBuilder<SplashController>(builder: (splashController) {
                  return Column(
                    children: [
                      splashController.configModel.themeIndex == '1'
                          ? GetBuilder<ProfileController>(
                              builder: (profile) => const FirstCardPortion())
                          : splashController.configModel.themeIndex == '2'
                              ? const SecondCardPortion()
                              : splashController.configModel.themeIndex == '3'
                                  ? const ThirdCardPortion()
                                  : GetBuilder<ProfileController>(
                                      builder: (profile) =>
                                          const FirstCardPortion()),
                      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      GetBuilder<WebsiteLinkController>(
                          builder: (websiteLinkController) {
                        return websiteLinkController.isLoading
                            ? const WebSiteShimmer()
                            : websiteLinkController.websiteList.isNotEmpty
                                ? const LinkedWebsite()
                                : const SizedBox();
                      }),
                      const SizedBox(height: 80),
                    ],
                  );
                }),
              ),
            ),
            persistentContentHeight: 70,
            persistentHeader: const CustomPersistentHeader(),
            expandableContent: const CustomExpandableContant()),
      );
    });
  }
}

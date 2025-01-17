import 'package:zawadicash_app/controller/transaction_history_controller.dart';
import 'package:zawadicash_app/data/model/transaction_model.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/view/base/appbar_home_element.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/screens/history/widget/transaction_view_screen.dart';

class HistoryScreen extends StatelessWidget {
  static final ScrollController _scrollController = ScrollController();
  final Transactions? transactions;

  const HistoryScreen([Key? key, this.transactions]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>()).setIndex(0);
    return Scaffold(
      appBar: AppbarHomeElement(title: 'history'.tr),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .getTransactionData(1, reload: true);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_SMALL),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: GetBuilder<TransactionHistoryController>(
                      init: Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>()),
                      tag: getClassName<TransactionHistoryController>(),
                      builder: (historyController) {
                        return ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                left: Dimensions.PADDING_SIZE_SMALL),
                            scrollDirection: Axis.horizontal,
                            children: [
                              TransactionTypeButton(
                                  text: 'all'.tr,
                                  index: 0,
                                  transactionHistoryList:
                                      historyController.transactionList),
                              const SizedBox(width: 10),
                              TransactionTypeButton(
                                  text: 'send_money'.tr,
                                  index: 1,
                                  transactionHistoryList:
                                      historyController.sendMoneyList),
                              const SizedBox(width: 10),
                              TransactionTypeButton(
                                  text: 'cash_in'.tr,
                                  index: 2,
                                  transactionHistoryList:
                                      historyController.cashInMoneyList),
                              const SizedBox(width: 10),
                              TransactionTypeButton(
                                  text: 'add_money'.tr,
                                  index: 3,
                                  transactionHistoryList:
                                      historyController.addMoneyList),
                              const SizedBox(width: 10),
                              TransactionTypeButton(
                                  text: 'received_money'.tr,
                                  index: 4,
                                  transactionHistoryList:
                                      historyController.receivedMoneyList),
                              const SizedBox(width: 10),
                              TransactionTypeButton(
                                  text: 'cash_out'.tr,
                                  index: 5,
                                  transactionHistoryList:
                                      historyController.cashOutList),
                              const SizedBox(width: 10),
                              TransactionTypeButton(
                                  text: 'withdraw'.tr,
                                  index: 6,
                                  transactionHistoryList:
                                      historyController.withdrawList),
                              const SizedBox(width: 10),
                              TransactionTypeButton(
                                  text: 'payment'.tr,
                                  index: 7,
                                  transactionHistoryList:
                                      historyController.paymentList),
                              const SizedBox(width: 10),
                            ]);
                      },
                    ),
                  ))),
              SliverToBoxAdapter(
                child: Scrollbar(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: TransactionViewScreen(
                        scrollController: _scrollController, isHome: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionTypeButton extends StatelessWidget {
  final String text;
  final int index;
  final List<Transactions> transactionHistoryList;

  const TransactionTypeButton(
      {Key? key,
      required this.text,
      required this.index,
      required this.transactionHistoryList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color:
              Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>()).transactionTypeIndex ==
                      index
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_LARGE),
          border: Border.all(width: .5, color: ColorResources.getGreyColor())),
      child: CustomInkWell(
        onTap: () => Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>()).setIndex(index),
        radius: Dimensions.RADIUS_SIZE_LARGE,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Text(text,
              style: rubikRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  color: Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                              .transactionTypeIndex ==
                          index
                      ? ColorResources.blackColor
                      : Theme.of(context).textTheme.titleLarge!.color)),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

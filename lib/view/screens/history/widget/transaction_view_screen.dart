import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/transaction_history_controller.dart';
import 'package:zawadicash_app/data/model/transaction_model.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/no_data_screen.dart';
import 'package:zawadicash_app/view/screens/history/widget/history_shimmer.dart';

import 'transaction_history_card_view.dart';

class TransactionViewScreen extends StatelessWidget {
  final ScrollController? scrollController;
  final bool? isHome;
  final String? type;
  const TransactionViewScreen(
      {Key? key, this.scrollController, this.isHome, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryController>(
        init: Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>()),
        tag: getClassName<TransactionHistoryController>(),
        builder: (transactionHistory) {
      List<Transactions> transactionList = transactionHistory.transactionList;

      if (!isHome!) {
        transactionList = [];
        if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>()).transactionTypeIndex ==
            0) {
          transactionList = transactionHistory.transactionList;
        } else if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .transactionTypeIndex ==
            1) {
          transactionList = transactionHistory.sendMoneyList;
        } else if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .transactionTypeIndex ==
            2) {
          transactionList = transactionHistory.cashInMoneyList;
        } else if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .transactionTypeIndex ==
            3) {
          transactionList = transactionHistory.addMoneyList;
        } else if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .transactionTypeIndex ==
            4) {
          transactionList = transactionHistory.receivedMoneyList;
        } else if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .transactionTypeIndex ==
            5) {
          transactionList = transactionHistory.cashOutList;
        } else if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .transactionTypeIndex ==
            6) {
          transactionList = transactionHistory.withdrawList;
        } else if (Get.find<TransactionHistoryController>(tag: getClassName<TransactionHistoryController>())
                .transactionTypeIndex ==
            7) {
          transactionList = transactionHistory.paymentList;
        }
      }

      return Column(
        children: [
          !transactionHistory.firstLoading
              ? transactionList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactionList.length,
                          itemBuilder: (ctx, index) {
                            return TransactionHistoryCardView(
                                transactions: transactionList[index]);
                          }),
                    )
                  : NoDataFoundScreen(fromHome: isHome!)
              : const HistoryShimmer(),
          transactionHistory.isLoading
              ? Center(
                  child: Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                ))
              : const SizedBox.shrink(),
        ],
      );
    });
  }
}

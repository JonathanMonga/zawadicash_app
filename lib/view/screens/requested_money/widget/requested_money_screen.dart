// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawadicash_app/controller/requested_money_controller.dart';
import 'package:zawadicash_app/data/model/response/requested_money_model.dart';
import 'package:zawadicash_app/data/model/withdraw_history_model.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/base/no_data_screen.dart';
import 'package:zawadicash_app/view/screens/requested_money/requested_money_list_screen.dart';
import 'package:zawadicash_app/view/screens/requested_money/widget/requested_money_card.dart';

class RequestedMoneyScreen extends StatelessWidget {
  final ScrollController? scrollController;
  final bool? isHome;
  final RequestType? requestType;
  const RequestedMoneyScreen({
    Key? key,
    this.scrollController,
    this.isHome,
    this.requestType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController!.addListener(() {
      if (requestType != RequestType.withdraw &&
          scrollController!.position.maxScrollExtent ==
              scrollController!.position.pixels &&
          (requestType == RequestType.sendRequest
                  ? Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).ownRequestList.length
                  : Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>())
                      .requestedMoneyList
                      .length) !=
              0 &&
          !Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).isLoading) {
        int pageSize;
        pageSize = Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).pageSize;

        if (offset < pageSize) {
          offset++;
          debugPrint('end of the page');
          Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).showBottomLoader();
          if (requestType == RequestType.sendRequest) {
            Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>())
                .getOwnRequestedMoneyList(offset);
          } else {
            Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).getRequestedMoneyList(offset);
          }
        }
      }
    });
    return GetBuilder<RequestedMoneyController>(
        init: Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()),
        tag: getClassName<RequestedMoneyController>(),
        builder: (req) {
      List<RequestedMoney>? reqList;
      List<WithdrawHistory>? withdrawHistoryList;
      reqList = requestType == RequestType.sendRequest
          ? req.ownRequestList
          : req.requestedMoneyList;

      if (Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).requestTypeIndex == 0) {
        if (requestType == RequestType.withdraw) {
          withdrawHistoryList = req.pendingWithdraw;
        } else {
          reqList = requestType == RequestType.sendRequest
              ? req.ownPendingRequestedMoneyList
              : req.pendingRequestedMoneyList;
        }
      } else if (Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).requestTypeIndex == 1) {
        if (requestType == RequestType.withdraw) {
          withdrawHistoryList = req.acceptedWithdraw;
        } else {
          reqList = requestType == RequestType.sendRequest
              ? req.ownAcceptedRequestedMoneyList
              : req.acceptedRequestedMoneyList;
        }
      } else if (Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).requestTypeIndex == 2) {
        if (requestType == RequestType.withdraw) {
          withdrawHistoryList = req.deniedWithdraw;
        } else {
          reqList = requestType == RequestType.sendRequest
              ? req.ownDeniedRequestedMoneyList
              : req.deniedRequestedMoneyList;
        }
      } else {
        if (requestType == RequestType.withdraw) {
          withdrawHistoryList = req.allWithdraw;
        } else {
          reqList = requestType == RequestType.sendRequest
              ? req.ownRequestList
              : req.requestedMoneyList;
        }
      }
      return Column(children: [
        !req.isLoading
            ? (requestType == RequestType.withdraw
                    ? withdrawHistoryList!.isNotEmpty
                    : reqList.isNotEmpty)
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: isHome!
                            ? 1
                            : requestType == RequestType.withdraw
                                ? withdrawHistoryList!.length
                                : reqList.length,
                        itemBuilder: (ctx, index) {
                          return RequestedMoneyCard(
                            requestedMoney: requestType != RequestType.withdraw
                                ? reqList![index]
                                : null,
                            isHome: isHome,
                            requestType: requestType,
                            withdrawHistory: requestType == RequestType.withdraw
                                ? withdrawHistoryList![index]
                                : null,
                          );
                        }),
                  )
                : const NoDataFoundScreen()
            : RequestedMoneyShimmer(isHome: isHome!),
      ]);
    });
  }
}

class RequestedMoneyShimmer extends StatelessWidget {
  final bool? isHome;
  const RequestedMoneyShimmer({Key? key, this.isHome}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: isHome!
          ? 1
          : Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).requestedMoneyList.length,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          color: ColorResources.getGreyColor(),
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[100]!,
            enabled:
                Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).requestedMoneyList == null,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.notifications)),
              title: Container(height: 20, color: Colors.white),
              subtitle: Container(height: 10, width: 50, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}

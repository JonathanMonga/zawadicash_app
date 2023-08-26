import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/requested_money_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/screens/requested_money/widget/requested_money_screen.dart';

enum RequestType { sendRequest, request, withdraw }

class RequestedMoneyListScreen extends StatefulWidget {
  final RequestType requestType;

  const RequestedMoneyListScreen({Key? key, required this.requestType})
      : super(key: key);

  @override
  State<RequestedMoneyListScreen> createState() =>
      _RequestedMoneyListScreenState();
}

class _RequestedMoneyListScreenState extends State<RequestedMoneyListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).setIndex(0, isUpdate: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.requestType == RequestType.sendRequest
            ? 'send_requests'.tr
            : widget.requestType == RequestType.request
                ? 'requests'.tr
                : 'withdraw_history'.tr,
        onTap: () => Get.back(),
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: () async {
          if (widget.requestType == RequestType.sendRequest) {
            await Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>())
                .getOwnRequestedMoneyList(1, reload: true);
          } else if (widget.requestType == RequestType.request) {
            await Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>())
                .getRequestedMoneyList(1, reload: true);
          } else if (widget.requestType == RequestType.withdraw) {
            await Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>())
                .getWithdrawHistoryList(reload: true);
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverDelegate(
                  child: Container(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                height: 50,
                alignment: Alignment.centerLeft,
                child: GetBuilder<RequestedMoneyController>(
                  init: Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()),
                  tag: getClassName<RequestedMoneyController>(),
                  builder: (requestMoneyController) {
                    return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          RequestTypeButton(
                            text: 'pending'.tr,
                            index: 0,
                            length:
                                widget.requestType == RequestType.sendRequest
                                    ? requestMoneyController
                                        .ownPendingRequestedMoneyList.length
                                    : widget.requestType == RequestType.withdraw
                                        ? requestMoneyController
                                            .pendingWithdraw.length
                                        : requestMoneyController
                                            .pendingRequestedMoneyList.length,
                          ),
                          const SizedBox(width: 10),
                          RequestTypeButton(
                            text: 'accepted'.tr,
                            index: 1,
                            length:
                                widget.requestType == RequestType.sendRequest
                                    ? requestMoneyController
                                        .ownAcceptedRequestedMoneyList.length
                                    : widget.requestType == RequestType.withdraw
                                        ? requestMoneyController
                                            .acceptedWithdraw.length
                                        : requestMoneyController
                                            .acceptedRequestedMoneyList.length,
                          ),
                          const SizedBox(width: 10),
                          RequestTypeButton(
                            text: 'denied'.tr,
                            index: 2,
                            length:
                                widget.requestType == RequestType.sendRequest
                                    ? requestMoneyController
                                        .ownDeniedRequestedMoneyList.length
                                    : widget.requestType == RequestType.withdraw
                                        ? requestMoneyController
                                            .deniedWithdraw.length
                                        : requestMoneyController
                                            .deniedRequestedMoneyList.length,
                          ),
                          const SizedBox(width: 10),
                          RequestTypeButton(
                            text: 'all'.tr,
                            index: 3,
                            length: widget.requestType ==
                                    RequestType.sendRequest
                                ? requestMoneyController.ownRequestList.length
                                : widget.requestType == RequestType.withdraw
                                    ? requestMoneyController.allWithdraw.length
                                    : requestMoneyController
                                        .requestedMoneyList.length,
                          ),
                        ]);
                  },
                ),
              )),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: RequestedMoneyScreen(
                    scrollController: _scrollController,
                    isHome: false,
                    requestType: widget.requestType,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestTypeButton extends StatelessWidget {
  final String text;
  final int index;
  final int length;

  const RequestTypeButton(
      {Key? key, required this.text, required this.index, required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).setIndex(index),
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color:
                Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).requestTypeIndex == index
                    ? Theme.of(context).secondaryHeaderColor
                    : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(width: .5, color: ColorResources.getGreyColor())),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Text('$text($length)',
              style: rubikSemiBold.copyWith(
                  color:
                      Get.find<RequestedMoneyController>(tag: getClassName<RequestedMoneyController>()).requestTypeIndex ==
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

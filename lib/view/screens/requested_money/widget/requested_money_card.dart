import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/requested_money_controller.dart';
import 'package:zawadicash_app/data/model/response/requested_money_model.dart';
import 'package:zawadicash_app/data/model/withdraw_histroy_model.dart';
import 'package:zawadicash_app/helper/date_converter.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/animated_custom_dialog.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/screens/requested_money/requested_money_list_screen.dart';

import 'confirmation_dialog.dart';
class RequestedMoneyCard extends StatefulWidget {
  final RequestedMoney requestedMoney;
  final bool isHome;
  final RequestType requestType;
  final WithdrawHistory withdrawHistory;

  const RequestedMoneyCard({Key key, this.requestedMoney, this.isHome, this.requestType, this.withdrawHistory}) : super(key: key);

  @override
  State<RequestedMoneyCard> createState() => _RequestedMoneyCardState();
}

class _RequestedMoneyCardState extends State<RequestedMoneyCard> {
  final TextEditingController reqPasswordController = TextEditingController();
  final List<FieldItem> _itemList = [];

  @override
  void initState() {

    if(widget.requestType == RequestType.WITHDRAW) {
      widget.withdrawHistory.withdrawalMethodFields.forEach((key, value) {
        _itemList.add(FieldItem(key, value));
      });
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String name;
    String phoneNumber;
    if(widget.requestType != RequestType.WITHDRAW) {

      try{
        if(widget.requestType == RequestType.SEND_REQUEST) {
          name = widget.requestedMoney.receiver.name;
          phoneNumber = widget.requestedMoney.receiver.phone;
        }else{
          name = widget.requestedMoney.sender.name;
          phoneNumber = widget.requestedMoney.sender.phone;
        }
      }catch(e){
        name = 'user_unavailable'.tr;
        phoneNumber = 'user_unavailable'.tr;
      }
    }
    return widget.requestType == RequestType.WITHDRAW ? Card(
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.2)),
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: [
            _methodFieldView(type: 'withdraw_method'.tr, value: widget.withdrawHistory.methodName),
            const SizedBox(height: Dimensions.DIVIDER_SIZE_EXTRA_LARGE,),

            _methodFieldView(type: 'request_status'.tr, value: widget.withdrawHistory.requestStatus.tr),
            const SizedBox(height: Dimensions.DIVIDER_SIZE_EXTRA_LARGE,),

            _methodFieldView(type: 'amount'.tr, value: PriceConverter.balanceWithSymbol(balance: '${widget.withdrawHistory.amount}')),
          ],),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: _itemList.map((item) => Padding(
            padding: const EdgeInsets.all(3.0),
            child: _methodFieldView(type: item.key.replaceAll('_', ' ').capitalizeFirst, value: item.value),
          )).toList()),
        ),
      ],
      ),
    ) :
    !(name == 'user_unavailable'.tr && phoneNumber == 'user_unavailable'.tr) ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: rubikMedium.copyWith(color: ColorResources.getTextColor(),fontSize: Dimensions.FONT_SIZE_LARGE) ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                    Text(phoneNumber,style: rubikMedium.copyWith(color: ColorResources.getTextColor(),fontSize: Dimensions.FONT_SIZE_SMALL) ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                    Text('${'amount'.tr} - ${PriceConverter.balanceWithSymbol(balance: widget.requestedMoney.amount.toString())}',style: rubikMedium.copyWith(color: Theme.of(context).textTheme.titleLarge.color,fontSize: Dimensions.FONT_SIZE_DEFAULT) ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(widget.requestedMoney.createdAt)), style: rubikLight.copyWith(color: ColorResources.getTextColor(),fontSize: Dimensions.FONT_SIZE_SMALL) ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(
                      children: [
                        Text('${'note'.tr} - ', style: rubikSemiBold.copyWith(color: ColorResources.getTextColor(),fontSize: Dimensions.FONT_SIZE_LARGE)),
                        Text(widget.requestedMoney.note ?? 'no_note_available'.tr , maxLines: widget.isHome? 1:10,overflow: TextOverflow.ellipsis,style: rubikLight.copyWith(color: ColorResources.getHintColor(),fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      ],
                    ),
                  ]),
              const Spacer(),

              widget.requestedMoney.type == AppConstants.PENDING && widget.requestType == RequestType.REQUEST?
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE)), color: ColorResources.getAcceptBtn()
                    ),
                    child: CustomInkWell(
                        onTap: (){
                          showAnimatedDialog(context,
                              ConfirmationDialog(
                                  passController: reqPasswordController,
                                  icon: Images.success_icon,
                                  isAccept: true,
                                  description: '${'are_you_sure_want_to_accept'.tr} \n ${widget.requestedMoney.sender.name} \n ${widget.requestedMoney.sender.phone}',
                                  onYesPressed: () {
                                    Get.find<RequestedMoneyController>().acceptRequest(context, widget.requestedMoney.id, reqPasswordController.text.trim()).then((value) =>  Get.find<RequestedMoneyController>().getRequestedMoneyList(1));
                                  }
                              ),
                              dismissible: false,
                              isFlip: true);
                        },
                        radius: Dimensions.RADIUS_SIZE_EXTRA_LARGE,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Text('accept'.tr, style: const TextStyle(color: Colors.white)),
                        )),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE)), border: Border.all(width: 1,color: ColorResources.getRedColor())),
                    child: CustomInkWell(
                      onTap: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return ConfirmationDialog(icon: Images.failed_icon,
                              passController: reqPasswordController,
                              description: '${'are_you_sure_want_to_denied'.tr} \n ${widget.requestedMoney.sender.name} \n ${widget.requestedMoney.sender.phone}',
                              onYesPressed: () {
                                Get.find<RequestedMoneyController>().isLoading?
                                Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)):Get.find<RequestedMoneyController>().denyRequest(context, widget.requestedMoney.id,  reqPasswordController.text.trim());
                              }
                          );});
                        Get.find<RequestedMoneyController>().getRequestedMoneyList(1);
                      },
                      radius: Dimensions.RADIUS_SIZE_EXTRA_LARGE,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                        child: Text('deny'.tr ,style: TextStyle(color: ColorResources.getRedColor())),
                      ),
                    ),
                  ),
                ],):Text(widget.requestedMoney.type, style: rubikRegular.copyWith(color: ColorResources.getAcceptBtn()),)
            ],
          ),
          const SizedBox(height: 5),
          widget.isHome ? const SizedBox() : Divider(height: .5,color: ColorResources.getGreyColor()),
        ],
      ),
    ) : const SizedBox();
  }

  Widget _methodFieldView({@required String type,@required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(type, style: rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),

        Text(value),
      ],
    );
  }
}

class FieldItem{
  final String key;
  final String value;
  FieldItem(this.key, this.value);

}

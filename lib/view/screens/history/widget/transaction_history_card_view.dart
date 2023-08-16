import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/localization_controller.dart';
import 'package:zawadicash_app/data/model/transaction_model.dart';
import 'package:zawadicash_app/helper/date_converter.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/helper/transaction_type.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
class TransactionHistoryCardView extends StatelessWidget {
  final Transactions transactions;
  const TransactionHistoryCardView({Key key, this.transactions}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    String userPhone;
    String userName;
    bool isCredit = transactions.transactionType == AppConstants.SEND_MONEY
        || transactions.transactionType == AppConstants.WITHDRAW
        || transactions.transactionType == TransactionType.CASH_OUT;

    try{

      userPhone = transactions.transactionType == AppConstants.SEND_MONEY
          ? transactions.receiver.phone : transactions.transactionType == AppConstants.RECEIVED_MONEY
          ? transactions.sender.phone : transactions.transactionType == AppConstants.ADD_MONEY
          ? transactions.sender.phone : transactions.transactionType == AppConstants.CASH_IN
          ? transactions.sender.phone : transactions.transactionType == AppConstants.WITHDRAW
          ? transactions.receiver.phone : transactions.userInfo.phone;

      userName = transactions.transactionType == AppConstants.SEND_MONEY
          ? transactions.receiver.name : transactions.transactionType == AppConstants.RECEIVED_MONEY
          ? transactions.sender.name : transactions.transactionType == AppConstants.ADD_MONEY
          ? transactions.sender.name : transactions.transactionType == AppConstants.CASH_IN
          ? transactions.sender.name : transactions.transactionType == AppConstants.WITHDRAW
          ? transactions.receiver.name : transactions.userInfo.name;
    }catch(e){
     userPhone = 'no_user'.tr;
     userName = 'no_user'.tr;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Stack(
        children: [
         Column(
          children: [
            Row(
              children: [

                Container(
                  height: 50,width: 50,
                  padding: const EdgeInsets.all(8.0),
                  child: transactions.transactionType == null
                      ? const SizedBox()
                      : Image.asset(Images.getTransactionImage(transactions.transactionType)),
                ),

                const SizedBox(width: 5,),

                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactions.transactionType.tr,
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text(
                        userName ?? '',
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        ),
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text(userPhone ?? '', style: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                      ),),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text(
                        'TrxID: ${transactions.transactionId}',
                        style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      ),

                    ]),
                const Spacer(),

                Text(
                  '${isCredit ? '-' : '+'} ${PriceConverter.convertPrice(double.parse(transactions.amount.toString()))}',
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: isCredit ? Colors.redAccent : Colors.green,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 5),

            Divider(height: .125,color: ColorResources.getGreyColor()),
          ],
        ),

          Get.find<LocalizationController>().isLtr ?  Positioned(
            bottom:  3 ,
              right: 2,
              child: Text(
                DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  color: ColorResources.getHintColor(),
                ),
              ),
          ) :
          Positioned(
            bottom:  3 ,
            left: 2,
            child: Text(
              DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),
              style: rubikRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                color: ColorResources.getHintColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


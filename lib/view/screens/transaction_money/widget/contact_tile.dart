
import 'package:flutter/material.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';

class ContactTile extends StatelessWidget {
  final TransactionMoneyController transactionMoneyController;
  final int index;
  const ContactTile({Key? key, required this.transactionMoneyController, required this.index}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Row(children: [ Padding(padding: const EdgeInsets.symmetric( horizontal: Dimensions.paddingSizeDefault),
          child: transactionMoneyController.filterdContacts[index].contact!.thumbnail != null ?
          CircleAvatar(backgroundImage: MemoryImage(transactionMoneyController.filterdContacts[index].contact!.thumbnail!)) :
          transactionMoneyController.filterdContacts[index].contact!.displayName == '' ? const CircleAvatar() :
          CircleAvatar(child:  Text(transactionMoneyController.filterdContacts[index].contact!.displayName[0].toUpperCase())),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transactionMoneyController.filterdContacts[index].contact!.displayName,
              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),

            transactionMoneyController.filterdContacts[index].contact!.phones.isEmpty ? const SizedBox() :
            Text(transactionMoneyController.filterdContacts[index].contact!.phones.first.number,
              style: rubikLight.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.getGreyBaseGray1()),
            ),
          ],
        ),

      ],),
    );
  }
}




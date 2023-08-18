import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zawadicash_app/data/model/response/contact_model.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/preview_contact_tile.dart';

class ForPersonWidget extends StatelessWidget {
  final ContactModel? contactModel;
  const ForPersonWidget({
    Key? key,
    this.contactModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.getBackgroundColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: Dimensions.PADDING_SIZE_DEFAULT,
                left: Dimensions.PADDING_SIZE_LARGE,
                right: Dimensions.PADDING_SIZE_LARGE),
            child: Text('for_person'.tr,
                style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    color: ColorResources.getGreyBaseGray1())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: PreviewContactTile(contactModel: contactModel!)),
            ],
          ),
          Container(
              height: Dimensions.DIVIDER_SIZE_MEDIUM,
              color: Theme.of(context).colorScheme.background),
        ],
      ),
    );
  }
}

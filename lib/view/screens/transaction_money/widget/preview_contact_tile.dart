import 'package:zawadicash_app/data/model/response/contact_model.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:flutter/material.dart';

class PreviewContactTile extends StatelessWidget {
  final ContactModel? contactModel;
  const PreviewContactTile({
    Key? key,
    required this.contactModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneNumber = contactModel!.phoneNumber!;
    if (phoneNumber.contains('-')) {
      phoneNumber.replaceAll('-', '');
    }

    return ListTile(
      title: Text(contactModel!.name ?? phoneNumber,
          style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      subtitle: phoneNumber.isEmpty
          ? const SizedBox()
          : Text(
              phoneNumber,
              style: rubikLight.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: ColorResources.getGreyBaseGray1()),
            ),
    );
  }
}

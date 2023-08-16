
import 'package:zawadicash_app/controller/create_account_controller.dart';
import 'package:zawadicash_app/controller/verification_controller.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InformationSection extends StatelessWidget {
  const InformationSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomLogo(
          height: Dimensions.BIG_LOGO,
          width: Dimensions.BIG_LOGO,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.PADDING_SIZE_LARGE),
          child: Text(
            'phone_number_verification'.tr,
            style: rubikMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge.color,
              fontSize: Dimensions.FONT_SIZE_EXTRA_OVER_LARGE,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE),
          child: Text(
            'we_have_send_the_code'.tr,
            style: rubikLight.copyWith(
              color: Theme.of(context).textTheme.bodyLarge.color,
              fontSize: Dimensions.FONT_SIZE_LARGE,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
        ),
        GetBuilder<CreateAccountController>(builder: (controller)=>Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.phoneNumber,
              style: rubikRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge.color,
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            InkWell(
              // onTap: ()=> Get.back(),
              onTap: (){
                Get.back();
                Get.find<VerificationController>().cancelTimer();
                Get.find<VerificationController>().setVisibility(false);


                // Get.offNamed(RouteHelper.getRegistrationRoute(phoneNumber: controller.phoneNumber.substring(4)));

              },
              child: Text(
                '(${'change_number'.tr})',
                style: rubikRegular.copyWith(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).textTheme.bodyLarge.color,
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),),
      ],
    );
  }
}

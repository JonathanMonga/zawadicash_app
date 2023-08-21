import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/screen_shot_widget_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zawadicash_app/view/base/custom_small_button.dart';

class ProfileQRCodeBottomSheet extends StatelessWidget {
  const ProfileQRCodeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.getWhiteAndBlack(),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.RADIUS_SIZE_LARGE),
            topRight: Radius.circular(Dimensions.RADIUS_SIZE_LARGE)),
        boxShadow: [
          BoxShadow(
              color: ColorResources.getBlackAndWhite().withOpacity(0.5),
              blurRadius: 80,
              offset: const Offset(0, 20)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 8.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                height: 4.0,
                width: 32.0,
                decoration: BoxDecoration(
                    color: ColorResources.getGreyBaseGray3(),
                    borderRadius: BorderRadius.circular(32.0)))
          ]),
          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          Padding(
            padding: const EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_LARGE,
                bottom: Dimensions.PADDING_SIZE_SMALL),
            child: Text('my_qr_code'.tr,
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: ColorResources.getBlackAndWhite().withOpacity(0.6),
                )),
          ),
          GetBuilder<ProfileController>(
              init: Get.find<ProfileController>(tag: getClassName<ProfileController>()),
              tag: getClassName<ProfileController>(),
              builder: (controller) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(50.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).secondaryHeaderColor),
                child: SvgPicture.string(controller.userInfo.qrCode!,
                    height: size.width * 0.4, width: size.width * 0.4),
              ),
            );
          }),
          const SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomSmallButton(
                    text: 'download'.tr,
                    textSize: Dimensions.FONT_SIZE_LARGE,
                    textColor: Theme.of(context).textTheme.bodyLarge!.color!,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    onTap: () => Get.find<ScreenShootWidgetController>(tag: getClassName<ScreenShootWidgetController>())
                        .qrCodeDownloadAndShare(
                            qrCode:
                                Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.qrCode!,
                            phoneNumber:
                                Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.phone!,
                            isShare: false),
                  ),
                  /*child: Container(
                  alignment: Alignment.center,

                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),color: Theme.of(context).secondaryHeaderColor),
                  child: CustomInkWell(
                    onTap: () => Get.find<ScreenShootWidgetController>(tag: getClassName<ScreenShootWidgetController>()).qrCodeDownloadAndShare(qrCode: Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.qrCode, phoneNumber: Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.phone,isShare: false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric( vertical: 14.0),
                      child: Text('download'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                    ),
                  ),
                ),*/
                ),
                const SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                Expanded(
                  child: CustomSmallButton(
                    text: 'share_QR_code'.tr,
                    textSize: Dimensions.FONT_SIZE_LARGE,
                    textColor: Theme.of(context).cardColor,
                    backgroundColor:
                        Theme.of(context).textTheme.titleLarge!.color!,
                    onTap: () => Get.find<ScreenShootWidgetController>(tag: getClassName<ScreenShootWidgetController>())
                        .qrCodeDownloadAndShare(
                            qrCode:
                                Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.qrCode!,
                            phoneNumber:
                                Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.phone!,
                            isShare: true),
                  ),
                  /*child: InkWell(
                  onTap: (){
                    Get.find<ScreenShootWidgetController>(tag: getClassName<ScreenShootWidgetController>()).qrCodeDownloadAndShare(qrCode: Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.qrCode, phoneNumber: Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.phone,isShare: true);

                    },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),color: Theme.of(context).primaryColor),
                    child: CustomInkWell(
                      onTap: ()=> Get.find<ScreenShootWidgetController>(tag: getClassName<ScreenShootWidgetController>()).qrCodeDownloadAndShare(qrCode: Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.qrCode, phoneNumber: Get.find<ProfileController>(tag: getClassName<ProfileController>()).userInfo.phone,isShare: true),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 14.0),
                        child: Text('share_QR_code'.tr,maxLines: 1, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,color: Colors.white),),
                      ),
                    ),
                  ),
                ),*/
                ),
              ],
            ),
          ),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

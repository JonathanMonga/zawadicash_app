import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/data/model/response/notification_model.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';

class NotificationDialog extends StatelessWidget {
  final Notifications notificationModel;
  const NotificationDialog({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width - 130,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_LARGE),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor.withOpacity(0.20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomImage(
                placeholder: Images.placeholder,
                image:
                    '${Get.find<SplashController>(tag: getClassName<SplashController>()).configModel.baseUrls!.notificationImageUrl}/${notificationModel.image}',
                height: MediaQuery.of(context).size.width - 130,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Text(notificationModel.title!,
                  textAlign: TextAlign.center,
                  style: rubikMedium.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(notificationModel.description!,
                  textAlign: TextAlign.center, style: rubikRegular)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/home_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/util/get_class_name.dart';
import 'package:zawadicash_app/view/screens/home/widget/animated_card/custom_rect_tween.dart';

class QrPopupCard extends StatelessWidget {
  const QrPopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: Get.find<HomeController>(tag: getClassName<HomeController>()).heroShowQr,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GetBuilder<ProfileController>(
                  init: Get.find<ProfileController>(tag: getClassName<ProfileController>()),
                  tag: getClassName<ProfileController>(),
                  builder: (controller) {
                    return SizedBox(
                      child: SvgPicture.string(
                        controller.userInfo!.qrCode!,
                        fit: BoxFit.contain,
                        width: size.width * 0.8,
                      ),
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}

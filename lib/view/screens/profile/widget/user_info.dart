import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/data/model/response/user_info.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/screens/kyc_verify/kyc_verify_screen.dart';
import 'package:zawadicash_app/view/screens/profile/widget/bootom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:zawadicash_app/view/screens/profile/widget/profile_shimmer.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) => profileController.isLoading
          ? const ProfileShimmer()
          : Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_LARGE,
                vertical: Dimensions.PADDING_SIZE_LARGE,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      profileController.userInfo != null
                          ? Row(
                              children: [
                                Container(
                                  width: Dimensions.SIZE_PROFILE_AVATAR,
                                  height: Dimensions.SIZE_PROFILE_AVATAR,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.RADIUS_PROFILE_AVATAR)),
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Theme.of(context).highlightColor),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.RADIUS_PROFILE_AVATAR)),
                                    child: CustomImage(
                                      fit: BoxFit.cover,
                                      image:
                                          "${Get.find<SplashController>().configModel.baseUrls!.customerImageUrl}/${profileController.userInfo.image}",
                                      placeholder: Images.avatar,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: Dimensions.PADDING_SIZE_SMALL),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${profileController.userInfo.fName} ${profileController.userInfo.lName}',
                                        style: rubikMedium.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                          fontSize: Dimensions.FONT_SIZE_LARGE,
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        profileController.userInfo.phone!,
                                        style: rubikMedium.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withOpacity(
                                                  Get.isDarkMode ? 0.8 : 0.5),
                                          fontSize: Dimensions.FONT_SIZE_LARGE,
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(),
                      InkWell(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                    Dimensions.RADIUS_SIZE_LARGE)),
                          ),
                          builder: (context) =>
                              const ProfileQRCodeBottomSheet(),
                        ),
                        child: GetBuilder<ProfileController>(
                            builder: (controller) {
                          return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).secondaryHeaderColor),
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.string(
                              controller.userInfo.qrCode!,
                              height: 24,
                              width: 24,
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  if (profileController.userInfo.kycStatus !=
                      KycVerification.approve)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            profileController.userInfo.kycStatus ==
                                    KycVerification.needApply
                                ? 'kyc_verification_is_not'.tr
                                : profileController.userInfo.kycStatus ==
                                        KycVerification.pending
                                    ? 'your_verification_request_is'.tr
                                    : 'your_verification_is_denied'.tr,
                            style: rubikRegular.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          width: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        CustomInkWell(
                          onTap: () => Get.to(() => const KycVerifyScreen()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              color: Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withOpacity(0.8),
                            ),
                            child: Text(
                              profileController.userInfo.kycStatus ==
                                      KycVerification.needApply
                                  ? 'click_to_verify'.tr
                                  : profileController.userInfo.kycStatus ==
                                          KycVerification.pending
                                      ? 'edit'.tr
                                      : 're_apply'.tr,
                              style: rubikMedium.copyWith(
                                  color: Theme.of(context).cardColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}

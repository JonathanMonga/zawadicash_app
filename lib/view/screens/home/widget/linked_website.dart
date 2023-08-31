import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/websitelink_controller.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/screens/add_money/web_screen.dart';
import 'package:zawadicash_app/view/screens/home/widget/shimmer/web_site_shimmer.dart';

class LinkedWebsite extends StatelessWidget {
  const LinkedWebsite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        return splashController.configModel!.systemFeature!.linkedWebSiteStatus! ?
        GetBuilder<WebsiteLinkController>(builder: (websiteLinkController){
          return websiteLinkController.isLoading ?
          const WebSiteShimmer() : websiteLinkController.websiteList!.isEmpty ?
          const SizedBox() :  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  'linked_website'.tr, style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),),
              ),


              Container(
                height: 86,
                width: double.infinity,
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(
                    color: ColorResources.containerShedow.withOpacity(0.05),
                    blurRadius: 20, offset: const Offset(0, 3),
                  )],
                ),
                child: ListView.builder(
                  itemCount: websiteLinkController.websiteList!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomInkWell(
                      onTap: () => Get.to(WebScreen(selectedUrl: websiteLinkController.websiteList![index].url!)),
                      radius: Dimensions.radiusSizeExtraSmall,
                      highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Container(width: 100,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                        child: Column(
                          children: [
                            SizedBox(width: 50, height: 30,
                              child: CustomImage(
                                image: "${Get.find<SplashController>().configModel!.baseUrls!.linkedWebsiteImageUrl
                                }/${websiteLinkController.websiteList![index].image}",
                                placeholder: Images.webLinkPlaceHolder, fit: BoxFit.cover,
                              ),
                            ),

                            const Spacer(),
                            Text(
                              websiteLinkController.websiteList![index].name!,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: ColorResources.getWebsiteTextColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: Dimensions.paddingSizeSmall ,
              ),
            ],
          );
        }
        ) : const SizedBox();
      }
    );
  }
}

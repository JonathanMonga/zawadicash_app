import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zawadicash_app/controller/banner_controller.dart';
import 'package:zawadicash_app/controller/home_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';
import 'package:zawadicash_app/view/screens/add_money/web_screen.dart';
import 'package:zawadicash_app/view/screens/home/widget/shimmer/banner_shimmer.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GetBuilder<SplashController>(builder: (splashController) {
      return splashController.configModel!.systemFeature!.bannerStatus!
          ? GetBuilder<BannerController>(builder: (controller) {
              return controller.bannerList == null
                  ? const Center(child: BannerShimmer())
                  : controller.bannerList!.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeLarge),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: size.width / 3.5,
                                width: size.width,
                                child: CarouselSlider.builder(
                                  itemCount: controller.bannerList!.length,
                                  itemBuilder: (context, index, realIndex) {
                                    final image = controller
                                            .bannerList!.isNotEmpty
                                        ? controller.bannerList![index].image
                                        : '';
                                    return InkWell(
                                      onTap: () {
                                        if (controller.bannerList!.isNotEmpty) {
                                          Get.to(WebScreen(
                                              selectedUrl: controller
                                                  .bannerList![index].url!));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .radiusSizeDefault)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CustomImage(
                                                image:
                                                    "${Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl}/$image",
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    Images.bannerPlaceHolder),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 4),
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      Get.find<HomeController>()
                                          .indicateIndex(index);
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedSmoothIndicator(
                                    activeIndex: Get.find<HomeController>()
                                        .activeIndicator,
                                    count: Get.find<BannerController>()
                                        .bannerList!
                                        .length,
                                    effect: CustomizableEffect(
                                      dotDecoration: DotDecoration(
                                        height: 5,
                                        width: 5,
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white.withOpacity(0.37),
                                      ),
                                      activeDotDecoration: const DotDecoration(
                                        height: 7,
                                        width: 7,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
            })
          : const SizedBox();
    });
  }
}

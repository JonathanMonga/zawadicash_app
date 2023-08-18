import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawadicash_app/util/dimensions.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[350]!,
          highlightColor: Colors.grey[200]!,
          child: Container(
            margin:
                const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.black26,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                    height: Dimensions.NOTIFICATION_IMAGE_SIZE,
                    width: Dimensions.NOTIFICATION_IMAGE_SIZE,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          Dimensions.RADIUS_SIZE_EXTRA_SMALL),
                      child: Container(
                        color: Colors.black45,
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}

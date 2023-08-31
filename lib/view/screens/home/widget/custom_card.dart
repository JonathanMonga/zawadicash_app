import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
class CustomCard extends StatelessWidget {
  final String? image;
  final String? text;
  final VoidCallback? onTap;
  final Color? color;
   const CustomCard({Key? key, this.image, this.text, this.onTap, this.color}) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
     return Container(
       margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
       decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault), color: color,
         boxShadow: [BoxShadow(color: ColorResources.getWhiteAndBlack().withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 4))]),


       child: CustomInkWell(
         onTap: onTap,
         radius: Dimensions.radiusSizeDefault,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             const SizedBox(height: Dimensions.paddingSizeDefault),
             Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
               decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.7)),
               child: SizedBox(height: 25, width: 25,
                 child: Image.asset(image!, fit: BoxFit.contain))),
             const SizedBox(height: 10),



             Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall+1),
               child: Text(text!, textAlign: TextAlign.center, maxLines: 2, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),),
             )
           ],
         ),
       ),
     );
  }
}
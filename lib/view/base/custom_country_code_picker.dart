import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/helper/functions.dart';
import 'package:zawadicash_app/util/get_class_name.dart';

class CustomCountryCodePiker extends StatelessWidget {
  final OnChangedFunction? onChanged;
  final OnInitFunction? onInit;
  final String? initSelect;

  const CustomCountryCodePiker(
      {Key? key, required this.onChanged, this.initSelect, this.onInit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      dialogBackgroundColor: Theme.of(context).canvasColor,
      padding: EdgeInsets.zero,
      onChanged: onChanged!,
      onInit: onInit,
      showDropDownButton: true,
      initialSelection: initSelect ??
          Get.find<SplashController>(tag: getClassName<SplashController>())
              .configModel
              .country,
      favorite: const [
        '+243',
        '+1',
        '+260',
        '+255',
        '+244',
        '+263',
        '+257',
        '+257',
        '+250',
        '+256',
        '+211',
        '+236',
        '+242',
        '+241',
        '+237'
      ],
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      showFlag: false,
    );
  }
}

String getCountryCode(String number) {
  String? countryCode = '';
  try {
    countryCode = codes.firstWhere(
        (item) => number.contains('${item['dial_code']}'))['dial_code'];
  } catch (error) {
    debugPrint('country error: $error');
  }
  return countryCode!;
}

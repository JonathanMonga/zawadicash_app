import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zawadicash_app/components/c_elevated_button.dart';
import 'package:zawadicash_app/utils/constants.dart';

import 'package:zawadicash_app/utils/routes.dart';

class RegisterFingerprintUnlockPage extends StatefulWidget {
  const RegisterFingerprintUnlockPage({super.key});

  @override
  State<RegisterFingerprintUnlockPage> createState() =>
      _RegisterFingerprintUnlockPageState();
}

class _RegisterFingerprintUnlockPageState
    extends State<RegisterFingerprintUnlockPage> {
  bool success = false;
  bool failed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: REdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.r,
                  color: primaryColor,
                ),
              ),
              Text(
                'Step 3 of 4',
                style: smallTextStyle,
              )
            ],
          ),
          SizedBox(
            height: 136.h,
          ),
          Column(
            children: [
              Text(
                'Biometric Security',
                style: largeTextStyle,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'For more advanced security, register your fingerprint and\nface unlock',
                style: xSmallTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 47.h,
              ),
              success
                  ? SvgPicture.asset(
                      'assets/svg/fingerprint_unlock_success.svg')
                  : failed
                      ? SvgPicture.asset(
                          'assets/svg/fingerprint_unlock_failed.svg')
                      : CircularPercentIndicator(
                          radius: 90.r,
                          lineWidth: 4.w,
                          percent: 0.5,
                          reverse: true,
                          backgroundColor: const Color(0xFFFFF9EF),
                          center: SvgPicture.asset(
                              'assets/svg/fingerprint_icon.svg'),
                          progressColor: const Color(0xFFFCC97C),
                        ),
              SizedBox(
                height: 40.h,
              ),
              success
                  ? Text(
                      'Registration is successful, you can proceed\nto the next step',
                      style: xSmallTextStyle,
                      textAlign: TextAlign.center,
                    )
                  : failed
                      ? Text(
                          'Registration failed, try again or try to clean\nyour finger',
                          style: xSmallTextStyle,
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'Put your finger on the sensor and register\nyour fingerprint data',
                          style: xSmallTextStyle,
                          textAlign: TextAlign.center,
                        ),
              SizedBox(
                height: 143.h,
              ),
              SizedBox(
                width: double.infinity,
                child: CElevatedButton(
                    child:
                        failed ? const Text('Retry') : const Text('Continue'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RouteGenerator.registerFaceUnlockPage,
                      );
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
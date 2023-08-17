import 'dart:async';
import 'package:zawadicash_app/data/repository/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController implements GetxService {
  late final AuthRepo authRepo;
  VerificationController({required this.authRepo});
  int maxSecond = 30;
  late Timer _timer;
  bool _visibility = false;
  bool get visibility => _visibility;
  Timer get timer => _timer;

  void cancelTimer() {
    _timer.cancel();
    // update();
  }

  setVisibility(bool b) {
    _visibility = b;
    maxSecond = 30;
    update();
  }

  // otp
  late String _otp;
  String get otp => _otp;
  setOtp(String pin) {
    debugPrint('set is working..... $pin');
    _otp = pin;
    debugPrint('is set otp$_otp');
    //update();
  }

  startTimer() {
    maxSecond = 30;
    update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (maxSecond > 0) {
        maxSecond = maxSecond - 1;
        debugPrint(maxSecond.toString());
        _visibility = false;
      } else {
        _visibility = true;
        _timer.cancel();
      }
      update();
    });
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/repository/kyc_verify_repo.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/data/api/api_client.dart';

class KycVerifyController extends GetxController implements GetxService {
  final KycVerifyRepo kycVerifyRepo;
  KycVerifyController({required this.kycVerifyRepo});
  late List<XFile> _imageFile;
  late List<XFile> _identityImage = [];
  List<XFile> get identityImage => _identityImage;

  late bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<String> _dropList = [
    'select_identity_type'.tr,
    'passport'.tr,
    'driving_licence'.tr,
    'nid'.tr,
    'trade_license'.tr,
  ];
  List<String> get dropList => _dropList;

  String _dropDownSelectedValue = 'select_identity_type'.tr;
  String get dropDownSelectedValue => _dropDownSelectedValue;

  void dropDownChange(String value) {
    _dropDownSelectedValue = value;
    update();
  }

  void initialSelect() {
    _dropDownSelectedValue = 'select_identity_type'.tr;
    _identityImage = [];
    _isLoading = false;
  }

  void pickImage(bool isRemove) async {
    final ImagePicker _picker = ImagePicker();
    if (isRemove) {
      _imageFile = [];
    } else {
      _imageFile = await _picker.pickMultiImage(imageQuality: 30);
      _identityImage.addAll(_imageFile);
    }
    update();
  }

  void removeImage(int index) {
    _identityImage.removeAt(index);
    update();
  }

  late List<MultipartBody> _multipartBody;

  Future<void> kycVerify(String idNumber) async {
    Map<String, String> _field = {
      'identification_number': idNumber,
      'identification_type': _dropDownSelectedValue == 'passport'.tr
          ? 'passport'
          : _dropDownSelectedValue == 'driving_licence'.tr
              ? 'driving_licence'
              : _dropDownSelectedValue == 'nid'.tr
                  ? 'nid'
                  : _dropDownSelectedValue == 'trade_license'.tr
                      ? 'trade_license'
                      : 'select_identity_type',
      '_method': 'put'
    };
    _multipartBody = _identityImage
        .map((image) =>
            MultipartBody('identification_image[]', File(image.path)))
        .toList();
    _isLoading = true;
    update();
    Response response =
        await kycVerifyRepo.kycVerifyApi(_field, _multipartBody);
    if (response.body['response_code'] == 'default_update_200') {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    debugPrint('body is : ${response.body}');
    _isLoading = false;
    update();
  }
}

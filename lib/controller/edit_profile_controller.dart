import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/camera_screen_controller.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/data/model/body/edit_profile_body.dart';
import 'package:zawadicash_app/data/model/response/response_model.dart';
import 'package:zawadicash_app/data/repository/auth_repo.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController implements GetxService{
  final AuthRepo authRepo;
  EditProfileController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _image ;
  String get image => _image;
  setImage(String image){
    _image = image;
  }

  ///gender
  String _gender;
  String get gender => _gender;

  setGender(String select){
    _gender = select;
    update();
    debugPrint(_gender);
  }

  ///occupation
  String _occupation ;
  String get occupation => _occupation;

  Future<bool> updateProfileData(EditProfileBody editProfileBody,List<MultipartBody> multipartBody) async{
    _isLoading = true;
    bool emailValidation = true;
    bool isSuccess = false;
    update();
    Map<String, String> allProfileInfo = {
      'f_name': editProfileBody.fName,
      'l_name': editProfileBody.lName,
      'gender': editProfileBody.gender,
      'occupation': editProfileBody.occupation,
      '_method': 'put',
    };
    if(editProfileBody.email != '') {
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(editProfileBody.email);

      if(emailValid){
        allProfileInfo.addAll({'email': editProfileBody.email});
      }else{
        emailValidation = emailValid;
      }
    }

    if(!emailValidation) {
      showCustomSnackBar('please_provide_valid_email'.tr);
      _isLoading = false;
      update();
    }else {
      Response response = await authRepo.updateProfile(allProfileInfo, multipartBody);
      ResponseModel responseModel;
      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, response.body['message']);
        isSuccess = true;
        Get.find<CameraScreenController>().removeImage();
        Get.find<ProfileController>().profileData(reload: true, isUpdate: true);
        Get.back();
        debugPrint(responseModel.message);
        showCustomSnackBar(responseModel.message, isError: false);
      }
      else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
    return isSuccess;
  }
}
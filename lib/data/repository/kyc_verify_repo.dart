import 'package:get/get_connect/http/src/response/response.dart';
import 'package:zawadicash_app/data/api/api_client.dart';
import 'package:zawadicash_app/util/app_constants.dart';

class KycVerifyRepo {
  final ApiClient apiClient;
  KycVerifyRepo({required this.apiClient});

  Future<Response> kycVerifyApi(
      Map<String, String> field, List<MultipartBody>? multipartBody) async {
    return await apiClient.postMultipartData(
        AppConstants.updateKycInformation, field, multipartBody);
  }
}

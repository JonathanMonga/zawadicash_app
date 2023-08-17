import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/model/BannerModel.dart';
import 'package:zawadicash_app/data/repository/banner_repo.dart';
import 'package:get/get.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late List<BannerModel> _bannerList;
  List<BannerModel> get bannerList => _bannerList;

  Future getBannerList(bool reload) async {
    if (reload) {
      _isLoading = true;

      Response response = await bannerRepo.getBannerList();
      if (response.statusCode == 200) {
        _bannerList = [];
        response.body.forEach((banner) {
          _bannerList.add(BannerModel.fromJson(banner));
        });
        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
    }
    update();
  }
}
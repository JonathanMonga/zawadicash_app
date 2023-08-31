import 'package:get/get.dart';
import 'package:zawadicash_app/data/api/api_checker.dart';
import 'package:zawadicash_app/data/model/response/notification_model.dart';
import 'package:zawadicash_app/data/repository/notification_repo.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Notifications>? _notificationList;
  List<Notifications>? get notificationList => _notificationList;

  Future getNotificationList(bool reload, {bool isUpdate = true}) async {
    if (reload || _notificationList == null) {
      _notificationList = null;
      _isLoading = true;
      if (isUpdate) {
        update();
      }
    }
    if (_notificationList == null) {
      Response response = await notificationRepo.getNotificationList();
      if (response.body != null &&
          response.body != {} &&
          response.statusCode == 200) {
        _notificationList = [];
        response.body['notifications'].forEach((notify) {
          _notificationList!.add(Notifications.fromJson(notify));
        });
      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
  }
}

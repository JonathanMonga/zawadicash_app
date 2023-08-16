import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/add_money_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/view/base/animated_custom_dialog.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_loader.dart';
import 'package:zawadicash_app/view/base/my_dialog.dart';
import 'package:zawadicash_app/view/screens/deshboard/nav_bar_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();
    selectedUrl = Get.find<AddMoneyController>().addMoneyWebLink;

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>_exitApp(context),
      child: Scaffold(
        backgroundColor: ColorResources.getBackgroundColor(),
        appBar: CustomAppbar(title: 'add_money'.tr),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: selectedUrl,
                    gestureNavigationEnabled: true,
                    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.future.then((value) => controllerGlobal = value);
                      _controller.complete(webViewController);
                    },
                    onPageStarted: (String url) {
                      if(url.contains(AppConstants.BASE_URL)) {
                        bool isSuccess = url.contains('success');
                        bool isFailed = url.contains('fail');
                        print('Page started loading: $url');
                        setState(() {
                          _isLoading = true;
                        });
                        if (isSuccess) {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const NavBarScreen()), (route) => false);
                          Get.find<ProfileController>().profileData(reload:true);
                          showAnimatedDialog(context, MyDialog(
                            icon: Icons.done,
                            title: 'payment_done'.tr,
                            description: 'your_payment_successfully_done'.tr,
                          ), dismissible: false, isFlip: true);
                        } else if (isFailed) {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const NavBarScreen()), (route) => false);
                          showAnimatedDialog(context, MyDialog(
                            icon: Icons.clear,
                            title: 'payment_failed'.tr,
                            description: 'your_payment_failed'.tr,
                            isFailed: true,
                          ), dismissible: false, isFlip: true);
                        } else if (url == '${AppConstants.BASE_URL}/cancel') {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const NavBarScreen()), (route) => false);
                          showAnimatedDialog(context, MyDialog(
                            icon: Icons.clear,
                            title: 'payment_cancelled'.tr,
                            description: 'your_payment_cancelled'.tr,
                            isFailed: true,
                          ), dismissible: false, isFlip: true);
                        }
                      }
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),

                  _isLoading ? Center(
                    child: CustomLoader(color: Theme.of(context).primaryColor),
                  ) : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const NavBarScreen()), (route) => false);
      showAnimatedDialog(context, MyDialog(
        icon: Icons.clear,
        title: 'payment_cancelled'.tr,
        description: 'your_payment_cancelled'.tr,
        isFailed: true,
      ), dismissible: false, isFlip: true);
      return Future.value(true);
    }
  }
}

import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppLinksDeepLink extends GetxController {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance =
      AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void onInit() {
    _appLinks = AppLinks();
    initDeepLinks();
    super.onInit();
  }

  Future<void> initDeepLinks() async {
    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks!.getInitialLink();
    if (appLink != null) {
      var uri = Uri.parse(appLink.toString());
      log(' here you can redirect from url as per your need $uri ');
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks!.uriLinkStream.listen(
      (uriValue) {
        log(' you will listen any url updates ');
        log(' here you can redirect from url as per your need ');
      },
      onError: (err) {
        debugPrint('====>>> error : $err');
      },
      onDone: () {
        _linkSubscription?.cancel();
      },
    );
  }
}

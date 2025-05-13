import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:simone/src/repository/authentication_repository/authentication_repository.dart';

class MailVerificationController extends GetxController {
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    //setTimerForAutoRedirect();
  }

  Future<void> sendVerificationEmail() async {
    await AuthenticationRepository.instance.sendEmailVerification();
  }

  void setTimerForAutoRedirect() {
    timer = Timer.periodic(const Duration(seconds: 300), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        timer.cancel();
        AuthenticationRepository.instance.setInitialScreen(user);
      }
    });
  }

  void manuallyCheckEmailVerificationStatus() {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      AuthenticationRepository.instance.setInitialScreen(user);
    }
  }
}

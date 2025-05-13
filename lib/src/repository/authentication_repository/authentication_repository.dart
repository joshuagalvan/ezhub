import 'dart:developer';

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simone/src/features/home/home.dart';
import 'package:simone/src/features/authentication/screens/login/login_screen.dart';
import 'package:simone/src/features/authentication/screens/mailverification/mail_verification.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  EmailOTP myauth = EmailOTP();

  @override
  void onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    //setInitialScreen(firebaseUser.value);
    ever(firebaseUser, setInitialScreen);
  }

  setInitialScreen(User? user) async {
    user == null
        ? Get.offAll(() => const LoginScreen())
        : user.emailVerified
            ? Get.offAll(() => const LoginScreen())
            : Get.offAll(() => const MailVerification());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is not valid.');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try again');
        }
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const MailVerification())
          : Get.to(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", "${e.message}");
    } catch (_) {}
  }

  Future<void> resetUserPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      // firebaseUser.value == null
      //     ? Get.offAll(() => const LoginScreen())
      //     : Get.to(() => const SentResetPasswordScreen());
    } on FirebaseAuthException catch (e) {
      log('check $e');
    } catch (_) {}
  }

  // Future<void> loginWithEmailAndPassword(
  //     String email, String password) async {
  //   //User? user;
  //   try {
  //     await auth.signInWithEmailAndPassword(email: email, password: password);
  //     firebaseUser.value != null
  //         ? Get.offAll(() => const Home())
  //         : Get.to(() => LoginScreen());
  //   } on FirebaseAuthException catch (e) {
  //   } catch (_) {}
  // }

  Future<void> sendEmailVerification() async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (_) {
    } catch (_) {}
  }

  Future<void> logOut() async {
    await GetStorage().remove('userData');
    await GetStorage().remove('branch');
    await auth.signOut();
  }

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const Home())
          : Get.to(() => const LoginScreen());
      return true;
    } on FirebaseAuthException catch (_) {
      // Get.snackbar("Error", "Invalid Email or Password. Please Try Again.");
      return false;
    } catch (_) {}
    return false;
  }
}

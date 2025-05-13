import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/repository/authentication_repository/authentication_repository.dart';
import 'package:simone/src/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final agentCode = TextEditingController();
  final email = TextEditingController();
  final fullname = TextEditingController();
  final password = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());

  void registerUser(String email, String password) {
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
  }

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }

  Future<bool> loginUser(String email, String password) async {
    final result = await AuthenticationRepository.instance
        .loginWithEmailAndPassword(email, password);

    return result;
  }

  Future<void> sendResetEmail(String email) async {
    await AuthenticationRepository.instance.resetUserPassword(email);
  }

  void phoneAuthentication(String phoneNo) {
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }
}

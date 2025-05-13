import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/repository/authentication_repository/authentication_repository.dart';
import 'package:simone/src/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final api = Api();
  final authRepo = Get.put(AuthenticationRepository());
  final userRepo = Get.put(UserRepository());
  final box = GetStorage();

  Future<UserModel?> getUserData() async {
    final email = authRepo.firebaseUser.value?.email;
    if (email != null) {
      final data = await userRepo.getUserDetails(email);
      log('USER DETAILS --> ${data.toJson()}');
      await box.write('userData', data.toJson());
      return data;
    } else {
      Get.snackbar("Error", "Login to Continue");
      return null;
    }
  }

  updateRecord(UserModel user) async {
    userRepo.updateUserRecord(user);
  }

  Future<Map<String, dynamic>> getBranch() async {
    final controller = Get.put(ProfileController());
    var userData = await controller.getUserData();

    final result = await api.getBranch(agentCode: userData?.agentCode ?? '');

    log('BRANCH DETAILS --> $result');

    final data = {
      "locTax": double.parse(result['local_tax']),
      "branch": result['name'],
      "code": result['code'],
      "id": result['id'],
    };
    await box.write('branch', data);
    return data;
    // locTax = double.parse(result['local_tax']);
    // setState(() {
    //   branchName = (result['name']);
    // });
  }

  getUserId() {}
}

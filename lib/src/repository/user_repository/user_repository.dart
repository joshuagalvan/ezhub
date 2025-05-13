import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => log("Success"),
        )
        // ignore: body_might_complete_normally_catch_error
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        snackPosition: SnackPosition.BOTTOM,
      );
      log(error.toString());
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUser() async {
    final snapshot = await db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    await db.collection("Users").doc(user.id).update(user.toJson());
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CtplController extends GetxController {
  static CtplController get instance => Get.find();

  final inName = TextEditingController();
  final email = TextEditingController();
  final fullname = TextEditingController();
  final password = TextEditingController();
  final phoneNo = TextEditingController();
}

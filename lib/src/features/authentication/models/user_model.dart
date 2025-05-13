import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String agentCode;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;

  const UserModel({
    this.id,
    required this.agentCode,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.password,
  });

  toJson() {
    return {
      "fullname": fullName,
      "agentCode": agentCode,
      "phonenumber": phoneNo,
      "email": email,
      "password": password
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fullName: json["fullname"],
        agentCode: json["agentCode"],
        phoneNo: json["phonenumber"],
        email: json["email"],
        password: json["password"],
      );

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return UserModel(
        id: documentSnapshot.id,
        agentCode: data["agentCode"],
        fullName: data["fullname"],
        email: data["email"],
        phoneNo: data["phonenumber"],
        password: data["password"]);
  }
}

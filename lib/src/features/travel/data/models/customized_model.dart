// To parse this JSON data, do
//
//     final customizedBenefitModel = customizedBenefitModelFromJson(jsonString);

import 'dart:convert';

CustomizedBenefitModel customizedBenefitModelFromJson(String str) =>
    CustomizedBenefitModel.fromJson(json.decode(str));

String customizedBenefitModelToJson(CustomizedBenefitModel data) =>
    json.encode(data.toJson());

class CustomizedBenefitModel {
  String name;
  String details;
  String isDefault;
  String isAddon;
  String amount;
  String limits;
  String id;
  String? code;

  CustomizedBenefitModel({
    required this.name,
    required this.details,
    required this.isDefault,
    required this.isAddon,
    required this.amount,
    required this.limits,
    required this.id,
    required this.code,
  });

  CustomizedBenefitModel copyWith({
    String? name,
    String? details,
    String? isDefault,
    String? isAddon,
    String? amount,
    String? limits,
    String? id,
    String? code,
  }) =>
      CustomizedBenefitModel(
        name: name ?? this.name,
        details: details ?? this.details,
        isDefault: isDefault ?? this.isDefault,
        isAddon: isAddon ?? this.isAddon,
        amount: amount ?? this.amount,
        limits: limits ?? this.limits,
        id: id ?? this.id,
        code: code ?? this.code,
      );

  factory CustomizedBenefitModel.fromJson(Map<String, dynamic> json) =>
      CustomizedBenefitModel(
        name: json["name"],
        details: json["details"],
        isDefault: json["is_default"],
        isAddon: json["is_addon"],
        amount: json["amount"],
        limits: json["limits"],
        id: json["id"],
        code: json["code"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "details": details,
        "is_default": isDefault,
        "is_addon": isAddon,
        "amount": amount,
        "limits": limits,
        "id": id,
        "code": code,
      };
}

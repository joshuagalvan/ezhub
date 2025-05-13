// To parse this JSON data, do
//
//     final standardBenefitModel = standardBenefitModelFromJson(jsonString);

import 'dart:convert';

StandardBenefitModel standardBenefitModelFromJson(String str) =>
    StandardBenefitModel.fromJson(json.decode(str));

String standardBenefitModelToJson(StandardBenefitModel data) =>
    json.encode(data.toJson());

class StandardBenefitModel {
  List<BenefitList> benefitList;
  double premium;

  StandardBenefitModel({
    required this.benefitList,
    required this.premium,
  });

  StandardBenefitModel copyWith({
    List<BenefitList>? benefitList,
    double? premium,
  }) =>
      StandardBenefitModel(
        benefitList: benefitList ?? this.benefitList,
        premium: premium ?? this.premium,
      );

  factory StandardBenefitModel.fromJson(Map<String, dynamic> json) =>
      StandardBenefitModel(
        benefitList: List<BenefitList>.from(
            json["result"].map((x) => BenefitList.fromJson(x))),
        premium: json["premium"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(benefitList.map((x) => x.toJson())),
        "premium": premium,
      };
}

class BenefitList {
  String id;
  String name;
  String coverageDescription;
  String type;
  int covidProtection;
  String description;
  String covidDescription;
  String baseAmount;
  String covidAmount;
  String? code;

  BenefitList({
    required this.id,
    required this.name,
    required this.coverageDescription,
    required this.type,
    required this.covidProtection,
    required this.description,
    required this.covidDescription,
    required this.baseAmount,
    required this.covidAmount,
    required this.code,
  });

  BenefitList copyWith({
    String? id,
    String? name,
    String? coverageDescription,
    String? type,
    int? covidProtection,
    String? description,
    String? covidDescription,
    String? baseAmount,
    String? covidAmount,
    String? code,
  }) =>
      BenefitList(
        id: id ?? this.id,
        name: name ?? this.name,
        coverageDescription: coverageDescription ?? this.coverageDescription,
        type: type ?? this.type,
        covidProtection: covidProtection ?? this.covidProtection,
        description: description ?? this.description,
        covidDescription: covidDescription ?? this.covidDescription,
        baseAmount: baseAmount ?? this.baseAmount,
        covidAmount: covidAmount ?? this.covidAmount,
        code: code ?? this.code,
      );

  factory BenefitList.fromJson(Map<String, dynamic> json) => BenefitList(
        id: json["id"],
        name: json["name"],
        coverageDescription: json["coverage_description"],
        type: json["type"],
        covidProtection: json["covid_protection"],
        description: json["description"],
        covidDescription: json["covid_description"],
        baseAmount: json["base_amount"],
        covidAmount: json["covid_amount"],
        code: json["code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "coverage_description": coverageDescription,
        "type": type,
        "covid_protection": covidProtection,
        "description": description,
        "covid_description": covidDescription,
        "base_amount": baseAmount,
        "covid_amount": covidAmount,
        "code": code,
      };
}

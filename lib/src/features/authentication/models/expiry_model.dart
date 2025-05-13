// To parse this JSON data, do
//
//     final expiryModel = expiryModelFromJson(jsonString);

import 'dart:convert';

ExpiryModel expiryModelFromJson(String str) => ExpiryModel.fromJson(json.decode(str));

String expiryModelToJson(ExpiryModel data) => json.encode(data.toJson());

class ExpiryModel {
    String policyNo;
    String insuredName;
    DateTime inceptionDate;
    DateTime expiryDate;
    String renewalPremium;
    String review;

    ExpiryModel({
        required this.policyNo,
        required this.insuredName,
        required this.inceptionDate,
        required this.expiryDate,
        required this.renewalPremium,
        required this.review,
    });

    ExpiryModel copyWith({
        String? policyNo,
        String? insuredName,
        DateTime? inceptionDate,
        DateTime? expiryDate,
        String? renewalPremium,
        String? review,
    }) => 
        ExpiryModel(
            policyNo: policyNo ?? this.policyNo,
            insuredName: insuredName ?? this.insuredName,
            inceptionDate: inceptionDate ?? this.inceptionDate,
            expiryDate: expiryDate ?? this.expiryDate,
            renewalPremium: renewalPremium ?? this.renewalPremium,
            review: review ?? this.review,
        );

    factory ExpiryModel.fromJson(Map<String, dynamic> json) => ExpiryModel(
        policyNo: json["Policy_no"],
        insuredName: json["insured_name"],
        inceptionDate: DateTime.parse(json["inception_date"]),
        expiryDate: DateTime.parse(json["expiry_date"]),
        renewalPremium: json["renewal_premium"],
        review: json["REVIEW"],
    );

    Map<String, dynamic> toJson() => {
        "Policy_no": policyNo,
        "insured_name": insuredName,
        "inception_date": inceptionDate.toIso8601String(),
        "expiry_date": expiryDate.toIso8601String(),
        "renewal_premium": renewalPremium,
        "REVIEW": review,
    };
}

import 'package:simone/src/features/travel/data/models/country_model.dart';
import 'package:simone/src/features/travel/data/models/customized_model.dart';
import 'package:simone/src/features/travel/data/models/province_model.dart';

class TravelModel {
  TravelModel({
    this.travelAs,
    this.noOfMinor,
    this.noOfAdult,
    this.travelType,
    this.departFrom,
    this.arriveIn,
    this.totalTravelDays,
    this.withCovid,
    this.countries,
    this.provinces,
    this.selectedPlan,
    this.selectedPlanId,
    this.selectedLessOptOut,
    this.selectedAddOns,
    this.isDetailsTermsChecked,
    this.basicPremium,
    this.lgt,
    this.branchLocalTax,
    this.dst,
    this.premiumTax,
    this.totalPremium,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.occupation,
    this.address,
    this.city,
    this.province,
    this.zip,
    this.passportId,
    this.govId,
    this.emergencyName,
    this.emergencyMobile,
    this.emergencyRelationship,
    this.isPersonalPrivacyChecked,
    this.isPersonalTermsChecked,
    this.isPersonalPromotionChecked,
    this.minorsPersonalData,
    this.adultsPersonalData,
  });

  String? travelAs;
  String? travelType;
  String? noOfMinor;
  String? noOfAdult;
  String? departFrom;
  String? arriveIn;
  String? totalTravelDays;
  String? withCovid;
  List<CountryModel?>? countries = [];
  List<ProvinceModel?>? provinces = [];
  String? selectedPlan;
  String? selectedPlanId;
  Set<CustomizedBenefitModel>? selectedLessOptOut;
  Set<CustomizedBenefitModel>? selectedAddOns;
  bool? isDetailsTermsChecked;
  String? basicPremium;
  String? lgt;
  String? branchLocalTax;
  String? dst;
  String? premiumTax;
  String? totalPremium;
  String? title;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? email;
  String? phone;
  String? dateOfBirth;
  String? occupation;
  String? address;
  String? city;
  String? province;
  String? zip;
  String? passportId;
  String? govId;
  String? emergencyName;
  String? emergencyMobile;
  String? emergencyRelationship;
  bool? isPersonalPrivacyChecked;
  bool? isPersonalTermsChecked;
  bool? isPersonalPromotionChecked;
  List<Map<String, dynamic>?>? minorsPersonalData = [];
  List<Map<String, dynamic>?>? adultsPersonalData = [];

  TravelModel copyWith({
    String? travelAs,
    String? noOfMinor,
    String? noOfAdult,
    String? travelType,
    String? departFrom,
    String? arriveIn,
    String? totalTravelDays,
    String? withCovid,
    List<CountryModel?>? countries,
    List<ProvinceModel?>? provinces,
    String? selectedPlan,
    String? selectedPlanId,
    Set<CustomizedBenefitModel>? selectedLessOptOut,
    Set<CustomizedBenefitModel>? selectedAddOns,
    bool? isDetailsTermsChecked,
    String? basicPremium,
    String? lgt,
    String? branchLocalTax,
    String? dst,
    String? premiumTax,
    String? totalPremium,
    String? title,
    String? firstName,
    String? middleName,
    String? lastName,
    String? gender,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? occupation,
    String? address,
    String? city,
    String? province,
    String? zip,
    String? passportId,
    String? govId,
    String? emergencyName,
    String? emergencyMobile,
    String? emergencyRelationship,
    bool? isPersonalPrivacyChecked,
    bool? isPersonalTermsChecked,
    bool? isPersonalPromotionChecked,
    List<Map<String, dynamic>?>? minorsPersonalData,
    List<Map<String, dynamic>?>? adultsPersonalData,
  }) {
    return TravelModel(
      travelAs: travelAs ?? this.travelAs,
      noOfMinor: noOfMinor ?? this.noOfMinor,
      noOfAdult: noOfAdult ?? this.noOfAdult,
      travelType: travelType ?? this.travelType,
      departFrom: departFrom ?? this.departFrom,
      arriveIn: arriveIn ?? this.arriveIn,
      totalTravelDays: totalTravelDays ?? this.totalTravelDays,
      withCovid: withCovid ?? this.withCovid,
      countries: countries ?? this.countries,
      provinces: provinces ?? this.provinces,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      selectedLessOptOut: selectedLessOptOut ?? this.selectedLessOptOut,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      isDetailsTermsChecked:
          isDetailsTermsChecked ?? this.isDetailsTermsChecked,
      basicPremium: basicPremium ?? this.basicPremium,
      lgt: lgt ?? this.lgt,
      branchLocalTax: branchLocalTax ?? this.branchLocalTax,
      dst: dst ?? this.dst,
      premiumTax: premiumTax ?? this.premiumTax,
      totalPremium: totalPremium ?? this.totalPremium,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      occupation: occupation ?? this.occupation,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      zip: zip ?? this.zip,
      passportId: passportId ?? this.passportId,
      govId: govId ?? this.govId,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyMobile: emergencyMobile ?? this.emergencyMobile,
      emergencyRelationship:
          emergencyRelationship ?? this.emergencyRelationship,
      isPersonalPrivacyChecked:
          isPersonalPrivacyChecked ?? this.isPersonalPrivacyChecked,
      isPersonalTermsChecked:
          isPersonalTermsChecked ?? this.isPersonalTermsChecked,
      isPersonalPromotionChecked:
          isPersonalPromotionChecked ?? this.isPersonalPromotionChecked,
      minorsPersonalData: minorsPersonalData ?? this.minorsPersonalData,
      adultsPersonalData: adultsPersonalData ?? this.adultsPersonalData,
    );
  }

  factory TravelModel.fromJson(Map<String, dynamic> json) => TravelModel(
        travelAs: json["travelAs"],
        noOfMinor: json["noOfMinor"],
        noOfAdult: json["noOfAdult"],
        travelType: json["travelType"],
        departFrom: json["departFrom"],
        arriveIn: json["arriveIn"],
        totalTravelDays: json["totalTravelDays"],
        withCovid: json["withCovid"],
        countries: json["countries"],
        provinces: json["provinces"],
        selectedPlan: json["selectedPlan"],
        selectedPlanId: json["selectedPlanId"],
        selectedLessOptOut: json["selectedLessOptOut"],
        selectedAddOns: json["selectedAddOns"],
        isDetailsTermsChecked: json["isDetailsTermsChecked"],
        basicPremium: json["basicPremium"],
        lgt: json["lgt"],
        branchLocalTax: json["branchLocalTax"],
        dst: json["dst"],
        premiumTax: json["premiumTax"],
        totalPremium: json["totalPremium"],
        title: json["title"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        gender: json["gender"],
        email: json["email"],
        phone: json["phone"],
        dateOfBirth: json["dateOfBirth"],
        occupation: json["occupation"],
        address: json["address"],
        city: json["city"],
        province: json["province"],
        zip: json["zip"],
        passportId: json["passportId"],
        govId: json["govId"],
        emergencyName: json["emergencyName"],
        emergencyMobile: json["emergencyMobile"],
        emergencyRelationship: json["emergencyRelationship"],
        isPersonalPrivacyChecked: json["isPersonalPrivacyChecked"],
        isPersonalTermsChecked: json["isPersonalTermsChecked"],
        isPersonalPromotionChecked: json["isPersonalPromotionChecked"],
        minorsPersonalData: json["minorsPersonalData"],
        adultsPersonalData: json["adultsPersonalData"],
      );

  Map<String, dynamic> toJson() => {
        "travelAs": travelAs,
        "noOfMinor": noOfMinor,
        "noOfAdult": noOfAdult,
        "travelType": travelType,
        "departFrom": departFrom,
        "arriveIn": arriveIn,
        "totalTravelDays": totalTravelDays,
        "withCovid": withCovid,
        "countries": countries,
        "provinces": provinces,
        "selectedPlan": selectedPlan,
        "selectedPlanId": selectedPlanId,
        "selectedLessOptOut": selectedLessOptOut,
        "selectedAddOns": selectedAddOns,
        "isDetailsTermsChecked": isDetailsTermsChecked,
        "basicPremium": basicPremium,
        "lgt": lgt,
        "branchLocalTax": branchLocalTax,
        "dst": dst,
        "premiumTax": premiumTax,
        "totalPremium": totalPremium,
        "title": title,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "gender": gender,
        "email": email,
        "phone": phone,
        "dateOfBirth": dateOfBirth,
        "occupation": occupation,
        "address": address,
        "city": city,
        "province": province,
        "zip": zip,
        "passportId": passportId,
        "govId": govId,
        "emergencyName": emergencyName,
        "emergencyMobile": emergencyMobile,
        "emergencyRelationship": emergencyRelationship,
        "isPersonalPrivacyChecked": isPersonalPrivacyChecked,
        "isPersonalTermsChecked": isPersonalTermsChecked,
        "isPersonalPromotionChecked": isPersonalPromotionChecked,
        "minorsPersonalData": minorsPersonalData,
        "adultsPersonalData": adultsPersonalData,
      };
}

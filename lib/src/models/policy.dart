class Policy {
  Policy({
    this.typeOfCoverId,
    this.typeOfCover,
    this.plateNumber,
    this.chassisNumber,
    this.engineNumber,
    this.mvFileNo,
    this.conductionSticker,
    this.rates,
    this.yearManufactured,
    this.carBrand,
    this.carBrandId,
    this.carModel,
    this.carType,
    this.carColor,
    this.carVariant,
    this.fairMarketValue,
    this.deductibles,
    this.bodilyInjury,
    this.propertyDamage,
    this.profileId,
    this.fullName,
    this.dateOfBirth,
    this.address1,
    this.address2,
    this.email,
    this.phoneNo,
    this.mobileNo,
    this.tin,
    this.policyPeriodFrom,
    this.policyPeriodTo,
    this.basicPremium,
    this.ownDamageRate,
    this.actOfNatureRate,
    this.ownDamageAmount,
    this.actOfNatureAmount,
    this.docStamp,
    this.vtplbiRate,
    this.vtplpdRate,
    this.vtplbiAmount,
    this.vtplpdAmount,
    this.gender,
    this.agentCode,
    this.branch,
    this.branchCode,
    this.toPro,
    this.productId,
  });

  String? typeOfCoverId;
  String? typeOfCover;
  String? plateNumber;
  String? chassisNumber;
  String? engineNumber;
  String? mvFileNo;
  String? conductionSticker;
  String? rates;
  String? yearManufactured;
  String? carBrand;
  String? carBrandId;
  String? carModel;
  String? carType;
  String? carColor;
  String? carVariant;
  String? fairMarketValue;
  String? deductibles;
  String? bodilyInjury;
  String? propertyDamage;
  String? profileId;
  String? fullName;
  String? dateOfBirth;
  String? address1;
  String? address2;
  String? email;
  String? phoneNo;
  String? mobileNo;
  String? tin;
  String? policyPeriodFrom;
  String? policyPeriodTo;
  String? basicPremium;
  String? ownDamageRate;
  String? ownDamageAmount;
  String? actOfNatureRate;
  String? actOfNatureAmount;
  String? docStamp;
  String? vtplbiRate;
  String? vtplbiAmount;
  String? vtplpdRate;
  String? vtplpdAmount;
  String? gender;
  String? agentCode;
  String? branch;
  String? branchCode;
  String? toPro;
  String? productId;

  Policy copyWith({
    String? typeOfCoverId,
    String? typeOfCover,
    String? plateNumber,
    String? chassisNumber,
    String? engineNumber,
    String? mvFileNo,
    String? conductionSticker,
    String? rates,
    String? yearManufactured,
    String? carBrand,
    String? carBrandId,
    String? carModel,
    String? carType,
    String? carColor,
    String? carVariant,
    String? fairMarketValue,
    String? deductibles,
    String? bodilyInjury,
    String? propertyDamage,
    String? profileId,
    String? fullName,
    String? dateOfBirth,
    String? address1,
    String? address2,
    String? email,
    String? phoneNo,
    String? mobileNo,
    String? tin,
    String? policyPeriodFrom,
    String? policyPeriodTo,
    String? vtplbiRate,
    String? vtplpdRate,
    String? vtplbiAmount,
    String? vtplpdAmount,
    String? basicPremium,
    String? ownDamageRate,
    String? actOfNatureRate,
    String? ownDamageAmount,
    String? actOfNatureAmount,
    String? docStamp,
    String? gender,
    String? agentCode,
    String? branch,
    String? branchCode,
    String? toPro,
    String? productId,
  }) {
    return Policy(
      typeOfCoverId: typeOfCoverId ?? this.typeOfCoverId,
      typeOfCover: typeOfCover ?? this.typeOfCover,
      plateNumber: plateNumber ?? this.plateNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      mvFileNo: mvFileNo ?? this.mvFileNo,
      conductionSticker: conductionSticker ?? this.conductionSticker,
      rates: rates ?? this.rates,
      yearManufactured: yearManufactured ?? this.yearManufactured,
      carBrand: carBrand ?? this.carBrand,
      carBrandId: carBrandId ?? this.carBrandId,
      carModel: carModel ?? this.carModel,
      carType: carType ?? this.carType,
      carColor: carColor ?? this.carColor,
      carVariant: carVariant ?? this.carVariant,
      fairMarketValue: fairMarketValue ?? this.fairMarketValue,
      deductibles: deductibles ?? this.deductibles,
      bodilyInjury: bodilyInjury ?? this.bodilyInjury,
      propertyDamage: propertyDamage ?? this.propertyDamage,
      profileId: profileId ?? this.profileId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      mobileNo: mobileNo ?? this.mobileNo,
      tin: tin ?? this.tin,
      policyPeriodFrom: policyPeriodFrom ?? this.policyPeriodFrom,
      policyPeriodTo: policyPeriodTo ?? this.policyPeriodTo,
      vtplbiRate: vtplbiRate ?? this.vtplbiRate,
      vtplpdRate: vtplpdRate ?? this.vtplpdRate,
      vtplbiAmount: vtplbiAmount ?? this.vtplbiAmount,
      vtplpdAmount: vtplpdAmount ?? this.vtplpdAmount,
      basicPremium: basicPremium ?? this.basicPremium,
      ownDamageRate: ownDamageRate ?? this.ownDamageRate,
      actOfNatureRate: actOfNatureRate ?? this.actOfNatureRate,
      ownDamageAmount: ownDamageAmount ?? this.ownDamageAmount,
      actOfNatureAmount: actOfNatureAmount ?? this.actOfNatureAmount,
      docStamp: docStamp ?? this.docStamp,
      gender: gender ?? this.gender,
      agentCode: agentCode ?? this.agentCode,
      branch: branch ?? this.branch,
      branchCode: branchCode ?? this.branchCode,
      toPro: toPro ?? this.toPro,
      productId: productId ?? this.productId,
    );
  }

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        typeOfCoverId: json["typeOfCoverId"],
        typeOfCover: json["typeOfCover"],
        plateNumber: json["plateNumber"],
        chassisNumber: json["chassisNumber"],
        engineNumber: json["engineNumber"],
        mvFileNo: json["mvFileNo"],
        conductionSticker: json["conductionSticker"],
        rates: json["rates"],
        yearManufactured: json["yearManufactured"],
        carBrand: json["carBrand"],
        carBrandId: json["carBrandId"],
        carModel: json["carModel"],
        carType: json["carType"],
        carColor: json["carColor"],
        carVariant: json["carVariant"],
        fairMarketValue: json["fairMarketValue"],
        deductibles: json["deductibles"],
        bodilyInjury: json["bodilyInjury"],
        propertyDamage: json["propertyDamage"],
        profileId: json["profileId"],
        fullName: json["fullName"],
        dateOfBirth: json["dateOfBirth"],
        address1: json["address1"],
        address2: json["address2"],
        email: json["email"],
        phoneNo: json["phoneNo"],
        mobileNo: json["mobileNo"],
        tin: json["tin"],
        policyPeriodFrom: json["policyPeriodFrom"],
        policyPeriodTo: json["policyPeriodTo"],
        vtplbiRate: json["vtplbiRate"],
        vtplpdRate: json["vtplpdRate"],
        vtplbiAmount: json["vtplbiAmount"],
        vtplpdAmount: json["vtplpdAmount"],
        basicPremium: json["basicPremium"],
        ownDamageRate: json["ownDamageRate"],
        actOfNatureRate: json["actOfNatureRate"],
        ownDamageAmount: json["ownDamageAmount"],
        actOfNatureAmount: json["actOfNatureAmount"],
        docStamp: json["docStamp"],
        gender: json["gender"],
        agentCode: json["agentCode"],
        branch: json["branch"],
        branchCode: json["branchCode"],
        toPro: json["toPro"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "typeOfCoverId": typeOfCoverId,
        "typeOfCover": typeOfCover,
        "plateNumber": plateNumber,
        "chassisNumber": chassisNumber,
        "engineNumber": engineNumber,
        "mvFileNo": mvFileNo,
        "rates": rates,
        "yearManufactured": yearManufactured,
        "carBrand": carBrand,
        "carBrandId": carBrandId,
        "carModel": carModel,
        "carType": carType,
        "carColor": carColor,
        "carVariant": carVariant,
        "fairMarketValue": fairMarketValue,
        "deductibles": deductibles,
        "bodilyInjury": bodilyInjury,
        "propertyDamage": propertyDamage,
        "profileId": profileId,
        "fullName": fullName,
        "dateOfBirth": dateOfBirth,
        "address1": address1,
        "address2": address2,
        "email": email,
        "phoneNo": phoneNo,
        "mobileNo": mobileNo,
        "tin": tin,
        "policyPeriodFrom": policyPeriodFrom,
        "policyPeriodTo": policyPeriodTo,
        "vtplbiRate": vtplbiRate,
        "vtplpdRate": vtplpdRate,
        "vtplbiAmount": vtplbiAmount,
        "vtplpdAmount": vtplpdAmount,
        "basicPremium": basicPremium,
        "ownDamageRate": ownDamageRate,
        "actOfNatureRate": actOfNatureRate,
        "ownDamageAmount": ownDamageAmount,
        "actOfNatureAmount": actOfNatureAmount,
        "docStamp": docStamp,
        "gender": gender,
        "agentCode": agentCode,
        "branch": branch,
        "branchCode": branchCode,
        "toPro": toPro,
        "productId": productId,
      };
}

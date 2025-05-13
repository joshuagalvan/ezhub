class CTPLPolicy {
  CTPLPolicy({
    this.plateNumber,
    this.chassisNumber,
    this.engineNumber,
    this.isPolicyBrandNew,
    this.ctplCoverage,
    this.vehicleTypeName,
    this.vehicleTypeId,
    this.inceptionDate,
    this.expiryDate,
    this.yearManufactured,
    this.carMakeBrand,
    this.carMakeBrandId,
    this.carModel,
    this.carModelId,
    this.carType,
    this.carTypeId,
    this.transmissionType,
    this.carVariant,
    this.conductionSticker,
    this.mvFileNumber,
    this.color,
    this.agentCode,
    this.fullName,
    this.branchCode,
    this.branchName,
    this.commision,
    this.basicPremium,
    this.dst,
    this.vat,
    this.lgt,
    this.lto,
    this.locTaxRate,
    this.totalPremium,
    this.refNo,
    this.source,
    this.policyType,
    this.hasProfile,
    this.isNewProfile,
    this.firstName,
    this.middleName,
    this.lastName,
    this.suffix,
    this.birthDate,
    this.birthPlace,
    this.gender,
    this.citizenship,
    this.address1,
    this.address2,
    this.streetAddress,
    this.brgy,
    this.city,
    this.province,
    this.zip,
    this.country,
    this.phoneNo,
    this.mobileNo,
    this.email,
    this.tin,
    this.incomeSource,
    this.idType,
    this.idNo,
    this.listManufactureYear,
    this.taggingId,
  });

  String? plateNumber;
  String? chassisNumber;
  String? engineNumber;
  String? isPolicyBrandNew;
  String? ctplCoverage;
  String? vehicleTypeName;
  String? vehicleTypeId;
  String? inceptionDate;
  String? expiryDate;
  String? yearManufactured;
  String? carMakeBrand;
  String? carMakeBrandId;
  String? carModel;
  String? carModelId;
  String? carType;
  String? carTypeId;
  String? transmissionType;
  String? carVariant;
  String? conductionSticker;
  String? mvFileNumber;
  String? color;
  String? agentCode;
  String? fullName;
  String? branchCode;
  String? branchName;
  String? commision;
  String? basicPremium;
  String? dst;
  String? vat;
  String? lgt;
  String? lto;
  String? locTaxRate;
  String? totalPremium;
  String? refNo;
  String? source;
  String? policyType;
  bool? hasProfile;
  bool? isNewProfile;
  String? firstName;
  String? middleName;
  String? lastName;
  String? suffix;
  String? birthDate;
  String? birthPlace;
  String? gender;
  String? citizenship;
  String? address1;
  String? address2;
  String? streetAddress;
  String? brgy;
  String? city;
  String? province;
  String? zip;
  String? country;
  String? phoneNo;
  String? mobileNo;
  String? email;
  String? tin;
  String? incomeSource;
  String? idType;
  String? idNo;
  String? taggingId;
  List<dynamic>? listManufactureYear = [];

  CTPLPolicy copyWith({
    String? plateNumber,
    String? chassisNumber,
    String? engineNumber,
    String? isPolicyBrandNew,
    String? ctplCoverage,
    String? vehicleTypeName,
    String? vehicleTypeId,
    String? inceptionDate,
    String? expiryDate,
    String? yearManufactured,
    String? carMakeBrand,
    String? carMakeBrandId,
    String? carModel,
    String? carModelId,
    String? carType,
    String? carTypeId,
    String? transmissionType,
    String? carVariant,
    String? conductionSticker,
    String? mvFileNumber,
    String? color,
    String? agentCode,
    String? fullName,
    String? branchCode,
    String? branchName,
    String? commision,
    String? basicPremium,
    String? dst,
    String? vat,
    String? lgt,
    String? lto,
    String? locTaxRate,
    String? totalPremium,
    String? refNo,
    String? source,
    String? policyType,
    bool? hasProfile,
    bool? isNewProfile,
    String? firstName,
    String? middleName,
    String? lastName,
    String? suffix,
    String? birthDate,
    String? birthPlace,
    String? gender,
    String? citizenship,
    String? address1,
    String? address2,
    String? streetAddress,
    String? brgy,
    String? city,
    String? province,
    String? zip,
    String? country,
    String? phoneNo,
    String? mobileNo,
    String? email,
    String? tin,
    String? incomeSource,
    String? idType,
    String? idNo,
    String? taggingId,
    List<dynamic>? listManufactureYear,
  }) {
    return CTPLPolicy(
      plateNumber: plateNumber ?? this.plateNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      isPolicyBrandNew: isPolicyBrandNew ?? this.isPolicyBrandNew,
      ctplCoverage: ctplCoverage ?? this.ctplCoverage,
      vehicleTypeName: vehicleTypeName ?? this.vehicleTypeName,
      vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
      inceptionDate: inceptionDate ?? this.inceptionDate,
      expiryDate: expiryDate ?? this.expiryDate,
      yearManufactured: yearManufactured ?? this.yearManufactured,
      carMakeBrand: carMakeBrand ?? this.carMakeBrand,
      carMakeBrandId: carMakeBrandId ?? this.carMakeBrandId,
      carModel: carModel ?? this.carModel,
      carModelId: carModelId ?? this.carModelId,
      carType: carType ?? this.carType,
      carTypeId: carTypeId ?? this.carTypeId,
      transmissionType: transmissionType ?? this.transmissionType,
      carVariant: carVariant ?? this.carVariant,
      conductionSticker: conductionSticker ?? this.conductionSticker,
      mvFileNumber: mvFileNumber ?? this.mvFileNumber,
      color: color ?? this.color,
      agentCode: agentCode ?? this.agentCode,
      fullName: fullName ?? this.fullName,
      branchCode: branchCode ?? this.branchCode,
      branchName: branchName ?? this.branchName,
      commision: commision ?? this.commision,
      basicPremium: basicPremium ?? this.basicPremium,
      dst: dst ?? this.dst,
      vat: vat ?? this.vat,
      lgt: lgt ?? this.lgt,
      lto: lto ?? this.lto,
      locTaxRate: locTaxRate ?? this.locTaxRate,
      totalPremium: totalPremium ?? this.totalPremium,
      refNo: refNo ?? this.refNo,
      source: source ?? this.source,
      policyType: policyType ?? this.policyType,
      hasProfile: hasProfile ?? this.hasProfile,
      isNewProfile: isNewProfile ?? this.isNewProfile,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      suffix: suffix ?? this.suffix,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      gender: gender ?? this.gender,
      citizenship: citizenship ?? this.citizenship,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      streetAddress: streetAddress ?? this.streetAddress,
      brgy: brgy ?? this.brgy,
      city: city ?? this.city,
      province: province ?? this.province,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      phoneNo: phoneNo ?? this.phoneNo,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      tin: tin ?? this.tin,
      incomeSource: incomeSource ?? this.incomeSource,
      idType: idType ?? this.idType,
      idNo: idNo ?? this.idNo,
      listManufactureYear: listManufactureYear ?? this.listManufactureYear,
      taggingId: taggingId,
    );
  }

  factory CTPLPolicy.fromJson(Map<String, dynamic> json) => CTPLPolicy(
        plateNumber: json["plateNumber"],
        chassisNumber: json["chassisNumber"],
        engineNumber: json["engineNumber"],
        isPolicyBrandNew: json["isPolicyBrandNew"],
        ctplCoverage: json["ctplCoverage"],
        vehicleTypeName: json["vehicleTypeName"],
        vehicleTypeId: json["vehicleTypeId"],
        inceptionDate: json["inceptionDate"],
        expiryDate: json["expiryDate"],
        yearManufactured: json["yearManufactured"],
        carMakeBrand: json["carMakeBrand"],
        carMakeBrandId: json["carMakeBrandId"],
        carModel: json["carModel"],
        carModelId: json["carModelId"],
        carType: json["carType"],
        carTypeId: json["carTypeId"],
        transmissionType: json["transmissionType"],
        carVariant: json["carVariant"],
        conductionSticker: json["conductionSticker"],
        mvFileNumber: json["mvFileNumber"],
        color: json["color"],
        agentCode: json["agentCode"],
        fullName: json["fullName"],
        branchCode: json["branchCode"],
        branchName: json["branchName"],
        commision: json["commision"],
        basicPremium: json["basicPremium"],
        dst: json["dst"],
        vat: json["vat"],
        lgt: json["lgt"],
        lto: json["lto"],
        locTaxRate: json["locTaxRate"],
        totalPremium: json["totalPremium"],
        refNo: json["refNo"],
        source: json["source"],
        policyType: json["policyType"],
        hasProfile: json["hasProfile"],
        isNewProfile: json["isNewProfile"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        suffix: json["suffix"],
        birthDate: json["birthDate"],
        birthPlace: json["birthPlace"],
        gender: json["gender"],
        citizenship: json["citizenship"],
        address1: json["address1"],
        address2: json["address2"],
        streetAddress: json["streetAddress"],
        brgy: json["brgy"],
        city: json["city"],
        province: json["province"],
        zip: json["zip"],
        country: json["country"],
        phoneNo: json["phoneNo"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        tin: json["tin"],
        incomeSource: json["incomeSource"],
        idType: json["idType"],
        idNo: json["idNo"],
        taggingId: json["taggingId"],
        listManufactureYear: json["listManufactureYear"],
      );

  Map<String, dynamic> toJson() => {
        "plateNumber": plateNumber,
        "chassisNumber": chassisNumber,
        "engineNumber": engineNumber,
        "isPolicyBrandNew": isPolicyBrandNew,
        "ctplCoverage": ctplCoverage,
        "vehicleTypeName": vehicleTypeName,
        "vehicleTypeId": vehicleTypeId,
        "inceptionDate": inceptionDate,
        "expiryDate": expiryDate,
        "yearManufactured": yearManufactured,
        "carMakeBrand": carMakeBrand,
        "carMakeBrandId": carMakeBrandId,
        "carModel": carModel,
        "carModelId": carModelId,
        "carType": carType,
        "carTypeId": carTypeId,
        "transmissionType": transmissionType,
        "carVariant": carVariant,
        "conductionSticker": conductionSticker,
        "mvFileNumber": mvFileNumber,
        "color": color,
        "agentCode": agentCode,
        "fullName": fullName,
        "branchCode": branchCode,
        "branchName": branchName,
        "commision": commision,
        "basicPremium": basicPremium,
        "dst": dst,
        "vat": vat,
        "lgt": lgt,
        "lto": lto,
        "locTaxRate": locTaxRate,
        "totalPremium": totalPremium,
        "refNo": refNo,
        "source": source,
        "policyType": policyType,
        "hasProfile": hasProfile,
        "isNewProfile": isNewProfile,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "suffix": suffix,
        "birthDate": birthDate,
        "birthPlace": birthPlace,
        "gender": gender,
        "citizenship": citizenship,
        "address1": address1,
        "address2": address2,
        "streetAddress": streetAddress,
        "brgy": brgy,
        "city": city,
        "province": province,
        "zip": zip,
        "country": country,
        "phoneNo": phoneNo,
        "mobileNo": mobileNo,
        "email": email,
        "tin": tin,
        "incomeSource": incomeSource,
        "idType": idType,
        "idNo": idNo,
        "taggingId": taggingId,
        "listManufactureYear": listManufactureYear,
      };
}

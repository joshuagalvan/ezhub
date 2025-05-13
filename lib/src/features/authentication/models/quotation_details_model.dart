class QuotationDetails {
  int id;
  double odRate;
  double aonRate;
  int vtplBi;
  int vtplPd;
  String status;
  String periodOfInsurance;
  String quotationExpiry;
  String refNumber;
  String intermediary;
  int refCounter;
  DateTime createdDate;
  String name;
  String email;
  String branch;
  String toc;
  String rate;
  String year;
  String carCompany;
  String carMake;
  String carType;
  String carVariant;
  String fmv;
  String deductible;
  double totalPremium;
  double basicPremium;
  double docStamp;
  double vat;
  double localTax;
  double od;
  double aon;
  DateTime createdAt;
  DateTime updatedAt;

  QuotationDetails({
    required this.id,
    required this.odRate,
    required this.aonRate,
    required this.vtplBi,
    required this.vtplPd,
    required this.status,
    required this.periodOfInsurance,
    required this.quotationExpiry,
    required this.refNumber,
    required this.intermediary,
    required this.refCounter,
    required this.createdDate,
    required this.name,
    required this.email,
    required this.branch,
    required this.toc,
    required this.rate,
    required this.year,
    required this.carCompany,
    required this.carMake,
    required this.carType,
    required this.carVariant,
    required this.fmv,
    required this.deductible,
    required this.totalPremium,
    required this.basicPremium,
    required this.docStamp,
    required this.vat,
    required this.localTax,
    required this.od,
    required this.aon,
    required this.createdAt,
    required this.updatedAt,
  });

  QuotationDetails copyWith({
    int? id,
    double? odRate,
    double? aonRate,
    int? vtplBi,
    int? vtplPd,
    String? status,
    String? periodOfInsurance,
    String? quotationExpiry,
    String? refNumber,
    String? intermediary,
    int? refCounter,
    DateTime? createdDate,
    String? name,
    String? email,
    String? branch,
    String? toc,
    String? rate,
    String? year,
    String? carCompany,
    String? carMake,
    String? carType,
    String? carVariant,
    String? fmv,
    String? deductible,
    double? totalPremium,
    double? basicPremium,
    double? docStamp,
    double? vat,
    double? localTax,
    double? od,
    double? aon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      QuotationDetails(
        id: id ?? this.id,
        odRate: odRate ?? this.odRate,
        aonRate: aonRate ?? this.aonRate,
        vtplBi: vtplBi ?? this.vtplBi,
        vtplPd: vtplPd ?? this.vtplPd,
        status: status ?? this.status,
        periodOfInsurance: periodOfInsurance ?? this.periodOfInsurance,
        quotationExpiry: quotationExpiry ?? this.quotationExpiry,
        refNumber: refNumber ?? this.refNumber,
        intermediary: intermediary ?? this.intermediary,
        refCounter: refCounter ?? this.refCounter,
        createdDate: createdDate ?? this.createdDate,
        name: name ?? this.name,
        email: email ?? this.email,
        branch: branch ?? this.branch,
        toc: toc ?? this.toc,
        rate: rate ?? this.rate,
        year: year ?? this.year,
        carCompany: carCompany ?? this.carCompany,
        carMake: carMake ?? this.carMake,
        carType: carType ?? this.carType,
        carVariant: carVariant ?? this.carVariant,
        fmv: fmv ?? this.fmv,
        deductible: deductible ?? this.deductible,
        totalPremium: totalPremium ?? this.totalPremium,
        basicPremium: basicPremium ?? this.basicPremium,
        docStamp: docStamp ?? this.docStamp,
        vat: vat ?? this.vat,
        localTax: localTax ?? this.localTax,
        od: od ?? this.od,
        aon: aon ?? this.aon,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory QuotationDetails.fromJson(Map<String, dynamic> json) =>
      QuotationDetails(
        id: json["id"],
        odRate: json["od_rate"]?.toDouble(),
        aonRate: json["aon_rate"]?.toDouble(),
        vtplBi: json["vtpl_bi"],
        vtplPd: json["vtpl_pd"],
        status: json["status"],
        periodOfInsurance: json["period_of_insurance"],
        quotationExpiry: json["quotation_expiry"],
        refNumber: json["ref_number"],
        intermediary: json["intermediary"],
        refCounter: json["ref_counter"],
        createdDate: DateTime.parse(json["created_date"]),
        name: json["name"],
        email: json["email"],
        branch: json["branch"],
        toc: json["toc"],
        rate: json["rate"],
        year: json["year"],
        carCompany: json["car_company"],
        carMake: json["car_make"],
        carType: json["car_type"],
        carVariant: json["car_variant"],
        fmv: json["fmv"],
        deductible: json["deductible"],
        totalPremium: json["total_premium"]?.toDouble(),
        basicPremium: json["basic_premium"]?.toDouble(),
        docStamp: json["doc_stamp"]?.toDouble(),
        vat: json["vat"]?.toDouble(),
        localTax: json["local_tax"]?.toDouble(),
        od: json["od"]?.toDouble(),
        aon: json["aon"]?.toDouble(),
        createdAt: DateTime.parse(
            json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updated_at"] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "od_rate": odRate,
        "aon_rate": aonRate,
        "vtpl_bi": vtplBi,
        "vtpl_pd": vtplPd,
        "status": status,
        "period_of_insurance": periodOfInsurance,
        "quotation_expiry": quotationExpiry,
        "ref_number": refNumber,
        "intermediary": intermediary,
        "ref_counter": refCounter,
        "created_date": createdDate.toIso8601String(),
        "name": name,
        "email": email,
        "branch": branch,
        "toc": toc,
        "rate": rate,
        "year": year,
        "car_company": carCompany,
        "car_make": carMake,
        "car_type": carType,
        "car_variant": carVariant,
        "fmv": fmv,
        "deductible": deductible,
        "total_premium": totalPremium,
        "basic_premium": basicPremium,
        "doc_stamp": docStamp,
        "vat": vat,
        "local_tax": localTax,
        "od": od,
        "aon": aon,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

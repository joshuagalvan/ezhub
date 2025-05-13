class CountryModel {
  String id;
  String countryModelClass;
  String continent;
  String region;
  String country;
  String capital;
  String isoCode;
  String isActive;

  CountryModel({
    required this.id,
    required this.countryModelClass,
    required this.continent,
    required this.region,
    required this.country,
    required this.capital,
    required this.isoCode,
    required this.isActive,
  });

  CountryModel copyWith({
    String? id,
    String? countryModelClass,
    String? continent,
    String? region,
    String? country,
    String? capital,
    String? isoCode,
    String? isActive,
  }) =>
      CountryModel(
        id: id ?? this.id,
        countryModelClass: countryModelClass ?? this.countryModelClass,
        continent: continent ?? this.continent,
        region: region ?? this.region,
        country: country ?? this.country,
        capital: capital ?? this.capital,
        isoCode: isoCode ?? this.isoCode,
        isActive: isActive ?? this.isActive,
      );

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["id"],
        countryModelClass: json["class"],
        continent: json["continent"],
        region: json["region"],
        country: json["country"],
        capital: json["capital"],
        isoCode: json["iso_code"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "class": countryModelClass,
        "continent": continent,
        "region": region,
        "country": country,
        "capital": capital,
        "iso_code": isoCode,
        "is_active": isActive,
      };
}

class RatesModel {
  int id;
  String classificationId;
  String rate;
  String ownDamage;
  String? actOfNature;
  String? rscc;
  String? deductible;

  RatesModel({
    required this.id,
    required this.classificationId,
    required this.rate,
    required this.ownDamage,
    required this.actOfNature,
    required this.rscc,
    required this.deductible,
  });

  RatesModel copyWith({
    int? id,
    String? classificationId,
    String? rate,
    String? ownDamage,
    String? actOfNature,
    String? rscc,
    String? deductible,
  }) =>
      RatesModel(
        id: id ?? this.id,
        classificationId: classificationId ?? this.classificationId,
        rate: rate ?? this.rate,
        ownDamage: ownDamage ?? this.ownDamage,
        actOfNature: actOfNature ?? this.actOfNature,
        rscc: rscc ?? this.rscc,
        deductible: deductible ?? this.deductible,
      );

  factory RatesModel.fromJson(Map<String, dynamic> json) => RatesModel(
        id: json["id"],
        classificationId: json["classification_id"],
        rate: json["rate"],
        ownDamage: json["own_damage"],
        actOfNature: json["act_of_nature"] ?? '0',
        rscc: json["rscc"] ?? '',
        deductible: json["deductible"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "classification_id": classificationId,
        "rate": rate,
        "own_damage": ownDamage,
        "act_of_nature": actOfNature,
        "rscc": rscc,
        "deductible": deductible,
      };
}



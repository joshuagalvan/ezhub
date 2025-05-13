class VTPLBIList {
  String id;
  String name;
  String premiumRatingLevel;
  String light;
  String medium;
  String heavy;

  VTPLBIList({
    required this.id,
    required this.name,
    required this.premiumRatingLevel,
    required this.light,
    required this.medium,
    required this.heavy,
  });

  VTPLBIList copyWith({
    String? id,
    String? name,
    String? premiumRatingLevel,
    String? light,
    String? medium,
    String? heavy,
  }) =>
      VTPLBIList(
        id: id ?? this.id,
        name: name ?? this.name,
        premiumRatingLevel: premiumRatingLevel ?? this.premiumRatingLevel,
        light: light ?? this.light,
        medium: medium ?? this.medium,
        heavy: heavy ?? this.heavy,
      );

  factory VTPLBIList.fromJson(Map<String, dynamic> json) => VTPLBIList(
        id: json["id"],
        name: json["name"],
        premiumRatingLevel: json["premium_rating_level"],
        light: json["light"],
        medium: json["medium"],
        heavy: json["heavy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "premium_rating_level": premiumRatingLevel,
        "light": light,
        "medium": medium,
        "heavy": heavy,
      };
}

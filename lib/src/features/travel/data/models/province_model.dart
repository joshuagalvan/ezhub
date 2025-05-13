

class ProvinceModel {
    String id;
    String name;
    String isActive;

    ProvinceModel({
        required this.id,
        required this.name,
        required this.isActive,
    });

    ProvinceModel copyWith({
        String? id,
        String? name,
        String? isActive,
    }) => 
        ProvinceModel(
            id: id ?? this.id,
            name: name ?? this.name,
            isActive: isActive ?? this.isActive,
        );

    factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
    };
}

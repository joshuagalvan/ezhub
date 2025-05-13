class CarVariantList {
  String? status;
  List<CarVariant>? list;

  CarVariantList({this.status, this.list});

  CarVariantList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['list'] != null) {
      list = <CarVariant>[];
      json['list'].forEach((v) {
        list!.add(CarVariant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarVariant {
  String? id;
  String? name;

  CarVariant({this.id, this.name});

  CarVariant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

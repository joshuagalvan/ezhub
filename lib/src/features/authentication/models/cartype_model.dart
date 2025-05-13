class CarTypeList {
  String? status;
  String? typeId;
  String? id;
  String? type;
  String? capacity;

  CarTypeList({this.status, this.typeId, this.id, this.type, this.capacity});

  CarTypeList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    typeId = json['type_id'];
    id = json['id'];
    type = json['type'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['type_id'] = typeId;
    data['id'] = id;
    data['type'] = type;
    data['capacity'] = capacity;
    return data;
  }
}

class CarCompanyList {
  String? id;
  String? name;
  String? code;

  CarCompanyList({this.id, this.name, this.code});

  CarCompanyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}

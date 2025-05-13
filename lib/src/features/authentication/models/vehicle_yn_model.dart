import 'package:simone/src/features/authentication/models/carcompany_model.dart';

class VechicleYoN {
  String? yes;
  String? no;

  VechicleYoN({this.yes, this.no});

  VechicleYoN.fromJson(Map<String, dynamic> json) {
    yes = json['yes'];
    no = json['no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yes'] = yes;
    data['no'] = no;
    return data;
  }

  static map(CarCompanyList Function(dynamic e) param0) {}
}

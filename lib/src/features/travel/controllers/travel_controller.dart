import 'package:get/get.dart';
import 'package:simone/src/features/travel/data/models/country_model.dart';
import 'package:simone/src/features/travel/data/models/customized_model.dart';
import 'package:simone/src/features/travel/data/models/province_model.dart';
import 'package:simone/src/features/travel/data/models/standard_model.dart';
import 'package:simone/src/features/travel/domain/repositories/travel_repository.dart';

class TravelController extends GetxController {
  static TravelController get instance => Get.find();

  final repository = TravelRepository();

  final selectedTravelAs = 'Individual'.obs;
  final withCovid = '0'.obs; //0 no, 1 yes
  final travelDays = '0'.obs;

  Future<List<CountryModel>> getCountries() async {
    final result = await repository.getCountriesProvinces(type: 'intl');

    return result as List<CountryModel>;
  }

  Future<List<ProvinceModel>> getProvinces() async {
    final result = await repository.getCountriesProvinces(type: 'dom');

    return result as List<ProvinceModel>;
  }

  Future<StandardBenefitModel> getStandardBenefits({
    required String planId,
    required String withCovid,
    required String travelDays,
    required String userType,
  }) async {
    final result = await repository.getStandardBenefits(
      line: 'INTERNATIONAL',
      planId: planId,
      withCovid: withCovid,
      travelDays: travelDays,
      userType: userType,
      account: 'PESO',
      bdate: '1995-10-10',
    );
    final data = StandardBenefitModel.fromJson(result);
    return data;
  }

  Future<List<CustomizedBenefitModel>> getCustomizedBenefits({
    required String productPlan,
    required String travelDays,
    required String userType,
  }) async {
    final result = await repository.getCustomizedBenefits(
      line: 'INTERNATIONAL',
      productPlan: productPlan,
      travelDays: travelDays,
      userType: userType,
    );
    final data =
        result.map((res) => CustomizedBenefitModel.fromJson(res)).toList();
    final list = List<CustomizedBenefitModel>.from(data);
    return list;
  }
}

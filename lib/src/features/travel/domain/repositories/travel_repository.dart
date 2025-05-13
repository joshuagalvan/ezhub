import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:simone/src/features/travel/data/models/country_model.dart';
import 'package:simone/src/features/travel/data/models/province_model.dart';

class TravelRepository {
  Future<List<dynamic>> getCountriesProvinces({required String type}) async {
    final response = await http.post(
      Uri.parse(
        'http://10.52.2.124:9017/travel/getDestination_json/',
      ),
      body: {'table': type},
    );
    log('response ${response.body}');
    if (response.statusCode == 200) {
      var result = (jsonDecode(response.body)['results']);

      if (type == 'intl') {
        return (result as List)
            .map((res) => CountryModel.fromJson(res))
            .toList();
      } else {
        return (result as List)
            .map((res) => ProvinceModel.fromJson(res))
            .toList();
      }
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getStandardBenefits({
    required String line,
    required String planId,
    required String withCovid,
    required String travelDays,
    required String userType,
    required String account,
    required String bdate,
  }) async {
    final data = {
      "line": line,
      "plan_id": planId,
      "with_covid": withCovid,
      "travel_days": travelDays,
      "user_type": userType,
      "account": account,
      "bdate": bdate,
    };

    final response = await http.post(
      Uri.parse(
        'http://10.52.2.124:9017/travelcoverage/fetchCoverages_json/',
      ),
      body: data,
    );
    if (response.statusCode == 200) {
      var result = (jsonDecode(response.body));

      return result as Map<String, dynamic>;
    }
    return {};
  }

  Future<List> getCustomizedBenefits({
    required String line,
    required String productPlan,
    required String travelDays,
    required String userType,
  }) async {
    final data = {
      "line": line,
      "product_plan": productPlan,
      "travel_days": travelDays,
      "user_type": userType,
    };
    final response = await http.post(
      Uri.parse(
        'http://10.52.2.124:9017/travelcoverage/fetchAvailableAddons_json/',
      ),
      body: data,
    );
    if (response.statusCode == 200) {
      List<dynamic> result = (jsonDecode(response.body));

      result = result.map((item) {
        final Map<String, dynamic> updatedItem = Map.from(item);
        updatedItem['limits'] = updatedItem['limits'].replaceAll('PESO', '₱');
        return updatedItem;
      }).toList();
      return result;
    }
    return [];
  }
}

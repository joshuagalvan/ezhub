import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:simone/src/features/authentication/models/carcompany_model.dart';
import 'package:simone/src/features/authentication/models/cartype_model.dart';

class Api {
  final String _apiEndpoint = 'http://10.52.2.117:1004';

  Future _get(String url, {dynamic query}) async {
    Uri parsedUrl = Uri.parse(url).replace(queryParameters: query);
    final response = await http.get(parsedUrl);
    log('===========================================\n');
    log('Response Status Code:${response.statusCode}\n');
    log('Response Body: ${response.body}\n');
    log('Request: ${response.request!.url}\nBody: $query');
    log('===========================================\n');
    final data = jsonDecode(response.body);
    return data;
  }

  Future _post(String url, {dynamic parameters}) async {
    Uri parsedUrl = Uri.parse(url);
    final params = jsonEncode(parameters);
    final response = await http.post(parsedUrl,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: params);
    log('===========================================\n');
    log('Response Status Code:${response.statusCode}\n');
    log('Response Body: ${response.body}\n');
    log('Request: ${response.request!.url}\nRequest Body: $parameters');
    log('===========================================\n');
    final data = jsonDecode(response.body);
    return data;
  }

  Future<dynamic> verifyVehicle(key, value) async {
    return await _post("$_apiEndpoint/api/motor/verification", parameters: {
      key: value,
    });
  }

  Future<dynamic> searchProfileByKeyword(keyword, intm, bday) async {
    return await _get(
      "http://10.52.2.58/care-uat/client/getProfilef/?name=$keyword&bdate=$bday&intm_code=$intm",
    );
  }

  Future<dynamic> getProfileDetails(profileId) async {
    return await _get("$_apiEndpoint/api/profile/$profileId");
  }

  Future<dynamic> getTypeOfCover(type) async {
    return await _get("$_apiEndpoint/api/type-of-cover");
  }

  Future<dynamic> getDefaultRates(int tocId) async {
    return await _get("$_apiEndpoint/api/default-rates?toc_id=$tocId");
  }

  // Future<dynamic> getVTPLBI(int tocId) async {
  //   return await _post("http://10.52.2.124/motor/getSumInsuredList_json/",
  //       parameters: {
  //         'sumInsuredList': '1',
  //         'typeOfCover': tocId,
  //         'premium_type': 'bodily_injury'
  //       });
  // }

  // Future<dynamic> getVTPLPD(int tocId) async {
  //   return await _post("http://10.52.2.124/motor/getSumInsuredList_json/",
  //       parameters: {
  //         'sumInsuredList': '1',
  //         'typeOfCover': tocId,
  //         'premium_type': 'property_damage'
  //       });
  // }

  Future<dynamic> getCarBrands() async {
    return await _get("$_apiEndpoint/api/car-brands");
  }

  Future<dynamic> getCarModels(String carCompanyId) async {
    return await _get(
        "$_apiEndpoint/api/car-models?car_company_id=$carCompanyId");
  }

  Future<dynamic> getCarVariants({
    required String carModel,
    required String carModelId,
    required String typeOfCover,
    required String yearManufactured,
  }) async {
    return await _get("$_apiEndpoint/api/car-variants", query: {
      'car_model': carModel,
      'car_model_id': carModelId,
      'toc': typeOfCover,
      'year': yearManufactured,
    });
  }

  Future<dynamic> getQuotation() async {
    return await _get("$_apiEndpoint/api/motor/quotation");
  }

  Future<dynamic> getQuotationDetails(int id) async {
    return await _get("$_apiEndpoint/api/motor/quotation/$id");
  }

  Future<dynamic> saveQuotation(params) async {
    return await _post("$_apiEndpoint/api/motor/quotation", parameters: params);
  }

  Future<Map<String, dynamic>> getBranch({required String agentCode}) async {
    final result = await _get(
        'http://10.52.254.164:3321/bridge_api.php?api_name=api1&agentCode=$agentCode');

    return result[0] as Map<String, dynamic>;
  }

  Future<List<CarCompanyList>> getCarCompanyList(
      {required String typeOfCoverValue}) async {
    final result = await _get(
        'http://10.52.254.164:3321/bridge_api.php?api_name=api3&typeOfCoverValue=$typeOfCoverValue');

    final data = (result as List)
        .map((value) => CarCompanyList.fromJson(value))
        .toList();
    return data;
  }

  Future<CarTypeList> getCarTypeBody({
    required String typeOfCoverValue,
    required String carMakeModelId,
  }) async {
    final result = await _get(
        'http://10.52.254.164:3321/bridge_api.php?api_name=api5&car_make_model_id=$carMakeModelId&toc=$typeOfCoverValue');

    final data = CarTypeList.fromJson(result);
    return data;
  }
}

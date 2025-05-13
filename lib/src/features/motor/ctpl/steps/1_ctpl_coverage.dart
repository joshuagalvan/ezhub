import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:http/http.dart' as http;

class CTPLCoverage extends StatefulHookWidget {
  const CTPLCoverage({
    super.key,
    required this.policy,
    required this.updatePolicy,
    required this.form,
  });

  final ValueNotifier<CTPLPolicy> policy;
  final Function(CTPLPolicy) updatePolicy;
  final GlobalKey<FormState>? form;

  @override
  State<CTPLCoverage> createState() => _CTPLCoverage();
}

class _CTPLCoverage extends State<CTPLCoverage> {
  final controller = Get.put(ProfileController());
  final dateNow = DateTime.now();
  final policyPeriodFromController = TextEditingController();
  final policyPeriodToController = TextEditingController();

  String branchName = '';
  String branchCode = '';
  String? lastDigit;
  String? tocName;
  String inceptionDate = '', expirationDate = '';
  String? basicPremium;
  String? ctplValueText;
  String? ctplTextValue;
  bool? ctplBool;
  double locTax = 0;
  double docStamp = 0;
  double Vat = 0;
  double lVat = 0;
  double totalPrem = 0;
  double ltoInter = 50.40;
  bool isVehicleTypeLoading = false;

  String? ctplValue;
  List<Map<String, dynamic>> ctplCoverage = [
    {'text': 'YES', 'value': '2'},
    {'text': 'NO', 'value': '1'},
  ];

  List<dynamic> manufactureYear = [];
  List<dynamic> toc = []; //vehicleType
  String? tocID;
  Map<String, dynamic>? tocBasicPremiumMap;
  String? tocBasicPremium;

  getBranch() async {
    var userData = await controller.getUserData();
    try {
      final response = await http.get(Uri.parse(
          'http://10.52.2.124/ezhub/getBranch_json/?intm_code=${userData?.agentCode ?? ''}'));
      var result = (jsonDecode(response.body)[0]);
      locTax = double.parse(result['local_tax']);
      setState(() {
        branchName = (result['name']);
        branchCode = result['code'];
      });
    } catch (_) {}
  }

  Future<void> getVehicleType() async {
    setState(() {
      isVehicleTypeLoading = true;
    });
    final response = await http.post(
      Uri.parse(
          'http://10.52.2.124/ctpl/getVehicleTypeOfCoverByCarStateId_json/'),
      body: {
        'state_id': ctplValue,
        // 'simoneApp': 'MTcyNTg1MzAwN18yMDI0MDkwOV9NMDlKSTAwMDAx'
      },
    );

    final result = jsonDecode(response.body);
    final data = (result as List).map((car) => car).toList();

    toc = data;
    setState(() {
      isVehicleTypeLoading = false;
    });
  }

  getLastDigit() {
    final digits =
        widget.policy.value.plateNumber!.replaceAll(RegExp(r'[^0-9]'), '');
    lastDigit = digits[digits.length - 1];
  }

  getPolicyPeriod() {
    DateTime startDate = DateTime(dateNow.year, 1, 1);
    switch (lastDigit) {
      case '1':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 1, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 1, startDate.day));
        break;
      case '2':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 2, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 2, startDate.day));
        break;
      case '3':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 3, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 3, startDate.day));
        break;
      case '4':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 4, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 4, startDate.day));
        break;
      case '5':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 5, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 5, startDate.day));
        break;
      case '6':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 6, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 6, startDate.day));
        break;
      case '7':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 7, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 7, startDate.day));
        break;
      case '8':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 8, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 8, startDate.day));
        break;
      case '9':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 9, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 9, startDate.day));
        break;
      case '0':
        inceptionDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year, startDate.month + 10, startDate.day));
        expirationDate = DateFormat('yyyy-MM-dd').format(
            DateTime(startDate.year + 1, startDate.month + 10, startDate.day));
        break;
    }
    setState(() {});
  }

  getManufactureYear() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124/ctpl/getManufactureYearList_json/'),
          body: {
            'is_brand_new': ctplTextValue,
            // 'simoneApp': 'MTcyNTg1MzAwN18yMDI0MDkwOV9NMDlKSTAwMDAx'
          });
      var result = (jsonDecode(response.body));

      manufactureYear = [];
      for (var row in result) {
        manufactureYear.add(row);
      }

      widget.policy.value = widget.policy.value.copyWith(
        listManufactureYear: manufactureYear,
      );
      widget.updatePolicy(widget.policy.value);
      setState(() {});
    } catch (_) {}
  }

  getPreviousDetails() async {
    ctplValue = (ctplCoverage.firstWhereOrNull((value) =>
        (widget.policy.value.isPolicyBrandNew) == value['text'])?['value']);
    ctplTextValue = widget.policy.value.isPolicyBrandNew ?? '';
    if (ctplValue != null) {
      await getVehicleType();
      // getManufactureYear();
    }
    ctplValueText = widget.policy.value.ctplCoverage ?? '';

    if (toc.isNotEmpty) {
      tocBasicPremiumMap = toc.firstWhere((value) =>
          (widget.policy.value.vehicleTypeName ?? '') == value['name']);
    }
    inceptionDate = widget.policy.value.inceptionDate ?? '';
    expirationDate = widget.policy.value.expiryDate ?? '';
  }

  String getClass() {
    switch (tocID) {
      case '4':
        return 'AC and Tourist Cars';
      case '3':
        return 'Heavy Trucks & Private Bus';
      case '2':
        return 'Light/Medium Truck';
      case '7':
        return 'Motorcycles/Tricycles';
      case '6':
        return 'PUB and Tourist Bus';
      case '5':
        return 'Taxi, PUJ and Mini Bus';
      case '15':
        return 'Trailers';
      case '1':
        return 'Private Cars';
      default:
        return '';
    }
  }

  @override
  void initState() {
    getLastDigit();
    getBranch();
    getPreviousDetails();
    getManufactureYear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.form,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                branch,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                branchName,
                style: const TextStyle(
                  color: ColorPalette.primaryColor,
                  fontSize: 17.0,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(
              plateNumberText,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            InputTextField(
              readOnly: true,
              initialValue: widget.policy.value.plateNumber,
            ),
            const SizedBox(height: 10),
            const Text(
              "Is Your Vehicle Brand New?:",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            CustomDropdownButton<String>(
              value: ctplValue,
              items: ctplCoverage.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: Text(item['text']),
                );
              }).toList(),
              onChanged: (value) {
                tocName = null;
                ctplValue = value;
                getVehicleType();
                setState(() {
                  tocBasicPremiumMap = null;
                  if (value == '1') {
                    ctplValueText = "1 YEAR COVERAGE";
                    ctplTextValue = "NO";
                    ctplBool = false;
                    getPolicyPeriod();
                  } else if (value == '2') {
                    ctplValueText = "3 YEAR COVERAGE";
                    ctplBool = true;
                    ctplTextValue = "YES";
                    inceptionDate = DateFormat('yyyy-MM-dd').format(dateNow);
                    expirationDate = DateFormat('yyyy-MM-dd').format(
                        DateTime(dateNow.year + 3, dateNow.month, dateNow.day));
                  }

                  widget.policy.value = widget.policy.value.copyWith(
                    isPolicyBrandNew: ctplTextValue,
                    ctplCoverage: ctplValueText,
                    inceptionDate: inceptionDate,
                    expiryDate: expirationDate,
                  );
                  widget.updatePolicy(widget.policy.value);
                  setState(() {});
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text(
              coverageCTPL,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            InputTextField(
              readOnly: true,
              controller: TextEditingController(text: ctplValueText),
            ),
            const SizedBox(height: 10),
            const Text(
              "Vehicle Type",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            CustomDropdownButton<Map<String, dynamic>>(
              value: tocBasicPremiumMap,
              items: toc.map((e) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: e,
                  child: Text(e['name'].toString()),
                );
              }).toList(),
              isLoading: isVehicleTypeLoading,
              onChanged: (value) {
                basicPremium = value!['basic_premium'].toString();
                setState(() {
                  docStamp =
                      ((double.parse(basicPremium.toString()) / 4).ceil()) * .5;
                  Vat = double.parse(basicPremium.toString()) * 0.12;
                  lVat = (double.parse(locTax.toString()) *
                          double.parse(basicPremium.toString())) /
                      100;
                  totalPrem = double.parse(basicPremium.toString()) +
                      docStamp +
                      Vat +
                      lVat +
                      ltoInter;
                });

                for (var row in toc) {
                  if (value["basic_premium"] ==
                      row["basic_premium"].toString()) {
                    tocID = row['id'];
                    tocName = row['name'].toString();
                    tocBasicPremiumMap = row;
                    tocBasicPremium = row['basic_premium'];
                  }
                }
                widget.policy.value = widget.policy.value.copyWith(
                  yearManufactured: null,
                  vehicleTypeId: tocID ?? '',
                  vehicleTypeName: tocName ?? '',
                  basicPremium: basicPremium,
                  dst: docStamp.toStringAsFixed(2),
                  vat: Vat.toStringAsFixed(2),
                  lgt: lVat.toString(),
                  lto: ltoInter.toString(),
                  totalPremium: totalPrem.toStringAsFixed(2),
                );
                widget.updatePolicy(widget.policy.value);
                getManufactureYear();
              },
              validator: (value) {
                if (value == null) {
                  return 'This field is required';
                }

                if (value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            // DropdownMenu(
            //   width: 400,
            //   menuHeight: 350,
            //   controller: tocController,
            //   hintText: "Choose Option",
            //   requestFocusOnTap: true,
            //   enableFilter: true,
            //   dropdownMenuEntries: toc.map((e) {
            //     return DropdownMenuEntry(
            //       label: e['name'].toString(),
            //       value: e['basic_premium'].toString(),
            //     );
            //   }).toList(),
            //   onSelected: (value) {
            //     basicPremium = value;
            //     setState(() {
            //       docStamp =
            //           ((double.parse(basicPremium.toString()) / 4).ceil()) *
            //               .5;
            //       Vat = double.parse(basicPremium.toString()) * 0.12;
            //       lVat = (double.parse(locTax.toString()) *
            //               double.parse(basicPremium.toString())) /
            //           100;
            //       totalPrem = double.parse(basicPremium.toString()) +
            //           docStamp +
            //           Vat +
            //           lVat +
            //           ltoInter;
            //     });
            //     for (var row in toc) {
            //       if (value == row["basic_premium"].toString()) {
            //         tocID = row['id'];
            //         tocName = row['name'];
            //       }
            //     }
            //     getManufactureYear();
            //   },
            // ),
            const SizedBox(height: 10),
            const Text(
              "Period of Issuance",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Inception",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InputTextField(
                        readOnly: true,
                        controller: TextEditingController(text: inceptionDate),
                        onChanged: (value) {
                          widget.policy.value = widget.policy.value
                              .copyWith(inceptionDate: value);
                          widget.updatePolicy(widget.policy.value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expiry",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InputTextField(
                        readOnly: true,
                        controller: TextEditingController(text: expirationDate),
                        onChanged: (value) {
                          widget.policy.value =
                              widget.policy.value.copyWith(expiryDate: value);
                          widget.updatePolicy(widget.policy.value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

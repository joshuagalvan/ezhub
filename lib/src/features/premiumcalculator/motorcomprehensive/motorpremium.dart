// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/carcompany_model.dart';
import 'package:simone/src/features/authentication/models/carmake_model.dart';
import 'package:simone/src/features/authentication/models/quotation_details_model.dart';
import 'package:simone/src/features/motor/productmotor.dart';
import 'package:simone/src/features/navbar/quotation/quotationlist.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/helpers/mysql.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:simone/src/utils/extensions.dart';

class MotorPremiumPageView extends StatefulWidget {
  const MotorPremiumPageView({
    super.key,
    required this.quote,
    required this.onPrevPressed,
  });

  final Function() quote;
  final Function() onPrevPressed;

  @override
  State<MotorPremiumPageView> createState() => _MotorPremiumPageViewState();
}

class _MotorPremiumPageViewState extends State<MotorPremiumPageView> {
  late dynamic quotes;
  String? typeofcoverValue,
      carMakeValue,
      carCompanyValue,
      odRate,
      aonRate,
      vtplBIValue,
      vtplPDValue,
      branchName,
      ratesValue,
      yearValue,
      carTypeName,
      variantValue,
      deductible;

  dynamic fmv = 0;
  double totalPrem = 0,
      basicPremium = 0,
      docStamp = 0,
      Vat = 0,
      lVat = 0,
      OD = 0,
      AON = 0;

  @override
  void initState() {
    super.initState();
    getQuote();
  }

  getQuote() async {
    quotes = await widget.quote();
    setState(() {
      typeofcoverValue = quotes!['toc'].toString();
      carCompanyValue = quotes!['carCompany'].toString();
      carMakeValue = quotes!['carMake'].toString();
      odRate = quotes!['odRate'].toString();
      aonRate = quotes!['aonRate'].toString();
      vtplBIValue = quotes!['vtplbiValue'].toString();
      vtplPDValue = quotes!['vtplpdValue'].toString();
      branchName = quotes!['branch'].toString();
      ratesValue = quotes!['rates'].toString();
      yearValue = quotes!['year'].toString();
      carTypeName = quotes!['carType'].toString();
      variantValue = quotes!['carVariant'].toString();
      fmv = quotes!['fmvValue'].toString();
      deductible = quotes!['deduc'].toString();
      totalPrem = double.parse(quotes!['totalPrem'].toString());
      basicPremium = double.parse(quotes!['basicPrem'].toString());
      docStamp = double.parse(quotes!['docStamp'].toString());
      Vat = double.parse(quotes!['vat'].toString());
      lVat = double.parse(quotes!['localvat'].toString());
      OD = double.parse(quotes!['od'].toString());
      AON = double.parse(quotes!['aon'].toString());
    });
  }

  String status = "Not Issued";
  String? agentCode = '';
  int refCounter = 1;
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final name = TextEditingController();
  String refNo = '';
  String currentYear = DateFormat('yyyy').format(DateTime.now());
  String currentMonth = DateFormat('MM').format(DateTime.now());
  String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  String periodOfInsurance = "TBA";
  final quotationExpiry = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 30)));

  Future<List<CarCompanyList>> getCarCompany() async {
    if (typeofcoverValue == '') {
      return [];
    }
    try {
      final response = await http.post(Uri.parse(
          'http://10.52.2.124/motorquotation/getCarCompanyList_json/?toc=$typeofcoverValue'));
      final carCompany = (jsonDecode(response.body)) as List;

      if (response.statusCode == 200) {
        return carCompany.map((e) {
          final map = e as Map<String, dynamic>;
          return CarCompanyList.fromJson(map);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<List<CarMakeList>> getCarMake() async {
    if (carCompanyValue == '') {
      return [];
    }
    try {
      final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motorquotation/getPiraCarModelByCarCompanyId_json/'),
          body: {'car_company_id': carCompanyValue});

      final carMake = (jsonDecode(response.body)) as List;

      if (response.statusCode == 200) {
        return carMake.map((e) {
          final map = e as Map<String, dynamic>;
          return CarMakeList(id: map['id'], name: map['name']);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  getReferenceNumber() async {
    var mysql = await mySQL().connect();
    var result = await mysql.query("""
          SELECT * FROM agent_quotes
          WHERE MONTH(created_date) = MONTH(NOW())
          AND YEAR(created_date) = YEAR(NOW())
          ORDER BY ref_number desc LIMIT 1""");

    if (result.isNotEmpty) {
      for (var row in result) {
        refCounter = row[10];
      }
      refCounter += 1;
    }
  }

  Future<int> saveQuote({bool isIssuePolicy = false}) async {
    final controller = Get.put(ProfileController());
    var userData = await controller.getUserData();

    List<CarCompanyList> carCompanyName = await getCarCompany();
    int index =
        carCompanyName.indexWhere((element) => element.id == carCompanyValue);
    CarCompanyList carCompName = carCompanyName[index];

    List<CarMakeList> carMakeName = await getCarMake();
    int indexMake =
        carMakeName.indexWhere((element) => element.id == carMakeValue);
    CarMakeList carMaName = carMakeName[indexMake];

    var details = {
      "od_rate": odRate,
      "aon_rate": aonRate,
      "vtpl_bi": vtplBIValue,
      "vtpl_pd": vtplPDValue,
      "status": status,
      "period_of_insurance": periodOfInsurance,
      "quotation_expiry": quotationExpiry,
      "ref_number": refNo,
      "intermediary": userData?.agentCode ?? '',
      "ref_counter": refCounter,
      "created_date": currentDate,
      "name": name.text,
      "email": email.text,
      "branch": branchName,
      "toc": typeofcoverValue,
      "rate": ratesValue,
      "year": yearValue,
      "car_company": carCompName.name,
      "car_make": carMaName.name,
      "car_type": carTypeName,
      "car_variant": variantValue,
      "fmv": fmv,
      "deductible": deductible,
      "total_premium": totalPrem,
      "basic_premium": basicPremium,
      "doc_stamp": docStamp,
      "vat": Vat,
      "local_tax": lVat,
      "od": OD,
      "aon": AON,
    };
    debugPrint('details $details', wrapWidth: 768);
    var result = await Api().saveQuotation(details);

    if (result != null) {
      if (isIssuePolicy == false) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.warning,
          title: 'Premium Calculator',
          desc: 'Quotation has been saved!',
          btnOkText: 'Go to Quotation List',
          btnOkOnPress: () {
            Navigator.pop(context);
            Get.to(() => const QuotationList());
          },
        ).show();
      }
    }
    refCounter = 1;
    return int.parse(result['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(defaultSizePrem),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 2,
                      color: Colors.grey[200]!,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        totalPremium,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '₱${totalPrem.toString().formatWithCommas()}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      premBreak,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _rowTextData(
                      title: 'Basic Premium:',
                      data: basicPremium.toString().formatWithCommas(),
                    ),
                    _rowTextData(
                      title: "Documentary Stamp Tax:",
                      data: docStamp.toString().formatWithCommas(),
                    ),
                    _rowTextData(
                      title: "Value Added Tax:",
                      data: Vat.toString().formatWithCommas(),
                    ),
                    _rowTextData(
                      title: "Local Government Tax:",
                      data: lVat.toString().formatWithCommas(),
                    ),
                    const Divider(),
                    const SizedBox(height: 5),
                    const Text(
                      benefits,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _rowTextData(
                      title: "Own Damage/Theft:",
                      data: OD.toString().formatWithCommas(),
                    ),
                    _rowTextData(
                      title: "Acts of Nature:",
                      data: AON.toString().formatWithCommas(),
                    ),

                    _rowTextData(
                      title: "RSCC & Auto Personal Accident:",
                      data: included,
                    ),
                    _rowTextData(
                      title: "VTPL - Bodily Injury:",
                      data: vtplBIValue.toString().formatWithCommas(),
                    ),
                    _rowTextData(
                      title: "VTPL - Property Damage:",
                      data: vtplPDValue.toString().formatWithCommas(),
                    ),

                    // const Row(
                    //   children: [
                    //     Text(
                    //       "Auto Personal Accident:   ",
                    //       style: TextStyle(
                    //         fontSize: 15.0,
                    //         fontFamily: 'OpenSans',
                    //         color: Color(0xfffe5000),
                    //       ),
                    //     ),
                    //     Text(included)
                    //   ],
                    // ),
                    // Divider(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: (clientName),
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                          ),
                          hintText: (clientName),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xfffe5000)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(
                              color: Color(0xfffe5000),
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Please Enter Client's Name";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            labelText: (eMail),
                            labelStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'OpenSans',
                            ),
                            hintText: (eMail),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xfffe5000)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(
                                color: Color(0xfffe5000),
                                width: 2.0,
                              ),
                            )),
                        validator: (text) {
                          if (text == null ||
                              text.isEmpty ||
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                  .hasMatch(text)) {
                            return "Please Enter a Valid Email Address";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: widget.onPrevPressed,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xfffe5000),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await getReferenceNumber();
                      refNo =
                          'EZ-MC-FQ-$currentYear-$currentMonth-${refCounter.toString().padLeft(6, '0')}';
                      saveQuote();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xfffe5000),
                  ),
                  child: const Text(
                    savequote,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await getReferenceNumber();
                      refNo =
                          'EZ-MC-FQ-$currentYear-$currentMonth-${refCounter.toString().padLeft(6, '0')}';
                      saveQuote(isIssuePolicy: true).then((id) async {
                        var result = await Api().getQuotationDetails(id);
                        final data = QuotationDetails.fromJson(result['data']);

                        Get.to(
                          () => Productmotor(
                            from: 'quotation',
                            quotation: data,
                          ),
                        );
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xfffe5000),
                  ),
                  child: const Text(
                    issuePolicy,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70)
          ],
        ),
      ),
    );
  }

  Widget _rowTextData({required String title, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontFamily: 'OpenSans',
              color: Color(0xfffe5000),
            ),
          ),
          Text(
            '₱$data',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

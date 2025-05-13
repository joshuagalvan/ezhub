// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/carcompany_model.dart';
import 'package:simone/src/features/authentication/models/carmake_model.dart';
import 'package:simone/src/features/authentication/models/cartype_model.dart';
import 'package:simone/src/features/authentication/models/carvariant_model.dart';
import 'package:simone/src/features/authentication/models/vtplbi_model.dart';
import 'package:simone/src/features/authentication/models/vtplpd_model.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/utils/colorpalette.dart';

class MotorQuotationPageView extends StatefulWidget {
  const MotorQuotationPageView({
    super.key,
    this.motorField,
    required this.onNextPressed,
  });
  final Function(String, dynamic)? motorField;
  final Function() onNextPressed;

  @override
  State<MotorQuotationPageView> createState() => _MotorQuotationPageViewState();
}

class _MotorQuotationPageViewState extends State<MotorQuotationPageView> {
  String? branchName, carCompanyName;
  double locTax = 0;
  dynamic fmv = 0;
  String? tocID;
  String? deductible;
  List<dynamic> toc = [];
  List<dynamic> ratesList = [];
  String? carTypeName;
  dynamic objToc;
  dynamic odRate, aonRate, commissionRate;
  String? agentCode = '';
  List<VTPLBIList> vtplb = [];
  List<VTPLPDList> vtplp = [];

  String status = "Not Issued";
  String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  final periodOfInsurance = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 365)));
  final quotationExpiry = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 30)));
  String currentDateToday = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String currentDateTodayWord = DateFormat('MMMM d y').format(DateTime.now());
  final quotationExpiryWord = DateFormat('MMMM d y')
      .format(DateTime.now().add(const Duration(days: 30)));
  final periodOfInsuranceWord = DateFormat('MMMM d y')
      .format(DateTime.now().add(const Duration(days: 365)));
  String currentYear = DateFormat('yyyy').format(DateTime.now());
  String currentMonth = DateFormat('MM').format(DateTime.now());
  String refNo = '';
  int refCounter = 1;

  @override
  void initState() {
    super.initState();
    getBranch();
    getToc();
  }

  getToc() async {
    var result = await Api().getTypeOfCover('motor_comprehensive');
    setState(() {
      toc = result['data'];
    });
  }

  getRates({required int toc}) async {
    var result = await Api().getDefaultRates(toc);
    setState(() {
      ratesList = result['data'];
    });
  }

  getBranch() async {
    final controller = Get.put(ProfileController());
    var userData = await controller.getUserData();
    try {
      final response = await http.get(Uri.parse(
          'http://10.52.2.124/ezhub/getBranch_json/?intm_code=${userData?.agentCode ?? ''}'));
      var result = (jsonDecode(response.body)[0]);
      locTax = double.parse(result['local_tax']);
      widget.motorField!('localTax', locTax);
      setState(() {
        branchName = (result['name']);
        widget.motorField!('branch', branchName);
      });
    } catch (_) {}
  }

  Future<List<CarCompanyList>> getCarCompany() async {
    if (typeofcoverValue == null) {
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
    if (carCompanyValue == null) {
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

  Future<List<CarTypeList>> getCarType() async {
    if (carMakeValue == null) {
      return [];
    }
    try {
      final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motorquotation/getCarTypeOfBodyByPiraModel_json/'),
          body: {'car_make_model_id': carMakeValue, 'toc': typeofcoverValue});

      final carType = (jsonDecode(response.body));
      carTypeName = carType['type'];
      widget.motorField!('carType', carTypeName);

      if (response.statusCode == 200) {
        return [carType].map((e) {
          final map = e as Map<String, dynamic>;
          return CarTypeList(
              id: map['id'],
              status: map['status'],
              typeId: map['typeId'],
              type: map['type'],
              capacity: map['capacity']);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<List<CarVariant>> getCarVariant() async {
    if (carMakeValue == null) {
      return [];
    }
    try {
      List<CarMakeList> carModel = await getCarMake();
      int index = carModel.indexWhere((element) => element.id == carMakeValue);
      CarMakeList carMake = carModel[index];
      final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motorquotation/getCarVariantByCarModelId_json/'),
          body: {
            'car_make_model_id': carMakeValue,
            'toc_description': typeofcoverValue,
            'car_model': carMake.name,
            'year': yearValue
          });
      final carVariant = (jsonDecode(response.body)['list']) as List;

      if (response.statusCode == 200) {
        return carVariant.map((e) {
          final map = e as Map<String, dynamic>;
          return CarVariant(
            id: map['id'],
            name: map['name'],
          );
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future getFmv() async {
    if (variantValue == null) {
      return [];
    }
    try {
      List<CarMakeList> carModel = await getCarMake();
      int index = carModel.indexWhere((element) => element.id == carMakeValue);
      CarMakeList carMake = carModel[index];

      // if (typeofcoverValue == "Private Car") {
      //   tocID = "1";
      // } else if (typeofcoverValue == "Commercial Vehicle - Light/Medium") {
      //   tocID = "2";
      // } else if (typeofcoverValue == "Commercial Vehicle - Heavy") {
      //   tocID = "3";
      // } else {
      //   tocID = "4";
      // }

      final response = await http.post(
          Uri.parse('http://10.52.2.124/motorquotation/getFmvLimit_json/'),
          body: {
            'car_make_model_id': carMakeValue,
            'toc_description': typeofcoverValue,
            'car_model': carMake.name,
            'year': yearValue,
            'car_variance': variantValue,
            'toc_id': tocID
          });

      vtplb = await getVtplBI();
      vtplp = await getVtplPD();
      setState(() {
        fmv = (jsonDecode(response.body));
        fmvValue.text = fmv ?? "0";
        widget.motorField!('fmv', fmvValue.text);

        vtplb = vtplb
            .where((i) => int.parse(i.name) <= int.parse(fmv ?? '0'))
            .toList();

        vtplp = vtplp
            .where((i) => int.parse(i.name) <= int.parse(fmv ?? '0'))
            .toList();
      });

      return true;
    } on SocketException {
      throw Exception('No Internet');
    }
  }

  Future getVtplBI() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124/motor/getSumInsuredList_json/'),
          body: {
            'sumInsuredList': '1',
            'typeOfCover': tocID,
            'premium_type': 'bodily_injury'
          });

      final vtplBi = (jsonDecode(response.body)) as List;

      List<VTPLBIList> list = [];
      if (response.statusCode == 200) {
        list = vtplBi.map((e) {
          final map = e as Map<String, dynamic>;
          return VTPLBIList.fromJson(map);
        }).toList();
      }
      setState(() {});
      return list;
    } on SocketException {
      throw Exception('No Internet');
    }
  }

  Future getVtplPD() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124/motor/getSumInsuredList_json/'),
          body: {
            'sumInsuredList': '1',
            'typeOfCover': tocID,
            'premium_type': 'property_damage'
          });

      final vtplPd = (jsonDecode(response.body)) as List;
      List<VTPLPDList> list = [];
      if (response.statusCode == 200) {
        list = vtplPd.map((e) {
          final map = e as Map<String, dynamic>;
          return VTPLPDList.fromJson(map);
        }).toList();
      }
      setState(() {
        OD = double.parse(odRate.toString()) * double.parse(fmv.toString());

        AON = double.parse(aonRate.toString()) * double.parse(fmv.toString());

        basicPremium = double.parse(OD.toString()) +
            double.parse(AON.toString()) +
            double.parse(vtplBIValue ?? '0') +
            double.parse(vtplPDValue ?? '0');
        basicPremium * double.parse(commissionRate.toString());

        docStamp = ((basicPremium / 4).ceil()) * .5;
        Vat = basicPremium * 0.12;
        lVat = (double.parse(locTax.toString()) * basicPremium) / 100;
        lVatNoAON = (double.parse(locTax.toString()) * basicPremiumNoAON) / 100;
        totalPrem = basicPremium + docStamp + Vat + lVat;
      });
      return list;
    } on SocketException {
      throw Exception('No Internet');
    }
  }

  CarCompanyList? selectedCarCompany;
  bool? isChecked = false;
  String? typeofcoverValue;
  String? yearValue;
  String? carCompanyValue;
  String? carMakeValue;
  String? carTypeValue;
  String? variantValue;
  String? deducValue;
  dynamic ratesValue;
  String? vtplBIValue;
  String? vtplPDValue;
  double BIValue = 0;
  double PDValue = 0;
  // String? ratesValueOD = null;
  // String? ratesValueTH = null;
  // String? ratesValueAON = null;
  // String? ratesValueRSCC = null;
  double OD = 0;
  //double Theft = 0;
  double AON = 0;
  double basicPremium = 0;
  double commissionRateWhole = 0;
  double odRateWhole = 0;
  double aonRateWhole = 0;
  double basicPremiumNoAON = 0;
  double totalPremNoAON = 0;
  double docStamp = 0;
  double Vat = 0;
  double lVat = 0;
  double lVatNoAON = 0;
  double totalPrem = 0;
  double totalCommission = 0;
  final email = TextEditingController();
  final name = TextEditingController();
  TextEditingController fmvValue = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(
              //     child: Column(
              //   children: [
              //     const Text(
              //       branch,
              //       style: TextStyle(
              //           fontSize: 20.0,
              //           fontFamily: 'OpenSans',
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       branchName ?? "",
              //       style: TextStyle(
              //           color: Color(0xfffe5000),
              //           fontSize: 17.0,
              //           fontFamily: 'OpenSans',
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // )),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    typeofCover,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  CustomDropdownButton(
                    value: typeofcoverValue,
                    items: toc.map((item) {
                      return DropdownMenuItem(
                        value: item["classification"].toString(),
                        child: Text(item["classification"].toString()),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Please Select Type of Cover";
                      }
                      return null;
                    },
                    onChanged: (value) async {
                      final newValue = value as String;
                      widget.motorField!('toc', newValue);
                      setState(() {
                        if (newValue.toLowerCase() == "private cars") {
                          tocID = "1";
                        } else if (newValue.toLowerCase() ==
                            "commercial vehicle - trucks - light & medium") {
                          tocID = "2";
                        } else if (newValue.toLowerCase() ==
                            "commercial vehicle - trucks - heavy") {
                          tocID = "3";
                        } else if (newValue.toLowerCase() ==
                            "motorcycle - big bikes") {
                          tocID = "4";
                        } else {
                          tocID = "5";
                        }

                        typeofcoverValue = newValue;
                        ratesValue = null;
                        yearValue = null;
                        carCompanyValue = null;
                        carMakeValue = null;
                        carTypeValue = null;
                        variantValue = null;
                        fmvValue.text = '';
                        fmv = 0;
                        OD = 0;
                        //Theft = 0;
                        AON = 0;
                        basicPremium = 0;
                        docStamp = 0;
                        Vat = 0;
                        lVat = 0;
                        totalPrem = 0;
                      });
                      for (var row in toc) {
                        if (newValue == row["classification"].toString()) {
                          objToc = row;
                          widget.motorField!('deduc', objToc['deductible']);
                          getRates(toc: row['id']);
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          rates,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        CustomDropdownButton(
                          items: ratesList.map((item) {
                            var ratePercent = double.parse(item['rate']) * 100;
                            return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(ratePercent.toStringAsFixed(2)),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Please Select Rates";
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            setState(() {
                              // ratesValue = newValue!;
                              // basicPremium = double.parse(ratesValue ?? '') *
                              //     double.parse(fmv.toString());
                              yearValue = null;
                              carCompanyValue = null;
                              carMakeValue = null;
                              carTypeValue = null;
                              fmvValue.text = '';
                              variantValue = null;
                              fmv = 0;
                              OD = 0;
                              //Theft = 0;
                              AON = 0;
                              basicPremium = 0;
                              docStamp = 0;
                              Vat = 0;
                              lVat = 0;
                              totalPrem = 0;
                              vtplBIValue = null;
                              vtplPDValue = null;

                              for (var row in ratesList) {
                                if (newValue == row['id'].toString()) {
                                  odRate = row['own_damage'];
                                  widget.motorField!('odRate', odRate);
                                  aonRate = row['act_of_nature'];
                                  widget.motorField!('aonRate', aonRate);
                                  ratesValue = row['rate'];
                                  widget.motorField!('rates', ratesValue);
                                  commissionRate = row['commission'];
                                  widget.motorField!('comRate', commissionRate);
                                }
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          year,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        CustomDropdownButton(
                          value: yearValue,
                          items: const [
                            DropdownMenuItem<String>(
                                value: "2024", child: Text("2024")),
                            DropdownMenuItem<String>(
                                value: "2023", child: Text("2023")),
                            DropdownMenuItem<String>(
                                value: "2022", child: Text("2022")),
                            DropdownMenuItem<String>(
                                value: "2021", child: Text("2021")),
                            DropdownMenuItem<String>(
                                value: "2020", child: Text("2020")),
                            DropdownMenuItem<String>(
                                value: "2019", child: Text("2019")),
                            DropdownMenuItem<String>(
                                value: "2018", child: Text("2018")),
                            DropdownMenuItem<String>(
                                value: "2017", child: Text("2017")),
                            DropdownMenuItem<String>(
                                value: "2016", child: Text("2016")),
                            DropdownMenuItem<String>(
                                value: "2015", child: Text("2015")),
                            DropdownMenuItem<String>(
                                value: "2014", child: Text("2014")),
                            DropdownMenuItem<String>(
                                value: "2013", child: Text("2013")),
                            DropdownMenuItem<String>(
                                value: "2012", child: Text("2012")),
                            DropdownMenuItem<String>(
                                value: "2011", child: Text("2011")),
                            DropdownMenuItem<String>(
                                value: "2010", child: Text("2010")),
                            DropdownMenuItem<String>(
                                value: "2009", child: Text("2009")),
                          ],
                          validator: (value) {
                            if (value == null) {
                              return "Please Select Year";
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            widget.motorField!('year', newValue);
                            setState(() {
                              yearValue = newValue!;
                              carCompanyValue = null;
                              carMakeValue = null;
                              carTypeValue = null;
                              variantValue = null;
                              fmv = 0;
                              fmvValue.text = '';

                              OD = 0;
                              //Theft = 0;
                              AON = 0;
                              basicPremium = 0;
                              docStamp = 0;
                              Vat = 0;
                              lVat = 0;
                              totalPrem = 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    carCompany,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  FutureBuilder<List<CarCompanyList>>(
                    future: getCarCompany(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomDropdownButton(
                          hintText: 'Choose Option',
                          value: carCompanyValue,
                          items: snapshot.data!.map((e) {
                            return DropdownMenuItem(
                              value: e.id.toString(),
                              child: Text(e.name.toString()),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Please Select Car Company";
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            widget.motorField!('carCompany', newValue);
                            setState(() {
                              carCompanyValue = newValue;
                              carMakeValue = null;
                              carTypeValue = null;
                              variantValue = null;
                              fmv = 0;
                              fmvValue.text = '';

                              OD = 0;
                              //Theft = 0;
                              AON = 0;
                              basicPremium = 0;
                              docStamp = 0;
                              Vat = 0;
                              lVat = 0;
                              totalPrem = 0;
                            });
                          },
                        );
                        // DropdownSearch<CarCompanyList>(
                        //   items: (filter, infiniteScrollProps) => data,

                        //   itemAsString: (CarCompanyList car) => car.name!,
                        //   selectedItem: selectedCarCompany,
                        //   decoratorProps: DropDownDecoratorProps(
                        //     decoration: InputDecoration(
                        //       hintText: 'Choose Option',
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide: BorderSide(
                        //           color: ColorPalette.greyE3,
                        //           width: 2,
                        //         ),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide: BorderSide(
                        //           color: ColorPalette.primaryColor,
                        //           width: 2,
                        //         ),
                        //       ),
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide: const BorderSide(
                        //           color: Colors.red,
                        //           width: 2,
                        //         ),
                        //       ),
                        //       disabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide: BorderSide(
                        //           color: ColorPalette.greyE3,
                        //           width: 2,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        //   enabled: typeofcoverValue != null,
                        //   compareFn: (CarCompanyList a, CarCompanyList b) =>
                        //       a.id == b.id,
                        //   popupProps: const PopupProps.menu(
                        //     showSearchBox: true,
                        //     searchFieldProps: TextFieldProps(
                        //       decoration: InputDecoration(
                        //         labelText: "Search Car",
                        //         border: OutlineInputBorder(),
                        //       ),
                        //     ),
                        //   ),
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return "Please Select Car Company";
                        //     }
                        //     return null;
                        //   },
                        //   onChanged: (CarCompanyList? newValue) {
                        //     widget.motorField!('carCompany', newValue);
                        //     setState(() {
                        //       carCompanyValue = newValue!.name;
                        //       selectedCarCompany = newValue;
                        //       carMakeValue = null;
                        //       carTypeValue = null;
                        //       variantValue = null;
                        //       fmv = 0;
                        //       fmvValue.text = '';

                        //       OD = 0;
                        //       //Theft = 0;
                        //       AON = 0;
                        //       basicPremium = 0;
                        //       docStamp = 0;
                        //       Vat = 0;
                        //       lVat = 0;
                        //       totalPrem = 0;
                        //     });
                        //   },
                        //   // searchFieldProps: TextFieldProps(
                        //   //   decoration: InputDecoration(
                        //   //     labelText: "Search Car",
                        //   //     border: OutlineInputBorder(),
                        //   //   ),
                        //   // ),
                        // );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          carMake,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        FutureBuilder<List<CarMakeList>>(
                          future: getCarMake(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CustomDropdownButton(
                                value: carMakeValue,
                                items: snapshot.data!.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text(e.name.toString()),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return "Car Make is Required";
                                  }
                                  return null;
                                },
                                onChanged: (newValue) {
                                  widget.motorField!('carMake', newValue);
                                  setState(() {
                                    carMakeValue = newValue;
                                    carTypeValue = null;
                                    variantValue = null;
                                    fmv = 0;
                                    fmvValue.text = '';

                                    OD = 0;
                                    //Theft = 0;
                                    AON = 0;
                                    basicPremium = 0;
                                    docStamp = 0;
                                    Vat = 0;
                                    lVat = 0;
                                    totalPrem = 0;
                                  });
                                },
                              );
                            } else {
                              return const Text(
                                  "No Available Car Make for this Car Company.");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          carType,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        FutureBuilder<List<CarTypeList>>(
                          future: getCarType(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CustomDropdownButton(
                                value: snapshot.data == null ||
                                        snapshot.data!.isEmpty
                                    ? carTypeValue
                                    : snapshot.data![0].id,
                                items: snapshot.data!.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text(e.type.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    carTypeValue = newValue;
                                    widget.motorField!('carType', carTypeValue);
                                  });
                                },
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    variant,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  FutureBuilder<List<CarVariant>>(
                    future: getCarVariant(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomDropdownButton(
                          value: variantValue,
                          items: snapshot.data!.map((e) {
                            return DropdownMenuItem(
                              value: e.id.toString(),
                              child: Text(e.name.toString()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            widget.motorField!('variant', newValue);
                            setState(() {
                              variantValue = newValue;
                              fmv = 0;
                              fmvValue.text = '';

                              OD = 0;
                              //Theft = 0;
                              AON = 0;
                              basicPremium = 0;
                              docStamp = 0;
                              Vat = 0;
                              lVat = 0;
                              totalPrem = 0;
                            });
                            getFmv();
                          },
                        );
                      } else {
                        variantValue = "No Variant Selected";
                        return const Text("No Data");
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    fairMarket,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: fmvValue,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'OpenSans',
                      ),
                      hintText: (fairMarket),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: ColorPalette.greyE3,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: ColorPalette.primaryColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) async {
                      widget.motorField!('fmv', value);
                      fmv = value;
                      await Future.delayed(const Duration(milliseconds: 500));
                      vtplb = await getVtplBI();
                      vtplp = await getVtplPD();

                      setState(() {
                        vtplb = vtplb
                            .where((i) =>
                                int.parse(i.name) <=
                                int.parse(fmv != null ? fmv.toString() : '0'))
                            .toList();

                        vtplp = vtplp
                            .where((i) =>
                                int.parse(i.name) <=
                                int.parse(fmv != null ? fmv.toString() : '0'))
                            .toList();

                        vtplBIValue = null;
                        vtplPDValue = null;
                        OD = 0;
                        //Theft = 0;
                        AON = 0;
                        basicPremium = 0;
                        docStamp = 0;
                        Vat = 0;
                        lVat = 0;
                        totalPrem = 0;
                      });
                    },
                    validator: (text) {
                      var value = text == '' ? '0' : text.toString();
                      if (tocID == '1' && int.parse(value) > 3000000) {
                        return "FMV is Over the Limit for Type of Cover";
                      } else if (text is int &&
                          int.parse(text.toString()) <= 0) {
                        return "FMV has no Value";
                      } else if (tocID == '2' &&
                          int.parse(text.toString()) > 3000000) {
                        return "FMV is Over the Limit for Type of Cover";
                      } else if (tocID == '3' &&
                          int.parse(text.toString()) > 3000000) {
                        return "FMV is Over the Limit for Type of Cover";
                      } else if (tocID == '4' &&
                          int.parse(text.toString()) > 1000000) {
                        return "FMV is Over the Limit for Type of Cover";
                      } else if (tocID == '5' &&
                          int.parse(text.toString()) > 500000) {
                        return "FMV is Over the Limit for Type of Cover";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              // const SizedBox(height: 10.0),
              // CheckboxListTile(
              //     title: Text(addVolun),
              //     value: isChecked,
              //     activeColor: Colors.orangeAccent,
              //     onChanged: (bool? newBool) {
              //       setState(() {
              //         isChecked = newBool;
              //       });
              //     }),
              const SizedBox(height: 10),
              // SizedBox(
              //     child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const Text(deduc),
              //     TextField(
              //       controller: TextEditingController()
              //         ..text = objToc != null
              //             ? objToc['deductible'].toString()
              //             : '',
              //       style: TextStyle(
              //         fontSize: 20.0,
              //         fontFamily: 'OpenSans',
              //       ),
              //       decoration: const InputDecoration(
              //           focusedBorder: UnderlineInputBorder(
              //             borderSide: BorderSide(
              //                 color: Color(0xfffe5000)),
              //           ),
              //           enabledBorder: UnderlineInputBorder(
              //             borderSide: BorderSide(
              //               color: Color(0xfffe5000),
              //               width: 2.0,
              //             ),
              //           )),
              //     ),
              //   ],
              // )),
              // const SizedBox(height: 5.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          vtplB,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        CustomDropdownButton(
                          value: vtplBIValue,
                          items: vtplb.map((item) {
                            return DropdownMenuItem(
                              value: tocID == "3"
                                  ? item.heavy.toString()
                                  : item.light.toString(),
                              child: Text(item.name.toString()),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Please Select VTPL - Bodily Injury";
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            widget.motorField!('vtplbi', newValue);
                            setState(() {
                              vtplBIValue = newValue;
                              vtplPDValue = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          vtplP,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        CustomDropdownButton(
                          value: vtplPDValue,
                          items: vtplp.map((item) {
                            return DropdownMenuItem(
                              value: tocID == "3"
                                  ? item.heavy.toString()
                                  : item.light.toString(),
                              child: Text(item.name.toString()),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Please Select VTPL - Property Damage";
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            widget.motorField!('vtplpd', newValue);
                            setState(() {
                              vtplPDValue = newValue;

                              AON = double.parse(aonRate.toString()) *
                                  double.parse(fmvValue.text == ""
                                      ? "0"
                                      : fmvValue.text);
                              OD = double.parse(odRate.toString()) *
                                  double.parse(fmvValue.text == ""
                                      ? "0"
                                      : fmvValue.text);
                              basicPremium = double.parse(OD.toString()) +
                                  double.parse(AON.toString()) +
                                  double.parse(vtplBIValue ?? '0') +
                                  double.parse(vtplPDValue ?? '0');
                              totalCommission = basicPremium *
                                  double.parse(commissionRate.toString());

                              docStamp = ((basicPremium / 4).ceil()) * .5;
                              Vat = basicPremium * 0.12;
                              lVat = (double.parse(locTax.toString()) *
                                      basicPremium) /
                                  100;
                              totalPrem = basicPremium + docStamp + Vat + lVat;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (vtplPDValue != null)
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: widget.onNextPressed,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

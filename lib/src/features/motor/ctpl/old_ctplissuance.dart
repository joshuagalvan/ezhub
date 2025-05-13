// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_dropdown_field.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/carcompany_model.dart';
import 'package:simone/src/features/authentication/models/carmake_model.dart';
import 'package:simone/src/features/authentication/models/cartype_model.dart';
import 'package:simone/src/features/motor/ctpl/ctpl_create_profile.dart';
import 'package:simone/src/features/motor/ctpl/draft_ctpl_policy.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/helpers/paynamics.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CtplIssuance extends StatefulWidget {
  const CtplIssuance({
    super.key,
    required this.plateText,
  });
  final String plateText;

  @override
  CtplIssuanceState createState() => CtplIssuanceState();
}

class CtplIssuanceState extends State<CtplIssuance> {
  final controller = Get.put(ProfileController());
  String? branchName,
      branchCode,
      ctplValue,
      transmissionValue,
      basicPremium,
      ctplTextValue,
      year,
      sourceIncomeValue,
      typeIdValue,
      lobValue,
      genderValue,
      tocName,
      yearValue,
      policyNumber,
      id;
  late bool ctplBool;
  String taggingText = '';
  String insuredAddress = '';
  String insuredTin = '';
  String insuredEmail = '';
  String insuredGender = '';
  String? insuredContact = '';
  String insuredCountry = 'Philippines';
  late DateTime insuredBirthday;
  String ctplValueText = '';
  List<dynamic> toc = [];
  List<dynamic> databaseList = [];
  List<dynamic> manufactureYear = [];
  List<dynamic> insuredDetails = [];
  List<dynamic> insuredNameList = [];
  List<dynamic> lineBusiness = [];
  List<dynamic> sourceIncome = [];
  List<dynamic> typeId = [];
  String inceptionDate = '', expirationDate = '';
  DateTime dateNow = DateTime.now();
  String? lastDigit;
  String? carTypeValue;
  String? carTypeName;
  String? carCompanyValue;
  String? carMakeValue;
  String? carMakeId;
  final formKey = GlobalKey<FormState>();
  TextEditingController engineNumberText = TextEditingController();
  TextEditingController chasisNumberText = TextEditingController();
  TextEditingController variantText = TextEditingController();
  TextEditingController conductionStickerText = TextEditingController();
  TextEditingController mvFileText = TextEditingController();
  TextEditingController colorText = TextEditingController();
  TextEditingController personalId = TextEditingController();
  final name = TextEditingController();
  bool isChecked = false;
  String? insCode;
  int tagging = 0;
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthPlace = TextEditingController();
  TextEditingController citizenship = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController blkSt = TextEditingController();
  TextEditingController barangay = TextEditingController();
  TextEditingController cityState = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController emailAdd = TextEditingController();
  TextEditingController tinNumber = TextEditingController();
  late DateTime birthDateValue, businessLicenseDateValue;
  TextEditingController businessLicenseDate = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController personCharge = TextEditingController();
  TextEditingController shareHolder1 = TextEditingController();
  TextEditingController shareHolder2 = TextEditingController();
  TextEditingController shareHolder3 = TextEditingController();
  double locTax = 0;
  double docStamp = 0;
  double Vat = 0;
  double lVat = 0;
  double totalPrem = 0;
  double ltoInter = 50.40;
  late Paynamics paynamics;
  late final WebViewController controllerWeb;
  String urlLink = '';
  TextEditingController carCompanyController = TextEditingController();
  TextEditingController carMakeController = TextEditingController();
  TextEditingController tocController = TextEditingController();
  dynamic tocID;
  String? tocBasicPremium;
  Map<String, dynamic>? tocBasicPremiumMap;
  String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  int databaseID = 0;
  String refNo = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
  String loadingText = 'Loading';
  Map<String, dynamic> individualData = {};
  String vehicleClass = '';

  final _carCompanyFocusNode = FocusNode();
  final _carMakeModelFocusNode = FocusNode();

  List<dynamic> carMakeList = [];
  List<dynamic> carVariant = [];
  String? selectedCarVariant;
  List<Map<String, dynamic>> ctplCoverage = [
    {'text': 'YES', 'value': '2'},
    {'text': 'NO', 'value': '1'},
  ];

  List<Map<String, dynamic>> gender = [
    {'text': 'Male', 'value': 'MALE'},
    {'text': 'Female', 'value': 'FEMALE'},
  ];

  List<Map<String, dynamic>> transmission = [
    {'text': 'Automatic', 'value': 'Automatic'},
    {'text': 'Manual', 'value': 'Manual'},
  ];

  String _pdfPath = '';

  @override
  void initState() {
    super.initState();
    getBranch();
    getLastDigit();
  }

  getLastDigit() {
    final digits = widget.plateText.replaceAll(RegExp(r'[^0-9]'), '');
    lastDigit = digits[digits.length - 1];
  }

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

  getVehicleType() async {
    final response = await http.post(
        Uri.parse(
            'http://10.52.2.124/ctpl/getVehicleTypeOfCoverByCarStateId_json/'),
        body: {
          'state_id': ctplValue,
          // 'simoneApp': 'MTcyNTg1MzAwN18yMDI0MDkwOV9NMDlKSTAwMDAx'
        });
    final result = jsonDecode(response.body);
    final data = (result as List).map((car) => car).toList();

    toc = data;
    setState(() {});
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

      setState(() {});
    } catch (_) {}
  }

  Future<List<CarCompanyList>> getCarCompany() async {
    try {
      final response = await http.post(Uri.parse(
          'http://10.52.2.124/motorquotation/getCarCompanyList_json/?toc=$tocID'));
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
        carMakeList = carMake;
        setState(() {});
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
          body: {'car_make_model_id': carMakeValue, 'toc': '$tocID'});

      final carType = (jsonDecode(response.body));
      carTypeName = carType['type'];

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

  Future<void> getCarVariants() async {
    dynamic modelObj = carMakeList.firstWhere((x) {
      return x['id'] == carMakeValue;
    });

    dynamic models = await Api().getCarVariants(
        carModel: modelObj['name'] ?? '',
        carModelId: modelObj['id'] ?? '',
        typeOfCover: tocName ?? '',
        yearManufactured: yearValue ?? '2024');
    if (models['data']['list'] != null) {
      carVariant = models['data']['list'].toList();
      setState(() {});
    } else {
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        CustomSnackBar.info(
          message: "There is no car variant for $carMakeValue",
        ),
      );
    }
  }

  getLineOfBusiness() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124:9017/ctpl/getLineOfBusiness_json/'));
      var result = (jsonDecode(response.body));

      lineBusiness = [];
      for (var row in result) {
        lineBusiness.add(row);
      }

      setState(() {});
    } catch (_) {}
  }

  getSourceOfIncome() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124:9017/ctpl/getSourceOfFunds_json/'));
      var result = (jsonDecode(response.body));

      sourceIncome = [];
      for (var row in result) {
        sourceIncome.add(row);
      }

      setState(() {});
    } catch (_) {}
  }

  getTypeOfId() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124:9017/ctpl/getAcceptableIds_json/'));
      var result = (jsonDecode(response.body));

      typeId = [];
      for (var row in result) {
        typeId.add(row);
      }

      setState(() {});
    } catch (_) {}
  }

  Future<void> getInsuredNameList() async {
    showDialog(
      context: context,
      builder: (context) => const CustomLoadingDialog(),
    );
    var userData = await controller.getUserData();
    try {
      final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motor/getInsuredListForAutoComplete_json/'),
          body: {
            'keyword': name.text,
            'intm_code': userData?.agentCode ?? '',
          });
      var result = (jsonDecode(response.body));

      insuredNameList = [];
      for (var row in result) {
        insuredNameList.add(row);
      }

      getTypeOfId();
      getSourceOfIncome();
      getLineOfBusiness();
      Navigator.pop(context);
      if (response.statusCode == 200 && insuredNameList.isNotEmpty) {
        return showModalBottomSheet(
            context: context,
            builder: (context) => StatefulBuilder(builder: (context, setS) {
                  return SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            ...insuredNameList.map((item) {
                              var id = item['id'];
                              var name = item['name'];

                              return SizedBox(
                                child: Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setS(() {
                                            insCode = id;
                                            getInsuredDetails();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'OpenSans',
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  );
                }));
      } else if (response.statusCode == 200 && insuredNameList.isEmpty) {
        //Constant Variables
        // firstName.text = "test";
        // lastName.text = "romeo";
        // middleName.text = "test";
        // emailAdd.text = "jgalvan@fpgins.com";
        // phoneNumber.text = "09612345837";
        // mobileNumber.text = "09612345837";
        // blkSt.text = "7 G Felipe";
        // barangay.text = 'Santa Cruz';
        // cityState.text = "Quezon City";
        // province.text = "Metro Manila";
        // zipCode.text = "1123";
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.warning,
          title: 'CTPL Issuance',
          desc: 'Profile not found.\nWould you like to create new profile?',
          btnCancelText: 'No',
          btnCancelOnPress: () {},
          btnOkText: 'Yes',
          btnOkOnPress: () {
            Get.to(
              () => CreateCTPLProfile(
                savedData: individualData,
                onSave: (data) {
                  individualData = data;
                  fullName.text =
                      '${data['firstName']} ${data['middleName']} ${data['lastName']}';
                  firstName.text = data['firstName'];
                  lastName.text = data['lastName'];
                  middleName.text = data['middleName'] ?? '';
                  birthDate.text = data['birthDate'];
                  birthPlace.text = data['birthPlace'];
                  genderValue = data['gender'];
                  insuredGender = data['gender'];
                  citizenship.text = data['citizenship'];
                  blkSt.text = data['blkSt'];
                  barangay.text = data['barangay'];
                  province.text = data['province'];
                  cityState.text = data['cityState'];
                  zipCode.text = data['zipCode'];
                  emailAdd.text = data['emailAdd'];
                  insuredEmail = data['emailAdd'];
                  insuredAddress =
                      '${blkSt.text} ${barangay.text} ${cityState.text} ${province.text} Philippines';
                  phoneNumber.text = data['phoneNumber'];
                  mobileNumber.text = data['mobileNumber'];
                  tinNumber.text = data['tinNumber'];
                  insuredTin = data['tinNumber'];
                  sourceIncomeValue = data['sourceIncome'];
                  sourceIncomeValue = data['typeId'];
                  personalId.text = data['personalId'];
                  typeIdValue = data['typeId'];
                  tagging = data['tagging'];
                  taggingText = data['taggingText'];
                  setState(() {});
                },
              ),
            );
          },
        ).show();

        // return showModalBottomSheet(
        //   isScrollControlled: true,
        //   context: context,
        //   builder: (context) => DefaultTabController(
        //     length: 2,
        //     child: StatefulBuilder(builder: (context, setS) {
        //       return Scaffold(
        //         appBar: AppBar(
        //           toolbarHeight: 90,
        //           leading: Padding(
        //             padding: const EdgeInsets.only(top: 60),
        //             child: IconButton(
        //               icon: const Icon(
        //                 Icons.arrow_back_ios,
        //                 size: 20,
        //               ),
        //               onPressed: () {
        //                 Navigator.pop(context);
        //               },
        //             ),
        //           ),
        //           bottom: const TabBar(
        //             indicatorSize: TabBarIndicatorSize.tab,
        //             indicatorColor: ColorPalette.primaryColor,
        //             labelColor: ColorPalette.primaryColor,
        //             tabs: [
        //               Tab(
        //                 icon: Icon(Icons.person),
        //                 text: "Individual",
        //               ),
        //               Tab(
        //                 icon: Icon(Icons.business),
        //                 text: "Corporate",
        //               ),
        //             ],
        //           ),
        //         ),
        //         body: TabBarView(
        //           children: [
        //             Container(
        //               padding: const EdgeInsets.all(defaultSizePrem),
        //               child: SingleChildScrollView(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     _buildTextInput(
        //                       "First Name",
        //                       hintText: "Enter First Name",
        //                       value: firstName,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Middle Name",
        //                       hintText: "Enter Middle Name",
        //                       value: middleName,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Last Name",
        //                       hintText: "Enter Last Name",
        //                       value: lastName,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text("Birth Date"),
        //                         InputTextField(
        //                           controller: birthDate,
        //                           hintText: 'Enter your Birthdate',
        //                           readOnly: true,
        //                           onTap: () {
        //                             selectBirthDate();
        //                           },
        //                         )
        //                       ],
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Birth Place",
        //                       hintText: "Enter Birth Place",
        //                       value: birthPlace,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text("Gender"),
        //                         CustomDropdownButton<String>(
        //                           value: genderValue,
        //                           items: gender.map((item) {
        //                             return DropdownMenuItem<String>(
        //                               value: item['value'],
        //                               child: Text(item['text']),
        //                             );
        //                           }).toList(),
        //                           onChanged: (value) {
        //                             genderValue = value;
        //                           },
        //                         ),
        //                       ],
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Citizenship",
        //                       hintText: "Enter Citizenship",
        //                       value: citizenship,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Block/ Lot/ Phase No/ Unit/ Street/ Village/ Subdivision",
        //                       hintText: "Enter Block/ Lot/ Phase No",
        //                       value: blkSt,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Barangay",
        //                       hintText: "Enter Barangay",
        //                       value: barangay,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "City",
        //                       hintText: "Enter City",
        //                       value: cityState,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Province",
        //                       hintText: "Enter Province",
        //                       value: province,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Postal Code",
        //                       hintText: "Enter Postal Code",
        //                       value: zipCode,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Country",
        //                       hintText: "Enter Country",
        //                       value: TextEditingController(text: 'Philippines'),
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Phone Number",
        //                       hintText: "Enter Phone Number",
        //                       value: phoneNumber,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Mobile Number",
        //                       hintText: "Enter Mobile Number",
        //                       value: mobileNumber,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Email Address",
        //                       hintText: "Enter Email Address",
        //                       value: emailAdd,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "TIN",
        //                       hintText: "Enter TIN",
        //                       value: tinNumber,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text("Source of Income"),
        //                         CustomDropdownButton<String>(
        //                           value: sourceIncomeValue,
        //                           items: sourceIncome.map((item) {
        //                             return DropdownMenuItem<String>(
        //                               value: item['id'],
        //                               child: Text(item['code']),
        //                             );
        //                           }).toList(),
        //                           onChanged: (value) {
        //                             sourceIncomeValue = value;
        //                           },
        //                         ),
        //                       ],
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text("Type of ID"),
        //                         CustomDropdownButton<String>(
        //                           value: typeIdValue,
        //                           items: typeId.map((item) {
        //                             return DropdownMenuItem<String>(
        //                               value: item['id'],
        //                               child: Text(item['description']),
        //                             );
        //                           }).toList(),
        //                           onChanged: (value) {
        //                             typeIdValue = value;
        //                           },
        //                         ),
        //                       ],
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Personal ID",
        //                       hintText: "Enter Personal ID",
        //                       value: personalId,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         ElevatedButton(
        //                           onPressed: () {
        //                             Navigator.pop(context);
        //                           },
        //                           style: OutlinedButton.styleFrom(
        //                             backgroundColor: const Color(0xfffe5000),
        //                           ),
        //                           child: const Text(
        //                             'Cancel',
        //                             style: TextStyle(
        //                               color: Colors.white,
        //                               fontFamily: 'OpenSans',
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ),
        //                         const SizedBox(width: 15),
        //                         ElevatedButton(
        //                           onPressed: () {
        //                             setState(() {
        //                               name.text =
        //                                   '${firstName.text} ${middleName.text} ${lastName.text}';
        //                               insuredTin = tinNumber.text;
        //                               insuredAddress =
        //                                   '${blkSt.text} ${barangay.text} ${cityState.text} ${province.text} Philippines';
        //                               taggingText = "Individual";
        //                               insuredEmail = emailAdd.text;
        //                               insuredGender = genderValue.toString();
        //                               insuredContact = mobileNumber.text;
        //                               tagging = 0;
        //                             });
        //                             Navigator.pop(context);
        //                           },
        //                           style: OutlinedButton.styleFrom(
        //                             backgroundColor: const Color(0xfffe5000),
        //                           ),
        //                           child: const Text(
        //                             'Save',
        //                             style: TextStyle(
        //                               color: Colors.white,
        //                               fontFamily: 'OpenSans',
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ),

        //             ///// CORPORATE TAB /////
        //             Container(
        //               padding: const EdgeInsets.all(defaultSizePrem),
        //               child: SingleChildScrollView(
        //                 child: Column(
        //                   children: [
        //                     _buildTextInput(
        //                       "Full Name",
        //                       hintText: "Enter Corporate Name",
        //                       value: fullName,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Person In Charge",
        //                       hintText: "Enter Corporate Name",
        //                       value: personCharge,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Block/ Lot/ Phase No/ Unit/ Street/ Village/ Subdivision",
        //                       hintText: "Enter Block/ Lot/ Phase No",
        //                       value: blkSt,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Barangay",
        //                       hintText: "Enter Barangay",
        //                       value: barangay,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "City",
        //                       hintText: "Enter City",
        //                       value: cityState,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Province",
        //                       hintText: "Enter Province",
        //                       value: province,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Postal Code",
        //                       hintText: "Enter Postal Code",
        //                       value: zipCode,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Country",
        //                       hintText: "Enter Country",
        //                       value: TextEditingController(text: 'Philippines'),
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Phone Number",
        //                       hintText: "Enter Phone Number",
        //                       value: phoneNumber,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Mobile Number",
        //                       hintText: "Enter Mobile Number",
        //                       value: mobileNumber,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Email Address",
        //                       hintText: "Enter Email Address",
        //                       value: emailAdd,
        //                       validators: (value) =>
        //                           TextFieldValidators.validateEmail(value),
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "TIN",
        //                       hintText: "Enter TIN",
        //                       value: tinNumber,
        //                       validators: (value) =>
        //                           TextFieldValidators.validateTIN(value),
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text("Line of Business"),
        //                         CustomDropdownButton<String>(
        //                           value: lobValue,
        //                           items: lineBusiness.map((item) {
        //                             return DropdownMenuItem<String>(
        //                               value: item['lob'],
        //                               child: Text(item['description']),
        //                             );
        //                           }).toList(),
        //                           onChanged: (value) {
        //                             lobValue = value;
        //                           },
        //                         ),
        //                       ],
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text("Source of Income"),
        //                         CustomDropdownButton<String>(
        //                           value: sourceIncomeValue,
        //                           items: sourceIncome.map((item) {
        //                             return DropdownMenuItem<String>(
        //                               value: item['id'],
        //                               child: Text(item['code']),
        //                             );
        //                           }).toList(),
        //                           onChanged: (value) {
        //                             sourceIncomeValue = value;
        //                           },
        //                         )
        //                       ],
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         const Text("Business License Date"),
        //                         const SizedBox(width: 37),
        //                         InputTextField(
        //                           controller: businessLicenseDate,
        //                           prefixIcon: const Icon(Icons.calendar_today),
        //                           readOnly: true,
        //                           onTap: () {
        //                             selectBusinessLicenseDate();
        //                           },
        //                         )
        //                       ],
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Share Holder 1",
        //                       hintText: "Enter Share Holder 1",
        //                       value: shareHolder1,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Share Holder 2",
        //                       hintText: "Enter Share Holder 2",
        //                       value: shareHolder2,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     _buildTextInput(
        //                       "Share Holder 3",
        //                       hintText: "Enter Share Holder 3",
        //                       value: shareHolder3,
        //                     ),
        //                     const SizedBox(height: 10),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         ElevatedButton(
        //                           onPressed: () {
        //                             Navigator.pop(context);
        //                           },
        //                           style: OutlinedButton.styleFrom(
        //                             backgroundColor: const Color(0xfffe5000),
        //                           ),
        //                           child: const Text(
        //                             'Cancel',
        //                             style: TextStyle(
        //                               color: Colors.white,
        //                               fontFamily: 'OpenSans',
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ),
        //                         const SizedBox(width: 15),
        //                         ElevatedButton(
        //                           onPressed: () {
        //                             setState(() {
        //                               name.text = fullName.text;
        //                               insuredTin = tinNumber.text;
        //                               insuredAddress =
        //                                   '${blkSt.text} ${cityState.text} Philippines';
        //                               taggingText = "Corporate";
        //                             });
        //                             Navigator.pop(context);
        //                           },
        //                           style: OutlinedButton.styleFrom(
        //                             backgroundColor: const Color(0xfffe5000),
        //                           ),
        //                           child: const Text(
        //                             'Save',
        //                             style: TextStyle(
        //                               color: Colors.white,
        //                               fontFamily: 'OpenSans',
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }),
        //   ),
        // );
      }

      setState(() {});
    } catch (_) {
      printError();
    }
  }

  getInsuredDetails() async {
    try {
      final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motor/getInsuredAdditionalDetails_json/'),
          body: {
            'ins_code': insCode,
          });
      var result = (jsonDecode(response.body));

      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(result['email']);

      setState(() {
        if (emailValid == true) {
          insuredBirthday = DateTime.parse(result['birthday']);
          insuredEmail = result['email'];
          insuredGender = result['sex'];
          insuredContact = result['contact'];
          insuredTin = result['tin'];
          insuredAddress = result['address'];
          name.text = result['name'];
          tagging = result['tagging'];

          if (tagging == 0) {
            taggingText = "Individual";
          } else {
            taggingText = "Corporate";
          }

          firstName.text = result['name'];
          middleName.text = "";
          lastName.text = "";
          birthDate.text = insuredBirthday.toString();
          birthPlace.text = "";
          citizenship.text = "";
          blkSt.text = insuredAddress;
          barangay.text = '';
          cityState.text = '';
          province.text = '';
          insuredCountry = '';
          phoneNumber.text = '';
          mobileNumber.text = insuredContact == '' ? '' : insuredContact ?? '';
        } else {
          Get.snackbar('Error',
              'Selected Insured Name has an Invalid Email Address. Please Update in Care to Proceed.');
        }
      });
    } catch (_) {}
  }

  Future<void> selectBirthDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        birthDate.text = picked.toString().split(" ")[0];
        birthDateValue = picked;
      });
    }
  }

  Future<void> selectBusinessLicenseDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        businessLicenseDate.text = picked.toString().split(" ")[0];
        businessLicenseDateValue = picked;
      });
    }
  }

  // saveDetails() async {
  //   List<CarCompanyList> carCompanyName = await getCarCompany();
  //   int index =
  //       carCompanyName.indexWhere((element) => element.id == carCompanyValue);
  //   CarCompanyList carCompName = carCompanyName[index];

  //   List<CarMakeList> carMakeName = await getCarMake();
  //   int indexMake =
  //       carMakeName.indexWhere((element) => element.id == carMakeValue);
  //   CarMakeList carMaName = carMakeName[indexMake];

  //   var userData = await controller.getUserData();
  //   var details = [
  //     '',
  //     ctplValue,
  //     ctplValue,
  //     ctplValue,
  //     tocID,
  //     tocName,
  //     inceptionDate,
  //     expirationDate,
  //     yearValue,
  //     carCompName.name,
  //     carMaName.name,
  //     carTypeName.toString(),
  //     engineNumberText.text,
  //     chasisNumberText.text,
  //     variantText.text,
  //     widget.plateText.toUpperCase(),
  //     conductionStickerText.text,
  //     mvFileText.text,
  //     colorText.text,
  //     userData.agentCode,
  //     userData.fullName,
  //     tagging,
  //     name.text,
  //     insuredTin,
  //     insuredAddress,
  //     birthDate.text,
  //     insuredGender,
  //     basicPremium.toString(),
  //     docStamp.toString(),
  //     Vat.toString(),
  //     lVat.toString(),
  //     locTax.toString(),
  //     totalPrem.toStringAsFixed(2),
  //     branchCode.toString(),
  //     insCode.toString(),
  //     currentDate,
  //     userData.agentCode,
  //   ];
  //   var mysql = await mySQL().connect();
  //   var result = await mysql.query(
  //       """INSERT INTO motor_ctpl (policy_no, is_vehicle_brand_new, coverage_id, coverage,
  //       vehicle_type_of_cover, toc_txt, inception_date, expiry_date, year_manufactured,
  //       car_company, car_make_model, car_type, engine_number, chasis_number, car_variance,
  //       plate_no, con_sticker_plate_no, mv_file_no, car_color, intm_code, intm_name, tagging,
  //       ins_name, ins_tin, ins_address, ins_birthday, ins_gender, basic_premium,
  //       dst, vat, lgt, lgt_rate, total_premium, branch, ins_code,
  //       date_created, added_by)
  //        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
  //         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""", details);

  //   if (result.affectedRows > 0) {
  //     showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //               title: Text('Details has been Saved'),
  //               content: Text(
  //                   'Redirecting to Paynamics for Payment. Please Do not Close the Application, Loading of Paynamics usually takes time.'),
  //               actions: [
  //                 TextButton(
  //                     onPressed: () async {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('OK'))
  //               ],
  //             ));
  //   }
  // }

  // saveWebDetails() async {
  //   var mysql = await mySQL().connect();
  //   var result = await mysql
  //       .query("""SELECT * FROM MOTOR_CTPL ORDER BY ID DESC LIMIT 1""");

  //   databaseList = [];
  //   for (var row in result) {
  //     databaseList.add(row);
  //   }

  //   var details = [
  //     'EZH' + refNo,
  //     databaseList[0]['id'],
  //     'CTPL',
  //     databaseList[0]['branch'],
  //     databaseList[0]['ins_name'],
  //     insuredEmail.toString(),
  //     insuredContact.toString(),
  //     databaseList[0]['total_premium'],
  //   ];

  //   var results = await mysql.query(
  //       """INSERT INTO web_payment (transaction_reference_id, line_id, line, branch_code,
  //       name, email, mobile_no, payment_amount)
  //        VALUES (?, ?, ?, ?, ?, ?, ?, ?)""", details);
  // }

  Future<void> getPolicyNumber() async {
    showDialog(
      context: context,
      builder: (ctx) => const CustomLoadingDialog(
        loadingText: 'Loading...',
      ),
    );
    List<CarCompanyList> carCompanyName = await getCarCompany();
    int index =
        carCompanyName.indexWhere((element) => element.id == carCompanyValue);
    CarCompanyList carCompName = carCompanyName[index];

    List<CarMakeList> carMakeName = await getCarMake();
    int indexMake =
        carMakeName.indexWhere((element) => element.id == carMakeValue);
    CarMakeList carMaName = carMakeName[indexMake];

    var userData = await controller.getUserData();
    final data = {
      'firstName': firstName.text,
      'middleName': middleName.text,
      'lastName': lastName.text,
      'suffix': '',
      'birthDate': birthDate.text,
      'birthPlace': birthPlace.text,
      'gender': insuredGender,
      'citizenship': citizenship.text,
      'streetAddress': blkSt.text,
      'brgy': barangay.text,
      'city': cityState.text,
      'province': province.text,
      'country': insuredCountry,
      'phoneNo': phoneNumber.text,
      'mobileNo': mobileNumber.text,
      'email': insuredEmail,
      'tin': insuredTin,
      'incomeSource': '',
      'idType': '',
      'idNo': "",
      'yearManufactured': yearValue,
      'carMakeId': carCompanyValue,
      'carMakeName': carCompName.name,
      'carModelId': carMakeValue,
      'carModelName': carMaName.name,
      'bodyType': carTypeName,
      'transmissionType': transmissionValue,
      'engineNo': engineNumberText.text,
      'chassisNo': chasisNumberText.text,
      'color': colorText.text,
      'plateNo': widget.plateText.toUpperCase(),
      'conduction': conductionStickerText.text,
      'mvFileNo': mvFileText.text,
      'vehicleTypeId': tocID.toString(),
      'vehicleTypeName': tocName,
      'tocId': "",
      'tocName': "",
      'refNo': refNo,
      'source': 'EZH',
      'policyType': 'Compulsory Third Party Liability',
      'intmCode': userData?.agentCode ?? '',
      'intmName': userData?.fullName ?? '',
      'branchCode': branchCode,
      'branchName': branchName,
      'inceptionDate': inceptionDate,
      'expiryDate': expirationDate,
      'commision': '0',
      'basicPremium': basicPremium,
      'dst': docStamp.toString(),
      'vat': Vat.toString(),
      'lgt': lVat.toString(),
      'lto': ltoInter.toString(),
      'totalPremium': totalPrem.toString(),
    };

    debugPrint('DATA $data', wrapWidth: 768);
    try {
      debugPrint(mobileNumber.text);
      final response = await http.post(
        Uri.parse('http://10.52.2.117:1003/api/motor-policies'),
        headers: {
          'X-Authorization':
              'Uskfm1KDr3KtCStV0W28oOoee8pTVkaCszauYNyyknDL9r5LLZv24Stt0GVWekeV'
        },
        body: data,
      );
      if (!response.body.toString().contains('Unauthorized')) {
        debugPrint('body ${response.body}');
        var result = (jsonDecode(response.body));

        Navigator.pop(context);

        policyNumber = result['data']['policy_no'];
        debugPrint('policyNumber $policyNumber');
        id = result['data']['id'];
        debugPrint('id $id');
        emailSend();

        setState(() {});
      } else {
        Navigator.pop(context);
        showTopSnackBar(
          Overlay.of(context),
          displayDuration: const Duration(seconds: 1),
          const CustomSnackBar.error(
            message: "There is a problem saving issuance.",
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  emailSend() async {
    // final controller = Get.put(ProfileController());
    // var userData = await controller.getUserData();
    showDialog(
      context: context,
      builder: (ctx) => const CustomLoadingDialog(
        loadingText: 'Sending email',
      ),
    );
    // final response = await http.get(
    //     Uri.parse('http://10.52.2.117:1003/api/motor-policies/$id'),
    //     headers: {
    //       'X-Authorization':
    //           'HD0Y4Gf6v3WUwaBpJN44lZ2VNv2IDfCNoLVYWpZQHw9XXVXENMpNacK8oxQrujqb'
    //     });

    // var result = (jsonDecode(response.body)['data']);

    // final Uint8List pdfBytes =
    //     base64.decode(result['files']['policy_schedule']);
    // var dir = (await getTemporaryDirectory()).path;
    // final String path = '$dir/CTPLPolicy.pdf';
    // final File file = File(path);
    // await file.writeAsBytes(pdfBytes);

    final smtpServer = SmtpServer('10.52.254.55',
        port: 25, allowInsecure: true, ignoreBadCertificate: true);
    // Link for Payment Deployed <a href="http://ph-webpayment.fpgins.com"></a>
    final message = Message()
      ..from =
          const Address("ezhub-donotreply@fpgins.com", "EZHub by FPG - UAT")
      ..recipients.add(insuredEmail)
      // ..recipients.add('jgalvan@fpgins.com')
      ..subject = 'Motor CTPL Insurance Payment and Preview Email $currentDate'
      ..html = """
                  <p>Greetings, <b>${name.text},</b><br></p>
                  <p>We appreciate you picking FPG Insurance! This is your vehicle's CTPL Insurance Preview Email. <br><br>
                     ${name.text}, your insurance agent, will walk you through the remaining steps of the insurance process. <br><br>
                  <p>We appreciate your business and are eager to insure you! <br><br></p>
                  <p>This Email will Provide you the Reference Number to be used in paying your insurance policy and the link to where will you pay. <br><br>
                  Attached is a PDF File of the Preview of your Upcoming Policy.<br><br></p>
                  <p>Policy Number: $policyNumber <br><br>
                  <a href="http://10.52.2.124:9013"><p>Click Here to Proceed to Payment</p></a></p>
                  <p style="color:#eb6434">FPG INSURANCE<br><br><br> </p>
                  <p style="font-style:italic; font-size:12px;">DISCLAIMER: This is an automatically generated e-mail notification. Please do not reply to this e-mail, as there will be no response.
                  This null message is confidential; its contents do not constitute a commitment by FPG Insurance Co., Inc.
                  except where provided in a written agreement between you and the company.
                  Any unauthorized disclosure, use or dissemination, either completely or in part, is prohibited.
                  If you are not the intended recipient of this message, please notify the sender immediately. </p>
               """
      ..attachments = [FileAttachment(File(_pdfPath))];

    try {
      final sendReport = await send(message, smtpServer);
      log('Message sent: $sendReport');
      Navigator.pop(context);
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        const CustomSnackBar.success(
          message: "Issuance has been saved and sent!",
        ),
      );
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //           title: const Text('Success'),
      //           content: const Text('Email has been Sent.'),
      //           actions: [
      //             TextButton(
      //                 onPressed: () {
      //                   Navigator.pop(context);
      //                   Navigator.pop(context);
      //                   Get.to(() => const ThankYouScreen());
      //                 },
      //                 child: const Text('OK'))
      //           ],
      //         ));
    } on MailerException catch (e) {
      log('Message not sent. ${e.message} ${e.problems.map((e) => e.msg).toList()}');
    }
    var connection = PersistentConnection(smtpServer);
    await connection.close();
  }

  String getClass() {
    switch (tocID) {
      case '4':
        vehicleClass = 'AC and Tourist Cars';
        return 'AC and Tourist Cars';
      case '3':
        vehicleClass = 'Heavy Trucks & Private Bus';
        return 'Heavy Trucks & Private Bus';
      case '2':
        vehicleClass = 'Light/Medium Truck';
        return 'Light/Medium Truck';
      case '7':
        vehicleClass = 'Motorcycles/Tricycles';
        return 'Motorcycles/Tricycles';
      case '6':
        vehicleClass = 'PUB and Tourist Bus';
        return 'PUB and Tourist Bus';
      case '5':
        vehicleClass = 'Taxi, PUJ and Mini Bus';
        return 'Taxi, PUJ and Mini Bus';
      case '15':
        vehicleClass = 'Trailers';
        return 'Trailers';
      case '1':
        vehicleClass = 'Private Cars';
        return 'Private Cars';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('tocBasicPremium  $toc', wrapWidth: 768);
    // engineNumberText.text = "";
    // chasisNumberText.text = "";
    // variantText.text = "";
    // conductionStickerText.text = "";
    // mvFileText.text = "";
    // colorText.text = "";
    // name.text = "romeo angelo";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "CTPL Issuance",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(defaultSizePrem),
        child: SingleChildScrollView(
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
                  branchName ?? "",
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
                initialValue: widget.plateText.toUpperCase(),
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
                      ctplTextValue = "No";
                      ctplBool = false;
                      getPolicyPeriod();
                    } else if (value == '2') {
                      ctplValueText = "3 YEAR COVERAGE";
                      ctplBool = true;
                      ctplTextValue = "Yes";
                      inceptionDate = DateFormat('yyyy-MM-dd').format(dateNow);
                      expirationDate = DateFormat('yyyy-MM-dd').format(DateTime(
                          dateNow.year + 3, dateNow.month, dateNow.day));
                    }
                  });
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
                onChanged: (value) {
                  basicPremium = value!['basic_premium'].toString();
                  setState(() {
                    docStamp =
                        ((double.parse(basicPremium.toString()) / 4).ceil()) *
                            .5;
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
                      getClass();
                      setState(() {});
                    }
                  }

                  getManufactureYear();
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
                          controller:
                              TextEditingController(text: inceptionDate),
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
                          controller:
                              TextEditingController(text: expirationDate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Vehicle Details",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Year Manufactured: ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomDropdownButton(
                value: year,
                items: manufactureYear.map((item) {
                  return DropdownMenuItem(
                    value: item['id'].toString(),
                    child: Text(item['name'].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  for (var row in manufactureYear) {
                    if (value == row["name"].toString()) {
                      yearValue = row["name"].toString();
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Car Company",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              FutureBuilder<List<CarCompanyList>>(
                future: getCarCompany(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownMenu(
                      width: 400,
                      menuHeight: 350,
                      focusNode: _carCompanyFocusNode,
                      controller: carCompanyController,
                      hintText: "Choose Option",
                      requestFocusOnTap: true,
                      inputDecorationTheme: InputDecorationTheme(
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
                      dropdownMenuEntries: snapshot.data!.map((e) {
                        return DropdownMenuEntry(
                          label: e.name.toString(),
                          value: e.id.toString(),
                        );
                      }).toList(),
                      onSelected: (String? newValue) {
                        _carCompanyFocusNode.unfocus();
                        setState(() {
                          carCompanyValue = newValue;
                          carMakeValue = null;
                          carTypeValue = null;
                        });
                      },
                    );
                    // return DropdownButtonFormField(
                    //   hint: const Text("Choose Option"),
                    //   value: carCompanyValue,
                    //   items: snapshot.data!.map((e) {
                    //     return DropdownMenuItem(
                    //         child: Text(e.name.toString()),
                    //         value: e.id.toString());
                    //   }).toList(),
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //   ),
                    //   icon: const Icon(Icons.arrow_drop_down),
                    //   validator: (value) {
                    //     if (value == null) {
                    //       return "Please Select Car Company";
                    //     }
                    //   },
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       carCompanyValue = newValue;
                    //       carMakeValue = null;
                    //       carTypeValue = null;
                    //     });
                    //   },
                    // );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Car Make and Model: ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              FutureBuilder<List<CarMakeList>>(
                future: getCarMake(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownMenu(
                      width: 400,
                      menuHeight: 350,
                      focusNode: _carMakeModelFocusNode,
                      hintText: "Choose Option",
                      requestFocusOnTap: true,
                      inputDecorationTheme: InputDecorationTheme(
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
                      dropdownMenuEntries: snapshot.data!.map((e) {
                        return DropdownMenuEntry(
                          value: e.id.toString(),
                          label: e.name.toString(),
                        );
                      }).toList(),
                      onSelected: (String? newValue) async {
                        _carMakeModelFocusNode.unfocus();

                        setState(() {
                          carMakeValue = newValue;
                          carTypeValue = null;
                        });
                        await getCarVariants();
                      },
                    );
                  } else {
                    return const Text(
                      "No Available Car Make for this Car Company.",
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Car Type of Body",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              FutureBuilder<List<CarTypeList>>(
                future: getCarType(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CustomDropdownButton(
                      value: snapshot.data == null || snapshot.data!.isEmpty
                          ? carTypeValue
                          : snapshot.data![0].id,
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.type.toString()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          carTypeValue = newValue;
                        });
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Car Variant",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              InputDropdownField(
                hintText: 'Car Variant',
                items: carVariant.map<String>((item) {
                  return item['name'];
                }).toList(),
                onChanged: (selectedValue) async {
                  variantText.text = selectedValue ?? '';
                  selectedCarVariant = selectedValue ?? '';
                  setState(() {});
                },
                initialValue: selectedCarVariant,
                validator: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
              const SizedBox(height: 10),
              const Text(
                "Transmission Type:",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomDropdownButton<String>(
                value: transmissionValue,
                items: transmission.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(item['text']),
                  );
                }).toList(),
                onChanged: (value) {
                  transmissionValue = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Chassis Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InputTextField(
                      controller: chasisNumberText,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: 'Enter Chassis Number',
                      validators: (text) =>
                          TextFieldValidators.validateChassisNumber(text),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Engine Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InputTextField(
                      controller: engineNumberText,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: 'Enter Engine Number',
                      validators: (text) =>
                          TextFieldValidators.validateEngineNumber(text),
                    ),
                    const SizedBox(height: 10),
                    // const Text(
                    //   "Variant",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontFamily: 'OpenSans',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // InputTextField(
                    //   controller: variantText,
                    //   autoValidateMode: AutovalidateMode.onUserInteraction,
                    //   hintText: 'Enter Variant',
                    //   // validators: (text) {
                    //   //   if (text == null || text.isEmpty) {
                    //   //     return "Please Enter Variant";
                    //   //   }
                    //   //   return null;
                    //   // },
                    // ),
                    const SizedBox(height: 10),
                    const Text(
                      "Conduction Sticker",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InputTextField(
                      controller: conductionStickerText,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: 'Enter Conduction Sticker',
                      validators: (text) {
                        if (text == null || text.isEmpty) {
                          return "Please Enter Conduction Sticker";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "MV File Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InputTextField(
                      controller: mvFileText,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: 'Enter MV File Number',
                      validators: (text) {
                        if (text == null || text.isEmpty) {
                          return "Please Enter MV File Number";
                        }
                        if (text.length > 15) {
                          return 'MV File Number should not be greater than 15 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Color",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InputTextField(
                      controller: colorText,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: 'Enter Color',
                      validators: (text) {
                        if (text == null || text.isEmpty) {
                          return "Please Enter Color";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Basic Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Text(
                                  //   "Insured Name",
                                  //   style: TextStyle(
                                  //     fontSize: 14,
                                  //     fontFamily: 'OpenSans',
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  InputTextField(
                                    controller: name,
                                    label: 'Insured Name',
                                    validators: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Please Enter Insured Name";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Text(
                                  //   "Birthday",
                                  //   style: TextStyle(
                                  //     fontSize: 14,
                                  //     fontFamily: 'OpenSans',
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  InputTextField(
                                    controller: birthDate,
                                    readOnly: true,
                                    label: 'Birthday',
                                    validators: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Please Enter Birthday";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      selectBirthDate();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (birthDate.text != '') {
                              getInsuredNameList();
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),
                                displayDuration: const Duration(seconds: 1),
                                const CustomSnackBar.info(
                                  message:
                                      "Birthday is required for validation",
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          label: const Icon(
                            Icons.search,
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tax Identification Number",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InputTextField(
                    controller: TextEditingController(text: insuredTin),
                    readOnly: true,
                    hintText: 'Enter Tax Identification Number',
                    validators: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please Enter Tax Identification Number";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InputTextField(
                    controller: TextEditingController(text: insuredAddress),
                    readOnly: true,
                    hintText: 'Enter Address',
                    validators: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please Enter Address";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tagging",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InputTextField(
                    controller:
                        TextEditingController(text: taggingText.toString()),
                    readOnly: true,
                    hintText: 'Enter Tagging',
                    validators: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please Enter Tagging";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(defaultSize),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 244, 238),
                  borderRadius: BorderRadius.circular(20),
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
                        '₱${totalPrem.toStringAsFixed(2).formatWithCommas()}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const Divider(),
                    const Text(
                      premBreak,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _rowTextData(
                      title: 'Basic Premium',
                      data: (basicPremium ?? '0.0').formatWithCommas(),
                    ),
                    // _rowTextData(
                    //   title: 'Local Tax Rate',
                    //   data: '$locTax%',
                    // ),
                    _rowTextData(
                      title: 'Documentary Stamps',
                      data: '₱$docStamp',
                    ),
                    _rowTextData(
                      title: 'Value Added Tax',
                      data: '₱${Vat.toStringAsFixed(2)}',
                    ),
                    _rowTextData(
                      title: 'Local Tax ($locTax%)',
                      data: '₱${lVat.toStringAsFixed(2)}',
                    ),
                    _rowTextData(
                      title: 'LTO Interconnectivity',
                      data: '₱$ltoInter',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  "I have read and understood and voluntarily agreed to the collection, use, and disclosure of my personal data in accordance with FPG Privacy Policy.",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                value: isChecked,
                onChanged: (bool? newBool) {
                  setState(() {
                    isChecked = newBool ?? false;
                  });
                },
              ),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: StatefulBuilder(builder: (context, setS) {
                      return ElevatedButton(
                        onPressed: isChecked
                            ? () async {
                                List<CarCompanyList> carCompanyName =
                                    await getCarCompany();
                                int index = carCompanyName.indexWhere(
                                    (element) => element.id == carCompanyValue);
                                CarCompanyList carCompName =
                                    carCompanyName[index];

                                List<CarMakeList> carMakeName =
                                    await getCarMake();
                                int indexMake = carMakeName.indexWhere(
                                    (element) => element.id == carMakeValue);
                                CarMakeList carMaName = carMakeName[indexMake];
                                var userData = await controller.getUserData();
                                final data = {
                                  'firstName': firstName.text,
                                  'middleName': middleName.text,
                                  'lastName': lastName.text,
                                  'suffix': '',
                                  'birthDate': birthDate.text,
                                  'birthPlace': birthPlace.text,
                                  'gender': insuredGender,
                                  'citizenship': citizenship.text,
                                  'insuredAddress': insuredAddress,
                                  'streetAddress': blkSt.text,
                                  'brgy': barangay.text,
                                  'city': cityState.text,
                                  'province': province.text,
                                  'country': insuredCountry,
                                  'phoneNo': phoneNumber.text,
                                  'mobileNo': mobileNumber.text,
                                  'email': insuredEmail,
                                  'tin': insuredTin,
                                  'incomeSource': '',
                                  'idType': '',
                                  'idNo': "",
                                  'yearManufactured': yearValue,
                                  'carMakeId': carCompanyValue,
                                  'carMakeName': carCompName.name,
                                  'carModelId': carMakeValue,
                                  'carModelName': carMaName.name,
                                  'bodyType': carTypeName,
                                  'transmissionType': transmissionValue,
                                  'engineNo': engineNumberText.text,
                                  'chassisNo': chasisNumberText.text,
                                  'color': colorText.text,
                                  'plateNo': widget.plateText.toUpperCase(),
                                  'conduction': conductionStickerText.text,
                                  'mvFileNo': mvFileText.text,
                                  'class': getClass(),
                                  'vehicleTypeId': tocID.toString(),
                                  'vehicleTypeName': tocName,
                                  'tocId': "",
                                  'tocName': "",
                                  'refNo': refNo,
                                  'source': 'EZH',
                                  'policyType':
                                      'Compulsory Third Party Liability',
                                  'intmCode': userData?.agentCode ?? '',
                                  'intmName': userData?.fullName ?? '',
                                  'branchCode': branchCode,
                                  'branchName': branchName,
                                  'inceptionDate': inceptionDate,
                                  'expiryDate': expirationDate,
                                  'commision': '0',
                                  'basicPremium': basicPremium,
                                  'dst': docStamp.toString(),
                                  'vat': Vat.toString(),
                                  'lgt': lVat.toString(),
                                  'lto': ltoInter.toString(),
                                  'totalPremium': totalPrem.toString(),
                                };
                                Get.to(() => CTPLDraftPolicy(
                                      policy: data,
                                      onSubmitPressed: isChecked
                                          ? (value) async {
                                              setState(() {
                                                _pdfPath = value;
                                              });
                                              await getPolicyNumber();
                                            }
                                          : null,
                                    ));
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xfffe5000),
                          disabledBackgroundColor: ColorPalette.primaryLighter,
                        ),
                        child: const Text(
                          'View Draft Policy',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                  // const SizedBox(width: 10),
                  // Center(
                  //   child: StatefulBuilder(builder: (context, setS) {
                  //     return ElevatedButton(
                  //       onPressed: isChecked
                  //           ? () async {
                  //               await getPolicyNumber();
                  //             }
                  //           : null,
                  //       style: OutlinedButton.styleFrom(
                  //         backgroundColor: const Color(0xfffe5000),
                  //         disabledBackgroundColor: ColorPalette.primaryLighter,
                  //       ),
                  //       child: const Text(
                  //         'Save & Send',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     );
                  //   }),
                  // ),
                ],
              ),

              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowTextData({required String title, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15.0,
                fontFamily: 'OpenSans',
                color: Color(0xfffe5000),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildTextInput(
  //   String label, {
  //   String? hintText,
  //   TextEditingController? value,
  //   String? Function(String?)? validators,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label),
  //       InputTextField(
  //         controller: value,
  //         hintText: hintText,
  //         autoValidateMode: AutovalidateMode.onUserInteraction,
  //         validators: validators,
  //       )
  //     ],
  //   );
  // }
}

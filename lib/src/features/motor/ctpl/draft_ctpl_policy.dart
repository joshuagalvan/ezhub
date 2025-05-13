import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';

class CTPLDraftPolicy extends StatefulHookWidget {
  const CTPLDraftPolicy({
    super.key,
    required this.policy,
    required this.onSubmitPressed,
  });

  final Map<String, dynamic> policy;
  final Function(String)? onSubmitPressed;
  @override
  State<CTPLDraftPolicy> createState() => _CTPLDraftPolicyState();
}

class _CTPLDraftPolicyState extends State<CTPLDraftPolicy> {
  String? _pdfPath;

  @override
  Widget build(BuildContext context) {
    // final ownDamage = useState<double>(0.0);
    // final actOfNature = useState<double>(0.0);
    final basicPremium = useState<double>(0.0);
    final docStamp = useState<double>(0.0);
    final vat = useState<double>(0.0);
    final lVat = useState<double>(0.0);
    final localTax = useState<double>(0.0);
    final totalPrem = useState<double>(0.0);
    final ltoInter = useState<double>(0.0);
    final policyNo = useState<String>('');
    final isLoading = useState<bool>(true);
    final loadingText = useState<String>('');

    Future<String> getTotalPremium() async {
      final controller = Get.put(ProfileController());
      var data = await controller.getBranch();
      localTax.value = data['locTax'];

      // ownDamage.value = double.parse(widget.policy.value.ownDamageRate ?? '') *
      //     double.parse(widget.policy.value.fairMarketValue ?? '');

      // actOfNature.value =
      //     double.parse(widget.policy.value.actOfNatureRate ?? '') *
      //         double.parse(widget.policy.value.fairMarketValue ?? '');

      basicPremium.value = double.parse(widget.policy['basicPremium'] ?? '0');
      ltoInter.value = double.parse(widget.policy['lto'] ?? '0.0');
      docStamp.value = ((basicPremium.value / 4).ceil()) * .5;
      vat.value = basicPremium.value * 0.12;
      lVat.value = (localTax.value * basicPremium.value) / 100;
      totalPrem.value = basicPremium.value +
          docStamp.value +
          vat.value +
          lVat.value +
          ltoInter.value;
      return '0.0';
    }

    // Future<List<CarCompanyList>> getCarCompany() async {
    //   try {
    //     final response = await http.post(Uri.parse(
    //         'http://10.52.2.124/motorquotation/getCarCompanyList_json/?toc=1'));
    //     final carCompany = (jsonDecode(response.body)) as List;
    //     if (response.statusCode == 200) {
    //       return carCompany.map((e) {
    //         final map = e as Map<String, dynamic>;
    //         return CarCompanyList.fromJson(map);
    //       }).toList();
    //     }
    //   } on SocketException {
    //     throw Exception('No Internet');
    //   }
    //   throw Exception('Error Fetching Data');
    // }

    // Future<List<CarMakeList>> getCarMake() async {
    //   if (widget.policy.value.carBrand == null) {
    //     return [];
    //   }
    //   try {
    //     final response = await http.post(
    //         Uri.parse(
    //             'http://10.52.2.124/motorquotation/getPiraCarModelByCarCompanyId_json/'),
    //         body: {'car_company_id': carCompanyValue});

    //     final carMake = (jsonDecode(response.body)) as List;

    //     if (response.statusCode == 200) {
    //       return carMake.map((e) {
    //         final map = e as Map<String, dynamic>;
    //         return CarMakeList(id: map['id'], name: map['name']);
    //       }).toList();
    //     }
    //   } on SocketException {
    //     throw Exception('No Internet');
    //   }
    //   throw Exception('Error Fetching Data');
    // }

    // void getPolicyNumber() async {
    //   showDialog(
    //     context: context,
    //     builder: (ctx) => const CustomLoadingDialog(
    //       loadingText: 'Loading...',
    //     ),
    //   );
    //   List<CarCompanyList> carCompanyName = await getCarCompany();
    //   int index = carCompanyName
    //       .indexWhere((element) => element.id == widget.policy.value.carBrand);
    //   CarCompanyList carCompName = carCompanyName[index];

    //   List<CarMakeList> carMakeName = await getCarMake();
    //   int indexMake =
    //       carMakeName.indexWhere((element) => element.id == carMakeValue);
    //   CarMakeList carMaName = carMakeName[indexMake];

    //   var userData = UserModel.fromJson(await GetStorage().read('userData'));
    //   final data = {
    //     'firstName': firstName.text,
    //     'middleName': middleName.text,
    //     'lastName': lastName.text,
    //     'suffix': '',
    //     'birthDate': birthDate.text,
    //     'birthPlace': birthPlace.text,
    //     'gender': insuredGender,
    //     'citizenship': citizenship.text,
    //     'streetAddress': blkSt.text,
    //     'brgy': barangay.text,
    //     'city': cityState.text,
    //     'province': province.text,
    //     'country': insuredCountry,
    //     'phoneNo': phoneNumber.text,
    //     'mobileNo': mobileNumber.text,
    //     'email': insuredEmail,
    //     'tin': insuredTin,
    //     'incomeSource': '',
    //     'idType': '',
    //     'idNo': "",
    //     'yearManufactured': yearValue,
    //     'carMakeId': carCompanyValue,
    //     'carMakeName': carCompName.name,
    //     'carModelId': carMakeValue,
    //     'carModelName': carMaName.name,
    //     'bodyType': carTypeName,
    //     'transmissionType': transmissionValue,
    //     'engineNo': engineNumberText.text,
    //     'chassisNo': chasisNumberText.text,
    //     'color': colorText.text,
    //     'plateNo': widget.plateText.toUpperCase(),
    //     'conduction': conductionStickerText.text,
    //     'mvFileNo': mvFileText.text,
    //     'vehicleTypeId': tocID.toString(),
    //     'vehicleTypeName': tocName,
    //     'tocId': "",
    //     'tocName': "",
    //     'refNo': refNo,
    //     'source': 'EZH',
    //     'policyType': 'Compulsory Third Party Liability',
    //     'intmCode': userData?.agentCode ?? '',
    //     'intmName': userData?.fullName ?? '',
    //     'branchCode': branchCode,
    //     'branchName': branchName,
    //     'inceptionDate': inceptionDate,
    //     'expiryDate': expirationDate,
    //     'commision': '0',
    //     'basicPremium': basicPremium,
    //     'dst': docStamp.toString(),
    //     'vat': Vat.toString(),
    //     'lgt': lVat.toString(),
    //     'lto': ltoInter.toString(),
    //     'totalPremium': totalPrem.toString(),
    //   };

    //   debugPrint('DATA $data', wrapWidth: 768);
    //   try {
    //     debugPrint(mobileNumber.text);
    //     final response = await http.post(
    //       Uri.parse('http://10.52.2.117:1003/api/motor-policies'),
    //       headers: {
    //         'X-Authorization':
    //             'HD0Y4Gf6v3WUwaBpJN44lZ2VNv2IDfCNoLVYWpZQHw9XXVXENMpNacK8oxQrujqb'
    //       },
    //       body: data,
    //     );
    //     var result = (jsonDecode(response.body));
    //     debugPrint('body ${response.body}');
    //     Navigator.pop(context);

    //     policyNumber = result['data']['policy_no'];
    //     debugPrint('policyNumber $policyNumber');
    //     id = result['data']['id'];
    //     debugPrint('id $id');
    //     emailSend();

    //     setState(() {});
    //   } catch (e) {
    //     log(e.toString());
    //   }
    // }

    Future<void> generatePdf() async {
      isLoading.value = true;
      loadingText.value = 'Generating Draft...';
      setState(() {
        _pdfPath = null;
      });
      final pdf = pw.Document();
      final fpgLogo =
          (await rootBundle.load('assets/fpg_logo.png')).buffer.asUint8List();
      final Uint8List fontData400 =
          (await rootBundle.load('assets/fonts/Inter-400.ttf'))
              .buffer
              .asUint8List();

      final Uint8List fontData600 =
          (await rootBundle.load('assets/fonts/Inter-600.ttf'))
              .buffer
              .asUint8List();

      final interFont400 = pw.Font.ttf(fontData400.buffer.asByteData());
      final interFont600 = pw.Font.ttf(fontData600.buffer.asByteData());

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Watermark.text('DRAFT'),
            ),
          ),
          header: (context) => pw.Row(
            children: [
              pw.Opacity(
                opacity: 0.5,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'FPG Insurance Co., Inc.',
                      style: pw.TextStyle(font: interFont600, fontSize: 6),
                    ),
                    pw.Text(
                      'Zuellig Building 6F, Makati Avenue cor. Paseo de Roxas, Makati City, 1225 Philippines',
                      style: pw.TextStyle(font: interFont400, fontSize: 6),
                    ),
                    pw.Row(
                      children: [
                        pw.Text(
                          '(632) 8859 1200, 7944 1300',
                          style: pw.TextStyle(font: interFont400, fontSize: 6),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Text(
                          '(632) 8811 5108',
                          style: pw.TextStyle(font: interFont400, fontSize: 6),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Text(
                          'www.fpgins.com',
                          style: pw.TextStyle(font: interFont400, fontSize: 6),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'VAT REG. TIN:  000-455-062-000',
                      style: pw.TextStyle(font: interFont400, fontSize: 6),
                    ),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Image(
                    pw.MemoryImage(fpgLogo),
                    width: 200,
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
          build: (context) => [
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text(
                'POLICY SCHEDULE',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Divider(),
            pw.Row(
              children: [
                pw.SizedBox(
                  width: 220,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "CLASS",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "${widget.policy['class']}",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "INSURED NAME",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "${widget.policy['firstName']} ${widget.policy[' middleName'] ?? ''} ${widget.policy['lastName']}",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "ADDRESS",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "${widget.policy['insuredAddress']}",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont400),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "TIN",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "${widget.policy['tin']}",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont400),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "TYPE OF PRODUCT",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "${widget.policy['policyType']}",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ///////////////////////////////////////////////////////////////////
                pw.Spacer(),
                pw.SizedBox(
                  width: 270,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              "POLICY NO.",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              policyNo.value,
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              "REF NO.",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "CTPL-${DateFormat('yyyyMMdd').format(DateTime.now())}${DateTime.now().millisecondsSinceEpoch}",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              "ACCOUNT CODE",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "${widget.policy['intmCode']}",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont400),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              "DATE OF ISSUANCE",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              DateFormat('dd MMMM yyyy').format(DateTime.now()),
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont400),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              "PERIOD OF",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "FROM",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              DateFormat('dd MMMM yyyy hh:mm a').format(
                                  DateTime.parse(
                                      widget.policy['inceptionDate'] ?? '')),
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont400),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              "INSURANCE",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "TO",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              DateFormat('dd MMMM yyyy hh:mm a').format(
                                  DateTime.parse(
                                      widget.policy['expiryDate'] ?? '')),
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(
                  width: 250,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Text(
                          "CTPL",
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: interFont600,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "PHP",
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: interFont400,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          "",
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: interFont400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 230,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "Premium",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "PHP",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "${basicPremium.value}".formatWithCommas(),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "DOCUMENTARY STAMPS",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "PHP",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "${docStamp.value}".formatWithCommas(),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "VALUE ADDED TAX",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "PHP",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "${vat.value}".formatWithCommas(),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "LOCAL TAX",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "PHP",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "${lVat.value}".formatWithCommas(),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "LTO INTERCONNECTIVITY",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "PHP",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "${widget.policy['lto']}".formatWithCommas(),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.Divider(indent: 130, height: 3),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "TOTAL AMOUNT DUE",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "PHP",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "${totalPrem.value}".formatWithCommas(),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(
                      width: 190,
                      child: pw.Text(
                        "INSURED VEHICLE",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "COVERAGE",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 100,
                      child: pw.Text(
                        "LIMIT OF LIABILITY",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 120,
                      child: pw.Text(
                        "PREMIUMS",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Divider(),
            pw.Column(
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 190,
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 70,
                            child: pw.Text(
                              "MAKE & MODEL",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                          pw.SizedBox(
                            width: 120,
                            child: pw.Text(
                              "${widget.policy['yearManufactured']} ${widget.policy['carMakeName']} ${widget.policy['carModelName']} ${widget.policy['vehicleTypeName']}",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "Section I/II CTPL",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "PHP  ",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '100,000',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "PHP ",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        "PLATE NO.",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 120,
                      child: pw.Text(
                        "${widget.policy['plateNo']}",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        "ENGINE NO.",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 120,
                      child: pw.Text(
                        "${widget.policy['engineNo']}",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        "CHASSIS NO.",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 120,
                      child: pw.Text(
                        "${widget.policy['chassisNo']}",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        "COC NO.",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 120,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Row(
                        children: [
                          pw.Text(
                            "",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        "AUTH. NO.",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 120,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Row(
                        children: [
                          pw.Text(
                            "",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        "COLOR",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 120,
                      child: pw.Text(
                        "${widget.policy['color']}",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "  ",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        "ACCESSORIES DECLARED",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
                      child: pw.Text(
                        "Standard Built-In",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 100,
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              "",
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont400,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '    PREMIUM',
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: interFont600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'PHP ${basicPremium.value.toString().formatWithCommas()}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Divider(),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 90,
                  child: pw.Text(
                    "DEDUCTIBLES",
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: interFont600,
                    ),
                  ),
                ),
                pw.SizedBox(
                  width: 30,
                  child: pw.Text(
                    ":",
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: interFont400,
                    ),
                  ),
                ),
                pw.SizedBox(
                  width: 70,
                  child: pw.Text(
                    'NIL',
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: interFont400,
                    ),
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.Text(
              'Own Damage/Theft Cover and Voluntary TPL Cover of Sections III and IV under this Policy are deemed deleted',
              style: pw.TextStyle(
                fontSize: 8,
                font: interFont600,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Column(
              children: [
                pw.Center(
                  child: pw.Text(
                    'Subject to the terms, conditions, warranties and clauses of the FPG Insurance Co. Inc. MOTOR VEHICLE Policy',
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: interFont600,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'IMPORTANT NOTICE : The Company reserves the right to inspect the Insured Vehicle at any time.',
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: interFont400,
                    ),
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.Text(
              "In Witness Whereof, the Company has caused this Policy to be signed by its duly authorized officer in Makati City, Philippines.",
              style: pw.TextStyle(font: interFont400, fontSize: 8),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Documentary Stamps to the value stated above have been affixed to the Policy. It is understood that upon the issuance of the Policy, no payment for Documentary Stamp Tax will be refunded as a result of the cancellation or endorsement of the policy or a reduction in the premium due for whatever reason.",
                        style: pw.TextStyle(font: interFont400, fontSize: 8),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        DateFormat('dd MMMM yyyy - hh:mm a')
                            .format(DateTime.now()),
                        style: pw.TextStyle(font: interFont400, fontSize: 8),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        "FPG INSURANCE CO., INC",
                        style: pw.TextStyle(font: interFont600, fontSize: 8),
                      ),
                      pw.SizedBox(height: 50),
                      pw.Text(
                        "GENEROSA PIO DE RODA",
                        style: pw.TextStyle(font: interFont600, fontSize: 8),
                      ),
                      pw.Center(
                        child: pw.Text(
                          "PRESIDENT & CEO",
                          style: pw.TextStyle(font: interFont400, fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/MotorCTPLPolicyDraftSchedule.pdf");
      await file.writeAsBytes(await pdf.save());

      setState(() {
        _pdfPath = file.path;
      });
      isLoading.value = false;
    }

    useEffect(() {
      asyncFunction() async {
        await getTotalPremium();
        generatePdf();
      }

      asyncFunction();
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "CTPL Draft Policy",
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
      body: Column(
        children: [
          // TextButton(
          //   onPressed: () {
          //     generatePdf();
          //   },
          //   child: Text('tets'),
          // ),
          _pdfPath != null
              ? Expanded(
                  child: PDFView(
                    filePath: _pdfPath,
                    autoSpacing: false,
                    fitEachPage: false,
                    onPageChanged: (page, _) {},
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SpinKitChasingDots(
                          color: ColorPalette.primaryColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          loadingText.value,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          if (_pdfPath != null)
            ElevatedButton(
              onPressed: () {
                widget.onSubmitPressed!(_pdfPath!);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xfffe5000),
                disabledBackgroundColor: ColorPalette.primaryLighter,
              ),
              child: const Text(
                'Save & Send',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }
}

//  _rowTextData(title: "POLICY NO.", data: '1234567890'),
//         _rowTextData(
//           title: "REF NO.",
//           data: '',
//         ),
//         _rowTextData(
//             title: "DATE OF ISSUANCE",
//             data: ,
//         _rowTextData(
//             title: "PERIOD OF INSURANCE FROM",
//             data: ,
//         _rowTextData(
//             title: "PERIOD OF INSURANCE TO",
//             data:
//                 ""),

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/models/policy.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PolicyScheduleStep extends StatefulHookWidget {
  const PolicyScheduleStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;
  @override
  State<PolicyScheduleStep> createState() => _PolicyScheduleStepState();
}

class _PolicyScheduleStepState extends State<PolicyScheduleStep> {
  String? _pdfPath;

  @override
  Widget build(BuildContext context) {
    final ownDamage = useState<double>(0.0);
    final actOfNature = useState<double>(0.0);
    final basicPremium = useState<double>(0.0);
    final docStamp = useState<double>(0.0);
    final vat = useState<double>(0.0);
    final lVat = useState<double>(0.0);
    final localTax = useState<double>(0.0);
    final totalPrem = useState<double>(0.0);
    final policyNo = useState<String>('');
    final isLoading = useState<bool>(true);
    final loadingText = useState<String>('');

    Future<String> getTotalPremium() async {
      final controller = Get.put(ProfileController());
      var data = await controller.getBranch();
      localTax.value = data['locTax'];

      ownDamage.value = double.parse(widget.policy.value.ownDamageRate ?? '') *
          double.parse(widget.policy.value.fairMarketValue ?? '');

      actOfNature.value =
          double.parse(widget.policy.value.actOfNatureRate ?? '') *
              double.parse(widget.policy.value.fairMarketValue ?? '');

      basicPremium.value = ownDamage.value +
          actOfNature.value +
          double.parse(widget.policy.value.vtplbiRate ?? '0') +
          double.parse(widget.policy.value.vtplpdRate ?? '0');

      docStamp.value = ((basicPremium.value / 4).ceil()) * .5;
      vat.value = basicPremium.value * 0.12;
      lVat.value = (localTax.value * basicPremium.value) / 100;
      totalPrem.value =
          basicPremium.value + docStamp.value + vat.value + lVat.value;
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
                              "${widget.policy.value.typeOfCover}",
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
                              "${widget.policy.value.fullName}",
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
                              "TIN",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "202-407-021-104",
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
                              "ADDRESS",
                              style:
                                  pw.TextStyle(fontSize: 8, font: interFont600),
                            ),
                          ),
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              "${widget.policy.value.address1} ${widget.policy.value.address2}",
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
                              "Comprehensive without CTPL",
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
                              '', //policyNo.value,
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
                              "EZH-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}",
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
                              "${widget.policy.value.agentCode}",
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
                                      widget.policy.value.policyPeriodFrom ??
                                          '')),
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
                              "${DateTime.parse(widget.policy.value.policyPeriodTo ?? '').day} ${DateFormat('MMMM').format(DateTime.parse(widget.policy.value.policyPeriodTo ?? ''))} ${DateTime.parse(widget.policy.value.policyPeriodTo ?? '').year} ${DateFormat('hh:mm a').format(DateTime.parse(widget.policy.value.policyPeriodTo ?? ''))}",
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
                          "Own Damage/Theft",
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
                          "${ownDamage.value}".formatWithCommas(),
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
                              "${widget.policy.value.yearManufactured} ${widget.policy.value.carBrand} ${widget.policy.value.carModel} ${widget.policy.value.carType}",
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
                        "Own Damage/Theft",
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
                              widget.policy.value.fairMarketValue
                                  .toString()
                                  .formatWithCommas(),
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
                        "PHP ${ownDamage.value.toString().formatWithCommas()}",
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
                        "${widget.policy.value.plateNumber}",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "ACT OF NATURE",
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
                              widget.policy.value.fairMarketValue
                                  .toString()
                                  .formatWithCommas(),
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
                        "PHP ${actOfNature.value.toString().formatWithCommas()}",
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
                        "${widget.policy.value.engineNumber}",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "VTPL - BODILY INJURY",
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
                              widget.policy.value.fairMarketValue
                                  .toString()
                                  .formatWithCommas(),
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
                        "PHP ${widget.policy.value.vtplbiRate.toString().formatWithCommas()}",
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
                        "${widget.policy.value.chassisNumber}",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "VTPL - PROPERTY DAMAGE",
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
                              widget.policy.value.fairMarketValue
                                  .toString()
                                  .formatWithCommas(),
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
                        "PHP ${widget.policy.value.vtplpdRate.toString().formatWithCommas()}",
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
                        "GREEN",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont400,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 140,
                      child: pw.Text(
                        "Riot, Strike & Civil Commotion",
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
                            "PHP  ",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              'FREE',
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
                        "PHP 0.0",
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
                      width: 120,
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
                        "Auto Personal Accident",
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
                            "PHP  ",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: interFont400,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              'FREE',
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
                        "PHP 0.0",
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
                        "",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: interFont600,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      width: 90,
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
                              'PREMIUM',
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
                    widget.policy.value.deductibles
                        .toString()
                        .formatWithCommas(),
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
              'Compulsory TPL under Section I/II of this Policy is deemed deleted',
              style: pw.TextStyle(
                fontSize: 8,
                font: interFont600,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'The following Clauses and Endorsements apply to this Policy:',
              style: pw.TextStyle(
                fontSize: 8,
                font: interFont600,
              ),
            ),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "• Accessories Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Auto Personal Accident Endorsement",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Airbag Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Aluminum Van Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Deductible Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Dealer or Casa Repair Shop Clause\n   (for Units 5 years old & below),\n   subject to Standard Depreciation ",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Importation Clause (for imported cars)",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                  ],
                ),
                pw.SizedBox(width: 30),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "• Pair and Set Endorsement",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Mortgagee Clause (if applicable)",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Terrorism and Sabotage Exclusion Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Electronic data Recognition Exclusion Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Total Asbestos Exclusion Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Communicable Disease Exclusion (LMA5394)",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Property Cyber and Data Exclusion Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Coronavirus Exclusion",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                    pw.Text(
                      "• Sanction Limitation and Exclusion Clause",
                      style: pw.TextStyle(font: interFont400, fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
            pw.Divider(),
            pw.Column(
              children: [
                pw.Center(
                  child: pw.Text(
                    "Subject to the terms, conditions, warranties, and clauses of the FPG Insurance Co. Inc. MOTOR VEHICLE Policy",
                    style: pw.TextStyle(font: interFont600, fontSize: 8),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    "IMPORTANT NOTICE: The Company reserves the right to inspect the Insured Vehicle at any time.",
                    style: pw.TextStyle(font: interFont400, fontSize: 8),
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
                      pw.SizedBox(height: 60),
                      pw.Text(
                        "BREFERJANE ABELADO",
                        style: pw.TextStyle(font: interFont600, fontSize: 8),
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
      final file = File("${output.path}/MotorQuotation.pdf");
      await file.writeAsBytes(await pdf.save());

      setState(() {
        _pdfPath = file.path;
      });
      isLoading.value = false;
    }

    Future<void> emailSend() async {
      // final controller = Get.put(ProfileController());
      // var userData = await controller.getUserData();
      showDialog(
        context: context,
        builder: (ctx) => const CustomLoadingDialog(
          loadingText: 'Sending email',
        ),
      );
      var userData = UserModel.fromJson(await GetStorage().read('userData'));
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
        ..recipients.add(widget.policy.value.email)
        // ..recipients.add('jgalvan@fpgins.com')
        ..subject =
            'Motor Comprehensive Insurance Payment and Preview Email ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}'
        ..html = """
                  <p>Greetings, <b>${widget.policy.value.fullName},</b><br></p>
                  <p>We appreciate you picking FPG Insurance! This is your vehicle's Comprehensive Insurance Preview Email. <br><br>
                     ${userData.fullName}, your insurance agent, will walk you through the remaining steps of the insurance process. <br><br>
                  <p>We appreciate your business and are eager to insure you! <br><br></p>
                  <p>This Email will Provide you the Reference Number to be used in paying your insurance policy and the link to where will you pay. <br><br>
                  Attached is a PDF File of the Preview of your Upcoming Policy.<br><br></p>
                  <p>Reference Number: ${policyNo.value} <br><br>
                  <a href="http://10.52.2.124:9013"><p>Click Here to Proceed to Payment</p></a></p>
                  <p style="color:#eb6434">FPG INSURANCE<br><br><br> </p>
                  <p style="font-style:italic; font-size:12px;">DISCLAIMER: This is an automatically generated e-mail notification. Please do not reply to this e-mail, as there will be no response.
                  This null message is confidential; its contents do not constitute a commitment by FPG Insurance Co., Inc.
                  except where provided in a written agreement between you and the company.
                  Any unauthorized disclosure, use or dissemination, either completely or in part, is prohibited.
                  If you are not the intended recipient of this message, please notify the sender immediately. </p>
               """
        ..attachments = [FileAttachment(File(_pdfPath!))];

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

    Future<void> sendSoapRequest() async {
      showDialog(
        context: context,
        builder: (ctx) => const CustomLoadingDialog(
          loadingText: 'Loading...',
        ),
      );
      var branchData = await GetStorage().read('branch');
      final url = Uri.parse('http://10.52.254.164:8181');
      final data = {
        "USERNAME": "uhqQVqoAGus=",
        "PASSWORD": "",
        "PRIVATEKEY": "3A7A616F48A944A5",
        "PRODUCTID": "${widget.policy.value.productId}",
        "TOPRO": "${widget.policy.value.toPro}",
        "TAXID": "",
        "REFNO": "EZH-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}",
        "REFID": "",
        "LONG_INSURED_NAME": "${widget.policy.value.fullName}",
        "INSUREDNAME": "${widget.policy.value.fullName}",
        "GENDER": widget.policy.value.gender ?? '',
        "BIRTHDATE": "${widget.policy.value.dateOfBirth}",
        "ID_NO": "123",
        "ADDRESS1": "${widget.policy.value.address1}",
        "ADDRESS2": "${widget.policy.value.address2}",
        "ADDRESS3": "",
        "AID": "${widget.policy.value.agentCode}",
        "OCCUPATION": "",
        "CITY": "",
        "ZIPCODE": "",
        "PHONENO": "${widget.policy.value.phoneNo}",
        "HANDPHONE": "${widget.policy.value.mobileNo}",
        "EMAIL": "${widget.policy.value.email}",
        "UTILIZATION": "Personal",
        "PLATNUMBER": "${widget.policy.value.plateNumber}",
        "VEHICLEBRAND": "${widget.policy.value.carBrand}",
        "VEHICLETYPE": "${widget.policy.value.carType}",
        "TYPEOFBODY": "${widget.policy.value.carModel}",
        "VEHICLEVARIANCE": "${widget.policy.value.carVariant}",
        "NUMBEROFPASSENGGER": "",
        "AUTOMATIC": "",
        "CHASSISNUMBER": "${widget.policy.value.chassisNumber}",
        "MACHINENUMBER": "${widget.policy.value.engineNumber}",
        "COLOR": "${widget.policy.value.carColor}",
        "PRODUCTIONYEAR": "${widget.policy.value.yearManufactured}",
        "ADATE": "${widget.policy.value.policyPeriodFrom}",
        "EDATE": "${widget.policy.value.policyPeriodTo}",
        "ACCESORISDECLARED": "",
        "MVFILENO": "${widget.policy.value.mvFileNo}",
        "NAMEINPARTY": "",
        "TYPEINPARTY": "",
        "CODECOVERAGE1": "ODT-${widget.policy.value.productId}",
        "TSI1": "${widget.policy.value.fairMarketValue}",
        "CODECOVERAGE2": "AON-02",
        "TSI2": "${widget.policy.value.fairMarketValue}",
        "CODECOVERAGE3": "RSCC-02",
        "TSI3": "0",
        "CODECOVERAGE4": "VTPLB-${widget.policy.value.productId}",
        "TSI4": "${double.parse(widget.policy.value.vtplbiAmount ?? '0.0')}",
        "CODECOVERAGE5": "VTPLP-${widget.policy.value.productId}",
        "TSI5": "${double.parse(widget.policy.value.vtplpdAmount ?? '0.0')}",
        "CODECOVERAGE6": "APA-02",
        "TSI6": "0",
        "PREMI": "${widget.policy.value.basicPremium}",
        "SPREMI": "",
        "RATE_1": double.parse(widget.policy.value.ownDamageAmount ?? '0.0')
            .toStringAsFixed(2),
        "RATE_2": double.parse(widget.policy.value.actOfNatureAmount ?? '0.0')
            .toStringAsFixed(2),
        "RATE_3": "0",
        "RATE_4": "${widget.policy.value.vtplbiRate}",
        "RATE_5": "${widget.policy.value.vtplpdRate}",
        "RATE_6": "",
        "DISCPERCENTAGE": "0",
        "DISCFEE": "0",
        "ADMINFEE": "0",
        "NOTE": "",
        "BRANCH": "${branchData['code']}",
        "StampDuty": "${widget.policy.value.docStamp}",
        "Segment": "06",
        "FEE": "0",
        "BSType": "Standard",
        "AID_1": "0",
        "Fee_1": "0",
        "BSType_1": "0",
        "AID_2": "0",
        "Fee_2": "0",
        "BSType_2": "0",
        "AID_3": "0",
        "Fee_3": "0",
        "BSType_3": "0",
        "AID_4": "0",
        "Fee_4": "0",
        "BSType_4": "0",
        "AIDCoverageCode": "ODT-${widget.policy.value.productId}",
        "AIDCoverageCode_1": "",
        "AIDCoverageCode_2": "",
        "AIDCoverageCode_3": "",
        "AIDCoverageCode_4": "",
        "SDPCT": "12.5",
        "Grace": "0",
        "OPFEEID": "",
        "OPFEEREMARK": "",
        "OPFEECURRENCY": "",
        "OPFEEAMOUNT": "0",
        "OPFEEAMOUNTPCT": "0",
        "OPFEECONTRIBUTIONF": "0",
        "InsuredID": "",
        "ConductionSticker": "${widget.policy.value.conductionSticker}",
        "TSI7": "0",
        "TSI8": "0",
        "TSI9": "0",
        "TSI10": "0"
      };

      debugPrint('CHECK BODY --> ${jsonEncode(data)}', wrapWidth: 768);
//sample only ID_NO
      final headers = {
        'Content-Type': 'application/json',
      };
      try {
        final response =
            await http.post(url, headers: headers, body: jsonEncode(data));
        log('Response data: ${response.statusCode} ${response.request!.url} ${response.body}');
        if (response.statusCode == 200) {
          final RegExp policyNoPattern = RegExp(r'PolicyNo=([A-Za-z0-9]+)');
          final RegExpMatch? match = policyNoPattern.firstMatch(response.body);
          if (match != null) {
            final String policyNoResult = match.group(1)!;
            log('PolicyNo: $policyNoResult');
            policyNo.value = policyNoResult;
            Navigator.pop(context);
            await emailSend();
          } else {}
        } else {
          log('Error: ${response.statusCode} ${response.body}');
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            displayDuration: const Duration(seconds: 1),
            const CustomSnackBar.error(
              message: "There is an error sending to CARE",
            ),
          );
        }
      } catch (e) {
        Navigator.pop(context);
        showTopSnackBar(
          Overlay.of(context),
          displayDuration: const Duration(seconds: 1),
          const CustomSnackBar.error(
            message: "There is an error sending to CARE",
          ),
        );
        log('Error: $e');
      }
    }

    useEffect(() {
      asyncFunction() async {
        await getTotalPremium();
        // await sendSoapRequest();
        await generatePdf();
      }

      asyncFunction();
      return null;
    }, []);

    return Column(
      children: [
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
            onPressed: () async {
              await sendSoapRequest();
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

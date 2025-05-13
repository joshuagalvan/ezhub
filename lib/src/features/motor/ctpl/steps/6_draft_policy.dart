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
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:simone/src/features/authentication/models/carcompany_model.dart';
import 'package:simone/src/features/authentication/models/carmake_model.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CTPLDraftPolicyStep extends StatefulHookWidget {
  const CTPLDraftPolicyStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
  });

  final ValueNotifier<CTPLPolicy> policy;
  final Function(CTPLPolicy) updatePolicy;
  @override
  State<CTPLDraftPolicyStep> createState() => _CTPLDraftPolicyStepState();
}

class _CTPLDraftPolicyStepState extends State<CTPLDraftPolicyStep> {
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
    final policyNumber = useState<String>('');

    Future<String> getTotalPremium() async {
      final controller = Get.put(ProfileController());
      var data = await controller.getBranch();
      localTax.value = data['locTax'];

      // ownDamage.value = double.parse(widget.policy.value.ownDamageRate ?? '') *
      //     double.parse(widget.policy.value.fairMarketValue ?? '');

      // actOfNature.value =
      //     double.parse(widget.policy.value.actOfNatureRate ?? '') *
      //         double.parse(widget.policy.value.fairMarketValue ?? '');

      basicPremium.value =
          double.parse(widget.policy.value.basicPremium ?? '0');
      ltoInter.value = double.parse(widget.policy.value.lto ?? '0.0');
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

    Future<List<CarCompanyList>> getCarCompany() async {
      try {
        final response = await http.post(Uri.parse(
            'http://10.52.2.124/motorquotation/getCarCompanyList_json/?toc=1'));
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
      if (widget.policy.value.carMakeBrand == null) {
        return [];
      }
      try {
        final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motorquotation/getPiraCarModelByCarCompanyId_json/'),
          body: {
            'car_company_id': widget.policy.value.carMakeBrandId,
          },
        );

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

    String getClass() {
      switch (widget.policy.value.vehicleTypeId) {
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

    Future<void> generatePdf() async {
      isLoading.value = true;
      loadingText.value = 'Generating Draft...';
      setState(() {
        _pdfPath = null;
      });
      var userData = UserModel.fromJson(await GetStorage().read('userData'));
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
                              getClass(),
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
                              "${widget.policy.value.streetAddress} ${widget.policy.value.brgy} ${widget.policy.value.city} ${widget.policy.value.province} Philippines ${widget.policy.value.zip} ",
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
                              "${widget.policy.value.tin}",
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
                              "Compulsory Third Party Liability",
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
                              userData.agentCode,
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
                              DateFormat('dd MMMM yyyy hh:mm NOON').format(
                                  DateTime.parse(
                                      widget.policy.value.inceptionDate ?? '')),
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
                              DateFormat('dd MMMM yyyy hh:mm NOON').format(
                                  DateTime.parse(
                                      widget.policy.value.expiryDate ?? '')),
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
                              "${widget.policy.value.lto}".formatWithCommas(),
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
                              "${widget.policy.value.yearManufactured} ${widget.policy.value.carMakeBrand} ${widget.policy.value.carModel} ${widget.policy.value.vehicleTypeName}",
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
                        "${widget.policy.value.color}",
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

    Map<String, String> splitFullName(String fullName) {
      // Trim extra spaces
      fullName = fullName.trim();

      // Split the full name into parts
      List<String> nameParts = fullName.split(RegExp(r'\s+'));

      // Initialize variables
      String firstName = '';
      String middleName = '';
      String lastName = '';

      if (nameParts.length == 1) {
        // Only one name part provided
        firstName = nameParts[0];
      } else if (nameParts.length == 2) {
        // Two parts: Assume first and last name
        firstName = nameParts[0];
        lastName = nameParts[1];
      } else {
        // Three or more parts: Assume first, middle, and last name
        firstName = nameParts[0];
        lastName = nameParts.last;
        middleName = nameParts.sublist(1, nameParts.length - 1).join(' ');
      }

      return {
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
      };
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

      final smtpServer = SmtpServer('10.52.254.55',
          port: 25, allowInsecure: true, ignoreBadCertificate: true);
      // Link for Payment Deployed <a href="http://ph-webpayment.fpgins.com"></a>
      final message = Message()
        ..from =
            const Address("ezhub-donotreply@fpgins.com", "EZHub by FPG - UAT")
        ..recipients.add(widget.policy.value.email)
        // ..recipients.add('jgalvan@fpgins.com')
        ..subject =
            'Motor CTPL Insurance Payment and Preview Email ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}'
        ..html = """
                  <p>Greetings, <b>${widget.policy.value.fullName},</b><br></p>
                  <p>We appreciate you picking FPG Insurance! This is your vehicle's CTPL Insurance Preview Email. <br><br>
                     ${userData.fullName}, your insurance agent, will walk you through the remaining steps of the insurance process. <br><br>
                  <p>We appreciate your business and are eager to insure you! <br><br></p>
                  <p>This Email will Provide you the Reference Number to be used in paying your insurance policy and the link to where will you pay. <br><br>
                  Attached is a PDF File of the Preview of your Upcoming Policy.<br><br></p>
                  <p>Reference Number: ${policyNumber.value} <br><br>
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

    Future<void> getPolicyNumber() async {
      showDialog(
        context: context,
        builder: (ctx) => const CustomLoadingDialog(
          loadingText: 'Loading...',
        ),
      );
      final policyData = widget.policy.value;
      // List<CarCompanyList> carCompanyName = await getCarCompany();
      // int index = carCompanyName
      //     .indexWhere((element) => element.id == policyData.carMakeBrandId);
      // CarCompanyList carCompName = carCompanyName[index];

      // List<CarMakeList> carMakeName = await getCarMake();
      // int indexMake = carMakeName
      //     .indexWhere((element) => element.id == policyData.carModelId);
      // CarMakeList carMaName = carMakeName[indexMake];

      var userData = UserModel.fromJson(await GetStorage().read('userData'));
      var branchData = await GetStorage().read('branch');

      // final data = {
      //   "USERNAME": "uhqQVqoAGus=",
      //   "PASSWORD": "",
      //   "PRIVATEKEY": "3A7A616F48A944A5",
      //   "PRODUCTID": "0201",
      //   "TOPRO": 'Compulsory Third Party Liability',
      //   "TAXID": "",
      //   "REFNO":
      //       "CTPL-${DateFormat('yyyyMMdd').format(DateTime.now())}${DateTime.now().millisecondsSinceEpoch}",
      //   "REFID": "",
      //   "LONG_INSURED_NAME":
      //       "${policyData.firstName} ${policyData.middleName} ${policyData.lastName}",
      //   "INSUREDNAME":
      //       "${policyData.firstName} ${policyData.middleName} ${policyData.lastName}",
      //   "GENDER": policyData.gender,
      //   "BIRTHDATE": policyData.birthDate,
      //   "ID_NO": userData.agentCode,
      //   "ADDRESS1": "${policyData.streetAddress} ${policyData.brgy}",
      //   "ADDRESS2": "${policyData.city} ${policyData.province}",
      //   "ADDRESS3": "",
      //   "AID": "M02AI00001",
      //   "OCCUPATION": "Engneer",
      //   "CITY": policyData.city,
      //   "ZIPCODE": policyData.zip,
      //   "PHONENO": policyData.phoneNo ?? '',
      //   "HANDPHONE": policyData.mobileNo,
      //   "EMAIL": policyData.email,
      //   "UTILIZATION": "Personal",
      //   "PLATNUMBER": policyData.plateNumber?.toUpperCase(),
      //   "VEHICLEBRAND": policyData.carMakeBrand,
      //   "VEHICLETYPE": policyData.carType,
      //   "TYPEOFBODY": policyData.carModel,
      //   "VEHICLEVARIANCE": policyData.carVariant,
      //   "NUMBEROFPASSENGGER": "",
      //   "AUTOMATIC": "",
      //   "CHASSISNUMBER": policyData.chassisNumber,
      //   "MACHINENUMBER": policyData.engineNumber,
      //   "COLOR": policyData.color,
      //   "PRODUCTIONYEAR": policyData.yearManufactured,
      //   "ADATE": policyData.inceptionDate,
      //   "EDATE": policyData.expiryDate,
      //   "ACCESORISDECLARED": "Yes",
      //   "MVFILENO": policyData.mvFileNumber,
      //   "NAMEINPARTY": "",
      //   "TYPEINPARTY": "",
      //   "CODECOVERAGE1": "CTPL-0201",
      //   "TSI1": "200000",
      //   "CODECOVERAGE2": "",
      //   "TSI2": "0",
      //   "CODECOVERAGE3": "",
      //   "TSI3": "0",
      //   "CODECOVERAGE4": "",
      //   "TSI4": "0",
      //   "CODECOVERAGE5": "",
      //   "TSI5": "0",
      //   "CODECOVERAGE6": "",
      //   "TSI6": "0",
      //   "PREMI": basicPremium.value.toString(),
      //   "SPREMI": "",
      //   "RATE_1": basicPremium.value.toString(),
      //   "RATE_2": "0",
      //   "RATE_3": "0",
      //   "RATE_4": "0",
      //   "RATE_5": "0",
      //   "RATE_6": "0",
      //   "DISCPERCENTAGE": "0",
      //   "DISCFEE": "0",
      //   "ADMINFEE": "0",
      //   "NOTE": "",
      //   "BRANCH": branchData['code'],
      //   "StampDuty": docStamp.value.toString(),
      //   "Segment": "06",
      //   "FEE": "0",
      //   "BSType": "Standard",
      //   "AID_1": "0",
      //   "Fee_1": "0",
      //   "BSType_1": "0",
      //   "AID_2": "0",
      //   "Fee_2": "0",
      //   "BSType_2": "0",
      //   "AID_3": "0",
      //   "Fee_3": "0",
      //   "BSType_3": "0",
      //   "AID_4": "0",
      //   "Fee_4": "0",
      //   "BSType_4": "0",
      //   "AIDCoverageCode": "",
      //   "AIDCoverageCode_1": "",
      //   "AIDCoverageCode_2": "",
      //   "AIDCoverageCode_3": "",
      //   "AIDCoverageCode_4": "",
      //   "SDPCT": "12.5",
      //   "Grace": "0",
      //   "OPFEEID": "",
      //   "OPFEEREMARK": "",
      //   "OPFEECURRENCY": "",
      //   "OPFEEAMOUNT": "0",
      //   "OPFEEAMOUNTPCT": "0",
      //   "OPFEECONTRIBUTIONF": "0",
      //   "InsuredID": "",
      //   "ConductionSticker": policyData.conductionSticker,
      //   "TSI7": "0",
      //   "TSI8": "0",
      //   "TSI9": "0",
      //   "TSI10": "0"
      // };

      final data = {
        'firstName': splitFullName(policyData.fullName ?? '')['firstName'],
        'middleName': splitFullName(policyData.fullName ?? '')['middleName'],
        'lastName': splitFullName(policyData.fullName ?? '')['lastName'],
        'suffix': '',
        'birthDate': policyData.birthDate,
        'birthPlace': policyData.birthPlace,
        'gender': policyData.gender,
        'citizenship': policyData.citizenship,
        'streetAddress': policyData.streetAddress,
        'brgy': policyData.brgy,
        'city': policyData.city,
        'province': policyData.province,
        'country': 'Philippines',
        'phoneNo': policyData.phoneNo ?? '',
        'mobileNo': policyData.mobileNo,
        'email': policyData.email,
        'tin': policyData.tin,
        'incomeSource': policyData.incomeSource,
        'idType': policyData.idType,
        'idNo': policyData.idNo,
        'yearManufactured': policyData.yearManufactured,
        'carMakeId': policyData.carMakeBrandId,
        'carMakeName': policyData.carMakeBrand,
        'carModelId': policyData.carModelId,
        'carModelName': policyData.carModel,
        'bodyType': policyData.carType,
        'transmissionType': policyData.transmissionType,
        'engineNo': policyData.engineNumber,
        'chassisNo': policyData.chassisNumber,
        'color': policyData.color,
        'plateNo': policyData.plateNumber?.toUpperCase(),
        'conduction': policyData.conductionSticker,
        'mvFileNo': policyData.mvFileNumber,
        'vehicleTypeId': policyData.vehicleTypeId,
        'vehicleTypeName': policyData.vehicleTypeName,
        'tocId': "",
        'tocName': "",
        'refNo':
            "CTPL-${DateFormat('yyyyMMdd').format(DateTime.now())}${DateTime.now().millisecondsSinceEpoch}",
        'source': 'EZH',
        'policyType': 'Compulsory Third Party Liability',
        'intmCode': userData.agentCode,
        'intmName': userData.fullName,
        'branchCode': branchData['code'],
        'branchName': branchData['branch'],
        'inceptionDate': policyData.inceptionDate,
        'expiryDate': policyData.expiryDate,
        'commision': '0',
        'basicPremium': basicPremium.value.toString(),
        'dst': docStamp.value.toString(),
        'vat': vat.value.toString(),
        'lgt': lVat.value.toString(),
        'lto': ltoInter.value.toString(),
        'totalPremium': totalPrem.value.toString(),
      };

      debugPrint('DATA $data', wrapWidth: 768);
      try {
        final response = await http.post(
          Uri.parse('http://10.52.2.117:1003/api/motor-policies'),
          headers: {
            'X-Authorization':
                'Uskfm1KDr3KtCStV0W28oOoee8pTVkaCszauYNyyknDL9r5LLZv24Stt0GVWekeV'
          },
          body: data,
        );
        debugPrint('body  ${response.statusCode} ${response.body}');
        var result = (jsonDecode(response.body));

        policyNumber.value = result['data']['policy_no'];
        debugPrint('policyNumber ${policyNumber.value}');
        // id = result['data']['id'];
        // debugPrint('id $id');
        Navigator.pop(context);
        await emailSend();

        setState(() {});
      } catch (e) {
        Navigator.pop(context);
        log('ERR Fetching Policy No ${e.toString()}');
        showTopSnackBar(
          Overlay.of(context),
          displayDuration: const Duration(seconds: 1),
          const CustomSnackBar.error(
            message: "There is a problem pushing to CARE",
          ),
        );
      }
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
              onPressed: () async {
                await getPolicyNumber();
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

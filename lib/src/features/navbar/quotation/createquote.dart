// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/carcompany_model.dart';
import 'package:simone/src/features/authentication/models/carmake_model.dart';
import 'package:simone/src/features/authentication/models/cartype_model.dart';
import 'package:simone/src/features/authentication/models/carvariant_model.dart';
import 'package:simone/src/features/authentication/models/quotation_details_model.dart';
import 'package:simone/src/features/authentication/models/vtplbi_model.dart';
import 'package:simone/src/features/authentication/models/vtplpd_model.dart';
import 'package:simone/src/features/motor/productmotor.dart';
import 'package:simone/src/features/navbar/quotation/quotationlist.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/helpers/mysql.dart';
import 'package:simone/src/utils/extensions.dart';
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateQuote extends StatefulWidget {
  const CreateQuote({super.key});

  @override
  State<CreateQuote> createState() => _CreateQuoteState();
}

class _CreateQuoteState extends State<CreateQuote> {
  final api = Api();
  String? branchName, carCompanyName;
  double locTax = 0;
  dynamic fmv = 0;
  String? tocID;
  String? deductible;
  List<dynamic> toc = [];
  List<dynamic> ratesList = [];
  String? carTypeName;
  dynamic objToc;
  dynamic odRate, aonRate;
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
  bool isReferToBranch = false;

  @override
  void initState() {
    super.initState();
    getBranch();
    getToc();
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

  Future<void> emailSend() async {
    List<CarCompanyList> carCompanyName = await getCarCompany();
    int index =
        carCompanyName.indexWhere((element) => element.id == carCompanyValue);
    CarCompanyList carCompName = carCompanyName[index];

    List<CarMakeList> carMakeName = await getCarMake();
    int indexMake =
        carMakeName.indexWhere((element) => element.id == carMakeValue);
    CarMakeList carMaName = carMakeName[indexMake];

    final controller = Get.put(ProfileController());
    var userData = await controller.getUserData();

    final pdf = pw.Document();
    final fpgLogo =
        (await rootBundle.load('assets/fpg_logo.png')).buffer.asUint8List();
    final Uint8List fontData400 =
        (await rootBundle.load('assets/fonts/Inter-400.ttf'))
            .buffer
            .asUint8List();
    final Uint8List fontData500 =
        (await rootBundle.load('assets/fonts/Inter-500.ttf'))
            .buffer
            .asUint8List();
    final Uint8List fontData600 =
        (await rootBundle.load('assets/fonts/Inter-600.ttf'))
            .buffer
            .asUint8List();
    final Uint8List fontData700 =
        (await rootBundle.load('assets/fonts/Inter-700.ttf'))
            .buffer
            .asUint8List();
    final ttf = pw.Font.ttf(fontData400.buffer.asByteData());
    final interFont400 = pw.Font.ttf(fontData400.buffer.asByteData());
    final interFont500 = pw.Font.ttf(fontData500.buffer.asByteData());
    final interFont600 = pw.Font.ttf(fontData600.buffer.asByteData());
    final interFont700 = pw.Font.ttf(fontData700.buffer.asByteData());

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Align(
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
        margin: const pw.EdgeInsets.fromLTRB(50, 50, 50, 30),
        footer: (context) => pw.Opacity(
          opacity: 0.5,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'FPG Insurance Co., Inc.',
                    style: pw.TextStyle(font: interFont600, fontSize: 8),
                  ),
                  pw.Text(
                    'Zuellig Building 6F, Makati Avenue cor. Paseo de Roxas, Makati City, 1225 Philippines',
                    style: pw.TextStyle(font: interFont400, fontSize: 8),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '(632) 8859 1200, 7944 1300',
                    style: pw.TextStyle(font: interFont400, fontSize: 8),
                  ),
                  pw.Text(
                    '(632) 8811 5108',
                    style: pw.TextStyle(font: interFont400, fontSize: 8),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'www.fpgins.com',
                    style: pw.TextStyle(font: interFont400, fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ),
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Text(
                    currentDateTodayWord,
                    style: pw.TextStyle(
                      font: interFont400,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Text(
                    "Subject:",
                    style: pw.TextStyle(font: interFont600, fontSize: 8),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    "MOTOR INSURANCE QUOTATION SLIP",
                    style: pw.TextStyle(
                      font: interFont700,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#fe5000'),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Text(
                    "Dear Sir/Madam:",
                    style: pw.TextStyle(
                      font: interFont400,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "We are pleased to submit for your consideration our Motor Vehicle Insurance proposal covering the above subject vehicle, with details of the terms and conditions as follows:",
                style: pw.TextStyle(font: ttf, fontSize: 8),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Text(
                    "Insurance Form",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 38),
                  pw.Text(":", style: pw.TextStyle(font: ttf, fontSize: 8)),
                  pw.SizedBox(width: 30),
                  pw.Text(
                    "FPG Motor Insurance Policy",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                ],
              ),
              pw.SizedBox(height: 5.0),
              pw.Row(
                children: [
                  pw.Text(
                    "Assured",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 66),
                  pw.Text(":", style: pw.TextStyle(font: ttf, fontSize: 8)),
                  pw.SizedBox(width: 30),
                  pw.Text(
                    name.text,
                    style: pw.TextStyle(
                      font: interFont500,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5.0),
              pw.Row(
                children: [
                  pw.Text(
                    "Unit to be Insured",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 29),
                  pw.Text(":", style: pw.TextStyle(font: ttf, fontSize: 8)),
                  pw.SizedBox(width: 30),
                  pw.Text(
                    "${carCompName.name} ${carMaName.name} $carTypeName $variantValue",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                children: [
                  pw.Text(
                    "Period of Insurance",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 23),
                  pw.Text(
                    ":",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 30),
                  // pw.Text("${periodOfInsuranceWord}",
                  //     style: pw.TextStyle(font: ttf, fontSize: 8)),
                  pw.Text(
                    "TBA",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2)
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Center(
                          child: pw.Text(
                            "Coverage",
                            style: pw.TextStyle(
                              font: interFont600,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Center(
                          child: pw.Text(
                            "Limit of Liability",
                            style: pw.TextStyle(
                              font: interFont600,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Center(
                          child: pw.Text(
                            "Premium",
                            style: pw.TextStyle(
                              font: interFont600,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          ownDamageTheft,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          "₱1,150,000.00",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${OD.toStringAsFixed(2).formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          actsofNature,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          "₱1,150,000.00",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${AON.toStringAsFixed(2).formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // pw.Text("",
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 10,
                      //     )),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          vtplB,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          "₱500,000.00",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${vtplBIValue.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // pw.Text("",
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 10,
                      //     )),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          vtplP,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          "₱500,000.00",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${vtplPDValue.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // pw.Text("",
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 10,
                      //     )),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          autoPaQuote,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          "₱250,000.00",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          "INCLUDED",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(""),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          basicPrem,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${basicPremium.toStringAsFixed(2).formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(""),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          docStamps,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${docStamp.toStringAsFixed(2).formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(""),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          vat,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${Vat.toStringAsFixed(2).formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(""),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          lGTax,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${lVat.toStringAsFixed(2).formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(""),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          totalPremium,
                          style: pw.TextStyle(
                            font: interFont600,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${totalPrem.toStringAsFixed(2).formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: interFont600,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10.0),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [],
              ),
              pw.SizedBox(height: 10),
              // pw.Row(children: [
              //   pw.Text("Mortgagee",
              //       style: pw.TextStyle(font: ttf, fontSize: 10)),
              //   pw.SizedBox(width: 20.0),
              //   pw.Text("-", style: pw.TextStyle(font: ttf, fontSize: 10)),
              //   pw.SizedBox(width: 53.0),
              //   pw.Text("", style: pw.TextStyle(font: ttf, fontSize: 10)),
              // ]),
              // pw.SizedBox(height: 20.0),
              pw.Row(
                children: [
                  pw.Text(
                    "Deductible",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 55),
                  pw.Text(":", style: pw.TextStyle(font: ttf, fontSize: 8)),
                  pw.SizedBox(width: 17),
                  pw.Text(
                    " ${objToc['deductible']}".formatWithCommas(),
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Applicable Clauses",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 24),
                  pw.Text(
                    ":",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                  pw.SizedBox(width: 12),
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
                      pw.Text(
                        "• Pair and Set Endorsement",
                        style: pw.TextStyle(font: interFont400, fontSize: 8),
                      ),
                    ],
                  ),
                  pw.SizedBox(width: 17),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
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
              pw.SizedBox(height: 20),
              pw.Text(
                "This quotation is subject to FPG Motor Vehicle standard policy wordings, its limitations, exclusions, conditions, provisions, and endorsements indicated hereto, if any, and is valid for thirty (30) days. Warranted no loss prior to issuance of the policy and is subject to the Assured's accomplishing the KYC form in accordance with the Anti-Money Laundering Act of 2001 as amended and IC circular letter no. 14-2004.",
                style: pw.TextStyle(font: ttf, fontSize: 8),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "We hope you find the above in order. Should you need further clarification, please do not hesitate to let us know.",
                style: pw.TextStyle(font: ttf, fontSize: 8),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Thank you for this opportunity and we look forward to receiving your further advice.",
                style: pw.TextStyle(font: ttf, fontSize: 8),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Text(
                    "Noted By:",
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Text(
                    userData?.fullName ?? '',
                    style: pw.TextStyle(
                      font: interFont600,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5.0),
              pw.Row(
                children: [
                  pw.Text(
                    "Manager - $branchName",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/MotorQuotation.pdf");
    await file.writeAsBytes(await pdf.save());

    final smtpServer = SmtpServer('10.52.254.55',
        port: 25, allowInsecure: true, ignoreBadCertificate: true);

    final message = Message()
      ..from =
          const Address("ezhub-donotreply@fpgins.com", "EZHub by FPG - UAT")
      ..recipients.add(email.text)
      ..subject = 'Motor Insurance Quotation Slip $currentDate'
      ..html = """
                  <p>Greetings, <b>${name.text},</b><br></p>
                  <p>We appreciate you picking FPG Insurance! This is your vehicle's motor insurance quote.<br><br>
                  ${userData?.fullName ?? ''}, your insurance agent, will walk you through the remaining steps of the insurance process.<br><br>
                  We appreciate your business and are eager to insure you!<br><br></p>
                  <p><a href="www.google.com">Agree with the quotation</a> or <a href="www.google.com">For Discussion</a></p>
                  <p>Attached is a PDF File of your Quotation.<br><br><br> </p>
                  <p style="color:#eb6434">FPG INSURANCE<br><br><br> </p>
                  <p style="font-style:italic; font-size:12px;">DISCLAIMER: This is an automatically generated e-mail notification. Please do not reply to this e-mail, as there will be no response.
                  This message is confidential; its contents do not constitute a commitment by FPG Insurance Co., Inc.
                  except where provided in a written agreement between you and the company.
                  Any unauthorized disclosure, use or dissemination, either completely or in part, is prohibited.
                  If you are not the intended recipient of this message, please notify the sender immediately. </p>
               """
      ..attachments = [
        FileAttachment(File("${output.path}/MotorQuotation.pdf"))
      ];

    try {
      final sendReport = await send(message, smtpServer);
      log('Message sent: $sendReport');
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        const CustomSnackBar.success(
          message: "Success! Email has been sent.",
        ),
      );
    } on MailerException catch (e) {
      log('Message not sent.');
      for (var p in e.problems) {
        log('Problem: ${p.code}: ${p.msg}');
      }
    }
    var connection = PersistentConnection(smtpServer);
    await connection.close();
  }

  Future<int> saveQuote({bool isIssuePolicy = false}) async {
    showDialog(
      context: context,
      builder: (context) => const CustomLoadingDialog(),
    );
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
      "deductible": objToc['deductible'],
      "total_premium": totalPrem,
      "basic_premium": basicPremium,
      "doc_stamp": docStamp,
      "vat": Vat,
      "local_tax": lVat,
      "od": OD,
      "aon": AON,
    };
    var result = await api.saveQuotation(details);
    Navigator.pop(context);
    if (result != null) {
      if (isIssuePolicy == false) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.warning,
          title: 'Save Quote',
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

  getToc() async {
    var result = await api.getTypeOfCover('motor_comprehensive');

    setState(() {
      toc = result['data'];
    });
  }

  getRates({required int toc}) async {
    var result = await api.getDefaultRates(toc);
    setState(() {
      ratesList = [];
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
      setState(() {
        branchName = (result['name']);
      });
    } catch (_) {}
  }

  Future<List<CarCompanyList>> getCarCompany() async {
    if (typeofcoverValue == null) {
      return [];
    }
    try {
      final response =
          await api.getCarCompanyList(typeOfCoverValue: typeofcoverValue ?? '');
      return response;
    } on SocketException {
      throw Exception('No Internet');
    }
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
      final result = await api.getCarTypeBody(
        carMakeModelId: carMakeValue ?? '',
        typeOfCoverValue: typeofcoverValue ?? '',
      );

      log('typebody $carMakeValue $typeofcoverValue');
      carTypeName = result.type;

      return [result].map((car) {
        return CarTypeList(
          id: car.id,
          status: car.status,
          typeId: car.typeId,
          type: car.type,
          capacity: car.capacity,
        );
      }).toList();
    } on SocketException {
      throw Exception('No Internet');
    }
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
        fmvValue.text = (fmv ?? "0");

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
        // Theft =
        //     double.parse(ratesValue) * double.parse(fmv.toString());
        AON = double.parse(aonRate != null ? aonRate.toString() : '0.0') *
            double.parse(fmv.toString());

        // BIValue = double.parse(vtplBIValue);
        // PDValue = double.parse(vtplPDValue);

        basicPremium = double.parse(OD.toString()) +
            double.parse(AON.toString()) +
            double.parse(vtplBIValue ?? '0') +
            double.parse(vtplPDValue ?? '0');

        //basicPremiumNoAON = double.parse(OD.toString());
        //totalPremNoAON = basicPremiumNoAON + docStamp + Vat + lVat;

        docStamp = ((basicPremium / 4).ceil()) * .5;
        Vat = basicPremium * 0.12;
        lVat = (double.parse(locTax.toString()) * basicPremium) / 100;
        // lVatNoAON =
        //     (double.parse(locTax.toString() ?? '') * basicPremiumNoAON) / 100;
        totalPrem = basicPremium + docStamp + Vat + lVat;
      });
      return list;
    } on SocketException {
      throw Exception('No Internet');
    }
  }

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
  double basicPremiumNoAON = 0;
  double totalPremNoAON = 0;
  double docStamp = 0;
  double Vat = 0;
  double lVat = 0;
  double lVatNoAON = 0;
  double totalPrem = 0;
  final email = TextEditingController();
  final name = TextEditingController();
  TextEditingController fmvValue = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Create Quote",
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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                        color: Color(0xfffe5000),
                        fontSize: 17.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                typeofCover,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
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
                      getRates(toc: row['id']);
                    }
                  }
                },
              ),
              const SizedBox(height: 15),
              const Text(
                rates,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              CustomDropdownButton<String>(
                items: [
                  ...ratesList.map((item) {
                    var ratePercent = double.parse(item['rate']) * 100;
                    return DropdownMenuItem(
                      value: item['id'].toString(),
                      child: Text(ratePercent.toStringAsFixed(2)),
                    );
                  }).toList(),
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please Select Rates";
                  }
                  return null;
                },
                onChanged: (newValue) {
                  setState(() {
                    //ratesValue = newValue!;
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
                  });

                  for (var row in ratesList) {
                    if (newValue == row['id'].toString()) {
                      odRate = row['own_damage'];
                      aonRate = row['act_of_nature'];
                      ratesValue = row['rate'];
                    }
                  }
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                year,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              CustomDropdownButton(
                value: yearValue,
                items: [
                  '2024',
                  '2023',
                  '2022',
                  '2021',
                  '2020',
                  '2019',
                  '2018',
                  '2017',
                  '2016',
                  '2015',
                  '2014',
                  '2013',
                  '2012',
                  '2011',
                  '2010',
                  '2009',
                ]
                    .map(
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ),
                    )
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return "Please Select Year";
                  }
                  return null;
                },
                onChanged: (newValue) {
                  setState(() {
                    yearValue = newValue!;
                    carCompanyValue = null;
                    carMakeValue = null;
                    carTypeValue = null;
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
                  });
                },
              ),

              const SizedBox(height: 15),

              const Text(
                carCompany,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              FutureBuilder<List<CarCompanyList>>(
                future: getCarCompany(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CustomDropdownButton(
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
                      onChanged: (String? newValue) {
                        setState(() {
                          carCompanyValue = newValue;
                          carMakeValue = null;
                          carTypeValue = null;
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
                        });
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 15),
              const Text(
                carMake,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
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
                      onChanged: (String? newValue) {
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
                      "No Available Car Make for this Car Company.",
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              const Text(
                carType,
                style: TextStyle(
                  fontSize: 14,
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
                      validator: (value) {
                        if (value == null) {
                          return "Car Type is Required";
                        }
                        return null;
                      },
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
              const SizedBox(height: 15),
              const Text(
                variant,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
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
                      validator: (value) {
                        if (value == null) {
                          return "Variant is Required";
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          variantValue = newValue;
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
                        getFmv();
                      },
                    );
                  } else {
                    variantValue = "No Variant Selected";
                    return const Text("No Data");
                  }
                },
              ),
              const SizedBox(height: 15),
              const Text(
                fairMarket,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              InputTextField(
                hintText: fairMarket,
                keyboardType: TextInputType.number,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                controller: fmvValue,
                onChanged: (value) async {
                  // check plate number
                  fmv = value;
                  await Future.delayed(const Duration(milliseconds: 500));
                  vtplb = await getVtplBI();
                  vtplp = await getVtplPD();

                  setState(() {
                    vtplb = vtplb
                        .where(
                          (i) =>
                              int.parse(i.name) <=
                              int.parse(
                                value.toString(),
                              ),
                        )
                        .toList();

                    vtplp = vtplp
                        .where(
                          (i) =>
                              int.parse(i.name) <=
                              int.parse(
                                value.toString(),
                              ),
                        )
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
                validators: (text) {
                  var value = text == '' ? '0' : text.toString();
                  if (tocID == '1' && int.parse(value) > 3000000) {
                    return "FMV is Over the Limit for Type of Cover";
                  } else if (text is int && int.parse(text.toString()) <= 0) {
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

              const SizedBox(height: 10),
              // CheckboxListTile(
              //     title: Text(addVolun),
              //     value: isChecked,
              //     activeColor: Colors.orangeAccent,
              //     onChanged: (bool? newBool) {
              //       setState(() {
              //         isChecked = newBool;
              //       });
              //     }),

              const Text(
                deduc,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              InputTextField(
                hintText: deduc,
                readOnly: true,
                controller: TextEditingController()
                  ..text =
                      objToc != null ? objToc['deductible'].toString() : '',
              ),
              const SizedBox(height: 15),
              const Text(
                vtplB,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5),
              CustomDropdownButton(
                value: vtplBIValue,
                items: [
                  ...vtplb.map((item) {
                    return DropdownMenuItem(
                      value: tocID == "3"
                          ? item.heavy.toString()
                          : item.light.toString(),
                      child: Text(item.name.toString()),
                    );
                  })
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please Select VTPL - Bodily Injury";
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    vtplBIValue = newValue;
                    vtplPDValue = null;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text(
                vtplP,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              CustomDropdownButton(
                value: vtplPDValue,
                items: [
                  ...vtplp.map((item) {
                    return DropdownMenuItem(
                      value: tocID == '3'
                          ? item.heavy.toString()
                          : item.light.toString(),
                      child: Text(item.name.toString()),
                    );
                  })
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please Select VTPL - Bodily Injury";
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    vtplPDValue = newValue;

                    AON = double.parse(aonRate.toString()) *
                        double.parse(fmvValue.text == "" ? "0" : fmvValue.text);
                    OD = double.parse(odRate.toString()) *
                        double.parse(fmvValue.text == "" ? "0" : fmvValue.text);
                    // Theft = double.parse(ratesValue) *
                    //     double.parse();
                    // AON = double.parse(ratesValue) *
                    //     double.parse();
                    // BIValue = double.parse(vtplBIValue ?? '');
                    // PDValue = double.parse(vtplPDValue ?? '');
                    basicPremium = double.parse(OD.toString()) +
                        double.parse(AON.toString()) +
                        double.parse(vtplBIValue ?? '0') +
                        double.parse(vtplPDValue ?? '0');
                    docStamp = ((basicPremium / 4).ceil()) * .5;
                    Vat = basicPremium * 0.12;
                    lVat =
                        (double.parse(locTax.toString()) * basicPremium) / 100;
                    totalPrem = basicPremium + docStamp + Vat + lVat;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text(
                "Client's Name",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              InputTextField(
                hintText: "Enter Client's Name",
                controller: name,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (text) => TextFieldValidators.validateName(text),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Client's Email",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              InputTextField(
                hintText: "Enter Client's Email",
                controller: email,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (text) => TextFieldValidators.validateEmail(text),
              ),
              const SizedBox(height: 20),
              const Text(
                'Quotation Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
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
                        'Total Premium',
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
                    Text(
                      premBreak.formatWithCommas(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _rowTextData(
                      title: 'Basic Premium',
                      data:
                          '₱${basicPremium.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Documentary Stamps',
                      data:
                          '₱${docStamp.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Value Added Tax',
                      data: '₱${Vat.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Local Tax',
                      data: '₱${lVat.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    const Divider(),
                    const Text(
                      benefits,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _rowTextData(
                      title: 'Own Damage/Theft',
                      data: '₱${OD.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Act of Nature',
                      data: '₱${AON.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'RSCC',
                      data: included,
                    ),
                    _rowTextData(
                      title: 'VTPL - Bodily Injury',
                      data: '₱${(vtplBIValue ?? '0.0').formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'VTPL - Property Damage',
                      data: '₱${(vtplPDValue ?? '0.0').formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Auto Personal Accident',
                      data: included,
                    ),
                    const Divider(),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // await getReferenceNumber();
                      refNo = 'EZ-MC-FQ-$currentYear-$currentMonth';
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await emailSend();
                        // await getReferenceNumber();
                        refNo = 'EZ-MC-FQ-$currentYear-$currentMonth}';
                        saveQuote();
                        refCounter = 1;
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xfffe5000),
                    ),
                    child: const Text(
                      emailQuote,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    // onPressed: () async {
                    //   // if (formKey.currentState!.validate()) {
                    //   //   await AgentQuotes();
                    //   await Myctplmatep();
                    // },
                    onPressed: () async {
                      setState(() {
                        refNo = 'EZ-MC-FQ-$currentYear-$currentMonth';
                      });
                      saveQuote(isIssuePolicy: true).then((id) async {
                        var result = await Api().getQuotationDetails(id);
                        final data = QuotationDetails.fromJson(result['data']);
                        Navigator.pop(context);
                        Get.to(
                          () => Productmotor(
                            from: 'quotation',
                            quotation: data,
                          ),
                        );
                      });
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
              )
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
}

// // For Issue Policy
//     // return Scaffold(
//     //   body: Center(
//     //     child: Container(
//     //       height: 408.0,
//     //       child: AlertDialog(
//     //         title: Text("Policy Vehicle Validation"),
//     //         content: Column(children: [
//     //           TextFormField(
//     //             decoration: const InputDecoration(
//     //                 prefixIcon: Icon(Icons.person_outline_outlined),
//     //                 labelText: (plateNo),
//     //                 hintText: (plateNo),
//     //                 border: OutlineInputBorder()),
//     //           ),
//     //           TextFormField(
//     //             decoration: const InputDecoration(
//     //                 prefixIcon: Icon(Icons.person_outline_outlined),
//     //                 labelText: (engineNo),
//     //                 hintText: (engineNo),
//     //                 border: OutlineInputBorder()),
//     //           ),
//     //           TextFormField(
//     //             decoration: const InputDecoration(
//     //                 prefixIcon: Icon(Icons.person_outline_outlined),
//     //                 labelText: (chasisNo),
//     //                 hintText: (chasisNo),
//     //                 border: OutlineInputBorder()),
//     //           ),
//     //         ]),
//     //         actions: [
//     //           TextButton(onPressed: () {}, child: const Text("Verify"))
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // );

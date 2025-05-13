// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/quotation_details_model.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/features/motor/productmotor.dart';
import 'package:simone/src/features/navbar/quotation/previewquote.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class QuotationList extends StatefulWidget {
  const QuotationList({super.key});

  @override
  State<QuotationList> createState() => _QuotationListState();
}

class _QuotationListState extends State<QuotationList> {
  final _searchController = TextEditingController();
  List<dynamic> agentQuotes = [];
  List<dynamic> filteredAgentQuotes = [];
  String currentDateToday = DateFormat('MMMM d y').format(DateTime.now());
  dynamic refNo,
      intermediary,
      created_date,
      name,
      email,
      branchValue,
      toc,
      rate,
      year,
      carCompanyValue,
      carMakeValue,
      carTypeValue,
      carVariantValue,
      fmv,
      deductible,
      totalpremium,
      basicPremium,
      docStamp,
      vatValue,
      localTaxValue,
      od,
      //theftValue,
      aon,
      periodOfInsurance,
      quotationExpiry,
      status,
      vtplbi,
      vtplpd;

  String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  String dateQuote = '';
  String periodOfInsuranceWord = '';
  String quotationExpiryWord = '';
  bool isLoading = false;
  // String? _pdfPath;

  @override
  void initState() {
    super.initState();
    getAgentCode();
    getAgentQuotes();
  }

  UserModel? userData;

  getAgentCode() async {
    final controller = Get.put(ProfileController());
    var tempUser = await controller.getUserData();
    setState(() {
      userData = tempUser;
    });
  }

  Future<void> emailSend() async {
    showDialog(
      context: context,
      builder: (_) => const CustomLoadingDialog(
        loadingText: 'Sending email',
      ),
    );
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
                    currentDateToday,
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
                    style: pw.TextStyle(
                      font: interFont600,
                      fontSize: 8,
                    ),
                  ),
                  pw.SizedBox(width: 20),
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
              pw.SizedBox(height: 5),
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
                    "$name",
                    style: pw.TextStyle(
                      font: interFont500,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
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
                    "$carCompanyValue $carMakeValue $carTypeValue $carVariantValue",
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
                border: pw.TableBorder.all(width: 0.5),
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
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${od.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      // pw.Text(OD.toString().formatWithCommas(),
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 8,
                      //     )),
                    ],
                  ),
                  // pw.TableRow(children: [
                  //   pw.Text(theftTitle,
                  //       style: pw.TextStyle(
                  //         font: ttf,
                  //         fontSize: 8,
                  //       )),
                  //   pw.Text("1,150,000.00",
                  //       style: pw.TextStyle(
                  //         font: ttf,
                  //         fontSize: 8,
                  //       )),
                  //   pw.Text(Theft.toString().formatWithCommas(),
                  //       style: pw.TextStyle(
                  //         font: ttf,
                  //         fontSize: 8,
                  //       )),
                  //   pw.Text(Theft.toString().formatWithCommas(),
                  //       style: pw.TextStyle(
                  //         font: ttf,
                  //         fontSize: 8,
                  //       )),
                  // ]),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          actsofNature,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${aon.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      // pw.Text("",
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 8,
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
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${vtplbi.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      // pw.Text("",
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 8,
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
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${vtplpd.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      // pw.Text("",
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 8,
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
                            fontSize: 8,
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
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      // pw.Text("INCLUDED",
                      //     style: pw.TextStyle(
                      //       font: ttf,
                      //       fontSize: 8,
                      //     )),
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
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${basicPremium.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${docStamp.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${vatValue.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
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
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${localTaxValue.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 8,
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
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          '₱${totalpremium.toString().formatWithCommas()}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: interFont600,
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20.0),

              // pw.SizedBox(height: 8.0),
              // pw.Row(children: [
              //   pw.Text("Mortgagee",
              //       style: pw.TextStyle(font: ttf, fontSize: 8)),
              //   pw.SizedBox(width: 20.0),
              //   pw.Text("-", style: pw.TextStyle(font: ttf, fontSize: 8)),
              //   pw.SizedBox(width: 53.0),
              //   pw.Text("", style: pw.TextStyle(font: ttf, fontSize: 8)),
              // ]),
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
                    " $deductible",
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
              pw.Row(
                children: [
                  pw.Text(
                    "Manager - $branchValue",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              // pw.Row(
              //   children: [
              //     pw.Text(
              //       "Email: ${userData?.email ?? ''}",
              //       style: pw.TextStyle(
              //         font: ttf,
              //         fontSize: 8,
              //       ),
              //     ),
              //   ],
              // ),
              // pw.Row(
              //   children: [
              //     pw.Text(
              //       "Mobile: ${userData?.phoneNo ?? ''}",
              //       style: pw.TextStyle(
              //         font: ttf,
              //         fontSize: 8,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/MotorQuotation.pdf");
    await file.writeAsBytes(await pdf.save());

    // setState(() {
    //   _pdfPath = file.path;
    // });
    // String username = 'jgalvanfpg@gmail.com';
    // String password = 'D3f@ult2027';
    // final smtpServer = gmail(username, password);

    final smtpServer = SmtpServer('10.52.254.55',
        port: 25, allowInsecure: true, ignoreBadCertificate: true);

    final message = Message()
      ..from =
          const Address("ezhub-donotreply@fpgins.com", "EZHub by FPG - UAT")
      ..recipients.add('$email')
      ..subject = 'Motor Insurance Quotation Slip $currentDate'
      ..html = """
                  <p>Greetings, <b>$name,</b><br></p>
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
      Navigator.pop(context);
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        const CustomSnackBar.success(
          message: "Success! Email has been sent.",
        ),
      );
    } on MailerException catch (e) {
      log('Message not sent. $e');
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        const CustomSnackBar.error(
          message: "Failed to send email.",
        ),
      );
      for (var p in e.problems) {
        log('Problem: ${p.code}: ${p.msg}');
      }
    }
    var connection = PersistentConnection(smtpServer);
    await connection.close();
  }

  getAgentQuotes() async {
    setState(() {
      isLoading = true;
    });

    var result = await Api().getQuotation();
    setState(() {
      isLoading = false;
      agentQuotes = [];
      agentQuotes = result['data'] ?? [];
      filteredAgentQuotes = agentQuotes;
      _searchController.addListener(() {
        filterAgentQuotes(_searchController.text);
      });
    });
  }

  Future<QuotationDetails> getQuotationDetails(id) async {
    showDialog(
      context: context,
      builder: (_) => const CustomLoadingDialog(
        loadingText: 'Loading...',
      ),
    );
    var result = await Api().getQuotationDetails(id);
    final data = QuotationDetails.fromJson(result['data']);
    refNo = data.refNumber;
    intermediary = data.intermediary;
    created_date = data.createdDate;
    name = data.name;
    email = data.email;
    branchValue = data.branch;
    toc = data.toc;
    rate = data.rate;
    year = data.year;
    carCompanyValue = data.carCompany;
    carMakeValue = data.carMake;
    carTypeValue = data.carType;
    carVariantValue = data.carVariant;
    fmv = data.fmv;
    deductible = data.deductible;
    totalpremium = data.totalPremium;
    basicPremium = data.basicPremium;
    docStamp = data.docStamp;
    vatValue = data.vat;
    localTaxValue = data.localTax;
    od = data.od;
    aon = data.aon;
    periodOfInsurance = data.periodOfInsurance;
    quotationExpiry = data.quotationExpiry;
    status = data.status;
    vtplbi = data.vtplBi;
    vtplpd = data.vtplPd;

    periodOfInsuranceWord = "TBA";
    quotationExpiryWord =
        DateFormat('y MMMM d').format(DateTime.parse(quotationExpiry));
    setState(() {});
    Navigator.pop(context);
    return data;
  }

  deleteQuote(refNo) async {
    // var mysql = await mySQL().connect();
    // var result = await mysql
    //     .query("""DELETE FROM agent_quotes WHERE ref_number = '$refNo'""");
    getAgentQuotes();
  }

  void filterAgentQuotes(String query) {
    final filteredList = agentQuotes.where((quote) {
      final refNumber = quote['ref_number'].toLowerCase();
      final name = quote['name'].toLowerCase();
      final searchLower = query.toLowerCase();

      return refNumber.contains(searchLower) || name.contains(searchLower);
    }).toList();

    setState(() {
      filteredAgentQuotes = filteredList;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Issued':
        return Colors.green;

      case 'Not Issued':
        return Colors.yellow[900]!;

      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 246),
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Quotation List",
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: InputTextField(
              controller: _searchController,
              hintText: 'Search Ref No., Name..',
              onChanged: filterAgentQuotes,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.tablet) {
                  return isLoading
                      ? _buildLoadingWidget()
                      : filteredAgentQuotes.isEmpty
                          ? _emptyRecordWidget()
                          : GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(20),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 130,
                              ),
                              itemCount: filteredAgentQuotes.length,
                              itemBuilder: (context, i) {
                                final item = filteredAgentQuotes[i];
                                // var dateQuote = item['created_date'];
                                //dateQuote = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                                var name = item['name'];
                                var id = item['id'];
                                var refNo = item['ref_number'];
                                status = item['status'];

                                return _buildQuotationCard(
                                  index: i,
                                  id: id,
                                  name: name,
                                  refNo: refNo,
                                  status: status,
                                );
                              },
                            );
                }
                return isLoading
                    ? _buildLoadingWidget()
                    : filteredAgentQuotes.isEmpty
                        ? _emptyRecordWidget()
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            itemCount: filteredAgentQuotes.length,
                            separatorBuilder: (context, i) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final item = filteredAgentQuotes[i];
                              // var dateQuote = item['created_date'];
                              //dateQuote = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                              var name = item['name'];
                              var id = item['id'];
                              var refNo = item['ref_number'];
                              status = item['status'];

                              return _buildQuotationCard(
                                index: i,
                                id: id,
                                name: name,
                                refNo: refNo,
                                status: status,
                              );
                            },
                          );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationCard({
    required int index,
    required int id,
    required String name,
    required String refNo,
    required String status,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => PreviewQuote(
                  id: id,
                  onEmail: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.warning,
                      title: 'Email Quotation',
                      desc: 'Do you want to send email to $name?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        await getQuotationDetails(id).then((_) async {
                          await emailSend();
                          // pushScreen(
                          //   context,
                          //   screen: PdfPreview(
                          //       pdfPath: _pdfPath!),
                          // );
                        });
                      },
                    ).show();
                  },
                  onIssuedPolicy: () async {
                    final data = await getQuotationDetails(id);
                    Get.to(
                      () => Productmotor(
                        from: 'quotation',
                        quotation: data,
                      ),
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 2,
                    color: Colors.grey[200]!,
                  )
                ],
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            color: _getStatusColor(status),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$refNo ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return ListView.separated(
      itemCount: 10,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: const FadeShimmer(
          height: 120,
          width: double.infinity,
          radius: 4,
          highlightColor: ColorPalette.greyE3,
          baseColor: ColorPalette.greyLight,
        ),
      ),
    );
  }

  Widget _emptyRecordWidget() {
    return const Center(
      child: Text(
        'No records available.',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

//
class PdfPreview extends StatefulWidget {
  const PdfPreview({super.key, required this.pdfPath});

  final String pdfPath;
  @override
  State<PdfPreview> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<PdfPreview> {
  int? pdfIndex;
  String? _pdfPath;
  @override
  void initState() {
    super.initState();
    _pdfPath = widget.pdfPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.greyLight,
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "PDF View",
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
      body: _pdfPath != null
          ? Column(
              children: [
                Expanded(
                  child: PDFView(
                    filePath: _pdfPath,
                    autoSpacing: false,
                    fitEachPage: false,
                    onPageChanged: (page, _) {
                      setState(() {
                        pdfIndex = page!;
                      });
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('BLANK'),
            ),
    );
  }
}

final data = {
  "id": 9,
  "od_rate": 0.0125,
  "aon_rate": 0.005,
  "vtpl_bi": 510,
  "vtpl_pd": 1515,
  "status": "Not Issued",
  "period_of_insurance": 2025 - 10 - 23,
  "quotation_expiry": 2024 - 11 - 22,
  "ref_number": "EZ-MC-FQ-2024-10-000001",
  "intermediary": "M02AI00001",
  "ref_counter": 1,
  "created_date": "2024-10-23 09:24:35",
  "name": "Joshua Test",
  "email": "rparayno@fpgins.com",
  "branch": "MAKATI",
  "toc": "PRIVATE CARS",
  "rate": 0.0175,
  "year": 2021,
  "car_company": "Honda",
  "car_make": "Brio",
  "car_type": "Hatchback",
  "car_variant": "RS 1200cc A&#47;T Gas FWD Hatchback 5-Seater",
  "fmv": 632900,
  "deductible": null,
  "total_premium": 16337.0415,
  "basic_premium": 13100.75,
  "doc_stamp": 1638,
  "vat": 1572.09,
  "local_tax": 26.2015,
  "od": 7911.25,
  "aon": 3164.5,
  "created_at": "2024-10-23T01:26:01.000000Z",
  "updated_at": "2024-10-23T01:26:01.000000Z",
};

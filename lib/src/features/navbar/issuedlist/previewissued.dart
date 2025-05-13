// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PreviewIssued extends StatefulWidget {
  const PreviewIssued({super.key, required this.id});
  final String id;

  @override
  State<PreviewIssued> createState() => _PreviewIssuedState();
}

class _PreviewIssuedState extends State<PreviewIssued> {
  List<dynamic> issuedDetails = [];
  String fullName = '',
      policyNumber = '',
      plateNo = '',
      email = '',
      inceptionDate = '',
      expiryDate = '';
  String? filePath;

  @override
  void initState() {
    super.initState();
    getIssuedDetails();
  }

  getIssuedDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.52.2.117:1003/api/motor-policies/${widget.id}'),
        headers: {
          'X-Authorization':
              'Uskfm1KDr3KtCStV0W28oOoee8pTVkaCszauYNyyknDL9r5LLZv24Stt0GVWekeV'
        },
      );
      var result = (jsonDecode(response.body)['data']);

      email = result['insured']['email'];
      fullName =
          '${result['insured']['first_name'] ?? ''} ${result['insured']['last_name'] ?? ''}';
      policyNumber = result['policy_no'];
      inceptionDate = result['inception_date'];
      expiryDate = result['expiry_date'];
      final Uint8List pdfBytes =
          base64.decode(result['files']['policy_schedule']);
      var dir = (await getTemporaryDirectory()).path;
      final String path = '$dir/PolicySchedule.pdf';
      final File file = File(path);
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        setState(() {
          filePath = path;
        });
      }

      setState(() {});
    } catch (e) {
      log('$e');
    }
  }

  Future<void> emailSend() async {
    showDialog(
      context: context,
      builder: (ctx) => const CustomLoadingDialog(
        loadingText: 'Sending email',
      ),
    );

    final smtpServer = SmtpServer('10.52.254.55',
        port: 25, allowInsecure: true, ignoreBadCertificate: true);
    final message = Message()
      ..from =
          const Address("ezhub-donotreply@fpgins.com", "EZHub by FPG - UAT")
      ..recipients.add(email)
      ..subject =
          'Motor CTPL Insurance Payment and Preview Email ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}'
      ..html = """
                  <p>Dear, <b>$fullName</b></p>

                  <p>We are pleased to confirm your purchase of <b style="color:#eb6434">Motor CTPL</b> Policy with Policy Number <b style="color:#eb6434">$policyNumber</b>. This Policy is valid from <b style="color:#eb6434">$inceptionDate</b>, to <b style="color:#eb6434">$expiryDate</b>.</p>

                  <p>Attached is the Policy Schedule.</p>

                  <p>Should you require assistance, you may reach out to our Customer Service by sending an email to phcustomercare@fpgins.com or call our hotline at (02) 8859-1200, which is open from 8:00 AM to 5:00 PM, Monday through Friday.</p>

                  <p>Sincerely,</p>
                  <p>FPG INSURANCE</p>

                  <p style="font-style:italic; font-size:12px; color:#eb6434;">Important Reminders: Premium must be paid in full before we can proceed with the renewal of your policy. Please use the Reference Number indicated in the renewal proposal as Payment Reference. In compliance with the Anti-Money Laundering Act (AMLA), kindly fill out the KNOW YOUR CUSTOMER (KYC) portion is completely filled out with relevant accurate information.</p>
                  <p style="font-style:italic; font-size:12px; color:#eb6434;">DISCLAIMER: This is an automatically generated e-mail notification. Please do not reply to this e-mail, as there will be no response.
                  This null message is confidential; its contents do not constitute a commitment by FPG Insurance Co., Inc.
                  except where provided in a written agreement between you and the company.
                  Any unauthorized disclosure, use or dissemination, either completely or in part, is prohibited.
                  If you are not the intended recipient of this message, please notify the sender immediately. </p>
               """
      ..attachments = [FileAttachment(File(filePath!))];

    try {
      final sendReport = await send(message, smtpServer);
      log('Message sent: $sendReport');
      Navigator.pop(context);
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        const CustomSnackBar.success(
          message: "Policy has been sent to the insured email",
        ),
      );
    } on MailerException catch (e) {
      log('Message not sent. ${e.message} ${e.problems.map((e) => e.msg).toList()}');
    }
    var connection = PersistentConnection(smtpServer);
    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Issued Preview",
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          filePath == null
              ? const Center(
                  child: Column(
                    children: [
                      SpinKitChasingDots(
                        color: ColorPalette.primaryColor,
                      ),
                      SizedBox(height: 10),
                      Text('Generating Policy...')
                    ],
                  ),
                )
              : Expanded(
                  child: PDFView(
                    filePath: filePath,
                    autoSpacing: true,
                    enableSwipe: true,
                    pageSnap: true,
                    swipeHorizontal: true,
                  ),
                ),
          if (filePath != null) ...[
            ElevatedButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  dialogType: DialogType.warning,
                  title: 'Send Email?',
                  btnCancelText: 'No',
                  btnCancelOnPress: () {},
                  btnOkText: 'Yes',
                  btnOkOnPress: () async {
                    await emailSend();
                  },
                ).show();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xfffe5000),
              ),
              child: const Text(
                sendEmail,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'OpenSans',
                  color: Colors.white,
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 20),
          ]
        ],
      ),
    );
  }
}

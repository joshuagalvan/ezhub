// import 'dart:io';
// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
// import 'package:intl/intl.dart';

// class emailSend {
//   emailSender(context, String email, String name) async {
//     String currentDate =
//         DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
//     final controller = Get.put(ProfileController());
//     var userData = await controller.getUserData();

//     final smtpServer = SmtpServer('10.52.254.55',
//         port: 25, allowInsecure: true, ignoreBadCertificate: true);

//     final message = Message()
//       ..from = Address("ezhub-donotreply@fpgins.com", "EZHub by FPG - UAT")
//       ..recipients.add('${email.text}')
//       ..subject = 'Motor Insurance Quotation Slip ${currentDate}'
//       ..html = """
//                   <p>Greetings, <b>${name.text},</b><br></p>
//                   <p>We appreciate you picking FPG Insurance! This is your vehicle's motor insurance quote.<br><br>
//                   ${userData.fullName}, your insurance agent, will walk you through the remaining steps of the insurance process.<br><br>
//                   We appreciate your business and are eager to insure you!<br><br></p>
//                   <p><a href="www.google.com">Agree with the quotation</a> or <a href="www.google.com">For Discussion</a></p>
//                   <p>Attached is a PDF File of your Quotation.<br><br><br> </p>
//                   <p style="color:#eb6434">FPG INSURANCE<br><br><br> </p>
//                   <p style="font-style:italic; font-size:12px;">DISCLAIMER: This is an automatically generated e-mail notification. Please do not reply to this e-mail, as there will be no response.
//                   This message is confidential; its contents do not constitute a commitment by FPG Insurance Co., Inc.
//                   except where provided in a written agreement between you and the company.
//                   Any unauthorized disclosure, use or dissemination, either completely or in part, is prohibited.
//                   If you are not the intended recipient of this message, please notify the sender immediately. </p>
//                """
//       ..attachments = [
//         FileAttachment(File("${output.path}/MotorQuotation.pdf"))
//       ];

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ' + sendReport.toString());
//       showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                 title: Text('Success'),
//                 content: Text('Email has been Sent.'),
//                 actions: [
//                   TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text('OK'))
//                 ],
//               ));
//     } on MailerException catch (e) {
//       print('Message not sent.');
//       for (var p in e.problems) {
//         print('Problem: ${p.code}: ${p.msg}');
//       }
//     }
//     var connection = PersistentConnection(smtpServer);
//     await connection.close();
//   }
// }

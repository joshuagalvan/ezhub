// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/signup_controller.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

final TextEditingController controller = TextEditingController();

class ForgotPasswordMailScreen extends StatefulWidget {
  const ForgotPasswordMailScreen({super.key});

  @override
  State<ForgotPasswordMailScreen> createState() =>
      ForgotPasswordMailScreenState();
}

class ForgotPasswordMailScreenState extends State<ForgotPasswordMailScreen> {
  final controller = Get.put(SignUpController());

  @override
  void initState() {
    super.initState();
    //emailValid();
  }

  // String ip = '10.52.2.236',
  //     port = '1433',
  //     username = 'FPGPH',
  //     password = 'ifrs17',
  //     databaseName = 'SEA_FPG_PHIL';

  final _sqlConnection = MssqlConnection.getInstance();

  void emailValid() async {
    showDialog(
      context: context,
      builder: (_) => const CustomLoadingDialog(),
    );
    final controller = Get.put(SignUpController());

    // if (ip.isEmpty ||
    //     port.isEmpty ||
    //     databaseName.isEmpty ||
    //     username.isEmpty ||
    //     password.isEmpty) {
    //   print("Please enter all fields");

    //   return;
    // }
    // await _sqlConnection
    //     .connect(
    //         ip: ip,
    //         port: port,
    //         databaseName: databaseName,
    //         username: username,
    //         password: password)
    //     .then((value) {
    //   if (value) {
    //     print("Connected");
    //   } else {
    //     print("No Connection");
    //   }
    // });

    String query =
        "SELECT * FROM Profile WHERE Email = '${controller.email.text}'";
    String result = await _sqlConnection.getData(query);

    Navigator.pop(context);
    if (jsonDecode(result).length > 0) {
      await SignUpController.instance.sendResetEmail(
        controller.email.text.trim(),
      );

      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        const CustomSnackBar.success(
          message: "Success! Reset Password Link has been sent to your Email.",
        ),
      );
      // Get.snackbar(
      //     'Success', 'Reset Password Link has been sent to your Email.');
    } else if (jsonDecode(result).length <= 0) {
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 1),
        const CustomSnackBar.error(
          message: "Failed to send Reset Password Link.",
        ),
      );
      // Get.snackbar('Error', 'Email Address is not Registered.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          surfaceTintColor: Colors.white,
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
            padding: const EdgeInsets.all(defaultSize),
            child: Column(children: [
              // const SizedBox(
              //   height: 20.0,
              // ),
              // //           const Image(
              // //            image: AssetImage(fpgIcon),
              // //            width: 140.0,
              // //            height: 140.0,
              // //          ),
              // const SizedBox(
              //   height: 30.0,
              // ),

              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                resetPassMailSub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: controller.email,
                        decoration: InputDecoration(
                          //  prefixIcon: Icon(Icons.email_outlined),
                          labelText: (eMail),
                          hintText: (eMail),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
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
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              emailValid();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xfffe5000),
                          ),
                          child: Text(
                            next.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ])));
  }
}

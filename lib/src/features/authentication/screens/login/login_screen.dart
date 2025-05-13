// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/constants/image_strings.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/controllers/signup_controller.dart';
import 'package:simone/src/features/authentication/screens/forgotpassword/forget_password_mail/forget_password_mail.dart';
import 'package:simone/src/features/authentication/screens/otp/otp.dart';
import 'package:simone/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/sizes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

final controller = Get.put(SignUpController());
bool _isObscured = true;
final _sqlConnection = MssqlConnection.getInstance();

class LoginScreenState extends State<LoginScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> checkDetails() async {
    try {
      String query =
          "SELECT * FROM Profile WHERE Email = '${controller.email.text}'";
      String result = await _sqlConnection.getData(query);
      EmailOTP myauth = EmailOTP();

      myauth.setConfig(
        appEmail: "ezhub-donotreply@fpgins.com",
        appName: "EZ HUB",
        userEmail: controller.email.text.trim(),
        otpLength: 6,
        otpType: OTPType.digitsOnly,
      );

      // myauth.setSMTP(
      //   host: "10.52.254.55",
      //   port: 25,
      //   auth: false,
      // );
      // myauth.setTemplate(
      //   render: '''
      // <div style="background-color: #f4f4f4; padding: 20px; font-family: Arial, sans-serif;">
      //   <div style="background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
      //     <h1 style="color: #333;">{{appName}}</h1>
      //     <p style="color: #333;">Your OTP is <strong>{{otp}}</strong></p>
      //     <p style="color: #333;">This OTP is valid for 5 minutes.</p>
      //     <p style="color: #333;">Thank you for using our service.</p>
      //   </div>
      // </div>
      // ''',
      // );

      if (jsonDecode(result).length > 0) {
        if (await myauth.sendOTP() == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreens(
                        myauth: myauth,
                        email: controller.email.text.trim(),
                        password: controller.password.text.trim(),
                      )));
        }
      } else if (jsonDecode(result).length <= 0) {
        Get.snackbar('Error', 'Email Address is not Registered');
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  void initState() {
    super.initState();
    Get.put(SignUpController());
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // if (kDebugMode) {
    //   controller.email.text = "jgalvan@fpgins.com";
    //   controller.password.text = "Test@1234";
    // }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage(fpgIcon),
                  width: 900.0,
                  height: 250.0,
                ),
                //                Text(
                //                 "Login".toUpperCase(),
                //                style: const TextStyle(
                //                  fontSize: 20.0,
                //                   fontFamily: 'OpenSans',
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //                ),
                Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          strutStyle: StrutStyle(
                            height: 2,
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Please enter your email and password to access your account.',
                          strutStyle: StrutStyle(
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: controller.email,
                          decoration: const InputDecoration(
                            //           prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: (eMail),
                            hintText: (eMail),
                            border: OutlineInputBorder(),
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
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controller.password,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            //          prefixIcon: Icon(Icons.fingerprint),
                            labelText: (password),
                            hintText: (password),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: _isObscured
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              color: Colors.grey,
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                          ),
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length < 8) {
                              return "Please Enter a Valid Password";
                            }
                            // if (!RegExp(r'.*[0-9].*').hasMatch(text)) {
                            //   return "Please Enter a Valid Password";
                            // }
                            // if (!RegExp(r'.*[a-z].*').hasMatch(text)) {
                            //   return "Please Enter a Valid Password";
                            // }
                            // if (!RegExp(r'.*[A-Z].*').hasMatch(text)) {
                            //   return "Please Enter a Valid Password";
                            // }
                            // if (!RegExp(r'.*[\W].*').hasMatch(text)) {
                            //   return "Please Enter a Valid Password";
                            // }
                            return null;
                          },
                        ),
                        const SizedBox(height: formHeight),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Get.to(() => const ForgotPasswordMailScreen()),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xfffe5000),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       // myauth.setSMTP();
                        //       // myauth.setTemplate();

                        //       if (formKey.currentState!.validate()) {
                        //         checkDetails();
                        //       }
                        //     },
                        //     style: OutlinedButton.styleFrom(
                        //       backgroundColor: Color(0xfffe5000),
                        //     ),
                        //     child: Text(
                        //       login.toUpperCase(),
                        //       style: const TextStyle(
                        //         color: Colors.white,
                        //         fontFamily: 'OpenSans',
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 2.0, height: 10.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => const CustomLoadingDialog(),
                                );
                                await SignUpController.instance
                                    .loginUser(
                                  controller.email.text.trim(),
                                  controller.password.text.trim(),
                                )
                                    .then((result) async {
                                  if (result == false) {
                                    Navigator.pop(context);
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      displayDuration:
                                          const Duration(seconds: 1),
                                      const CustomSnackBar.error(
                                        message:
                                            "Failed to Login! Invalid Email or Password.",
                                      ),
                                    );
                                  } else {
                                    final controller =
                                        Get.put(ProfileController());
                                    await controller.getUserData();
                                    await controller.getBranch();
                                  }
                                });
                              }
                              // else {
                              //   Get.snackbar("Error",
                              //       "Email Address is not yet Verified");
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text(
                              login.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 80.0, height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(noAccount),
                            TextButton(
                              onPressed: () =>
                                  Get.to(() => const SignUpScreen()),
                              child: const Text(
                                accountRegistration,
                                style: TextStyle(
                                  color: Color(0xfffe5000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

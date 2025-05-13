import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/signup_controller.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/features/navbar/companyprofile/web_viewer.dart';
import 'package:simone/src/features/navbar/companyinformation/dataprivacy/dataprivacy.dart';
import 'package:simone/src/features/authentication/screens/login/login_screen.dart';

final TextEditingController controller = TextEditingController();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  // String ip = '10.52.2.236',
  //     port = '1433',
  //     username = 'FPGPH',
  //     password = 'ifrs17',
  //     databaseName = 'SEA_FPG_PHIL';

  final _sqlConnection = MssqlConnection.getInstance();

  late FirebaseAuth auth;
  bool? isChecked = false;
  bool? isCheckedData = false;

  @override
  Widget build(BuildContext context) {
    // User? user = auth.currentUser;
    // String? uid = user?.uid;

    final controller = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();

    connect() async {
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
          "SELECT * FROM Profile WHERE ID = '${controller.agentCode.text}' AND Email = '${controller.email.text}'";
      String result = await _sqlConnection.getData(query);
      if (jsonDecode(result).length > 0) {
        final user = UserModel(
          fullName: controller.fullname.text.trim(),
          agentCode: controller.agentCode.text.trim(),
          phoneNo: controller.phoneNo.text.trim(),
          email: controller.email.text.trim(),
          password: controller.password.text.trim(),
        );

        SignUpController.instance.createUser(user);
        SignUpController.instance.registerUser(
            controller.email.text.trim(), controller.password.text.trim());
      } else {
        Get.snackbar('Error', 'Agent Code or Email is not Registered in Care');
      }
    }

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
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          accountRegistration,
                          strutStyle: StrutStyle(
                            height: 2,
                          ),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const Text(
                          'Excited to have you on board! Fill in your details to create a new account.',
                          strutStyle: StrutStyle(
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        InputTextField(
                          controller: controller.agentCode,
                          label: agentCode,
                          validators: (text) {
                            if (text == null || text.isEmpty) {
                              return "Please Enter Your Agent Code";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        InputTextField(
                          controller: controller.fullname,
                          label: fullname,
                          textCapitalization: TextCapitalization.words,
                          validators: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                !RegExp(r'^[a-z A-Z.]+$').hasMatch(text)) {
                              return "Please Enter Correct Full Name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        InputTextField(
                          controller: controller.email,
                          label: eMail,
                          keyboardType: TextInputType.emailAddress,
                          validators: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                    .hasMatch(text)) {
                              return "Please Enter a Valid Email Address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        InputTextField(
                          controller: controller.phoneNo,
                          label: phone,
                          validators: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                !RegExp(r'^([(]{0,1}(09|\+639)+[)]{0,1})[0-9]{9}$')
                                    .hasMatch(text)) {
                              return "Please Enter a Valid Phone Number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        InputTextField(
                          controller: controller.password,
                          obscureText: _isObscured,
                          label: "Password",
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
                          validators: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length < 8) {
                              return "Please Enter a Valid Password";
                            }
                            if (!RegExp(r'.*[0-9].*').hasMatch(text)) {
                              return "Please Enter a Valid Password";
                            }
                            if (!RegExp(r'.*[a-z].*').hasMatch(text)) {
                              return "Please Enter a Valid Password";
                            }
                            if (!RegExp(r'.*[A-Z].*').hasMatch(text)) {
                              return "Please Enter a Valid Password";
                            }
                            if (!RegExp(r'.*[\W].*').hasMatch(text)) {
                              return "Please Enter a Valid Password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: FlutterPwValidator(
                            controller: controller.password,
                            minLength: 8,
                            uppercaseCharCount: 1,
                            lowercaseCharCount: 1,
                            numericCharCount: 1,
                            specialCharCount: 1,
                            width: 400,
                            height: 165,
                            onSuccess: () {},
                            onFail: () {},
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'By submitting my information, I agree to the ',
                          ),
                          TextSpan(
                            text: 'Terms and Conditions.',
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Color(0xfffe5000),
                              //  decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => const WebViewer(
                                      title: 'Terms & Conditions',
                                      url:
                                          'https://ph.fpgins.com/about/terms-conditions/',
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    value: isChecked,
                    activeColor: const Color(0xfffe5000),
                    onChanged: (bool? newBool) {
                      setState(() {
                        isChecked = newBool;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text:
                                    'By signing up, you agree to our terms and acknowledge our commitment to protecting your personal information as outlined in our '),
                            TextSpan(
                              text: 'Data Privacy.',
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffe5000),
                                //  decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => Get.to(() => const Dataprivacy()),
                            ),
                          ],
                        ),
                      ),
                      // title: const Text(
                      //   "Data Privacy.",
                      //   strutStyle: StrutStyle(
                      //     height: 0.3,
                      //   ),
                      // ),
                      value: isCheckedData,
                      activeColor: const Color(0xfffe5000),
                      onChanged: (bool? newBool) {
                        setState(() {
                          isCheckedData = newBool;
                        });
                      }),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 270,
                    child: ElevatedButton(
                      //onPressed: () => Get.to(() => const LoginScreen()),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (isChecked == true && isCheckedData == true) {
                            connect();
                          } else if (isChecked == false &&
                              isCheckedData == false) {
                            Get.snackbar('Error',
                                'Please Accept the Terms and Conditions and Data Privacy');
                          } else if (isChecked == false) {
                            Get.snackbar('Error',
                                'Please Accept the Terms and Conditions');
                          } else if (isCheckedData == false) {
                            Get.snackbar('Error', 'Please Accept Data Privacy');
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xfffe5000),
                      ),
                      child: Text(
                        createAccount.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        hasAccount,
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => const LoginScreen()),
                        child: const Text(
                          login,
                          style: TextStyle(
                            color: Color(0xfffe5000),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

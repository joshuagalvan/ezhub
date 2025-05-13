import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/signup_controller.dart';

class OTPScreens extends StatefulWidget {
  const OTPScreens(
      {Key? key,
      required this.myauth,
      required this.email,
      required this.password})
      : super(key: key);

  final EmailOTP myauth;
  final String email, password;

  @override
  State<OTPScreens> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreens> {
  TextEditingController otpcontroller = TextEditingController();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios), // Different icon for back button
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(children: [
              // const SizedBox(height: 50.0),
              const Text(
                otpVerify,
                strutStyle: StrutStyle(
                  height: 2.0,
                ),
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
              const Text(
                "Please enter the OTP code we sent to your Email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Form(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: otpcontroller,
                        decoration: InputDecoration(
                          //    prefixIcon: Icon(Icons.numbers),
                          labelText: ("OTP"),
                          hintText: ("OTP"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await widget.myauth.verifyOTP(
                                    otp: otpcontroller.text.trim()) ==
                                true) {
                              Get.snackbar('Success', 'OTP is Verified.');
                              SignUpController.instance
                                  .loginUser(widget.email, widget.password);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xfffe5000),
                          ),
                          child: Text(
                            "Submit".toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              )
            ])));
  }
}

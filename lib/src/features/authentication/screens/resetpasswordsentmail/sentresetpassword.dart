import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/screens/login/login_screen.dart';

class SentResetPasswordScreen extends StatelessWidget {
  const SentResetPasswordScreen({super.key});

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
        child: Column(
          children: [
            const Text(
              sentResetEmail,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            const SizedBox(height: 25.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => Get.to(() => const LoginScreen()),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xfffe5000),
                  ),
                  child: Text(
                    okay.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

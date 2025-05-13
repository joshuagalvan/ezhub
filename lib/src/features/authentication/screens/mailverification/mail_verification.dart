import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/mailverificationcontroller.dart';
import 'package:simone/src/features/authentication/screens/login/login_screen.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.mark_email_read_rounded,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              emailVerify,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 30.0,
              ),
            ),
            const Text(
              "Email verification link has been sent!",
              strutStyle: StrutStyle(
                height: 3.0,
              ),
              style: TextStyle(
                fontFamily: 'OpenSans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () =>
                    controller.manuallyCheckEmailVerificationStatus(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xfffe5000),
                  foregroundColor: const Color(0xfffe5000),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () => Get.to(() => const LoginScreen()),
              child: const Text("Back to Login"),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      ),
    );
  }
}

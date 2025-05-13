import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/navbar/renewals/expirylist/expirylist.dart';
import 'package:simone/src/features/navbar/renewals/renewallist/renewallist.dart';

class Renewals extends StatelessWidget {
  const Renewals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  // onPressed: () {},
                  onPressed: () => Get.to(() => const Renewallist()),
                  child: Text(
                    renewallist.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xfffe5000),
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  // onPressed: () {},
                  onPressed: () => Get.to(() => const ExpiryList()),
                  child: Text(
                    expirylist.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xfffe5000),
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

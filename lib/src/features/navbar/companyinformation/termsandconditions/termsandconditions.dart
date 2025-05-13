import 'package:flutter/material.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            toolbarHeight: 120.0,
            surfaceTintColor: Colors.white,
            // toolbarOpacity: 30,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(),
            // centerTitle: true,
            title: const Text(
              termsandcon,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 30.0,
                // color: Color(0xfffe5000),
                fontWeight: FontWeight.bold,
              ),
              strutStyle: StrutStyle(
                height: 10,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                  Icons.arrow_back_ios), // Different icon for back button
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: const Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                // bottomNavigationBar: Container(
                //   height: 55.0,
                //   color: Colors.grey,
                //   child: InkWell(
                //     onTap: () => Get.to(() => const CompanyInformation()),
                //     child: const Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(Icons.arrow_back_outlined),
                //               Text(myfpg),
                //             ])
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

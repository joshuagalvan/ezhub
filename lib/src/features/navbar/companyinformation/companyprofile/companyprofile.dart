import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simone/src/constants/image_strings.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/navbar/companyprofile/web_viewer.dart';

class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          companyprof,
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
      body: Stack(
        children: [
          Image.asset(
            comProf,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.66,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(100, 30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "We've built an enviable reputation for developing customer insights that support the creation of relevant commercial and individual insurance products and solutions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Color(0xfffe5000),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        pushScreen(
                          context,
                          screen: const WebViewer(
                            title: 'Corporate Governance',
                            url:
                                'https://ph.fpgins.com/about/corporate-governance/',
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(0, 1),
                              color: Colors.grey[300]!,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/corporate_governance.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const Text(
                                    "CORPORATE GOVERNANCE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 20,
                                      color: Color(0xfffe5000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 3.0,
                                    ),
                                  ),
                                  const Text(
                                    "The FPG Insurance governance structure establishes checks and balances, and is designed to provide added assurance to our customers and shareholders alike.",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16.0,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.5,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      pushScreen(
                                        context,
                                        screen: const WebViewer(
                                          title: 'Corporate Governance',
                                          url:
                                              'https://ph.fpgins.com/about/corporate-governance/',
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xfffe5000),
                                    ),
                                    child: const Text(
                                      'LEARN MORE',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pushScreen(
                          context,
                          screen: const WebViewer(
                            title: 'Privacy Policy',
                            url: 'https://ph.fpgins.com/about/privacy-policy/',
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 2,
                              color: Colors.grey[200]!,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/privacy_policy.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const Text(
                                    "PRIVACY POLICY",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 20,
                                      color: Color(0xfffe5000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 3.0,
                                    ),
                                  ),
                                  const Text(
                                    'FPG Insurance respects your privacy. Learn how we collect and use your personal data.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16.0,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.5,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      pushScreen(
                                        context,
                                        screen: const WebViewer(
                                          title: 'Privacy Policy',
                                          url:
                                              'https://ph.fpgins.com/about/privacy-policy/',
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xfffe5000),
                                    ),
                                    child: const Text(
                                      'LEARN MORE',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 2,
                              color: Colors.grey[200]!,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/directors_management_team.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const Text(
                                    "DIRECTORS & MANAGEMENT TEAM",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 20,
                                      color: Color(0xfffe5000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 3.0,
                                    ),
                                  ),
                                  const Text(
                                    'FPG Insurance has an effective governance structure comprised of our Board of Directors, Management Team, and Internal Units.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16.0,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.5,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      pushScreen(
                                        context,
                                        screen: const WebViewer(
                                          title: 'Directors & Management Team',
                                          url:
                                              'https://ph.fpgins.com/about/directors-management/',
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xfffe5000),
                                    ),
                                    child: const Text(
                                      'LEARN MORE',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}

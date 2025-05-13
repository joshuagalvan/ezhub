import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/navbar/companyinformation/branches/branches.dart';
import 'package:simone/src/features/navbar/companyinformation/companyprofile/companyprofile.dart';
import 'package:simone/src/features/navbar/companyinformation/companyprofile/web_viewer.dart';
import 'package:simone/src/features/navbar/clientlist/clientlist.dart';
import 'package:simone/src/features/navbar/commissions/commisions.dart';
import 'package:simone/src/features/navbar/issuedlist/issuedlist.dart';
import 'package:simone/src/features/navbar/policylist/policylist.dart';
import 'package:simone/src/features/navbar/quotation/createquote.dart';
import 'package:simone/src/features/navbar/quotation/quotationlist.dart';
import 'package:simone/src/features/navbar/renewals/expirylist/expirylist.dart';
import 'package:simone/src/features/navbar/renewals/renewallist/renewallist.dart';
import 'package:simone/src/features/undermaintenance/undermaintenance.dart';
import 'package:simone/src/utils/colorpalette.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  final controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    db = FirebaseFirestore.instance;
  }

  late FirebaseAuth auth;
  late FirebaseFirestore db;

  @override
  Widget build(BuildContext context) {
    // User? user = auth.currentUser!;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/EZHUB.png',
            height: 80,
            fit: BoxFit.fitHeight,
          ),
          const Divider(height: 1),
          Column(
            children: [
              ExpansionTile(
                iconColor: ColorPalette.primaryColor,
                textColor: ColorPalette.primaryColor,
                title: _rowExpansionTitle(
                  icon: const Icon(
                    FontAwesomeIcons.fileInvoiceDollar,
                    size: 20,
                  ),
                  title: 'Quotations',
                ),
                collapsedBackgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: const Text("Create Quote"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(() => const CreateQuote()),
                  ),
                  ListTile(
                    title: const Text("Quotation List"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(() => const QuotationList()),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              ExpansionTile(
                iconColor: ColorPalette.primaryColor,
                textColor: ColorPalette.primaryColor,
                title: _rowExpansionTitle(
                  icon: const Icon(
                    FontAwesomeIcons.arrowRotateRight,
                    size: 20,
                  ),
                  title: 'Renewals',
                ),
                collapsedBackgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: const Text("Renewal List"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(() => const Renewallist()),
                  ),
                  ListTile(
                    title: const Text("Expiry List"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(() => const ExpiryList()),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              ExpansionTile(
                iconColor: ColorPalette.primaryColor,
                textColor: ColorPalette.primaryColor,
                title: _rowExpansionTitle(
                  icon: const Icon(
                    FontAwesomeIcons.fileContract,
                    size: 20,
                  ),
                  title: "Active Policies",
                ),
                collapsedBackgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: const Text("Policy List"),
                    tileColor: Colors.white,
                    onTap: () {
                      // Get.to(() => const UnderMaintenanceScreen());
                      pushScreen(
                        context,
                        screen: const Policylist(),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Client List"),
                    tileColor: Colors.white,
                    onTap: () {
                      // Get.to(() => const UnderMaintenanceScreen());
                      pushScreen(
                        context,
                        screen: const Clientlist(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          ListTile(
            title: _rowExpansionTitle(
              icon: const Icon(
                FontAwesomeIcons.clipboardList,
                size: 20,
              ),
              title: "Issued List",
            ),
            tileColor: Colors.white,
            onTap: () => Get.to(() => const IssuedList()),
          ),
          ListTile(
            title: _rowExpansionTitle(
              icon: const Icon(
                FontAwesomeIcons.moneyBillWave,
                size: 20,
              ),
              title: "Commissions",
            ),
            tileColor: Colors.white,
            onTap: () {
              pushScreen(
                context,
                screen: const Commissionslist(),
              );
            },
          ),
          ListTile(
            title: _rowExpansionTitle(
              icon: const Icon(
                FontAwesomeIcons.fileSignature,
                size: 20,
              ),
              title: "File A Claim",
            ),
            tileColor: Colors.white,
            onTap: () {
              pushScreen(
                context,
                screen: const WebViewer(
                  title: 'File a Claim',
                  url: 'https://info.fpgins.com/s/ocC6bOQi',
                ),
              );
            },
          ),
          Column(
            children: [
              ExpansionTile(
                iconColor: ColorPalette.primaryColor,
                textColor: ColorPalette
                    .primaryColor, //leading: Icon(Icons.arrow_forward_ios),
                title: _rowExpansionTitle(
                  icon: const Icon(
                    FontAwesomeIcons.circleInfo,
                    size: 20,
                  ),
                  title: "Company Information",
                ),
                collapsedBackgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: const Text("Company Profile"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(() => const CompanyProfile()),
                  ),
                  ListTile(
                    title: const Text("Branches"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(() => const Branches()),
                  ),
                  ListTile(
                    title: const Text("Terms and Conditions"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(
                      () => const WebViewer(
                        title: 'Terms & Conditions',
                        url: 'https://ph.fpgins.com/about/terms-conditions/',
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text("Data Privacy"),
                    tileColor: Colors.white,
                    onTap: () => Get.to(() => const UnderMaintenanceScreen()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rowExpansionTitle({
    required Widget icon,
    required String title,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }
}

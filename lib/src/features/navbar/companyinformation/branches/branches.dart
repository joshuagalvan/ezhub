import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';

class Branches extends StatefulWidget {
  const Branches({super.key});

  @override
  State<Branches> createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  final List<Branch> branchList = [
    Branch(
      name: "Alabang",
      address:
          "24th Floor Axis Tower 1 Filinvest Avenue, Northgate Cyberzone, Alabang, Muntinlupa City, Metro Manila, Philippines",
      phoneNumbers: ["(+63) 917 814 7958"],
      email: "alabang@fpgins.com",
    ),
    Branch(
      name: "Angeles",
      address: "No. 303 McArthur Highway Balibago, Angeles City, Pampanga",
      phoneNumbers: ["(045) 458 3866"],
      email: "angeles@fpgins.com",
    ),
    Branch(
      name: "Binondo",
      address:
          "G/F, Pacific Centre Building, 460 Quintin Paredes Road, Binondo, Manila",
      phoneNumbers: ["(02) 8242 4161", "(02) 8523 1698"],
      email: "binondo@fpgins.com",
    ),
    Branch(
      name: "Cagayan De Oro",
      address:
          "2F Cebu CFI Community Cooperative Building, Tiano Bros. corner Mabini Street, Cagayan De Oro City",
      phoneNumbers: ["(02) 8859 1200"],
      email: "cagayandeoro@fpgins.com",
    ),
    Branch(
      name: "Cebu",
      address:
          "Unit 2 2/F One Mango Avenue, General Maxilom Avenue, Cogon Ramos, Cebu City",
      phoneNumbers: ["(032) 232 4715", "(032) 326 7106"],
      email: "cebu@fpgins.com",
    ),
    Branch(
      name: "Dagupan",
      address:
          "Ground Floor, Unit D & E ARB Corporate Center, Tapuac District, Dagupan City",
      phoneNumbers: ["(075) 522 1763"],
      email: "dagupan@fpgins.com",
    ),
    Branch(
      name: "Davao",
      address:
          "2/F Suite A205-206, Plaza de Luisa Bldg., Ramon Magsaysay Ave. Davao City",
      phoneNumbers: ["(082) 224 1289", "(082) 222 0013"],
      email: "davao@fpgins.com",
    ),
    Branch(
      name: "General Santos City",
      address:
          "Unit 202, 2F RDRDC Bldg., P. Acharon Blvd. cor Santiago Blvd, General Santos City",
      phoneNumbers: ["(083) 552 7959"],
      email: "generalsantoscity@fpgins.com",
    ),
    Branch(
      name: "Head Office – Makati",
      address:
          "6/F Zuellig Building, Makati Avenue corner Paseo de Roxas, Makati City 1225, Philippines",
      phoneNumbers: ["(02) 8859 1200", "(02) 8662 8600", "(02) 7944 1300"],
      email: "phcustomercare@fpgins.com",
    ),
    Branch(
      name: "Iloilo",
      address: "2/F Dolores O. Tan Bldg Valeria St., Iloilo City",
      phoneNumbers: ["(033) 325 1251", "(02) 8859 1258"],
      email: "iloilo@fpgins.com",
    ),
    Branch(
      name: "Laguna",
      address:
          "G/F Unit 1AB ALX Building, National Highway, Brgy. Halang, Calamba City, Laguna",
      phoneNumbers: ["(049) 520 5372", "(02) 8859 1293"],
      email: "laguna@fpgins.com",
    ),
    Branch(
      name: "Ortigas",
      address:
          "Unit 1007, One Corporate Center, Julia Vargas corner Meralco Avenue, Ortigas Center, Pasig City",
      phoneNumbers: ["(02) 8721 2321", "(02) 8859 1269", "(02) 8859 1200"],
      email: "ortigas@fpgins.com",
    ),
    Branch(
      name: "Quezon City",
      address:
          "Unit 602 & 604, The Richwell Center, 102 Timog Avenue, Quezon City, Metro Manila",
      phoneNumbers: ["(02) 7944 1358"],
      email: "quezoncity@fpgins.com",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          branches,
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
      body: Padding(
        padding: const EdgeInsets.all(defaultSize),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "If you wish to contact any of our Branches, please select from the list below, where you can contact the FPG Insurance Branch directly.",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  //      color: Color(0xfffe5000),
                  //       fontSize: 5.0,
                  //         fontWeight: FontWeight.bold,
                ),
                strutStyle: StrutStyle(
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: branchList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(5),
                  separatorBuilder: (context, i) => const SizedBox(height: 20),
                  itemBuilder: (context, i) {
                    final branch = branchList[i];
                    return AnimationConfiguration.staggeredList(
                      position: i,
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 300),
                      child: SlideAnimation(
                        horizontalOffset: 50,
                        delay: const Duration(milliseconds: 300),
                        child: FadeInAnimation(
                          duration: const Duration(milliseconds: 400),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 2,
                                  color: Colors.grey[200]!,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  branch.name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 20.0,
                                    color: Color(0xfffe5000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  strutStyle: const StrutStyle(
                                    height: 3.0,
                                  ),
                                ),
                                Text(
                                  branch.address,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                  strutStyle: const StrutStyle(
                                    height: 1.7,
                                  ),
                                ),
                                Text(
                                  'Tel: ${branch.phoneNumbers.join(', ')}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                  strutStyle: const StrutStyle(
                                    height: 1.7,
                                  ),
                                ),
                                Text(
                                  'Email: ${branch.email}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                  strutStyle: const StrutStyle(
                                    height: 1.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class Branch {
  final String name;
  final String address;
  final List<String> phoneNumbers;
  final String email;

  Branch({
    required this.name,
    required this.address,
    required this.phoneNumbers,
    required this.email,
  });
}

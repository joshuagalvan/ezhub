import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
// import 'package:http/http.dart' as http;
import 'package:simone/src/utils/colorpalette.dart';

String? stringResponse;
Map? mapResponse;
Map? dataResponse;
List? listResponse;

class Renewallist extends StatefulWidget {
  const Renewallist({super.key});

  @override
  State<Renewallist> createState() => RenewallistState();
}

class RenewallistState extends State<Renewallist> {
//   // double mtd_gpw = 0.0;
//   // double mtd_ly = 0.0;
//   // int mtd_gr = 0;

//   int renewal_policy_id = 0;
//   late String renewal_policy_motor_review;

//   late PageController _pageController;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     POLICY_NO();
//     _pageController =
//         PageController(initialPage: _currentPage, viewportFraction: 0.8);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//   }

//   final _sqlConnection = MssqlConnection.getInstance();

//   POLICY_NO() async {
//     final controller = Get.put(ProfileController());
//     var userData = await controller.getUserData();
//     var id = await controller.getUserId();

//     String query =
//         """SELECT B.POLICY_NO FROM renewal_policy_motor_queued A LEFT OUTER JOIN
// renewal_policy_motor_review B
// ON A.renewal_policy_id = '${userData.agentCode}'
// WHERE b.bscode = 'M09JI00001' AND A.`status` = 'PENDING'

// UNION ALL

// SELECT B.POLICY_NO FROM renewal_policy_motor_queued A LEFT OUTER JOIN
// renewal_policy_motor_APPROVAL B
// ON A.renewal_policy_id = '${userData.agentCode}'
// WHERE b.bscode = 'M09JI00001'  AND A.`status` = 'PENDING'""";

//     String result = await _sqlConnection.getData(query);
//     setState(() {
//       renewal_policy_id = jsonDecode(result)[0]["RENEWAL_POLICY_ID"];
//       renewal_policy_motor_review =
//           jsonDecode(result)[0]["RENEWAL_POLICY_MOTOR_REVIEW"];
//       //  bscode = jsonDecode(result)[0]["MTD_GROWTH_RATE"];

//     });

  // Future apicall() async {
  //   http.Response response;

  //   response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       //  stringResponse = response.body;
  //       mapResponse = json.decode(response.body);
  //       listResponse = mapResponse?['data'];
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   apicall();
  //   super.initState();
  //   // Example parameters, replace with actual values or user input
  //   // _posts = fetchPosts(30, 'M09JI00001');
  // }

  final _searchController = TextEditingController();
  List<Renewal> filteredRenewal = [];

  final List<Renewal> renewalList = [
    Renewal(
      policyNo: "1090101210000033",
      inception: DateTime(2023, 5, 12),
      expiry: DateTime(2024, 5, 12),
      insured: "Celso & Rosemary Aaron",
      premium: 1200.50,
      status: "Non-renewal",
    ),
    Renewal(
      policyNo: "1090101210000045",
      inception: DateTime(2022, 8, 20),
      expiry: DateTime(2023, 8, 20),
      insured: "Maria Cristiana Reyes",
      premium: 800.00,
      status: "Renewed",
    ),
    Renewal(
      policyNo: "1090101210000067",
      inception: DateTime(2023, 1, 10),
      expiry: DateTime(2024, 1, 10),
      insured: "John Smith",
      premium: 950.75,
      status: "Pending",
    ),
    Renewal(
      policyNo: "1090101210000089",
      inception: DateTime(2023, 3, 15),
      expiry: DateTime(2024, 3, 15),
      insured: "Ana Marie Santos",
      premium: 1100.00,
      status: "Non-renewal",
    ),
    Renewal(
      policyNo: "1090101210000098",
      inception: DateTime(2022, 11, 1),
      expiry: DateTime(2023, 11, 1),
      insured: "Carlos Garcia",
      premium: 1300.50,
      status: "Renewed",
    ),
    Renewal(
      policyNo: "1090101210000123",
      inception: DateTime(2023, 2, 5),
      expiry: DateTime(2024, 2, 5),
      insured: "Samantha Lee",
      premium: 750.00,
      status: "Non-renewal",
    ),
    Renewal(
      policyNo: "1090101210000146",
      inception: DateTime(2022, 9, 25),
      expiry: DateTime(2023, 9, 25),
      insured: "Richard Tan",
      premium: 1150.00,
      status: "Pending",
    ),
    Renewal(
      policyNo: "1090101210000169",
      inception: DateTime(2023, 6, 30),
      expiry: DateTime(2024, 6, 30),
      insured: "Emily Cruz",
      premium: 980.00,
      status: "Renewed",
    ),
    Renewal(
      policyNo: "1090101210000182",
      inception: DateTime(2023, 4, 18),
      expiry: DateTime(2024, 4, 18),
      insured: "Jake Rivera",
      premium: 1025.00,
      status: "Non-renewal",
    ),
    Renewal(
      policyNo: "1090101210000205",
      inception: DateTime(2023, 7, 12),
      expiry: DateTime(2024, 7, 12),
      insured: "Olivia Diaz",
      premium: 1250.75,
      status: "Pending",
    ),
  ];

  void filterRenewal(String query) {
    final List<Renewal> filteredList = renewalList.where((policy) {
      final nameLower = policy.insured.toLowerCase();
      final numberLower = policy.policyNo.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          numberLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredRenewal = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    filteredRenewal = renewalList;
    _searchController.addListener(() {
      filterRenewal(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Renewal List",
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Total Renewals: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'OpenSans',
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  TextSpan(text: '${renewalList.length}'),
                ],
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'OpenSans',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: _searchController,
                    onChanged: filterRenewal,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xfffe5000)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide(
                          color: Color(0xfffe5000),
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text != ''
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                              },
                              child: const Icon(Icons.close),
                            )
                          : const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ResponsiveBuilder(
                        builder: (context, sizingInformation) {
                      if (sizingInformation.deviceScreenType ==
                          DeviceScreenType.tablet) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: 150,
                            ),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: filteredRenewal.length,
                            itemBuilder: (context, i) {
                              final renewal = filteredRenewal[i];
                              return _buildRenewalCard(
                                index: i,
                                renewal: renewal,
                              );
                            },
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredRenewal.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final renewal = filteredRenewal[i];
                          return _buildRenewalCard(
                            index: i,
                            renewal: renewal,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRenewalCard({
    required int index,
    required Renewal renewal,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 400),
      child: SlideAnimation(
        horizontalOffset: 50,
        duration: const Duration(milliseconds: 500),
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 400),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 250, 233, 221),
              ),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Policy No. ${renewal.policyNo}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      renewal.status,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      renewal.insured,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      '₱${renewal.premium}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${DateFormat('MMM dd, yyyy').format(renewal.inception)} - ${DateFormat('MMM dd, yyyy').format(renewal.expiry)}',
                  style: const TextStyle(
                    color: ColorPalette.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans',
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
// itemCount: listResponse == null ? 0 : listResponse?.length,
// ),
// body: DataTable(
//   //  columnSpacing: 150.0,
//   //headingRowHeight: 50,

//   headingRowColor: MaterialStateColor.resolveWith(
//       (states) => Color.fromARGB(255, 236, 115, 60)),
//   columns: [
//     // StepStyle(),

//     DataColumn(
//         label: Text(
//       "Policy",
//       style: TextStyle(
//         fontSize: 20.0,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//         // backgroundColor: Color(0xfffe5000),
//       ),
//     )),
//     DataColumn(
//         label: Text(
//       "Type",
//       style: TextStyle(
//         fontSize: 20.0,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     )),
//   ],
//   rows: [
//     DataRow(cells: [
//       DataCell(Text("1070201220001491")),
//       DataCell(Text("Approved")),
//     ]),
//     DataRow(cells: [
//       DataCell(Text("1070203220000065")),
//       DataCell(Text("Approved")),
//     ])
//   ],
// ),
//     );
//   }
// }

class Renewal {
  final String policyNo;
  final DateTime inception;
  final DateTime expiry;
  final String insured;
  final double premium;
  final String status;

  Renewal({
    required this.policyNo,
    required this.inception,
    required this.expiry,
    required this.insured,
    required this.premium,
    required this.status,
  });
}

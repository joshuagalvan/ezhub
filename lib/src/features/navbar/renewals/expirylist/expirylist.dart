// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:simone/src/constants/sizes.dart';

// // String buildUrl(int duration, String intermediaryCode) {
// //   final uri = Uri.http(
// //     "10.52.2.58", // Replace with your actual domain
// //     '/ecpro-uat/motor/getReasonf/?reason=Awaiting',
// //     {
// //       'PRIVATE_USERNAME': 'Regina'.toString(), // Replace with actual username
// //       'PRIVATE_PASSWORD':
// //           'Testing@1234'.toString(), // Replace with actual password
// //       'duration': duration.toString(),
// //       'intermediary_code': intermediaryCode.toString(),
// //     },
// //   );

// //   return uri.toString();
// // }

// // //Fetch posts from the API
// // Future<List<Post>> fetchPosts(int duration, String intermediaryCode) async {
// //   final url = buildUrl(duration, intermediaryCode);
// //   final response = await http.get(Uri.parse(url));

// //   // try {
// //   if (response.statusCode == 200) {
// //     List<dynamic> data = jsonDecode(response.body);
// //     return data.map((json) => Post.fromJson(json)).toList();
// //   } else {
// //     throw Exception('Failed to load posts');
// //   }
// // } catch (e) {
// //   print('Error fetching posts: $e');
// //   return []; // Return an empty list in case of an error
// // }
// // }

// String? stringResponse;
// Map? mapResponse;
// Map? dataResponse;
// List? listResponse;

// class Expirylist extends StatefulWidget {
//   const Expirylist({super.key});
//   State<Expirylist> createState() => ExpirylistState();
// }

// class ExpirylistState extends State<Expirylist> {
//   // late Future<List<Post>> _posts;
//   // late String stringResponse;
//   // late Map mapResponse;
//   // late Map dataResponse;
//   // late List listResponse;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Example parameters, replace with actual values or user input
//   //   _posts = fetchPosts(30, 'M09JI00001');
//   // }

//   Future apicall() async {
//     http.Response response;

//     response = await http.get(Uri.parse(
//         'http://10.52.2.58/hive/policy/renewal-duration?intermediary_code=M05HN00001'));
//     if (response.statusCode == 200) {
//       setState(() {
//         //  stringResponse = response.body;
//         mapResponse = json.decode(response.body);
//         listResponse = mapResponse?['record'];
//       });
//     }
//   }

//   @override
//   void initState() {
//     apicall();
//     super.initState();
//     // Example parameters, replace with actual values or user input
//     // _posts = fetchPosts(30, 'M09JI00001');
//   }

// // class Post {
// //   final int id;
// //   final String title;
// //   final String body;

// //   Post({required this.id, required this.title, required this.body});

// //   factory Post.fromJson(Map<String, dynamic> json) {
// //     return Post(
// //       id: json['id'],
// //       title: json['title'],
// //       body: json['body'],
// //     );
// //   }
// // }

// // class Cloud {
// //   static const String DOMAIN_NAME_HIVE =
// //       "https://10.52.2.58/policy/renewal-duration";
// //   static const String PRIVATE_USERNAME = "user";
// //   static const String PRIVATE_PASSWORD = "password";
// // }

// // String buildUrl(int duration, String intermediaryCode) {
// //   final uri = Uri.https(
// //     // Base domain
// //     Cloud.DOMAIN_NAME_HIVE.replaceFirst(
// //         'https://10.52.2.58/policy/renewal-duration',
// //         ''), // Remove 'https://' for Uri.https()
// //     '/policy/renewal-duration',
// //     {
// //       'PRIVATE_USERNAME': Cloud.PRIVATE_USERNAME,
// //       'PRIVATE_PASSWORD': Cloud.PRIVATE_PASSWORD,
// //       'duration': duration.toString(),
// //       'intermediary_code': intermediaryCode,
// //     },
// //   );
// //   return uri.toString();
// // }

// // void main() {
// //   final url = buildUrl(30, 'ABC123');
// //   print(url); // Prints the complete URL
// // }

// //   Future<List<Post>> fetchPosts(int duration, String intermediaryCode) async {
// //   final url = buildUrl(duration, intermediaryCode);
// //   final response = await http.get(Uri.parse(url));

// //   if (response.statusCode == 200) {
// //     List<dynamic> data = jsonDecode(response.body);
// //     return data.map((json) => Post.fromJson(json)).toList();
// //   } else {
// //     throw Exception('Failed to load posts');
// //   }
// // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 251, 248, 246),
//       appBar: AppBar(
//         title: Text(
//           "Expiry List",
//           style: TextStyle(
//             fontSize: 30.0,
//             fontFamily: 'OpenSans',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//               Icons.arrow_back_ios), // Different icon for back button
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ListView.builder(
//         itemBuilder: (context, index) {
//           return Container(
//             //   height: 50,
//             margin: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Color.fromARGB(255, 250, 233, 221),
//               ),
//               color: Color.fromARGB(255, 255, 255, 255),
//             ),

//             padding: EdgeInsets.all(defaultSize),

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(listResponse![index]['bsname'].toString()),
//                 Text(listResponse![index]['Insured_Name'].toString()),
//                 Text(listResponse![index]['LOB'].toString()),
//                 Text(listResponse![index]['policy_no'].toString()),
//                 Text(listResponse![index]['inception_date'].toString()),
//                 Text(listResponse![index]['expiry_date'].toString()),
//                 Text(listResponse![index]['renewal_status'].toString()),
//               ],
//             ),
//           );
//         },
//         itemCount: listResponse == null ? 0 : listResponse?.length,
//       ),
//     );
//   }
// }

// // body: Center(
// //   child: Container(
// //     height: 200,
// //     width: 300,
// //     decoration: BoxDecoration(
// //       borderRadius: BorderRadius.circular(20),
// //       color: Colors.white,
// //     ),
// //     child: Center(
// //       child: listResponse == null
// //           ? Container()
// //           : Text(listResponse![1]['first_name'].toString()),
// //     ),
// //   ),
// // ),

// // body: FutureBuilder<List<Post>>(
// //   future: _posts,
// //   builder: (context, snapshot) {
// //     if (snapshot.connectionState == ConnectionState.waiting) {
// //       return Center(child: CircularProgressIndicator());
// //     } else if (snapshot.hasError) {
// //       return Center(child: Text('Error: ${snapshot.error}'));
// //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //       return Center(child: Text('No posts available'));
// //     } else {
// //       final posts = snapshot.data!;

// //       return ListView.builder(
// //         itemCount: posts.length,
// //         itemBuilder: (context, index) {
// //           final post = posts[index];
// //           return ListTile(
// //             title: Text(post.title),
// //             subtitle: Text(post.body),
// //             leading: CircleAvatar(
// //               child: Text(post.id.toString()),
// //             ),
// //           );
// //         },
// //       );
// //     }
// //   },
// // ),
// // body: DataTable(
// //   //  columnSpacing: 150.0,
// //   // headingRowHeight: 50,
// //   // headingRowColor: MaterialStateColor.resolveWith(
// //   //     (states) => Color.fromARGB(255, 249, 136, 84)),

// //   columns: [
// //     // StepStyle(),

// //     DataColumn(
// //       label: Text(""),
// //     ),
// //     DataColumn(
// //       label: Text(""),
// //     ),
// //   ],
// //   rows: [
// //     DataRow(cells: [
// //       DataCell(Text(
// //           "Name \nLine of Business \nPolicy Number \n Inception Date \nExpiry Date \nGross Premiun \nPremium Paid \nRenewal Status")),
// //       DataCell(Text(
// //           "SPS, FELIX/MINDA DACUYCUY \nFIRE \n1050101210000748 \nMay 27, 2024 \nMay 27, 2025 \n3,800.00 \n3,800.00 \nUNRENEWED")),
// //     ]),
// //     // DataRow(cells: [
// //     //   DataCell(Text(
// //     //       "Name \nLine of Business \nPolicy Number \n Inception Date \nExpiry Date \nGross Premiun \nPremium Paid \nRenewal Status")),
// //     //   DataCell(Text(
// //     //       "NELSON B. MONSERAT \nFIRE \n1050101210000823 \nMay 14, 2024 \nMay 14, 2025 \n5,400.00 \n5,400.00 \nUNRENEWED")),
// //     // ])
// //   ],
// // ),
// //   );
// // }

// void main() {
//   runApp(MaterialApp(
//     home: Expirylist(),
//   ));
// }
// // }

import 'dart:convert';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/src/features/authentication/models/expiry_model.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';

class ExpiryList extends StatefulWidget {
  const ExpiryList({super.key});

  @override
  State<ExpiryList> createState() => ExpiryListState();
}

class ExpiryListState extends State<ExpiryList> {
  final _searchController = TextEditingController();
  List<ExpiryModel> filteredExpiry = [];
  List<ExpiryModel> expiryList = [];
  bool isLoading = true;

  void filterExpiry(String query) {
    final List<ExpiryModel> filteredList = expiryList.where((policy) {
      final nameLower = policy.insuredName.toLowerCase();
      final numberLower = policy.policyNo.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          numberLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredExpiry = filteredList;
    });
  }

  void fetchExpiryList() async {
    setState(() {
      isLoading = true;
    });
    final storage = GetStorage().read('userData');
    final response = await http.get(
      Uri.parse(
          'http://10.52.2.58/ras-uat/policy/getExpiryListf?agent=${storage['agentCode']}'),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['record']
          .map((expiry) => ExpiryModel.fromJson(expiry))
          .toList();
      final allExpiry = List<ExpiryModel>.from(result);
      if (mounted) {
        setState(() {
          expiryList = allExpiry;
          filteredExpiry = allExpiry;
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExpiryList();
    _searchController.addListener(() {
      filterExpiry(_searchController.text);
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
          "Expiry List",
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
                    text: 'Total Expiry: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'OpenSans',
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  TextSpan(
                      text: '${expiryList.isEmpty ? '0' : expiryList.length}'),
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
                    onChanged: filterExpiry,
                    decoration: InputDecoration(
                      hintText: 'Search Policy No., Insured Name...',
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
                        return isLoading
                            ? _buildLoadingWidget()
                            : Padding(
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
                                  itemCount: filteredExpiry.length,
                                  itemBuilder: (context, i) {
                                    final expiry = filteredExpiry[i];

                                    return _buildExpiryCard(
                                      index: i,
                                      policyNo: expiry.policyNo,
                                      insuredName: expiry.insuredName,
                                      premium: expiry.renewalPremium
                                          .formatWithCommas(),
                                      inceptionDate: expiry.inceptionDate,
                                      expiryDate: expiry.expiryDate,
                                    );
                                  },
                                ),
                              );
                      }
                      return isLoading
                          ? _buildLoadingWidget()
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: filteredExpiry.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, i) {
                                final expiry = filteredExpiry[i];
                                return _buildExpiryCard(
                                  index: i,
                                  policyNo: expiry.policyNo,
                                  insuredName: expiry.insuredName,
                                  premium:
                                      expiry.renewalPremium.formatWithCommas(),
                                  inceptionDate: expiry.inceptionDate,
                                  expiryDate: expiry.expiryDate,
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

  Widget _buildExpiryCard({
    required int index,
    required String policyNo,
    required String insuredName,
    required String premium,
    required DateTime inceptionDate,
    required DateTime expiryDate,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 400),
      delay: const Duration(milliseconds: 10),
      child: SlideAnimation(
        verticalOffset: 50,
        duration: const Duration(milliseconds: 400),
        delay: const Duration(milliseconds: 10),
        child: FadeInAnimation(
          delay: const Duration(milliseconds: 10),
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
                      'Policy No. $policyNo',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                      ),
                    ),
                    // Text(
                    //   expiry.review,
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontFamily: 'OpenSans',
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .45,
                        child: Text(
                          insuredName,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '₱$premium',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${DateFormat('MMM dd, yyyy').format(inceptionDate)} - ${DateFormat('MMM dd, yyyy').format(expiryDate)}',
                  style: const TextStyle(
                    color: ColorPalette.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) => const FadeShimmer(
        height: 115,
        width: double.infinity,
        radius: 20,
        highlightColor: ColorPalette.greyE3,
        baseColor: ColorPalette.greyLight,
      ),
    );
  }
}

import 'dart:convert';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:simone/src/features/navbar/issuedlist/previewissued.dart';
import 'package:simone/src/utils/colorpalette.dart';

class IssuedList extends StatefulWidget {
  const IssuedList({super.key});

  @override
  State<IssuedList> createState() => _IssuedListState();
}

class _IssuedListState extends State<IssuedList> {
  final controller = Get.put(ProfileController());
  final _searchController = TextEditingController();
  List<dynamic> filteredIssuedList = [];
  List<dynamic> issuedList = [];
  bool isLoading = false;
  String status = '';

  getIssuedPolicies() async {
    setState(() {
      isLoading = true;
    });

    var userData = await controller.getUserData();
    try {
      final response = await http.get(
          Uri.parse(
              'http://10.52.2.117:1003/api/motor-policies/?intm_code=${userData?.agentCode ?? ''}&source=EZH'),
          headers: {
            'X-Authorization':
                'Uskfm1KDr3KtCStV0W28oOoee8pTVkaCszauYNyyknDL9r5LLZv24Stt0GVWekeV'
          });

      var result = (jsonDecode(response.body));

      issuedList = [];
      // for (var row in result['data']) {
      //   issuedList.add(row);
      // }
      issuedList = result['data'] ?? [];
      issuedList.sort((a, b) => b['created_at'].compareTo(a['created_at']));
      filteredIssuedList = issuedList;
      _searchController.addListener(() {
        filterIssuedList(_searchController.text);
      });

      setState(() {
        isLoading = false;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    getIssuedPolicies();
  }

  Future<String> getStatus(String? policyNumber) async {
    if (policyNumber != null) {
      try {
        final response = await http.get(
          Uri.parse(
              'http://10.52.2.58/care-uat/policy/getPremiumAmountEzHub/?policy=$policyNumber'),
        );
        var result = (jsonDecode(response.body));

        if (result['record'] == "0.0" || result['record'] == "0") {
          return "PAID";
        } else {
          return "PENDING";
        }
      } catch (_) {
        return "PENDING";
      }
    }
    return "PENDING";
  }

  void filterIssuedList(String query) {
    final filteredList = issuedList.where((quote) {
      final refNumber = quote['payment_reference'].toLowerCase();
      final firstName = '${quote['insured']['first_name']}';
      final middleName = '${quote['insured']['middle_name']}';
      final lastName = '${quote['insured']['last_name']}';
      final name = '$firstName $middleName $lastName'.toLowerCase();
      final searchLower = query.toLowerCase();

      return refNumber.contains(searchLower) || name.contains(searchLower);
    }).toList();

    setState(() {
      filteredIssuedList = filteredList;
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
          "Issued List",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: InputTextField(
              controller: _searchController,
              hintText: 'Search Payment Ref No., Name..',
              onChanged: filterIssuedList,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
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
                            itemCount: filteredIssuedList.length,
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: 140,
                            ),
                            itemBuilder: (context, i) {
                              final item = filteredIssuedList[i];
                              var name = item['insured']['full_name'];
                              var id = item['id'].toString();
                              var refNo = item['payment_reference'];
                              var policyNumber = item['policy_no'].toString();

                              DateTime dateIssued =
                                  DateTime.parse(item['created_at'].toString());
                              String date = DateFormat('yyyy-MM-dd  hh:mm:ss a')
                                  .format(dateIssued);

                              return _buildIssuedCard(
                                index: i,
                                name: name,
                                policyNumber: policyNumber,
                                id: id,
                                refNo: refNo,
                                date: date,
                              );
                            },
                          ),
                        );
                }
                return isLoading
                    ? _buildLoadingWidget()
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.separated(
                          itemCount: filteredIssuedList.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, i) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final item = filteredIssuedList[i];
                            var name = item['insured']['full_name'];
                            var id = item['id'].toString();
                            var refNo = item['payment_reference'];
                            var policyNumber = item['policy_no'].toString();

                            DateTime dateIssued =
                                DateTime.parse(item['created_at'].toString());
                            String date = DateFormat('yyyy-MM-dd  hh:mm:ss a')
                                .format(dateIssued);

                            return _buildIssuedCard(
                              index: i,
                              name: name,
                              policyNumber: policyNumber,
                              id: id,
                              refNo: refNo,
                              date: date,
                            );
                          },
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssuedCard({
    required int index,
    required String name,
    required String policyNumber,
    required String id,
    required String refNo,
    required String date,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 400),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 400),
          child: FutureBuilder(
            future: getStatus(policyNumber),
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => PreviewIssued(
                        id: id,
                      ));
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 2,
                        color: Colors.grey[200]!,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      snapshot.data != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              decoration: BoxDecoration(
                                color: snapshot.data == 'PAID'
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                snapshot.data ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: snapshot.data == 'PAID'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: const FadeShimmer(
                                height: 32,
                                width: 100,
                                radius: 4,
                                highlightColor: ColorPalette.greyE3,
                                baseColor: ColorPalette.greyLight,
                              ),
                            ),
                      const SizedBox(height: 5),
                      Text(
                        refNo,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsets.all(20),
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: const FadeShimmer(
          height: 150,
          width: double.infinity,
          radius: 4,
          highlightColor: ColorPalette.greyE3,
          baseColor: ColorPalette.greyLight,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/src/utils/colorpalette.dart';

class Policylist extends StatefulWidget {
  const Policylist({super.key});

  @override
  State<Policylist> createState() => _PolicylistState();
}

class _PolicylistState extends State<Policylist> {
  final _searchController = TextEditingController();
  List<PolicyModel> filteredPolicies = [];

  final List<PolicyModel> policyList = [
    PolicyModel(
      policyName: "DBP Leasing Corporation Leased",
      policyNumber: "1020522400000001",
    ),
    PolicyModel(
      policyName: "Celso & Rosemary Aaron",
      policyNumber: "1020522400000037",
    ),
    PolicyModel(
      policyName: "Senator Crewing Manila, Inc.",
      policyNumber: "1020522400000020",
    ),
    PolicyModel(
      policyName: "Health Insurance",
      policyNumber: "1020522400000001",
    ),
    PolicyModel(
      policyName: "Life Insurance",
      policyNumber: "L98765",
    ),
    PolicyModel(
      policyName: "Car Insurance",
      policyNumber: "C56789",
    ),
    PolicyModel(
      policyName: "Home Insurance - Mark & Anna Cruz",
      policyNumber: "1020522400000051",
    ),
    PolicyModel(
      policyName: "Travel Insurance - Juan Dela Cruz",
      policyNumber: "T20245216",
    ),
    PolicyModel(
      policyName: "Fire Insurance - BDO Unibank, Inc.",
      policyNumber: "1020522400000063",
    ),
    PolicyModel(
      policyName: "Personal Accident Insurance - John Smith",
      policyNumber: "PA8745236",
    ),
    PolicyModel(
      policyName: "Corporate Health Insurance - ABC Corporation",
      policyNumber: "CH10253624",
    ),
    PolicyModel(
      policyName: "General Liability Insurance - XYZ Construction Co.",
      policyNumber: "GL10283010",
    ),
    PolicyModel(
      policyName: "Property Insurance - Greenfield Properties",
      policyNumber: "PR10152743",
    ),
    PolicyModel(
      policyName: "Motor Insurance - Jane Doe",
      policyNumber: "M10235824",
    ),
    PolicyModel(
      policyName: "Marine Insurance - Pacific Shipping Corp.",
      policyNumber: "MR10356829",
    ),
  ];

  void filterPolicies(String query) {
    final List<PolicyModel> filteredList = policyList.where((policy) {
      final nameLower = policy.policyName.toLowerCase();
      final numberLower = policy.policyNumber.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          numberLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredPolicies = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    filteredPolicies = policyList;
    _searchController.addListener(() {
      filterPolicies(_searchController.text);
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
          "Policy List",
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
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Total No. of Policy: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'OpenSans',
                    color: ColorPalette.primaryColor,
                  ),
                ),
                TextSpan(text: '${policyList.length}'),
              ],
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              dataMap: const {
                "Paid": 10,
                "Unpaid": 5,
              },
              colorList: const [
                Color(0xfffe5000),
                Color.fromARGB(255, 207, 207, 207),
              ],
              chartType: ChartType.ring,
              chartRadius: MediaQuery.of(context).size.width * 0.3,
              centerTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'OpenSans',
              ),
              ringStrokeWidth: 40,
              degreeOptions: const DegreeOptions(
                initialAngle: 270,
              ),
              animationDuration: const Duration(seconds: 2),
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: true,
                showChartValuesOutside: true,
                showChartValuesInPercentage: false,
                showChartValueBackground: true,
                chartValueStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
              legendOptions: const LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.bottom,
                showLegendsInRow: true,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _searchController,
                    onChanged: filterPolicies,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xfffe5000)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide(
                          color: Color(0xfffe5000),
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
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
                              mainAxisExtent: 110,
                            ),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: filteredPolicies.length,
                            itemBuilder: (context, i) {
                              final policy = filteredPolicies[i];
                              return _buildPolicyCard(
                                index: i,
                                policy: policy,
                              );
                            },
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredPolicies.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemBuilder: (context, i) {
                          final policy = filteredPolicies[i];
                          return _buildPolicyCard(
                            index: i,
                            policy: policy,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPolicyCard({required int index, required PolicyModel policy}) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 400),
      child: SlideAnimation(
        horizontalOffset: 50,
        duration: const Duration(milliseconds: 500),
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 2,
                  color: Colors.grey[200]!,
                )
              ],
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policy.policyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'OpenSans',
                  ),
                ),
                Text(policy.policyNumber),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PolicyModel {
  PolicyModel({
    required this.policyName,
    required this.policyNumber,
  });

  final String policyName;
  final String policyNumber;
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/src/utils/colorpalette.dart';

class Commissionslist extends StatefulWidget {
  const Commissionslist({super.key});

  @override
  State<Commissionslist> createState() => _CommissionslistState();
}

class _CommissionslistState extends State<Commissionslist> {
  final _searchController = TextEditingController();
  List<CommissionsModel> filteredCommissions = [];

  final List<CommissionsModel> commissionList = [
    CommissionsModel(
      voucher: "CN-09-21-00000248",
      sourceID: "M09JI00001",
      sourceName: "JOSE ISAGANI FLORES",
      docNo: "1090101210000033",
      remarks: "CELSO & ROSEMARY",
    ),
    CommissionsModel(
      voucher: "CN-09-21-00000249",
      sourceID: "M09JI00002",
      sourceName: "MARIA CRISTINA REYES",
      docNo: "1090101210000045",
      remarks: "Health Insurance",
    ),
    CommissionsModel(
      voucher: "CN-09-21-00000250",
      sourceID: "M09JI00003",
      sourceName: "JUAN DELA CRUZ",
      docNo: "1090101210000067",
      remarks: "Life Insurance",
    ),
    CommissionsModel(
      voucher: "CN-09-21-00000251",
      sourceID: "M09JI00004",
      sourceName: "ANA MARIE SANTOS",
      docNo: "1090101210000089",
      remarks: "Motor Insurance",
    ),
    CommissionsModel(
      voucher: "CN-09-21-00000252",
      sourceID: "M09JI00005",
      sourceName: "CARLOS GARCIA",
      docNo: "1090101210000098",
      remarks: "Property Insurance",
    ),
    CommissionsModel(
      voucher: "CN-09-21-00000253",
      sourceID: "M09JI00006",
      sourceName: "LUIS TAN",
      docNo: "1090101210000123",
      remarks: "Travel Insurance",
    ),
  ];

  void filterCommissions(String query) {
    final List<CommissionsModel> filteredList =
        commissionList.where((commission) {
      final nameLower = commission.sourceName.toLowerCase();
      final numberLower = commission.sourceID.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          numberLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredCommissions = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    filteredCommissions = commissionList;
    _searchController.addListener(() {
      filterCommissions(_searchController.text);
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
          "Commissions List",
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
                  text: 'Total No. of Commission: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'OpenSans',
                    color: ColorPalette.primaryColor,
                  ),
                ),
                TextSpan(text: '${commissionList.length}'),
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
                "Paid": 4,
                "Unpaid": 2,
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
                    onChanged: filterCommissions,
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
                                    mainAxisExtent: 130),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: filteredCommissions.length,
                            itemBuilder: (context, i) {
                              final commission = filteredCommissions[i];
                              return _buildCommissionCard(
                                index: i,
                                commission: commission,
                              );
                            },
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredCommissions.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, i) {
                          final commission = filteredCommissions[i];
                          return _buildCommissionCard(
                            index: i,
                            commission: commission,
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

  Widget _buildCommissionCard({
    required int index,
    required CommissionsModel commission,
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
                  'Voucher: ${commission.voucher}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Source ID: ${commission.sourceID}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Source Name: ${commission.sourceName}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Doc No.: ${commission.docNo}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                // Text(
                //   'Remarks: ${commission.remarks}',
                //   style: const TextStyle(
                //     fontSize: 16,
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

class CommissionsModel {
  final String voucher;
  final String sourceID;
  final String sourceName;
  final String docNo;
  final String remarks;

  CommissionsModel({
    required this.voucher,
    required this.sourceID,
    required this.sourceName,
    required this.docNo,
    required this.remarks,
  });
}

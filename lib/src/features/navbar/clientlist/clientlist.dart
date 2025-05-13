import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/src/utils/colorpalette.dart';

class Clientlist extends StatefulWidget {
  const Clientlist({super.key});

  @override
  State<Clientlist> createState() => _ClientlistState();
}

class _ClientlistState extends State<Clientlist> {
  final _searchController = TextEditingController();
  List<ClientModel> filteredClient = [];

  final List<ClientModel> clientList = [
    ClientModel(
      clientName: "HILMARC’S CONSTRUCTION CORP.",
      clientNumber: "1020522400000001",
    ),
    ClientModel(
      clientName: "JOVYLYN QUIZON GEN   ERALAO",
      clientNumber: "1020522400000037",
    ),
    ClientModel(
      clientName: "JENNIFER U. UNICIANO",
      clientNumber: "1020522400000020",
    ),
    ClientModel(
      clientName: "OLIVER F. CANDELARIO",
      clientNumber: "1020522400000001",
    ),
    ClientModel(
      clientName: "Mark & Anna Cruz",
      clientNumber: "1020522400000051",
    ),
    ClientModel(
      clientName: "Juan Dela Cruz",
      clientNumber: "T20245216",
    ),
    ClientModel(
      clientName: "BDO Unibank, Inc.",
      clientNumber: "1020522400000063",
    ),
    ClientModel(
      clientName: "John Smith",
      clientNumber: "PA8745236",
    ),
    ClientModel(
      clientName: "ABC Corporation",
      clientNumber: "CH10253624",
    ),
    ClientModel(
      clientName: "XYZ Construction Co.",
      clientNumber: "GL10283010",
    ),
    ClientModel(
      clientName: "Greenfield Properties",
      clientNumber: "PR10152743",
    ),
    ClientModel(
      clientName: "Jane Doe",
      clientNumber: "M10235824",
    ),
    ClientModel(
      clientName: "Pacific Shipping Corp.",
      clientNumber: "MR10356829",
    ),
    ClientModel(
      clientName: "SecureTech Solutions",
      clientNumber: "CY10523647",
    ),
    ClientModel(
      clientName: "Markus Del Rosario",
      clientNumber: "CY10523647",
    ),
  ];

  void filterClients(String query) {
    final List<ClientModel> filteredList = clientList.where((policy) {
      final nameLower = policy.clientName.toLowerCase();
      final numberLower = policy.clientNumber.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          numberLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredClient = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    filteredClient = clientList;
    _searchController.addListener(() {
      filterClients(_searchController.text);
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
          "Client List",
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
                  text: 'Total No. of Client: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'OpenSans',
                    color: ColorPalette.primaryColor,
                  ),
                ),
                TextSpan(text: '${clientList.length}'),
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
                    onChanged: filterClients,
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
                              mainAxisExtent: 100,
                            ),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: filteredClient.length,
                            itemBuilder: (context, i) {
                              final client = filteredClient[i];
                              return _buildClientCard(
                                index: i,
                                client: client,
                              );
                            },
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredClient.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemBuilder: (context, i) {
                          final client = filteredClient[i];
                          return _buildClientCard(
                            index: i,
                            client: client,
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

  Widget _buildClientCard({required int index, required ClientModel client}) {
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
                  client.clientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

class ClientModel {
  ClientModel({
    required this.clientName,
    required this.clientNumber,
  });

  final String clientName;
  final String clientNumber;
}

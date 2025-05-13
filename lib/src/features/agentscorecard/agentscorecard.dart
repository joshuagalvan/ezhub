import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';

class Agentscorecard extends StatefulWidget {
  const Agentscorecard({super.key});

  @override
  State<Agentscorecard> createState() => AgentscorecardState();
}

class AgentscorecardState extends State<Agentscorecard> {
  double mtd_gpw = 0.0;
  double mtd_ly = 0.0;
  int mtd_gr = 0;
  double ytd_gpw = 0.0;
  double ytd_ly = 0.0;
  int ytd_gr = 0;
  int loss_inc = 0;
  double lr_gpw = 0.0;
  int loss_rat = 0;
  int paid_prem = 0;
  double pp_gpw = 0.0;
  int paid_pr = 0;

  late PageController _pageController;
  // int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    scorecardData();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  // String ip = '10.52.2.236',
  //     port = '1433',
  //     username = 'FPGPH',
  //     password = 'ifrs17',
  //     databaseName = 'SEA_FPG_PHIL';

  final _sqlConnection = MssqlConnection.getInstance();

  scorecardData() async {
    final controller = Get.put(ProfileController());
    var userData = await controller.getUserData();

    // if (ip.isEmpty ||
    //     port.isEmpty ||
    //     databaseName.isEmpty ||
    //     username.isEmpty ||
    //     password.isEmpty) {
    //   print("Please enter all fields");

    //   return;
    // }
    // await _sqlConnection
    //     .connect(
    //         ip: ip,
    //         port: port,
    //         databaseName: databaseName,
    //         username: username,
    //         password: password)
    //     .then((value) {
    //   if (value) {
    //     print("Connected");
    //   } else {
    //     print("No Connection");
    //   }
    // });

    String query = """SELECT sum(MTD_GPW) AS MTD_GPW, 
        sum(MTD_LY) AS MTD_LY, 
        SUM(MTD_GROWTH_RATE) AS MTD_GROWTH_RATE, 
        sum(YTD_GPW) AS YTD_GPW, 
	      sum(YTD_LY) AS YTD_LY, 
	      SUM(YTD_GROWTH_RATE) AS YTD_GROWTH_RATE,
	      SUM(LOSSES_INCURRED) AS LOSSES_INCURRED,
	      SUM(LOSS_RATIO) AS LOSS_RATIO,
	      SUM(PAID_PREMIUM) AS PAID_PREMIUM,
	      SUM(PAID_PREMIUM_RATIO) AS PAID_PREMIUM_RATIO 
        FROM TEMP_VEN_DATA 
        WHERE new_source_id = '${userData?.agentCode ?? ''}' 
        GROUP BY new_source_id""";

    String result = await _sqlConnection.getData(query);
    setState(() {
      mtd_gpw = jsonDecode(result)[0]["MTD_GPW"];
      mtd_ly = jsonDecode(result)[0]["MTD_LY"];
      mtd_gr = jsonDecode(result)[0]["MTD_GROWTH_RATE"];
      ytd_gpw = jsonDecode(result)[0]["YTD_GPW"];
      ytd_ly = jsonDecode(result)[0]["YTD_LY"];
      ytd_gr = jsonDecode(result)[0]["YTD_GROWTH_RATE"];
      loss_inc = jsonDecode(result)[0]["LOSSES_INCURRED"];
      loss_rat = jsonDecode(result)[0]["LOSS_RATIO"];
      paid_prem = jsonDecode(result)[0]["PAID_PREMIUM"];
      paid_pr = jsonDecode(result)[0]["PAID_PREMIUM_RATIO"];
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
          "Scorecard",
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
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children: [
              const Divider(
                color: Colors.black,
              ),
              const Text(
                "COMPARATIVE PERFORMANCE",
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const ListTile(
                title: Center(
                  child: Text("Month to Date (GPW)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Current"),
                trailing: Text(mtd_gpw.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Last Year"),
                trailing: Text(mtd_ly.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Growth Rate"),
                trailing: Text(mtd_gr.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              const ListTile(
                title: Center(
                  child: Text("Year to Date (GPW)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Current"),
                trailing: Text(ytd_gpw.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Last Year"),
                trailing: Text(ytd_ly.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Growth Rate"),
                trailing: Text(ytd_gr.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black,
              ),
              const Text(
                "PROFITABILITY",
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const ListTile(
                title: Center(
                  child: Text("Loss Ratio",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Losses Incurred"),
                trailing: Text(loss_inc.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("GPW"),
                trailing: Text(lr_gpw.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Loss Ratio"),
                trailing: Text(loss_rat.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              const ListTile(
                title: Center(
                  child: Text("Paid Premium",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Paid Premium"),
                trailing: Text(paid_prem.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("GPW"),
                trailing: Text(pp_gpw.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Paid Premium Ratio"),
                trailing: Text(paid_pr.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.deepOrange)),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

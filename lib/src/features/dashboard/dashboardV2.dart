import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/features/authentication/models/models.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/features/motor/productmotor.dart';
import 'package:simone/src/features/travel/travel_view.dart';
import 'package:simone/src/utils/colorpalette.dart';

class Dashboard extends HookWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueNotifier<DateTime> nowDate = useState(DateTime.now());
    // ValueNotifier<String> startDate = useState('');
    // ValueNotifier<String> endDate = useState('');
    // ValueNotifier<String> year = useState('');
    ValueNotifier<String> branchName = useState('');
    ValueNotifier<bool> isLoading = useState(false);
    ValueNotifier<int> currentProduct = useState(0);
    ValueNotifier<UserModel?> profile = useState(null);
    ValueNotifier<dynamic> scorecard = useState(null);

    final sqlConnection = MssqlConnection.getInstance();

    Future<void> scorecardData() async {
      final controller = Get.put(ProfileController());
      var userData = await controller.getUserData();
      String query = """
        SELECT sum(MTD_GPW) AS MTD_GPW, 
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
        GROUP BY new_source_id
      """;

      String result = await sqlConnection.getData(query);
      scorecard.value = jsonDecode(result)[0];
    }

    Future<void> getBranch() async {
      final storage = GetStorage();
      final userData = await storage.read('userData');
      final branchData = await storage.read('branch');

      if (branchData != null) {
        branchName.value = (branchData['branch']);
      }

      profile.value = UserModel.fromJson(userData);
    }

    final startDateTime = useState(DateTime(DateTime.now().year, 1, 1));
    final endDateTime = useState(DateTime.now());
    final displayPeriodTime = useState('');

    Future<void> pickDateRange(BuildContext context) async {
      final pickedRange = await showCalendarDatePicker2Dialog(
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range,
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime.now(),
          selectedRangeHighlightColor:
              ColorPalette.primaryLighter.withOpacity(0.8),
          selectedDayHighlightColor: ColorPalette.primaryLight,
          calendarViewMode: CalendarDatePicker2Mode.month,
          hideMonthPickerDividers: true,
          hideScrollViewTopHeader: true,
          hideScrollViewMonthWeekHeader: true,
          hideScrollViewTopHeaderDivider: true,
          hideYearPickerDividers: true,
          disableModePicker: true,
          disableMonthPicker: true,
          calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
        ),
        dialogSize: const Size(400, 400),
      );

      if (pickedRange != null) {
        if (pickedRange.isNotEmpty &&
            pickedRange[0] != null &&
            pickedRange[1] != null) {
          startDateTime.value = pickedRange[0]!;
          endDateTime.value = pickedRange[1]!;

          final DateFormat formatter = DateFormat('MMMM d, y');
          displayPeriodTime.value =
              "Period ${formatter.format(startDateTime.value)} to ${formatter.format(endDateTime.value)}";
        }
      }
    }

    useEffect(() {
      isLoading.value = true;

      // var offset = nowDate.value.day - 15;
      // var startDay = 1;
      // var endDay = 15;
      // if (offset >= 15) {
      //   startDay = 16;
      //   endDay = 0;
      // }
      // startDate.value = DateFormat('MMMM d')
      //     .format(DateTime(nowDate.value.year, nowDate.value.month, startDay));
      // endDate.value = DateFormat('MMMM d')
      //     .format(DateTime(nowDate.value.year, nowDate.value.month, endDay));
      // year.value = DateFormat('y')
      //     .format(DateTime(nowDate.value.year, nowDate.value.month, startDay));
      final DateFormat formatter = DateFormat('MMMM d, y');
      displayPeriodTime.value =
          "Period ${formatter.format(startDateTime.value)} to ${formatter.format(endDateTime.value)}";
      asyncing() async {
        await Future.delayed(const Duration(seconds: 1));
        await getBranch();
        await scorecardData();
      }

      asyncing();

      isLoading.value = false;
      return null;
    }, []);

    final size = MediaQuery.of(context).size;
    return isLoading.value
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 120.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 2),
                          color: Color.fromARGB(255, 220, 216, 216),
                          spreadRadius: 2,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Agent Scorecard",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Branch'),
                            Text(
                              branchName.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Intermediary'),
                            Text(
                              profile.value?.fullName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      pickDateRange(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        displayPeriodTime.value,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // pushScreen(
                          //   context,
                          //   screen: const Agentscorecard(),
                          // );
                        },
                        child: Container(
                          height: 190,
                          width: size.width * 0.47,
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(1, 2),
                                color: Color.fromARGB(255, 220, 216, 216),
                                spreadRadius: 2,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: agentGraph(
                            context,
                            label: 'Growth Rate',
                            dataMap: {
                              "Last Year": scorecard.value != null
                                  ? scorecard.value['YTD_LY']
                                  : 0.0,
                              "Current Year": scorecard.value != null
                                  ? scorecard.value['YTD_GPW']
                                  : 0.0,
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 85,
                              width: size.width * 0.5,
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(1, 2),
                                    color: Color.fromARGB(255, 220, 216, 216),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Countup(
                                    begin: 0,
                                    end: 132,
                                    duration: const Duration(seconds: 2),
                                    separator: ',',
                                    suffix: '%',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Loss Ratio',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 85,
                              width: size.width * 0.5,
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(1, 2),
                                    color: Color.fromARGB(255, 220, 216, 216),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Countup(
                                    begin: 0,
                                    end: 78,
                                    duration: const Duration(seconds: 2),
                                    separator: ',',
                                    suffix: '%',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Paid Premium Ratio',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 15),
                  // agentIncentives(
                  //   context,
                  //   title: "Agent Incentives",
                  //   description:
                  //       "You've already achieved 70% of your goal incentive's.",
                  //   progress: 70.0,
                  //   qouta: 100.0,
                  // ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "FPG Products",
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(height: 1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: getValueForScreenType<double>(
                          context: context,
                          mobile: 180,
                          tablet: 420,
                        ),
                        width: double.infinity,
                        child: slider.CarouselSlider(
                          items: dataList
                              .map(
                                (item) => carouselCard(
                                  context: context,
                                  data: item,
                                  onTap: () {
                                    if (item.title == 'Motor') {
                                      Get.to(
                                        () => const Productmotor(),
                                      );
                                    } else {
                                      Get.to(
                                        () => const TravelView(),
                                      );
                                    }
                                  },
                                ),
                              )
                              .toList(),
                          options: slider.CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            aspectRatio: 2.0,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              currentProduct.value = index;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dataList.asMap().entries.map((entry) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentProduct.value == entry.key ? 12 : 8,
                            height: currentProduct.value == entry.key ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentProduct.value == entry.key
                                  ? ColorPalette.primaryColor
                                  : ColorPalette.primaryColor.withOpacity(0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
  }

  Widget agentGraph(context, {String? label, Map<String, double>? dataMap}) {
    return Column(
      children: [
        PieChart(
          dataMap: dataMap!,
          colorList: const [
            Color.fromARGB(255, 207, 207, 207),
            Color(0xfffe5000),
          ],
          chartType: ChartType.ring,
          chartRadius: 80,
          // centerText: label,
          baseChartColor: ColorPalette.primaryColor,
          emptyColor: ColorPalette.greyLight,
          centerTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 10.0,
            fontFamily: 'OpenSans',
          ),
          ringStrokeWidth: 12,
          animationDuration: const Duration(seconds: 2),
          chartValuesOptions: const ChartValuesOptions(
            showChartValues: true,
            showChartValuesOutside: true,
            showChartValuesInPercentage: true,
            showChartValueBackground: false,
            chartValueStyle: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          legendOptions: const LegendOptions(
            showLegends: false,
            legendPosition: LegendPosition.left,
            showLegendsInRow: true,
          ),
        ),
        LayoutBuilder(builder: (context, constraints) {
          // Check if the screen is narrow (adjust the width threshold as needed)
          bool isSmallScreen = constraints.maxWidth < 150;

          return isSmallScreen
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        const Text(
                          ' Current Year',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette.greyLight,
                          ),
                        ),
                        const Text(
                          ' Last Year',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          const Text(
                            ' Current Year',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.greyLight,
                            ),
                          ),
                          const Text(
                            ' Last Year',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        }),
        const SizedBox(height: 10),
        Text(
          label ?? '',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget agentIncentives(
    context, {
    String? title,
    String? description,
    double? progress,
    required double qouta,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 1.0),
        Text(
          title ?? '',
          textAlign: TextAlign.center,
          strutStyle: const StrutStyle(height: 1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 1.0),
        PreferredSize(
          preferredSize: Size.zero,
          child: Text(
            description ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: LinearProgressIndicator(
            value: (progress ?? 0.0) / qouta,
            backgroundColor: const Color.fromARGB(255, 228, 228, 228),
            color: const Color.fromARGB(255, 193, 192, 192),
            borderRadius: BorderRadius.circular(20),
            minHeight: 15.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
        Text("$progress / $qouta"),
      ],
    );
  }

  Widget carouselCard({
    required BuildContext context,
    required DataModel data,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Hero(
        tag: data.imageName,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(
                  data.imageName,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get/get.dart';
// import 'package:mssql_connection/mssql_connection.dart';
// import 'package:pie_chart/pie_chart.dart';
// import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
// import 'package:simone/src/features/authentication/models/models.dart';
// import 'package:simone/src/features/authentication/models/user_model.dart';
// import 'package:simone/src/features/authentication/screens/companyinformation/products/productmotor/productmotor.dart';
// import 'package:intl/intl.dart';
// import 'package:simone/src/utils/colorpalette.dart';

// // ignore: must_be_immutable
// class Dashboard extends HookWidget {
//   Dashboard({super.key});

//   Map<String, double> dataMap = {
//     "Last Year": 20.3,
//     "Current Year": 79.7,
//   };
//   Map<String, double> dataMap1 = {
//     "Last Year": 35.2,
//     "Current Year": 65.3,
//   };
//   Map<String, double> dataMap2 = {
//     "Last Year": 45.2,
//     "Current Year": 55.3,
//   };

//   List<Color> colorList = [
//     const Color.fromARGB(255, 207, 207, 207),
//     const Color(0xfffe5000),
//   ];

//   final _sqlConnection = MssqlConnection.getInstance();

//   @override
//   Widget build(BuildContext context) {
//     ValueNotifier<DateTime> nowDate = useState(DateTime.now());
//     ValueNotifier<String> startDate = useState('');
//     ValueNotifier<String> endDate = useState('');
//     ValueNotifier<String> year = useState('');

//     ValueNotifier<bool> isLoading = useState(false);
//     ValueNotifier<int> currentProduct = useState(0);
//     PageController pageController = usePageController(
//       initialPage: 0,
//       viewportFraction: 0.8,
//     );
//     var profileController = Get.put(ProfileController());
//     ValueNotifier<UserModel?> profile = useState(null);
//     ValueNotifier<dynamic> scorecard = useState(null);

//     scorecardData() async {
//       final controller = Get.put(ProfileController());
//       var userData = await controller.getUserData();
//       String query = """
//         SELECT sum(MTD_GPW) AS MTD_GPW,
//         sum(MTD_LY) AS MTD_LY,
//         SUM(MTD_GROWTH_RATE) AS MTD_GROWTH_RATE,
//         sum(YTD_GPW) AS YTD_GPW,
//         sum(YTD_LY) AS YTD_LY,
//         SUM(YTD_GROWTH_RATE) AS YTD_GROWTH_RATE,
//         SUM(LOSSES_INCURRED) AS LOSSES_INCURRED,
//         SUM(LOSS_RATIO) AS LOSS_RATIO,
//         SUM(PAID_PREMIUM) AS PAID_PREMIUM,
//         SUM(PAID_PREMIUM_RATIO) AS PAID_PREMIUM_RATIO
//         FROM TEMP_VEN_DATA
//         WHERE new_source_id = '${userData?.agentCode ?? ''}'
//         GROUP BY new_source_id
//       """;

//       String result = await _sqlConnection.getData(query);
//       return jsonDecode(result)[0];
//     }

//     useEffect(() {
//       isLoading.value = true;

//       var offset = nowDate.value.day - 15;
//       var startDay = 1;
//       var endDay = 15;
//       if (offset >= 15) {
//         startDay = 16;
//         endDay = 0;
//       }
//       startDate.value = DateFormat('MMMM d')
//           .format(DateTime(nowDate.value.year, nowDate.value.month, startDay));
//       endDate.value = DateFormat('MMMM d')
//           .format(DateTime(nowDate.value.year, nowDate.value.month, endDay));
//       year.value = DateFormat('y')
//           .format(DateTime(nowDate.value.year, nowDate.value.month, startDay));

//       asyncing() async {
//         profile.value = await profileController.getUserData();
//         scorecard.value = await scorecardData();
//       }

//       asyncing();

//       isLoading.value = false;
//       return null;
//     }, []);

//     return isLoading.value
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     height: 130.0,
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: const [
//                         BoxShadow(
//                           offset: Offset(1, 2),
//                           color: Color.fromARGB(255, 220, 216, 216),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Agent Scorecard",
//                           style: TextStyle(
//                             fontFamily: 'OpenSans',
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 10),
//                         const SizedBox(height: 20),
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Branch'),
//                             Text(
//                               'Alabang',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Intermediary'),
//                             Text(
//                               profile.value?.fullName ?? '',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     height: 170.0,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: const [
//                         BoxShadow(
//                           offset: Offset(1, 2),
//                           color: Color.fromARGB(255, 220, 216, 216),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 3, horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).primaryColor,
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(8)),
//                           ),
//                           child: Text(
//                             "Period ${startDate.value} to ${endDate.value}, ${year.value}",
//                             style: const TextStyle(color: Colors.white),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             agentGraph(
//                               context,
//                               label: 'Loss Ratio',
//                               dataMap: {
//                                 "Last Year": 0.0,
//                                 "Current Year": 0.0,
//                               },
//                             ),
//                             agentGraph(
//                               context,
//                               label: 'Growth Rate',
//                               dataMap: {
//                                 "Last Year": scorecard.value != null
//                                     ? scorecard.value['YTD_LY']
//                                     : 0.0,
//                                 "Current Year": scorecard.value != null
//                                     ? scorecard.value['YTD_GPW']
//                                     : 0.0,
//                               },
//                             ),
//                             agentGraph(
//                               context,
//                               label: 'Paid Premium\nRatio',
//                               dataMap: {
//                                 "Last Year": 0.0,
//                                 "Current Year": 0.0,
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   agentIncentives(
//                     context,
//                     title: "Agent Incentives",
//                     description:
//                         "You've already achieved 70% of your goal incentive's.",
//                     progress: 70.0,
//                     qouta: 100.0,
//                   ),
//                   const SizedBox(height: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const SizedBox(height: 5.0),
//                       const Text(
//                         "FPG Products",
//                         textAlign: TextAlign.center,
//                         strutStyle: StrutStyle(height: 1),
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       AspectRatio(
//                         aspectRatio: 9 / 4,
//                         child: PageView.builder(
//                           itemCount: dataList.length,
//                           physics: const ClampingScrollPhysics(),
//                           controller: pageController,
//                           onPageChanged: (value) {
//                             currentProduct.value = value;
//                           },
//                           itemBuilder: (context, index) {
//                             return AnimatedBuilder(
//                               animation: pageController,
//                               builder: (context, child) {
//                                 return carouselCard(context, dataList[index]);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: dataList.asMap().entries.map((entry) {
//                           return Container(
//                             width: 10,
//                             height: 10,
//                             margin: const EdgeInsets.symmetric(
//                               vertical: 8.0,
//                               horizontal: 4.0,
//                             ),
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: (Theme.of(context).brightness ==
//                                             Brightness.dark
//                                         ? Colors.white
//                                         : ColorPalette.primaryColor)
//                                     .withOpacity(
//                                         currentProduct.value == entry.key
//                                             ? 0.9
//                                             : 0.4)),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }

//   Widget agentGraph(context, {String? label, Map<String, double>? dataMap}) {
//     return Expanded(
//       child: PieChart(
//         dataMap: dataMap!,
//         colorList: colorList,
//         chartType: ChartType.ring,
//         chartRadius: MediaQuery.of(context).size.width / 5.0,
//         centerText: label,
//         centerTextStyle: const TextStyle(
//           color: Colors.black,
//           fontSize: 10.0,
//           fontFamily: 'OpenSans',
//         ),
//         ringStrokeWidth: 10,
//         animationDuration: const Duration(seconds: 2),
//         chartValuesOptions: const ChartValuesOptions(
//           showChartValues: true,
//           showChartValuesOutside: true,
//           showChartValuesInPercentage: true,
//           showChartValueBackground: false,
//         ),
//         legendOptions: const LegendOptions(
//           showLegends: false,
//           legendPosition: LegendPosition.left,
//           showLegendsInRow: true,
//         ),
//       ),
//     );
//   }

//   Widget agentIncentives(context,
//       {String? title,
//       String? description,
//       double? progress,
//       required double qouta}) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const SizedBox(height: 1.0),
//         Text(
//           title ?? '',
//           textAlign: TextAlign.center,
//           strutStyle: const StrutStyle(height: 1),
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         const SizedBox(height: 1.0),
//         PreferredSize(
//           preferredSize: Size.zero,
//           child: Text(
//             description ?? '',
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10.0),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 50),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: LinearProgressIndicator(
//             value: (progress ?? 0.0) / qouta,
//             backgroundColor: const Color.fromARGB(255, 228, 228, 228),
//             color: const Color.fromARGB(255, 193, 192, 192),
//             borderRadius: BorderRadius.circular(20),
//             minHeight: 15.0,
//             valueColor: AlwaysStoppedAnimation<Color>(
//               Theme.of(context).primaryColor,
//             ),
//           ),
//         ),
//         Text("$progress / $qouta"),
//       ],
//     );
//   }

//   Widget carouselCard(context, DataModel data) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Hero(
//               tag: data.imageName,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const Productmotor()),
//                   );
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     image: DecorationImage(
//                       image: AssetImage(
//                         data.imageName,
//                       ),
//                       fit: BoxFit.fitWidth,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

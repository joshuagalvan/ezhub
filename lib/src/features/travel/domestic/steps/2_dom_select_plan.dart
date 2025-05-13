import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/extensions.dart';

class DomesticTravelPlan extends HookWidget {
  const DomesticTravelPlan({
    super.key,
    required this.domData,
  });

  final ValueNotifier<TravelModel> domData;

  @override
  Widget build(BuildContext context) {
    final selectedPlan = useState<String>('');
    final selectedPlanId = useState<String>('');
    final plan1Benefits = useState([]);
    final plan2Benefits = useState([]);
    final plan3Benefits = useState([]);
    final plan4Benefits = useState([]);
    final plan5Benefits = useState([]);
    ValueNotifier<String> lgtRate = useState('');
    ValueNotifier<String> premiumBreakdownPlan1 = useState('');
    ValueNotifier<String> premiumBreakdownPlan2 = useState('');
    ValueNotifier<String> premiumBreakdownPlan3 = useState('');
    ValueNotifier<String> premiumBreakdownPlan4 = useState('');
    ValueNotifier<String> premiumBreakdownPlan5 = useState('');
    final isLoading = useState(true);

    Future<void> getPlan1() async {
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPlanCoverage_json/?line=domestic&account=PESO&covid=0&plan_id=4&bdate=4/5/1997'));
        var result = (jsonDecode(response.body)['result']);
        final data = (result as List).toList();
        plan1Benefits.value = data;
      } catch (_) {}
    }

    Future<void> getPlan2() async {
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPlanCoverage_json/?line=domestic&account=PESO&covid=0&plan_id=5&bdate=4/5/1997'));
        var result = (jsonDecode(response.body)['result']);
        final data = (result as List).toList();
        plan2Benefits.value = data;
      } catch (_) {}
    }

    Future<void> getPlan3() async {
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPlanCoverage_json/?line=domestic&account=PESO&covid=0&plan_id=6&bdate=4/5/1997'));
        var result = (jsonDecode(response.body)['result']);
        final data = (result as List).toList();
        plan3Benefits.value = data;
      } catch (_) {}
    }

    Future<void> getPlan4() async {
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPlanCoverage_json/?line=domestic&account=PESO&covid=0&plan_id=7&bdate=4/5/1997'));
        var result = (jsonDecode(response.body)['result']);
        final data = (result as List).toList();
        plan4Benefits.value = data;
      } catch (_) {}
    }

    Future<void> getPlan5() async {
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPlanCoverage_json/?line=domestic&account=PESO&covid=0&plan_id=8&bdate=4/5/1997'));
        var result = (jsonDecode(response.body)['result']);
        final data = (result as List).toList();
        plan5Benefits.value = data;
      } catch (_) {}
    }

    Future<void> getBranch() async {
      final storage = GetStorage();
      final branchData = await storage.read('branch');

      if (branchData != null) {
        lgtRate.value = (branchData['locTax']).toString();
      }
    }

    Future<void> getPremiumPlan1() async {
      final from = DateTime.parse('${domData.value.departFrom}');
      final to = DateTime.parse('${domData.value.arriveIn}');
      final travelDays = to.difference(from).inDays + 1;
      domData.value = domData.value.copyWith(
        totalTravelDays: travelDays.toString(),
      );
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=domestic&plan_id=4&account=PESO&covid_protection=0&lgt_rate=${lgtRate.value}&bdate=4/5/1997&travel_destination=&travel_days=$travelDays'));
        var result = (jsonDecode(response.body));
        premiumBreakdownPlan1.value = result['total_premium'];
      } catch (_) {}
    }

    Future<void> getPremiumPlan2() async {
      final from = DateTime.parse('${domData.value.departFrom}');
      final to = DateTime.parse('${domData.value.arriveIn}');
      final travelDays = to.difference(from).inDays + 1;
      domData.value = domData.value.copyWith(
        totalTravelDays: travelDays.toString(),
      );
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=domestic&plan_id=5&account=PESO&covid_protection=0&lgt_rate=${lgtRate.value}&bdate=4/5/1997&travel_destination=&travel_days=$travelDays'));
        var result = (jsonDecode(response.body));
        premiumBreakdownPlan2.value = result['total_premium'];
      } catch (_) {}
    }

    Future<void> getPremiumPlan3() async {
      final from = DateTime.parse('${domData.value.departFrom}');
      final to = DateTime.parse('${domData.value.arriveIn}');
      final travelDays = to.difference(from).inDays + 1;
      domData.value = domData.value.copyWith(
        totalTravelDays: travelDays.toString(),
      );
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=domestic&plan_id=6&account=PESO&covid_protection=0&lgt_rate=${lgtRate.value}&bdate=4/5/1997&travel_destination=&travel_days=$travelDays'));
        var result = (jsonDecode(response.body));
        premiumBreakdownPlan3.value = result['total_premium'];
      } catch (_) {}
    }

    Future<void> getPremiumPlan4() async {
      final from = DateTime.parse('${domData.value.departFrom}');
      final to = DateTime.parse('${domData.value.arriveIn}');
      final travelDays = to.difference(from).inDays + 1;
      domData.value = domData.value.copyWith(
        totalTravelDays: travelDays.toString(),
      );
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=domestic&plan_id=7&account=PESO&covid_protection=0&lgt_rate=${lgtRate.value}&bdate=4/5/1997&travel_destination=&travel_days=$travelDays'));
        var result = (jsonDecode(response.body));
        premiumBreakdownPlan4.value = result['total_premium'];
      } catch (_) {}
    }

    Future<void> getPremiumPlan5() async {
      final from = DateTime.parse('${domData.value.departFrom}');
      final to = DateTime.parse('${domData.value.arriveIn}');
      final travelDays = to.difference(from).inDays + 1;
      domData.value = domData.value.copyWith(
        totalTravelDays: travelDays.toString(),
      );
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=domestic&plan_id=8&account=PESO&covid_protection=0&lgt_rate=${lgtRate.value}&bdate=4/5/1997&travel_destination=&travel_days=$travelDays'));
        var result = (jsonDecode(response.body));
        premiumBreakdownPlan5.value = result['total_premium'];
        isLoading.value = false;
      } catch (_) {}
    }

    useEffect(() {
      async() async {
        await getPlan1();
        await getPlan2();
        await getPlan3();
        await getPlan4();
        await getPlan5();
        await getBranch();
        await getPremiumPlan1();
        await getPremiumPlan2();
        await getPremiumPlan3();
        await getPremiumPlan4();
        await getPremiumPlan5();
      }

      async();
      return null;
    }, []);

    return isLoading.value
        ? const Center(
            child: SpinKitChasingDots(
              color: ColorPalette.primaryColor,
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  selectedPlan.value != ''
                      ? 'YOU HAVE SELECTED'
                      : 'YOU HAVE NOT SELECTED A PLAN',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (selectedPlan.value != '')
                  Text(
                    selectedPlan.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                Accordion(
                  headerBorderColor: Colors.blueGrey,
                  headerBorderColorOpened: Colors.transparent,
                  headerBackgroundColorOpened: ColorPalette.primaryColor,
                  contentBackgroundColor: Colors.white,
                  contentBorderColor: ColorPalette.primaryColor,
                  contentBorderWidth: 3,
                  scaleWhenAnimating: true,
                  openAndCloseAnimation: true,
                  disableScrolling: true,
                  headerPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                  sectionClosingHapticFeedback: SectionHapticFeedback.light,
                  children: [
                    AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLAN 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PHP ${premiumBreakdownPlan1.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final benefits = plan1Benefits.value[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(benefits['name']),
                                  Text(
                                      '₱${jsonDecode(benefits['base_amount'])['PESO'].toString().formatWithCommas()}')
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: plan1Benefits.value.length,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selectedPlan.value == "PLAN 1"
                                  ? ColorPalette.primaryColor
                                  : Colors.white,
                            ),
                            onPressed: () async {
                              selectedPlan.value = "PLAN 1";
                              selectedPlanId.value = "4";
                              domData.value = domData.value.copyWith(
                                selectedPlan: selectedPlan.value,
                                selectedPlanId: selectedPlanId.value,
                              );
                            },
                            child: SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: selectedPlan.value == "PLAN 1"
                                        ? Colors.white
                                        : ColorPalette.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    selectedPlan.value == "PLAN 1"
                                        ? 'SELECTED PLAN'
                                        : 'SELECT PLAN',
                                    style: TextStyle(
                                      color: selectedPlan.value == "PLAN 1"
                                          ? Colors.white
                                          : ColorPalette.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLAN 2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PHP ${premiumBreakdownPlan2.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final benefits = plan2Benefits.value[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(benefits['name']),
                                  Text(
                                    '₱${jsonDecode(benefits['base_amount'])['PESO'].toString().formatWithCommas()}',
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: plan2Benefits.value.length,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selectedPlan.value == "PLAN 2"
                                  ? ColorPalette.primaryColor
                                  : Colors.white,
                            ),
                            onPressed: () async {
                              selectedPlan.value = "PLAN 2";
                              selectedPlanId.value = "5";
                              domData.value = domData.value.copyWith(
                                selectedPlan: selectedPlan.value,
                                selectedPlanId: selectedPlanId.value,
                              );
                            },
                            child: SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: selectedPlan.value == "PLAN 2"
                                        ? Colors.white
                                        : ColorPalette.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    selectedPlan.value == "PLAN 2"
                                        ? 'SELECTED PLAN'
                                        : 'SELECT PLAN',
                                    style: TextStyle(
                                      color: selectedPlan.value == "PLAN 2"
                                          ? Colors.white
                                          : ColorPalette.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLAN 3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PHP ${premiumBreakdownPlan3.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final benefits = plan3Benefits.value[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(benefits['name']),
                                  Text(
                                      '₱${jsonDecode(benefits['base_amount'])['PESO'].toString().formatWithCommas()}')
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: plan3Benefits.value.length,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selectedPlan.value == "PLAN 3"
                                  ? ColorPalette.primaryColor
                                  : Colors.white,
                            ),
                            onPressed: () async {
                              selectedPlan.value = "PLAN 3";
                              selectedPlanId.value = "6";
                              domData.value = domData.value.copyWith(
                                selectedPlan: selectedPlan.value,
                                selectedPlanId: selectedPlanId.value,
                              );
                            },
                            child: SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: selectedPlan.value == "PLAN 3"
                                        ? Colors.white
                                        : ColorPalette.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    selectedPlan.value == "PLAN 3"
                                        ? 'SELECTED PLAN'
                                        : 'SELECT PLAN',
                                    style: TextStyle(
                                      color: selectedPlan.value == "PLAN 3"
                                          ? Colors.white
                                          : ColorPalette.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLAN 4',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PHP ${premiumBreakdownPlan4.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final benefits = plan4Benefits.value[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(benefits['name']),
                                  Text(
                                    '₱${jsonDecode(benefits['base_amount'])['PESO'].toString().formatWithCommas()}',
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: plan4Benefits.value.length,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selectedPlan.value == "PLAN 4"
                                  ? ColorPalette.primaryColor
                                  : Colors.white,
                            ),
                            onPressed: () async {
                              selectedPlan.value = "PLAN 4";
                              selectedPlanId.value = "7";
                              domData.value = domData.value.copyWith(
                                selectedPlan: selectedPlan.value,
                                selectedPlanId: selectedPlanId.value,
                              );
                            },
                            child: SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: selectedPlan.value == "PLAN 4"
                                        ? Colors.white
                                        : ColorPalette.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    selectedPlan.value == "PLAN 4"
                                        ? 'SELECTED PLAN'
                                        : 'SELECT PLAN',
                                    style: TextStyle(
                                      color: selectedPlan.value == "PLAN 4"
                                          ? Colors.white
                                          : ColorPalette.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLAN 5',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PHP ${premiumBreakdownPlan5.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final benefits = plan5Benefits.value[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(benefits['name']),
                                  Text(
                                    '₱${jsonDecode(benefits['base_amount'])['PESO'].toString().formatWithCommas()}',
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: plan5Benefits.value.length,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selectedPlan.value == "PLAN 5"
                                  ? ColorPalette.primaryColor
                                  : Colors.white,
                            ),
                            onPressed: () async {
                              selectedPlan.value = "PLAN 5";
                              selectedPlanId.value = "8";
                              domData.value = domData.value.copyWith(
                                selectedPlan: selectedPlan.value,
                                selectedPlanId: selectedPlanId.value,
                              );
                            },
                            child: SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: selectedPlan.value == "PLAN 5"
                                        ? Colors.white
                                        : ColorPalette.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    selectedPlan.value == "PLAN 5"
                                        ? 'SELECTED PLAN'
                                        : 'SELECT PLAN',
                                    style: TextStyle(
                                      color: selectedPlan.value == "PLAN 5"
                                          ? Colors.white
                                          : ColorPalette.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

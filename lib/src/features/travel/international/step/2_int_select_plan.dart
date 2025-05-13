import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:simone/src/features/travel/controllers/travel_controller.dart';
import 'package:simone/src/features/travel/data/models/customized_model.dart';
import 'package:simone/src/features/travel/data/models/standard_model.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';

class InternationalSelectPlan extends StatefulHookWidget {
  const InternationalSelectPlan({
    super.key,
    required this.intData,
  });

  final ValueNotifier<TravelModel> intData;

  @override
  State<InternationalSelectPlan> createState() =>
      _InternationalSelectPlanState();
}

class _InternationalSelectPlanState extends State<InternationalSelectPlan> {
  final _scrollController = ScrollController();
  final controller = Get.put(TravelController());
  final planList = [
    {
      'id': "10",
      'name': 'Basic Plan',
      'amount': '₱500K',
      'desc': '',
    },
    {
      'id': "11",
      'name': 'Classic Plan',
      'amount': '₱1M',
      'desc': '',
    },
    {
      'id': "12",
      'name': 'Elite Plan',
      'amount': '₱2.5M',
      'desc': 'Schengen Accredited',
    },
    {
      'id': "13",
      'name': 'Prestige Plan',
      'amount': '₱5M',
      'desc': 'Schengen Accredited',
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToItem(int index) {
    const double itemHeight = 100;
    final double position = index * itemHeight;

    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlan = useState<String>("10");
    final travelDays = useState<String>("");
    final isLoading = useState<bool>(false);
    final listBenefitPlan = useState<StandardBenefitModel>(
        StandardBenefitModel(premium: 0.0, benefitList: []));
    final listCustomizedPlan = useState<List<CustomizedBenefitModel>>([]);
    final selectedBenefits = useState<Set<CustomizedBenefitModel>>({});
    final selectedLessOptOut = useState<Set<CustomizedBenefitModel>>({});

    final basicPremium = useState<double>(0.0);
    final lgt = useState<double>(0.0);
    final dst = useState<double>(0.0);
    final premiumTax = useState<double>(0.0);
    final totalBasicPremium = useState<double>(0.0);

    void getLessOptOutBenefits() {
      selectedLessOptOut.value = listCustomizedPlan.value
          .where((value) =>
              !selectedBenefits.value.contains(value) && value.isAddon == '0')
          .toList()
          .toSet();

      basicPremium.value = listBenefitPlan.value.premium +
          selectedBenefits.value.map((value) => value.amount).toList().fold(
              0.0,
              (previousValue, element) =>
                  previousValue + double.parse(element));
      lgt.value = double.parse((basicPremium.value *
              (double.parse(widget.intData.value.branchLocalTax ?? '0') / 100))
          .toString()
          .formatWithCommas());
      premiumTax.value = double.parse(
          (basicPremium.value * 0.02).toString().formatWithCommas());
      totalBasicPremium.value =
          basicPremium.value + lgt.value + dst.value + premiumTax.value;
      widget.intData.value = widget.intData.value.copyWith(
        selectedLessOptOut: selectedLessOptOut.value,
        basicPremium: basicPremium.value.toString().formatWithCommas(),
        lgt: lgt.value.toString(),
        dst: dst.value.toString(),
        premiumTax: premiumTax.value.toString(),
        totalPremium: totalBasicPremium.value.toString().formatWithCommas(),
      );
    }

    Future<void> getTravelDays() async {
      await Future.delayed(const Duration(milliseconds: 500));
      final from = DateTime.parse('${widget.intData.value.departFrom}');
      final to = DateTime.parse('${widget.intData.value.arriveIn}');
      final totalDays = to.difference(from).inDays + 1;
      travelDays.value = totalDays.toString();
      widget.intData.value = widget.intData.value.copyWith(
        totalTravelDays: travelDays.value,
      );
    }

    Future<void> getStandardBenefitList() async {
      final result = await controller.getStandardBenefits(
        planId: planList.firstWhere(
                (plan) => (plan['id'] as String) == selectedPlan.value)['id'] ??
            '10',
        travelDays: travelDays.value,
        userType: widget.intData.value.travelAs?.toUpperCase() ?? '',
        withCovid: widget.intData.value.withCovid ?? '',
      );
      listBenefitPlan.value = result;
    }

    Future<void> getCustomizedBenefitList() async {
      final result = await controller.getCustomizedBenefits(
        productPlan: planList.firstWhere(
                (plan) => (plan['id'] as String) == selectedPlan.value)['id'] ??
            '',
        travelDays: travelDays.value,
        userType: widget.intData.value.travelAs?.toUpperCase() ?? '',
      );
      listCustomizedPlan.value = result;
      selectedBenefits.value =
          result.where((value) => value.isDefault == '1').toList().toSet();

      //TOTAL PREMIUM COMPUTATION
      basicPremium.value = listBenefitPlan.value.premium +
          selectedBenefits.value.map((value) => value.amount).toList().fold(
              0.0,
              (previousValue, element) =>
                  previousValue + double.parse(element));
      lgt.value = double.parse((basicPremium.value *
              (double.parse(widget.intData.value.branchLocalTax ?? '0') / 100))
          .toString()
          .formatWithCommas());
      if (widget.intData.value.travelAs == 'Individual' &&
          selectedPlan.value == "10") {
        dst.value = 100;
      } else {
        dst.value = 200;
      }
      premiumTax.value = double.parse(
          (basicPremium.value * 0.02).toString().formatWithCommas());
      totalBasicPremium.value =
          basicPremium.value + lgt.value + dst.value + premiumTax.value;
      //SAVE TO MODEL
      final typeOfPlan =
          planList.firstWhere((value) => value['id'] == selectedPlan.value);
      widget.intData.value = widget.intData.value.copyWith(
        selectedLessOptOut: selectedLessOptOut.value,
        selectedAddOns: selectedBenefits.value,
        selectedPlanId: selectedPlan.value,
        selectedPlan: '${typeOfPlan['name']} ${typeOfPlan['amount']}',
        basicPremium: basicPremium.value.toString().formatWithCommas(),
        lgt: lgt.value.toString(),
        dst: dst.value.toString(),
        premiumTax: premiumTax.value.toString(),
        totalPremium: totalBasicPremium.value.toString().formatWithCommas(),
      );
      isLoading.value = false;
    }

    useEffect(() {
      async() async {
        isLoading.value = true;
        selectedPlan.value = widget.intData.value.selectedPlanId ?? '10';

        await getTravelDays();
        await getStandardBenefitList();
        await getCustomizedBenefitList();
      }

      async();
      return null;
    }, []);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: isLoading.value
          ? const Center(
              child: SpinKitChasingDots(
                color: ColorPalette.primaryColor,
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorPalette.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'FAMILY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: planList.length,
                    itemBuilder: (context, index) {
                      final plan = planList[index];
                      return GestureDetector(
                        onTap: () async {
                          selectedPlan.value = plan['id']!;
                          widget.intData.value = widget.intData.value
                              .copyWith(selectedPlanId: selectedPlan.value);
                          await getStandardBenefitList();
                          await getCustomizedBenefitList();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedPlan.value == plan['id']
                                ? ColorPalette.primaryColor
                                : Colors.white,
                            border: Border.all(
                              color: selectedPlan.value == plan['id']
                                  ? Colors.white
                                  : ColorPalette.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${plan['name']}",
                                style: TextStyle(
                                  color: selectedPlan.value == plan['id']
                                      ? Colors.white
                                      : ColorPalette.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${plan['amount']}",
                                style: TextStyle(
                                  color: selectedPlan.value == plan['id']
                                      ? Colors.white
                                      : ColorPalette.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              if (plan['desc'] != '')
                                Text(
                                  "${plan['desc']}",
                                  style: TextStyle(
                                    color: selectedPlan.value == plan['id']
                                        ? Colors.white
                                        : ColorPalette.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Accordion(
                    headerBorderColor: Colors.blueGrey,
                    headerBorderColorOpened: Colors.transparent,
                    contentBackgroundColor: Colors.white,
                    contentBorderColor: ColorPalette.primaryColor,
                    contentBorderWidth: 3,
                    scaleWhenAnimating: false,
                    openAndCloseAnimation: false,
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
                        header: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Standard Benefits',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Essential benefits that are fixed and included in every plan.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        content: ListView.separated(
                          shrinkWrap: true,
                          itemCount: listBenefitPlan.value.benefitList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final benefit =
                                listBenefitPlan.value.benefitList[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: Text(benefit.name)),
                                Flexible(
                                  child: Text(
                                    '₱${jsonDecode(benefit.baseAmount)['PESO'].toString().formatWithCommas()}',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      AccordionSection(
                        isOpen: true,
                        contentVerticalPadding: 20,
                        leftIcon: const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                        ),
                        header: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customizable Benefits',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Customized your coverage by adding or removing benefits based on your travel preference.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        content: ListView.separated(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: listCustomizedPlan.value.length,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final benefit = listCustomizedPlan.value[index];

                            return IgnorePointer(
                              ignoring: benefit.isAddon == '1',
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: selectedBenefits.value
                                              .contains(benefit),
                                          onChanged: (value) async {
                                            setState(() {
                                              if (value == true) {
                                                selectedBenefits.value
                                                    .add(benefit);
                                              } else {
                                                selectedBenefits.value
                                                    .remove(benefit);
                                              }
                                              getLessOptOutBenefits();
                                            });

                                            await Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              scrollToItem(index);
                                            });
                                          },
                                          side: BorderSide(
                                            color: benefit.isAddon == '1'
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            benefit.name,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: benefit.isAddon == '1'
                                                  ? Colors.grey
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      benefit.limits,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: benefit.isAddon == '1'
                                            ? Colors.grey
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

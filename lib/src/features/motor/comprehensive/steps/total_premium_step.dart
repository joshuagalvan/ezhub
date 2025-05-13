import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:simone/src/models/policy.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';

class TotalPremiumStep extends HookWidget {
  const TotalPremiumStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;
  @override
  Widget build(BuildContext context) {
    final List<String> clauses = [
      "Accessories Clause",
      "Auto Personal Accident Endorsement",
      "Airbag Clause",
      "Aluminum Van Clause",
      "Deductible Clause",
      "Dealer or Casa Repair Shop Clause (for Units 5 years old & below), subject to Standard Depreciation",
      "Importation Clause (for imported cars)",
      "Pair and Set Endorsement",
      "Mortgagee Clause (if applicable)",
      "Terrorism and Sabotage Exclusion Clause",
      "Electronic data Recognition Exclusion Clause",
      "Total Asbestos Exclusion Clause",
      "Communicable Disease Exclusion (LMA5394)",
      "Property Cyber and Data Exclusion Clause",
      "Coronavirus Exclusion",
      "Sanction Limitation and Exclusion Clause",
    ];

    final ownDamage = useState<double>(0.0);
    final actOfNature = useState<double>(0.0);
    final basicPremium = useState<double>(0.0);
    final docStamp = useState<double>(0.0);
    final vat = useState<double>(0.0);
    final lVat = useState<double>(0.0);
    final localTax = useState<double>(0.0);
    final totalPrem = useState<double>(0.0);

    Future<String> getTotalPremium() async {
      final controller = Get.put(ProfileController());
      var data = await controller.getBranch();
      localTax.value = data['locTax'];

      ownDamage.value = double.parse(policy.value.ownDamageRate ?? '') *
          double.parse(policy.value.fairMarketValue ?? '');

      actOfNature.value = double.parse(policy.value.actOfNatureRate ?? '') *
          double.parse(policy.value.fairMarketValue ?? '');

      basicPremium.value = ownDamage.value +
          actOfNature.value +
          double.parse(policy.value.vtplbiRate ?? '0') +
          double.parse(policy.value.vtplpdRate ?? '0');

      docStamp.value = ((basicPremium.value / 4).ceil()) * .5;
      vat.value = basicPremium.value * 0.12;
      lVat.value = (localTax.value * basicPremium.value) / 100;
      totalPrem.value =
          basicPremium.value + docStamp.value + vat.value + lVat.value;
      policy.value = policy.value.copyWith(
        basicPremium: basicPremium.value.toString(),
        docStamp: docStamp.value.toString(),
        actOfNatureAmount: actOfNature.value.toString(),
        ownDamageAmount: ownDamage.value.toString(),
      );
      updatePolicy(policy.value);
      return '0.0';
    }

    useEffect(() {
      asyncFunction() async {
        await getTotalPremium();
      }

      asyncFunction();
      return null;
    }, []);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 2,
                      color: Colors.grey[200]!,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Total Premium',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '₱${totalPrem.value.toStringAsFixed(2).formatWithCommas()}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const Divider(),
                    const Text(
                      'Premium Breakdown',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _rowTextData(
                      title: 'Basic Premium',
                      data:
                          '₱${basicPremium.value.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Documentary Stamps',
                      data:
                          '₱${docStamp.value.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Value Added Tax',
                      data:
                          '₱${vat.value.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Local Tax',
                      data:
                          '₱${lVat.value.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    const Divider(),
                    const Text(
                      'Benefits',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _rowTextData(
                      title: 'Own Damage/Theft',
                      data:
                          '₱${ownDamage.value.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Act of Nature',
                      data:
                          '₱${actOfNature.value.toStringAsFixed(2).formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'RSCC',
                      data: 'INCLUDED',
                    ),
                    _rowTextData(
                      title: 'VTPL - Bodily Injury',
                      data:
                          '₱${policy.value.vtplbiRate.toString().formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'VTPL - Property Damage',
                      data:
                          '₱${policy.value.vtplpdRate.toString().formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Auto Personal Accident',
                      data: 'INCLUDED',
                    ),
                  ],
                ),
              ),
            ),
            Accordion(
              headerBorderColor: Colors.blueGrey,
              headerBorderColorOpened: Colors.transparent,
              headerBackgroundColorOpened: ColorPalette.primaryColor,
              contentBackgroundColor: Colors.white,
              contentBorderColor: ColorPalette.primaryColor,
              contentBorderWidth: 3,
              contentHorizontalPadding: 20,
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
                  contentVerticalPadding: 20,
                  leftIcon: const Icon(
                    Icons.text_fields_rounded,
                    color: Colors.white,
                  ),
                  header: const Text(
                    'Warranties and Clauses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clauses.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                clauses[index],
                                style: const TextStyle(fontSize: 14),
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

  Widget _rowTextData({required String title, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15.0,
                fontFamily: 'OpenSans',
                color: Color(0xfffe5000),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:simone/src/utils/extensions.dart';

class CTPLTotalPremiumStep extends HookWidget {
  const CTPLTotalPremiumStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
  });

  final ValueNotifier<CTPLPolicy> policy;
  final Function(CTPLPolicy) updatePolicy;
  @override
  Widget build(BuildContext context) {
    // final List<String> clauses = [
    //   "Accessories Clause",
    //   "Auto Personal Accident Endorsement",
    //   "Airbag Clause",
    //   "Aluminum Van Clause",
    //   "Deductible Clause",
    //   "Dealer or Casa Repair Shop Clause (for Units 5 years old & below), subject to Standard Depreciation",
    //   "Importation Clause (for imported cars)",
    //   "Pair and Set Endorsement",
    //   "Mortgagee Clause (if applicable)",
    //   "Terrorism and Sabotage Exclusion Clause",
    //   "Electronic data Recognition Exclusion Clause",
    //   "Total Asbestos Exclusion Clause",
    //   "Communicable Disease Exclusion (LMA5394)",
    //   "Property Cyber and Data Exclusion Clause",
    //   "Coronavirus Exclusion",
    //   "Sanction Limitation and Exclusion Clause",
    // ];

    // final basicPremium = useState<double>(0.0);
    // final docStamp = useState<double>(0.0);
    // final lVat = useState<double>(0.0);
    // final totalPrem = useState<double>(0.0);

    useEffect(() {
      asyncFunction() async {
        // await getTotalPremium();
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
                padding: const EdgeInsets.all(defaultSize),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 244, 238),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        totalPremium,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '₱${policy.value.totalPremium.toString().formatWithCommas()}',
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
                      premBreak,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _rowTextData(
                      title: 'Basic Premium',
                      data: policy.value.basicPremium
                          .toString()
                          .formatWithCommas(),
                    ),
                    // _rowTextData(
                    //   title: 'Local Tax Rate',
                    //   data: '$locTax%',
                    // ),
                    _rowTextData(
                      title: 'Documentary Stamps',
                      data: '₱${policy.value.dst}',
                    ),
                    _rowTextData(
                      title: 'Value Added Tax',
                      data: '₱${policy.value.vat!.formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'Local Tax (${policy.value.locTaxRate}%)',
                      data: '₱${policy.value.lgt!.formatWithCommas()}',
                    ),
                    _rowTextData(
                      title: 'LTO Interconnectivity',
                      data: '₱${policy.value.lto!.formatWithCommas()}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // const Divider(),
            // CheckboxListTile(
            //   controlAffinity: ListTileControlAffinity.leading,
            //   title: const Text(
            //     "I have read and understood and voluntarily agreed to the collection, use, and disclosure of my personal data in accordance with FPG Privacy Policy.",
            //     style: TextStyle(
            //       fontSize: 12,
            //     ),
            //   ),
            //   value: isChecked,
            //   onChanged: (bool? newBool) {
            //     setState(() {
            //       isChecked = newBool ?? false;
            //     });
            //   },
            // ),

            // Accordion(
            //   headerBorderColor: Colors.blueGrey,
            //   headerBorderColorOpened: Colors.transparent,
            //   headerBackgroundColorOpened: ColorPalette.primaryColor,
            //   contentBackgroundColor: Colors.white,
            //   contentBorderColor: ColorPalette.primaryColor,
            //   contentBorderWidth: 3,
            //   contentHorizontalPadding: 20,
            //   scaleWhenAnimating: true,
            //   openAndCloseAnimation: true,
            //   disableScrolling: true,
            //   headerPadding: const EdgeInsets.symmetric(
            //     vertical: 15,
            //     horizontal: 15,
            //   ),
            //   sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            //   sectionClosingHapticFeedback: SectionHapticFeedback.light,
            //   children: [
            //     AccordionSection(
            //       isOpen: false,
            //       contentVerticalPadding: 20,
            //       leftIcon: const Icon(
            //         Icons.text_fields_rounded,
            //         color: Colors.white,
            //       ),
            //       header: const Text(
            //         'Warranties and Clauses',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       content: ListView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: clauses.length,
            //         itemBuilder: (context, index) {
            //           return Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 2),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text(
            //                   "• ",
            //                   style: TextStyle(fontSize: 18),
            //                 ),
            //                 Expanded(
            //                   child: Text(
            //                     clauses[index],
            //                     style: const TextStyle(fontSize: 14),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // ),
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/utils/colorpalette.dart';

class Declaration extends StatefulHookWidget {
  const Declaration({
    super.key,
    required this.onTermsChecked,
    required this.onPromotionalChecked,
  });

  final Function(bool) onTermsChecked;
  final Function(bool) onPromotionalChecked;
  @override
  State<Declaration> createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration> {
  final declarationList = [
    "1. All persons to be insured understand that all pre-existing medical conditions are not covered under all FPG Insurance Travel Insurance plan.",
    "2. ll persons to be insured are in good health and free from physical defects and are not not traveling against the advice of any doctor or for the purpose of obtaining medical treatment.",
    "3. Travel itinerary to be insured will start and end in the Philippines.",
    "4. None of the persons intended to be insured have already left the Philippines on any trip meant to be covered by the insurance policy. I / we understand that an insured person is not covered for the entire trip if they leave the Philippines before the start of the period of insurance coverage.",
    "5. All persons to be insured have not been refused cover or imposed special terms for travel insurance by any insurer.",
    "6. None of the persons intending to be insured are aware of any circumstances which are likely to lead to a claim under the policy.",
    "7. Any insured person under the age of 12 years old must be accompanied by a parent or adult guardian during the trip.",
    "8. The country of residence of all persons to be insured is the Philippines.",
    "9. All persons to be insured have authorized me to complete the Application Form on their behalf.",
    "10. The information given are true and correct to the best of my knowledge and I have not withheld any fact likely to influence FPG Insurance's assessment of the Application.",
    "11. I accept the terms, conditions, and exclusions, contained in the Policy and that this Declaration and other information provided shall form the basis of the contract.",
    "12. I understand and accept that my personal particulars will be collected, used, disclosed, and kept under FPG Insurance’s Privacy Policy for the provision of all related services herein.",
    "13. FPG may also disclose my personal information to its business partners and third party service providers for the purpose of the delivery of services",
    "14. When there are more than one persons insured, I confirm that they have also consented to FPG Insurance's collection, use, disclosure, and storage of their personal information",
    "15. For more details, please refer to the FPG Insurance Privacy Policy.",
  ];
  bool isTermsChecked = false;
  bool isPromotionalChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 244, 238),
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
                  children: [
                    const Center(
                      child: Text(
                        'Declaration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    ),
                    const Text(
                        'On behalf of all persons applied to be insured, I hereby agree / declare that:'),
                    const SizedBox(height: 20),
                    ListView.separated(
                      itemCount: declarationList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return Text(declarationList[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                        "Full details of the terms, conditions, and exclusions of this insurance coverage are provided in the Policy, and will be sent to you upon acceptance of your Application by FPG Insurance."),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text(
                        "I AGREE TO THE DECLARATION INCLUDING THE TERMS, CONDITIONS, AND EXCLUSIONS.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      value: isTermsChecked,
                      onChanged: (newBool) {
                        widget.onTermsChecked(newBool ?? false);

                        setState(() {
                          isTermsChecked = newBool ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text(
                        """
      I confirm that I am purchasing this travel insurance for myself or my family, and that all travelers are under 75 years of age on the date of travel.
      
      Note: For travelers aged above 75, please leave your details on our "Contact Us" page or call our Customer Care Hotline at (02) 8859 1200 so we can assist you on your purchase.""",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      value: isPromotionalChecked,
                      onChanged: (newBool) {
                        widget.onPromotionalChecked(newBool ?? false);

                        setState(() {
                          isPromotionalChecked = newBool ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

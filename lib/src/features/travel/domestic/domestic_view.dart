import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/components/stepper_container_form.dart';
import 'package:simone/src/components/stepper_page_view.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/features/travel/domestic/steps/1__dom_travel_details.dart';
import 'package:simone/src/features/travel/domestic/steps/2_dom_select_plan.dart';
import 'package:simone/src/features/travel/domestic/steps/3_dom_plan_details.dart';
import 'package:simone/src/features/travel/domestic/steps/4_dom_personal_details.dart';
import 'package:simone/src/features/travel/domestic/steps/5_declaration.dart';

import 'package:simone/src/components/basic_layout.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class TravelDomestic extends HookWidget {
  TravelDomestic({super.key});

  final List<GlobalKey<FormState>> forms = [
    GlobalKey<FormState>(), //0
    GlobalKey<FormState>(), //1
    GlobalKey<FormState>(), //2
    GlobalKey<FormState>(), //3
  ];

  @override
  Widget build(BuildContext context) {
    final domesticTravelPolicy = useState(TravelModel());
    final currentPage = useState(0);
    final pageIsLoading = useState(false);
    final isPersonalPrivacyChecked = useState(false);
    final isDeclarationTermsChecked = useState(false);
    final isDeclarationPromChecked = useState(false);

    useEffect(() {
      // policy.value = policyObj!;
      return null;
    }, []);

    pageIsLoading.value = false;
    return BasicLayout(
      title: 'Travel Domestic Insurance',
      child: StepperContainerForm(
        previous: () async {
          pageIsLoading.value = true;
          if (currentPage.value <= 0) {
            Navigator.of(context).pop();
          } else {
            currentPage.value--;
          }

          pageIsLoading.value = false;
          return currentPage.value;
        },
        next: currentPage.value == 5
            ? null
            : () async {
                if (currentPage.value == 0 &&
                    forms[0].currentState!.validate()) {
                  // Travel Details
                  if (domesticTravelPolicy.value.departFrom ==
                      domesticTravelPolicy.value.arriveIn) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Departure and Arrival cannot be the same.",
                      ),
                    );
                    return currentPage.value;
                  } else if (domesticTravelPolicy.value.provinces == null) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please select at least one province.",
                      ),
                    );
                    return currentPage.value;
                  } else {
                    currentPage.value++;
                    return currentPage.value;
                  }
                }

                if (currentPage.value == 1) {
                  if (domesticTravelPolicy.value.selectedPlan == null) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please select a plan",
                      ),
                    );
                    return currentPage.value;
                  } else {
                    currentPage.value++;
                    return currentPage.value;
                  }
                }
                if (currentPage.value == 2) {
                  currentPage.value++;
                  return currentPage.value;
                }

                if (currentPage.value == 3 &&
                    forms[1].currentState!.validate()) {
                  if (isPersonalPrivacyChecked.value == false) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please confirm the privacy policy ",
                      ),
                    );
                  } else {
                    currentPage.value++;
                  }

                  return currentPage.value;
                }

                if (currentPage.value == 4) {
                  if (isDeclarationTermsChecked.value == false) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please agree to the declaration terms",
                      ),
                    );
                  } else if (isDeclarationPromChecked.value == false) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please agree to the declaration promotion",
                      ),
                    );
                  } else {
                    currentPage.value++;
                  }

                  return currentPage.value;
                }

                return currentPage.value;
              },
        isLoading: () {
          return pageIsLoading.value;
        },
        steps: [
          StepperPageView(
            title: 'Travel Details',
            content: DomesticTravelDetails(
              form: forms[0],
              // onTermsChecked: (value) {
              //   isDetailsTermsChecked.value = value;
              // },
              domData: domesticTravelPolicy,
            ),
          ),
          StepperPageView(
            title: 'Select Plan',
            content: DomesticTravelPlan(
              domData: domesticTravelPolicy,
            ),
          ),
          StepperPageView(
            title: 'Plan Details',
            content: DomesticPlanDetails(
              domData: domesticTravelPolicy,
            ),
          ),
          StepperPageView(
            title: 'Personal Details',
            content: DomesticPersonalDetails(
              domData: domesticTravelPolicy,
              form: forms[1],
              onPrivacyChecked: (value) {
                isPersonalPrivacyChecked.value = value;
              },
            ),
          ),
          StepperPageView(
            title: 'Declaration',
            content: Declaration(
              onTermsChecked: (value) {
                isDeclarationTermsChecked.value = value;
              },
              onPromotionalChecked: (value) {
                isDeclarationPromChecked.value = value;
              },
            ),
          ),
          StepperPageView(
            title: 'Payment',
            content: Container(),
          ),
        ],
      ),
    );
  }
}

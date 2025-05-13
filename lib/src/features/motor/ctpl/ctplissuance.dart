import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/components/stepper_container_form.dart';
import 'package:simone/src/components/stepper_page_view.dart';
import 'package:simone/src/features/motor/ctpl/steps/1_ctpl_coverage.dart';
import 'package:simone/src/features/motor/ctpl/steps/2_vehicle_details.dart';
import 'package:simone/src/features/motor/ctpl/steps/3_profile_detail.dart';
import 'package:simone/src/features/motor/ctpl/steps/4_file_upload.dart';
import 'package:simone/src/features/motor/ctpl/steps/5_total_premium.dart';
import 'package:simone/src/features/motor/ctpl/steps/6_draft_policy.dart';

import 'package:simone/src/components/basic_layout.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class CTPLIssuanceForm extends HookWidget {
  CTPLIssuanceForm({super.key, required this.policyObj});
  CTPLPolicy policyObj;

  final List<GlobalKey<FormState>> forms = [
    GlobalKey<FormState>(), //0 ctpl coverage
    GlobalKey<FormState>(), //1 vehicle details
    GlobalKey<FormState>(), //2 profile
    GlobalKey<FormState>(), //3
  ];

  @override
  Widget build(BuildContext context) {
    final policy = useState(CTPLPolicy());
    final currentPage = useState(0);
    final pageIsLoading = useState(false);
    final isTermsChecked = useState(false);
    useEffect(() {
      policy.value = policyObj;
      return null;
    }, []);

    updatePolicy(CTPLPolicy copyPolicy) {
      policy.value = copyPolicy;
    }

    pageIsLoading.value = false;
    return BasicLayout(
      title: 'CTPL Issuance',
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
                pageIsLoading.value = true;

                if (currentPage.value == 0 &&
                    forms[0].currentState!.validate()) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                }

                //validation for vehicle details
                if (currentPage.value == 1 &&
                    forms[1].currentState!.validate()) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                }

                //validation for profile data
                if (currentPage.value == 2 &&
                    forms[2].currentState!.validate()) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                }

                // documents upload and terms
                if (currentPage.value == 3) {
                  if (isTermsChecked.value) {
                    currentPage.value++;
                    pageIsLoading.value = false;
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please accept the terms and conditions",
                      ),
                    );
                  }
                  return currentPage.value;
                }

                // total premium
                if (currentPage.value == 4) {
                  currentPage.value++;
                  pageIsLoading.value = false;
                  return currentPage.value;
                }
                // if (currentPage.value == 3 && forms[3].currentState!.validate()) {
                //   AwesomeDialog(
                //     context: context,
                //     animType: AnimType.scale,
                //     dialogType: DialogType.question,
                //     title: 'Profile Data',
                //     desc: 'Are you sure to proceed to next step?',
                //     btnCancelOnPress: () {},
                //     btnOkOnPress: () {
                //       currentPage.value++;
                //       pageIsLoading.value = false;
                //     },
                //   ).show();

                //   return currentPage.value;
                // } else if (currentPage.value == 3 &&
                //     !forms[3].currentState!.validate()) {
                //   showTopSnackBar(
                //     Overlay.of(context),
                //     displayDuration: const Duration(seconds: 1),
                //     const CustomSnackBar.info(
                //       message: "Please fill in all the fields",
                //     ),
                //   );
                //   return currentPage.value;

                //else if (currentPage.value == 5) {
                //   if (forms[2].currentState!.validate()) {
                //     currentPage.value++;
                //     pageIsLoading.value = false;
                //   } else {
                //     showTopSnackBar(
                //       Overlay.of(context),
                //       displayDuration: const Duration(seconds: 1),
                //       const CustomSnackBar.info(
                //         message: "Please select RATES, VTPLBI and VTPLPD",
                //       ),
                //     );
                //   }

                //   return currentPage.value;
                // } else if (currentPage.value == 6) {
                //   currentPage.value++;
                //   pageIsLoading.value = false;

                //   return currentPage.value;
                // } else if (currentPage.value == 7) {
                //   currentPage.value++;
                //   pageIsLoading.value = false;

                //   return currentPage.value;
                // } else if (currentPage.value == 8) {
                //   currentPage.value++;
                //   pageIsLoading.value = false;

                //   return currentPage.value;
                // }
                return currentPage.value;
              },
        isLoading: () {
          return pageIsLoading.value;
        },
        steps: [
          StepperPageView(
            title: 'CTPL Coverage',
            content: CTPLCoverage(
              policy: policy,
              updatePolicy: updatePolicy,
              form: forms[0],
            ),
          ),

          StepperPageView(
            title: 'Vehicle Details',
            content: VehicleDetails(
              policy: policy,
              updatePolicy: updatePolicy,
              form: forms[1],
            ),
          ),
          StepperPageView(
            title: 'Profile Data',
            content: CTPLProfileDataStep(
              policy: policy,
              updatePolicy: updatePolicy,
              form: forms[2],
            ),
          ),
          StepperPageView(
            title: 'Upload Documents',
            content: CTPLFileUploader(
              policy: policy,
              updatePolicy: updatePolicy,
              onTermsChecked: (value) {
                isTermsChecked.value = value;
              },
            ),
          ),
          // StepperPageView(
          //   title: 'Coverage Rates',
          //   content: CoverageRatesStep(
          //     policy: policy,
          //     updatePolicy: updatePolicy,
          //     form: forms[2],
          //   ),
          // ),
          // StepperPageView(
          //   title: 'Review Details',
          //   content: ReviewDetailsStep(
          //     policy: policy,
          //     updatePolicy: updatePolicy,
          //   ),
          // ),
          StepperPageView(
            title: 'Total Premium',
            content: CTPLTotalPremiumStep(
              policy: policy,
              updatePolicy: updatePolicy,
            ),
          ),
          StepperPageView(
            title: 'Policy Schedule Details',
            content: CTPLDraftPolicyStep(
              policy: policy,
              updatePolicy: updatePolicy,
            ),
          ),
        ],
      ),
    );
  }
}

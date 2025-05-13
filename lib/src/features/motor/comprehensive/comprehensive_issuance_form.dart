import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/components/stepper_container_form.dart';
import 'package:simone/src/components/stepper_page_view.dart';
import 'package:simone/src/features/motor/comprehensive/steps/coverage_rates_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/file_upload_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/policy_period_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/policy_schedule_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/profile_data_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/review_details_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/total_premium_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/type_cover_step.dart';
import 'package:simone/src/features/motor/comprehensive/steps/vehicle_data_step.dart';
import 'package:simone/src/components/basic_layout.dart';
import 'package:simone/src/models/policy.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class ComprehensiveIssuanceForm extends HookWidget {
  ComprehensiveIssuanceForm({super.key, required this.policyObj});

  Policy policyObj;
  final List<GlobalKey<FormState>> forms = [
    GlobalKey<FormState>(), //0 policy period
    GlobalKey<FormState>(), //1 vehicle data
    GlobalKey<FormState>(), //2 coverage rate data
    GlobalKey<FormState>(), //3 profile data
  ];

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Policy> policy = useState(Policy());
    final currentPage = useState(0);
    final pageIsLoading = useState(false);
    final isTermsChecked = useState(false);
    final isProfileProceed = useState(false);
    final hasProfile = useState(false);
    useEffect(() {
      policy.value = policyObj;
      return null;
    }, []);

    void updatePolicy(Policy copyPolicy) {
      policy.value = copyPolicy;
    }

    pageIsLoading.value = false;
    return BasicLayout(
      title: 'Comprehensive Issuance',
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
        next: currentPage.value == 8
            ? null
            : () async {
                pageIsLoading.value = true;

                if (currentPage.value == 0 &&
                    forms[0].currentState!.validate()) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                }
                if (currentPage.value == 1 &&
                    policy.value.typeOfCover != null) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                }
                if (currentPage.value == 2 &&
                    forms[1].currentState!.validate()) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                }

                if (currentPage.value == 3 &&
                    forms[3].currentState!.validate()) {
                  if (hasProfile.value == false) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "You have not selected profile yet.",
                      ),
                    );
                    return currentPage.value;
                  }

                  if (isProfileProceed.value) {
                    currentPage.value++;
                    pageIsLoading.value = false;
                    hasProfile.value = false;
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.question,
                      title: 'Profile Data',
                      desc: 'Are you sure your details is correct?',
                      btnOkText: 'Yes',
                      btnCancelText: 'No',
                      btnCancelOnPress: () {
                        isProfileProceed.value = false;
                      },
                      btnOkOnPress: () {
                        isProfileProceed.value = true;
                      },
                    ).show();
                  }

                  return currentPage.value;
                } else if (currentPage.value == 3 &&
                    !forms[3].currentState!.validate()) {
                  showTopSnackBar(
                    Overlay.of(context),
                    displayDuration: const Duration(seconds: 1),
                    const CustomSnackBar.info(
                      message: "Please fill in all the fields",
                    ),
                  );
                  return currentPage.value;
                } else if (currentPage.value == 4) {
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
                } else if (currentPage.value == 5) {
                  if (forms[2].currentState!.validate()) {
                    currentPage.value++;
                    pageIsLoading.value = false;
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please select RATES, VTPLBI and VTPLPD",
                      ),
                    );
                  }

                  return currentPage.value;
                } else if (currentPage.value == 6) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                } else if (currentPage.value == 7) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                } else if (currentPage.value == 8) {
                  currentPage.value++;
                  pageIsLoading.value = false;

                  return currentPage.value;
                }
                return currentPage.value;
              },
        isLoading: () {
          return pageIsLoading.value;
        },
        steps: [
          StepperPageView(
            title: 'Policy Period',
            content: PolicyPeriod(
              policy: policy,
              updatePolicy: updatePolicy,
              form: forms[0],
            ),
          ),
          StepperPageView(
            title: 'Type of Cover',
            content: TypeCoverStep(
              policy: policy,
              updatePolicy: updatePolicy,
            ),
          ),
          StepperPageView(
            title: 'Vehicle Data',
            content: VehicleDataStep(
              policy: policy,
              updatePolicy: updatePolicy,
              form: forms[1],
            ),
          ),
          StepperPageView(
            title: 'Profile Data',
            content: ProfileDataStep(
              policy: policy,
              updatePolicy: updatePolicy,
              form: forms[3],
              onProfileChecked: (value) {
                hasProfile.value = value;
              },
            ),
          ),
          StepperPageView(
            title: 'Upload Documents',
            content: FileUploader(
              policy: policy,
              updatePolicy: updatePolicy,
              onTermsChecked: (value) {
                isTermsChecked.value = value;
              },
            ),
          ),
          StepperPageView(
            title: 'Coverage Rates',
            content: CoverageRatesStep(
              policy: policy,
              updatePolicy: updatePolicy,
              form: forms[2],
            ),
          ),
          StepperPageView(
            title: 'Review Details',
            content: ReviewDetailsStep(
              policy: policy,
              updatePolicy: updatePolicy,
            ),
          ),
          StepperPageView(
            title: 'Total Premium',
            content: TotalPremiumStep(
              policy: policy,
              updatePolicy: updatePolicy,
            ),
          ),
          StepperPageView(
            title: 'Policy Schedule Details',
            content: PolicyScheduleStep(
              policy: policy,
              updatePolicy: updatePolicy,
            ),
          ),
        ],
      ),
    );
  }
}

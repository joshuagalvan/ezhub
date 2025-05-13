import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simone/src/components/stepper_container_form.dart';
import 'package:simone/src/components/stepper_page_view.dart';
import 'package:simone/src/features/navbar/companyprofile/web_viewer.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/features/travel/international/step/1_int_travel_details.dart';
import 'package:simone/src/features/travel/international/step/2_int_select_plan.dart';
import 'package:simone/src/features/travel/international/step/3_plan_details.dart';
import 'package:simone/src/features/travel/international/step/4_int_personal_info.dart';

import 'package:simone/src/components/basic_layout.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TravelInternational extends HookWidget {
  TravelInternational({super.key});

  final List<GlobalKey<FormState>> forms = [
    GlobalKey<FormState>(), //0 travel details
    GlobalKey<FormState>(), //1 personal info
    GlobalKey<FormState>(), //2
    GlobalKey<FormState>(), //3
  ];

  @override
  Widget build(BuildContext context) {
    final data = useState(TravelModel());
    final currentPage = useState(0);
    final pageIsLoading = useState(false);
    final isDetailsTermsChecked = useState(false);
    final isPersonalTermsChecked = useState(false);
    final isPersonalPrivacyChecked = useState(false);

    Future<String> getBranch() async {
      final storage = GetStorage();
      final branchData = await storage.read('branch');

      if (branchData != null) {
        return (branchData['locTax']).toString();
      }
      return '';
    }

    void showPopupBanner() async {
      await Future.delayed(const Duration(milliseconds: 500));
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  pushScreen(
                    context,
                    screen: const WebViewer(
                      title: 'Contact Us',
                      url: 'http://10.52.2.124:9018/contact/us/',
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/travel_popup_banner.jpg'),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      );
    }

    useEffect(() {
      async() async {
        data.value = data.value.copyWith(
          branchLocalTax: await getBranch(),
        );
      }

      async();
      showPopupBanner();
      return null;
    }, []);

    pageIsLoading.value = false;
    return BasicLayout(
      title: 'Travel International Insurance',
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
                  // Travel Details
                  if (data.value.departFrom == data.value.arriveIn) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Departure and Arrival cannot be the same.",
                      ),
                    );
                    return currentPage.value;
                  } else if (data.value.countries == null) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message:
                            "Please select at least one itenerary country.",
                      ),
                    );
                    return currentPage.value;
                  } else if (isDetailsTermsChecked.value == false) {
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please confirm the terms.",
                      ),
                    );

                    return currentPage.value;
                  } else {
                    currentPage.value++;
                    return currentPage.value;
                  }
                }
                if (currentPage.value == 1) {
                  // Select Plan
                  currentPage.value++;
                  return currentPage.value;
                }
                if (currentPage.value == 2) {
                  // Plan Details
                  currentPage.value++;
                  return currentPage.value;
                }

                if (currentPage.value == 3 &&
                    forms[1].currentState!.validate()) {
                  // Personal Info

                  currentPage.value++;
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
            content: InternationalTravelDetails(
              form: forms[0],
              intData: data,
              onTermsChecked: (value) {
                isDetailsTermsChecked.value = value;
              },
            ),
          ),
          StepperPageView(
            title: 'Select Plan',
            content: InternationalSelectPlan(
              intData: data,
            ),
          ),
          StepperPageView(
            title: 'Plan Details',
            content: InternationalPlanDetails(
              intData: data,
            ),
          ),
          StepperPageView(
            title: 'Personal Info',
            content: InternationalPersonalInfo(
              form: forms[1],
              intData: data,
              onPrivacyChecked: (value) {
                isPersonalTermsChecked.value = value;
              },
              onTermsChecked: (value) {
                isPersonalPrivacyChecked.value = value;
              },
            ),
          ),
          StepperPageView(
            title: 'Payment',
            content: Container(),
          ),
          StepperPageView(
            title: 'Success',
            content: Container(),
          ),
        ],
      ),
    );
  }
}

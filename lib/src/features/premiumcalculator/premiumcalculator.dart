// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:simone/src/constants/text_strings.dart';
// import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
// import 'package:simone/src/features/authentication/models/carcompany_model.dart';
// import 'package:simone/src/features/authentication/models/carmake_model.dart';
// import 'package:simone/src/features/authentication/models/cartype_model.dart';
// import 'package:simone/src/features/authentication/models/carvariant_model.dart';
// import 'package:simone/src/features/authentication/models/vtplbi_model.dart';
// import 'package:simone/src/features/authentication/models/vtplpd_model.dart';
// import 'package:simone/src/features/authentication/screens/navbar/quotation/quotationlist.dart';
// import 'package:simone/src/helpers/mysql.dart';
// import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:im_stepper/stepper.dart';
import 'package:simone/src/features/premiumcalculator/motorcomprehensive/motorcommission.dart';
import 'package:simone/src/features/premiumcalculator/motorcomprehensive/motorpremium.dart';
import 'package:simone/src/features/premiumcalculator/motorcomprehensive/motorquotation.dart';
import 'package:simone/src/features/premiumcalculator/traveldomestic/traveldomesticcommission.dart';
import 'package:simone/src/features/premiumcalculator/traveldomestic/traveldomesticpremium.dart';
import 'package:simone/src/features/premiumcalculator/traveldomestic/traveldomesticquotation.dart';
import 'package:simone/src/features/premiumcalculator/travelinternational/travelinternationalcommission.dart';
import 'package:simone/src/features/premiumcalculator/travelinternational/travelinternationalpremium.dart';
import 'package:simone/src/features/premiumcalculator/travelinternational/travelinternationalquotation.dart';
import 'package:simone/src/utils/colorpalette.dart';

class PremiumCalculator extends StatefulWidget {
  const PremiumCalculator({super.key});

  @override
  State<PremiumCalculator> createState() => _PremiumCalculatorState();
}

class _PremiumCalculatorState extends State<PremiumCalculator> {
  String total_premium = '';
  String basic_premium = '';
  String dst = '';
  String premium_tax = '';
  String lgt = '';

  var quote = {
    'branch': '',
    'toc': '',
    'year': '',
    'rates': '',
    'odRate': '',
    'aonRate': '',
    'comRate': '',
    'carCompany': '',
    'carMake': '',
    'carType': '',
    'variant': '',
    'fmv': '',
    'vtplbi': '',
    'vtplpd': '',
    'deduc': '',
    'localTax': '',
  };

  var quoteTravel = {
    'plan': '',
    'locTax': '',
    'inceptionDate': '',
    'expirationDate': '',
    'daysBetween': '',
    'covidProtection': '',
    'total_premium': '',
    'basic_premium': '',
    'dst': '',
    'premium_tax': '',
    'lgt': '',
  };

  motorFields(key, newVal) {
    quote[key] = newVal.toString();
  }

  travelDomFields(key, newVal) {
    quoteTravel[key] = newVal.toString();
  }

  travelDomesticPremium() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=domestic&plan_id=${quoteTravel['plan'].toString()}&account=PESO&covid_protection=${quoteTravel['covidProtection'].toString()}&travel_days=${quoteTravel['daysBetween'].toString()}&travel_destination&lgt_rate=${quoteTravel['locTax'].toString()}&bdate=09/29/2005'));
      var result = (jsonDecode(response.body));
      setState(() {
        lgt = result['lgt'];
        total_premium = result['total_premium'];
        basic_premium = result['basic_premium'];
        dst = result['dst'];
        premium_tax = result['premium_tax'];
      });
    } catch (_) {}

    String travelDomCommission =
        (double.parse(basic_premium.replaceAll(',', '')) * 0.35)
            .toStringAsFixed(2);

    var computation = {
      'lgt': lgt,
      'total_premium': total_premium,
      'basic_premium': basic_premium,
      'dst': dst,
      'premium_tax': premium_tax,
      'travelDomCommission': travelDomCommission,
    };
    return computation;
  }

  travelInternationalPremium() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=international&plan_id=${quoteTravel['plan'].toString()}&account=DOLLAR&covid_protection=${quoteTravel['covidProtection'].toString()}&travel_days=${quoteTravel['daysBetween'].toString()}&travel_destination&lgt_rate=${quoteTravel['locTax'].toString()}&bdate=09/29/2005'));
      var result = (jsonDecode(response.body));
      setState(() {
        lgt = result['lgt'];
        total_premium = result['total_premium'];
        basic_premium = result['basic_premium'];
        dst = result['dst'];
        premium_tax = result['premium_tax'];
      });
    } catch (_) {}

    String travelDomCommission =
        (double.parse(basic_premium.replaceAll(',', '')) * 0.35)
            .toStringAsFixed(2);

    var computation = {
      'lgt': lgt,
      'total_premium': total_premium,
      'basic_premium': basic_premium,
      'dst': dst,
      'premium_tax': premium_tax,
      'travelDomCommission': travelDomCommission,
    };
    return computation;
  }

  commissionComputation() {
    dynamic odComputation = double.parse(quote['odRate'].toString()) *
        double.parse(quote['fmv'].toString());
    dynamic aonComputation = double.parse(quote['aonRate'].toString()) *
        double.parse(quote['fmv'].toString());
    double basicPremComputation = double.parse(quote['vtplbi'].toString()) +
        double.parse(quote['vtplpd'].toString()) +
        odComputation +
        aonComputation;
    double odComRateComputation =
        odComputation * double.parse(quote['comRate'].toString());
    double aonComRateComputation =
        aonComputation * double.parse(quote['comRate'].toString());
    double vtplbiComRateComputation = double.parse(quote['vtplbi'].toString()) *
        double.parse(quote['comRate'].toString());
    double vtplpdComRateComputation = double.parse(quote['vtplpd'].toString()) *
        double.parse(quote['comRate'].toString());
    double totalcommissionComputation =
        basicPremComputation * double.parse(quote['comRate'].toString());
    double docStampComputation =
        ((basicPremComputation / 4).ceilToDouble()) * .5;
    double vatComputation = basicPremComputation * .12;
    double localVatComputation =
        (double.parse(quote['localTax'].toString()) * basicPremComputation) /
            100;
    double totalPremiumComputation = basicPremComputation +
        docStampComputation +
        vatComputation +
        localVatComputation;
    double commissionRateWhole =
        100 * double.parse(quote['comRate'].toString());
    String fmvComValue = quote['fmv'].toString();
    double odRateValue = double.parse(quote['odRate'].toString());
    double aonRateValue = double.parse(quote['aonRate'].toString());
    double vtplbiValue = double.parse(quote['vtplbi'].toString());
    double vtplpdValue = double.parse(quote['vtplpd'].toString());
    String tocValue = quote['toc'].toString();
    dynamic yearValue = quote['year'].toString();
    String ratesValue = quote['rates'].toString();
    String carCompanyValue = quote['carCompany'].toString();
    String carMakeValue = quote['carMake'].toString();
    String carTypeValue = quote['carType'].toString();
    String carVariantValue = quote['variant'].toString();
    String deduc = quote['deduc'].toString();
    String branch = quote['branch'].toString();
    double locTax = double.parse(quote['localTax'].toString());

    var computation = {
      'od': odComputation,
      'aon': aonComputation,
      'basicPrem': basicPremComputation,
      'odCom': odComRateComputation,
      'aonCom': aonComRateComputation,
      'vtplbiCom': vtplbiComRateComputation,
      'vtplpdCom': vtplpdComRateComputation,
      'totalCom': totalcommissionComputation,
      'docStamp': docStampComputation,
      'vat': vatComputation,
      'localvat': localVatComputation,
      'totalPrem': totalPremiumComputation,
      'comRate': commissionRateWhole,
      'fmvValue': fmvComValue,
      'odRate': odRateValue,
      'aonRate': aonRateValue,
      'vtplbiValue': vtplbiValue,
      'vtplpdValue': vtplpdValue,
      'toc': tocValue,
      'year': yearValue,
      'rates': ratesValue,
      'carCompany': carCompanyValue,
      'carMake': carMakeValue,
      'carType': carTypeValue,
      'carVariant': carVariantValue,
      'deduc': deduc,
      'branch': branch,
      'localTax': locTax,
    };
    return computation;
  }

  final _comprehensiveController = PageController();
  int _comprehensiveCurrentStep = 0;

  final _domesticController = PageController();
  int _domesticCurrentStep = 0;

  final _internatlController = PageController();
  int _internatlCurrentStep = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              indicatorColor: ColorPalette.primaryColor,
              labelColor: ColorPalette.primaryColor,
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_car),
                  text: "Comprehensive",
                ),
                Tab(
                  icon: Icon(Icons.flight),
                  text: "Domestic",
                ),
                Tab(
                  icon: Icon(Icons.flight),
                  text: "International",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      NumberStepper(
                        numbers: const [
                          1,
                          2,
                          3,
                        ],
                        activeStepColor: ColorPalette.primaryColor,
                        activeStepBorderColor: ColorPalette.primaryColor,
                        lineColor: ColorPalette.grey,
                        stepColor: ColorPalette.primaryColor.withOpacity(0.3),
                        activeStep: _comprehensiveCurrentStep,
                        enableNextPreviousButtons: false,
                        enableStepTapping: false,
                      ),
                      Expanded(
                        child: PageView(
                          controller: _comprehensiveController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            MotorQuotationPageView(
                              motorField: motorFields,
                              onNextPressed: () {
                                setState(() {
                                  _comprehensiveCurrentStep = 1;
                                  _comprehensiveController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                });
                              },
                            ),
                            MotorCommissionPageView(
                              quote: commissionComputation,
                              onPrevPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.warning,
                                  title: 'Are you sure you want to go back?',
                                  desc:
                                      'This will reset all the selected data form fields',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      _comprehensiveCurrentStep = 0;
                                      _comprehensiveController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    });
                                  },
                                ).show();
                              },
                              onNextPressed: () {
                                setState(() {
                                  _comprehensiveCurrentStep = 2;
                                  _comprehensiveController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                });
                              },
                            ),
                            MotorPremiumPageView(
                              quote: commissionComputation,
                              onPrevPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.warning,
                                  title: 'Are you sure you want to go back?',
                                  desc: 'This might reset all the saved data',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      _comprehensiveCurrentStep = 1;
                                      _comprehensiveController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    });
                                  },
                                ).show();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  ///// Domestic
                  Column(
                    children: [
                      NumberStepper(
                        numbers: const [
                          1,
                          2,
                          3,
                        ],
                        activeStepColor: ColorPalette.primaryColor,
                        activeStepBorderColor: ColorPalette.primaryColor,
                        lineColor: ColorPalette.grey,
                        stepColor: ColorPalette.primaryColor.withOpacity(0.3),
                        activeStep: _domesticCurrentStep,
                        enableNextPreviousButtons: false,
                        enableStepTapping: false,
                      ),
                      Expanded(
                        child: PageView(
                          controller: _domesticController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            TravelDomesticQuotation(
                              travelDomField: travelDomFields,
                              onNextPressed: () {
                                setState(() {
                                  _domesticCurrentStep = 1;
                                  _domesticController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                });
                              },
                            ),
                            TravelDomesticCommission(
                              quoteTravel: travelDomesticPremium,
                              onPrevPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.warning,
                                  title: 'Are you sure you want to go back?',
                                  desc:
                                      'This will reset all the selected data form fields',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      _domesticCurrentStep = 0;
                                      _domesticController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    });
                                  },
                                ).show();
                              },
                              onNextPressed: () {
                                setState(() {
                                  _domesticCurrentStep = 2;
                                  _domesticController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                });
                              },
                            ),
                            TravelDomesticPremium(
                              quoteTravel: travelDomesticPremium,
                              onPrevPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.warning,
                                  title: 'Are you sure you want to go back?',
                                  desc: 'This might reset all the saved data',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      _domesticCurrentStep = 1;
                                      _domesticController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    });
                                  },
                                ).show();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  ///// Internaltional
                  Column(
                    children: [
                      NumberStepper(
                        numbers: const [
                          1,
                          2,
                          3,
                        ],
                        activeStepColor: ColorPalette.primaryColor,
                        activeStepBorderColor: ColorPalette.primaryColor,
                        lineColor: ColorPalette.grey,
                        stepColor: ColorPalette.primaryColor.withOpacity(0.3),
                        activeStep: _internatlCurrentStep,
                        enableNextPreviousButtons: false,
                        enableStepTapping: false,
                      ),
                      Expanded(
                        child: PageView(
                          controller: _internatlController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            TravelInternationalQuotation(
                              travelDomField: travelDomFields,
                              onNextPressed: () {
                                setState(() {
                                  _internatlCurrentStep = 1;
                                  _internatlController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                });
                              },
                            ),
                            TravelInternationalCommission(
                              quoteTravel: travelInternationalPremium,
                              onPrevPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.warning,
                                  title: 'Are you sure you want to go back?',
                                  desc:
                                      'This will reset all the selected data form fields',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      _internatlCurrentStep = 0;
                                      _internatlController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    });
                                  },
                                ).show();
                              },
                              onNextPressed: () {
                                setState(() {
                                  _internatlCurrentStep = 2;
                                  _internatlController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                });
                              },
                            ),
                            TravelInternationalPremium(
                              quoteTravel: travelInternationalPremium,
                              onPrevPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.warning,
                                  title: 'Are you sure you want to go back?',
                                  desc: 'This might reset all the saved data',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      _internatlCurrentStep = 1;
                                      _internatlController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    });
                                  },
                                ).show();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simone/src/constants/image_strings.dart';
import 'package:simone/src/features/authentication/models/quotation_details_model.dart';
import 'package:simone/src/features/motor/comprehensive/verification_form.dart';
import 'package:simone/src/features/navbar/companyprofile/web_viewer.dart';
import 'package:simone/src/utils/colorpalette.dart';

class Productmotor extends StatefulWidget {
  const Productmotor({super.key, this.from, this.quotation});

  final String? from;
  final QuotationDetails? quotation;
  @override
  State<Productmotor> createState() => ProductmotorState();
}

class ProductmotorState extends State<Productmotor> {
  final typeController = TextEditingController();
  String selectedType = 'Plate Number';

  void checkQuotation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (widget.from == 'quotation') {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (context) {
            return VerificationForm(
              quotation: widget.quotation,
              type: 'comprehensive',
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    checkQuotation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          surfaceTintColor: Colors.white,
          title: const Text(
            "Motor Insurance",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 3,
                      color: Colors.grey[200]!,
                    )
                  ],
                ),
                child: const Column(
                  children: [
                    Hero(
                      tag: motor,
                      child: Image(
                        image: AssetImage(motor),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Text(
                      "Many car accidents happen in the Philippines every day. Make sure you are protected.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      strutStyle: StrutStyle(
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInsuranceCard(
                      imageBanner: 'assets/motor_myautomate.jpg',
                      title: 'MyAuto Mate',
                      description:
                          "Providing full insurance protection against total or partial loss due to events such as impact collision, overturning, sliding, fire and theft.",
                      onInfoPressed: () {
                        pushScreen(
                          context,
                          screen: const WebViewer(
                            title: 'MyAuto Mate',
                            url:
                                'https://ph.fpgins.com/products/motor/comprehensive/',
                          ),
                        );
                      },
                      onBuyPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            builder: (context) {
                              return const VerificationForm(
                                type: 'comprehensive',
                              );
                            });
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildInsuranceCard(
                      imageBanner: 'assets/motor_myctplmate.jpg',
                      title: 'MyCTPL Mate',
                      description:
                          "Protects the insured from any liability against bodily injury and/or death to any third-party individual.",
                      onInfoPressed: () {
                        pushScreen(
                          context,
                          screen: const WebViewer(
                            title: 'MyCTPL Mate',
                            url: 'https://ph.fpgins.com/products/motor/ctpl/',
                          ),
                        );
                      },
                      onBuyPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            builder: (context) {
                              return const VerificationForm(
                                type: 'ctpl',
                              );
                            });
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceCard({
    required String imageBanner,
    required String title,
    required String description,
    required Function() onInfoPressed,
    required Function() onBuyPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 1,
            color: Colors.grey[300]!,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: ColorPalette.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Stack(
            children: [
              Image(
                image: AssetImage(imageBanner),
                width: 400.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: onInfoPressed,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FontAwesomeIcons.circleInfo,
                        color: ColorPalette.primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              description,
              textAlign: TextAlign.center,
              strutStyle: const StrutStyle(
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBuyPressed,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xfffe5000),
                ),
                child: const Text(
                  'Buy Your Insurance',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

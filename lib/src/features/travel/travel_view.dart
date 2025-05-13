// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simone/src/features/navbar/companyprofile/web_viewer.dart';
import 'package:simone/src/features/travel/domestic/domestic_view.dart';
import 'package:simone/src/features/travel/international/international_view.dart';
import 'package:simone/src/utils/colorpalette.dart';

class TravelView extends StatefulWidget {
  const TravelView({super.key});

  @override
  State<TravelView> createState() => TravelViewState();
}

class TravelViewState extends State<TravelView> {
  final typeController = TextEditingController();
  String selectedType = 'Plate Number';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          surfaceTintColor: Colors.white,
          title: const Text(
            "Travel Insurance",
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
                      tag: 'assets/Travel.png',
                      child: Image(
                        image: AssetImage('assets/Travel.png'),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Text(
                      "Adventures are more enjoyable when you travel\nworry-free!",
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInsuranceCard(
                      imageBanner: 'assets/travel_international.jpg',
                      title: 'MyTravel Mate International',
                      description:
                          "Europe, Asia, or anywhere worldwide, we got you covered.",
                      onInfoPressed: () {
                        pushScreen(
                          context,
                          screen: const WebViewer(
                            title: 'MyTravel Mate International',
                            url:
                                'http://10.52.2.124:9018/products/travel/international/',
                          ),
                        );
                      },
                      onBuyPressed: () {
                        pushScreen(
                          context,
                          screen: TravelInternational(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInsuranceCard(
                      imageBanner: 'assets/travel_domestic.jpg',
                      title: 'MyTravel Mate Domestic',
                      description:
                          "Explore 7,107 islands worry-free. Truly, it's more fun in the Philippines!",
                      onInfoPressed: () {
                        pushScreen(
                          context,
                          screen: const WebViewer(
                            title: 'MyTravel Mate Domestic',
                            url:
                                'http://10.52.2.124:9018/products/travel/domestic/',
                          ),
                        );
                      },
                      onBuyPressed: () {
                        pushScreen(
                          context,
                          screen: TravelDomestic(),
                        );
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
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
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: onInfoPressed,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xfffe5000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        color: Color(0xfffe5000),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

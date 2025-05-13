import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/features/authentication/controllers/profile_controller.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/colorpalette.dart';

class TravelDomesticQuotation extends StatefulWidget {
  const TravelDomesticQuotation({
    super.key,
    this.travelDomField,
    required this.onNextPressed,
  });

  final Function(String, dynamic)? travelDomField;
  final Function() onNextPressed;

  @override
  State<TravelDomesticQuotation> createState() =>
      _TravelDomesticQuotationState();
}

class _TravelDomesticQuotationState extends State<TravelDomesticQuotation> {
  final controller = Get.put(ProfileController());
  TextEditingController inceptionDate = TextEditingController();
  TextEditingController expirationDate = TextEditingController();
  late DateTime inceptionValue, expirationValue;
  String? branchName, topValue;
  bool showWidget = false;
  bool? covidToggle = false;
  dynamic covidProtect = 0;
  double locTax = 0;

  dynamic daysBetween, daysBetweenAdded;

  List<Map<String, dynamic>> plans = [
    {'text': 'PLAN 1', 'value': '4'},
    {'text': 'PLAN 2', 'value': '5'},
    {'text': 'PLAN 3', 'value': '6'},
    {'text': 'PLAN 4', 'value': '7'},
    {'text': 'PLAN 5', 'value': '8'},
  ];

  List<String?> destinations = [''];
  List<String?> destinationsOptions = [];

  @override
  void initState() {
    super.initState();
    getBranch();
    getDestinations();
  }

  getBranch() async {
    var userData = await controller.getUserData();
    try {
      final response = await http.get(Uri.parse(
          'http://10.52.2.124/ezhub/getBranch_json/?intm_code=${userData?.agentCode}'));
      var result = (jsonDecode(response.body)[0]);
      locTax = double.parse(result['local_tax']);
      widget.travelDomField!('locTax', locTax);
      setState(() {
        branchName = (result['name']);
      });
    } catch (_) {}
  }

  getDestinations() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124:9017/travel/getDestination_json/'),
          body: {'table': 'dom'});
      var result = (jsonDecode(response.body));
      List<String> dest = [];
      for (var row in result['results']) {
        dest.add(row['name']);
      }
      setState(() {
        destinationsOptions = dest;
      });
    } catch (_) {}
  }

  Future<void> selectInceptionDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        inceptionDate.text = picked.toString().split(" ")[0];
        inceptionValue = picked;
        widget.travelDomField!('inceptionDate', inceptionValue);
      });
    }
  }

  Future<void> selectExpirationDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        expirationDate.text = picked.toString().split(" ")[0];
        expirationValue = picked;
        widget.travelDomField!('expirationDate', expirationValue);
        daysBetween = expirationValue.difference(inceptionValue).inDays;
        daysBetweenAdded = daysBetween + 1;
        widget.travelDomField!('daysBetween', daysBetweenAdded);
      });
    }
  }

  bool validateNextButton() {
    final check = (topValue != null) &&
        destinations.isNotEmpty &&
        inceptionDate.text != '' &&
        expirationDate.text != '';
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      branch,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      branchName ?? "",
                      style: const TextStyle(
                        color: Color(0xfffe5000),
                        fontSize: 17.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Type of Product",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: CustomDropdownButton<String>(
                      value: topValue,
                      items: plans.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['value'],
                          child: Text(item['text']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        topValue = value;
                        widget.travelDomField!('plan', topValue);
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Add Destination",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                destinations.add('');
                              });
                            },
                          )
                        ],
                      ),
                      ...destinationList(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Inception Date",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            TextField(
                              controller: inceptionDate,
                              decoration: InputDecoration(
                                hintText: "Select Date",
                                prefixIcon: const Icon(Icons.calendar_today),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: ColorPalette.greyE3,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: ColorPalette.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                              ),
                              readOnly: true,
                              onTap: () {
                                selectInceptionDate();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Expiration Date",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            TextField(
                              controller: expirationDate,
                              decoration: InputDecoration(
                                hintText: "Select Date",
                                prefixIcon: const Icon(Icons.calendar_today),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: ColorPalette.greyE3,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: ColorPalette.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                              ),
                              readOnly: true,
                              onTap: () {
                                selectExpirationDate();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: RichText(
                  text: const TextSpan(
                    text: "Covid Protection",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfffe5000),
                    ),
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                contentPadding: EdgeInsets.zero,
                value: covidToggle,
                activeColor: const Color(0xfffe5000),
                onChanged: (bool? newBool) {
                  setState(() {
                    covidToggle = newBool;
                    if (covidToggle == true) {
                      covidProtect = 1;
                    } else {
                      covidProtect = 0;
                    }
                    widget.travelDomField!('covidProtection', covidProtect);
                  });
                },
              ),
              if (validateNextButton())
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: widget.onNextPressed,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Iterable<Widget> destinationList() {
    List<Widget> destList = [];
    destinations.asMap().forEach(
      (k, destination) {
        destList.add(
          Row(
            children: [
              SizedBox(
                width: 190,
                height: 60,
                child: CustomDropdownButton(
                  value: destination == '' && destinationsOptions.isNotEmpty
                      ? destinationsOptions[0]
                      : destination,
                  items: destinationsOptions.map((destinationOption) {
                    return DropdownMenuItem(
                      value: destinationOption,
                      child: Text(destinationOption!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      destinations[k] = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    destinations.removeAt(k);
                  });
                },
              )
            ],
          ),
        );
      },
    );
    return destList;
  }
}

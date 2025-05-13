import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/validators.dart';

class CreateCTPLProfile extends StatefulWidget {
  const CreateCTPLProfile({super.key, required this.onSave, this.savedData});
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? savedData;

  @override
  State<CreateCTPLProfile> createState() => _CreateCTPLProfileState();
}

class _CreateCTPLProfileState extends State<CreateCTPLProfile> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthDateController = TextEditingController();
  final birthPlaceController = TextEditingController();
  final citizenshipController = TextEditingController();
  final blkStController = TextEditingController();
  final barangayController = TextEditingController();
  final cityStateController = TextEditingController();
  final provinceController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailAddController = TextEditingController();
  final tinNumberController = TextEditingController();
  final personalIdController = TextEditingController();

  String? genderValue;
  String? sourceIncomeValue;
  String? typeIdValue;
  List<dynamic> lineBusiness = [];
  List<dynamic> sourceIncome = [];
  List<dynamic> typeId = [];
  // final _carCompanyFocusNode = FocusNode();
  // final _carMakeModelFocusNode = FocusNode();

  List<Map<String, dynamic>> ctplCoverage = [
    {'text': 'YES', 'value': '2'},
    {'text': 'NO', 'value': '1'},
  ];

  List<Map<String, dynamic>> gender = [
    {'text': 'Male', 'value': 'MALE'},
    {'text': 'Female', 'value': 'FEMALE'},
  ];

  List<Map<String, dynamic>> transmission = [
    {'text': 'Automatic', 'value': 'Automatic'},
    {'text': 'Manual', 'value': 'Manual'},
  ];

  getLineOfBusiness() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124:9017/ctpl/getLineOfBusiness_json/'));
      var result = (jsonDecode(response.body));

      lineBusiness = [];
      for (var row in result) {
        lineBusiness.add(row);
      }

      setState(() {});
    } catch (_) {}
  }

  getSourceOfIncome() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124:9017/ctpl/getSourceOfFunds_json/'));
      var result = (jsonDecode(response.body));

      sourceIncome = [];
      for (var row in result) {
        sourceIncome.add(row);
      }

      setState(() {});
    } catch (_) {}
  }

  getTypeOfId() async {
    try {
      final response = await http.post(
          Uri.parse('http://10.52.2.124:9017/ctpl/getAcceptableIds_json/'));
      var result = (jsonDecode(response.body));

      typeId = [];
      for (var row in result) {
        typeId.add(row);
      }

      setState(() {});
    } catch (_) {}
  }

  getPreviousData() {
    if (widget.savedData != null && widget.savedData!.isNotEmpty) {
      firstNameController.text = widget.savedData!["firstName"];
      middleNameController.text = widget.savedData?["middleName"] ?? '';
      lastNameController.text = widget.savedData!["lastName"];
      birthDateController.text = widget.savedData!["birthDate"];
      birthPlaceController.text = widget.savedData!["birthPlace"];
      genderValue = (widget.savedData?["gender"] as String?) ?? 'Male';
      citizenshipController.text = widget.savedData!["citizenship"];
      blkStController.text = widget.savedData!["blkSt"];
      barangayController.text = widget.savedData!["barangay"];
      cityStateController.text = widget.savedData!["cityState"];
      provinceController.text = widget.savedData!["province"];
      zipCodeController.text = widget.savedData!["zipCode"];
      phoneNumberController.text = widget.savedData!["phoneNumber"];
      mobileNumberController.text = widget.savedData!["mobileNumber"];
      emailAddController.text = widget.savedData!["emailAdd"];
      tinNumberController.text = widget.savedData!["tinNumber"];
      sourceIncomeValue = widget.savedData!["sourceIncome"];
      typeIdValue = widget.savedData!["typeId"];
      personalIdController.text = widget.savedData!["personalId"];
      // "Individual" = widget.savedData!["taggingText"];
      //  widget.savedData!["tagging"];
    }
  }

  @override
  void initState() {
    super.initState();
    getLineOfBusiness();
    getSourceOfIncome();
    getTypeOfId();
    getPreviousData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: ColorPalette.primaryColor,
            labelColor: ColorPalette.primaryColor,
            tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: "Individual",
              ),
              Tab(
                icon: Icon(Icons.business),
                text: "Corporate",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(defaultSizePrem),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextInput(
                        "First Name",
                        hintText: "Enter First Name",
                        controller: firstNameController,
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Middle Name",
                        hintText: "Enter Middle Name (Optional)",
                        controller: middleNameController,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Last Name",
                        hintText: "Enter Last Name",
                        controller: lastNameController,
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Birth Date"),
                          InputTextField(
                            controller: birthDateController,
                            hintText: 'Enter your Birthdate',
                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            readOnly: true,
                            onTap: () {
                              selectBirthDate();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Birth Place",
                        hintText: "Enter Birth Place",
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                        controller: birthPlaceController,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Gender"),
                          CustomDropdownButton<String>(
                            value: genderValue,
                            items: gender.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Text(item['text']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              genderValue = value;
                            },
                            validator: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Citizenship",
                        hintText: "Enter Citizenship",
                        controller: citizenshipController,
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Block/ Lot/ Phase No/ Unit/ Street/ Village/ Subdivision",
                        hintText: "Enter Block/ Lot/ Phase No",
                        controller: blkStController,
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Barangay",
                        hintText: "Enter Barangay",
                        controller: barangayController,
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "City",
                        hintText: "Enter City",
                        controller: cityStateController,
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Province",
                        hintText: "Enter Province",
                        controller: provinceController,
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Zip Code",
                        hintText: "Enter Zip Code",
                        controller: zipCodeController,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Country",
                        hintText: "Enter Country",
                        controller: TextEditingController(text: 'Philippines'),
                        textCapitalization: TextCapitalization.words,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Phone Number",
                        hintText: "Enter Phone Number (Optional)",
                        controller: phoneNumberController,
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Mobile Number",
                        hintText: "Enter Mobile Number",
                        controller: mobileNumberController,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Email Address",
                        hintText: "Enter Email Address",
                        controller: emailAddController,
                        validators: (value) =>
                            TextFieldValidators.validateEmail(value),
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "TIN",
                        hintText: "Enter TIN",
                        controller: tinNumberController,
                        validators: (value) =>
                            TextFieldValidators.validateTIN(value),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Source of Income"),
                          CustomDropdownButton<String>(
                            value: sourceIncomeValue,
                            items: sourceIncome.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'],
                                child: Text(item['code']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              sourceIncomeValue = value;
                            },
                            validator: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Type of ID"),
                          CustomDropdownButton<String>(
                            value: typeIdValue,
                            items: typeId.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'],
                                child: Text(item['description']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              typeIdValue = value;
                            },
                            validator: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTextInput(
                        "Personal ID",
                        hintText: "Enter Personal ID",
                        controller: personalIdController,
                        validators: (value) =>
                            TextFieldValidators.validateEmptyField(value),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xfffe5000),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () {
                              // name.text =
                              //     '${firstName.text} ${middleName.text} ${lastName.text}';
                              // insuredTin = tinNumber.text;
                              // insuredAddress =
                              //     '${blkSt.text} ${barangay.text} ${cityState.text} ${province.text} Philippines';
                              // taggingText = "Individual";
                              // insuredEmail = emailAdd.text;
                              // insuredGender = genderValue.toString();
                              // insuredContact = mobileNumber.text;
                              // tagging = 0;
                              if (_formKey.currentState!.validate()) {
                                final data = {
                                  "firstName": firstNameController.text,
                                  "middleName": middleNameController.text,
                                  "lastName": lastNameController.text,
                                  "birthDate": birthDateController.text,
                                  "birthPlace": birthPlaceController.text,
                                  "gender": genderValue ?? '',
                                  "citizenship": citizenshipController.text,
                                  "blkSt": blkStController.text,
                                  "barangay": barangayController.text,
                                  "cityState": cityStateController.text,
                                  "province": provinceController.text,
                                  "zipCode": zipCodeController.text,
                                  "phoneNumber": phoneNumberController.text,
                                  "mobileNumber": mobileNumberController.text,
                                  "emailAdd": emailAddController.text,
                                  "tinNumber": tinNumberController.text,
                                  "sourceIncome": sourceIncomeValue.toString(),
                                  "typeId": typeIdValue.toString(),
                                  "personalId": personalIdController.text,
                                  "taggingText": "Individual",
                                  "tagging": 0,
                                };
                                widget.onSave(data);
                                Navigator.pop(context);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xfffe5000),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            ///// CORPORATE TAB /////
            Container(
              padding: const EdgeInsets.all(defaultSizePrem),
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    // _buildTextInput(
                    //   "Full Name",
                    //   hintText: "Enter Corporate Name",
                    //   controller: fullName,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Person In Charge",
                    //   hintText: "Enter Corporate Name",
                    //   controller: personCharge,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Block/ Lot/ Phase No/ Unit/ Street/ Village/ Subdivision",
                    //   hintText: "Enter Block/ Lot/ Phase No",
                    //   controller: blkSt,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Barangay",
                    //   hintText: "Enter Barangay",
                    //   controller: barangay,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "City",
                    //   hintText: "Enter City",
                    //   controller: cityState,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Province",
                    //   hintText: "Enter Province",
                    //   controller: province,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Postal Code",
                    //   hintText: "Enter Postal Code",
                    //   controller: zipCode,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Country",
                    //   hintText: "Enter Country",
                    //   controller: TextEditingController(text: 'Philippines'),
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Phone Number",
                    //   hintText: "Enter Phone Number",
                    //   controller: phoneNumber,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Mobile Number",
                    //   hintText: "Enter Mobile Number",
                    //   controller: mobileNumber,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Email Address",
                    //   hintText: "Enter Email Address",
                    //   controller: emailAdd,
                    //   validators: (value) =>
                    //       TextFieldValidators.validateEmail(value),
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "TIN",
                    //   hintText: "Enter TIN",
                    //   controller: tinNumber,
                    //   validators: (value) =>
                    //       TextFieldValidators.validateTIN(value),
                    // ),
                    // const SizedBox(height: 10),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text("Line of Business"),
                    //     CustomDropdownButton<String>(
                    //       value: lobValue,
                    //       items: lineBusiness.map((item) {
                    //         return DropdownMenuItem<String>(
                    //           value: item['lob'],
                    //           child: Text(item['description']),
                    //         );
                    //       }).toList(),
                    //       onChanged: (value) {
                    //         lobValue = value;
                    //       },
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 10),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text("Source of Income"),
                    //     CustomDropdownButton<String>(
                    //       value: sourceIncomeValue,
                    //       items: sourceIncome.map((item) {
                    //         return DropdownMenuItem<String>(
                    //           value: item['id'],
                    //           child: Text(item['code']),
                    //         );
                    //       }).toList(),
                    //       onChanged: (value) {
                    //         sourceIncomeValue = value;
                    //       },
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(height: 10),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text("Business License Date"),
                    //     const SizedBox(width: 37),
                    //     InputTextField(
                    //       controller: businessLicenseDate,
                    //       prefixIcon: const Icon(Icons.calendar_today),
                    //       readOnly: true,
                    //       onTap: () {
                    //         selectBusinessLicenseDate();
                    //       },
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Share Holder 1",
                    //   hintText: "Enter Share Holder 1",
                    //   controller: shareHolder1,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Share Holder 2",
                    //   hintText: "Enter Share Holder 2",
                    //   controller: shareHolder2,
                    // ),
                    // const SizedBox(height: 10),
                    // _buildTextInput(
                    //   "Share Holder 3",
                    //   hintText: "Enter Share Holder 3",
                    //   controller: shareHolder3,
                    // ),
                    // const SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         Navigator.pop(context);
                    //       },
                    //       style: OutlinedButton.styleFrom(
                    //         backgroundColor: const Color(0xfffe5000),
                    //       ),
                    //       child: const Text(
                    //         'Cancel',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontFamily: 'OpenSans',
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 15),
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           name.text = fullName.text;
                    //           insuredTin = tinNumber.text;
                    //           insuredAddress =
                    //               '${blkSt.text} ${cityState.text} Philippines';
                    //           taggingText = "Corporate";
                    //         });
                    //         Navigator.pop(context);
                    //       },
                    //       style: OutlinedButton.styleFrom(
                    //         backgroundColor: const Color(0xfffe5000),
                    //       ),
                    //       child: const Text(
                    //         'Save',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontFamily: 'OpenSans',
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectBirthDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        birthDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Widget _buildTextInput(
    String label, {
    String? hintText,
    TextEditingController? controller,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validators,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        InputTextField(
          controller: controller,
          hintText: hintText,
          textCapitalization: textCapitalization,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validators: validators,
        )
      ],
    );
  }
}

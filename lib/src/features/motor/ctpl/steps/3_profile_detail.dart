// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/features/navbar/quotation/form.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CTPLProfileDataStep extends HookWidget {
  const CTPLProfileDataStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
    this.form,
  });

  final ValueNotifier<CTPLPolicy> policy;
  final Function(CTPLPolicy) updatePolicy;
  final GlobalKey<FormState>? form;

  @override
  Widget build(BuildContext context) {
    final fullNameController = useState(TextEditingController());
    final birthDateController = useState(TextEditingController());
    final birthPlaceController = useState(TextEditingController());
    final emailController = useState(TextEditingController());
    final streetAddressController = useState(TextEditingController());
    final brgyController = useState(TextEditingController());
    final cityController = useState(TextEditingController());
    final provinceController = useState(TextEditingController());
    final zipController = useState(TextEditingController());
    final countryController =
        useState(TextEditingController(text: 'Philippines'));
    final taggingController = useState(TextEditingController());
    final phoneController = useState(TextEditingController());
    final mobileController = useState(TextEditingController());
    final tinController = useState(TextEditingController());
    final citizenshipController = useState(TextEditingController());
    final personalIdController = useState(TextEditingController());
    final isLoading = useState(false);
    final hasProfile = useState(false);
    final isNewProfile = useState(false);
    final isProfileCorrect = useState('Yes');
    final selectedGender = useState<String?>(null);
    // final insuredTin = useState('');
    // final insuredAddress = useState('');
    final tagging = useState(0);
    final taggingText = useState('');
    final focusNode = FocusNode();

    // final insCode = useState<String?>(null);
    final sourceIncomeValue = useState<String?>(null);
    final typeIdValue = useState<String?>(null);
    final lineBusiness = useState([]);
    final sourceIncome = useState([]);
    final typeId = useState([]);
    final insuredNameList = useState([]);

    getLineOfBusiness() async {
      try {
        final response = await http.post(
            Uri.parse('http://10.52.2.124:9017/ctpl/getLineOfBusiness_json/'));
        var result = (jsonDecode(response.body));

        lineBusiness.value = [];
        for (var row in result) {
          lineBusiness.value.add(row);
        }
      } catch (_) {}
    }

    getSourceOfIncome() async {
      try {
        final response = await http.post(
            Uri.parse('http://10.52.2.124:9017/ctpl/getSourceOfFunds_json/'));
        var result = (jsonDecode(response.body));

        sourceIncome.value = [];
        for (var row in result) {
          sourceIncome.value.add(row);
        }
      } catch (_) {}
    }

    getTypeOfId() async {
      try {
        final response = await http.post(
            Uri.parse('http://10.52.2.124:9017/ctpl/getAcceptableIds_json/'));
        var result = (jsonDecode(response.body));

        typeId.value = [];
        for (var row in result) {
          typeId.value.add(row);
        }
      } catch (_) {}
    }

    Map<String, String> splitFullName(String fullName) {
      // Trim extra spaces
      fullName = fullName.trim();

      // Split the full name into parts
      List<String> nameParts = fullName.split(RegExp(r'\s+'));

      // Initialize variables
      String firstName = '';
      String middleName = '';
      String lastName = '';

      if (nameParts.length == 1) {
        // Only one name part provided
        firstName = nameParts[0];
      } else if (nameParts.length == 2) {
        // Two parts: Assume first and last name
        firstName = nameParts[0];
        lastName = nameParts[1];
      } else {
        // Three or more parts: Assume first, middle, and last name
        firstName = nameParts[0];
        lastName = nameParts.last;
        middleName = nameParts.sublist(1, nameParts.length - 1).join(' ');
      }

      return {
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
      };
    }

    Future<void> getInsuredDetails(String insCode) async {
      showDialog(
        context: context,
        builder: (context) => const CustomLoadingDialog(),
      );
      try {
        final response = await http.post(
            Uri.parse(
                'http://10.52.2.124/motor/getInsuredAdditionalDetails_json/'),
            body: {
              "ins_code": insCode,
            });
        Navigator.pop(context);
        var result = (jsonDecode(response.body));
        if (GetUtils.isEmail(result['email'])) {
          hasProfile.value = true;
          insuredNameList.value.clear();
          fullNameController.value.text = result['name'];
          tagging.value = result['tagging'];
          emailController.value.text = result['email'];
          phoneController.value.text = policy.value.phoneNo ?? '';
          mobileController.value.text = policy.value.mobileNo ?? '';
          birthDateController.value.text = result['birthday'];
          selectedGender.value = policy.value.gender;
          policy.value = policy.value.copyWith(
            fullName: result['name'],
            firstName: splitFullName(result['name'])['firstName'],
            middleName: splitFullName(result['name'])['middleName'],
            lastName: splitFullName(result['name'])['lastName'],
            email: result['email'],
            address1: result['address_1'],
            address2: result['address_2'],
            tin: result['tin'],
          );

          if (tagging.value == 0) {
            taggingText.value = "Individual";
            taggingController.value.text = "Individual";
          } else {
            taggingText.value = "Corporate";
            taggingController.value.text = "Corporate";
          }
          updatePolicy(policy.value);
        } else {
          showTopSnackBar(
            Overlay.of(context),
            displayDuration: const Duration(seconds: 1),
            const CustomSnackBar.error(
              message: "The email of this profile is not valid!",
            ),
          );
          hasProfile.value = false;
        }
      } catch (_) {}
    }

    Future<void> searchProfileByKeyword() async {
      // showDialog(
      //   context: context,
      //   builder: (context) => const CustomLoadingDialog(),
      // );
      isLoading.value = true;
      final userDataResult = GetStorage().read('userData');
      final userData = UserModel.fromJson(userDataResult);
      try {
        final response = await http.get(
          Uri.parse(
            'http://10.52.2.58/care-uat/client/getProfilef/?name=${fullNameController.value.text}&bdate=${birthDateController.value.text}&intm_code=${userData.agentCode}',
          ),
        );
        getTypeOfId();
        getSourceOfIncome();
        getLineOfBusiness();
        if (response.body.contains('No record found')) {
          isLoading.value = false;
          isProfileCorrect.value = 'No';
          taggingText.value = "Individual";
          taggingController.value.text = "Individual";
          policy.value = policy.value.copyWith(taggingId: '0');
          updatePolicy(policy.value);
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.warning,
            title: 'CTPL Issuance',
            desc: 'Profile not found.\nWould you like to create new profile?',
            btnCancelText: 'No',
            btnCancelOnPress: () {},
            btnOkText: 'Yes',
            btnOkOnPress: () {
              isNewProfile.value = true;
            },
          ).show();
          return;
        }

        var result = (jsonDecode(response.body));

        insuredNameList.value = [];
        for (var row in result['record']) {
          insuredNameList.value.add(row);
        }

        isLoading.value = false;
      } catch (_) {
        printError();
      }
    }

    useEffect(() {
      birthDateController.value.text = policy.value.birthDate ?? '';
      fullNameController.value.text = policy.value.fullName ?? '';
      emailController.value.text = policy.value.email ?? '';
      selectedGender.value = policy.value.gender;
      streetAddressController.value.text = policy.value.streetAddress ?? '';
      citizenshipController.value.text = policy.value.citizenship ?? '';
      birthPlaceController.value.text = policy.value.birthPlace ?? '';
      brgyController.value.text = policy.value.brgy ?? '';
      cityController.value.text = policy.value.city ?? '';
      provinceController.value.text = policy.value.province ?? '';
      zipController.value.text = policy.value.zip ?? '';
      countryController.value.text = 'Philippines';
      phoneController.value.text = policy.value.phoneNo ?? '';
      mobileController.value.text = policy.value.mobileNo ?? '';
      tinController.value.text = policy.value.tin ?? '';
      sourceIncomeValue.value = policy.value.incomeSource;
      typeIdValue.value = policy.value.idType;
      personalIdController.value.text = policy.value.idNo ?? '';
      taggingController.value.text =
          policy.value.taggingId == '0' ? 'Individual' : '';
      return null;
      // if (policy.value.profileId != '' && policy.value.profileId != 'NEW') {
      //   profileId.value = policy.value.profileId;
      //   searchProfileByKeyword();
      // }
      // return null;
    }, []);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            children: [
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        InputTextField(
                          label: 'Full Name',
                          controller: fullNameController.value,
                          focusNode: focusNode,
                          onChanged: (value) {
                            fullNameController.value.text = value;
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) async {
                            focusNode.unfocus();
                            policy.value =
                                policy.value.copyWith(fullName: value);
                            // await searchProfileByKeyword();
                          },
                          // initialValue: policy.value.fullName,
                          validators: (value) {
                            if (value!.isEmpty) {
                              return 'Full name is required';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        InputTextField(
                          label: 'Date of Birth',
                          controller: birthDateController.value,
                          readOnly: true,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            policy.value =
                                policy.value.copyWith(birthDate: value);
                            updatePolicy(policy.value);
                          },
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (picked != null) {
                              birthDateController.value.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              policy.value = policy.value.copyWith(
                                birthDate: birthDateController.value.text,
                              );
                              updatePolicy(policy.value);
                            }
                          },
                          validators: (value) {
                            if (value!.isEmpty) {
                              return 'Date of Birth is required';
                            }

                            return null;
                          },
                          // initialValue: policy.value.birthDate,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (fullNameController.value.text.isEmpty &&
                          birthDateController.value.text.isEmpty) {
                        showTopSnackBar(
                          Overlay.of(context),
                          displayDuration: const Duration(seconds: 1),
                          const CustomSnackBar.error(
                            message:
                                "Fullname & Date of Birth is required for validation.",
                          ),
                        );
                        return;
                      }
                      if (fullNameController.value.text.isEmpty) {
                        showTopSnackBar(
                          Overlay.of(context),
                          displayDuration: const Duration(seconds: 1),
                          const CustomSnackBar.error(
                            message: "Fullname is required for validation.",
                          ),
                        );
                        return;
                      }
                      if (birthDateController.value.text.isEmpty) {
                        showTopSnackBar(
                          Overlay.of(context),
                          displayDuration: const Duration(seconds: 1),
                          const CustomSnackBar.error(
                            message:
                                "Date of Birth is required for validation.",
                          ),
                        );
                        return;
                      }
                      if (fullNameController.value.text.isNotEmpty &&
                          birthDateController.value.text.isNotEmpty) {
                        if (hasProfile.value) {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.question,
                            title: 'Are you sure to re-select profile again?',
                            desc: '',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              focusNode.unfocus();
                              hasProfile.value = false;
                              policy.value = policy.value.copyWith(
                                fullName: fullNameController.value.text,
                                birthDate: birthDateController.value.text,
                                // address1: '',
                                // address2: '',
                                // email: '',
                                // mobileNo: '',
                                // phoneNo: '',
                                // tin: '',
                              );
                              await searchProfileByKeyword();
                            },
                          ).show();
                        } else {
                          focusNode.unfocus();
                          policy.value = policy.value.copyWith(
                            fullName: fullNameController.value.text,
                            birthDate: birthDateController.value.text,
                            // address1: '',
                            // address2: '',
                            // email: '',
                            // birthDate: '',
                            // mobileNo: '',
                            // phoneNo: '',
                            // tin: '',
                          );
                          await searchProfileByKeyword();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    label: const Icon(
                      Icons.search,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ],
              ),
              if (hasProfile.value || isNewProfile.value)
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("First Name"),
                          InputTextField(
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'First Name',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(firstName: value);
                              updatePolicy(policy.value);
                            },
                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.firstName,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Middle Name"),
                          InputTextField(
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Middle Name',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(middleName: value);
                              updatePolicy(policy.value);
                            },
                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.middleName,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Last Name"),
                          InputTextField(
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Last Name',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(lastName: value);
                              updatePolicy(policy.value);
                            },
                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.lastName,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Birth Place"),
                          InputTextField(
                            // controller: birthPlaceController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Birth Place',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(birthPlace: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.birthPlace,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Citizenship"),
                          InputTextField(
                            // controller: citizenshipController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Citizenship',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(citizenship: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.citizenship,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Gender"),
                          CustomDropdownButton(
                            value: selectedGender.value,
                            items: ['Male', 'Female'].map(
                              (item) {
                                return DropdownMenuItem(
                                  value: item.toString(),
                                  child: Text(item),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(gender: value);
                              updatePolicy(policy.value);
                              selectedGender.value = value.toString();
                            },
                            validator: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Email Address"),
                          InputTextField(
                            // controller: emailController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Email Address',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(email: value);
                              updatePolicy.call(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmail(value),
                            initialValue: policy.value.email,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Street Address"),
                          InputTextField(
                            // controller: streetAddressController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText:
                                'Block/ Lot/ Phase No/ Unit/ Street/ Village/ Subdivision',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(streetAddress: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.streetAddress,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Barangay"),
                          InputTextField(
                            // controller: brgyController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Barangay',
                            onChanged: (value) {
                              policy.value = policy.value.copyWith(brgy: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.brgy,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("City"),
                          InputTextField(
                            // controller: cityController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'City',
                            onChanged: (value) {
                              policy.value = policy.value.copyWith(city: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.city,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Province"),
                          InputTextField(
                            // controller: provinceController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Province',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(province: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            initialValue: policy.value.province,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Zip"),
                          InputTextField(
                            // controller: zipController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Zip',
                            onChanged: (value) {
                              policy.value = policy.value.copyWith(zip: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),

                            initialValue: policy.value.zip,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Country"),
                          InputTextField(
                            controller: countryController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Country',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(country: value);
                              updatePolicy(policy.value);
                            },
                            readOnly: true,
                            validators: (value) =>
                                TextFieldValidators.validateEmptyField(value),
                            // initialValue: policy.value.country,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Phone Number (optional)"),
                          InputTextField(
                            // controller: phoneController.value,
                            hintText: 'Phone Number',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(phoneNo: value);
                              updatePolicy(policy.value);
                            },

                            initialValue: policy.value.phoneNo,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Mobile Number"),
                          InputTextField(
                            // controller: mobileController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Mobile Number',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(mobileNo: value);
                              updatePolicy(policy.value);
                            },

                            validators: (value) =>
                                TextFieldValidators.validatePhoneNumber(value),
                            initialValue: policy.value.mobileNo,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("TIN #"),
                          InputTextField(
                            hintText: 'TIN #',
                            // controller: tinController.value,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              policy.value = policy.value.copyWith(tin: value);
                              updatePolicy.call(policy.value);
                            },
                            // validators: (value) =>
                            //     TextFieldValidators.validateTIN(value),
                            initialValue: policy.value.tin,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tagging"),
                          InputTextField(
                            controller: taggingController.value,
                            hintText: 'Tagging',
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(taggingId: '0');
                              updatePolicy.call(policy.value);
                            },
                            readOnly: true,
                            // initialValue: policy.value.taggingId == '0'
                            //     ? 'Individual'
                            //     : '',
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Source of Income"),
                          CustomDropdownButton<String>(
                            value: sourceIncomeValue.value,
                            items: sourceIncome.value.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'],
                                child: Text(item['code']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              sourceIncomeValue.value = value;
                              policy.value = policy.value.copyWith(
                                incomeSource: value,
                              );
                              updatePolicy.call(policy.value);
                            },
                            // validator: (value) =>
                            //     TextFieldValidators.validateEmptyField(value),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Type of ID"),
                          CustomDropdownButton<String>(
                            value: typeIdValue.value,
                            items: typeId.value.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'],
                                child: Text(item['description']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              typeIdValue.value = value;
                              policy.value = policy.value.copyWith(
                                idType: value,
                              );
                              updatePolicy.call(policy.value);
                            },
                            // validator: (value) =>
                            //     TextFieldValidators.validateEmptyField(value),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Personal ID"),
                          InputTextField(
                            hintText: "Enter Personal ID",
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            // controller: personalIdController.value,
                            // validators: (value) =>
                            //     TextFieldValidators.validateEmptyField(value),

                            onChanged: (value) {
                              policy.value = policy.value.copyWith(
                                idNo: value,
                              );
                              updatePolicy.call(policy.value);
                            },
                            initialValue: policy.value.idNo,
                          ),
                        ],
                      ),
                    ].withSpaceBetween(height: 10),
                  ),
                ),
              if (isLoading.value)
                const Center(
                  child: SpinKitChasingDots(color: ColorPalette.primaryColor),
                ),
              if (isLoading.value == false)
                if (insuredNameList.value.isNotEmpty)
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: insuredNameList.value
                          .map(
                            (profile) {
                              return GestureDetector(
                                onTap: () {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.question,
                                    title:
                                        'Are you sure to select this profile?',
                                    desc: '',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      // updatePolicy(policy.value);
                                      await getInsuredDetails(profile['id']);
                                    },
                                  ).show();
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            profile['id'],
                                          ),
                                          Text(
                                            profile['name'],
                                          ),
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    profile['birthdate'])),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                          .toList()
                          .withSpaceBetween(height: 5),
                    ),
                  ),
              // if (hasProfile.value && isProfileCorrect.value == 'No')
              //   SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: () {},
              //       style: OutlinedButton.styleFrom(
              //         backgroundColor: const Color(0xfffe5000),
              //       ),
              //       child: const Text(
              //         'Update Profile',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontFamily: 'OpenSans',
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // if (hasProfile.value)
              //   Row(
              //     children: [
              //       const Text('Is the Insured Profile is correct?'),
              //       const Spacer(),
              //       Row(
              //         children: [
              //           ProfileUpdateRadio(
              //             value: 'Yes',
              //             selectedValue: isProfileCorrect.value,
              //             onChanged: (value) {
              //               isProfileCorrect.value = value!;
              //             },
              //           ),
              //           ProfileUpdateRadio(
              //             value: 'No',
              //             selectedValue: isProfileCorrect.value,
              //             onChanged: (value) {
              //               isProfileCorrect.value = value!;
              //             },
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
            ].withSpaceBetween(height: 10),
          ),
        ),
      ),
    );
  }
}

profileNotFoundModal(context, {Function()? onSuccess, Function()? onFailed}) {
  AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    title: 'Profile Validation',
    desc: 'Profile Not Found!\nProceed to create new profile...',
    btnCancelText: 'Try Again',
    btnOkText: 'Proceed',
    btnCancelOnPress: () {
      if (onFailed != null) {
        onFailed();
      }
    },
    btnOkOnPress: () async {
      if (onSuccess != null) {
        onSuccess();
      }
    },
  ).show();
}

class ProfileUpdateRadio extends StatefulWidget {
  const ProfileUpdateRadio({
    super.key,
    required this.value,
    required this.selectedValue,
    this.onChanged,
  });

  final String value;
  final String selectedValue;
  final Function(String?)? onChanged;
  @override
  State<ProfileUpdateRadio> createState() => ProfileUpdateRadioState();
}

class ProfileUpdateRadioState extends State<ProfileUpdateRadio> {
  @override
  Widget build(BuildContext context) {
    // bool isSelected = widget.value == widget.selectedValue;
    return GestureDetector(
      onTap: () {
        widget.onChanged!(widget.value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Radio(
              value: widget.value,
              groupValue: widget.selectedValue,
              onChanged: widget.onChanged,
              activeColor: ColorPalette.primaryColor,
            ),
            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

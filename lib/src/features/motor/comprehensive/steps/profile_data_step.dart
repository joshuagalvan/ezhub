// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/features/navbar/quotation/form.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/models/policy.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileDataStep extends HookWidget {
  const ProfileDataStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
    required this.onProfileChecked,
    this.form,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;
  final Function(bool) onProfileChecked;
  final GlobalKey<FormState>? form;

  @override
  Widget build(BuildContext context) {
    final fullNameController = useState(TextEditingController());
    final dateTimeController = useState(TextEditingController());
    final emailController = useState(TextEditingController());
    final address1Controller = useState(TextEditingController());
    final address2Controller = useState(TextEditingController());
    final taggingController = useState(TextEditingController());
    final phoneController = useState(TextEditingController());
    final mobileController = useState(TextEditingController());
    final ValueNotifier<String?> profileId = useState(policy.value.profileId);
    final ValueNotifier<List<dynamic>> profileList = useState([]);
    final isLoading = useState(false);
    final hasProfile = useState(false);
    // final isProfileCorrect = useState('Yes');
    final selectedGender = useState('Male');
    // final insuredTin = useState('');
    // final insuredAddress = useState('');
    final tagging = useState(0);
    final taggingText = useState('');
    final focusNode = FocusNode();

    Future<void> searchProfileByKeyword() async {
      final userDataResult = GetStorage().read('userData');
      final userData = UserModel.fromJson(userDataResult);
      isLoading.value = true;
      await Api()
          .searchProfileByKeyword(policy.value.fullName, userData.agentCode,
              dateTimeController.value.text)
          .then((res) {
        // Navigator.pop(context);
        isLoading.value = false;
        if (res['record'].contains('Null')) {
          profileNotFoundModal(
            context,
            onSuccess: () {
              profileList.value = [];
              profileId.value = 'NEW';
              onProfileChecked(true);
            },
          );
        } else {
          profileList.value = res['record'];
        }
      });
    }

    useEffect(() {
      dateTimeController.value.text = policy.value.dateOfBirth ?? '';
      fullNameController.value.text = policy.value.fullName ?? '';

      return null;
      // if (policy.value.profileId != '' && policy.value.profileId != 'NEW') {
      //   profileId.value = policy.value.profileId;
      //   searchProfileByKeyword();
      // }
      // return null;
    }, []);

    void getInsuredDetails(String insCode) async {
      try {
        final response = await http.post(
            Uri.parse(
                'http://10.52.2.124/motor/getInsuredAdditionalDetails_json/'),
            body: {
              'ins_code': insCode,
            });
        var result = (jsonDecode(response.body));
        if (GetUtils.isEmail(result['email'])) {
          hasProfile.value = true;
          profileList.value.clear();
          policy.value.email = result['email'];
          policy.value.address1 = result['address_1'];
          policy.value.address2 = result['address_2'];
          tagging.value = result['tagging'];
          emailController.value.text = result['email'];
          address1Controller.value.text = result['address_1'];
          address2Controller.value.text = result['address_2'];
          phoneController.value.text = policy.value.phoneNo ?? '';
          mobileController.value.text = policy.value.mobileNo ?? '';
          dateTimeController.value.text = result['birthday'];
          selectedGender.value = policy.value.gender ?? 'Male';
          onProfileChecked(true);

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

    return PopScope(
      canPop: profileId.value == null,
      onPopInvokedWithResult: (canPop, result) {
        if (!canPop) {
          profileId.value = null;
          profileList.value = [];
        }
      },
      child: Container(
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
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            controller: dateTimeController.value,
                            readOnly: true,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              policy.value =
                                  policy.value.copyWith(dateOfBirth: value);
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
                                dateTimeController.value.text =
                                    DateFormat('yyyy-MM-dd').format(picked);
                                policy.value = policy.value.copyWith(
                                    dateOfBirth: dateTimeController.value.text);
                                updatePolicy(policy.value);
                              }
                            },
                            validators: (value) {
                              if (value!.isEmpty) {
                                return 'Date of Birth is required';
                              }

                              return null;
                            },
                            // initialValue: policy.value.dateOfBirth,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (fullNameController.value.text.isEmpty &&
                            dateTimeController.value.text.isEmpty) {
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
                        if (dateTimeController.value.text.isEmpty) {
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
                            dateTimeController.value.text.isNotEmpty) {
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
                                  address1: '',
                                  address2: '',
                                  email: '',
                                  dateOfBirth: dateTimeController.value.text,
                                  mobileNo: '',
                                  phoneNo: '',
                                  tin: '',
                                );
                                await searchProfileByKeyword();
                              },
                            ).show();
                          } else {
                            focusNode.unfocus();
                            policy.value = policy.value.copyWith(
                              fullName: fullNameController.value.text,
                              dateOfBirth: dateTimeController.value.text,
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
                // if (profileId.value != 'NEW')
                //   TextButton(
                //     onPressed: () async {
                //       showDialog(
                //         context: context,
                //         builder: (context) => const CustomLoadingDialog(),
                //       );
                //       await searchProfileByKeyword();
                //     },
                //     child: const Text('Find Profile'),
                //   ),
                if (hasProfile.value)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        InputTextField(
                          controller: emailController.value,
                          hintText: 'Email Address',
                          onChanged: (value) {
                            policy.value = policy.value.copyWith(email: value);
                            updatePolicy(policy.value);
                          },
                          readOnly: true,
                          // initialValue: policy.value.email,
                        ),
                        InputTextField(
                          controller: address1Controller.value,
                          hintText: 'Address 1',
                          onChanged: (value) {
                            policy.value =
                                policy.value.copyWith(address1: value);
                            updatePolicy(policy.value);
                          },
                          readOnly: true,
                          // initialValue: policy.value.address1,
                        ),
                        InputTextField(
                          controller: address2Controller.value,
                          hintText: 'Address 2',
                          onChanged: (value) {
                            policy.value =
                                policy.value.copyWith(address2: value);
                            updatePolicy(policy.value);
                          },
                          readOnly: true,
                          // initialValue: policy.value.address2,
                        ),
                        CustomDropdownButton(
                          items: ['Male', 'Female'].map(
                            (item) {
                              return DropdownMenuItem(
                                value: item.toString(),
                                child: Text(item),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            policy.value = policy.value.copyWith(gender: value);
                            updatePolicy(policy.value);
                            selectedGender.value = value.toString();
                          },
                        ),
                        InputTextField(
                          controller: phoneController.value,
                          hintText: 'Phone Number',
                          onChanged: (value) {},
                          readOnly: true,
                          // initialValue: policy.value.phoneNo,
                        ),
                        InputTextField(
                          controller: mobileController.value,
                          hintText: 'Mobile Number',
                          onChanged: (value) {},
                          readOnly: true,
                          // initialValue: policy.value.mobileNo,
                        ),
                        InputTextField(
                          controller: taggingController.value,
                          hintText: 'Tagging',
                          onChanged: (value) {},
                          readOnly: true,
                          // initialValue: taggingText.value,
                        ),
                      ].withSpaceBetween(height: 10),
                    ),
                  ),
                if (profileId.value != null && profileId.value == 'NEW')
                  SingleChildScrollView(
                    child: Column(
                        children: [
                      // InputTextField(
                      //   label: 'Date of Birth',
                      //   controller: dateTimeController.value,
                      //   readOnly: true,
                      //   autoValidateMode: AutovalidateMode.onUserInteraction,
                      //   // onChanged: (value) {
                      //   //   policy.value = policy.value.copyWith(dateOfBirth: value);
                      //   //   updatePolicy(policy.value);
                      //   // },

                      //   onTap: () async {
                      //     final picked = await showDatePicker(
                      //       context: context,
                      //       initialDate: DateTime.now(),
                      //       firstDate: DateTime(1900),
                      //       lastDate: DateTime.now(),
                      //     );

                      //     if (picked != null) {
                      //       dateTimeController.value.text =
                      //           DateFormat('yyyy-MM-dd').format(picked);
                      //       policy.value = policy.value.copyWith(
                      //           dateOfBirth: dateTimeController.value.text);
                      //       updatePolicy(policy.value);
                      //     }
                      //   },
                      //   validators: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Date of Birth is required';
                      //     }

                      //     return null;
                      //   },
                      //   // initialValue: policy.value.dateOfBirth,
                      // ),
                      InputTextField(
                        label: 'Address 1',
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          policy.value = policy.value.copyWith(address1: value);
                          updatePolicy(policy.value);
                        },
                        validators: (value) {
                          if (value!.isEmpty) {
                            return 'Address 1 is required';
                          }

                          return null;
                        },
                        initialValue: policy.value.address1,
                      ),
                      InputTextField(
                        label: 'Address 2',
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          policy.value = policy.value.copyWith(address2: value);
                          updatePolicy(policy.value);
                        },
                        validators: (value) {
                          if (value!.isEmpty) {
                            return 'Address 2 is required';
                          }

                          return null;
                        },
                        initialValue: policy.value.address2,
                      ),
                      InputTextField(
                        label: 'Email Address',
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          policy.value = policy.value.copyWith(email: value);
                          updatePolicy(policy.value);
                        },
                        validators: (value) {
                          if (value == null) {
                            return 'Email is required';
                          }
                          if (value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Invalid email format';
                          }

                          return null;
                        },
                        initialValue: policy.value.email,
                      ),
                      InputTextField(
                        label: 'Phone Number (optional)',
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          policy.value = policy.value.copyWith(phoneNo: value);
                          updatePolicy(policy.value);
                        },
                        // validators: (value) {
                        //   if (!GetUtils.isPhoneNumber(value ?? '')) {
                        //     return 'Phone Number must start with +639';
                        //   }

                        //   return null;
                        // },
                        initialValue: policy.value.phoneNo,
                      ),
                      InputTextField(
                        label: 'Mobile Number eg. 09XXXXXXXXX',
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          policy.value = policy.value.copyWith(mobileNo: value);
                          updatePolicy(policy.value);
                        },
                        validators: (value) {
                          if (value!.isEmpty) {
                            return 'Mobile Number is required';
                          }

                          if (!GetUtils.isLengthEqualTo(value, 11)) {
                            return 'Mobile Number must be 11 digits only';
                          }

                          return null;
                        },
                        initialValue: policy.value.mobileNo,
                      ),
                      InputTextField(
                        label: 'TIN #',
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          policy.value = policy.value.copyWith(tin: value);
                          updatePolicy(policy.value);
                        },
                        validators: (value) =>
                            TextFieldValidators.validateTIN(value),
                        initialValue: policy.value.tin,
                      ),
                    ].withSpaceBetween(height: 10)),
                  ),
                if (isLoading.value)
                  const Center(
                    child: SpinKitChasingDots(color: ColorPalette.primaryColor),
                  ),
                if (isLoading.value == false)
                  if (profileList.value.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: profileList.value
                              .map(
                                (profile) {
                                  final textColor =
                                      (profileId.value == profile['id'])
                                          ? Colors.white
                                          : Colors.black;
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
                                        btnOkOnPress: () {
                                          profileId.value = profile['id'];
                                          policy.value.profileId =
                                              profile['id'];
                                          updatePolicy(policy.value);
                                          getInsuredDetails(profile['id']);
                                        },
                                      ).show();
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 1,
                                        color:
                                            (profileId.value == profile['id'])
                                                ? Colors.blueAccent
                                                : Colors.white,
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
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              Text(
                                                profile['name'],
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateTime.parse(
                                                        profile['birthdate']
                                                            .toString())),
                                                style:
                                                    TextStyle(color: textColor),
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
                    ),
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
                // if (isProfileCorrect.value == 'No')
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
              ].withSpaceBetween(height: 10),
            ),
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

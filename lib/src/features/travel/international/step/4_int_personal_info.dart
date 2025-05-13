import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class InternationalPersonalInfo extends StatefulHookWidget {
  const InternationalPersonalInfo({
    super.key,
    required this.form,
    required this.intData,
    required this.onPrivacyChecked,
    required this.onTermsChecked,
  });

  final GlobalKey<FormState>? form;
  final ValueNotifier<TravelModel> intData;
  final Function(bool) onPrivacyChecked;
  final Function(bool) onTermsChecked;

  @override
  State<InternationalPersonalInfo> createState() =>
      _InternationalPersonalInfoState();
}

class _InternationalPersonalInfoState extends State<InternationalPersonalInfo> {
  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  String? validateAge(DateTime birthDate, bool isMinor) {
    final int age = calculateAge(birthDate);
    final DateTime today = DateTime.now();
    final DateTime minDate = today.subtract(const Duration(days: 28));

    if (isMinor) {
      if (birthDate.isAfter(minDate)) {
        return "Date of birth must be at least 4 weeks old.";
      }
      if (age < 0 || age > 17) {
        return "Minors must be between 4 weeks to 17 years old.";
      }
    } else {
      if (age < 18) {
        return "Adults must be 18 years or older.";
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedTitle = useState<String?>(null);
    final selectedGender = useState<String?>(null);
    final firstNameController = useTextEditingController();
    final middleNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final dateOfBirthController = useTextEditingController();
    final passportController = useTextEditingController();
    final govIdController = useTextEditingController();
    final occupationController = useTextEditingController();
    final addressController = useTextEditingController();
    final cityController = useTextEditingController();
    final provinceController = useTextEditingController();
    final zipController = useTextEditingController();
    final emergencyNameController = useTextEditingController();
    final emergencyMobileController = useTextEditingController();
    final emergencyRelationshipController = useTextEditingController();
    final isPrivacyChecked = useState(false);
    final isTermsChecked = useState(false);
    final isPromotionChecked = useState(false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Form(
        key: widget.form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleRequiredText(text: 'Title '),
                        CustomDropdownButton<String>(
                          value: selectedTitle.value,
                          hintText: 'Mr.',
                          items: ['Mr.', 'Ms.'].map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedTitle.value = value;
                            widget.intData.value = widget.intData.value
                                .copyWith(title: selectedTitle.value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleRequiredText(text: 'FirstName '),
                        InputTextField(
                          hintText: '',
                          controller: firstNameController,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validators: (value) =>
                              TextFieldValidators.validateEmptyField(value),
                          onChanged: (value) {
                            widget.intData.value =
                                widget.intData.value.copyWith(firstName: value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleRequiredText(text: 'Middle Name '),
                        InputTextField(
                          hintText: '',
                          controller: middleNameController,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validators: (value) =>
                              TextFieldValidators.validateEmptyField(value),
                          onChanged: (value) {
                            widget.intData.value = widget.intData.value
                                .copyWith(middleName: value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleRequiredText(text: 'Last Name '),
                        InputTextField(
                          hintText: '',
                          controller: lastNameController,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validators: (value) =>
                              TextFieldValidators.validateEmptyField(value),
                          onChanged: (value) {
                            widget.intData.value =
                                widget.intData.value.copyWith(lastName: value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Gender '),
              CustomDropdownButton<String>(
                value: selectedGender.value,
                hintText: '',
                items: ['Male', 'Female'].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedGender.value = value;
                  widget.intData.value = widget.intData.value
                      .copyWith(gender: selectedGender.value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Date of Birth '),
              InputTextField(
                hintText: '',
                controller: dateOfBirthController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );

                  if (picked != null) {
                    final error = validateAge(picked, false);
                    if (error == null) {
                      dateOfBirthController.text =
                          DateFormat('dd-MM-yyyy').format(picked);
                      widget.intData.value = widget.intData.value.copyWith(
                          dateOfBirth: dateOfBirthController.value.text);
                    } else {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        displayDuration: const Duration(seconds: 1),
                        CustomSnackBar.info(
                          message: error,
                        ),
                      );
                    }
                  }
                },
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Email '),
              InputTextField(
                hintText: '',
                controller: emailController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                validators: (value) => TextFieldValidators.validateEmail(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(email: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Mobile Number '),
              InputTextField(
                hintText: '',
                controller: phoneController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                validators: (value) =>
                    TextFieldValidators.validatePhoneNumber(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(phone: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Passport Number ', isRequired: false),
              InputTextField(
                hintText: '',
                controller: passportController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(passportId: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Identification Number '),
              InputTextField(
                hintText: 'TIN, any Government ID, School ID',
                controller: govIdController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(govId: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Occupation ', isRequired: false),
              InputTextField(
                hintText: '',
                controller: occupationController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(occupation: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Address '),
              InputTextField(
                hintText: '',
                controller: addressController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(address: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'City '),
              InputTextField(
                hintText: '',
                controller: cityController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(city: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Province '),
              InputTextField(
                hintText: '',
                controller: provinceController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(province: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Country '),
              InputTextField(
                hintText: '',
                controller: TextEditingController(text: 'Philippines'),
                readOnly: true,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Zip '),
              InputTextField(
                hintText: '',
                controller: zipController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(zip: value);
                },
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Center(
                child: Text(
                  'Emergency Contact',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Name '),
              InputTextField(
                hintText: '',
                controller: emergencyNameController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(emergencyName: value);
                },
              ),
              const SizedBox(height: 10),
              _titleRequiredText(text: 'Mobile Number '),
              InputTextField(
                hintText: '',
                controller: emergencyMobileController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value =
                      widget.intData.value.copyWith(emergencyMobile: value);
                },
              ),
              _titleRequiredText(text: 'Relationship with Insured '),
              InputTextField(
                hintText: '',
                controller: emergencyRelationshipController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
                onChanged: (value) {
                  widget.intData.value = widget.intData.value
                      .copyWith(emergencyRelationship: value);
                },
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              if (int.parse(widget.intData.value.noOfAdult ?? '0') > 1)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      (int.parse(widget.intData.value.noOfAdult ?? '0')) - 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _buildAdditionalInfo(
                      type: 'Adult',
                      data: (widget.intData.value.adultsPersonalData)![index],
                      onUpdate: (updatedData) {
                        final updatedList = List<Map<String, dynamic>>.from(
                            widget.intData.value.adultsPersonalData!);
                        updatedList[index] = updatedData;
                        widget.intData.value = widget.intData.value.copyWith(
                          adultsPersonalData: updatedList,
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              if (int.parse(widget.intData.value.noOfMinor ?? '0') > 1)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: int.parse(widget.intData.value.noOfMinor ?? '0'),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _buildAdditionalInfo(
                      type: 'Minor',
                      data: (widget.intData.value.minorsPersonalData)![index],
                      onUpdate: (updatedData) {
                        final updatedList = List<Map<String, dynamic>>.from(
                            widget.intData.value.minorsPersonalData!);
                        updatedList[index] = updatedData;
                        widget.intData.value = widget.intData.value.copyWith(
                          minorsPersonalData: updatedList,
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I have read and understood and voluntarily agreed to the collection, use, and disclosure of my personal data in accordance with FPG Privacy Policy.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                value: isPrivacyChecked.value,
                onChanged: (newBool) {
                  widget.onPrivacyChecked(newBool ?? false);
                  isPrivacyChecked.value = newBool ?? false;
                  widget.intData.value = widget.intData.value.copyWith(
                      isPersonalPrivacyChecked: isPrivacyChecked.value);
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I have read and agree to the Terms, Conditions, and Exclusions of this product.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                value: isTermsChecked.value,
                onChanged: (newBool) {
                  widget.onTermsChecked(newBool ?? false);
                  isTermsChecked.value = newBool ?? false;
                  widget.intData.value = widget.intData.value
                      .copyWith(isPersonalTermsChecked: isTermsChecked.value);
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I agree to receive promotional offers, exclusive promotions for policyholders, and other distributed communication via SMS, E-Mail, and Phone Call.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                value: isPromotionChecked.value,
                onChanged: (newBool) {
                  isPromotionChecked.value = newBool ?? false;
                  widget.intData.value = widget.intData.value.copyWith(
                      isPersonalPromotionChecked: isPromotionChecked.value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleRequiredText({required String text, bool isRequired = true}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
          ),
          if (isRequired)
            const TextSpan(
              text: "*",
              style: TextStyle(
                color: Colors.red,
              ),
            )
        ],
      ),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAdditionalInfo({
    required String type,
    required Map<String, dynamic>? data,
    required ValueChanged<Map<String, dynamic>> onUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Personal Information ($type)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorPalette.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleRequiredText(text: 'First Name '),
                  InputTextField(
                    hintText: '',
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validators: (value) =>
                        TextFieldValidators.validateEmptyField(value),
                    onChanged: (value) {
                      final updatedData = {...data!, "firstName": value};
                      onUpdate(updatedData);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleRequiredText(text: 'Last Name '),
                  InputTextField(
                    hintText: '',
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validators: (value) =>
                        TextFieldValidators.validateEmptyField(value),
                    onChanged: (value) {
                      final updatedData = {...data!, "lastName": value};
                      onUpdate(updatedData);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleRequiredText(text: 'Date of Birth '),
            InputTextField(
              hintText: '',
              controller: TextEditingController(text: data!["dateOfBirth"]),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validators: (value) =>
                  TextFieldValidators.validateEmptyField(value),
              helperText: type == 'Adult'
                  ? 'Age Eligibility: Travelers must be between 18 and 75 years old on the specified travel dates.'
                  : 'Age Eligibility: between 4 weeks to 17 years old',
              prefixIcon: const Icon(Icons.calendar_month_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                );

                if (picked != null) {
                  final error = validateAge(picked, type == 'Minor');
                  if (error == null) {
                    final updatedData = {
                      ...data,
                      "dateOfBirth": DateFormat('yyyy-MM-dd').format(picked)
                    };
                    onUpdate(updatedData);
                  } else {
                    showTopSnackBar(
                      // ignore: use_build_context_synchronously
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      CustomSnackBar.info(
                        message: error,
                      ),
                    );
                  }
                }
              },
              onChanged: (value) {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleRequiredText(text: 'Gender '),
            CustomDropdownButton<String>(
              value: data['gender'] == '' ? null : data['gender'],
              hintText: '',
              items: ['Male', 'Female'].map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                final updatedData = {
                  ...data,
                  "gender": value,
                };
                onUpdate(updatedData);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        _titleRequiredText(text: 'Passport '),
        InputTextField(
          hintText: '',
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validators: (value) => TextFieldValidators.validateEmptyField(value),
          onChanged: (value) {
            final updatedData = {
              ...data,
              "passport": value,
            };
            onUpdate(updatedData);
          },
        ),
      ],
    );
  }
}

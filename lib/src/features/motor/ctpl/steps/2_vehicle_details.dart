// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_dropdown_field.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/authentication/models/carcompany_model.dart';
import 'package:simone/src/features/authentication/models/carmake_model.dart';
import 'package:simone/src/features/authentication/models/cartype_model.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VehicleDetails extends HookWidget {
  const VehicleDetails({
    super.key,
    required this.policy,
    required this.updatePolicy,
    required this.form,
  });

  final ValueNotifier<CTPLPolicy> policy;
  final Function(CTPLPolicy) updatePolicy;
  final GlobalKey<FormState>? form;

  @override
  Widget build(BuildContext context) {
    final listManufactureYear = useState([]);
    final selectedManufactureYear = useState<String?>(null);
    final carCompanyValue = useState<String?>(null);
    final carCompanyId = useState<String?>(null);
    final carMakeModelValue = useState<String?>(null);
    final carMakeModelId = useState<String?>(null);
    final carTypeValue = useState<String?>(null);
    final carTypeId = useState<String?>(null);
    final transmissionValue = useState<String?>(null);

    final carCompanyController = useState(TextEditingController());
    final carMakeController = useState(TextEditingController());
    final chassisNumberText = useState(TextEditingController());
    final engineNumberText = useState(TextEditingController());
    final variantText = useState(TextEditingController());
    final conductionStickerText = useState(TextEditingController());
    final mvFileText = useState(TextEditingController());
    final colorText = useState(TextEditingController());
    final carCompanyFocusNode = useState(FocusNode());
    final carMakeModelFocusNode = useState(FocusNode());

    final carCompanyList = useState<List<CarCompanyList>>([]);
    final carMakeList = useState<List<CarMakeList>>([]);
    final carTypeList = useState<List<dynamic>>([]);
    final carVariant = useState<List<dynamic>>([]);
    final isCarCompanyListLoading = useState(false);
    final isCarMakeListLoading = useState(false);
    final isCarTypeListLoading = useState(false);
    // final isCarVariantLoading = useState(false);
    final selectedCarVariant = useState<String?>(null);

    List<Map<String, dynamic>> transmission = [
      {'text': 'Automatic', 'value': 'Automatic'},
      {'text': 'Manual', 'value': 'Manual'},
    ];

    Future<List<CarTypeList>> getCarType() async {
      if (carMakeModelId.value == null) {
        return [];
      }
      try {
        final response = await http.post(
            Uri.parse(
                'http://10.52.2.124/motorquotation/getCarTypeOfBodyByPiraModel_json/'),
            body: {'car_make_model_id': carMakeModelId.value, 'toc': '1'});
        final carType = (jsonDecode(response.body));
        isCarTypeListLoading.value = false;
        if (response.statusCode == 200) {
          carTypeValue.value = carType['type'];
          carTypeId.value = carType['id'];
          policy.value = policy.value.copyWith(
            carType: [carType].first['type'],
            carTypeId: [carType].first['id'],
          );
          updatePolicy(policy.value);
          return [
            CarTypeList(
                id: carType['id'],
                status: carType['status'],
                typeId: carType['type_id'],
                type: carType['type'],
                capacity: carType['capacity'])
          ];
        }
      } on SocketException {
        throw Exception('No Internet');
      }
      throw Exception('Error Fetching Data');
    }

    Future<List<CarMakeList>> getCarMake() async {
      isCarMakeListLoading.value = true;
      if (carCompanyId.value == null) {
        return [];
      }

      try {
        final response = await http.post(
            Uri.parse(
                'http://10.52.2.124/motorquotation/getPiraCarModelByCarCompanyId_json/'),
            body: {'car_company_id': carCompanyId.value});

        isCarMakeListLoading.value = false;
        final carMake = (jsonDecode(response.body)) as List;
        if (response.statusCode == 200) {
          carMakeList.value = carMake.map((e) {
            final map = e as Map<String, dynamic>;
            return CarMakeList(id: map['id'], name: map['name']);
          }).toList();
          return carMakeList.value;
        }
      } on SocketException {
        throw Exception('No Internet');
      }
      throw Exception('Error Fetching Data');
    }

    Future<List<CarCompanyList>> getCarCompany() async {
      isCarCompanyListLoading.value = true;
      carMakeList.value.clear();
      carMakeModelValue.value = null;
      carMakeModelId.value = null;
      carTypeList.value.clear();
      carTypeId.value = null;
      carTypeValue.value = null;
      carVariant.value.clear();
      selectedCarVariant.value = null;

      try {
        final response = await http.post(Uri.parse(
            'http://10.52.2.124/motorquotation/getCarCompanyList_json/?toc=1'));
        final carCompany = (jsonDecode(response.body)) as List;
        isCarCompanyListLoading.value = false;
        if (response.statusCode == 200) {
          await getCarMake();
          carCompanyList.value = carCompany.map((e) {
            final map = e as Map<String, dynamic>;
            return CarCompanyList.fromJson(map);
          }).toList();
          return carCompanyList.value;
        }
      } on SocketException {
        throw Exception('No Internet');
      }
      throw Exception('Error Fetching Data');
    }

    Future<void> getCarVariants() async {
      dynamic modelObj = carMakeList.value.firstWhereOrNull((x) {
        return x.id == carMakeModelId.value;
      });

      if (modelObj != null) {
        dynamic models = await Api().getCarVariants(
            carModel: modelObj.name ?? '',
            carModelId: modelObj.id ?? '',
            typeOfCover: policy.value.vehicleTypeName ?? '',
            yearManufactured: selectedManufactureYear.value ?? '2024');
        if (models['data']['list'] != null) {
          carVariant.value = models['data']['list'].toList();
        } else {
          showTopSnackBar(
            Overlay.of(context),
            displayDuration: const Duration(seconds: 1),
            CustomSnackBar.info(
              message: "There is no car variant for ${carMakeModelValue.value}",
            ),
          );
        }
      }
    }

    useEffect(() {
      asyncing() async {
        await getCarCompany();
        await getCarMake();
        await getCarType();
        await getCarVariants();
        listManufactureYear.value = policy.value.listManufactureYear ?? [];
        selectedManufactureYear.value = policy.value.yearManufactured;
        carCompanyValue.value = policy.value.carMakeBrand;
        carCompanyId.value = policy.value.carMakeBrandId;
        carMakeModelValue.value = policy.value.carModel;
        carMakeModelId.value = policy.value.carModelId;
        carTypeValue.value = policy.value.carType;
        carTypeId.value = policy.value.carTypeId;

        transmissionValue.value = policy.value.transmissionType;
        selectedCarVariant.value = policy.value.carVariant;
        carCompanyController.value.text = policy.value.carMakeBrand ?? '';
        carMakeController.value.text = policy.value.carModel ?? '';
        chassisNumberText.value.text = policy.value.chassisNumber ?? '';
        engineNumberText.value.text = policy.value.engineNumber ?? '';
        variantText.value.text = policy.value.carVariant ?? '';
        conductionStickerText.value.text = policy.value.conductionSticker ?? '';
        mvFileText.value.text = policy.value.mvFileNumber ?? '';
        colorText.value.text = policy.value.color ?? '';
      }

      asyncing();

      return null;
    }, []);

    return Form(
      key: form,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Vehicle Details",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Year Manufactured: ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomDropdownButton(
                value: selectedManufactureYear.value,
                items: listManufactureYear.value.map((item) {
                  return DropdownMenuItem(
                    value: item['id'].toString(),
                    child: Text(item['name'].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  for (var row in listManufactureYear.value) {
                    if (value == row["name"].toString()) {
                      selectedManufactureYear.value = row["name"].toString();
                      policy.value = policy.value.copyWith(
                        yearManufactured: selectedManufactureYear.value,
                      );
                      updatePolicy(policy.value);
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Car Company",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              DropdownMenu(
                width: 400,
                menuHeight: 350,
                focusNode: carCompanyFocusNode.value,
                controller: carCompanyController.value,
                hintText: "Choose Option",
                requestFocusOnTap: true,
                trailingIcon: isCarCompanyListLoading.value
                    ? const Center(
                        child: SpinKitChasingDots(
                          color: ColorPalette.primaryColor,
                          size: 25,
                        ),
                      )
                    : const Icon(Icons.arrow_drop_down),
                inputDecorationTheme: InputDecorationTheme(
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
                dropdownMenuEntries: carCompanyList.value.map((e) {
                  return DropdownMenuEntry(
                    label: e.name.toString(),
                    value: e.id.toString(),
                  );
                }).toList(),
                onSelected: (String? newValue) async {
                  await getCarMake();
                  carCompanyFocusNode.value.unfocus();
                  carCompanyValue.value = carCompanyController.value.text;
                  carCompanyId.value = newValue;
                  carMakeModelValue.value = null;
                  carTypeValue.value = null;
                  policy.value = policy.value.copyWith(
                    carMakeBrandId: newValue,
                    carMakeBrand: carCompanyController.value.text,
                  );
                  updatePolicy(policy.value);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Car Make and Model: ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              FutureBuilder(
                  future: getCarMake(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        "No Available Car Make for this Car Company.",
                      );
                    }
                    return DropdownMenu(
                      width: 400,
                      menuHeight: 350,
                      focusNode: carMakeModelFocusNode.value,
                      controller: carMakeController.value,
                      hintText: "Choose Option",
                      requestFocusOnTap: true,
                      inputDecorationTheme: InputDecorationTheme(
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
                      dropdownMenuEntries: carMakeList.value.map((e) {
                        return DropdownMenuEntry(
                          value: e.id.toString(),
                          label: e.name.toString(),
                        );
                      }).toList(),
                      onSelected: (String? newValue) async {
                        carMakeModelFocusNode.value.unfocus();
                        carMakeModelValue.value = carMakeController.value.text;
                        carMakeModelId.value = newValue;
                        carTypeValue.value = null;
                        await getCarVariants();
                        policy.value = policy.value.copyWith(
                          carModelId: newValue,
                          carModel: carMakeController.value.text,
                        );
                        updatePolicy(policy.value);
                      },
                    );
                  }),
              const SizedBox(height: 10),
              const Text(
                "Car Type of Body",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              FutureBuilder<List<CarTypeList>>(
                future: getCarType(),
                builder: (context, snapshot) {
                  debugPrint(
                      'isLoading ${isCarTypeListLoading.value} ${carMakeController.value.text}');
                  if (snapshot.hasData) {
                    return CustomDropdownButton(
                      value: carTypeId.value,
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.type.toString()),
                        );
                      }).toList(),
                      isLoading: carMakeController.value.text.isEmpty
                          ? false
                          : isCarTypeListLoading.value,
                      onChanged: (String? newValue) {
                        carTypeValue.value = snapshot.data!
                            .firstWhere((value) => value.id == newValue)
                            .type;

                        carTypeId.value = newValue;
                        policy.value = policy.value.copyWith(
                          carType: carTypeValue.value,
                          carTypeId: carTypeId.value,
                        );
                        updatePolicy(policy.value);
                      },
                    );
                  } else {
                    return const Center(
                      child: SpinKitChasingDots(
                        color: ColorPalette.primaryColor,
                        size: 45,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Car Variant",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              InputDropdownField(
                hintText: 'Car Variant',
                items: carVariant.value.map<String>((item) {
                  return item['name'];
                }).toList(),
                onChanged: (selectedValue) async {
                  variantText.value.text = selectedValue ?? '';
                  selectedCarVariant.value = selectedValue ?? '';
                  policy.value = policy.value.copyWith(
                    carVariant: selectedValue ?? '',
                  );
                  updatePolicy(policy.value);
                },
                initialValue: selectedCarVariant.value,
                validator: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
              const SizedBox(height: 10),
              const Text(
                "Transmission Type:",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomDropdownButton<String>(
                value: transmissionValue.value,
                items: transmission.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(item['text']),
                  );
                }).toList(),
                onChanged: (value) {
                  transmissionValue.value = value;
                  policy.value = policy.value
                      .copyWith(transmissionType: transmissionValue.value);
                  updatePolicy(policy.value);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Chassis Number",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputTextField(
                controller: chassisNumberText.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Enter Chassis Number',
                validators: (text) =>
                    TextFieldValidators.validateChassisNumber(text),
                onChanged: (value) {
                  policy.value = policy.value.copyWith(chassisNumber: value);
                  updatePolicy(policy.value);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Engine Number",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputTextField(
                controller: engineNumberText.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Enter Engine Number',
                validators: (text) =>
                    TextFieldValidators.validateEngineNumber(text),
                onChanged: (value) {
                  policy.value = policy.value.copyWith(engineNumber: value);
                  updatePolicy(policy.value);
                },
              ),
              const SizedBox(height: 10),
              // const Text(
              //   "Variant",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontFamily: 'OpenSans',
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // InputTextField(
              //   controller: variantText.value,
              //   autoValidateMode: AutovalidateMode.onUserInteraction,
              //   hintText: 'Enter Variant',
              //   onChanged: (value) {
              //     policy.value = policy.value.copyWith(carVariant: value);
              //     updatePolicy(policy.value);
              //   },
              //   // validators: (text) {
              //   //   if (text == null || text.isEmpty) {
              //   //     return "Please Enter Variant";
              //   //   }
              //   //   return null;
              //   // },
              // ),
              // const SizedBox(height: 10),
              const Text(
                "Conduction Sticker",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputTextField(
                controller: conductionStickerText.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Enter Conduction Sticker',
                validators: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please Enter Conduction Sticker";
                  }
                  return null;
                },
                onChanged: (value) {
                  policy.value =
                      policy.value.copyWith(conductionSticker: value);
                  updatePolicy(policy.value);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "MV File Number",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputTextField(
                controller: mvFileText.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Enter MV File Number',
                validators: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please Enter MV File Number";
                  }
                  if (text.length > 15) {
                    return 'MV File Number should not be greater than 15 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  policy.value = policy.value.copyWith(mvFileNumber: value);
                  updatePolicy(policy.value);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Color",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputTextField(
                controller: colorText.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Enter Color',
                validators: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please Enter Color";
                  }
                  return null;
                },
                onChanged: (value) {
                  policy.value = policy.value.copyWith(color: value);
                  updatePolicy(policy.value);
                },
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}

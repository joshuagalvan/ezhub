// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/input_dropdown_field.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/authentication/models/carmake_model.dart';
import 'package:simone/src/features/authentication/models/cartype_model.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/models/policy.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VehicleDataStep extends HookWidget {
  const VehicleDataStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
    required this.form,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;
  final GlobalKey<FormState>? form;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<dynamic>> carBrands = useState([]);
    ValueNotifier<List<dynamic>> carModels = useState([]);
    ValueNotifier<List<dynamic>> carVariant = useState([]);
    ValueNotifier<String?> yearValue = useState(null);
    ValueNotifier<String?> selectedCarModel = useState(null);
    // ValueNotifier<String?> selectedCarType = useState(null);
    ValueNotifier<String?> selectedCarVariant = useState(null);
    ValueNotifier<int?> carBrandId = useState(null);
    ValueNotifier<int?> carModelId = useState(null);
    ValueNotifier<TextEditingController> fairMarketValue =
        useState(TextEditingController());
    ValueNotifier<TextEditingController> selectedCarType =
        useState(TextEditingController());
    final carBrandController = useState(TextEditingController());
    final carModelController = useState(TextEditingController());
    final carColorController = useState(TextEditingController());
    final carBrandFocusNode = useState(FocusNode());
    final carModelFocusNode = useState(FocusNode());
    final isReferToBranch = useState(false);
    final currentFmv = useState('0.0');

    getCarBrands() async {
      dynamic brands = await Api().getCarBrands();
      carBrands.value = brands['data'];
      // print('brands $brands');
      // carBrandId.value = brands['id'] ?? 0;
    }

    Future<List<CarTypeList>> getCarType() async {
      try {
        carModelId.value = int.parse(carModels.value.firstWhere(
            (model) => selectedCarModel.value == model['name'])['id']);

        final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motorquotation/getCarTypeOfBodyByPiraModel_json/'),
          body: {
            'car_make_model_id': carModelId.value.toString(),
            'toc': policy.value.typeOfCoverId,
          },
        );

        final carType = (jsonDecode(response.body));
        selectedCarType.value.text = carType['type'];
        policy.value.carType = selectedCarType.value.text;
        policy.value.copyWith(carType: selectedCarType.value.text);
        updatePolicy(policy.value);
        if (response.statusCode == 200) {
          return [carType].map((e) {
            final map = e as Map<String, dynamic>;
            return CarTypeList(
                id: map['id'],
                status: map['status'],
                typeId: map['typeId'],
                type: map['type'],
                capacity: map['capacity']);
          }).toList();
        }
      } on SocketException {
        throw Exception('No Internet');
      }
      throw Exception('Error Fetching Data');
    }

    getCarModels() async {
      dynamic carObj = carBrands.value.firstWhere((x) {
        return x['name'] == policy.value.carBrand;
      });
      dynamic models = await Api().getCarModels(carObj['id']);
      carModels.value = models['data'];
    }

    Future<void> getCarVariants() async {
      dynamic modelObj = carModels.value.firstWhere((x) {
        return x['name'] == policy.value.carModel;
      });

      dynamic models = await Api().getCarVariants(
          carModel: modelObj['name'],
          carModelId: modelObj['id'],
          typeOfCover: policy.value.typeOfCover!,
          yearManufactured: yearValue.value ?? '2024');
      if (models['data']['list'] != null) {
        carVariant.value = models['data']['list'].toList();
      } else {
        showTopSnackBar(
          Overlay.of(context),
          displayDuration: const Duration(seconds: 1),
          CustomSnackBar.info(
            message: "There is no car variant for ${policy.value.carModel}",
          ),
        );
      }
    }

    Future<List<CarMakeList>> getCarMake() async {
      if (carBrandId.value == null) {
        return [];
      }
      try {
        final response = await http.post(
          Uri.parse(
              'http://10.52.2.124/motorquotation/getPiraCarModelByCarCompanyId_json/'),
          body: {'car_company_id': carBrandId.value!.toString()},
        );

        final carMake = (jsonDecode(response.body)) as List;

        if (response.statusCode == 200) {
          return carMake.map((e) {
            final map = e as Map<String, dynamic>;
            return CarMakeList(id: map['id'], name: map['name']);
          }).toList();
        }
      } on SocketException {
        throw Exception('No Internet');
      }
      throw Exception('Error Fetching Data');
    }

    Future getFmv(String? carVariant) async {
      if (carVariant == null) {
        return [];
      }

      List<CarMakeList> carModel = await getCarMake();
      int index = carModel.indexWhere((element) {
        return element.id == carModelId.value.toString();
      });
      CarMakeList carMake = carModel[index];
      final data = {
        'car_make_model_id': policy.value.carModel,
        'toc_description': policy.value.typeOfCover,
        'car_model': carMake.name,
        'year': yearValue.value,
        'car_variance': carVariant,
        'toc_id': policy.value.typeOfCoverId,
      };
      final response = await http.post(
        Uri.parse('http://10.52.2.124/motorquotation/getFmvLimit_json/'),
        body: data,
      );

      if (response.body != 'null') {
        final fmv = response.body.substring(1, response.body.length - 1);
        fairMarketValue.value.text = fmv;
        policy.value.fairMarketValue = fmv;
        currentFmv.value = fmv;
        isReferToBranch.value = false;
      } else {
        isReferToBranch.value = true;
        fairMarketValue.value.text = '';
        showTopSnackBar(
          Overlay.of(context),
          displayDuration: const Duration(seconds: 1),
          const CustomSnackBar.info(
            message: "Please refer to the branch.",
          ),
        );
      }
      return true;
    }

    useEffect(() {
      asyncing() async {
        await getCarBrands();
        yearValue.value = policy.value.yearManufactured;
        selectedCarModel.value = policy.value.carModel;
        selectedCarType.value.text = policy.value.carType ?? '';
        selectedCarVariant.value = policy.value.carVariant;
        fairMarketValue.value.text = policy.value.fairMarketValue ?? '';
        currentFmv.value = policy.value.fairMarketValue ?? '';
        carBrandController.value.text = policy.value.carBrand ?? '';
        carModelController.value.text = policy.value.carModel ?? '';
        carColorController.value.text = policy.value.carColor ?? '';

        if (policy.value.carModel != null) {
          if (policy.value.carModel!.isNotEmpty) {
            await getCarModels();
          }
        }

        if (policy.value.carVariant != null) {
          if (policy.value.carVariant!.isNotEmpty) {
            getCarVariants();
          }
        }
        // if (policy.value.carBrand != '') {
        //   await getCarModels();
        // }
        // if (policy.value.carModel != '') {
        //   await getCarVariants();
        // }
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
                'Please fill-up all fields',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Plate Number'),
              InputTextField(
                hintText: 'Enter Plate #',
                onChanged: (newValue) {
                  policy.value = policy.value.copyWith(plateNumber: newValue);
                  updatePolicy.call(policy.value);
                },
                initialValue: policy.value.plateNumber,
              ),
              const SizedBox(height: 10),
              const Text('Chassis Number'),
              InputTextField(
                hintText: 'Enter Chassis #',
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (newValue) {
                  policy.value = policy.value.copyWith(chassisNumber: newValue);
                  updatePolicy.call(policy.value);
                },
                initialValue: policy.value.chassisNumber,
                validators: (value) {
                  if (value == null) {
                    return 'Please enter chassis number';
                  }

                  if (value.length > 17) {
                    return 'Chassis number should not be greater than 17 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text('Engine Number'),
              InputTextField(
                hintText: 'Enter Engine #',
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (newValue) {
                  policy.value = policy.value.copyWith(engineNumber: newValue);
                  updatePolicy.call(policy.value);
                },
                initialValue: policy.value.engineNumber,
                validators: (value) {
                  if (value == null) {
                    return 'Please enter engine number';
                  }
                  if (value.length > 17) {
                    return 'Engine number should not be greater than 17 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              const Text('MV File Number'),
              InputTextField(
                hintText: 'Enter MV File #',
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (newValue) {
                  policy.value = policy.value.copyWith(mvFileNo: newValue);
                  updatePolicy.call(policy.value);
                },
                initialValue: policy.value.mvFileNo,
                validators: (value) {
                  if (value == null) {
                    return 'Please enter MV File Number';
                  }
                  if (value.length > 15) {
                    return 'MV File Number should not be greater than 15 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text('Conduction Sticker'),
              InputTextField(
                hintText: 'Enter Conduction Sticker',
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (newValue) {
                  policy.value =
                      policy.value.copyWith(conductionSticker: newValue);
                  updatePolicy.call(policy.value);
                },
                initialValue: policy.value.conductionSticker,
                validators: (value) {
                  if (value == null) {
                    return 'Please enter Conduction Sticker';
                  }
                  if (value.length > 15) {
                    return 'Conduction Sticker should not be greater than 15 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text('Year'),
              CustomDropdownButton(
                value: yearValue.value,
                items: const [
                  DropdownMenuItem<String>(value: "2024", child: Text("2024")),
                  DropdownMenuItem<String>(value: "2023", child: Text("2023")),
                  DropdownMenuItem<String>(value: "2022", child: Text("2022")),
                  DropdownMenuItem<String>(value: "2021", child: Text("2021")),
                  DropdownMenuItem<String>(value: "2020", child: Text("2020")),
                  DropdownMenuItem<String>(value: "2019", child: Text("2019")),
                  DropdownMenuItem<String>(value: "2018", child: Text("2018")),
                  DropdownMenuItem<String>(value: "2017", child: Text("2017")),
                  DropdownMenuItem<String>(value: "2016", child: Text("2016")),
                  DropdownMenuItem<String>(value: "2015", child: Text("2015")),
                  DropdownMenuItem<String>(value: "2014", child: Text("2014")),
                  DropdownMenuItem<String>(value: "2013", child: Text("2013")),
                  DropdownMenuItem<String>(value: "2012", child: Text("2012")),
                  DropdownMenuItem<String>(value: "2011", child: Text("2011")),
                  DropdownMenuItem<String>(value: "2010", child: Text("2010")),
                  DropdownMenuItem<String>(value: "2009", child: Text("2009")),
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please Select Year";
                  }
                  return null;
                },
                onChanged: (newValue) async {
                  yearValue.value = newValue;
                  carBrandController.value.clear();
                  carModelController.value.clear();
                  carModels.value.clear();
                  carVariant.value.clear();
                  selectedCarType.value.clear();
                  fairMarketValue.value.clear();
                  carVariant.value.clear();
                  selectedCarVariant.value = null;
                  policy.value = policy.value.copyWith(
                    yearManufactured: newValue,
                    carBrand: null,
                    carBrandId: null,
                    carVariant: null,
                    carModel: null,
                    carType: null,
                  );
                  updatePolicy(policy.value);
                },
              ),
              const SizedBox(height: 10),
              const Text('Car Brand'),
              // InputDropdownField(
              //   hintText: 'Car Brand',
              //   items: carBrands.value.map<String>((item) {
              //     return item['name'];
              //   }).toList(),
              //   onChanged: (selectedValue) async {
              //     policy.value = policy.value.copyWith(carBrand: selectedValue);
              //     carBrandId.value = int.parse(carBrands.value
              //         .firstWhere((car) => car['name'] == selectedValue)['id']);
              //     updatePolicy.call(policy.value);
              //     getCarModels();
              //   },
              //   isLoading: carBrands.value.isEmpty,
              //   initialValue: policy.value.carBrand,
              // ),
              DropdownMenu(
                width: 400,
                menuHeight: 350,
                focusNode: carBrandFocusNode.value,
                controller: carBrandController.value,
                hintText: "Choose Option",
                requestFocusOnTap: true,
                errorText: carBrandController.value.text.isEmpty
                    ? 'Car Brand is required'
                    : null,
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
                  border: OutlineInputBorder(
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
                dropdownMenuEntries: carBrands.value.map((e) {
                  return DropdownMenuEntry(
                    label: e['name'].toString(),
                    value: e['id'].toString(),
                  );
                }).toList(),
                onSelected: (String? newValue) async {
                  carBrandFocusNode.value.unfocus();
                  carModelController.value.clear();
                  carVariant.value.clear();
                  selectedCarType.value.clear();
                  selectedCarVariant.value = null;
                  policy.value = policy.value.copyWith(
                    carVariant: null,
                    carModel: null,
                    carType: null,
                  );

                  selectedCarVariant.value = null;
                  final name = carBrands.value
                      .firstWhere((car) => car['id'] == newValue)['name'];
                  final id = carBrands.value
                      .firstWhere((car) => car['id'] == newValue)['id'];
                  policy.value = policy.value.copyWith(
                    carBrand: name,
                    carBrandId: id,
                  );
                  carBrandId.value = int.parse(newValue!);
                  updatePolicy.call(policy.value);
                  await getCarModels();
                },
              ),
              const SizedBox(height: 10),
              const Text('Car Model'),
              // InputDropdownField(
              //   hintText: 'Car Model',
              //   initialValue: selectedCarModel.value,
              //   items: carModels.value.map<String>((item) {
              //     return item['name'];
              //   }).toList(),
              //   onChanged: (selectedValue) async {
              //     carModelId.value = int.parse(carModels.value
              //         .firstWhere((car) => car['name'] == selectedValue)['id']);
              //     policy.value = policy.value.copyWith(carModel: selectedValue);
              //     selectedCarModel.value = selectedValue;
              //     updatePolicy.call(policy.value);
              //     await getCarType();
              //     getCarVariants();
              //   },
              // ),
              DropdownMenu(
                width: 400,
                menuHeight: 350,
                focusNode: carModelFocusNode.value,
                controller: carModelController.value,
                hintText: "Choose Option",
                errorText: carModelController.value.text.isEmpty
                    ? 'Car Model is required'
                    : null,
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
                  border: OutlineInputBorder(
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
                dropdownMenuEntries: carModels.value.map((e) {
                  return DropdownMenuEntry(
                    label: e['name'].toString(),
                    value: e['id'].toString(),
                  );
                }).toList(),
                onSelected: (String? newValue) async {
                  carModelFocusNode.value.unfocus();
                  final name = carModels.value
                      .firstWhere((car) => car['id'] == newValue)['name'];
                  carModelId.value = int.parse(newValue!);
                  policy.value = policy.value.copyWith(carModel: name);
                  selectedCarModel.value = name;
                  selectedCarVariant.value = null;
                  carVariant.value.clear();
                  updatePolicy.call(policy.value);
                  await getCarType();
                  await getCarVariants();
                },
              ),
              const SizedBox(height: 10), const Text('Car Color'),
              InputTextField(
                controller: carColorController.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Car Color',
                onChanged: (newValue) {
                  policy.value = policy.value
                      .copyWith(carColor: carColorController.value.text);
                  updatePolicy.call(policy.value);
                },
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
              const SizedBox(height: 10),
              const Text('Car Type'),
              InputTextField(
                controller: selectedCarType.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Car Type',
                readOnly: true,
                onChanged: (newValue) {
                  policy.value = policy.value
                      .copyWith(carType: selectedCarType.value.text);
                  updatePolicy.call(policy.value);
                },
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
              const SizedBox(height: 10),
              const Text('Car Variant'),
              InputDropdownField(
                hintText: 'Car Variant',
                key: ValueKey(carVariant.value),
                items: carVariant.value.map<String>((item) {
                  return item['name'];
                }).toList(),
                onChanged: (selectedValue) async {
                  await getFmv(selectedValue);

                  policy.value =
                      policy.value.copyWith(carVariant: selectedValue);
                  updatePolicy.call(policy.value);
                },
                initialValue: selectedCarVariant.value,
                validator: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
              const SizedBox(height: 10),
              const Text('Fair Market Value'),
              InputTextField(
                hintText: 'Fair Market Value',
                autoValidateMode: AutovalidateMode.onUserInteraction,
                controller: fairMarketValue.value,
                onChanged: (newValue) {
                  final current = num.tryParse(currentFmv.value) ?? 0.0;
                  final tenPercentSum = current + (current * 0.1);
                  final tenPercentDiff = current - (current * 0.1);
                  if (double.parse(newValue) > tenPercentSum) {
                    isReferToBranch.value = true;
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please refer to the branch.",
                      ),
                    );
                  } else if (double.parse(newValue) < tenPercentDiff) {
                    isReferToBranch.value = true;
                    showTopSnackBar(
                      Overlay.of(context),
                      displayDuration: const Duration(seconds: 1),
                      const CustomSnackBar.info(
                        message: "Please refer to the branch.",
                      ),
                    );
                  } else {
                    isReferToBranch.value = false;
                    policy.value =
                        policy.value.copyWith(fairMarketValue: newValue);
                    updatePolicy.call(policy.value);
                  }
                },
                validators: (value) {
                  final current = num.tryParse(currentFmv.value) ?? 0.0;
                  final tenPercentSum = current + (current * 0.1);
                  final tenPercentDiff = current - (current * 0.1);
                  const errorText = 'Please refer to the branch.';
                  if (value == null) {
                    return errorText;
                  }
                  if (value == '') {
                    return errorText;
                  }
                  if (double.parse(value) > tenPercentSum) {
                    return errorText;
                  }
                  if (double.parse(value) < tenPercentDiff) {
                    return errorText;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              if (isReferToBranch.value)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xfffe5000),
                    ),
                    child: const Text(
                      'Submit to Branch',
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
}

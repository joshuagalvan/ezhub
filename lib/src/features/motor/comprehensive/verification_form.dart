// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simone/src/components/custom_dialog.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/authentication/models/quotation_details_model.dart';
import 'package:simone/src/features/authentication/models/user_model.dart';
import 'package:simone/src/features/motor/ctpl/ctplissuance.dart';
import 'package:simone/src/features/motor/comprehensive/comprehensive_issuance_form.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/helpers/extensions.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:simone/src/models/policy.dart';
import 'package:http/http.dart' as http;
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/validators.dart';

class VerificationForm extends HookWidget {
  const VerificationForm({super.key, this.quotation, required this.type});
  final QuotationDetails? quotation;
  final String type;

  @override
  Widget build(BuildContext context) {
    final policy = useState(Policy());
    final ctplPolicy = useState(CTPLPolicy());
    final verifySelect = useState('plate_no');
    final verifyInput = useState('');
    final formKey = useState(GlobalKey<FormState>());
    final fieldController = useState(TextEditingController());
    final check = useState<String?>(null);

    useEffect(() {
      if (quotation != null) {
        policy.value.actOfNatureRate = quotation!.aon.toString();
        policy.value.typeOfCover = quotation!.toc;
        policy.value.yearManufactured = quotation!.year;
        policy.value.carBrand = quotation!.carCompany;
        policy.value.carModel = quotation!.carMake;
        policy.value.carType = quotation!.carType;
        policy.value.carVariant = quotation!.carVariant;
        policy.value.fairMarketValue = quotation!.fmv;
        policy.value.rates = quotation!.rate;
        policy.value.vtplbiRate = quotation!.vtplBi.toString();
        policy.value.vtplpdRate = quotation!.vtplPd.toString();
      }
      return null;
    }, []);

    Map<String, dynamic> getSelectedData() {
      switch (verifySelect.value) {
        case 'plate_no':
          return {
            'plateNumberConductionSticker': verifyInput.value,
            'engine_no': '',
            'chasis_no': '',
            'topro': '1',
          };

        case 'engine_no':
          return {
            'plateNumberConductionSticker': '',
            'engine_no': verifyInput.value,
            'chasis_no': '',
            'topro': '1',
          };
        case 'chassis_no':
          return {
            'plateNumberConductionSticker': '',
            'engine_no': '',
            'chasis_no': verifyInput.value,
            'topro': '1',
          };
        default:
          return {};
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 270,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Form(
          key: formKey.value,
          child: Column(
            children: [
              const Text(
                'Policy Vehicle Validation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: const Text('PLATE #/CS'),
                    showCheckmark: false,
                    selected: verifySelect.value == 'plate_no',
                    selectedColor: ColorPalette.primaryLighter.withOpacity(0.6),
                    onSelected: (selected) {
                      if (selected) verifySelect.value = 'plate_no';
                    },
                  ),
                  ChoiceChip(
                    label: const Text('CHASSIS #'),
                    showCheckmark: false,
                    selected: verifySelect.value == 'chassis_no',
                    selectedColor: ColorPalette.primaryLighter.withOpacity(0.6),
                    onSelected: (selected) {
                      if (selected) verifySelect.value = 'chassis_no';
                    },
                  ),
                  ChoiceChip(
                    label: const Text('ENGINE #'),
                    showCheckmark: false,
                    selected: verifySelect.value == 'engine_no',
                    selectedColor: ColorPalette.primaryLighter.withOpacity(0.6),
                    onSelected: (selected) {
                      if (selected) verifySelect.value = 'engine_no';
                    },
                  ),
                ],
              ),
              InputTextField(
                controller: fieldController.value,
                label: 'Type something...',
                textCapitalization: TextCapitalization.characters,
                errorText: check.value,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (newValue) {
                  // policy.value = policy.value.copyWith(plateNumber: newValue);
                  verifyInput.value = newValue.toUpperCase();
                },
              ),
              ElevatedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xfffe5000),
                ),
                onPressed: () async {
                  final validator = TextFieldValidators.validatePlateNumber(
                      fieldController.value.text);
                  check.value = validator;
                  if (validator == null) {
                    showDialog(
                      context: context,
                      builder: (context) => const CustomLoadingDialog(),
                    );
                    final resultUser = GetStorage().read('userData');
                    final resultBranch = GetStorage().read('branch');
                    final result = UserModel.fromJson(resultUser);
                    if (type == 'comprehensive') {
                      await Api()
                          .verifyVehicle(verifySelect.value, verifyInput.value)
                          .then((res) {
                        Navigator.pop(context);

                        bool isSuccess = false;
                        if (res['data']['return']['status'] == 'Failed') {
                          String? plateNumber = verifySelect.value == 'plate_no'
                              ? verifyInput.value
                              : '';
                          String? chassisNumber =
                              verifySelect.value == 'chassis_no'
                                  ? verifyInput.value
                                  : '';
                          String? engineNumber =
                              verifySelect.value == 'engine_no'
                                  ? verifyInput.value
                                  : '';
                          policy.value = policy.value.copyWith(
                            plateNumber: plateNumber,
                            chassisNumber: chassisNumber,
                            engineNumber: engineNumber,
                            agentCode: result.agentCode,
                            branchCode: resultBranch['branchCode'],
                          );

                          isSuccess = true;
                        } else {
                          isSuccess = false;
                        }
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.info,
                          useRootNavigator: true,
                          title: isSuccess
                              ? 'No Active Policy Found!'
                              : 'Active policy found',
                          desc: isSuccess
                              ? 'Please click Proceed to continue.'
                              : 'Please try to choose again...',
                          body: isSuccess
                              ? null
                              : SizedBox(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      Text(
                                        isSuccess
                                            ? 'No Active Policy Found!'
                                            : 'Active policy found',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        isSuccess
                                            ? 'Please click Proceed to continue.'
                                            : "The information you've entered has an active policy. Please try to choose again...",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _rowTextData(
                                        title: "PLATE NO",
                                        data:
                                            "${res['data']['return']['record']['plate']}",
                                      ),
                                      _rowTextData(
                                        title: 'START DATE',
                                        data:
                                            '${res['data']['return']['record']['PDATE']}',
                                      ),
                                      _rowTextData(
                                        title: 'END DATE',
                                        data:
                                            '${res['data']['return']['record']['EDATE']}',
                                      ),
                                    ],
                                  ),
                                ),
                          btnOkText: isSuccess ? 'Proceed' : 'Okay',
                          btnCancelOnPress: isSuccess ? () {} : null,
                          btnOkOnPress: () {
                            if (isSuccess) {
                              Navigator.pop(context);
                              Get.to(
                                () => ComprehensiveIssuanceForm(
                                    policyObj: policy.value),
                              );
                            } else {}
                          },
                        ).show();
                      });
                    } else {
                      final data = getSelectedData();
                      ctplPolicy.value = ctplPolicy.value.copyWith(
                        plateNumber: verifyInput.value,
                        locTaxRate: resultBranch['locTax'].toString(),
                        taggingId: '0',
                      );

                      await validateCtpl(context, data, verifyInput.value,
                              ctplPolicy.value)
                          .then((_) {});
                    }
                  }
                },
                label: const Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )
            ].withSpaceBetween(height: 8),
          ),
        ),
      ),
    );
  }
}

Future<void> validateCtpl(BuildContext context, Map<String, dynamic> data,
    String selectedValue, CTPLPolicy ctplPolicy) async {
  final response = await http.post(
    Uri.parse('http://10.52.2.124/motor/validatePlateNumber_json/'),
    body: data,
  );

  // print('validatectpl ${response.statusCode} ${response.body}');
  var result = (jsonDecode(response.body));
  Navigator.pop(context);

  if (response.statusCode == 500) {
    return;
  }

  if (result['return']['status'] == "Success") {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      useRootNavigator: true,
      body: SizedBox(
        width: 300,
        child: Column(
          children: [
            const Text(
              'Active policy found',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const Text(
              "The information you've entered has an active policy. Please try to choose again...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            _rowTextData(
              title: "PLATE NO",
              data: "${result['return']['record']['plate']}",
            ),
            _rowTextData(
              title: 'START DATE',
              data: '${result['return']['record']['PDATE']}',
            ),
            _rowTextData(
              title: 'END DATE',
              data: '${result['return']['record']['EDATE']}',
            ),
          ],
        ),
      ),
      btnOkText: 'Okay',
      btnCancelOnPress: null,
      btnOkOnPress: () {},
    ).show();
  } else {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      useRootNavigator: true,
      title: 'No Active Policy Found!',
      desc: 'Please Click Proceed to Continue.',
      btnOkText: 'Proceed',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.pop(context);
        Get.to(() => CTPLIssuanceForm(policyObj: ctplPolicy));
        // Get.to(() => CtplIssuance(plateText: ctplPolicy.plateNumber!));
      },
    ).show();
  }
}

Widget _rowTextData({required String title, required String data}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'OpenSans',
              color: Color(0xfffe5000),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          data,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}

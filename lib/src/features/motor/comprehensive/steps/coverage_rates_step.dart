import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:simone/src/components/input_dropdown_field.dart';
import 'package:simone/src/features/authentication/models/rates_model.dart';
import 'package:simone/src/features/authentication/models/vtplbi_model.dart';
import 'package:simone/src/features/authentication/models/vtplpd_model.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/models/policy.dart';

import 'package:http/http.dart' as http;
import 'package:simone/src/utils/validators.dart';

class CoverageRatesStep extends HookWidget {
  const CoverageRatesStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
    required this.form,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;
  final GlobalKey<FormState> form;

  Future<List<RatesModel>> getRates() async {
    var result =
        await Api().getDefaultRates(int.parse(policy.value.typeOfCoverId!));
    await Future.delayed(const Duration(seconds: 1));
    final data =
        result['data'].map((rate) => RatesModel.fromJson(rate)).toList();
    return List<RatesModel>.from(data);
  }

  Future<List<VTPLBIList>> getVtplBI() async {
    final response = await http.post(
      Uri.parse('http://10.52.2.124/motor/getSumInsuredList_json/'),
      body: {
        'sumInsuredList': '1',
        'typeOfCover': policy.value.typeOfCoverId!,
        'premium_type': 'bodily_injury'
      },
    );

    final vtplBi = (jsonDecode(response.body)) as List;
    List<VTPLBIList> list = [];
    if (response.statusCode == 200) {
      list = vtplBi
          .map((e) {
            final map = e as Map<String, dynamic>;
            return VTPLBIList.fromJson(map);
          })
          .toList()
          .where((rate) =>
              int.parse(rate.name) <
              int.parse(policy.value.fairMarketValue ?? '0'))
          .toList();
    }

    return list;
  }

  Future<List<VTPLPDList>> getVtplPD() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.52.2.124/motor/getSumInsuredList_json/'),
        body: {
          'sumInsuredList': '1',
          'typeOfCover': policy.value.typeOfCoverId!,
          'premium_type': 'property_damage'
        },
      );

      final vtplPd = (jsonDecode(response.body)) as List;
      List<VTPLPDList> list = [];
      if (response.statusCode == 200) {
        list = vtplPd
            .map((e) {
              final map = e as Map<String, dynamic>;
              return VTPLPDList.fromJson(map);
            })
            .toList()
            .where((rate) =>
                int.parse(rate.name) <
                int.parse(policy.value.fairMarketValue ?? '0'))
            .toList();
      }

      return list;
    } on SocketException {
      throw Exception('No Internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('asd ${policy.value.typeOfCoverId}');
    final ValueNotifier<List<RatesModel>> rates = useState([]);
    final ValueNotifier<List<VTPLPDList>> vtplpd = useState([]);
    final ValueNotifier<List<VTPLBIList>> vtplbi = useState([]);
    final ValueNotifier<String?> selectedRate = useState(null);
    final ValueNotifier<String?> selectedVtplBI = useState(null);
    final ValueNotifier<String?> selectedVtplPd = useState(null);

    useEffect(() {
      asyncFunction() async {
        rates.value = await getRates();
        vtplpd.value = await getVtplPD();
        vtplbi.value = await getVtplBI();
        final rate = (double.parse(rates.value
                        .firstWhereOrNull((rate) =>
                            (double.parse(rate.rate) * 100)
                                .toStringAsFixed(2) ==
                            policy.value.rates)
                        ?.rate ??
                    '0') *
                100)
            .toStringAsFixed(2);
        String myVtplBi = '';
        String myVtplPd = '';
        if (vtplbi.value.isNotEmpty) {
          myVtplBi = vtplbi.value.firstWhere((value) {
            if (policy.value.typeOfCoverId == '3') {
              return value.heavy == policy.value.vtplbiRate;
            } else {
              return value.light == policy.value.vtplbiRate;
            }
          }).name;
        }

        if (vtplpd.value.isNotEmpty) {
          myVtplPd = vtplpd.value.firstWhere((value) {
            if (policy.value.typeOfCoverId == '3') {
              return value.heavy == policy.value.vtplpdRate;
            } else {
              return value.light == policy.value.vtplpdRate;
            }
          }).name;
        }
        policy.value.actOfNatureRate = rates.value
                .firstWhere(
                  (value) =>
                      (double.parse(value.rate) * 100).toStringAsFixed(2) ==
                      rate,
                )
                .actOfNature ??
            '0.0';

        policy.value.ownDamageRate = rates.value
            .firstWhere(
              (value) =>
                  (double.parse(value.rate) * 100).toStringAsFixed(2) == rate,
            )
            .ownDamage;

        selectedRate.value = rate;
        selectedVtplBI.value = myVtplBi;
        selectedVtplPd.value = myVtplPd;
      }

      asyncFunction();
      return null;
      // if (policy.value.profileId != '' && policy.value.profileId != 'NEW') {
      //   profileId.value = policy.value.profileId;
      //   searchProfileByKeyword();
      // }
      // return null;
    }, []);
    debugPrint(
        '${vtplpd.value.map((e) => e.toJson()).toList()} ---------------}',
        wrapWidth: 768);
    debugPrint('${vtplbi.value.map((e) => e.toJson()).toList()}',
        wrapWidth: 768);
    return Form(
      key: form,
      child: Column(
        children: [
          //         TextButton(
          //             onPressed: () async {
          //               rates.value = await getRates();
          //               vtplpd.value = await getVtplPD();
          //               vtplbi.value = await getVtplBI();
          // // 0.0125, act_of_nature: 0.005,
          // // 1320
          // // 510
          //             },
          //             child: Text('test')),
          ratesDropdown(
            title: 'Default Rates',
            subtitle: '* Including Own Damage, Theft and Act of Nature',
            trailing: InputDropdownField(
              label: 'Rate',
              initialValue: selectedRate.value,
              items: rates.value
                  .map((rate) =>
                      (double.parse(rate.rate) * 100).toStringAsFixed(2))
                  .toList(),
              onChanged: (value) {
                policy.value.actOfNatureRate = rates.value
                        .firstWhere(
                          (rate) =>
                              (double.parse(rate.rate) * 100)
                                  .toStringAsFixed(2) ==
                              value,
                        )
                        .actOfNature ??
                    '0.0';

                policy.value.ownDamageRate = rates.value
                    .firstWhere(
                      (rate) =>
                          (double.parse(rate.rate) * 100).toStringAsFixed(2) ==
                          value,
                    )
                    .ownDamage;

                policy.value.rates = value;
              },
              validator: (value) =>
                  TextFieldValidators.validateEmptyField(value),
            ),
          ),
          ratesDropdown(
            title: 'RSCC',
            subtitle: 'Riots, Strikes and Civil Commotion',
            trailing: const Text(
              'INCLUDED',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ratesDropdown(
            title: 'VTPLBI',
            subtitle: 'Bodily-injury',
            trailing: InputDropdownField(
              label: 'Rate',
              initialValue: selectedVtplBI.value,
              items: vtplbi.value.map((rate) => rate.name).toList(),
              onChanged: (value) {
                policy.value.vtplbiAmount = value;
                policy.value.vtplpdAmount = value;
                if (policy.value.typeOfCoverId == '3') {
                  policy.value.vtplbiRate = vtplbi.value
                      .firstWhere((rate) => (rate.name) == value)
                      .heavy;
                  selectedVtplPd.value = value;
                  policy.value.vtplpdRate = vtplpd.value
                      .firstWhere((rate) => (rate.name) == value)
                      .heavy;
                } else {
                  policy.value.vtplbiRate = vtplbi.value
                      .firstWhere((rate) => (rate.name) == value)
                      .light;
                  selectedVtplPd.value = value;
                  policy.value.vtplpdRate = vtplpd.value
                      .firstWhere((rate) => (rate.name) == value)
                      .light;
                }
              },
              validator: (value) =>
                  TextFieldValidators.validateEmptyField(value),
            ),
          ),
          ratesDropdown(
            title: 'VTPLPD',
            subtitle: 'Property-damage',
            trailing: InputDropdownField(
              label: 'Rate',
              initialValue: selectedVtplPd.value,
              items: vtplpd.value.map((rate) => rate.name).toList(),
              onChanged: (value) {
                policy.value.vtplpdAmount = value;
                if (policy.value.typeOfCoverId == '3') {
                  policy.value.vtplpdRate = vtplpd.value
                      .firstWhere((rate) => (rate.name) == value)
                      .heavy;
                } else {
                  policy.value.vtplpdRate = vtplpd.value
                      .firstWhere((rate) => (rate.name) == value)
                      .light;
                }
              },
              validator: (value) =>
                  TextFieldValidators.validateEmptyField(value),
            ),
          ),
          ratesDropdown(
            title: 'APA',
            subtitle: 'Auto Personal Accident',
            trailing: const Text(
              'INCLUDED',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ratesDropdown({
    String? title,
    String? subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(
        title ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle ?? '',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          letterSpacing: 1.1,
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: trailing,
      ),
    );
  }
}

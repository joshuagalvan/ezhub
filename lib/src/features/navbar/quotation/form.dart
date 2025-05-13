import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/components/button_primary_form.dart';
import 'package:simone/src/components/input_dropdown_field.dart';
import 'package:simone/src/components/input_label_field.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/helpers/api.dart';

class QuotationForm extends HookWidget {
  QuotationForm({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<dynamic>> typeOfCover = useState([]);
    ValueNotifier<List<dynamic>> defaultRates = useState([]);
    ValueNotifier<List<dynamic>> carBrands = useState([]);

    useEffect(() {
      asyncing() async {
        dynamic cover = await Api().getTypeOfCover('motor_comprehensive');
        typeOfCover.value = cover['data'];

        dynamic brands = await Api().getCarBrands();
        carBrands.value = brands['data'];
      }

      asyncing();
      return null;
    }, []);

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text(
            "Comprehensive Issuance",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: defaultSize),
            child: Form(
                child: Center(
              child: Column(
                // direction: Axis.vertical,
                // spacing: 20,
                children: [
                  const InputLabelField(label: 'Branch', value: 'Alabang'),
                  // InputDropdownField(
                  //   label: 'Type Of Cover',
                  //   items: typeOfCover.value.map<String>((item) {
                  //     return item['classification'];
                  //   }).toList(),
                  //   onChanged: () async {
                  //     dynamic rates = await Api().getDefaultRates();
                  //     defaultRates.value = rates['data'];
                  //   },
                  // ),
                  InputDropdownField(
                    label: 'Rates',
                    items: defaultRates.value.map<String>((item) {
                      return "${((item['rate']) * 100).toStringAsFixed(2)} %";
                    }).toList(),
                  ),
                  const InputTextField(
                    label: 'Year Manufactured',
                  ),
                  InputDropdownField(
                      label: 'Car Brand',
                      items: carBrands.value.map<String>((item) {
                        return item['name'];
                      }).toList()),
                  const InputDropdownField(label: 'Car Model', items: []),
                  const InputDropdownField(label: 'Car Type', items: []),
                  const InputDropdownField(label: 'Car Variant', items: []),
                  const InputTextField(
                    label: 'Fair Market Value',
                  ),
                  const InputTextField(
                    label: 'Deductibles',
                  ),
                  const InputDropdownField(
                      label: 'VTPL - Bodily Injury', items: []),
                  const InputDropdownField(
                      label: 'VTPL - Property Damage', items: []),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonPrimaryForm(label: 'Pay Now'),
                        ButtonPrimaryForm(label: 'Push Now'),
                      ]),
                ].withSpaceBetween(height: 10),
              ),
            ))));
  }
}

extension ListSpaceBetweenExtension on List<Widget> {
  List<Widget> withSpaceBetween({double? width, double? height}) => [
        for (int i = 0; i < length; i++) ...[
          if (i > 0) SizedBox(width: width, height: height),
          this[i],
        ],
      ];
}

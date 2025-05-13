import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/custom_radio.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/travel/controllers/travel_controller.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/features/travel/data/models/country_model.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/validators.dart';

class InternationalTravelDetails extends StatefulHookWidget {
  const InternationalTravelDetails({
    super.key,
    this.form,
    required this.onTermsChecked,
    required this.intData,
  });

  final GlobalKey<FormState>? form;
  final Function(bool) onTermsChecked;
  final ValueNotifier<TravelModel> intData;

  @override
  State<InternationalTravelDetails> createState() =>
      _InternationalTravelDetailsState();
}

class _InternationalTravelDetailsState
    extends State<InternationalTravelDetails> {
  final controller = Get.put(TravelController());

  @override
  Widget build(BuildContext context) {
    final travelAs = useState<String?>('');
    final selectedTravelType = useState<String?>(null);
    final selectedNoOfMinor = useState<String?>('1');
    final selectedNoOfAdult = useState<String?>('1');
    final travelDateFrom = useTextEditingController();
    final travelDateTo = useTextEditingController();
    final covidProtection = useState('');
    final selectedItenerary = useState<List<CountryModel?>>([null]);
    final isChecked = useState(false);
    final countryList = useState<List<CountryModel?>>([]);
    final selectedDateFrom = useState<DateTime?>(null);
    final selectedDateTo = useState<DateTime?>(null);
    final numbers = useState(["1", "2", "3", "4"]);

    List<String> availableAdults = numbers.value.where((number) {
      int num = int.parse(number);
      return selectedNoOfMinor.value == null ||
          (num + (int.parse(selectedNoOfMinor.value ?? '0'))) <= 5;
    }).toList();

    void validateSelection(CountryModel? country) {
      for (int i = 1; i < selectedItenerary.value.length; i++) {
        if (country == selectedItenerary.value[i - 1]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Consecutive selections of ${country?.country} are not allowed.'),
            ),
          );
          return;
        }
      }
    }

    useEffect(() {
      async() async {
        await Future.delayed(const Duration(milliseconds: 500));
        travelAs.value = widget.intData.value.travelAs ?? 'Individual';
        selectedTravelType.value =
            widget.intData.value.travelType ?? 'Single Trip';
        selectedNoOfMinor.value = widget.intData.value.noOfMinor ?? '1';
        selectedNoOfAdult.value = widget.intData.value.noOfAdult ?? '1';
        travelDateFrom.text = widget.intData.value.departFrom ?? '';
        travelDateTo.text = widget.intData.value.arriveIn ?? '';
        covidProtection.value = widget.intData.value.withCovid ?? 'No';
        isChecked.value = widget.intData.value.isDetailsTermsChecked ?? false;

        widget.intData.value = widget.intData.value.copyWith(
          travelAs: travelAs.value,
          withCovid: covidProtection.value,
          noOfMinor: selectedNoOfMinor.value,
          noOfAdult: selectedNoOfAdult.value,
        );

        final list = await controller.getCountries();
        countryList.value = list;
        setState(() {});
        selectedItenerary.value
            .addAll(widget.intData.value.countries ?? [null]);
      }

      async();
      return null;
    }, []);
    return Form(
      key: widget.form,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Travel As",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  CustomRadio(
                    value: 'Individual',
                    selectedValue: travelAs.value ?? 'Individual',
                    onChanged: (value) {
                      travelAs.value = value!;
                      selectedNoOfMinor.value = null;
                      selectedNoOfMinor.value = null;
                      widget.intData.value = widget.intData.value.copyWith(
                        travelAs: travelAs.value,
                        noOfAdult: null,
                        noOfMinor: null,
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  CustomRadio(
                    value: 'Family',
                    selectedValue: travelAs.value ?? 'Individual',
                    onChanged: (value) {
                      travelAs.value = value!;
                      widget.intData.value = widget.intData.value
                          .copyWith(travelAs: travelAs.value);
                    },
                  ),
                ],
              ),
              if (travelAs.value == 'Family') ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "No. of Minor(s)",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5),
                              Tooltip(
                                showDuration: Duration(seconds: 5),
                                triggerMode: TooltipTriggerMode.tap,
                                preferBelow: true,
                                richMessage: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Notes\n',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(
                                        text:
                                            'Minor(s) must be accompanied by atleast 1 adult.'),
                                  ],
                                  style: TextStyle(fontSize: 12),
                                ),
                                child: Icon(Icons.info),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          CustomDropdownButton<String>(
                            value: selectedNoOfMinor.value,
                            helperText: 'age 4 weeks to 17 years old',
                            items: ['1', '2', '3', '4'].map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedNoOfMinor.value = value ?? '1';
                              final adult =
                                  int.parse(selectedNoOfAdult.value ?? '1');
                              final minors =
                                  int.parse(selectedNoOfMinor.value ?? '1');
                              setState(() {
                                if ((adult + minors) >= 5) {
                                  // Reset adults to the first valid option
                                  selectedNoOfAdult.value =
                                      availableAdults.isNotEmpty ? "1" : null;
                                }
                              });

                              selectedNoOfMinor.value = value ?? '1';
                              widget.intData.value =
                                  widget.intData.value.copyWith(
                                noOfMinor: selectedNoOfMinor.value,
                                noOfAdult: selectedNoOfAdult.value,
                                adultsPersonalData: List.generate(
                                  adult,
                                  (_) => {
                                    "firstName": "",
                                    "lastName": "",
                                    "dateOfBirth": "",
                                    "gender": "",
                                    "passport": "",
                                  },
                                ),
                                minorsPersonalData: List.generate(
                                  minors,
                                  (_) => {
                                    "firstName": "",
                                    "lastName": "",
                                    "dateOfBirth": "",
                                    "gender": "",
                                    "passport": "",
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "No. of Adult",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomDropdownButton<String>(
                            value: selectedNoOfAdult.value,
                            helperText: 'ages 18 to 75 years old',
                            items: availableAdults.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedNoOfAdult.value = value ?? '1';
                              final adult =
                                  int.parse(selectedNoOfAdult.value ?? '0');
                              final minors =
                                  int.parse(selectedNoOfMinor.value ?? '0');
                              selectedNoOfAdult.value = value ?? '1';
                              widget.intData.value =
                                  widget.intData.value.copyWith(
                                noOfAdult: selectedNoOfAdult.value,
                                adultsPersonalData: List.generate(
                                  adult,
                                  (_) => {
                                    "firstName": "",
                                    "lastName": "",
                                    "dateOfBirth": "",
                                    "gender": "",
                                    "passport": "",
                                  },
                                ),
                                minorsPersonalData: List.generate(
                                  minors,
                                  (_) => {
                                    "firstName": "",
                                    "lastName": "",
                                    "dateOfBirth": "",
                                    "gender": "",
                                    "passport": "",
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    "Travel Type",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 5),
                  Tooltip(
                    showDuration: Duration(seconds: 5),
                    triggerMode: TooltipTriggerMode.tap,
                    preferBelow: true,
                    richMessage: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Notes\n',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                            text:
                                'Single trip plans can cover you for trips up to 180 days.\n'),
                        TextSpan(
                            text:
                                'For Multi-Trip plans please send us an email at '),
                        TextSpan(
                          text: 'PHCustomerCare@fpgins.com ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(text: 'or call our Customer Care Hotline at '),
                        TextSpan(
                          text: '(02) 8859 1200.',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                      style: TextStyle(fontSize: 12),
                    ),
                    child: Icon(Icons.info),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              CustomDropdownButton<String>(
                value: selectedTravelType.value,
                items: ['Single Trip'].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedTravelType.value = value;
                  widget.intData.value = widget.intData.value
                      .copyWith(travelType: selectedTravelType.value);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Travel Date",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Depart From Philippines",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette.neutralGrey,
                          ),
                        ),
                        InputTextField(
                          hintText: 'Date',
                          controller: travelDateFrom,
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );

                            if (picked != null) {
                              selectedDateFrom.value = picked;
                              travelDateFrom.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              widget.intData.value = widget.intData.value
                                  .copyWith(
                                      departFrom: travelDateFrom.value.text);
                            }
                          },
                          validators: (value) =>
                              TextFieldValidators.validateEmptyField(value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Arrive in the Philippines",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette.neutralGrey,
                          ),
                        ),
                        InputTextField(
                          hintText: 'Date',
                          controller: travelDateTo,
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          onTap: () async {
                            if (selectedDateFrom.value != null) {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDateFrom.value
                                        ?.add(const Duration(days: 1)) ??
                                    DateTime.now(),
                                firstDate: selectedDateFrom.value
                                        ?.add(const Duration(days: 1)) ??
                                    DateTime.now(),
                                lastDate: selectedDateFrom.value!
                                    .add(const Duration(days: 180)),
                              );

                              if (picked != null) {
                                selectedDateTo.value = picked;
                                travelDateTo.text =
                                    DateFormat('yyyy-MM-dd').format(picked);
                                widget.intData.value = widget.intData.value
                                    .copyWith(
                                        arriveIn: travelDateTo.value.text);
                              }
                            }
                          },
                          validators: (value) =>
                              TextFieldValidators.validateEmptyField(value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Covid Protection",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  CustomRadio(
                    value: 'Yes',
                    selectedValue: covidProtection.value,
                    onChanged: (value) {
                      covidProtection.value = value!;
                      widget.intData.value = widget.intData.value
                          .copyWith(withCovid: covidProtection.value);
                    },
                  ),
                  const SizedBox(width: 20),
                  CustomRadio(
                    value: 'No',
                    selectedValue: covidProtection.value,
                    onChanged: (value) {
                      covidProtection.value = value!;
                      widget.intData.value = widget.intData.value
                          .copyWith(withCovid: covidProtection.value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    "Itenerary",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 5),
                  Tooltip(
                    showDuration: Duration(seconds: 5),
                    triggerMode: TooltipTriggerMode.tap,
                    preferBelow: true,
                    message:
                        '''Please declare the country(ies) of your destination including stop-overs, lay-overs or connecting flights\nOrigin and Return Country: Philippines only''',
                    child: Icon(Icons.info),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedItenerary.value.length,
                separatorBuilder: (context, i) => const SizedBox(height: 5),
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownButton<CountryModel>(
                              value: selectedItenerary.value[i],
                              items: countryList.value.map((item) {
                                return DropdownMenuItem<CountryModel>(
                                  value: item,
                                  child: Text(item?.country ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) {
                                validateSelection(value);
                                selectedItenerary.value[i] = value;
                                widget.intData.value = widget.intData.value
                                    .copyWith(
                                        countries: selectedItenerary.value);
                                print(
                                    'checking ${selectedItenerary.value.map((e) => e?.country).toList()}');
                                print(
                                    'checking ${widget.intData.value.countries!.map((e) => e?.country).toList()}');
                              },
                            ),
                          ),
                          if (i != 0)
                            GestureDetector(
                              onTap: () {
                                selectedItenerary.value.removeAt(i);
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              if (selectedItenerary.value.firstWhereOrNull((e) =>
                      (e?.countryModelClass ?? '').toLowerCase() ==
                      'schengen') !=
                  null)
                const Text(
                  'Note: For Schengen Visa applicants, only our Elite and Prestige Plans are accepted by the embassy.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    onPressed: () {
                      selectedItenerary.value.add(null);
                      setState(() {});
                    },
                    child: const Text(
                      '+ Add Country',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text(
                  """
      I confirm that I am purchasing this travel insurance for myself or my family, and that all travelers are under 75 years of age on the date of travel.
      
      Note: For travelers aged above 75, please leave your details on our "Contact Us" page or call our Customer Care Hotline at (02) 8859 1200 so we can assist you on your purchase.""",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                value: isChecked.value,
                onChanged: (newBool) {
                  widget.onTermsChecked(newBool ?? false);
                  widget.intData.value = widget.intData.value
                      .copyWith(isDetailsTermsChecked: newBool);
                  setState(() {
                    isChecked.value = newBool ?? false;
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

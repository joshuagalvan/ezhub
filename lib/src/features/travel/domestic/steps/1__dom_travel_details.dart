import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/components/custom_dropdown.dart';
import 'package:simone/src/components/custom_radio.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/features/travel/controllers/travel_controller.dart';
import 'package:simone/src/features/travel/data/models/province_model.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/utils/colorpalette.dart';

class DomesticTravelDetails extends StatefulHookWidget {
  const DomesticTravelDetails({
    super.key,
    this.form,
    //required this.onTermsChecked,
    required this.domData,
  });

  final ValueNotifier<TravelModel> domData;
  final GlobalKey<FormState>? form;
  //final Function(bool) onTermsChecked;

  @override
  State<DomesticTravelDetails> createState() => _DomesticTravelDetailsState();
}

class _DomesticTravelDetailsState extends State<DomesticTravelDetails> {
  final controller = Get.put(TravelController());
  @override
  Widget build(BuildContext context) {
    // String? domToc;
    List<Map<String, dynamic>> domTypeofCover = [
      {'text': 'Single Trip', 'value': 'SHRT'},
    ];
    final selectedItenerary = useState<List<ProvinceModel?>>([null]);
    final provinceList = useState(<ProvinceModel>[]);
    //final isChecked = useState(false);
    final fromDate = useState(TextEditingController());
    final toDate = useState(TextEditingController());
    final travelAs = useState('Individual');
    final selectedTravelType = useState<String?>('SHRT');
    final selectedDateFrom = useState<DateTime?>(null);
    final selectedDateTo = useState<DateTime?>(null);

    Future<void> getProvince() async {
      final list = await controller.getProvinces();
      provinceList.value = list;
    }

    useEffect(() {
      async() async {
        await getProvince();
        travelAs.value = "Individual";
        await Future.delayed(const Duration(seconds: 1));
        selectedTravelType.value = 'SHRT';
        widget.domData.value = widget.domData.value.copyWith(
          travelAs: travelAs.value,
          travelType: 'Single Trip',
        );
      }

      async();
      return null;
    }, []);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Form(
        key: widget.form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Travel As?",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomRadio(
                    value: "Individual",
                    selectedValue: "Individual",
                    onChanged: (value) {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Type of Cover",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Travel Type:",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.greyLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomDropdownButton<String>(
                    value: selectedTravelType.value,
                    items: domTypeofCover.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['text']),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      // await getProvince();

                      selectedTravelType.value = value!;
                      widget.domData.value = widget.domData.value
                          .copyWith(travelType: "Single Trip");
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Travel Date",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "FROM",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                            color: ColorPalette.greyLight,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InputTextField(
                          controller: fromDate.value,
                          readOnly: true,
                          hintText: 'Date',
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {},
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
                              fromDate.value.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              widget.domData.value = widget.domData.value
                                  .copyWith(departFrom: fromDate.value.text);
                            }
                          },
                          validators: (value) {
                            if (value!.isEmpty) {
                              return 'FROM Date Required';
                            }
                            return null;
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
                        const Text(
                          "TO",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                            color: ColorPalette.greyLight,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InputTextField(
                          controller: toDate.value,
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                          readOnly: true,
                          hintText: 'Date',
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {},
                          onTap: () async {
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
                              toDate.value.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              widget.domData.value = widget.domData.value
                                  .copyWith(arriveIn: toDate.value.text);
                            }
                          },
                          validators: (value) {
                            if (value!.isEmpty) {
                              return 'TO Date Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    "Itinerary",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10),
                  Tooltip(
                    message:
                        "Note: Please declare the PROVINCE of your destination including stop-overs, lay-overs or connecting flights.",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(Icons.info),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedItenerary.value.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 5),
                  itemBuilder: (context, i) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomDropdownButton<ProvinceModel>(
                            value: selectedItenerary.value[i],
                            items: provinceList.value.map((item) {
                              return DropdownMenuItem<ProvinceModel>(
                                value: item,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedItenerary.value[i] = value;
                              widget.domData.value = widget.domData.value
                                  .copyWith(provinces: selectedItenerary.value);
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
                    );
                  }),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColor,
                  ),
                  onPressed: () async {
                    selectedItenerary.value.add(null);
                    setState(() {});
                  },
                  child: const Text(
                    '+ Add Province',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/models/policy.dart';
import 'package:simone/src/utils/colorpalette.dart';

class TypeCoverStep extends HookWidget {
  const TypeCoverStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
    this.form,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;
  final GlobalKey<FormState>? form;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<dynamic>> typeOfCover = useState([]);

    Map<String, String> getProductId(String value) {
      switch (value) {
        case 'PRIVATE CARS':
          return {
            'productId': '0201',
            'toPro': 'COMWOPC',
          };
        case 'COMMERCIAL VEHICLES - LIGHT/MEDIUM' ||
              'COMMERCIAL VEHICLES - HEAVY':
          return {
            'productId': '0202',
            'toPro': 'COMWOCV',
          };
        case 'MOTORCYCLES':
          return {
            'productId': '0203',
            'toPro': 'COMWOMCY',
          };
        default:
          return {};
      }
    }

    useEffect(() {
      asyncing() async {
        dynamic cover = await Api().getTypeOfCover('motor_comprehensive');
        typeOfCover.value = cover['data'];
        if (policy.value.typeOfCover != null) {
          final tocId = (cover['data'] as List).firstWhere(
            (toc) =>
                (policy.value.typeOfCover ?? '') ==
                toc['classification'].toString(),
          )['id'] as String?;
          policy.value.typeOfCoverId = tocId ?? '';
        }
      }

      asyncing();

      return null;
    }, []);
    return Form(
      key: form,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select the type of vehicle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            if (typeOfCover.value.isNotEmpty)
              ListView(
                shrinkWrap: true,
                children: typeOfCover.value.map<Widget>((item) {
                  return VehicleTypeRadio(
                    value: item['classification'],
                    selectedValue: policy.value.typeOfCover ?? '',
                    onChanged: (value) {
                      final data = getProductId(item['classification']);
                      policy.value = policy.value.copyWith(
                        typeOfCover: item['classification'],
                        typeOfCoverId: item['id'].toString(),
                        deductibles: item['deductible'].toString(),
                        productId: data['productId'],
                        toPro: data['toPro'],
                      );

                      updatePolicy.call(policy.value);
                    },
                  );
                }).toList(),
              )
            else
              const SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 5),
                    Text('Please wait..')
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class VehicleTypeRadio extends StatefulWidget {
  const VehicleTypeRadio({
    super.key,
    required this.value,
    required this.selectedValue,
    this.onChanged,
  });

  final String value;
  final String selectedValue;
  final Function(String?)? onChanged;
  @override
  State<VehicleTypeRadio> createState() => _VehicleTypeRadioState();
}

class _VehicleTypeRadioState extends State<VehicleTypeRadio> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.value == widget.selectedValue;
    return GestureDetector(
      onTap: () {
        widget.onChanged!(widget.value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected
              ? ColorPalette.primaryColor.withOpacity(0.5)
              : Colors.white,
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
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

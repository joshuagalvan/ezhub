import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/helpers/extensions.dart';

class CarVerificationStep extends HookWidget {
  const CarVerificationStep({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> verifySelect = useState('PLATE #');
    ValueNotifier<String> verifyInput = useState('');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text('Verify if your car already insured'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('PLATE #'), 
                  selected: verifySelect.value == 'PLATE #',
                  onSelected: (selected) {
                    if (selected) verifySelect.value = 'PLATE #';
                  },
                ),
              ),
              Expanded(
                child: ChoiceChip(
                  label: const Text('CHASSIS #'), 
                  selected: verifySelect.value == 'CHASSIS #',
                  onSelected: (selected) {
                    if (selected) verifySelect.value = 'CHASSIS #';
                  },
                ),
              ),
              Expanded(
                child: ChoiceChip(
                  label: const Text('ENGINE #'), 
                  selected: verifySelect.value == 'ENGINE #',
                  onSelected: (selected) {
                    if (selected) verifySelect.value = 'ENGINE #';
                  },
                ),
              ),
            ]
          ),
          InputTextField(
            label: 'Type something...',
            onChanged: (newValue) {
              // policy.value = policy.value.copyWith(plateNumber: newValue);
              verifyInput.value = newValue;
            },
          ),
          TextButton.icon(
            onPressed: () {
              var a = AlertDialog(
                title: const Text(
                  'Car Verification',
                  style: TextStyle(fontSize: 18)
                ),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      Icons.check_circle_rounded, 
                      color: Colors.green,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No active policy',
                      style: TextStyle(
                        fontSize: 13,
                      )
                    ),
                    Text(
                      'Please proceed to continue...',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      )
                    ),
                  ]
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('OK'),
                  ),
                ]
              );

              showDialog(
                context: context,
                builder: (context) {
                  return a;
                }
              );
            }, 
            label: const Text('Verify'),
            icon: const Icon(Icons.search),
          )
        ].withSpaceBetween(height: 10)
      )
    );
  }
}

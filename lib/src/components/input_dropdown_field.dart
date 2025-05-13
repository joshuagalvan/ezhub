import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simone/src/utils/colorpalette.dart';

class InputDropdownField extends HookWidget {
  const InputDropdownField({
    super.key,
    this.label,
    this.hintText,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.isLoading = false,
    this.disabled = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String? label;
  final String? hintText;
  final List<String> items;
  final String? initialValue;
  final Function(String?)? onChanged;
  final bool isLoading;
  final bool disabled;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    var select = useState('');

    return DropdownButtonFormField(
      isExpanded: true,
      value: items.isEmpty ? null : initialValue,
      autovalidateMode: autovalidateMode,
      icon: SizedBox(
        child: isLoading
            ? const Center(
                child: SpinKitChasingDots(
                  color: ColorPalette.primaryColor,
                  size: 20,
                ),
              )
            : const Icon(
                Icons.arrow_drop_down,
              ),
      ),

      decoration: InputDecoration(
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
        labelText: label,
      ),
      hint: Text(hintText ?? ''),
      // value: select.value,
      onChanged: (String? selected) {
        select.value = selected ?? '';
        if (onChanged != null) {
          onChanged!(selected);
        }
      },
      validator: validator,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}

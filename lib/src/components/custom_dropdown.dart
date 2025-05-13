import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simone/src/utils/colorpalette.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    this.value,
    this.hintText = 'Choose Option',
    required this.items,
    this.validator,
    this.onChanged,
    this.isLoading = false,
    this.isEnabled = true,
    this.helperText,
  });

  final dynamic value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final bool isLoading;
  final bool isEnabled;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      hint: Text(hintText),
      value: value,
      items: items,
      decoration: InputDecoration(
        border: InputBorder.none,
        helperText: helperText,
        helperStyle: const TextStyle(
          color: ColorPalette.primaryDark,
        ),
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorPalette.greyE3,
            width: 2,
          ),
        ),
        enabled: isEnabled,
      ),
      icon: isLoading
          ? const Center(
              child: SpinKitChasingDots(
                color: ColorPalette.primaryColor,
                size: 25,
              ),
            )
          : const Icon(Icons.arrow_drop_down),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

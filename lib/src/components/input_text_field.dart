import 'package:flutter/material.dart';
import 'package:simone/src/utils/colorpalette.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.decoration,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.initialValue,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
    this.validators,
    this.autoValidateMode,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.words,
    this.obscureText = false,
    this.helperText,
  });

  final String? label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? initialValue;
  final Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final FocusNode? focusNode;
  final String? Function(String?)? validators;
  final AutovalidateMode? autoValidateMode;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validators,
      obscureText: obscureText,
      autovalidateMode: autoValidateMode,
      initialValue: initialValue,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorPalette.greyE3,
            width: 2,
          ),
        ),
        helperText: helperText,
        hintText: hintText,
        labelText: label,
        errorText: errorText,
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
          borderSide: BorderSide(
            color: Colors.red[800]!,
            width: 2,
          ),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      readOnly: readOnly,
      enabled: enabled,
      onTap: onTap,
      onChanged: (String newValue) {
        if (onChanged != null) {
          onChanged!(newValue);
        }
      },
      onFieldSubmitted: (String newValue) {
        if (onFieldSubmitted != null) {
          onFieldSubmitted!(newValue);
        }
      },
    );
  }
}

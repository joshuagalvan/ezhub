import 'package:flutter/material.dart';
import 'package:simone/src/utils/colorpalette.dart';

class CustomRadio extends StatefulWidget {
  const CustomRadio({
    super.key,
    required this.value,
    required this.selectedValue,
    this.onChanged,
  });

  final String value;
  final String selectedValue;
  final Function(String?)? onChanged;
  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.value == widget.selectedValue;
    return GestureDetector(
      onTap: () {
        widget.onChanged!(widget.value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              fontSize: 14,
              color: isSelected ? ColorPalette.primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

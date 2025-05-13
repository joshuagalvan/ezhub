import 'package:flutter/material.dart';

class InputLabelField extends StatelessWidget {
  const InputLabelField({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.0,
            // fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.0,
            color: Color(0xfffe5000),
            // fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        )
      ]
    );
  }
}
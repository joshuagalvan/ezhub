import 'package:flutter/material.dart';

class ButtonPrimaryForm extends StatelessWidget {
  const ButtonPrimaryForm({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xfffe5000),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
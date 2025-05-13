// ignore_for_file: unnecessary_this

import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalizeEachWord() {
    return split(' ').map((word) => word.capitalizeFirstLetter()).join(' ');
  }

  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String formatWithCommas() {
    double? number = double.tryParse(this.replaceAll(',', ''));
    if (number == null) return this;

    final formatter = NumberFormat('#,##0.00');
    return formatter.format(number);
  }
}

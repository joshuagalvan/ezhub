import 'package:flutter/widgets.dart';

class StepperPageView {
  StepperPageView({
    required this.title,
    required this.content,
    this.next = true,
  });

  final String title;
  final Widget content;
  final bool next;
}
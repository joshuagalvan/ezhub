import 'package:flutter/material.dart';

class AccordionForm extends StatelessWidget {
  const AccordionForm({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: children.map((item) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return const Text('test');
          }, 
          body: item
        );
      }).toList(),
    );
  }
}
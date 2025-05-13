import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/components/input_text_field.dart';
import 'package:simone/src/models/policy.dart';
import 'package:simone/src/utils/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PolicyPeriod extends StatefulHookWidget {
  const PolicyPeriod({
    super.key,
    required this.policy,
    required this.updatePolicy,
    required this.form,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;
  final GlobalKey<FormState>? form;

  @override
  State<PolicyPeriod> createState() => _PolicyPeriodState();
}

class _PolicyPeriodState extends State<PolicyPeriod> {
  final policyPeriodFromController = TextEditingController();
  final policyPeriodToController = TextEditingController();

  @override
  void initState() {
    policyPeriodFromController.text =
        widget.policy.value.policyPeriodFrom ?? '';
    policyPeriodToController.text = widget.policy.value.policyPeriodTo ?? '';
    if (policyPeriodFromController.text.isNotEmpty) {
      policyPeriodToController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(policyPeriodFromController.text));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.form,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your policy period',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'From',
              style: TextStyle(),
            ),
            InputTextField(
              hintText: 'Policy Period',
              controller: policyPeriodFromController,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                );

                if (picked != null) {
                  policyPeriodFromController.text =
                      DateFormat('yyyy-MM-dd').format(picked);
                  policyPeriodToController.text = DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(policyPeriodFromController.text)
                          .add(const Duration(days: 365)));

                  widget.policy.value = widget.policy.value.copyWith(
                    policyPeriodFrom: policyPeriodFromController.text,
                    policyPeriodTo: policyPeriodToController.text,
                  );
                  widget.updatePolicy(widget.policy.value);
                }
              },
              validators: (value) =>
                  TextFieldValidators.validateEmptyField(value),
            ),
            if (policyPeriodFromController.value.text.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                'To',
                style: TextStyle(),
              ),
              InputTextField(
                hintText: 'Policy Period',
                controller: policyPeriodToController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                readOnly: true,
                onTap: () {
                  showTopSnackBar(
                    Overlay.of(context),
                    displayDuration: const Duration(seconds: 1),
                    const CustomSnackBar.info(
                      message: "You cannot update this period",
                    ),
                  );
                },
                validators: (value) =>
                    TextFieldValidators.validateEmptyField(value),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

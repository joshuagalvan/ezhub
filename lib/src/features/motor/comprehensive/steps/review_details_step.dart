import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simone/src/models/policy.dart';

class ReviewDetailsStep extends StatelessWidget {
  const ReviewDetailsStep({
    super.key,
    required this.policy,
    required this.updatePolicy,
  });

  final ValueNotifier<Policy> policy;
  final Function(Policy) updatePolicy;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          form(
            context,
            title: 'Policy Cover',
            icon: FontAwesomeIcons.fileShield,
            body: [
              formItem(
                label: 'Type of Vehicle',
                value: policy.value.typeOfCover,
              ),
            ],
          ),
          const SizedBox(height: 25),
          form(
            context,
            title: 'Vehicle Data',
            icon: FontAwesomeIcons.car,
            body: [
              formItem(
                label: 'Plate Number',
                value: policy.value.plateNumber,
              ),
              formItem(
                label: 'Chassis Number',
                value: policy.value.chassisNumber,
              ),
              formItem(
                label: 'Engine Number',
                value: policy.value.engineNumber,
              ),
              formItem(
                label: 'Car Brand',
                value: policy.value.carBrand,
              ),
              formItem(
                label: 'Car Model',
                value: policy.value.carModel,
              ),
              formItem(
                label: 'Car Type',
                value: policy.value.carType,
              ),
              formItem(
                label: 'Car Variant',
                value: policy.value.carVariant,
              ),
            ],
          ),
          const SizedBox(height: 20),
          form(
            context,
            title: 'Profile Data',
            icon: FontAwesomeIcons.solidUser,
            body: [
              formItem(
                label: 'Full Name',
                value: policy.value.fullName,
              ),
              formItem(
                label: 'Address 1',
                value: policy.value.address1,
              ),
              formItem(
                label: 'Address 2',
                value: policy.value.address2,
              ),
              formItem(
                label: 'Date of Birth',
                value: policy.value.dateOfBirth,
              ),
              formItem(
                label: 'Email Address',
                value: policy.value.email,
              ),
              formItem(
                label: 'Phone No.',
                value: policy.value.phoneNo,
              ),
              formItem(
                label: 'Mobile No.',
                value: policy.value.mobileNo,
              ),
              formItem(
                label: 'TIN #',
                value: policy.value.tin,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget form(
    context, {
    String? title,
    IconData? icon,
    List<Widget> body = const [],
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon ?? Icons.assignment_rounded,
              size: 25,
              color: Theme.of(context).primaryColorDark,
            ),
            const SizedBox(width: 10),
            Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 16,
                letterSpacing: -0.1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).highlightColor,
        ),
        ...body,
      ],
    );
  }

  Widget formItem({String? label, String? value}) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(label ?? '',
                style: TextStyle(
                  color: Colors.grey[500],
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              value ?? '',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

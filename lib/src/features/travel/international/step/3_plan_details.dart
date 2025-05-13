import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';

class InternationalPlanDetails extends StatefulHookWidget {
  const InternationalPlanDetails({super.key, required this.intData});

  final ValueNotifier<TravelModel> intData;
  @override
  State<InternationalPlanDetails> createState() =>
      _InternationalPlanDetailsState();
}

class _InternationalPlanDetailsState extends State<InternationalPlanDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 244, 238),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 2,
                      color: Colors.grey[200]!,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '₱${widget.intData.value.totalPremium}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const Divider(),
                    _rowTextData(
                      title: 'Policy Duration',
                      data: 'Single Trip',
                    ),
                    _rowTextData(
                      title: 'Type of Cover',
                      data: widget.intData.value.travelAs ?? 'Individual',
                    ),
                    _rowTextData(
                      title: 'No of Traveler(s)',
                      data: widget.intData.value.travelAs == 'Individual'
                          ? '1'
                          : (int.parse(widget.intData.value.noOfAdult ?? '0') +
                                  int.parse(
                                      widget.intData.value.noOfMinor ?? '0'))
                              .toString(),
                    ),
                    _rowTextData(
                      title: 'Type of Plan',
                      data: widget.intData.value.selectedPlan ?? '',
                    ),
                    _rowTextData(
                      title: 'Less Opt-out',
                      data: (widget.intData.value.selectedLessOptOut ?? {})
                              .isNotEmpty
                          ? ''
                          : 'None',
                    ),
                    if ((widget.intData.value.selectedLessOptOut ?? {})
                        .isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: widget.intData.value.selectedLessOptOut!
                            .toList()
                            .length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        itemBuilder: (context, index) {
                          final opt = widget.intData.value.selectedLessOptOut!
                              .toList()[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  '• ${opt.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '(₱${opt.amount})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    _rowTextData(
                      title: 'Destination',
                      data: widget.intData.value.countries!
                          .map((value) => value?.country)
                          .toList()
                          .join(", "),
                    ),
                    _rowTextData(
                      title: 'Cover Start Date',
                      data: DateFormat('MMMM d, y').format(DateTime.parse(
                          widget.intData.value.departFrom.toString())),
                    ),
                    _rowTextData(
                      title: 'Cover End Date',
                      data: DateFormat('MMMM d, y').format(DateTime.parse(
                          widget.intData.value.arriveIn.toString())),
                    ),
                    const Divider(),
                    _rowTextData(
                      title: 'Basic Premium',
                      data: '₱${widget.intData.value.basicPremium}',
                    ),
                    _rowTextData(
                      title: 'LGT',
                      data: '₱${widget.intData.value.lgt}',
                    ),
                    _rowTextData(
                      title: 'DST',
                      data: '₱${widget.intData.value.dst}',
                    ),
                    _rowTextData(
                      title: 'Premium Tax',
                      data: '₱${widget.intData.value.premiumTax}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowTextData({required String title, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15.0,
                fontFamily: 'OpenSans',
                color: Color(0xfffe5000),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: Text(
              data,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}

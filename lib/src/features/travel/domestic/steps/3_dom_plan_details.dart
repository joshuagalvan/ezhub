import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:simone/src/features/travel/data/models/travel_model.dart';
import 'package:simone/src/utils/colorpalette.dart';

class DomesticPlanDetails extends StatefulHookWidget {
  const DomesticPlanDetails({
    super.key,
    required this.domData,
  });

  final ValueNotifier<TravelModel> domData;

  @override
  State<DomesticPlanDetails> createState() => _DomesticPlanDetailsState();
}

class _DomesticPlanDetailsState extends State<DomesticPlanDetails> {
  @override
  Widget build(BuildContext context) {
    final premiumBreakdown = useState<Map<String, dynamic>>({});
    final isLoading = useState(true);
    ValueNotifier<String> lgtRate = useState('');

    Future<void> getBranch() async {
      final storage = GetStorage();
      final branchData = await storage.read('branch');

      if (branchData != null) {
        lgtRate.value = (branchData['locTax']).toString();
      }
    }

    Future<void> getPremium() async {
      final from = DateTime.parse('${widget.domData.value.departFrom}');
      final to = DateTime.parse('${widget.domData.value.arriveIn}');
      final travelDays = to.difference(from).inDays + 1;
      widget.domData.value = widget.domData.value.copyWith(
        totalTravelDays: travelDays.toString(),
      );
      try {
        final response = await http.get(Uri.parse(
            'http://10.52.2.124:9017/travel/getPremiumComputation_json/?line=domestic&plan_id=${widget.domData.value.selectedPlanId}&account=PESO&covid_protection=0&lgt_rate=${lgtRate.value}&bdate=4/5/1997&travel_destination=&travel_days=$travelDays'));
        var result = (jsonDecode(response.body));
        premiumBreakdown.value = result;
      } catch (_) {}
    }

    useEffect(() {
      async() async {
        await getBranch();
        await getPremium();
        isLoading.value = false;
      }

      async();
      return null;
    }, []);

    return isLoading.value
        ? const Center(
            child: SpinKitChasingDots(
              color: ColorPalette.primaryColor,
            ),
          )
        : Padding(
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
                              '₱${premiumBreakdown.value['total_premium']}',
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
                            data: widget.domData.value.travelType.toString(),
                          ),
                          _rowTextData(
                            title: 'Type of Plan',
                            data: widget.domData.value.selectedPlan.toString(),
                          ),
                          _rowTextData(
                            title: 'Destination',
                            data: widget.domData.value.provinces!
                                .map((value) => value?.name)
                                .toList()
                                .join(", "),
                          ),
                          _rowTextData(
                            title: 'Type of Insurance',
                            data: widget.domData.value.travelAs.toString(),
                          ),
                          _rowTextData(
                            title: 'No of Traveler(s)',
                            data: '1',
                          ),
                          _rowTextData(
                            title: 'Cover Start Date',
                            data: DateFormat('MMMM d y').format(DateTime.parse(
                                widget.domData.value.departFrom.toString())),
                          ),
                          _rowTextData(
                            title: 'Cover End Date',
                            data: DateFormat('MMMM d y').format(DateTime.parse(
                                widget.domData.value.arriveIn.toString())),
                          ),
                          const Divider(),
                          _rowTextData(
                            title: 'Basic Premium',
                            data: '₱${premiumBreakdown.value['basic_premium']}',
                          ),
                          _rowTextData(
                            title: 'LGT',
                            data: '₱${premiumBreakdown.value['lgt']}',
                          ),
                          _rowTextData(
                            title: 'DST',
                            data: '₱${premiumBreakdown.value['dst']}',
                          ),
                          _rowTextData(
                            title: 'Premium Tax',
                            data: '₱${premiumBreakdown.value['premium_tax']}',
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

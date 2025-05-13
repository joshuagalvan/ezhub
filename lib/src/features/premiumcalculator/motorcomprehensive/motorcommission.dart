import 'package:flutter/material.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';

class MotorCommissionPageView extends StatefulWidget {
  const MotorCommissionPageView({
    super.key,
    required this.quote,
    required this.onPrevPressed,
    required this.onNextPressed,
  });

  final Function() quote;
  final Function() onPrevPressed;
  final Function() onNextPressed;
  @override
  State<MotorCommissionPageView> createState() =>
      _MotorCommissionPageViewState();
}

class _MotorCommissionPageViewState extends State<MotorCommissionPageView> {
  late dynamic quotes;

  @override
  void initState() {
    super.initState();
    getQuote();
  }

  getQuote() {
    quotes = widget.quote();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(defaultSizePrem),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(defaultSizePrem),
              decoration: BoxDecoration(
                color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      totalcommission,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '₱${quotes!['totalCom'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    comBreak,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _rowTextData(
                    title: "• Basic Premium:",
                    data:
                        '₱${quotes!['basicPrem'].toString().formatWithCommas()}',
                  ),
                  _rowTextData(
                    title: "• Commission Rate:",
                    data:
                        '${quotes!['comRate'].toString().formatWithCommas()} %',
                  ),
                  _rowTextData(
                    title: "• Sum Insured:",
                    data:
                        '₱${quotes!['fmvValue'].toString().formatWithCommas()}',
                  ),
                  const Divider(),
                  const Text(
                    "Own Damage ",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _rowTextData(
                    title: "• Gross Premium:",
                    data: '₱${quotes!['od'].toString().formatWithCommas()}',
                  ),
                  _rowTextData(
                    title: "• Rate:",
                    data:
                        '${(double.parse(quotes!['odRate'].toString()) * 100)}%',
                  ),
                  _rowTextData(
                    title: "• Own Damage Commission:",
                    data: '₱${quotes!['odCom'].toString().formatWithCommas()}',
                  ),
                  const Divider(),
                  const Text(
                    "Act of Nature",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  _rowTextData(
                    title: "• Gross Premium:",
                    data: '₱${quotes!['aon'].toString().formatWithCommas()}',
                  ),
                  _rowTextData(
                    title: "• Rate:",
                    data:
                        '${double.parse(quotes!['aonRate'].toString()) * 100}%',
                  ),
                  _rowTextData(
                    title: "• Acts of Nature Commission:",
                    data: '₱${quotes!['aonCom'].toString().formatWithCommas()}',
                  ),
                  const Divider(),
                  const Text(
                    "VTPL - Bodily Injury",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  _rowTextData(
                    title: "• Gross Premium:",
                    data:
                        '₱${quotes!['vtplbiValue'].toString().formatWithCommas()}',
                  ),
                  _rowTextData(
                    title: "• VTPL - Bodily Injury Commission:",
                    data:
                        '₱${quotes!['vtplbiCom'].toString().formatWithCommas()}',
                  ),
                  const Divider(),
                  const Text(
                    "VTPL - Property Damage",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _rowTextData(
                    title: "• Gross Premium:",
                    data:
                        '₱${quotes!['vtplpdValue'].toString().formatWithCommas()}',
                  ),
                  _rowTextData(
                    title: "• VTPL - Property Damage Commission:",
                    data:
                        '₱${quotes!['vtplpdCom'].toString().formatWithCommas()}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: widget.onPrevPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: widget.onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
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
          Text(
            data,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';

class TravelDomesticCommission extends StatefulWidget {
  const TravelDomesticCommission({
    super.key,
    required this.quoteTravel,
    required this.onPrevPressed,
    required this.onNextPressed,
  });

  final Function() quoteTravel;
  final Function() onPrevPressed;
  final Function() onNextPressed;
  @override
  State<TravelDomesticCommission> createState() =>
      _TravelDomesticCommissionState();
}

class _TravelDomesticCommissionState extends State<TravelDomesticCommission> {
  dynamic quotes;

  @override
  void initState() {
    super.initState();
    getQuote();
  }

  getQuote() async {
    quotes = await widget.quoteTravel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
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
                    quotes == null
                        ? ''
                        : '₱ ${quotes['travelDomCommission'].toString().formatWithCommas()}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  comBreak,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _rowTextData(
                  title: 'Basic Premium:',
                  data: quotes == null
                      ? ''
                      : '₱ ${quotes['basic_premium'].toString().formatWithCommas()}',
                ),
                _rowTextData(
                  title: 'Commission Rate:',
                  data: '35%',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
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
        ),
      ],
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

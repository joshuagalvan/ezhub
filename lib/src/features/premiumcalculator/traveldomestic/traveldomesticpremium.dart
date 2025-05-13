import 'package:flutter/material.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/utils/extensions.dart';

class TravelDomesticPremium extends StatefulWidget {
  const TravelDomesticPremium({
    super.key,
    required this.quoteTravel,
    required this.onPrevPressed,
  });

  final Function() quoteTravel;
  final Function() onPrevPressed;

  @override
  State<TravelDomesticPremium> createState() => _TravelDomesticPremiumState();
}

class _TravelDomesticPremiumState extends State<TravelDomesticPremium> {
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
                    totalPremium,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    quotes == null ? '' : '₱${quotes['total_premium']}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  premBreak,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _rowTextData(
                  title: 'Basic Premium:',
                  data: quotes == null
                      ? ''
                      : '₱${quotes['basic_premium']}'.formatWithCommas(),
                ),
                _rowTextData(
                  title: 'Documentary Stamp Tax:',
                  data: quotes == null
                      ? ''
                      : '₱${quotes['dst']}'.formatWithCommas(),
                ),
                _rowTextData(
                  title: 'Premium Tax:',
                  data: quotes == null
                      ? ''
                      : '₱${quotes['premium_tax']}'.formatWithCommas(),
                ),
                _rowTextData(
                  title: 'Local Government Tax:',
                  data: quotes == null
                      ? ''
                      : '₱${quotes['lgt']}'.formatWithCommas(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: widget.onPrevPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xfffe5000),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xfffe5000),
              ),
              child: const Text(
                issuePolicy,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
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

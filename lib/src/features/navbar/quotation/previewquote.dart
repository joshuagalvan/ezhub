import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simone/src/constants/sizes.dart';
import 'package:simone/src/constants/text_strings.dart';
import 'package:simone/src/helpers/api.dart';
import 'package:simone/src/utils/colorpalette.dart';
import 'package:simone/src/utils/extensions.dart';

class PreviewQuote extends StatefulWidget {
  const PreviewQuote({
    super.key,
    required this.id,
    required this.onEmail,
    required this.onIssuedPolicy,
  });

  final int id;
  final Function() onEmail;
  final Function() onIssuedPolicy;

  @override
  State<PreviewQuote> createState() => _PreviewQuoteState();
}

class _PreviewQuoteState extends State<PreviewQuote> {
  bool isLoading = false;
  dynamic refNo,
      intermediary,
      created_date,
      name,
      email,
      branch,
      toc,
      rate,
      year,
      carCompanyValue,
      carMakeValue,
      carTypeValue,
      carVariantValue,
      fmv,
      deductible,
      totalpremium,
      basicPremium,
      docStamp,
      vat,
      localTax,
      od,
      aon,
      periodOfInsurance,
      quotationExpiry,
      status,
      vtplbi,
      vtplpd,
      odRate,
      aonRate;

  @override
  void initState() {
    super.initState();
    getQuotationDetails(widget.id);
  }

  getQuotationDetails(id) async {
    setState(() {
      isLoading = true;
    });
    var result = await Api().getQuotationDetails(id);
    var row = result['data'];
    setState(() {
      isLoading = false;
    });
    refNo = row['ref_number'];
    intermediary = row['intermediary'];
    created_date = row['created_date'];
    name = row['name'];
    email = row['email'];
    branch = row['branch'];
    toc = row['toc'];
    rate = row['rate'];
    year = row['year'];
    carCompanyValue = row['car_company'];
    carMakeValue = row['car_make'];
    carTypeValue = row['car_type'];
    carVariantValue = row['car_variant'];
    fmv = row['fmv'];
    deductible = row['deductible'];
    totalpremium = row['total_premium'];
    basicPremium = row['basic_premium'];
    docStamp = row['doc_stamp'];
    vat = row['vat'];
    localTax = row['local_tax'];
    od = row['od'];
    aon = row['aon'];
    periodOfInsurance = row['period_of_insurance'];
    quotationExpiry = row['quotation_expiry'];
    status = row['status'];
    vtplbi = row['vtpl_bi'];
    vtplpd = row['vtpl_pd'];
    odRate = "${row['od_rate'] * 100} %";
    aonRate = "${row['aon_rate'] * 100} %";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Preview Quote",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: widget.onEmail,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xfffe5000),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    sendEmail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: widget.onIssuedPolicy,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xfffe5000),
              ),
              child: const Row(
                children: [
                  Icon(
                    FontAwesomeIcons.fileInvoice,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    issuePolicy,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const SpinKitChasingDots(
              color: ColorPalette.primaryColor,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultSize,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Container(
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Motor Insurance",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        _rowTextData(
                          title: 'Branch Name:',
                          data: branch,
                        ),
                        _rowTextData(
                          title: 'Type of Cover:',
                          data: toc,
                        ),
                        _rowTextData(
                          title: 'Agent Code:',
                          data: intermediary,
                        ),
                        _rowTextData(
                          title: 'Insured Name:',
                          data: name,
                        ),
                        _rowTextData(
                          title: 'Insured Email:',
                          data: email,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Vehicle Details",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        _rowTextData(
                          title: 'Manufactured Year',
                          data: year,
                        ),
                        _rowTextData(
                          title: 'Car Company:',
                          data: carCompanyValue,
                        ),
                        _rowTextData(
                          title: 'Car Make Model:',
                          data: carMakeValue,
                        ),
                        _rowTextData(
                          title: 'Car Type:',
                          data: carTypeValue,
                        ),
                        _rowTextData(
                          title: 'Car Variance:',
                          data: carVariantValue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Peril Details",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        _rowTextData(
                          title: 'Market Value',
                          data: '₱${fmv.toString().formatWithCommas()}',
                        ),
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Own Damage ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'OpenSans',
                              color: Color(0xfffe5000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _rowTextData(
                          title: 'Sum Insured',
                          data: '₱${fmv.toString().formatWithCommas()}',
                        ),
                        _rowTextData(
                          title: 'Gross Premium',
                          data: '₱${od.toString().formatWithCommas()}',
                        ),
                        _rowTextData(
                          title: 'Rate',
                          data: odRate.toString().formatWithCommas(),
                        ),
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Acts of Nature ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'OpenSans',
                              color: Color(0xfffe5000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _rowTextData(
                          title: 'Sum Insured',
                          data: '₱${fmv.toString().formatWithCommas()}',
                        ),
                        _rowTextData(
                          title: 'Gross Premium',
                          data: '₱${aon.toString().formatWithCommas()}',
                        ),
                        _rowTextData(
                          title: 'Rate',
                          data: aonRate.toString().formatWithCommas(),
                        ),
                        const Divider(),
                        _rowTextData(
                          title: 'RSCC:',
                          data: included,
                        ),
                        const Divider(),
                        _rowTextData(
                          title: 'VTPL - Bodily Injury:',
                          data: '₱${vtplbi.toString().formatWithCommas()}',
                        ),
                        _rowTextData(
                          title: 'VTPL - Property Damage:',
                          data: '₱${vtplpd.toString().formatWithCommas()}',
                        ),
                        _rowTextData(
                          title: 'Auto Personal Accident:',
                          data: included,
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _rowTextData({required String title, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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

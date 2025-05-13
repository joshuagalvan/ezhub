import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class Paynamics {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String refNo = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  Paynamics({required this.details});
  final dynamic details;

  getRedirect() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.payserv.net/v1/rpf/transactions/rpf/'),
        headers: {
          'Accept': "application/json",
          'Authorization':
              "Basic ${stringToBase64.encode('fpginsuranceX1Zd:ovX1Zd1geVHJ')}"
        },
        body: payload(),
      );
      var result = (jsonDecode(response.body));
      log(result['redirect_url']);

      return result['redirect_url'];
    } catch (_) {
    }
  }

  transactionSignature() {
    var bytes1 = utf8.encode([
      '000000110123EFE520B1',
      'EZH$refNo',
      'http://www.google.com',
      'https://www.google.com/success',
      'https://www.google.com/cancel',
      '',
      details['totalPremium'] ?? '',
      '₱',
      1,
      1,
      '483F7CD5D55E5E65102E64D5743E708B'
    ].join('')); // data being hashed
    return (sha512.convert(bytes1).toString());
  }

  customerSignature() {
    var bytes1 = utf8.encode(([
      details['firstName'] ?? '',
      details['lastName'] ?? '',
      details['middleName'] ?? '',
      details['email'] ?? '',
      details['phoneNo'] ?? '',
      details['mobileNo'] ?? '',
      '', // birth date
      '483F7CD5D55E5E65102E64D5743E708B'
    ].join(''))); // data being hashed
    return (sha512.convert(bytes1).toString());
  }

  payload() {
    return (jsonEncode({
      'transaction': {
        'request_id': 'EZH$refNo',
        'notification_url': 'http://www.google.com',
        'response_url': 'https://www.google.com/success',
        'cancel_url': 'https://www.google.com/cancel',
        'pchannel':
            "pnb_ph,ucpb_ph,ecpay_ph,da5_ph,expresspay_ph,711_ph,mlhuillier_ph,cebuana_ph,smbills_ph,truemoney_ph,posible_ph,bdo_cc_ph,gpap_cc_ph,metrobank_cc_ph,maybank_cc_ph,ubp_cc_ph,rbank_cc_ph,rcbc_cc_ph,bdoobp,pnbobp,ucpbobp,sbobp,ubp_online,gc",
        'payment_notification_status': 1,
        'payment_notification_channel': 1,
        'amount': details['totalPremium'] ?? '',
        'currency': '₱',
        'trx_type': 'sale',
        'signature': transactionSignature(),
      },
      'billing_info': {
        'billing_address1': details['address1'] ?? '',
        'billing_address2': details['address2'] ?? '',
        'billing_city': details['city'] ?? '',
        'billing_state': details['state'] ?? '',
        'billing_country': details['country'] ?? '',
        'billing_zip': details['zip'] ?? '',
      },
      'shipping_info': {
        'shipping_address1': details['address1'] ?? '',
        'shipping_address2': details['address2'] ?? '',
        'shipping_city': details['city'] ?? '',
        'shipping_state': details['state'] ?? '',
        'shipping_country': details['country'] ?? '',
        'shipping_zip': details['zip'] ?? '',
      },
      'customer_info': {
        'fname': details['firstName'] ?? '',
        'lname': details['lastName'] ?? '',
        'mname': details['middleName'] ?? '',
        'email': details['email'] ?? '',
        'phone': details['phoneNo'] ?? '',
        'mobile': details['mobileNo'] ?? '',
        'dob': '',
        'signature': customerSignature(),
      },
      'order_details': {
        'orders': [
          {
            'itemname': 'Premium',
            'quantity': 1,
            'unitprice': details['totalPremium'] ?? '',
            'totalprice': details['totalPremium'] ?? '',
          }
        ],
        'subtotalprice': details['totalPremium'] ?? '',
        'shippingprice': 0,
        'discountamount': 0,
        'totalorderamount': details['totalPremium'] ?? '',
      }
    }));
  }
}

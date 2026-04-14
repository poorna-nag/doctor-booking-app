import 'dart:convert';
import 'dart:developer';

import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import '../General/AppConstant.dart';

class PhonepePaymentController with ChangeNotifier {
  List verifyPamentResponseData = [];
  String payUrl = '';
  int? merchantTransactionId;

  bool isPayLoading = false;
  Future<bool> initiatePhonePeTransaction({required String amount}) async {
    bool check = false;

    notifyListeners();
    try {
      final userId = GroceryAppConstant.user_id;
      String? shopId = GroceryAppConstant.Shop_id;

      var map = new Map<String, dynamic>();
      map['shop_id'] = shopId;
      map['user_id'] = userId;
      map['amount'] = amount;

      final response = await http.post(
          Uri.parse(
              GroceryAppConstant.base_url + 'phonepe/gen_transaction.php'),
          body: map);
      print(GroceryAppConstant.base_url +
          'phonepe/gen_transaction.php' +
          response.body);
      if (response.statusCode == 200) {
        print(response.toString());
        final jsonBody = json.decode(response.body);
        // loginModal user = loginModal.fromJson(jsonDecode(response.body));
        print(jsonBody.toString());
        if (jsonBody['success'] == 'true') {
          payUrl = jsonBody['url'];
          merchantTransactionId = jsonBody['tx_id'];
          payUrl = payUrl.replaceAll('\\', '');
          // merchantTransactionId = merchantTransactionId!.replaceAll('\\', '');

          log('payUrl------------>>   $payUrl');
          log('merchantTransactionId------------>>   $merchantTransactionId');
          check = true;
          notifyListeners();
        } else {
          // _showLongToast("not available at the moment");
        }
      } else
        throw Exception("Unable to get phonepay link");
    } catch (e) {
      // _showLongToast("not available at the moment");
      notifyListeners();
      log(e.toString());
    }
    return check;
  }

  Future<String> checkWalletAddPaymnetverify(BuildContext context,
      {required String txId}) async {
    String status = '';
    try {
      var map = new Map<String, dynamic>();
      map['tx_id'] = merchantTransactionId.toString();
      map['shop_id'] = GroceryAppConstant.Shop_id;
      // map['amount'] = amount;

      final response = await http.post(
          Uri.parse(GroceryAppConstant.base_url + 'phonepe/check_status.php'),
          body: map);
      print(GroceryAppConstant.base_url +
          'phonepe/check_status.php' +
          response.body);
      if (response.statusCode == 200) {
        print(response.toString());
        final jsonBody = json.decode(response.body);
        // loginModal user = loginModal.fromJson(jsonDecode(response.body));
        print(jsonBody.toString());
        if (jsonBody['success'] == 'true') {
          status = jsonBody['status'];

          notifyListeners();
        } else {
          // _showLongToast("not available at the moment");
        }
      } else
        throw Exception("Unable to get phonepay link");
    } catch (e) {
      log(e.toString());
      // setSnackbar(getTranslated(context, 'somethingMSg')!, context);
    }
    return status;
  }

  void _showLongToast(String s) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}

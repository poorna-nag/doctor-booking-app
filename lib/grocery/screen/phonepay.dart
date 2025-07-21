// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:aladdinmart/grocery/dbhelper/CarrtDbhelper.dart';
// import 'package:crypto/crypto.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../BottomNavigation/wishlist.dart';
// // import '../../General/AppConstant.dart';
// import '../../controller/phonepay_controller.dart';
// import '../../model/InvoiceModel.dart';
// import '../../screen/finalScreen.dart';
// import '../General/AppConstant.dart';

// class PhonepePaymentScreen extends StatefulWidget {
//   const PhonepePaymentScreen(
//       {Key? key,
//       required this.paymentUrl,
//       required this.merchantTransactionId,
//       required this.amount,
//       required this.paymentType,
//       required this.email,
//       required this.name,
//       required this.mobile,
//       required this.address,
//       required this.pincode,
//       required this.city,
//       required this.deliveryfee,
//       required this.coupancode,
//       required this.difference,
//       required this.onedayprice,
//       required this.prodctlist1,
//       required this.username,
//       required this.finalamt,
//       required this.shipping,
//       required this.usedWalletamt,
//       required this.mv,
//       required this.lat,
//       required this.long,
//       required this.coupoun,
//       required this.coupoun_amount,
//       required this.fast_price,
//       required this.checkbox})
//       : super(key: key);
//   final String paymentUrl;
//   final String amount;
//   final int merchantTransactionId;
//   final String paymentType;
//   final String email;
//   final String name;
//   final String mobile;

//   final String username;
//   final String finalamt;
//   final String usedWalletamt;

//   final String address;
//   final String pincode;
//   final String city;
//   final String deliveryfee;
//   final String coupancode;
//   final String difference;
//   final String onedayprice;
//   final String shipping;
//   final String coupoun_amount;
//   final String coupoun;
//   final String long;
//   final String lat;
//   final String mv;
//   final String fast_price;

//   final bool checkbox;
//   final List<ProductsCart> prodctlist1;
//   @override
//   State<PhonepePaymentScreen> createState() => _PhonepePaymentScreenState();
// }

// class _PhonepePaymentScreenState extends State<PhonepePaymentScreen> {
//   final GlobalKey webViewKey = GlobalKey();
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//     crossPlatform: InAppWebViewOptions(
//       applicationNameForUserAgent: '',
//       javaScriptEnabled: true,
//       supportZoom: false,
//       useShouldOverrideUrlLoading: true,
//       mediaPlaybackRequiresUserGesture: false,
//       userAgent:
//           // ''
//           'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
//     ),
//     android: AndroidInAppWebViewOptions(
//       allowFileAccess: true,
//       allowContentAccess: true,
//       supportMultipleWindows: true,
//       thirdPartyCookiesEnabled: true,
//       useHybridComposition: true,
//       loadWithOverviewMode: true,
//       domStorageEnabled: true,
//     ),
//     ios: IOSInAppWebViewOptions(
//       sharedCookiesEnabled: true,
//     ),
//   );
//   final DbProductManager dbmanager = new DbProductManager();
//   InAppWebViewController? webViewController;
//   PullToRefreshController? pullToRefreshController;
//   bool result = false;
//   String url = '';
//   double progress = 0;
//   final urlController = TextEditingController();
//   bool isShowWebView = false;
//   String userId = '';
//   String shareLink = '';
//   String? initiaUrl;
//   @override
//   void initState() {
//     super.initState();
//     log('wenview');
//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _exitApp(context),
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white,
//           elevation: 0,
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   showDilogueExitPayment(context);
//                 },
//                 child: const Text(
//                   'Close',
//                   style: TextStyle(fontSize: 16),
//                 ))
//           ],
//         ),
//         body: SafeArea(
//           child: Stack(children: [
//             Consumer(
//               builder:
//                   (context, PhonepePaymentController phhonepeProvider, child) {
//                 return result
//                     ? const Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : InAppWebView(
//                         key: webViewKey,
//                         initialUrlRequest: URLRequest(
//                           url: Uri.parse(widget.paymentUrl),
//                         ),
//                         initialOptions: options,
//                         pullToRefreshController: pullToRefreshController,
//                         onLoadStart: (controller, url) async {
//                           setState(() {
//                             this.url = url.toString();
//                           });
//                         },
//                         androidOnPermissionRequest:
//                             (controller, origin, resources) async {
//                           return PermissionRequestResponse(
//                               resources: resources,
//                               action: PermissionRequestResponseAction.GRANT);
//                         },
//                         shouldOverrideUrlLoading:
//                             (controller, navigationAction) async {
//                           log(navigationAction.request.url.toString());
//                           var uri = navigationAction.request.url!;

//                           if (uri.scheme.contains('verify_payment.php')) {
//                             setState(() {
//                               result = true;
//                             });
//                             webViewController?.goBack();
//                             webViewController?.goBack();
//                             phhonepeProvider
//                                 .checkWalletAddPaymnetverify(context, txId: '')
//                                 .then((value) {
//                               String msg = '';
//                               if (value == '0') {
//                                 msg = 'Transaction Pending';
//                               } else if (value == '2') {
//                                 msg = 'Transaction Successfull';
//                               } else {
//                                 msg = 'Transaction Failed';
//                               }

//                               if (value == '0' || value == '2') {
//                                 if (widget.paymentType == 'prime' ||
//                                     widget.paymentType == 'pro') {
//                                   successPopUp(context);
//                                   Future.delayed(const Duration(seconds: 2))
//                                       .then((value) {});

//                                   _showLongToast(msg);
//                                 } else {
//                                   /// Order place API
//                                 }
//                               } else {
//                                 _showLongToast(msg);
//                                 Navigator.of(context).pop();
//                               }
//                             });
//                             log('shouldOverrideUrlLoading');

//                             return NavigationActionPolicy.CANCEL;
//                           } else if (uri.scheme
//                               .contains('payment_status=Failed')) {
//                             Navigator.of(context).pop();

//                             return NavigationActionPolicy.CANCEL;
//                           }
//                           return NavigationActionPolicy.ALLOW;
//                         },
//                         onLoadStop: (controller, url) async {
//                           log(url.toString());

//                           if (url.toString().contains('verify_payment.php')) {
//                             setState(() {
//                               result = true;
//                             });
//                             log('shouldOverrideUrlLoading  onLoadStop');
//                             webViewController?.goBack();
//                             webViewController?.goBack();
//                             phhonepeProvider
//                                 .checkWalletAddPaymnetverify(context, txId: '')
//                                 .then((value) {
//                               String msg = '';
//                               if (value == '0') {
//                                 msg = 'Transaction Pending';
//                               } else if (value == '2') {
//                                 msg = 'Transaction Successfull';
//                               } else {
//                                 msg = 'Transaction Failed';
//                               }

//                               if (value == '0' || value == '2') {
//                                 if (widget.paymentType == 'prime' ||
//                                     widget.paymentType == 'pro') {
//                                   successPopUp(context);
//                                   Future.delayed(const Duration(seconds: 2))
//                                       .then((value) {});

//                                   _showLongToast(msg);
//                                 } else {
//                                   _getInvoice('ONLINE');
//                                   _showLongToast(msg);
//                                 }
//                               } else {
//                                 _showLongToast(msg);
//                                 Navigator.of(context).pop();
//                               }
//                             });
//                           }

//                           pullToRefreshController!.endRefreshing();
//                           setState(() {
//                             this.url = url.toString();
//                           });
//                         },
//                         onProgressChanged: (controller, progress) {
//                           if (progress == 100) {
//                             pullToRefreshController?.endRefreshing();
//                           }
//                           setState(() {
//                             this.progress = progress / 100;
//                           });
//                         },
//                         onUpdateVisitedHistory:
//                             (controller, url, androidIsReload) {
//                           setState(() {
//                             this.url = url.toString();
//                           });
//                         },
//                         onConsoleMessage: (controller, consoleMessage) {},
//                       );
//               },
//             ),
//             progress < 1.0
//                 ? LinearProgressIndicator(value: progress)
//                 : Container()
//           ]),
//         ),
//       ),
//     );
//   }

//   Future<bool> _exitApp(BuildContext context) async {
//     if (await webViewController?.canGoBack() ?? false) {
//       webViewController?.goBack();
//       return Future.value(false);
//     } else {
//       return Future.value(false);
//     }
//   }

//   void successPopUp(context) async {
//     await showDialog(
//       // barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return Dialog(
//           child: SizedBox(
//             height: 350,
//             child: Column(
//               children: [
//                 Container(
//                   height: 300,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                       image: DecorationImage(
//                           image:
//                               AssetImage('assets/staticimage/sucprim.jpeg'))),
//                 ),
//                 const Text(
//                   'Congratulations 🎉',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   showDilogueExitPayment(
//     BuildContext context,
//   ) {
//     Dialog errorDialog = Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0)), //this right here
//       child: SizedBox(
//         height: 130.0,
//         width: 200.0,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: 20,
//             ),
//             const Text(
//               'Do You Want To Exit From Payment?',
//               style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 SizedBox(
//                   width: 20,
//                 ),
//                 TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text(
//                       'CANCEL',
//                       style: TextStyle(color: Colors.black, fontSize: 14.0),
//                     )),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     'YES',
//                     style: TextStyle(color: Colors.red, fontSize: 14.0),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => errorDialog,
//     );
//   }

//   void _showLongToast(String s) {
//     Fluttertoast.cancel();
//     Fluttertoast.showToast(
//       msg: s,
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }

//   Future _getInvoice(
//     String paymode,
//   ) async {
//     print('called data oredr first');
//     var map = Map<String, dynamic>();
//     map['name'] = widget.name;
//     map['mobile'] = widget.username;
//     map['email'] = widget.email;
//     map['address'] = widget.address;
//     map['pincode'] = widget.pincode;
//     map['city'] = widget.city;
//     map['invoice_total'] = widget.finalamt.toString();
//     map['notes'] = "no notes";
//     map['shop_id'] = GroceryAppConstant.Shop_id.toString();
//     map['PayMode'] = paymode;
//     map['user_id'] = GroceryAppConstant.user_id;
//     map['shipping'] = widget.deliveryfee;
//     map['mv'] = widget.prodctlist1[0].mv.toString();
//     map['lat'] = widget.lat.toString();
//     map['lng'] = widget.long.toString();
//     map['coupon'] = widget.coupancode != null ? widget.coupancode : "";
//     map['couponAmount'] = widget.difference.toString();
//     map['fast_price'] =
//         widget.onedayprice != null ? widget.onedayprice.toString() : "0.0";
//     print('map-------->${map}');
//     final response = await http.post(
//         Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
//         body: map);
//     print('called data oredr' + response.body);
//     if (response.statusCode == 200) {
// //      final jsonBody = json.decode(response.body);
//       Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
//       // print("123"+user.Invoice);
//       if (user.success.toString() == "true") {
//         print("12345" + user.Invoice.toString());
//         print('called data oredr' + user.Invoice.toString());
//         _uploadProducts(invoice: user.Invoice ?? '');
//       } else {
//         showLongToast('Invoice is not generated');
//       }
//     } else
//       throw Exception("Unable to generate Employee Invoice");
// //    print("123  Unable to generate Employee Invoice");
//   }

//   Future _uploadProducts({required String invoice}) async {
//     SharedPreferences pre = await SharedPreferences.getInstance();
//     print('called data oredr secnd');
//     print('called data oredr secnd      ' + GroceryAppConstant.email);

//     final email = GroceryAppConstant.email.contains("@gmai.com") ||
//             GroceryAppConstant.email.contains("@")
//         ? GroceryAppConstant.email
//         : 'shahiexpressofficial@gmail.com';

//     print('called data email      ' + email);

//     for (int i = 0; i < widget.prodctlist1.length; i++) {
//       var map = Map<String, dynamic>();

//       map['invoice_id'] = invoice;
//       map['product_id'] = widget.prodctlist1[i].pid;
//       map['product_name'] = widget.prodctlist1[i].pname;
//       map['quantity'] = widget.prodctlist1[i].pQuantity.toString();
//       map['price'] = (double.parse(widget.prodctlist1[i].costPrice ?? "") *
//               widget.prodctlist1[i].pQuantity!)
//           .toString();
//       map['user_per'] = widget.prodctlist1[i].discount;
//       map['user_dis'] =
//           (double.parse(widget.prodctlist1[i].discountValue ?? "") *
//                   widget.prodctlist1[i].pQuantity!)
//               .toStringAsFixed(2)
//               .toString();
//       map['admin_per'] = widget.prodctlist1[i].adminper;
//       map['admin_dis'] = widget.prodctlist1[i].adminpricevalue;
//       map['shop_id'] = GroceryAppConstant.Shop_id;
//       map['cgst'] = widget.prodctlist1[i].cgst;
//       map['sgst'] = widget.prodctlist1[i].sgst;
//       map['variant'] = widget.prodctlist1[i].varient == null
//           ? " "
//           : WishlistState.prodctlist1![i].varient;
//       map['color'] = widget.prodctlist1[i].pcolor == null ||
//               widget.prodctlist1[i].pcolor!.isEmpty
//           ? 'defaultcolor'
//           : widget.prodctlist1[i].pcolor;
//       map['size'] = widget.prodctlist1[i].psize == null ||
//               widget.prodctlist1[i].psize!.isEmpty
//           ? 'defaultSize'
//           : widget.prodctlist1[i].psize;
//       map['refid'] = "0";
//       map['image'] = widget.prodctlist1[i].pimage;
//       map['prime'] = "0";
//       map['mv'] = widget.prodctlist1[i].mv.toString();
//       final response = await http.post(
//           Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
//           body: map);
//       print('called data oredr snd  ' + response.body);
//       try {
//         // print(response);
//         if (response.statusCode == 200) {
// //        final jsonBody = json.decode(response.body);
//           ProductAdded1 user =
//               ProductAdded1.fromJson(jsonDecode(response.body));

//           setState(() {
//             if (user.success.toString() == "true" &&
//                 i == (widget.prodctlist1.length - 1)) {
//               dbmanager.deleteallProducts();
//               GroceryAppConstant.itemcount = 0;
//               GroceryAppConstant.groceryAppCartItemCount = 0;
//               groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
//               pre.setString("mvid", "");
//               setState(() {
//                 webViewController?.goBack();
//               });

//               if (widget.checkbox) {
//                 walletPurchase2(widget.usedWalletamt.toString(),
//                     invoice: invoice);
//               }
//             } else {
//               showLongToast(' Somting went wrong');
//             }
//           });
//         }
//       } catch (Exception) {}
//     }
//   }

//   String generateMd5(String input) {
//     return md5.convert(utf8.encode(input)).toString();
//   }

//   Future walletPurchase2(String amount, {required String invoice}) async {
//     String md5 = generateMd5(
//       widget.username.toString() + invoice.toString() + amount.toString(),
//     );
//     String link = GroceryAppConstant.base_url + "api/payFromWallet.php";
//     var body = {
//       "username": widget.username,
//       "key": md5,
//       "price": amount.toString(),
//       "purpose": invoice,
//       "name": GroceryAppConstant.name,
//       "phone": widget.username,
//       "email": GroceryAppConstant.email,
//     };
//     print("walletPurchaseBody------->$body");
//     final response = await http.post(Uri.parse(link), body: body);

//     try {
//       if (response.statusCode == 200) {
//         print("response------->${response.body}");
//         print("res---->${response.body}");
//         showLongToast('Your order is successfull');
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ShowInVoiceId(invoice)),
//         );
//       }
//     } catch (Exception) {}
//   }
// }

import 'dart:convert';
import 'package:aladdinmart/constent/app_constent.dart';
import 'package:aladdinmart/grocery/Web/BlogShow.dart';
import 'package:aladdinmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/model/InvoiceModel.dart';
import 'package:aladdinmart/grocery/model/RegisterModel.dart';
import 'package:aladdinmart/grocery/screen/checkout.dart';
import 'package:aladdinmart/grocery/screen/finalScreen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhonepePaymentScreen extends StatefulWidget {
  const PhonepePaymentScreen(
      {Key? key,
      required this.paymentUrl,
      required this.merchantTransactionId,
      required this.amount,
      required this.paymentType,
      required this.email,
      required this.name,
      required this.mobile,
      required this.address,
      required this.pincode,
      required this.city,
      required this.deliveryfee,
      required this.coupancode,
      required this.difference,
      required this.onedayprice,
      required this.prodctlist1,
      required this.username,
      required this.finalamt,
      required this.shipping,
      required this.usedWalletamt,
      required this.mv,
      required this.lat,
      required this.long,
      required this.coupoun,
      required this.coupoun_amount,
      required this.fast_price,
      required this.checkbox})
      : super(key: key);

  final String paymentUrl;
  final String amount;
  final int merchantTransactionId;
  final String paymentType;
  final String email;
  final String name;
  final String mobile;

  final String username;
  final String finalamt;
  final String usedWalletamt;

  final String address;
  final String pincode;
  final String city;
  final String deliveryfee;
  final String coupancode;
  final String difference;
  final String onedayprice;
  final String shipping;
  final String coupoun_amount;
  final String coupoun;
  final String long;
  final String lat;
  final String mv;
  final String fast_price;
  final bool checkbox;
  final List<ProductsCart> prodctlist1;

  @override
  State<PhonepePaymentScreen> createState() => _PhonepePaymentScreenState();
}

class _PhonepePaymentScreenState extends State<PhonepePaymentScreen> {
  String environment = "UAT_SIM";
  String appId = "2725";
  String merchantId = "M22M7IQO4AJLE";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "e8bb2e87-39bc-445f-b343-e38191b6ba53";
  String saltindex = "1";
  // String callbckUrl = "https://citychoice.w4u.in/phonepe/verify_payment.php";
  String callbckUrl =
      "https://www.customercare247.in/phonepe/verify_payment.php";
  String body = "";
  Object? result;
  String apiEndPoint = "/pg/v1/pay";
  String packageNme = "";
  String phoneNumber = "9356201201";
  bool completed = false;
  String invoice = "";
  String invoice1 = "";
  String phonepe = "PhonePe";

  // String merchantTransactionId = merchantTransactionId;

  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId":
          "PhonePe${widget.merchantTransactionId.toString()}",
      // "merchantTransactionId": "ewertr456yyy",
      "merchantUserId": "${widget.username}",
      // "amount": "${widget.amount}",
      "amount": "${double.parse("${widget.amount}").toInt() * 100}",
      // "amount": "900",
      "mobileNumber": phoneNumber,
      "callbackUrl": callbckUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      }
    };
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum =
        "${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltindex";
    return base64Body;

    // checksum =
    //     "${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltindex";
    // return base64Body;
  }

  @override
  void initState() {
    invoice1 = "PhonePe${widget.merchantTransactionId.toString()}";
    super.initState();
    phonepeInit();
    body = getChecksum().toString();
    startPgTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Phonepe"),
        // ),
        body: Center(
      child: Text(
        "Please Wait....",
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w600, fontSize: 32),
      ),
    )
        // Column(
        //   children: [
        //     SizedBox(
        //       height: 25,
        //     ),
        //     Text("$Error \n $result "),
        //     SizedBox(
        //       height: 25,
        //     ),
        //     Text(
        //       "$Error \n $merchantId \n ${widget.merchantTransactionId} \n $invoice1 \n ",
        //     ),
        //     TextButton(
        //         onPressed: () {
        //           // _getInvoice1("ONLINE");
        //           Navigator.pushReplacement(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => ShowInVoiceId(invoice.toString())),
        //           );
        //         },
        //         child: Text("invoice"))
        //   ],
        // ),
        );
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startPgTransaction() async {
    PhonePePaymentSdk.startTransaction(body, callbckUrl)
        .then((response) => {
              setState(() {
                if (response != null) {
                  String status = response['status'].toString();
                  String error = response['error'].toString();
                  if (status == 'SUCCESS') {
                    // "Flow Completed - Status: Success!";
                    // _getInvoice("ONLINE");
                    setState(() {
                      completed = true;
                      invoice1 =
                          "PhonePe${widget.merchantTransactionId.toString()}";
                    });
                    result = "Flow Completed - Statuss: Success!";
                    // checkPaymentStatus();
                    showLongToast(
                        "don't press back until payment gets completed or else payment will get cancelled.");
                    // showLoaderDialog(context, true);
                    _getInvoice("ONLINE");
                    // showLoaderDialog(context, false);

                    print("--------->Hellllllo");
                    // }

                    // _getInvoice("ONLINE");
                  } else {
                    // "Flow Completed - Status: $status and Error: $error";
                    result =
                        "Flow Completed - Status: $status and Error: $error";
                  }
                } else {
                  // "Flow Incomplete";
                  result = "Flow Incomplete";
                }
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  // Future<void> checkPaymentStatus() async {
  //   final statusUrl =
  //       "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$phonepe${widget.merchantTransactionId.toString()}";

  //   final response = await http.get(Uri.parse(statusUrl));

  //   if (response.statusCode == 200) {
  //     final responseBody = jsonDecode(response.body);
  //     if (responseBody['success'] == true &&
  //         responseBody['data']['status'] == 'SUCCESS') {
  //       _getInvoice("ONLINE");
  //     } else {
  //       Fluttertoast.showToast(msg: 'Payment failed or still processing.');
  //     }
  //   } else {
  //     _getInvoice("ONLINE");
  //     Fluttertoast.showToast(msg: 'Error checking payment status.');
  //   }
  // }

  final DbProductManager dbmanager = new DbProductManager();

  void _showLongToast(String s) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  showLoaderDialog(BuildContext context, bool bool) {
    showDialog(
      context: context,
      barrierDismissible: bool,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => bool,
          child: AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: Text("Please Wait...")),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _getInvoice(
    String paymode,
  ) async {
    print('called data oredr first');
    var map = Map<String, dynamic>();
    map['name'] = widget.name;
    map['mobile'] = widget.username;
    map['email'] = widget.email;
    map['address'] = widget.address;
    map['pincode'] = widget.pincode;
    map['city'] = widget.city;
    map['invoice_total'] = widget.finalamt.toString();
    map['notes'] = "no notes";
    map['shop_id'] = GroceryAppConstant.Shop_id.toString();
    map['PayMode'] = paymode;
    map['user_id'] = GroceryAppConstant.user_id;
    map['shipping'] = widget.deliveryfee;
    map['mv'] = widget.prodctlist1[0].mv.toString();
    map['lat'] = widget.lat.toString();
    map['lng'] = widget.long.toString();
    map['coupon'] = widget.coupancode.isNotEmpty ? widget.coupancode : "";
    map['couponAmount'] = widget.difference.toString();
    map['fast_price'] =
        widget.onedayprice.isNotEmpty ? widget.onedayprice.toString() : "0.0";
    print('map-------->${map}');
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
        body: map);
    print('called data oredr' + response.body);
    if (response.statusCode == 200) {
//      final jsonBody = json.decode(response.body);
      Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
      // print("123"+user.Invoice);
      if (user.success.toString() == "true") {
        print("12345" + user.Invoice.toString());
        print('called data oredr' + user.Invoice.toString());
        _uploadProducts(invoice: user.Invoice ?? '');
      } else {
        showLongToast('Invoice is not generated');
      }
    } else
      throw Exception("Unable to generate Employee Invoice");
//    print("123  Unable to generate Employee Invoice");
  }

  Future _uploadProducts({required String invoice}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    print('called data oredr secnd');
    print('called data oredr secnd      ' + GroceryAppConstant.email);

    final email = GroceryAppConstant.email.contains("@gmai.com") ||
            GroceryAppConstant.email.contains("@")
        ? GroceryAppConstant.email
        : 'shahiexpressofficial@gmail.com';

    print('called data email      ' + email);

    for (int i = 0; i < widget.prodctlist1.length; i++) {
      var map = Map<String, dynamic>();

      map['invoice_id'] = invoice;
      map['product_id'] = widget.prodctlist1[i].pid;
      map['product_name'] = widget.prodctlist1[i].pname;
      map['quantity'] = widget.prodctlist1[i].pQuantity.toString();
      map['price'] = (double.parse(widget.prodctlist1[i].costPrice ?? "") *
              (widget.prodctlist1[i].pQuantity ?? 0))
          .toString();
      map['user_per'] = widget.prodctlist1[i].discount;
      map['user_dis'] =
          (double.parse(widget.prodctlist1[i].discountValue ?? "") *
                  (widget.prodctlist1[i].pQuantity ?? 0))
              .toStringAsFixed(2)
              .toString();
      map['admin_per'] = widget.prodctlist1[i].adminper;
      map['admin_dis'] = widget.prodctlist1[i].adminpricevalue;
      map['shop_id'] = GroceryAppConstant.Shop_id;
      map['cgst'] = widget.prodctlist1[i].cgst;
      map['sgst'] = widget.prodctlist1[i].sgst;
      map['variant'] = widget.prodctlist1[i].varient == null
          ? " "
          : widget.prodctlist1[i].varient.toString();
      map['color'] = widget.prodctlist1[i].pcolor == null ||
              (widget.prodctlist1[i].pcolor ?? "").isEmpty
          ? 'defaultcolor'
          : widget.prodctlist1[i].pcolor;
      map['size'] = widget.prodctlist1[i].psize == null ||
              (widget.prodctlist1[i].psize ?? "").isEmpty
          ? 'defaultSize'
          : widget.prodctlist1[i].psize;
      map['refid'] = "0";
      map['image'] = widget.prodctlist1[i].pimage;
      map['prime'] = "0";
      map['mv'] = widget.prodctlist1[i].mv.toString();
      print('map-------->${map}');
      final response = await http.post(
          Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
          body: map);

      print('called data oredr snd  ' + response.body);
      try {
        // print(response);
        if (response.statusCode == 200) {
//        final jsonBody = json.decode(response.body);
          ProductAdded1 user =
              ProductAdded1.fromJson(jsonDecode(response.body));

          setState(() {
            if (user.success.toString() == "true" &&
                i == (widget.prodctlist1.length - 1)) {
              showLongToast(' Your order is successful');
              dbmanager.deleteallProducts();
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.groceryAppCartItemCount = 0;
              groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
              pre.setString("mvid", "");
              setState(() {
                AppConstent.cc = 0;

                pre.setInt("cc", AppConstent.cc);
              });

              if (widget.checkbox) {
                walletPurchase2(widget.usedWalletamt.toString(),
                    invoice: invoice);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowInVoiceId(user.Invoice.toString())),
                );
              }

              // Navigator.push(
              // context,
              // MaterialPageRoute(
              //     builder: (context) =>
              //         ShowInVoiceId(user.Invoice.toString())),
            } else {
              showLongToast(' Somting went wrong');
            }
          });
        }
      } catch (Exception) {}
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future walletPurchase2(String amount, {required String invoice}) async {
    String md5 = generateMd5(
      widget.username.toString() + invoice.toString() + amount.toString(),
    );
    String link = GroceryAppConstant.base_url + "api/payFromWallet.php";
    var body = {
      "username": widget.username,
      "key": md5,
      "price": amount.toString(),
      "purpose": invoice,
      "name": GroceryAppConstant.name,
      "phone": widget.username,
      "email": GroceryAppConstant.email,
    };
    print("walletPurchaseBody------->$body");
    final response = await http.post(Uri.parse(link), body: body);

    try {
      if (response.statusCode == 200) {
        print("response------->${response.body}");
        print("res---->${response.body}");
        showLongToast('Your order is successfull');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShowInVoiceId(invoice)),
        );
      }
    } catch (Exception) {}
  }

  void handleError(error) {
    setState(() {
      result = {"error": error};
    });
  }
}

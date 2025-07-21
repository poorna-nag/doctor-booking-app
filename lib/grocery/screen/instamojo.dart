import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:aladdinmart/grocery/BottomNavigation/wishlist.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:aladdinmart/grocery/model/InvoiceModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../screen/finalScreen.dart';

class InstaMojoPaymentWebViewFood extends StatefulWidget {
  final String url;
  final String amount;
  final String email;
  final String name;
  final String mobile;
  final String invoice;

  final String address;
  final String pincode;
  final String city;
  final String deliveryfee;
  final String coupancode;
  final String difference;
  final String onedayprice;
  final List<ProductsCart> prodctlist1;
  InstaMojoPaymentWebViewFood(
      {Key? key,
      required this.url,
      required this.amount,
      required this.email,
      required this.name,
      required this.mobile,
      required this.invoice,
      required this.address,
      required this.pincode,
      required this.city,
      required this.deliveryfee,
      required this.coupancode,
      required this.difference,
      required this.onedayprice,
      required this.prodctlist1})
      : super(key: key);

  @override
  State<InstaMojoPaymentWebViewFood> createState() =>
      _InstaMojoPaymentWebViewFoodState();
}

class _InstaMojoPaymentWebViewFoodState
    extends State<InstaMojoPaymentWebViewFood> {
  final GlobalKey webViewKey = GlobalKey();
  final DbProductManager dbmanager = new DbProductManager();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      applicationNameForUserAgent: '',
      javaScriptEnabled: true,
      supportZoom: false,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      userAgent:
          // ''
          'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
    ),
    android: AndroidInAppWebViewOptions(
      allowFileAccess: true,
      allowContentAccess: true,
      supportMultipleWindows: true,
      thirdPartyCookiesEnabled: true,
      useHybridComposition: true,
      // javaScriptEnabled: true,
      domStorageEnabled: true,
    ),
    ios: IOSInAppWebViewOptions(
      // javaScriptEnabled: true,
      sharedCookiesEnabled: true,
    ),
  );

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  late bool result;
  String url = '';
  double progress = 0;
  final urlController = TextEditingController();
  bool isShowWebView = false;
  String userId = '';
  String shareLink = '';
  String? initiaUrl;
  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  // Connectivity connectivity = Connectivity();
  // ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  Widget build(BuildContext context) {
    initiaUrl = widget.url +
        "?price=${widget.amount}&name=${widget.name}&phone=${widget.mobile}&invoice=${widget.invoice}&email=${widget.email}";
    log('initiaUrl   ' + initiaUrl.toString());
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 10, 102, 53),
            elevation: 0,
            title: Text("Payment"),
            centerTitle: true,
          ),
          body: Stack(children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: WebUri(initiaUrl.toString()),
              ),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              // onWebViewCreated: (controller) async {
              //   webViewController = controller;
              //   print(await controller.getUrl());
              // },

              onLoadStart: (controller, url) async {
                setState(() {
                  this.url = url.toString();
                  // urlController.text = widget.url;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                log(navigationAction.request.url.toString());
                var uri = navigationAction.request.url!;

                if (uri.scheme.contains("payment_status=Credit")) {
                  //  urlController.text = uri.scheme.toString();
                  //log("url response----------------->>>" +
                  //  urlController.text.toString());

                  _uploadProductsInstamojo();
                  log("shouldOverrideUrlLoading");

                  return NavigationActionPolicy.CANCEL;
                } else if (uri.scheme.contains("payment_status=Failed")) {
                  cancleandRefund('can', context);
                  Navigator.of(context).pop();
                  showLongToast("Payment Faild");

                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                SharedPreferences pre = await SharedPreferences.getInstance();
                if (url.toString().contains("payment_status=Credit")) {
                  log("shouldOverrideUrlLoading");

                  _uploadProductsInstamojo();
                } else if (url.toString().contains("payment_status=Failed")) {
                  setState(() {
                    webViewController?.goBack();
                  });
                  cancleandRefund('can', context);
                  Navigator.of(context).pop();
                  showLongToast("Payment Faild");
                  // } else if (url
                  //     .toString()
                  //     .startsWith("https://www.instamojo.com/")) {
                  //   log(url.toString());

                  // await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (ctx) => InstamojoScreen(
                  //               isLive: true,
                  //               body: CreateOrderBody(
                  //                   buyerName: 'althaf',
                  //                   buyerEmail: 'althaf@gmail.com',
                  //                   buyerPhone: '8086689184',
                  //                   amount: "100",
                  //                   description: 'test'),
                  //               orderCreationUrl: url
                  //                   .toString(), // The sample server of instamojo to create order id.
                  //             )));
                }

                pullToRefreshController!.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  // checkConnectivity().then((value) {
                  //   if (connectivityResult.name == 'none') {
                  //     Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => InstaMojoPaymentWebView(
                  //                   url: AppGroceryAppConstant.homeWebViewURL,
                  //                 )),
                  //         (route) => false);
                  //   }
                  // });
                });
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  //  urlController.text = this.url;
                  // log(urlController.text.toString());
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                // log(consoleMessage.toString());
                //   },
                // );
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container()
          ]),
        ),

        /*floatingActionButton: isShowWebView
                ? FloatingActionButton(
                    onPressed: () => _launchUrl(whatsappUrl),
                    backgroundColor: AppColors.whatsappColor,
                    child: const Icon(
                      Icons.whatsapp,
                      size: 30,
                    ),
                  )
                : null,*/
      ),
    );
  }

  cancleandRefund(String val, BuildContext context) async {
    String link = GroceryAppConstant.base_url + "api/order_status.php";
    var map = new Map<String, dynamic>();
    map['user_id'] = widget.mobile;
    map['order_id'] = widget.invoice;
    map['status'] = val;
    map['note'] = 'Payment faild';
    map['api_id'] = GroceryAppConstant.Shop_id;
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await webViewController?.canGoBack() ?? false) {
      webViewController?.goBack();
      return Future.value(false);
    } else {
      Navigator.pop(context);

      return Future.value(false);
    }
  }

  //-------------------------------------------------------------------------------///

//   Future _getInvoiceinstamojo(
//     String paymode,
//   ) async {
//     print('called data oredr first');
//     var map = Map<String, dynamic>();
//     map['name'] = widget.name;
//     map['mobile'] = widget.mobile;
//     map['email'] = widget.email;
//     map['address'] = widget.address;
//     map['pincode'] = widget.pincode;
//     map['city'] = widget.city;
//     map['invoice_total'] = widget.amount.toString();
//     map['notes'] = 'ghy';
//     map['shop_id'] = GroceryAppConstant.Shop_id.toString();
//     map['PayMode'] = paymode;
//     map['user_id'] = "user_id";
//     map['shipping'] = widget.deliveryfee;
//     map['mv'] = widget.prodctlist1[0].mv.toString();
//     map['lat'] = GroceryAppConstant.latitude.toString();
//     map['lng'] = GroceryAppConstant.longitude.toString();
//     map['coupon'] = widget.coupancode != null ? widget.coupancode : "";
//     map['couponAmount'] = widget.difference.toString();
//     map['fast_price'] =
//         widget.onedayprice != null ? widget.onedayprice.toString() : "0.0";
//     print('map-------->${map}');
//     final response = await http
//         .post(Uri.parse(GroceryAppConstant.base_url + 'api/order.php'), body: map);
//     print('called data oredr' + response.body);
//     if (response.statusCode == 200) {
// //      final jsonBody = json.decode(response.body);
//       Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
//       // print("123"+user.Invoice);
//       if (user.success.toString() == "true") {
//         print("12345" + user.Invoice.toString());
//         print('called data oredr' + user.Invoice.toString());

//         // _uploadProductsInstamojo(
//         //   user.Invoice ?? "",
//         //   paymode,
//         // );
//         setState(() {
//           invoiceid = user.Invoice;
//         });
//       } else {
//         showLongToast('Invoice is not generated');
//       }
//     } else
//       throw Exception("Unable to generate Employee Invoice");
// //    print("123  Unable to generate Employee Invoice");
//   }

  Future _uploadProductsInstamojo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    print('called data oredr secnd');
    print('called data oredr secnd      ' + GroceryAppConstant.email);

    final email =
        GroceryAppConstant.email.contains("@gmai.com") || GroceryAppConstant.email.contains("@")
            ? GroceryAppConstant.email
            : 'shahiexpressofficial@gmail.com';

    print('called data email      ' + email);

    for (int i = 0; i < widget.prodctlist1.length; i++) {
      var map = Map<String, dynamic>();

      map['invoice_id'] = widget.invoice;
      map['product_id'] = widget.prodctlist1[i].pid;
      map['product_name'] = widget.prodctlist1[i].pname;
      map['quantity'] = widget.prodctlist1[i].pQuantity.toString();
      map['price'] = (double.parse(widget.prodctlist1[i].costPrice ?? "") *
              widget.prodctlist1[i].pQuantity!)
          .toString();
      map['user_per'] = widget.prodctlist1[i].discount;
      map['user_dis'] =
          (double.parse(widget.prodctlist1[i].discountValue ?? "") *
                  widget.prodctlist1[i].pQuantity!)
              .toStringAsFixed(2)
              .toString();
      map['admin_per'] = widget.prodctlist1[i].adminper;
      map['admin_dis'] = widget.prodctlist1[i].adminpricevalue;
      map['shop_id'] = GroceryAppConstant.Shop_id;
      map['cgst'] = widget.prodctlist1[i].cgst;
      map['sgst'] = widget.prodctlist1[i].sgst;
      map['variant'] = widget.prodctlist1[i].varient == null
          ? " "
          : WishlistState.prodctlist1![i].varient;
      map['color'] = widget.prodctlist1[i].pcolor == null ||
              widget.prodctlist1[i].pcolor!.isEmpty
          ? 'defaultcolor'
          : widget.prodctlist1[i].pcolor;
      map['size'] = widget.prodctlist1[i].psize == null ||
              widget.prodctlist1[i].psize!.isEmpty
          ? 'defaultSize'
          : widget.prodctlist1[i].psize;
      map['refid'] = "0";
      map['image'] = widget.prodctlist1[i].pimage;
      map['prime'] = "0";
      map['mv'] = widget.prodctlist1[i].mv.toString();
      final response = await http
          .post(Uri.parse(GroceryAppConstant.base_url + 'api/order.php'), body: map);
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
              dbmanager.deleteallProducts();
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.carditemCount = 0;
              groceryCartItemCount(GroceryAppConstant.carditemCount);
              pre.setString("mvid", "");
              setState(() {
                webViewController?.goBack();
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId(widget.invoice)),
              );
            } else {
              showLongToast(' Somting went wrong');
            }
          });
        }
      } catch (Exception) {
        // throw Exception("Unable to uplod product detail");
      }
      // }

      /*  else{
        setState(() {

          pmv=prodctlist1[i].mv;

          // print(' set state after if ${pmv}'+i.toString());
        });
          int p;
        for( p=0;p<i;p++){
          setState(() {
            prodctlist1.removeAt(0);
            print("list length"+prodctlist1.length.toString());

          });

        }

        if(p==i){

          _getInvoice1(paytype);
          break;


        }

      }*/
    }
  }
}

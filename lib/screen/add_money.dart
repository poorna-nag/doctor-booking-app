import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/model/InvoiceModel.dart';
import 'package:aladdinmart/model/OrderDliverycharge.dart';
import 'package:aladdinmart/screen/transaction_successful.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'finalScreen.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({Key? key}) : super(key: key);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  Razorpay? razorpay;
  final myController = TextEditingController();
  String? razorpay_key;
  String? gateway;
  String? orderid;
  String? signature;
  String? paymentId;
  String? invoiceid;
  String? name;
  String? phone;
  String? email, address, pinCode, city, userId;
  bool isLoading = false;
  Future<void> _gefreedelivery() async {
    final response = await http.get(Uri.parse(FoodAppConstant.base_url +
        'api/shipping.php?shop_id=' +
        FoodAppConstant.Shop_id));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      DeliveryCharge user1 = DeliveryCharge.fromJson(jsonDecode(response.body));
      if (user1.success.toString() == "true") {
        setState(() {
          gateway = user1.Gateway;
          razorpay_key = user1.razorpay_key;
        });
        print(user1.COD);
        // print("user1.Min_Order");
      }

//        setState(() {
//          invoiceid=user.Invoice;
//
//        });
    } else
      throw Exception("Unable to generate Employee Invoice");
//    print("123  Unable to generate Employee Invoice");
  }

  void openCheckout() {
//    var options1 = {
//      'key': 'rzp_live_y9LCkyj468leuC',
//      'amount': finalamount*100, //in the smallest currency sub-unit.
//      'name':FoodAppConstant.name,
//      'order_id': invoiceid, // Generate order_id using Orders API
//      'description': 'Fine T-Shirt',
//      'prefill': {
//        'contact': mobile1,
//        'email': email1
//      }
//    };

//    rzp_live_vkeFphEQQ90LK1

    // 'amount': (twltamount-difference) * 100.0,
    var options = {
      'key': razorpay_key,
      'amount': int.parse(myController.text) * 100,
      "currency": "INR",
      'name': name,
      'description': "Wallet Recharge",
      'prefill': {'contact': phone, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };
/*     var options = {
      "key" : "[YOUR_API_KEY]",
      "amount" : "10000",
      "name" : "Sample App",
      "description" : "Payment for the some random product",
      "prefill" : {
        "contact" : "2323232323",
        "email" : "shdjsdh@gmail.com"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };*/

    try {
      razorpay?.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  Future _getInvoice1(String paymode) async {
    print("_getInvoice1--> ");
    var map = new Map<String, dynamic>();
    map['name'] = name ?? "";
    map['mobile'] = phone ?? "";
    map['email'] = email ?? "";
    map['address'] = address ?? "";
    map['pincode'] = pinCode ?? "";
    map['city'] = city ?? "";
    map['invoice_total'] = myController.text.toString();
    map['notes'] = "";
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['PayMode'] = paymode;
    map['user_id'] = "user_id";
    map['shipping'] = "0";
    map['mv'] = '0';
    map['lat'] = FoodAppConstant.latitude.toString();
    map['lng'] = FoodAppConstant.longitude.toString();
    map['coupon'] = "";
    map['couponAmount'] = "";

    print("mapppp--->${map}");

    final response =
        await http.post(Uri.parse(FoodAppConstant.base_url + 'api/order.php'), body: map);

    print("API-Response--> ${response.statusCode}");
    print("API_Response--> ${response.body}");

    if (response.statusCode == 200) {
//      final jsonBody = json.decode(response.body);
      print("hellllo");
      Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
      print(user.Invoice);
      // print("123"+user.Invoice);
      if (user.success.toString() == "true") {
        print("12345" + user.Invoice.toString());

        _uploadProducts(user.Invoice??"", paymode);
        setState(() {
          invoiceid = user.Invoice;
        });
      } else {
        showLongToast('Invoice is not generated');
        print("not generated");
      }
    } else
      throw Exception("Unable to generate Employee Invoice");
//    print("123  Unable to generate Employee Invoice");
  }

  Future _uploadProducts(String invoice, String paytype) async {
    // int pmv= prodctlist1[0].mv;
    //
    // print("Pmv12   "+pmv.toString()+ "   "+prodctlist1.length.toString());
    for (int i = 1; i < 2; i++) {
      /*     if(pmv==prodctlist1[i].mv) {
        setState(() {
          pmv=prodctlist1[i].mv;

          print("Pmv"+pmv.toString());
        });*/

      // print("WishlistState.prodctlist1[i].pimage");
      // print(WishlistState.prodctlist1[i].pimage);

      var map = new Map<String, dynamic>();
      print(invoice);
      map['invoice_id'] = invoice;
      map['product_id'] = '88649';
      map['product_name'] = "Desi Feed Starter";
      map['quantity'] = "1";
      map['price'] = myController.text.toString();
      map['user_per'] = "0";
      map['user_dis'] = "0";
      map['admin_per'] = "0";
      map['admin_dis'] = "0";
      map['shop_id'] = FoodAppConstant.Shop_id;
      map['cgst'] = "0";
      map['sgst'] = "0";
      map['variant'] = "";
      map['color'] = 'defaultcolor';
      map['size'] = 'defaultSize';
      map['refid'] = "0";
      map['image'] = "";
      map['prime'] = "0";
      map['mv'] = "0";
      map['total_sub'] = "";
      // map['variant']=val;
      map['sub_date'] = "";
      print(FoodAppConstant.base_url + 'api/order.php');
      print(map.toString());
      final response = await http
          .post(Uri.parse(FoodAppConstant.base_url + 'api/order.php'), body: map);

      try {
        // print(response);
        if (response.statusCode == 200) {
          print("rahul-------->");

          // final jsonBody = json.decode(response.body);
          // print(jsonBody.success);
          ProductAdded1 user =
              ProductAdded1.fromJson(jsonDecode(response.body));
          print(user.success);

          setState(() {
            if (user.success.toString() == "true" &&
                i == (1) &&
                paytype == 'ONLINE') {
              showLongToast('Please wait');
              //FoodAppConstant.itemcount = 0;
              //FoodAppConstant.carditemCount = 0;
              //cartItemcount(FoodAppConstant.carditemCount);
              _afterPayment(orderid??"", signature??"", paymentId??"");

              // openCheckout();

              // Navigator.push(context,
              //   MaterialPageRoute(builder: (context) => ShowInVoiceId(user.Invoice)),);
            } else {
              // showLongToast(' Somting went wrong');
            }
          });
        }
      } catch (Exception) {
        //throw Exception("Unable to uplod product detail");
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

  Future _afterPayment(
      String orderid, String signature, String paymentId) async {
    var map = new Map<String, dynamic>();
    map['phone'] = phone;
    map['name'] = name;
    map['razorpay_payment_id'] = paymentId != null ? paymentId : "";
    map['razorpay_order_id'] = orderid != null ? orderid : "";
    map['razorpay_signature'] = signature != null ? signature : "";
    map['email'] = email;
    map['username'] = phone;
    map['price'] = myController.text.toString();
    //map['purpose'] = invoiceid;
    map['wallet'] = "w_in";
    print("mymap---->${map}");
    final response = await http
        .post(Uri.parse(FoodAppConstant.base_url + 'verifyUserWallet.php'), body: map);
    try {
      print("response------->${response.body}");
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionSuccessful()),
        );
      }
    } catch (Exception) {}
  }

  getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
      phone = pref.getString('mobile');
      email = pref.getString('email');
      address = pref.getString('address');
      pinCode = pref.getString('pin');
      userId = pref.getString('user_id');
      print("name----->$name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    _gefreedelivery();
    razorpay = new Razorpay();
    razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        title: Text("Add Money"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width / 2,
          ),
          Container(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: FoodAppColors.tela,
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 27),
                  child: Column(
                    children: [
                      TextField(
                        controller: myController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hoverColor: Colors.green,
                            hintText: "Please enter the amount",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            )),
                      ),
                      SizedBox(
                        height: 27,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          openCheckout();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 120, right: 120),
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.green,
                          ),
                          child: Center(
                              child: Text(
                            "Add",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      orderid = response.orderId;
      signature = response.signature;
      paymentId = response.paymentId;
    });
    CircularProgressIndicator(
        //color: FoodAppColors.tela,
        );
    showLongToast(
        "Don't press back until payment gets confirmed or else payment will get cancelled.");
    // _getInvoice1("ONLINE");
    _afterPayment(orderid??"", signature??"", paymentId??"");
  }

  handlerErrorFailure() {
    print("failure");
  }

  handlerExternalWallet() {
    print("Wallet");
  }
}

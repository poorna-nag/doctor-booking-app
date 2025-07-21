import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:aladdinmart/BottomNavigation/wishlist.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/StyleDecoration/styleDecoration.dart';
import 'package:aladdinmart/dbhelper/CarrtDbhelper.dart';
import 'package:aladdinmart/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/model/AddressModel.dart';
import 'package:aladdinmart/model/CoupanModel.dart';
import 'package:aladdinmart/model/CustmerModel.dart';
import 'package:aladdinmart/model/InvoiceModel.dart';
import 'package:aladdinmart/model/OrderDliverycharge.dart';
import 'package:aladdinmart/model/TrackInvoiceModel.dart';
import 'package:aladdinmart/model/usable_wallet_amount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'ShowINVoiceIc1.dart';
import 'finalScreen.dart';

class CheckOutPage extends StatefulWidget {
  final UserAddress address;

  const CheckOutPage(this.address) : super();

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final DbProductManager dbmanager = new DbProductManager();
  final coupanController = TextEditingController();
  final resignofcause = TextEditingController();
  int? count;
  String? name1;
  String? email1;
  String? mobile1;
  String? gateway;
  String? codp;
  String? pin1;
  String? city1;
  String? address1;
  String? address2;
  String? walletamt, user_name, checkcoupan;
  double? wltamount = 0.0,
      twltamt = 0.0,
      twltamount = 0.0,
      finalamount,
      calcutateAmount,
      checkamount,
      difference = 0.0;
  bool discountval_flag = false;

  String? sex1;
  String? coupancode;
  String? user_id1;
  String? state1;
  String? invoiceid;
  String? razorpay_key;
  String deliveryfee = '00.00';
  bool flag = true;
  bool flag1 = false;
  bool checkBoxValue = false;

  double Onedayprice = 0.00;
  String fast_text = "";
  String? usableWAlletAmount;
  String? finalUsableWAlletAmount;
  String textval = "Select Date";
  String textval1 = "Select Time";
  bool loader = false;
  bool applyButtonLoader = false;
  bool hideApplyButton = false;
  List<TrackInvoice> list = [];

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
          codp = user1.COD;
          razorpay_key = user1.razorpay_key;
        });
        print(user1.COD);
        // print("user1.Min_Order");
        if (FoodAppConstant.totalAmount < double.parse(user1.Min_Order ?? "")) {
          setState(() {
            deliveryfee =
                (double.parse(user1.Fee ?? "") + FoodAppConstant.shipingAmount)
                    .toString();
            finalamount =
                FoodAppConstant.totalAmount + double.parse(user1.Fee ?? "");
            twltamount =
                FoodAppConstant.totalAmount + double.parse(user1.Fee ?? "");
          });
        } else {
          if (FoodAppConstant.shipingAmount > 0) {
            deliveryfee = (double.parse("0.0") + FoodAppConstant.shipingAmount)
                .toString();
            finalamount =
                FoodAppConstant.totalAmount + double.parse(user1.Fee ?? "");
            twltamount =
                FoodAppConstant.totalAmount + double.parse(user1.Fee ?? "");
          } else {
            deliveryfee = '0.0';
          }
        }

//        setState(() {
//          invoiceid=user.Invoice;
//
//        });
      } else {}
    } else
      throw Exception("Unable to generate Employee Invoice");
//    print("123  Unable to generate Employee Invoice");
  }

  getUsableWAlletAmount() async {
    var link =
        "${FoodAppConstant.base_url}api/cp.php?shop_id=${FoodAppConstant.Shop_id}";
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var result = UsableWalletAmount.fromJson(jsonDecode(response.body));
      var usablePercent = result.walletCanBeUsed;
      print(calcutateAmount);
      usableWAlletAmount =
          (int.parse(walletamt ?? "") * (int.parse(usablePercent ?? "")) / 100)
              .toStringAsFixed(0);
      print(walletamt);
      print("usableamount---->${usableWAlletAmount}");
    }
  }

/*
  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String name= pre.getString("name");
    String email= pre.getString("email");
    String mobile= pre.getString("mobile");
    String pin= pre.getString("pin");
    String city= pre.getString("city");
    String address= pre.getString("address");
    String sex= pre.getString("sex");
    String state=pre.getString("state");
    String userid=pre.getString("user_id");
    print(name);
    print(email);
    print(pin);

    this.setState(() {

      name1=name;
      email1= email;
      mobile1=mobile;
      pin1=pin;
      city1=city;
      address1=address;
      sex1=sex;
      state1=state;
      user_id1=userid;


    });
  }
*/
  SharedPreferences? pre;

  Future<void> getUserInfo() async {
    pre = await SharedPreferences.getInstance();
    user_name = pre!.getString("mobile");
    walletamt = pre!.getString("wallet");
    print(user_name! + "userNAme");

    // walletamt="2000";
    String? email = pre!.getString("email");
    String? name = pre!.getString("name");
//    String pin= pre!.getString("pin");
//    String city= pre!.getString("city");
//    String address= pre!.getString("address");
    String? sex = pre!.getString("sex");
//    String state=pre!.getString("state");
    String? userid = pre!.getString("user_id");

    this.setState(() {
      name1 = widget.address.fullName;
      email1 = widget.address.email;
      mobile1 = widget.address.mobile;
      pin1 = widget.address.pincode;
      city1 = widget.address.city;
      address1 = widget.address.address1;
      address2 = widget.address.address2;
      sex1 = sex;
      state1 = widget.address.state;
      user_id1 = userid;
      FoodAppConstant.name = name ?? "";
      FoodAppConstant.email = email ?? "";
      FoodAppConstant.username = user_name ?? "";
      FoodAppConstant.latitude = double.parse(widget.address.lat ?? "");
      FoodAppConstant.longitude = double.parse(widget.address.lng ?? "");

      _getwalletActive();
    });
  }

  Razorpay? razorpay;
  List<ProductsCart> prodctlist1 = [];
  List<CustmerModel> walletlist = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? userid = pref.getString("user_id");
    isLoading.value = true;
    await getUserInfo();
    finalamount = FoodAppConstant.totalAmount;
    calcutateAmount = FoodAppConstant.totalAmount;
    _gefreedelivery();

    await dbmanager.getProductList().then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          prodctlist1 = usersFromServe;
          print(" Shipping ${prodctlist1[0].shipping}");
          print(" Shipping ${prodctlist1[0].shipping!.length}");

          for (var i = 0; i < prodctlist1.length; i++) {
            FoodAppConstant.shipingAmount = FoodAppConstant.shipingAmount +
                        prodctlist1[i].shipping!.trim().length >
                    1
                ? double.parse(prodctlist1[i].shipping!.trim())
                : 0.0;
            print(" Shipping ${FoodAppConstant.shipingAmount}");
          }
        });
      }
    });
    await mywallet(userid ?? "").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          walletlist = usersFromServe!;
          walletamt = walletlist[0].wallet;
          print("${walletamt}----->wallet");
        });
      }
    });

    await getUsableWAlletAmount();

    razorpay = new Razorpay();
    razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);

    isLoading.value = false;
  }

  String? orderid;
  String? signature;
  String? paymentId;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay?.clear();
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    // print(response.signature);
    setState(() {
      orderid = response.orderId;
      signature = response.signature;
      paymentId = response.paymentId;
    });
    showLongToast(
        "don't press back until payment gets completed or else payment will get cancelled.");
    showLoaderDialog(context);
    _getInvoice1("ONLINE");
    print("--------->Hellllllo");
  }

  void handlerErrorFailure(PaymentSuccessResponse response) {
    print("Pament error");
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    showLongToast(' Payment Error');
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  void handlerExternalWallet(PaymentSuccessResponse response) {
    print("External Wallet");
    showLongToast("External Wallet");

    Navigator.of(context, rootNavigator: true).pop('dialog');
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
      'amount': checkBoxValue || discountval_flag
          ? (twltamount! - difference!) * 100.0
          : finalamount! * 100.0,
      "currency": "INR",
      'name': FoodAppConstant.name,
      'description': prodctlist1[0].pname,
      'prefill': {'contact': mobile1, 'email': email1},
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

  @override
  Widget build(BuildContext context) {
    print("isloading.valuee---> ${isLoading.value}");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // backgroundColor:FoodAppColors.tela1,

          key: _scaffoldKey,
          // resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: FoodAppColors.tela,
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              "Checkout",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          body: ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (BuildContext context, bool value, Widget? child) {
              return isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            GroceryAppColors.tela),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
//                  Color:Colors.teal[50],
//                   color: FoodAppColors.tela1,

                            child: ListView(
                              children: <Widget>[
                                selectedAddressSection(),
                                // standardDelivery(),
                                checkoutItem(),
                                priceSection()
                              ],
                            ),
                          ),
                          flex: 30,
                        ),
                        Expanded(
                          child: Container(
                            // color: Colors.red[50].withOpacity(.9),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          colors: [
                                            Colors.red[50]!.withOpacity(.9),
                                            Colors.red[50]!.withOpacity(.9),
                                          ])),
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    left: 18,
                                    right: 18,
                                  ),
                                  child: Card(
                                    elevation: 0.0,
                                    child: Column(
                                      mainAxisAlignment: codp == 'yes'
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                "Total",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                // "\u{20B9} ${twltamount.toStringAsFixed(2)}",
                                                checkBoxValue ||
                                                        discountval_flag
                                                    ? "\u{20B9}${twltamount! - difference!}"
                                                    : "\u{20B9}${finalamount}",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        loader
                                            ? Container(
                                                child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          GroceryAppColors
                                                              .tela),
                                                ),
                                              ))
                                            : Container(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            // gateway == 'no'
                                            //     ? Container()
                                            //     :
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 10,
                                                    top: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    twltamount! - difference! ==
                                                                0.0 &&
                                                            checkBoxValue
                                                        ? Container(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    FoodAppColors
                                                                        .checkoup_paybuttoncolor,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(24))),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  loader = true;
                                                                });
                                                                _getInvoice1(
                                                                    "WALLET");
                                                              },
                                                              child: Text(
                                                                "Confirm",
                                                                style: CustomTextStyle
                                                                    .textFormFieldMedium
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    FoodAppColors
                                                                        .checkoup_paybuttoncolor,
//                          padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(24))),
                                                              ),
                                                              onPressed: () {
                                                                print(
                                                                    "calculated amount----->${calcutateAmount}");
                                                                print(
                                                                    "final amount----->${calcutateAmount}");
                                                                print(
                                                                    "final amount----->${twltamount! - difference!}");
                                                                openCheckout();
                                                                //openCheckout();
                                                              },
                                                              child: Text(
                                                                "Pay Online",
                                                                style: CustomTextStyle
                                                                    .textFormFieldMedium
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              ),
                                                            ),
                                                          )
//                                           Container(
//                                             child: RaisedButton(
//                                               onPressed: () {
//                                                 // _getInvoice1("UPI/QRCODE");
//                                                 showLoaderDialog(context);
//
//                                                 // _getInvoice1("COD");
//                                                 openCheckout();
//
// //                      Navigator.push(context,
// //                          new MaterialPageRoute(builder: (context) => CheckOutPage()));
//                                               },
//                                               color: FoodAppColors
//                                                   .checkoup_paybuttoncolor,
//                                               padding: EdgeInsets.only(
//                                                   top: 12,
//                                                   left: 12,
//                                                   right: 12,
//                                                   bottom: 12),
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                       Radius.circular(
//                                                           24))),
//                                               child: Text(
//                                                 "Pay Online",
//                                                 style: CustomTextStyle
//                                                     .textFormFieldMedium
//                                                     .copyWith(
//                                                     color:
//                                                     Colors.white,
//                                                     fontSize: 14,
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .bold),
//                                               ),
//                                             ),
//                                           ),
                                                    /*Container(
                              child: RaisedButton(
                                onPressed: () {
                                    _getInvoice1("THROUGH ACCOUNTS");
//                      Navigator.push(context,
//                          new MaterialPageRoute(builder: (context) => CheckOutPage()));
                                },
                                color: FoodAppColors.checkoup_paybuttoncolor,
//                          padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
                                shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24))),
                                child: Text(
                                    "THROUGH ACCOUNTS", style: CustomTextStyle.textFormFieldMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),

                                ),
                              ),
                            ),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                            codp == 'yes'
                                                ? Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 10,
                                                          top: 0),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              FoodAppColors
                                                                  .checkoup_paybuttoncolor,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 12,
                                                                  left: 12,
                                                                  right: 12,
                                                                  bottom: 12),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          24))),
                                                        ),
                                                        onPressed: () {
                                                          showLongToast(
                                                              "don't press back until payment gets completed or else payment will get cancelled.");
                                                          showLoaderDialog(
                                                              context);
                                                          _getInvoice1("COD");
                                                          setState(() {
                                                            flag = false;
                                                          });
//                      Navigator.push(context,
//                          new MaterialPageRoute(builder: (context) => CheckOutPage()));
                                                        },
                                                        child: flag
                                                            ? Text(
                                                                "Cash on Delivery",
                                                                style: CustomTextStyle
                                                                    .textFormFieldMedium
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              )
                                                            : Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                      ),
                                                    ),
                                                  )
                                                : Row(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          flex: 10,
                        )
                      ],
                    );
            },
          )),
    );
  }

  selectedAddressSection() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              // color: FoodAppColors.tela1,

//              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Deliver TO :",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[],
              ),
              createAddressText("Name: $name1", 16),
              createAddressText(
                  address1 != null
                      ? address1.toString() + " " + address2.toString()
                      : "address",
                  6),
              // createAddressText(address1!=null?address1:"address", 6),
              createAddressText(
                  city1 == null ? 'Banglore' : '${city1}:${pin1} ', 6),
              createAddressText(state1 != null ? "$state1" : 'Karnatka', 6),
              SizedBox(
                height: 6,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Mobile : ",
                      style: CustomTextStyle.textFormFieldMedium
                          .copyWith(fontSize: 12, color: Colors.grey.shade800)),
                  TextSpan(
                      text: mobile1 != null ? mobile1 : '9989898989',
                      style: CustomTextStyle.textFormFieldBold
                          .copyWith(color: Colors.black, fontSize: 12)),
                ]),
              ),

              /*Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Edit / Change",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 18, color: Colors.indigo.shade700),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) => DliveryInfo()));
                      },
                      child: Icon(

                        Icons.edit,
                        color: Colors.pink,
                        size: 24.0,
                      ),
                    ),
                  )
                ],
              ),*/

              SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.grey.shade300,
                height: 1,
                width: double.infinity,
              ),
//              addressAction()
            ],
          ),
        ),
      ),
    );
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: CustomTextStyle.textFormFieldMedium
            .copyWith(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }

  addressAction() {
    return Container(
      child: Row(
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Edit / Change",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(fontSize: 12, color: Colors.indigo.shade700),
            ),
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
          ),
          Spacer(
            flex: 3,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.grey,
          ),
          Spacer(
            flex: 3,
          ),
          TextButton(
            onPressed: () {},
            child: Text("Add New Address",
                style: CustomTextStyle.textFormFieldSemiBold
                    .copyWith(fontSize: 12, color: Colors.indigo.shade700)),
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  standardDelivery() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border:
              Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (isChecked) {},
            activeColor: Colors.tealAccent.shade400,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Standard Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "  Free Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  checkoutItem() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: ListView.builder(
            itemBuilder: (context, position) {
              return checkoutListItem(position);
            },
            itemCount: WishlistState.prodctlist1!.length > 0
                ? WishlistState.prodctlist1!.length
                : 0,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
          ),
        ),
      ),
    );
  }

  checkoutListItem(int position) {
    return Stack(
      children: <Widget>[
        Container(
//              padding: EdgeInsets.only(right: 8, top: 4),
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              WishlistState.prodctlist1![position].pname == null
                  ? 'name'
                  : WishlistState.prodctlist1![position].pname ?? "",
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)
                  .copyWith(fontSize: 14),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 0, top: 8, bottom: 8),
                width: 50,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.blue.shade200,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: prodctlist1 != null
                            ? prodctlist1.length > 0
                                ? prodctlist1[position].pimage != null
                                    ? NetworkImage(
                                        FoodAppConstant.Product_Imageurl +
                                            WishlistState
                                                .prodctlist1![position].pimage
                                                .toString(),
                                      )
                                    : AssetImage("assets/images/plogo.png")
                                        as ImageProvider
                                : AssetImage("assets/images/plogo.png")
                            : AssetImage("assets/images/plogo.png"))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          // WishlistState.prodctlist1[position].pcolor!=null?  Text(
                          //   'COLOR: ${WishlistState.prodctlist1[position].pcolor}',
                          //   style:TextStyle( fontWeight: FontWeight.w400, color: Colors.black)
                          //       .copyWith(color: Colors.grey, fontSize: 14),
                          // ):Row(),
                          // WishlistState.prodctlist1[position].pcolor.length>0?   SizedBox(width: 20):Row(),

                          WishlistState.prodctlist1![position].pQuantity != null
                              ? Text(
                                  'Quantity: ${WishlistState.prodctlist1![position].pQuantity}',
                                  style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)
                                      .copyWith(
                                          color: Colors.grey, fontSize: 14),
                                )
                              : Row(),
                        ],
                      ),

                      SizedBox(height: 3),
                      WishlistState.prodctlist1![position].varient != null
                          ? Text(
                              'Varient: ${WishlistState.prodctlist1![position].varient}',
                              style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)
                                  .copyWith(color: Colors.grey, fontSize: 14),
                            )
                          : Row(),

                      WishlistState.prodctlist1![position].shipping!.length > 0
                          ? Text(
                              'Shipping:  \u{20B9} ${WishlistState.prodctlist1![position].shipping}',
                              style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)
                                  .copyWith(color: Colors.grey, fontSize: 14),
                            )
                          : Row(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              WishlistState.prodctlist1![position].pprice ==
                                      null
                                  ? '00.0'
                                  : '\u{20B9} ${double.parse(WishlistState.prodctlist1![position].pprice.toString()).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ).copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
      ],
    );
  }

  priceSection() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          // color: FoodAppColors.tela1,
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.all(Radius.circular(4)),
//              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Flexible(
//                    child: Padding(
//                      padding: EdgeInsets.only(right: 10.0),
//                      child:  TextFormField(
//                        controller:coupanController,
//                        keyboardType: TextInputType.number,
//                        validator: (String value){
//                          if(value.isEmpty){
//                            return " Apply Coupon Code";
//                          }
//                        },
//                        decoration: const InputDecoration(
//                            hintText: "Apply Coupon Code"),
////                        enabled: !_status,
//                      ),
//                    ),
////                    flex: 2,
//                  ),
//
//
//                  Expanded(
//                    child: Padding(
//                      padding: EdgeInsets.only(right: 0.0),
//                      child: Container(
//                          child:  Center(
//                            child: RaisedButton(
//                              child: new Text("Apply  Coupon"),
//                              textColor: Colors.white,
//                              color: FoodAppColors.telamoredeep,
//                              onPressed: () {
//
////
//                              },
//                              shape: new RoundedRectangleBorder(
//                                  borderRadius: new BorderRadius.circular(20.0)),
//                            ),
//                          )),
//                    ),
////                    flex: 2,
//                  ),
//                ],
//              ),

              hideApplyButton
                  ? Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: FoodAppColors.sellp,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "Congratulations! you saved \u{20B9}${difference!.toStringAsFixed(1)} on this order.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: FoodAppColors.white,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: TextFormField(
                              controller: coupanController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return " Apply Coupon Code";
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "Apply Coupon Code"),
//                        enabled: !_status,
                            ),
                          ),
//                    flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 0.0),
                            child: Container(
                                child: Center(
                              child: applyButtonLoader
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: FoodAppColors
                                            .checkoup_paybuttoncolor,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: new Text("Apply "),
                                      onPressed: () {
                                        setState(() {
                                          applyButtonLoader = true;
                                        });
                                        _applycoupancode("1");
                                      },
                                    ),
                            )),
                          ),
//                    flex: 2,
                        ),
                      ],
                    ),
              SizedBox(
                height: 25,
              ),

              walletamt != "0" && double.parse(usableWAlletAmount ?? "") != 0
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.red[50]!.withOpacity(.9),
                                Colors.red[50]!.withOpacity(.9),
                              ])),
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                        left: 4,
                        right: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              activeColor: FoodAppColors.sellp,
                              value: checkBoxValue,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  checkBoxValue = newValue!;
                                  if (newValue) {
                                    print("count------->$count");
                                    if (double.parse(usableWAlletAmount ?? "") >
                                        finalamount!) {
                                      print("first");
                                      print(walletamt);
                                      print(twltamount);
                                      twltamount = finalamount;
                                      wltamount = double.parse(walletamt ?? "");
                                      twltamt = wltamount! - twltamount!;
                                      wltamount = finalamount! -
                                          double.parse(walletamt ?? "");
                                      print("yhaan");
                                      print(wltamount);
                                      twltamount = 0;
                                    } else {
                                      print("second");
                                      twltamount = finalamount;
                                      wltamount = wltamount;
                                      twltamount = twltamount! -
                                          int.parse(usableWAlletAmount ?? "");
                                      twltamt = 0;
                                    }
                                  } else {
                                    print("third");
                                    twltamount = finalamount;
                                    wltamount =
                                        double.parse(usableWAlletAmount ?? "");
                                    twltamt = wltamount;
                                  }
                                });
                              }),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pay using Wallet",
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                              Text(
                                "Wallet Points:   " +
                                    "${walletamt != null ? walletamt : "0"}",
                                style: TextStyle(
                                    color: FoodAppColors.sellp, fontSize: 12),
                              ),
                              double.parse(walletamt ?? "") >
                                      double.parse(usableWAlletAmount ?? "")
                                  ? Text(
                                      "You can use ${usableWAlletAmount} points from your wallet ",
                                      style: TextStyle(
                                          color: FoodAppColors.tela,
                                          fontSize: 12),
                                    )
                                  : Container(),
                              double.parse(walletamt ?? "") <
                                      double.parse(usableWAlletAmount ?? "")
                                  ? Text(
                                      "You can use \u{20B9}${walletamt} from your wallet ",
                                      style: TextStyle(
                                          color: FoodAppColors.tela,
                                          fontSize: 12),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 25,
              ),
              Text(
                "PRICE DETAILS",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Total MRP",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "\u{20B9} ${(calcutateAmount)!.toStringAsFixed(2)}",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Total Item",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "${FoodAppConstant.itemcount}",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              difference! > 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Coupan discount",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "-${difference}",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.green),
                          ),
                        ),
                      ],
                    )
                  : Row(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Delivery Charges (+)",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      deliveryfee != null ? deliveryfee : "00.00",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              checkBoxValue &&
                      (double.parse(usableWAlletAmount ?? "") < finalamount!)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Wallet Points (-)",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "${double.parse(usableWAlletAmount ?? "")}",
                            // "\u{20B9} ${finalamountu}",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              checkBoxValue &&
                      (double.parse(usableWAlletAmount ?? "") > finalamount!)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Wallet Amount (-)",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "\u{20B9} ${finalamount}",
                            // "\u{20B9} ${finalamountu}",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              checkBoxValue &&
                      (double.parse(usableWAlletAmount ?? "") == finalamount)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Wallet Amount (-)",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "\u{20B9} ${finalamount}",
                            // "\u{20B9} ${finalamountu}",
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 15, color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : Container(),

              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total",
                    style: CustomTextStyle.textFormFieldSemiBold
                        .copyWith(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    // "${twltamount.toStringAsFixed(2)}",
                    checkBoxValue || discountval_flag
                        ? "${twltamount! - difference!}"
                        : "${finalamount}",
                    style: CustomTextStyle.textFormFieldSemiBold
                        .copyWith(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
                child: Container(
                    child: TextFormField(
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        // Use mobile input type for emails.
                        controller: resignofcause,
                        decoration: new InputDecoration(
                          hintText: 'Order Notes',
                          labelText: 'Order Notes',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),

//                                      icon: new Icon(Icons.queue_play_next),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: Colors.grey.shade700, fontSize: 12),
          ),
          Text(
            value,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: color, fontSize: 12),
          )
        ],
      ),
    );
  }

  Future _getwalletActive() async {
    var map = new Map<String, dynamic>();
    map['username'] = user_name;
    map['shop_id'] = FoodAppConstant.Shop_id.toString();

    print(FoodAppConstant.base_url + 'api/user_active_order.php');
    print(map.toString());

    final response = await http.post(
        Uri.parse(FoodAppConstant.base_url + 'api/user_active_order.php'),
        body: map);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      // Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
      // print("123"+user.Invoice);
      if (jsonBody["success"] == "true") {
        if (jsonBody["orders"] == "0") {
          setState(() {
            flag1 = true;
            if (double.parse(walletamt ?? "") > finalamount!) {
              twltamount = finalamount;
              wltamount = double.parse(walletamt ?? "");
              twltamt = wltamount! - twltamount!;
              wltamount = finalamount;
              twltamount = 0;
            } else {
              twltamount = finalamount;
              wltamount = double.parse(walletamt ?? "");
              twltamount = twltamount! - wltamount!;
              twltamt = 0;
            }
            twltamount = finalamount;
            wltamount = double.parse(walletamt ?? "");
            twltamt = wltamount;
          });
        } else {
          twltamount = finalamount;
          // wltamount = 0.0;
          twltamt = wltamount;
        }
      } else {
        // showLongToast('Invoice is not generated');
      }
    } else
      throw Exception("Unable to generate Employee Invoice");
//    print("123  Unable to generate Employee Invoice");
  }

// String invoicemenual;
  Future _getInvoice1(String paymode) async {
    var map = new Map<String, dynamic>();
    map['name'] = name1;
    map['mobile'] = user_name;
    map['email'] = email1;
    map['address'] = address1;
    map['pincode'] = pin1;
    map['city'] = city1;
    map['invoice_total'] = (calcutateAmount! - difference!).toString();
    map['notes'] = resignofcause.text != null ? resignofcause.text : "";
    map['shop_id'] = FoodAppConstant.Shop_id.toString();
    map['PayMode'] = paymode;
    map['user_id'] = "user_id";
    map['shipping'] = deliveryfee;
    map['mv'] = prodctlist1[0].mv.toString();
    map['lat'] = FoodAppConstant.latitude.toString();
    map['lng'] = FoodAppConstant.longitude.toString();
    map['coupon'] = coupancode != null ? coupancode : "";
    map['couponAmount'] = difference.toString();

    print(map.toString());
    final response = await http
        .post(Uri.parse(FoodAppConstant.base_url + 'api/order.php'), body: map);

    if (response.statusCode == 200) {
//      final jsonBody = json.decode(response.body);
      Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
      // print("123"+user.Invoice);
      if (user.success.toString() == "true") {
        print("12345" + user.Invoice!);

        _uploadProducts(user.Invoice ?? "", paymode);
        setState(() {
          invoiceid = user.Invoice;
        });
      } else {
        showLongToast('Invoice is not generated');
      }
    } else
      throw Exception("Unable to generate Employee Invoice");
//    print("123  Unable to generate Employee Invoice");
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: new Row(
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

  Future _uploadProducts(String invoice, String paytype) async {
    // int pmv= prodctlist1[0].mv;
    //
    // print("Pmv12   "+pmv.toString()+ "   "+prodctlist1.length.toString());
    for (int i = 0; i < prodctlist1.length; i++) {
      /*     if(pmv==prodctlist1[i].mv) {
        setState(() {
          pmv=prodctlist1[i].mv;

          print("Pmv"+pmv.toString());
        });*/

      // print("WishlistState.prodctlist1[i].pimage");
      // print(WishlistState.prodctlist1[i].pimage);

      var map = new Map<String, dynamic>();
      // print(invoice);
      // print(WishlistState.prodctlist1[i].pid);
      // print(WishlistState.prodctlist1[i].pname);
      // print(WishlistState.prodctlist1[i].pQuantity);
      // print(WishlistState.prodctlist1[i].costPrice);
      // print(WishlistState.prodctlist1[i].discount);
      // print(WishlistState.prodctlist1[i].discountValue);
      // print(WishlistState.prodctlist1[i].adminper);
      // print(WishlistState.prodctlist1[i].adminpricevalue);
      // print(WishlistState.prodctlist1[i].cgst);
      // print(WishlistState.prodctlist1[i].sgst);
      // print(WishlistState.prodctlist1[i].pcolor);
      // print(WishlistState.prodctlist1[i].pimage);

      map['invoice_id'] = invoice;
      map['product_id'] = prodctlist1[i].pid;
      map['product_name'] = prodctlist1[i].pname;
      map['quantity'] = prodctlist1[i].pQuantity.toString();
      map['price'] = (int.parse(prodctlist1[i].costPrice ?? "") *
              prodctlist1[i].pQuantity!)
          .toString();
      map['user_per'] = prodctlist1[i].discount;
      map['user_dis'] = (double.parse(prodctlist1[i].discountValue ?? "") *
              prodctlist1[i].pQuantity!)
          .toStringAsFixed(2)
          .toString();
      map['admin_per'] = prodctlist1[i].adminper;
      map['admin_dis'] = prodctlist1[i].adminpricevalue;
      map['shop_id'] = FoodAppConstant.Shop_id;
      map['cgst'] = prodctlist1[i].cgst;
      map['sgst'] = prodctlist1[i].sgst;
      map['variant'] = prodctlist1[i].varient == null
          ? " "
          : WishlistState.prodctlist1![i].varient;
      map['color'] =
          prodctlist1[i].pcolor == null || prodctlist1[i].pcolor!.isEmpty
              ? ""
              : prodctlist1[i].pcolor;
      map['size'] =
          prodctlist1[i].psize == null || prodctlist1[i].psize!.isEmpty
              ? ""
              : prodctlist1[i].psize;
      map['refid'] = "0";
      map['image'] = prodctlist1[i].pimage;
      map['prime'] = "0";
      map['mv'] = prodctlist1[i].mv.toString();
      map['adate'] = textval == "Select Date" || textval.isEmpty
          ? ''
          : (Jiffy(textval, "dd/MM/yyyy").format("yyyy-MM-dd")).toString();
      //map['atime'] =textval1 == "Select Time" ||textval1.isEmpty ? '' : textval1;
      final response = await http.post(
          Uri.parse(FoodAppConstant.base_url + 'api/order.php'),
          body: map);

      try {
        // print(response);
        if (response.statusCode == 200) {
//        final jsonBody = json.decode(response.body);
          ProductAdded1 user =
              ProductAdded1.fromJson(jsonDecode(response.body));

          setState(() {
            if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'ONLINE') {
              showLongToast(' Your order is successful');
              dbmanager.deleteallProducts();
              FoodAppConstant.itemcount = 0;
              FoodAppConstant.foodAppCartItemCount = 0;
              foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
              pre!.setString("mvid", "");
              _afterPayment(orderid ?? "", signature ?? "", paymentId ?? "");

              // openCheckout();

              // Navigator.push(context,
              //   MaterialPageRoute(builder: (context) => ShowInVoiceId(user.Invoice)),);
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'COD') {
              showLongToast(' Your  order is  sucessfull');
              dbmanager.deleteallProducts();
              FoodAppConstant.itemcount = 0;
              FoodAppConstant.foodAppCartItemCount = 0;
              foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
              pre!.setString("mvid", "");

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId(user.Invoice)),
              );
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'WALLET') {
              dbmanager.deleteallProducts();
              FoodAppConstant.itemcount = 0;
              FoodAppConstant.foodAppCartItemCount = 0;
              foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
              pre!.setString("mvid", "");
              walletPurchase();
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'UPI/QRCODE') {
              showLongToast(' Your order is successful');
              dbmanager.deleteallProducts();
              FoodAppConstant.itemcount = 0;
              FoodAppConstant.itemcount = 0;
              FoodAppConstant.itemcount = 0;
              pre!.setString("mvid", "");

//
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId1(user.Invoice)),
              );
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'THROUGH ACCOUNTS') {
              showLongToast(' Your order is successful');
              dbmanager.deleteallProducts();
              FoodAppConstant.itemcount = 0;
              FoodAppConstant.itemcount = 0;
              pre!.setString("mvid", "");

//          openCheckout();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId1(user.Invoice)),
              );
            } else {
              // showLongToast(' Somting went wrong');
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

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _afterPayment(
      String orderid, String signature, String paymentId) async {
    var map = new Map<String, dynamic>();

    print(mobile1);
    print(FoodAppConstant.name);
    print(user_name);
    print(paymentId);
    print(orderid);
    print(signature);
    print(FoodAppConstant.email);
    print(user_name);
    print(finalamount.toString());
    print(invoiceid);

//Wallet For Tiffynox...............................................................................................................
//Wallet For Tiffynox...............................................................................................................
//Wallet For Tiffynox...............................................................................................................
//Wallet For Tiffynox...............................................................................................................

    map['phone'] = mobile1;
    map['name'] = FoodAppConstant.name;
    map['razorpay_payment_id'] = paymentId != null ? paymentId : "";
    map['razorpay_order_id'] = orderid != null ? orderid : "";
    map['razorpay_signature'] = signature != null ? signature : "";
    map['email'] = FoodAppConstant.email;
    map['username'] = user_name;
    map['price'] = (calcutateAmount).toString();
    map['purpose'] = invoiceid;
    //map['mem_plan_id'] = "8";
    print("map---------->${map}");
    final response = await http.post(
        Uri.parse(FoodAppConstant.base_url + 'verifyUser.php'),
        body: map);

    try {
      if (response.statusCode == 200) {
        print("res---->${response.body}");
        print("Your order is  sucessful");
        showLongToast(' Your  order is  sucessful');
        Navigator.of(context, rootNavigator: true).pop('dialog');
        checkBoxValue && int.parse(usableWAlletAmount ?? "") < finalamount!
            ? walletPurchase1()
            : print("hi");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowInVoiceId(invoiceid ?? "")),
        );
      }
    } catch (Exception) {}
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future walletPurchase() async {
    String md5 = generateMd5(
        mobile1.toString() + invoiceid.toString() + finalamount.toString());
    String link = FoodAppConstant.base_url + "api/payFromWallet.php";
    var body = {
      "username": mobile1,
      "key": md5,
      "price": finalamount.toString(),
      "purpose": invoiceid,
      "name": FoodAppConstant.name,
      "phone": mobile1,
      "email": FoodAppConstant.email,
    };
    print("walletPurchaseBody------->${body}");
    final response = await http.post(Uri.parse(link), body: body);

    try {
      if (response.statusCode == 200) {
        print("response------->${response.body}");
        print("res---->${response.body}");
        showLongToast('Your order is successful');
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          loader = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowInVoiceId(invoiceid ?? "")),
        );
      }
    } catch (Exception) {}
  }

  Future walletPurchase1() async {
    String md5 = generateMd5(
        mobile1 ?? "" + invoiceid.toString() + usableWAlletAmount.toString());
    String link = FoodAppConstant.base_url + "api/payFromWallet.php";
    var body = {
      "username": mobile1,
      "key": md5,
      "price": usableWAlletAmount,
      "purpose": invoiceid,
      "name": FoodAppConstant.name,
      "phone": mobile1,
      "email": FoodAppConstant.email,
    };
    print("walletPurchaseBody------->${body}");
    final response = await http.post(Uri.parse(link), body: body);
    try {
      if (response.statusCode == 200) {
        print("response------->${response.body}");
        print("res---->${response.body}");
        showLongToast('Your order is successful');
        //Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          loader = false;
        });
      }
    } catch (Exception) {}
  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    return returnStr;
  }

  void _applycoupancode(String val) {
    if (coupanController.text.length > 4) {
      Coupan coupan;
      getCoupan(coupanController.text).then((usersFromServe) {
        setState(() {
          // prodctlist1
          coupan = usersFromServe!;
          if (coupan.status == "true") {
            String fortype = coupan.data!.couponCodes![0].fortype ?? "";

            if (int.parse(coupan.data!.couponCodes![0].mv_id ?? "") > 0) {
              if (coupan.data!.couponCodes![0].mv_id ==
                  "${pre!.getString("mvid")}") {
                if (fortype == "first") {
                  trackInvoice1(FoodAppConstant.username)
                      .then((usersFromServe) {
                    setState(() {
                      list = usersFromServe!;
                      print("InVOICE LIST  ${list.length}");
                      list.length > 0
                          ? showLongToast("Invalid and Expire Coupon")
                          : checkvalue(coupan);
                      // getCoupanVal(coupan);
                    });
                  });
                } else {
                  // getCoupanVal(coupan);
                  checkvalue(coupan);
                }
              } else {
                setState(() {
                  applyButtonLoader = false;
                });
                showLongToast(" Coupon is not applied for this vendor");
              }
            } else {
              if (fortype == "first") {
                trackInvoice1(FoodAppConstant.username).then((usersFromServe) {
                  setState(() {
                    list = usersFromServe!;
                    print("InVOICE LIST  ${list.length}");
                    if (list.length > 0) {
                      applyButtonLoader = false;
                      showLongToast("Invalid and Expire Coupon");
                    } else {
                      checkvalue(coupan);
                    }
                  });
                });
              } else {
                checkvalue(coupan);
              }
            }
          } else {
            showLongToast("Invalid Or Expire Coupon");
            setState(() {
              difference = 0.0;
              applyButtonLoader = false;
            });
          }
        });
      });
    } else {
      showLongToast("Invalid Or Expire Coupon");
      setState(() {
        difference = 0.0;
        applyButtonLoader = false;
      });
    }
  }

  checkvalue(Coupan coupan) {
    if (coupan.data!.couponCodes![0].pro_id!.length > 0) {
      // print("product Id  ${prodctlist1[0].pid}");
      // print("product Id  ${coupan.data.couponCodes[0].pro_id}");
      print("length------>${prodctlist1.length}");
      for (var i = 0; i < prodctlist1.length; i++) {
        if (prodctlist1[i].pid!.trim() ==
            coupan.data!.couponCodes![0].pro_id!.trim()) {
          //getCoupanVal(coupan);
          if (coupan.data!.couponCodes![0].type == "per") {
            double differ = double.parse(calDiscount1(
                prodctlist1[i].pprice.toString(),
                coupan.data!.couponCodes![0].val ?? ""));
            print("differ${differ}");
            String val = calDiscount(calcutateAmount.toString(),
                coupan.data!.couponCodes![0].val ?? "");
            String val1 = calDiscount1(calcutateAmount.toString(),
                coupan.data!.couponCodes![0].val ?? "");

            setState(() {
              discountval_flag = true;
              if (differ >
                  double.parse(coupan.data!.couponCodes![0].maxVal ?? "")) {
                setState(() {
                  difference =
                      double.parse(coupan.data!.couponCodes![0].maxVal ?? "");
                  discountval_flag = true;
                  finalamount = finalamount! - difference!;
                  applyButtonLoader = false;
                  hideApplyButton = true;
                });
                showLongToast("Coupon code applied successfully...");
              } else {
                difference = differ;
                finalamount = finalamount! - difference!;
              }
              applyButtonLoader = false;
              hideApplyButton = true;
              showLongToast("Coupon code applied successfully...");
            });
          } else {
            setState(() {
              difference = double.parse(coupan.data!.couponCodes![0].val ?? "");
              discountval_flag = true;
              finalamount = finalamount! - difference!;
            });
            applyButtonLoader = false;
            hideApplyButton = true;
            showLongToast("Coupon code applied successfully...");
          }
          break;
        } else {
          if (i == prodctlist1.length - 1) {
            print("called--------->2");
            setState(() {
              applyButtonLoader = false;
            });
            showLongToast("Invalid Or Expire Coupon");
          }
        }
      }
    } else {
      print("called--------->3");
      calcutateAmount = FoodAppConstant.totalAmount;
      getCoupanVal(coupan);

      print("calcutateAmount  ${calcutateAmount}");
    }
  }

  getCoupanVal(Coupan coupan) {
    setState(() {
      coupancode = coupanController.text;
      String name = FoodAppConstant.username;
      String usernamevalue = coupan.data!.couponCodes![0].userId ?? "";
      int length = coupan.data!.couponCodes![0].userId!.length;
      if (double.parse(coupan.data!.couponCodes![0].minVal ?? "") <
          calcutateAmount! + 1) {
        print("if----------->1");
        if (length > 3) {
          print("if----------->2");
          if (name.contains(usernamevalue)) {
            print("if----------->3");
            if (coupan.data!.couponCodes![0].type == "per") {
              print("if----------->4");
              double differ = double.parse(calDiscount1(
                  calcutateAmount.toString(),
                  coupan.data!.couponCodes![0].val ?? ""));
              String val = calDiscount(calcutateAmount.toString(),
                  coupan.data!.couponCodes![0].val ?? "");
              String val1 = calDiscount1(calcutateAmount.toString(),
                  coupan.data!.couponCodes![0].val ?? "");
              print("value1  ${val}");
              setState(() {
                discountval_flag = true;

                if (differ >
                    double.parse(coupan.data!.couponCodes![0].maxVal ?? "")) {
                  setState(() {
                    difference =
                        double.parse(coupan.data!.couponCodes![0].maxVal ?? "");
                    discountval_flag = true;
                    finalamount = finalamount! - difference!;
                    applyButtonLoader = false;
                    hideApplyButton = true;
                  });
                  showLongToast("Coupon code applied successfully...");
                } else {
                  difference = double.parse(val1);
                  finalamount = finalamount! - difference!;
                  applyButtonLoader = false;
                  hideApplyButton = true;
                  showLongToast("Coupon code applied successfully...");
                }
              });
            } else {
              setState(() {
                difference =
                    double.parse(coupan.data!.couponCodes![0].val ?? "");
                discountval_flag = true;
                print(difference);
                finalamount = finalamount! - difference!;
                applyButtonLoader = false;
                hideApplyButton = true;
              });
              showLongToast("Coupon code applied successfully...");
            }
          } else {
            setState(() {
              applyButtonLoader = false;
            });
            showLongToast("Invalid Or Expire Coupon");
          }
        } else {
          print("else called---->");
          if (coupan.data!.couponCodes![0].type == "per") {
            double differ = double.parse(calDiscount1(
                calcutateAmount.toString(),
                coupan.data!.couponCodes![0].val ?? ""));

            String val = calDiscount(calcutateAmount.toString(),
                coupan.data!.couponCodes![0].val ?? "");
            String val1 = calDiscount1(calcutateAmount.toString(),
                coupan.data!.couponCodes![0].val ?? "");

            setState(() {
              discountval_flag = true;
              if (differ >
                  double.parse(coupan.data!.couponCodes![0].maxVal ?? "")) {
                setState(() {
                  difference =
                      double.parse(coupan.data!.couponCodes![0].maxVal ?? "");
                  discountval_flag = true;
                  finalamount = finalamount! - difference!;
                  applyButtonLoader = false;
                  hideApplyButton = true;
                });
                showLongToast("Coupon code applied successfully...");
              } else {
                difference = double.parse(val1);
                finalamount = finalamount! - difference!;
              }
              applyButtonLoader = false;
              hideApplyButton = true;
              showLongToast("Coupon code applied successfully...");
            });
          } else {
            setState(() {
              difference = double.parse(coupan.data!.couponCodes![0].val ?? "");
              discountval_flag = true;
              finalamount = finalamount! - difference!;
            });
            applyButtonLoader = false;
            hideApplyButton = true;
            showLongToast("Coupon code applied successfully...");
          }
        }
      } else {
        applyButtonLoader = false;
        showLongToast(
            "Coupon is only valid for orders above ${coupan.data!.couponCodes![0].minVal}");
      }
    });
  }

  String calDiscount1(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = ((byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    return returnStr;
  }
}

/*

double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}


IndiVisualvenderDetails().then((usersFromServe) {
setState(() {
vender = usersFromServe;
vender.length>0? p = calculateDistance(double.parse(vender[0].lat),double.parse(vender[0].lng),double.parse(widget.address.lat),double.parse(widget.address.lng)):p=0;
print('distance ${p}');
if(p<=4){
p= p+20.0;
// finalamount=finalamount+p;
_gefreedelivery(20);

}
else if(p>4&& p<=6) {
p= p+30.0;
// finalamount=finalamount+p;
_gefreedelivery(30);

} else if(p>6&& p<=8)
{
p=p+40.0;
_gefreedelivery(40);
// finalamount=finalamount+p;

}
else{
_gefreedelivery(60);
// p= p+60.0;
// finalamount=finalamount+p;

// deliveryfee=(double.parse(deliveryfee)+60.0).toString();
}

});
});*/

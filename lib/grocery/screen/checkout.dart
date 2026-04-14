import 'dart:convert';
import 'dart:developer';

import 'package:ecoshine24/grocery/screen/coupen_codes.dart';
import 'package:ecoshine24/grocery/screen/instamojo.dart';
import 'package:ecoshine24/grocery/screen/phonepay.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ecoshine24/grocery/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/StyleDecoration/styleDecoration.dart';
import 'package:ecoshine24/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/AddressModel.dart';
import 'package:ecoshine24/grocery/model/CoupanModel.dart';
import 'package:ecoshine24/grocery/model/CustmerModel.dart';
import 'package:ecoshine24/grocery/model/InvoiceModel.dart';
import 'package:ecoshine24/grocery/model/OrderDliverycharge.dart';
import 'package:ecoshine24/grocery/model/TrackInvoiceModel.dart';
import 'package:ecoshine24/grocery/model/usable_wallet_amount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:provider/provider.dart';

import '../../General/AppConstant.dart';
import '../../controller/phonepay_controller.dart';
import '../General/Home.dart';
import 'ShowINVoiceIc1.dart';
import 'ShowInvoiceid2.dart';
import 'finalScreen.dart';

/*final String date;
final String time;
const CheckOutPage(this.date, this.time) : super();*/
class CheckOutPage extends StatefulWidget {
  final UserAddress address;

  const CheckOutPage(this.address) : super();

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final DbProductManager dbmanager = DbProductManager();
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
      finalamount = 0.0,
      calcutateAmount = 0.0,
      checkamount = 0.0,
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
  String? razorpayOn;
  String? instaMojoOn;
  double Onedayprice = 0.00;
  String fast_text = "";
  String? usableWAlletAmount;
  String? finalUsableWAlletAmount;
  String textval = "Select Date";
  String textval1 = "Select Time";
  // Modern date/time slot state
  DateTime? selectedDate;
  DateTime? selectedTimeSlot;
  int serviceDurationHours = 4; // configurable if needed
  String displayDate = "Select Date";
  String selectedPayment = "";
  bool loader = false;
  bool applyButtonLoader = false;
  bool hideApplyButton = false;
  List<TrackInvoice> list = [];

  String? phonepayOn;

//   Future<void> _gefreedelivery() async {
//     final response = await http.get(Uri.parse(GroceryAppConstant.base_url +
//         'api/shipping.php?shop_id=' +
//         GroceryAppConstant.Shop_id));

//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       DeliveryCharge user1 = DeliveryCharge.fromJson(jsonDecode(response.body));
//       if (user1.success.toString() == "true") {
//         setState(() {
//           instaMojoOn = user1.imGatway;
//           print('called data!' + instaMojoOn.toString());

//           gateway = user1.Gateway;
//           codp = user1.COD;
//           razorpay_key = user1.razorpay_key;
//         });
//         print(user1.COD);
//         // print("user1.Min_Order");
//         if (GroceryAppConstant.totalAmount <
//             double.parse(user1.Min_Order ?? "")) {
//           setState(() {
//             deliveryfee = (double.parse(user1.Fee ?? "") +
//                     GroceryAppConstant.shipingAmount)
//                 .toString();
//             finalamount =
//                 GroceryAppConstant.totalAmount + double.parse(user1.Fee ?? "");
//             twltamount =
//                 GroceryAppConstant.totalAmount + double.parse(user1.Fee ?? "");
//           });
//         } else {
//           if (GroceryAppConstant.shipingAmount > 0) {
//             setState(() {
//               deliveryfee =
//                   (double.parse("0.0") + GroceryAppConstant.shipingAmount)
//                       .toString();
//               finalamount = GroceryAppConstant.totalAmount +
//                   double.parse(user1.Fee ?? "");
//               twltamount = GroceryAppConstant.totalAmount +
//                   double.parse(user1.Fee ?? "");
//             });
//           } else {
//             deliveryfee = '0.0';
//           }
//         }

// //        setState(() {
// //          invoiceid=user.Invoice;
// //
// //        });
//       } else {
//         twltamount =
//             GroceryAppConstant.totalAmount + double.parse(user1.Fee ?? "");
//       }
//     } else
//       throw Exception("Unable to generate Employee Invoice");
// //    print("123  Unable to generate Employee Invoice");
//   }

  Future<void> _gefreedelivery() async {
    final response = await http.get(Uri.parse(GroceryAppConstant.base_url +
        'api/shipping.php?shop_id=' +
        GroceryAppConstant.Shop_id));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      DeliveryCharge user1 = DeliveryCharge.fromJson(jsonDecode(response.body));
      if (user1.success.toString() == "true") {
        setState(() {
          instaMojoOn = user1.imGatway;
          phonepayOn = user1.phone_pay;
          print('called data!' + instaMojoOn.toString());

          gateway = user1.Gateway;
          codp = user1.COD;
          razorpay_key = user1.razorpay_key;
        });
        print(user1.COD);
        // print("user1.Min_Order");
        if (GroceryAppConstant.totalAmount < double.parse(user1.Min_Order)) {
          setState(() {
            deliveryfee =
                (double.parse(user1.Fee) + GroceryAppConstant.shipingAmount)
                    .toString();
            finalamount =
                GroceryAppConstant.totalAmount + double.parse(user1.Fee);
            twltamount =
                GroceryAppConstant.totalAmount + double.parse(user1.Fee);
          });
        } else {
          if (GroceryAppConstant.shipingAmount > 0) {
            deliveryfee =
                (double.parse("0.0") + GroceryAppConstant.shipingAmount)
                    .toString();
            finalamount =
                GroceryAppConstant.totalAmount + double.parse(user1.Fee);
            twltamount =
                GroceryAppConstant.totalAmount + double.parse(user1.Fee);
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
        "${GroceryAppConstant.base_url}api/cp.php?shop_id=${GroceryAppConstant.Shop_id}";
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var result = UsableWalletAmount.fromJson(jsonDecode(response.body));
      var usablePercent = result.walletCanBeUsed;

      if (usablePercent != null && num.parse(usablePercent) > 0) {}
      print(calcutateAmount);
      usableWAlletAmount =
          (int.parse(walletamt ?? "") * (int.parse(usablePercent ?? "")) / 100)
              .toStringAsFixed(0);
      print(walletamt);
      print("usableamount---->$usableWAlletAmount");
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
    print(user_name.toString() + "userNAme");

    // walletamt="2000";
    String? email = pre!.getString("email");
    String? name = pre!.getString("name");
//    String? pin= pre!.getString("pin");
//    String? city= pre!.getString("city");
//    String? address= pre!.getString("address");
    String? sex = pre!.getString("sex");
//    String? state=pre!.getString("state");
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
      GroceryAppConstant.name = name ?? "";
      GroceryAppConstant.email = email ?? "";
      GroceryAppConstant.username = user_name ?? "";
      GroceryAppConstant.latitude = double.parse(widget.address.lat ?? "");
      GroceryAppConstant.longitude = double.parse(widget.address.lng ?? "");

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
    isLoading.value = true;
    await getUserInfo();
    finalamount = GroceryAppConstant.totalAmount;
    calcutateAmount = GroceryAppConstant.totalAmount;
    await dbmanager.getProductList().then((usersFromServe) async {
      if (this.mounted) {
        setState(() {
          prodctlist1 = usersFromServe;
          // Reset and recompute shipping amount
          GroceryAppConstant.shipingAmount = 0.0;
          for (var i = 0; i < prodctlist1.length; i++) {
            final String ship = prodctlist1[i].shipping?.trim() ?? '';
            GroceryAppConstant.shipingAmount +=
                ship.isNotEmpty ? double.tryParse(ship) ?? 0.0 : 0.0;
          }

          // Recompute cart totals when arriving directly from Home
          double computedTotal = 0.0;
          for (var i = 0; i < prodctlist1.length; i++) {
            computedTotal +=
                double.tryParse(prodctlist1[i].pprice ?? '0') ?? 0.0;
          }
          GroceryAppConstant.totalAmount = computedTotal;
          GroceryAppConstant.itemcount = prodctlist1.length;
          calcutateAmount = computedTotal;
          finalamount = computedTotal;
        });

        // After totals are in place, refresh delivery logic based on new total
        await _gefreedelivery();
      }
    });
    await mywallet(GroceryAppConstant.User_ID).then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            walletlist = usersFromServe;
            walletamt = walletlist[0].wallet;
            print("$walletamt----->wallet");
          });
        }
      }
    });

    await getUsableWAlletAmount();

    razorpay = Razorpay();
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
    _getInvoice1("ONLINE", "");
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

  // Add this variable to store the created order ID
  String? razorpayOrderId;

  // Method to create Razorpay order before payment
  Future<String?> createRazorpayOrder() async {
    print('=== Creating Razorpay Order ===');
    var map = Map<String, String>(); // Changed to String for form data

    // Calculate final amount
    double amount = checkBoxValue || discountval_flag
        ? (twltamount! - difference!)
        : finalamount!;

    print('Amount to be charged: $amount');

    map['amount'] =
        ((amount * 100).toInt()).toString(); // Amount in paise as string
    map['currency'] = 'INR';
    map['receipt'] = 'receipt_${DateTime.now().millisecondsSinceEpoch}';
    map['payment_capture'] = '1'; // Auto capture payment as string

    print('Request data: $map');

    try {
      String apiUrl =
          GroceryAppConstant.base_url + 'api/create_razorpay_order.php';
      print('API URL: $apiUrl');

      final response = await http.post(Uri.parse(apiUrl), body: map);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Parsed JSON Response: $jsonResponse');

        if (jsonResponse['success'] == true) {
          print('Order created successfully: ${jsonResponse['order_id']}');
          return jsonResponse['order_id'];
        } else {
          print('Order creation failed: ${jsonResponse['message']}');
          showLongToast('Failed to create order: ${jsonResponse['message']}');
          return null;
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        showLongToast('Failed to create order. Please try again.');
        return null;
      }
    } catch (e) {
      print('Exception in createRazorpayOrder: $e');
      showLongToast('Network error. Please try again.');
      return null;
    }
  }

  void openCheckout() async {
    // First create a Razorpay order
    showLoaderDialog(context);

    razorpayOrderId = await createRazorpayOrder();
    Navigator.of(context, rootNavigator: true).pop('dialog');

    if (razorpayOrderId == null) {
      showLongToast('Unable to create order. Please try again.');
      return;
    }

    // Now create payment options with the order ID
    var options = {
      'key': razorpay_key,
      'amount': checkBoxValue || discountval_flag
          ? (twltamount! - difference!) * 100.0
          : finalamount! * 100.0,
      "currency": "INR",
      'order_id': razorpayOrderId, // Use the created order ID for auto-capture
      'name': GroceryAppConstant.name,
      'description': prodctlist1![0].pname,
      'prefill': {'contact': mobile1, 'email': email1},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay?.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
      showLongToast('Payment initialization failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1E88E5), // Medical blue
              Color(0xff42A5F5), // Lighter medical blue
              Color(0xff64B5F6), // Lightest medical blue
            ],
          ),
        ),
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              floatingActionButtonAnimator:
                  FloatingActionButtonAnimator.scaling,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: GestureDetector(
                onTap: () {
                  if (textval == "Select Date" || textval1 == "Select Time") {
                    showLongToast("Please select date & time...");
                  } else {
                    if (twltamount! - difference! == 0.0 && checkBoxValue) {
                      setState(() {
                        loader = true;
                      });
                      _getInvoice1("WALLET", "");
                    } else {
                      paymentPopUp();
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1E88E5), // Medical blue
                        Color(0xff42A5F5), // Lighter medical blue
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('TOTAL',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 14)),
                            SizedBox(height: 2),
                            Text(
                              checkBoxValue || discountval_flag
                                  ? "\u{20B9}${(twltamount! - difference!).round()}"
                                  : "\u{20B9}${finalamount!.round()}",
                              style: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text('CONFIRM BOOKING',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              key: _scaffoldKey,
              appBar: AppBar(
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xff1E88E5), // Medical blue
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      color: Color(0xff1E88E5), // Medical blue
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                centerTitle: true,
              ),
              body: ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (BuildContext context, bool value, Widget? child) {
                  return isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 120, 15, 90),
                              child: Column(
                                children: <Widget>[
                                  selectedAddressSection(),
                                  SizedBox(height: 15),
                                  timeSlote(),
                                  SizedBox(height: 15),
                                  checkoutItem(),
                                  SizedBox(height: 15),
                                  priceSection(),

//                                 Expanded(
//                                   child: Container(
//                                     // color: Colors.red[50].withOpacity(.9),
//                                     child: Column(
//                                       children: <Widget>[
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               gradient: LinearGradient(
//                                                   begin: Alignment.bottomRight,
//                                                   colors: [
//                                                     Colors.red[50]!
//                                                         .withOpacity(.9),
//                                                     Colors.red[50]!
//                                                         .withOpacity(.9),
//                                                   ])),
//                                           width: double.infinity,
//                                           margin: EdgeInsets.only(
//                                             left: 18,
//                                             right: 18,
//                                           ),
//                                           child: Card(
//                                             elevation: 0.0,
//                                             child: Column(
//                                               mainAxisAlignment: codp == 'yes'
//                                                   ? MainAxisAlignment.start
//                                                   : MainAxisAlignment.center,
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: [
//                                                     Padding(
//                                                       padding:
//                                                           EdgeInsets.all(20),
//                                                       child: Text(
//                                                         "Total",
//                                                         style: CustomTextStyle
//                                                             .textFormFieldMedium
//                                                             .copyWith(
//                                                                 color:
//                                                                     Colors.grey,
//                                                                 fontSize: 18,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           EdgeInsets.all(20),
//                                                       child: Text(
//                                                         // "\u{20B9} ${twltamount.toStringAsFixed(2)}",
//                                                         checkBoxValue ||
//                                                                 discountval_flag
//                                                             ? "\u{20B9}${(twltamount! - difference!).round()}"
//                                                             : "\u{20B9}${finalamount!.round()}",
//                                                         style: CustomTextStyle
//                                                             .textFormFieldMedium
//                                                             .copyWith(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontSize: 18,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 loader
//                                                     ? Container(
//                                                         child: Center(
//                                                           child: CircularProgressIndicator(
//                                                               //color:
//                                                               // GroceryAppColors.tela1,
//                                                               ),
//                                                         ),
//                                                       )
//                                                     : Container(),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: <Widget>[
//                                                     // gateway == 'no'
//                                                     //     ? Container()
//                                                     //     :
//                                                     Expanded(
//                                                       child: Container(
//                                                         margin: EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             bottom: 10,
//                                                             top: 0),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             twltamount! - difference! ==
//                                                                         0.0 &&
//                                                                     checkBoxValue
//                                                                 ? Container(
//                                                                     child:
//                                                                         ElevatedButton(
//                                                                       style: ElevatedButton
//                                                                           .styleFrom(
//                                                                         backgroundColor:
//                                                                             GroceryAppColors.checkoup_paybuttoncolor,
//                                                                         shape: RoundedRectangleBorder(
//                                                                             borderRadius:
//                                                                                 BorderRadius.all(Radius.circular(24))),
//                                                                       ),
//                                                                       onPressed:
//                                                                           () {
//                                                                         setState(
//                                                                             () {
//                                                                           loader =
//                                                                               true;
//                                                                         });
//                                                                         _getInvoice1(
//                                                                             "WALLET");
//                                                                       },
//                                                                       child:
//                                                                           Text(
//                                                                         "Confirm",
//                                                                         style: CustomTextStyle.textFormFieldMedium.copyWith(
//                                                                             color: Colors
//                                                                                 .white,
//                                                                             fontSize:
//                                                                                 14,
//                                                                             fontWeight:
//                                                                                 FontWeight.bold),
//                                                                       ),
//                                                                     ),
//                                                                   )
//                                                                 : razorpay_key ==
//                                                                             null ||
//                                                                         razorpay_key ==
//                                                                             ""
//                                                                     ? SizedBox()
//                                                                     : Container(
//                                                                         child:
//                                                                             ElevatedButton(
//                                                                           style:
//                                                                               ElevatedButton.styleFrom(
//                                                                             backgroundColor:
//                                                                                 GroceryAppColors.checkoup_paybuttoncolor,
//                                                                             shape:
//                                                                                 RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
//                                                                           ),
//                                                                           onPressed:
//                                                                               () {
//                                                                             print("calculated amount----->$calcutateAmount");
//                                                                             print("final amount----->$calcutateAmount");
//                                                                             openCheckout();
//                                                                           },
//                                                                           child:
//                                                                               Text(
//                                                                             "Pay Online",
//                                                                             style: CustomTextStyle.textFormFieldMedium.copyWith(
//                                                                                 color: Colors.white,
//                                                                                 fontSize: 14,
//                                                                                 fontWeight: FontWeight.bold),
//                                                                           ),
//                                                                         ),
//                                                                       )
// //                                           Container(
// //                                             child: RaisedButton(
// //                                               onPressed: () {
// //                                                 // _getInvoice1("UPI/QRCODE");
// //                                                 showLoaderDialog(context);
// //
// //                                                 // _getInvoice1("COD");
// //                                                 openCheckout();
// //
// // //                      Navigator.push(context,
// // //                           MaterialPageRoute(builder: (context) => CheckOutPage()));
// //                                               },
// //                                               color: GroceryAppColors
// //                                                   .checkoup_paybuttoncolor,
// //                                               padding: EdgeInsets.only(
// //                                                   top: 12,
// //                                                   left: 12,
// //                                                   right: 12,
// //                                                   bottom: 12),
// //                                               shape: RoundedRectangleBorder(
// //                                                   borderRadius:
// //                                                   BorderRadius.all(
// //                                                       Radius.circular(
// //                                                           24))),
// //                                               child: Text(
// //                                                 "Pay Online",
// //                                                 style: CustomTextStyle
// //                                                     .textFormFieldMedium
// //                                                     .copyWith(
// //                                                     color:
// //                                                     Colors.white,
// //                                                     fontSize: 14,
// //                                                     fontWeight:
// //                                                     FontWeight
// //                                                         .bold),
// //                                               ),
// //                                             ),
// //                                           ),
//                                                             /*Container(
//                               child: RaisedButton(
//                                 onPressed: () {
//                                     _getInvoice1("THROUGH ACCOUNTS");
// //                      Navigator.push(context,
// //                           MaterialPageRoute(builder: (context) => CheckOutPage()));
//                                 },
//                                 color: GroceryAppColors.checkoup_paybuttoncolor,
// //                          padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
//                                 shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(Radius.circular(24))),
//                                 child: Text(
//                                     "THROUGH ACCOUNTS", style: CustomTextStyle.textFormFieldMedium.copyWith(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold),

//                                 ),
//                               ),
//                             ),*/
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     codp == 'yes'
//                                                         ? Expanded(
//                                                             child: Container(
//                                                               margin: EdgeInsets
//                                                                   .only(
//                                                                       left: 10,
//                                                                       right: 10,
//                                                                       bottom:
//                                                                           10,
//                                                                       top: 0),
//                                                               child:
//                                                                   ElevatedButton(
//                                                                 style: ElevatedButton
//                                                                     .styleFrom(
//                                                                   backgroundColor:
//                                                                       GroceryAppColors
//                                                                           .checkoup_paybuttoncolor,
//                                                                   padding: EdgeInsets.only(
//                                                                       top: 12,
//                                                                       left: 12,
//                                                                       right: 12,
//                                                                       bottom:
//                                                                           12),
//                                                                   shape: RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius.all(
//                                                                               Radius.circular(24))),
//                                                                 ),
//                                                                 onPressed: () {
//                                                                   showLongToast(
//                                                                       "don't press back until payment gets completed or else payment will get cancelled.");
//                                                                   showLoaderDialog(
//                                                                       context);
//                                                                   _getInvoice1(
//                                                                       "COD");
//                                                                   setState(() {
//                                                                     flag =
//                                                                         false;
//                                                                   });
// //                      Navigator.push(context,
// //                           MaterialPageRoute(builder: (context) => CheckOutPage()));
//                                                                 },
//                                                                 child: flag
//                                                                     ? Text(
//                                                                         "Cash on Delivery",
//                                                                         style: CustomTextStyle.textFormFieldMedium.copyWith(
//                                                                             color: Colors
//                                                                                 .white,
//                                                                             fontSize:
//                                                                                 14,
//                                                                             fontWeight:
//                                                                                 FontWeight.bold),
//                                                                       )
//                                                                     : Center(
//                                                                         child:
//                                                                             CircularProgressIndicator()),
//                                                               ),
//                                                             ),
//                                                           )
//                                                         : Row(),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   //  flex: 10,
//                                 )
                                ],
                              ),
                            ),
                            // flex: 30,
                          ),
                        );
                },
              )),
        ));
  }

  selectedAddressSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff42A5F5), // Primary orange
                      Color(0xff42A5F5), // Light orange
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Delivery Address",
                style: TextStyle(
                  color: Color(0xff42A5F5), // Primary orange
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          createAddressText("Name: $name1", 5),
          createAddressText(
              address1 != null
                  ? address1.toString() + " " + address2.toString()
                  : "address",
              6),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Mobile : ",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(fontSize: 14, color: Colors.grey.shade700)),
              TextSpan(
                  text: mobile1 != null ? mobile1 : '',
                  style: CustomTextStyle.textFormFieldBold
                      .copyWith(color: Colors.black, fontSize: 14)),
            ]),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Edit / Change",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff1E88E5), // Medical blue
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xff1E88E5)
                        .withOpacity(0.1), // Light medical blue background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Color(0xff1E88E5), // Medical blue
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    String formattedDate1 = DateFormat('dd/MM/yyyy ').format(DateTime.now());
    var now = DateTime.now();
    print(DateFormat('HH').format(now));
    dynamic currentTime = await DateFormat('HH').format(now);
    // dynamic currentTime = await DateFormat.jm().format(DateTime.now());
    String compair =
        currentTime.toString().substring(0, 2).replaceAll(":", "").trim();
    // print(compair);
    // print(formattedDate1);
    // print(compair);
    List<String> time;

    if (formattedDate1 == textval && int.parse(compair) >= 8) {
      log("hdjshfsjd----------------------------->>" + compair.toString());
      switch (int.parse(compair)) {
        case 6:
          time = [
            "06.00AM to 09.00AM",
            "09.00AM to 11.00AM",
            "11.00AM to 01.00PM",
            "01.00PM to 03.00PM",
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 7:
          time = [
            "09.00AM to 11.00AM",
            "11.00AM to 01.00PM",
            "01.00PM to 03.00PM",
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 8:
          time = [
            "09.00AM to 11.00AM",
            "11.00AM to 01.00PM",
            "01.00PM to 03.00PM",
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 9:
          time = [
            "11.00AM to 01.00PM",
            "01.00PM to 03.00PM",
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 10:
          time = [
            "11.00AM to 01.00PM",
            "01.00PM to 03.00PM",
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 11:
          time = [
            "01.00PM to 03.00PM",
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 12:
          time = [
            "01.00PM to 03.00PM",
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 13:
          time = [
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 14:
          time = [
            "03.00PM to 05.00PM",
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 15:
          time = [
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 16:
          time = [
            "05.00PM to 07.00PM",
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;
        case 17:
          time = [
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;

        case 18:
          time = [
            "07.00PM to 09.00PM",
            "09.00PM to 10.00PM",
          ];
          break;

        case 19:
          time = [
            "09.00PM to 10.00PM",
          ];
          break;

        case 20:
          time = [
            "09.00PM to 10.00PM",
          ];
          break;

        default:
          time = ["No time is available"];
          break;
      }
    } else {
      time = [
        "06.00AM to 09.00AM",
        "09.00AM to 11.00AM",
        "11.00AM to 01.00PM",
        "01.00PM to 03.00PM",
        "03.00PM to 05.00PM",
        "05.00PM to 07.00PM",
        "07.00PM to 09.00PM",
        "09.00PM to 10.00PM",
        // "7.00AM to 7.30AM",
        // "7.30AM to 8.00AM",
        // "8.00AM to 8.30AM",
        // "8.30AM to 9.00AM",
        // "9.00AM to 9.30AM",
        // "9.30AM to 10.00AM",
        // "10.00AM to 10.30AM",
        // "10.30AM to 11.00AM",
        // "11.00AM to 11.30AM",
        // "11.30AM to 12.00PM",
        // "12.00PM to 12.30PM",
        // "12.00PM to 01.00PM",
        // "01.00PM to 01.30PM",
        // "01.30PM to 02.00PM",
        // "02.00PM to 02.30PM",
        // "02.30PM to 03.00PM",
        // "03.00PM to 03.30PM",
        // "03.30PM to 04.00PM",
        // "04.00PM to 04.30PM",
        // "04.30PM to 05.00PM",
        // "05.00PM to 05.30PM",
        // "05.30PM to 06.00PM",
        // "06.00PM to 06.30PM",
        // "06.30PM to 07.00PM",
        // "07.00PM to 0.30PM",
        // "07.30PM to 08.00PM",
      ];
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select Time'),
            content: Container(
              width: double.maxFinite,
              height: time.length * 56.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: time.length == null ? 0 : time.length,
                  itemBuilder: (BuildContext context, int index) {
                    log(time.length.toString());
                    return Container(
                      width: time[index] != 0 ? 130.0 : 230.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            textval1 = time[index];
                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: Text(
                                    time[index],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: GroceryAppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: GroceryAppColors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  bool _decideWhichDayToEnable(DateTime day) {
    // Allow today and next 30 days
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(today.year, today.month, today.day);
    DateTime endDate = startDate.add(Duration(days: 30));

    return day.isAfter(startDate.subtract(Duration(days: 1))) &&
        day.isBefore(endDate.add(Duration(days: 1)));
  }

  showCalander() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      selectableDayPredicate: _decideWhichDayToEnable,
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          // Keep internal value in legacy format, UI uses ISO style
          textval = DateFormat('dd/MM/yyyy ').format(date);
          displayDate = DateFormat('yyyy-MM-dd').format(date);
          // Reset previously selected time if date changes
          selectedTimeSlot = null;
          textval1 = "Select Time";
        });
      }
    }).catchError((error) {
      print('Error selecting date: $error');
      showLongToast("Error selecting date. Please try again.");
    });
  }

  List<DateTime> _generateSlots(DateTime date) {
    final start = DateTime(date.year, date.month, date.day, 7, 0);
    return List.generate(13, (i) => start.add(Duration(hours: i)));
  }

  bool _isPastSlot(DateTime slot) {
    final now = DateTime.now();
    if (selectedDate == null) return false;
    final sameDay =
        slot.year == now.year && slot.month == now.month && slot.day == now.day;
    if (!sameDay) return false;
    // Disable slots strictly before current hour
    return slot.isBefore(DateTime(now.year, now.month, now.day, now.hour));
  }

  Widget _slotChip(DateTime slot) {
    final isSelected =
        selectedTimeSlot != null && slot.hour == selectedTimeSlot!.hour;
    final disabled = _isPastSlot(slot);
    final label = DateFormat('h:00 a').format(slot);
    Color bg;
    Color fg;
    if (disabled) {
      bg = Colors.grey.shade300;
      fg = Colors.grey.shade600;
    } else if (isSelected) {
      bg = const Color(0xff42A5F5); // Medical blue (selected)
      fg = Colors.white;
    } else {
      bg = const Color(0xffE3F2FD); // Light medical blue (available)
      fg = Colors.black87;
    }
    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              setState(() {
                selectedTimeSlot = slot;
                textval1 = DateFormat('h:00 a').format(slot);
              });
            },
      child: Container(
        width: 88,
        height: 40,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: disabled
                  ? Colors.grey.shade400
                  : Color(0xff1E88E5).withOpacity(0.5)),
        ),
        child: Text(label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // Grid cell version of the slot for a 4-column layout
  Widget _slotGridCell(DateTime slot) {
    final isSelected =
        selectedTimeSlot != null && slot.hour == selectedTimeSlot!.hour;
    final disabled = _isPastSlot(slot);
    final label = DateFormat('h:00 a').format(slot);
    Color bg;
    Color fg;
    if (disabled) {
      bg = Colors.grey.shade300;
      fg = Colors.grey.shade600;
    } else if (isSelected) {
      bg = const Color(0xff42A5F5); // Medical blue
      fg = Colors.white;
    } else {
      bg = const Color(0xffE3F2FD); // Light medical blue
      fg = Colors.black87;
    }
    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              setState(() {
                selectedTimeSlot = slot;
                textval1 = DateFormat('h:00 a').format(slot);
              });
            },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: disabled
                  ? Colors.grey.shade400
                  : Color(0xff1E88E5).withOpacity(0.5)),
        ),
        child: Text(label,
            style: TextStyle(
                color: fg, fontWeight: FontWeight.w600, fontSize: 12)),
      ),
    );
  }

  String _selectedDurationText() {
    if (selectedTimeSlot == null) return '';
    final end = selectedTimeSlot!.add(Duration(hours: serviceDurationHours));
    return 'Service Duration: ${DateFormat('h:00 a').format(selectedTimeSlot!)} to ${DateFormat('h:00 a').format(end)} ($serviceDurationHours hours)';
  }

  timeSlote() {
    final hasDate = selectedDate != null;
    final slots = hasDate ? _generateSlots(selectedDate!) : <DateTime>[];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1E88E5), // Medical blue
                      Color(0xff42A5F5), // Lighter medical blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Schedule Service",
                style: TextStyle(
                  color: Color(0xff1E88E5), // Medical blue
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Date selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xff1E88E5), // Medical blue
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Select Date *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xff1E88E5), // Medical blue
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: showCalander,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff1E88E5), // Medical blue
                              Color(0xff42A5F5), // Lighter medical blue
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        displayDate,
                        style: TextStyle(
                          fontSize: 16,
                          color: displayDate == "Select Date"
                              ? Colors.grey[500]
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Time title
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Color(0xff1E88E5), // Medical blue
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Select Time Slot *',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff1E88E5), // Medical blue
                ),
              ),
            ],
          ),
          SizedBox(height: 9),

          // Duration on next line after selection
          if (selectedTimeSlot != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xff1E88E5).withOpacity(0.1), // Medical blue
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: Color(0xff1E88E5), // Medical blue
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedDurationText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff1E88E5), // Medical blue
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (selectedTimeSlot != null) SizedBox(height: 12),

          // Slots grid
          hasDate
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: slots.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.4,
                  ),
                  itemBuilder: (context, index) => _slotGridCell(slots[index]),
                )
              : Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    'Please select a date first',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
        ],
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
            child: Text("Add  Address",
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
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1E88E5), // Medical blue
                      Color(0xff42A5F5), // Lighter medical blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medical_services_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Service Items",
                style: TextStyle(
                  color: Color(0xff1E88E5), // Medical blue
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xff1E88E5).withOpacity(0.1), // Medical blue
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${prodctlist1.length} ${prodctlist1.length == 1 ? 'item' : 'items'}",
                  style: TextStyle(
                    color: Color(0xff1E88E5), // Medical blue
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[200],
                height: 20,
              );
            },
            itemBuilder: (context, position) {
              return checkoutListItem(position);
            },
            itemCount: prodctlist1.length > 0 ? prodctlist1.length : 0,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }

  checkoutListItem(int position) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Color(0xff1E88E5).withOpacity(0.1), // Medical blue
                  Color(0xff42A5F5).withOpacity(0.1), // Lighter medical blue
                ],
              ),
              image: prodctlist1.isNotEmpty
                  ? (prodctlist1[position].pimage != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            GroceryAppConstant.Product_Imageurl +
                                (prodctlist1[position].pimage ?? ''),
                          ),
                        )
                      : null)
                  : null,
            ),
            child: prodctlist1[position].pimage == null
                ? Icon(
                    Icons.local_hospital_outlined,
                    color: Color(0xff1E88E5), // Medical blue
                    size: 30,
                  )
                : null,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  prodctlist1[position].pname == null
                      ? ''
                      : prodctlist1[position].pname ?? "",
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                if (prodctlist1[position].pQuantity != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xff1E88E5).withOpacity(0.1), // Medical blue
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Quantity: ${prodctlist1[position].pQuantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1E88E5), // Medical blue
                        fontSize: 12,
                      ),
                    ),
                  ),
                SizedBox(height: 4),
                if (prodctlist1[position].varient != null)
                  Text(
                    'Variant: ${prodctlist1[position].varient}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                SizedBox(height: 4),
                if (prodctlist1[position].shipping != null &&
                    prodctlist1[position].shipping!.length > 0)
                  Text(
                    'Shipping: \u{20B9} ${prodctlist1[position].shipping}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff42A5F5),
                        Color(0xff42A5F5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prodctlist1[position].pprice == null
                        ? '00.0'
                        : '\u{20B9} ${double.parse(prodctlist1[position].pprice ?? "0").toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  priceSection() {
    return Column(
      children: [
        // Success message for coupon
        if (hideApplyButton)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff42A5F5),
                  Color(0xff42A5F5),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Congratulations! You saved \u{20B9}${difference!.toStringAsFixed(1)} on this order.",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          // Coupon section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff42A5F5),
                        Color(0xff42A5F5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.discount_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: coupanController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: "Enter coupon code",
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CouponCodes(),
                          ));
                        },
                        child: Text(
                          'View Available Coupons',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff42A5F5),
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10),
                applyButtonLoader
                    ? Container(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF1B5E20)),
                          strokeWidth: 2,
                        ),
                      )
                    : Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff42A5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            "Apply",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              applyButtonLoader = true;
                            });
                            _applycoupancode("1");
                          },
                        ),
                      ),
              ],
            ),
          ),

        SizedBox(height: 15),

        // Wallet section
        if (walletamt != "0" && double.parse(usableWAlletAmount ?? "") != 0)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    checkboxTheme: CheckboxThemeData(
                      fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Color(0xff42A5F5);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  child: Checkbox(
                    activeColor: Color(0xff42A5F5),
                    value: checkBoxValue,
                    onChanged: (Value) {
                      setState(() {
                        checkBoxValue = Value!;
                        if (Value) {
                          print("count------->$count");
                          if (double.parse(usableWAlletAmount!) >
                              finalamount!) {
                            print("first");
                            print(walletamt);
                            print(twltamount);
                            twltamount = finalamount;
                            wltamount = double.parse(walletamt!);
                            twltamt = wltamount! - twltamount!;
                            wltamount = finalamount! - double.parse(walletamt!);
                            print("yhaan");
                            print(wltamount);
                            twltamount = 0;
                          } else {
                            print("second");
                            twltamount = finalamount;
                            wltamount = wltamount;
                            twltamount =
                                twltamount! - int.parse(usableWAlletAmount!);
                            twltamt = 0;
                          }
                        } else {
                          print("third");
                          twltamount = finalamount;
                          wltamount = double.parse(usableWAlletAmount!);
                          twltamt = wltamount;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff42A5F5),
                        Color(0xff42A5F5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pay using Wallet",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Wallet Points: ${walletamt != null ? walletamt : "0"}",
                        style: TextStyle(
                          color: Color(0xff42A5F5),
                          fontSize: 12,
                        ),
                      ),
                      if (double.parse(walletamt!) >
                          double.parse(usableWAlletAmount!))
                        Text(
                          "You can use $usableWAlletAmount points from your wallet",
                          style: TextStyle(
                            color: Color(0xff42A5F5),
                            fontSize: 12,
                          ),
                        ),
                      if (double.parse(walletamt!) <
                          double.parse(usableWAlletAmount!))
                        Text(
                          "You can use \u{20B9}$walletamt from your wallet",
                          style: TextStyle(
                            color: Color(0xff42A5F5),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        SizedBox(height: 15),

        // Price details
        detailsPrice(),

        SizedBox(height: 15),

        // Order notes
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff42A5F5),
                          Color(0xff42A5F5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.note_add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Order Notes",
                    style: TextStyle(
                      color: Color(0xff42A5F5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  controller: resignofcause,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add special instructions for your service...',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff42A5F5),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailsPrice() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff42A5F5),
                      Color(0xff42A5F5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "PRICE DETAILS",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff42A5F5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildPriceRow(
              "Total MRP",
              "\u{20B9} ${(calcutateAmount)!.toStringAsFixed(2)}",
              Colors.black87),
          _buildDivider(),
          _buildPriceRow(
              "Total Item", "${GroceryAppConstant.itemcount}", Colors.black87),
          if (difference! > 1) _buildDivider(),
          if (difference! > 1)
            _buildPriceRow(
                "Coupon Discount",
                "-\u{20B9}${difference!.toStringAsFixed(2)}",
                Color(0xff42A5F5)),
          _buildDivider(),
          _buildPriceRow(
              "Delivery Charges (+)", "\u{20B9}${deliveryfee}", Colors.black87),
          if (checkBoxValue &&
              (double.parse(usableWAlletAmount!) < finalamount!))
            _buildDivider(),
          if (checkBoxValue &&
              (double.parse(usableWAlletAmount!) < finalamount!))
            _buildPriceRow(
                "Wallet Points (-)",
                "-\u{20B9}${double.parse(usableWAlletAmount!)}",
                Color(0xff42A5F5)),
          if (checkBoxValue &&
              (double.parse(usableWAlletAmount!) > finalamount!))
            _buildDivider(),
          if (checkBoxValue &&
              (double.parse(usableWAlletAmount!) > finalamount!))
            _buildPriceRow("Wallet Amount (-)", "-\u{20B9}$finalamount",
                Color(0xff42A5F5)),
          if (checkBoxValue &&
              (double.parse(usableWAlletAmount!) == finalamount))
            _buildDivider(),
          if (checkBoxValue &&
              (double.parse(usableWAlletAmount!) == finalamount))
            _buildPriceRow("Wallet Amount (-)", "-\u{20B9}$finalamount",
                Color(0xff42A5F5)),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: 2,
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff42A5F5),
                  Color(0xff42A5F5),
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff42A5F5).withOpacity(0.1),
                  Color(0xff42A5F5).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff42A5F5),
                  ),
                ),
                Text(
                  checkBoxValue || discountval_flag
                      ? "\u{20B9}${(twltamount! - difference!).round()}"
                      : "\u{20B9}${finalamount!.round()}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff42A5F5),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 20,
    );
  }

  Widget disblePayment(text, image) {
    return ListTile(
      leading: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
            //color: Colors.green,
            image: DecorationImage(image: AssetImage(image))),
      ),
      trailing: Radio(
        value: 'cod',
        groupValue: 'order',
        onChanged: (value) {
          showLongToast('Not available');
        },
      ),
      title: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
    );
  }

  // paymentPopUp() async {
  //   return await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         child: SizedBox(
  //           height: 350,
  //           child: Stack(
  //             children: [
  //               Column(
  //                 children: [
  //                   codp == 'yes'
  //                       ? ListTile(
  //                           leading: Container(
  //                             width: 60,
  //                             height: 50,
  //                             decoration: BoxDecoration(
  //                                 //color: Colors.green,
  //                                 image: DecorationImage(
  //                                     image:
  //                                         AssetImage('assets/images/cod.png'))),
  //                           ),
  //                           trailing: Theme(
  //                             data: Theme.of(context).copyWith(
  //                                 unselectedWidgetColor: Colors.black,
  //                                 disabledColor: Colors.blue),
  //                             child: Radio(
  //                               activeColor: GroceryAppColors.black,
  //                               fillColor: MaterialStateColor.resolveWith(
  //                                   (states) => Colors.blue),
  //                               value: 'cod',
  //                               groupValue: selectedPayment,
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   selectedPayment = value.toString();
  //                                   log('selectedPayment   ' +
  //                                       selectedPayment.toString());
  //                                   Navigator.pop(context);
  //                                   paymentPopUp();
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                           title: Text('CASH ON DELIVERY',
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: GroceryAppColors.black,
  //                                   fontSize: 12)),
  //                         )
  //                       : disblePayment(
  //                           'CASH ON DELIVERY', 'assets/images/cod.png'),
  //                   razorpay_key == null || razorpay_key == ""
  //                       ? disblePayment('Card / Net Banking / UPI',
  //                           'assets/images/razorpay.png')
  //                       : ListTile(
  //                           leading: Container(
  //                             width: 60,
  //                             height: 50,
  //                             decoration: BoxDecoration(
  //                                 //color: Colors.green,
  //                                 image: DecorationImage(
  //                                     image: AssetImage(
  //                                         'assets/images/razorpay.png'))),
  //                           ),
  //                           trailing: Radio(
  //                             activeColor: GroceryAppColors.black,
  //                             fillColor: MaterialStateColor.resolveWith(
  //                                 (states) => Colors.blue),
  //                             value: 'razorpay',
  //                             groupValue: selectedPayment,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 selectedPayment = value.toString();
  //                                 log('selectedPayment   ' +
  //                                     selectedPayment.toString());
  //                                 Navigator.pop(context);
  //                                 paymentPopUp();
  //                               });
  //                             },
  //                           ),
  //                           title: Text('Card / Net Banking / UPI',
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: GroceryAppColors.black,
  //                                   fontSize: 12)),
  //                         ),
  //                   instaMojoOn == null ||
  //                           instaMojoOn == "off" ||
  //                           instaMojoOn.toString().isEmpty
  //                       ? disblePayment(
  //                           'INSTAMOJO', 'assets/images/instamojo.png')
  //                       : ListTile(
  //                           leading: Container(
  //                             width: 60,
  //                             height: 50,
  //                             decoration: BoxDecoration(
  //                                 //color: Colors.green,
  //                                 image: DecorationImage(
  //                                     image: AssetImage(
  //                                         'assets/images/instamojo.png'))),
  //                           ),
  //                           trailing: Radio(
  //                             activeColor: GroceryAppColors.black,
  //                             fillColor: MaterialStateColor.resolveWith(
  //                                 (states) => Colors.blue),
  //                             value: 'instamojo',
  //                             groupValue: selectedPayment,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 selectedPayment = value.toString();
  //                                 log('selectedPayment   ' +
  //                                     selectedPayment.toString());
  //                                 Navigator.pop(context);
  //                                 paymentPopUp();
  //                               });
  //                             },
  //                           ),
  //                           title: Text('INSTAMOJO',
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: GroceryAppColors.black,
  //                                   fontSize: 12)),
  //                         ),
  //                 ],
  //               ),
  //               flag
  //                   ? Align(
  //                       alignment: Alignment.bottomCenter,
  //                       //bottom: 5,
  //                       child: ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                               backgroundColor: Colors.green),
  //                           onPressed: () {
  //                             if (selectedPayment == 'cod') {
  //                               showLongToast(
  //                                   "don't press back until payment gets completed or else payment will get cancelled.");
  //                               showLoaderDialog(context);
  //                               _getInvoice1("COD");
  //                               setState(() {
  //                                 flag = false;
  //                               });
  //                             } else if (selectedPayment == 'razorpay') {
  //                               print(
  //                                   "calculated amount----->$calcutateAmount");
  //                               print("final amount----->$calcutateAmount");
  //                               openCheckout();
  //                             } else if (selectedPayment == 'instamojo') {
  //                               showLongToast(
  //                                   " ⚠ Don't Close App Or Press Back Button Until Payment Success Or Failure....... ");
  //                               _getInvoiceinstamojo("ONLINE");
  //                             }
  //                             Navigator.pop(context);
  //                           },
  //                           child: Text('Confirm',
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: GroceryAppColors.white,
  //                                   fontSize: 16))),
  //                     )
  //                   : Center(child: CircularProgressIndicator()),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  paymentPopUp() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 245,
            child: Stack(
              children: [
                Column(
                  children: [
                    codp == 'yes'
                        ? ListTile(
                            leading: Container(
                              width: 60,
                              height: 50,
                              decoration: BoxDecoration(
                                  //color: Colors.green,
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/cod.png'))),
                            ),
                            trailing: Theme(
                              data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.black,
                                  disabledColor: Colors.blue),
                              child: Radio(
                                activeColor: FoodAppColors.black,
                                fillColor: WidgetStateColor.resolveWith(
                                    (states) => Colors.blue),
                                value: 'cod',
                                groupValue: selectedPayment,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPayment = value.toString();
                                    log('selectedPayment   ' +
                                        selectedPayment.toString());
                                    Navigator.pop(context);
                                    paymentPopUp();
                                  });
                                },
                              ),
                            ),
                            title: Text('CASH ON DELIVERY',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: FoodAppColors.black,
                                    fontSize: 12)),
                          )
                        : ListTile(),
                    razorpay_key == null || razorpay_key == ""
                        ? disblePayment('Card / Net Banking / UPI',
                            'assets/images/razorpay.png')
                        : ListTile(
                            leading: Container(
                              width: 60,
                              height: 50,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/razorpay.png'))),
                            ),
                            trailing: Radio(
                              activeColor: FoodAppColors.black,
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.blue),
                              value: 'razorpay',
                              groupValue: selectedPayment,
                              onChanged: (value) {
                                setState(() {
                                  selectedPayment = value.toString();
                                  log('selectedPayment   ' +
                                      selectedPayment.toString());
                                  Navigator.pop(context);
                                  paymentPopUp();
                                });
                              },
                            ),
                            title: Text('Card / Net Banking / UPI',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: FoodAppColors.black,
                                    fontSize: 12)),
                          ),
                    // PhonePe option hidden for now. Keep commented for future use.
                    // disblePayment('PHONEPAY', 'assets/images/phone_pay.png'),
                  ],
                ),
                flag
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        //bottom: 5,
                        child: Consumer<PhonepePaymentController>(builder:
                            (context, PhonepePaymentController snapshot, _) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                //  Navigator.pop(context);
                                if (selectedPayment == 'cod') {
                                  if (textval == "Select Date" ||
                                      textval1 == "Select Time") {
                                    showLongToast(
                                        "Please select date & time...");
                                    Navigator.pop(context);
                                    return;
                                  }
                                  showLongToast(
                                      "don't press back until payment gets completed or else payment will get cancelled.");
                                  showLoaderDialog(context);
                                  _getInvoice1("COD", "");
                                  setState(() {
                                    flag = false;
                                  });
                                  Navigator.pop(context);
                                } else if (selectedPayment == 'razorpay') {
                                  print(
                                      "calculated amount----->$calcutateAmount");
                                  print("final amount----->$calcutateAmount");
                                  openCheckout();
                                  Navigator.pop(context);
                                } else if (selectedPayment == 'instamojo') {
                                  showLongToast(
                                      " ⚠ Don't Close App Or Press Back Button Until Payment Success Or Failure....... ");
                                  _getInvoiceinstamojo("ONLINE");
                                }
                                // else if (selectedPayment == 'phonepay') {
                                //   showLongToast(
                                //       " ⚠ Don't Close App Or Press Back Button Until Payment Success Or Failure....... ");
                                //   snapshot
                                //       .initiatePhonePeTransaction(
                                //           amount: finalamount.toString())
                                //       .then((value) {
                                //     log("before condition");
                                //     if (value &&
                                //         snapshot.payUrl != '' &&
                                //         snapshot.merchantTransactionId != 0) {
                                //       log("after condition");
                                //       final email = GroceryAppConstant.email
                                //                   .contains("@gmai.com") ||
                                //               GroceryAppConstant.email
                                //                   .contains("@")
                                //           ? GroceryAppConstant.email
                                //           : 'support@tidyhome.biz';
                                //       Navigator.push(context,
                                //           MaterialPageRoute(builder: (context) {
                                //         return PhonepePaymentScreen(
                                //           paymentType: 'checkout',
                                //           paymentUrl: snapshot.payUrl,
                                //           amount: finalamount.toString(),
                                //           merchantTransactionId:
                                //               snapshot.merchantTransactionId!,
                                //           finalamt: finalamount.toString(),
                                //           usedWalletamt:
                                //               usableWAlletAmount.toString(),
                                //           username: user_name ?? '',
                                //           checkbox: checkBoxValue,
                                //           address: address1 ?? "",
                                //           city: city1 ?? "",
                                //           coupancode: coupancode ?? "",
                                //           deliveryfee: deliveryfee.toString(),
                                //           difference: difference.toString(),
                                //           onedayprice: Onedayprice.toString(),
                                //           pincode: pin1 ?? "",
                                //           prodctlist1: prodctlist1,
                                //           email: email,
                                //           mobile: GroceryAppConstant.username,
                                //           name: GroceryAppConstant.name,
                                //           shipping: deliveryfee.toString(),
                                //           mv: prodctlist1[0].mv.toString(),
                                //           lat: widget.address.lat.toString(),
                                //           long: widget.address.lng.toString(),
                                //           coupoun: coupancode != null
                                //               ? coupancode ?? ""
                                //               : "",
                                //           coupoun_amount: difference.toString(),
                                //           fast_price: Onedayprice != null
                                //               ? Onedayprice.toString()
                                //               : "0.0",
                                //         );
                                //       }));
                                //     } else {
                                //       showLongToast('Payment request failed');
                                //     }
                                //   });
                                // }
                                //Navigator.pop(context);
                              },
                              child: Text('Confirm',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: FoodAppColors.white,
                                      fontSize: 16)));
                        }),
                      )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
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

  Future _getInvoiceinstamojo(
    String paymode,
  ) async {
    print('called data oredr first');
    var map = Map<String, dynamic>();
    map['name'] = name1;
    map['mobile'] = user_name ?? '';
    map['email'] = email1 ?? '';
    map['address'] = address1 ?? '';
    map['pincode'] = pin1 ?? '123456';
    map['city'] = city1 ?? '';
    map['invoice_total'] = finalamount.toString();
    map['notes'] = "no notes";
    map['shop_id'] = GroceryAppConstant.Shop_id.toString();
    map['PayMode'] = paymode;
    map['user_id'] = GroceryAppConstant.user_id;
    map['shipping'] = deliveryfee;
    map['mv'] = prodctlist1[0].mv.toString();
    map['lat'] = widget.address.lat.toString();
    map['lng'] = widget.address.lng.toString();
    map['coupon'] = coupancode != null ? coupancode : "";
    map['couponAmount'] = difference.toString();
    map['fast_price'] = Onedayprice != null ? Onedayprice.toString() : "0.0";
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
        final email = GroceryAppConstant.email.contains("@gmai.com") ||
                GroceryAppConstant.email.contains("@")
            ? GroceryAppConstant.email
            : 'support@tidyhome.biz';

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InstaMojoPaymentWebViewFood(
              address: address1 ?? "",
              city: city1 ?? "",
              coupancode: coupancode ?? "",
              deliveryfee: deliveryfee,
              difference: difference.toString(),
              onedayprice: Onedayprice.toString(),
              pincode: pin1 ?? "",
              prodctlist1: prodctlist1,
              url: GroceryAppConstant.base_url + "im_pay_app.php",
              amount: finalamount.toString(),
              email: email,
              mobile: GroceryAppConstant.username,
              name: GroceryAppConstant.name,
              invoice: user.Invoice ?? '',
            ),
          ),
        );

        // _uploadProductsInstamojo(
        //   user.Invoice ?? "",
        //   paymode,
        // );
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

  Future _getwalletActive() async {
    var map = Map<String, dynamic>();
    map['username'] = user_name;
    map['shop_id'] = GroceryAppConstant.Shop_id.toString();

    print(GroceryAppConstant.base_url + 'api/user_active_order.php');
    print(map.toString());

    final response = await http.post(
        Uri.parse(
          GroceryAppConstant.base_url + 'api/user_active_order.php',
        ),
        body: map);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      // Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
      // print("123"+user.Invoice);
      if (jsonBody["success"] == "true") {
        if (jsonBody["orders"] == "0") {
          setState(() {
            flag1 = true;
            if (double.parse(walletamt!) > finalamount!) {
              twltamount = finalamount;
              wltamount = double.parse(walletamt!);
              twltamt = wltamount! - twltamount!;
              wltamount = finalamount;
              twltamount = 0;
            } else {
              twltamount = finalamount;
              wltamount = double.parse(walletamt!);
              twltamount = twltamount! - wltamount!;
              twltamt = 0;
            }
            twltamount = finalamount;
            wltamount = double.parse(walletamt!);
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

  Future _getInvoice1(String paymode, String payId) async {
    var map = new Map<String, dynamic>();
    map['name'] = name1;
    map['mobile'] = user_name;
    map['email'] = email1;
    map['address'] = address1;
    map['pincode'] = pin1;
    map['city'] = city1;
    map['invoice_total'] = (calcutateAmount! - difference!).toString();
    map['notes'] = "";
    map['shop_id'] = GroceryAppConstant.Shop_id.toString();
    map['PayMode'] = paymode;
    map['user_id'] = "user_id";
    map['shipping'] = deliveryfee;
    map['mv'] = prodctlist1[0].mv.toString();
    map['lat'] = GroceryAppConstant.latitude.toString();
    map['lng'] = GroceryAppConstant.longitude.toString();
    map['coupon'] = coupancode != null ? coupancode : "";
    map['couponAmount'] = difference.toString();
    // Ensure date and time are sent in invoice header as well
    if (textval == "Select Date" || textval.toString().isEmpty) {
      map['adate'] = '';
    } else {
      map['adate'] = (Jiffy.parse(textval, pattern: "dd/MM/yyyy")
              .format(pattern: "yyyy-MM-dd"))
          .toString();
    }
    if (textval1 == "Select Time" || textval1.isEmpty) {
      map['atime'] = '';
    } else {
      map['atime'] = textval1;
    }

    print(map.toString());
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
        body: map);

    if (response.statusCode == 200) {
//      final jsonBody = json.decode(response.body);
      Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
      // print("123"+user.Invoice);
      if (user.success.toString() == "true") {
        print("12345" + user.Invoice!);

        _uploadProducts(user.Invoice!, paymode, payId);
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
// String invoicemenual;
//   Future _getInvoice1(String paymode) async {
//     var map = Map<String, dynamic>();
//     map['name'] = name1;
//     map['mobile'] = user_name;
//     map['email'] = email1;
//     map['address'] = address1;
//     map['pincode'] = pin1;
//     map['city'] = city1;
//     map['invoice_total'] = (calcutateAmount! - difference!).toString();
//     map['notes'] = resignofcause.text != null ? resignofcause.text : "";
//     map['shop_id'] = GroceryAppConstant.Shop_id.toString();
//     map['PayMode'] = paymode;
//     map['user_id'] = "user_id";
//     map['shipping'] = deliveryfee;
//     map['mv'] = prodctlist1[0].mv.toString();
//     map['lat'] = widget.address.lat.toString();
//     map['lng'] = widget.address.lng.toString();
//     map['coupon'] = coupancode != null ? coupancode : "";
//     map['couponAmount'] = difference.toString();

//     print(map.toString());
//     final response = await http.post(
//         Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
//         body: map);

//     if (response.statusCode == 200) {
// //      final jsonBody = json.decode(response.body);
//       Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
//       // print("123"+user.Invoice);
//       if (user.success.toString() == "true") {
//         print("12345" + user.Invoice.toString());

//         _uploadProducts(user.Invoice.toString(), paymode);
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

  showLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
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

//   Future _uploadProducts(String invoice, String paytype) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     // int pmv= prodctlist1[0].mv;
//     //
//     // print("Pmv12   "+pmv.toString()+ "   "+prodctlist1.length.toString());
//     for (int i = 0; i < prodctlist1.length; i++) {
//       /*     if(pmv==prodctlist1[i].mv) {
//         setState(() {
//           pmv=prodctlist1[i].mv;

//           print("Pmv"+pmv.toString());
//         });*/

//       // print("WishlistState.prodctlist1[i].pimage");
//       // print(WishlistState.prodctlist1[i].pimage);

//       var map = Map<String, dynamic>();
//       // print(invoice);
//       // print(WishlistState.prodctlist1[i].pid);
//       // print(WishlistState.prodctlist1[i].pname);
//       // print(WishlistState.prodctlist1[i].pQuantity);
//       // print(WishlistState.prodctlist1[i].costPrice);
//       // print(WishlistState.prodctlist1[i].discount);
//       // print(WishlistState.prodctlist1[i].discountValue);
//       // print(WishlistState.prodctlist1[i].adminper);
//       // print(WishlistState.prodctlist1[i].adminpricevalue);
//       // print(WishlistState.prodctlist1[i].cgst);
//       // print(WishlistState.prodctlist1[i].sgst);
//       // print(WishlistState.prodctlist1[i].pcolor);
//       // print(WishlistState.prodctlist1[i].pimage);

//       map['invoice_id'] = invoice;
//       map['product_id'] = prodctlist1[i].pid;
//       map['product_name'] = prodctlist1[i].pname;
//       map['quantity'] = prodctlist1[i].pQuantity.toString();
//       map['price'] = (int.parse(prodctlist1[i].costPrice.toString()) *
//               prodctlist1[i].pQuantity!)
//           .toString();
//       map['user_per'] = prodctlist1[i].discount;
//       map['user_dis'] = (double.parse(prodctlist1[i].discountValue ?? "") *
//               prodctlist1[i].pQuantity!)
//           .toStringAsFixed(2)
//           .toString();
//       map['admin_per'] = prodctlist1[i].adminper;
//       map['admin_dis'] = prodctlist1[i].adminpricevalue;
//       map['shop_id'] = GroceryAppConstant.Shop_id;
//       map['cgst'] = prodctlist1[i].cgst;
//       map['sgst'] = prodctlist1[i].sgst;
//       map['variant'] = prodctlist1[i].varient == null
//           ? " "
//           : WishlistState.prodctlist1![i].varient;
//       map['color'] =
//           prodctlist1[i].pcolor == null || prodctlist1[i].pcolor!.isEmpty
//               ? ""
//               : prodctlist1[i].pcolor;
//       map['size'] =
//           prodctlist1[i].psize == null || prodctlist1[i].psize!.isEmpty
//               ? ""
//               : prodctlist1[i].psize;
//       map['refid'] = "0";
//       map['image'] = prodctlist1[i].pimage;
//       map['prime'] = "0";
//       map['mv'] = prodctlist1[i].mv.toString();
//       map['adate'] = textval == "Select Date" || textval.isEmpty
//           ? ''
//           : (Jiffy(textval, "dd/MM/yyyy").format("yyyy-MM-dd")).toString();
//       map['atime'] =
//           textval1 == "Select Time" || textval1.isEmpty ? '' : textval1;
//       final response = await http.post(
//           Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
//           body: map);

//       try {
//         ;
//         log(map.toString());
//         if (response.statusCode == 200) {
// //        final jsonBody = json.decode(response.body);
//           ProductAdded1 user =
//               ProductAdded1.fromJson(jsonDecode(response.body));
//           //-------------//

//           setState(() {
//             AppConstent.cc = 0;

//             pref.setInt("cc", AppConstent.cc);
//           });

//           //-----------------//
//           setState(() {
//             if (user.success.toString() == "true" &&
//                 i == (prodctlist1.length - 1) &&
//                 paytype == 'ONLINE') {
//               showLongToast(' Your order is successfull');
//               dbmanager.deleteallProducts();
//               GroceryAppConstant.itemcount = 0;
//               GroceryAppConstant.groceryAppCartItemCount = 0;
//               groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
//               pre!.setString("mvid", "");
//               _afterPayment(orderid ?? "", signature ?? "", paymentId ?? "");
//               //-------------//

//               setState(() {
//                 AppConstent.cc = 0;

//                 pref.setInt("cc", AppConstent.cc);
//               });

//               //-----------------//
//               // openCheckout();

//               // Navigator.push(context,
//               //   MaterialPageRoute(builder: (context) => ShowInVoiceId(user.Invoice)),);
//             } else if (user.success.toString() == "true" &&
//                 i == (prodctlist1.length - 1) &&
//                 paytype == 'COD') {
//               showLongToast(' Your  order is  sucessfull');
//               dbmanager.deleteallProducts();
//               GroceryAppConstant.itemcount = 0;
//               GroceryAppConstant.groceryAppCartItemCount = 0;
//               groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
//               pre!.setString("mvid", "");
//               //-------------//

//               setState(() {
//                 AppConstent.cc = 0;

//                 pref.setInt("cc", AppConstent.cc);
//               });

//               //-----------------//

//               if (checkBoxValue) {
//                 log("wtam--------->>  $finalamount");
//                 log("wtam--------->>  $usableWAlletAmount");
//                 if (finalamount! <= double.parse(usableWAlletAmount ?? "")) {
//                   walletPurchase2(finalamount.toString());
//                 } else {
//                   walletPurchase2(usableWAlletAmount.toString());
//                 }
//               }
//               if (checkBoxValue == false) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ShowInVoiceId(user.Invoice ?? "")),
//                 );
//               }
//             } else if (user.success.toString() == "true" &&
//                 i == (prodctlist1.length - 1) &&
//                 paytype == 'WALLET') {
//               dbmanager.deleteallProducts();
//               GroceryAppConstant.itemcount = 0;
//               GroceryAppConstant.groceryAppCartItemCount = 0;
//               groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
//               pre!.setString("mvid", "");

//               //-------------//

//               setState(() {
//                 AppConstent.cc = 0;

//                 pref.setInt("cc", AppConstent.cc);
//               });

//               //-----------------//
//               walletPurchase();
//             } else if (user.success.toString() == "true" &&
//                 i == (prodctlist1.length - 1) &&
//                 paytype == 'UPI/QRCODE') {
//               showLongToast(' Your order is successfull');
//               dbmanager.deleteallProducts();
//               GroceryAppConstant.itemcount = 0;
//               GroceryAppConstant.itemcount = 0;
//               GroceryAppConstant.itemcount = 0;
//               pre!.setString("mvid", "");

//               //-------------//

//               setState(() {
//                 AppConstent.cc = 0;

//                 pref.setInt("cc", AppConstent.cc);
//               });

//               //-----------------//

//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ShowInVoiceId1(user.Invoice ?? "")),
//               );
//             } else if (user.success.toString() == "true" &&
//                 i == (prodctlist1.length - 1) &&
//                 paytype == 'THROUGH ACCOUNTS') {
//               showLongToast(' Your order is successfull');
//               dbmanager.deleteallProducts();
//               GroceryAppConstant.itemcount = 0;
//               GroceryAppConstant.itemcount = 0;
//               pre!.setString("mvid", "");

//               //-------------//

//               setState(() {
//                 AppConstent.cc = 0;

//                 pref.setInt("cc", AppConstent.cc);
//               });

//               //-----------------//

// //          openCheckout();
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //       builder: (context) => ShowInVoiceId2(user.Invoice ?? "")),
//               // );
//             } else {
//               // showLongToast(' Somting went wrong');
//             }
//           });
//         }
//       } catch (Exception) {
//         //throw Exception("Unable to uplod product detail");
//       }
//       // }

//       /*  else{
//         setState(() {

//           pmv=prodctlist1[i].mv;

//           // print(' set state after if ${pmv}'+i.toString());
//         });
//           int p;
//         for( p=0;p<i;p++){
//           setState(() {
//             prodctlist1.removeAt(0);
//             print("list length"+prodctlist1.length.toString());

//           });

//         }

//         if(p==i){

//           _getInvoice1(paytype);
//           break;

//         }

//       }*/
//     }
//   }

  Future _uploadProducts(String invoice, String paytype, String payId) async {
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
      final String unitPriceStr = prodctlist1[i].costPrice.toString();
      final double unitPrice = double.tryParse(unitPriceStr) ?? 0.0;
      final int qty = prodctlist1[i].pQuantity ?? 1;
      map['price'] = (unitPrice * qty).toStringAsFixed(2);
      map['user_per'] = prodctlist1[i].discount;
      map['user_dis'] = (double.parse(prodctlist1[i].discountValue.toString()) *
              prodctlist1[i].pQuantity!)
          .toStringAsFixed(2)
          .toString();
      map['admin_per'] = prodctlist1[i].adminper;
      map['admin_dis'] = prodctlist1[i].adminpricevalue;
      map['shop_id'] = GroceryAppConstant.Shop_id;
      map['cgst'] = prodctlist1[i].cgst;
      map['sgst'] = prodctlist1[i].sgst;
      map['variant'] = prodctlist1[i].varient ?? " ";
      map['color'] = prodctlist1[i].pcolor == null ||
              prodctlist1[i].pcolor.toString().isEmpty
          ? ""
          : prodctlist1[i].pcolor;
      map['size'] = prodctlist1[i].psize == null ||
              prodctlist1[i].psize.toString().isEmpty
          ? ""
          : prodctlist1[i].psize;
      map['refid'] = "0";
      map['image'] = prodctlist1[i].pimage;
      map['prime'] = "0";
      map['mv'] = prodctlist1[i].mv?.toString() ?? "0";
      // Set date and time separately
      if (textval == "Select Date" || textval.toString().isEmpty) {
        map['adate'] = '';
      } else {
        map['adate'] = (Jiffy.parse(textval, pattern: "dd/MM/yyyy")
                .format(pattern: "yyyy-MM-dd"))
            .toString();
      }

      // Set time slot
      if (textval1 == "Select Time" || textval1.isEmpty) {
        map['atime'] = '';
      } else {
        map['atime'] = textval1;
      }

      map['notes'] = "";
      final response = await http.post(
          Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
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
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.groceryAppCartItemCount = 0;
              groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
              pre!.setString("mvid", "");
              _afterPayment(
                  orderid.toString(), signature.toString(), payId.toString());

              // openCheckout();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId(user.Invoice!)),
              );
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'COD') {
              showLongToast(' Your  order is  sucessfull');
              dbmanager.deleteallProducts();
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.groceryAppCartItemCount = 0;
              groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
              pre!.setString("mvid", "");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId(user.Invoice!)),
              );
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'WALLET') {
              dbmanager.deleteallProducts();
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.groceryAppCartItemCount = 0;
              groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
              pre!.setString("mvid", "");
              walletPurchase();
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'UPI/QRCODE') {
              showLongToast(' Your order is successful');
              dbmanager.deleteallProducts();
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.itemcount = 0;
              pre!.setString("mvid", "");

//
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId1(user.Invoice!)),
              );
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'THROUGH ACCOUNTS') {
              showLongToast(' Your order is successful');
              dbmanager.deleteallProducts();
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.itemcount = 0;
              pre!.setString("mvid", "");

//          openCheckout();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId2(user.Invoice!)),
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
    var map = Map<String, dynamic>();

    print(mobile1);
    print(GroceryAppConstant.name);
    print(user_name);
    print(paymentId);
    print(orderid);
    print(signature);
    print(GroceryAppConstant.email);
    print(user_name);
    print(finalamount.toString());
    print(invoiceid);

//Wallet For Tiffynox...............................................................................................................
//Wallet For Tiffynox...............................................................................................................
//Wallet For Tiffynox...............................................................................................................
//Wallet For Tiffynox...............................................................................................................

    map['phone'] = mobile1;
    map['name'] = GroceryAppConstant.name;
    map['razorpay_payment_id'] = paymentId != null ? paymentId : "";
    map['razorpay_order_id'] = orderid != null ? orderid : "";
    map['razorpay_signature'] = signature != null ? signature : "";
    map['email'] = GroceryAppConstant.email;
    map['username'] = user_name;
    map['price'] = (calcutateAmount).toString();
    map['purpose'] = invoiceid;
    //map['mem_plan_id'] = "8";
    print("map---------->$map");
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'verifyUser.php'),
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
    String link = GroceryAppConstant.base_url + "api/payFromWallet.php";
    var body = {
      "username": mobile1,
      "key": md5,
      "price": finalamount.toString(),
      "purpose": invoiceid,
      "name": GroceryAppConstant.name,
      "phone": mobile1,
      "email": GroceryAppConstant.email,
    };
    print("walletPurchaseBody------->$body");
    final response = await http.post(Uri.parse(link), body: body);

    try {
      if (response.statusCode == 200) {
        print("response------->${response.body}");
        print("res---->${response.body}");
        showLongToast('Your order is successfull');
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
    String md5 = generateMd5(mobile1.toString() +
        invoiceid.toString() +
        usableWAlletAmount.toString());
    String link = GroceryAppConstant.base_url + "api/payFromWallet.php";
    var body = {
      "username": mobile1,
      "key": md5,
      "price": usableWAlletAmount,
      "purpose": invoiceid,
      "name": GroceryAppConstant.name,
      "phone": mobile1,
      "email": GroceryAppConstant.email,
    };
    print("walletPurchaseBody------->$body");
    final response = await http.post(Uri.parse(link), body: body);
    try {
      if (response.statusCode == 200) {
        print("response------->${response.body}");
        print("res---->${response.body}");
        showLongToast('Your order is successfull');
        //Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          loader = false;
        });
      }
    } catch (Exception) {}
  }

  Future walletPurchase2(String amount) async {
    String md5 = generateMd5(
        user_name.toString() + invoiceid.toString() + amount.toString());
    String link = GroceryAppConstant.base_url + "api/payFromWallet.php";
    var body = {
      "username": user_name,
      "key": md5,
      "price": amount.toString(),
      "purpose": invoiceid,
      "name": GroceryAppConstant.name,
      "phone": user_name,
      "email": GroceryAppConstant.email,
    };
    print("walletPurchaseBody------->$body");
    final response = await http.post(Uri.parse(link), body: body);

    try {
      if (response.statusCode == 200) {
        print("response------->${response.body}");
        print("res---->${response.body}");
        showLongToast('Your order is successfull');
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
        if (usersFromServe != null) {
          setState(() {
            // prodctlist1
            coupan = usersFromServe;
            if (coupan.status == "true") {
              String fortype = coupan.data!.couponCodes![0].fortype ?? "";

              if (int.parse(coupan.data!.couponCodes![0].mv_id ?? "") > 0) {
                if (coupan.data!.couponCodes![0].mv_id ==
                    "${pre!.getString("mvid")}") {
                  if (fortype == "first") {
                    trackInvoice1(GroceryAppConstant.username)
                        .then((usersFromServe) {
                      if (usersFromServe != null) {
                        setState(() {
                          list = usersFromServe;
                          print("InVOICE LIST  ${list.length}");
                          list.length > 0
                              ? showLongToast("Invalid and Expire Coupon")
                              : checkvalue(coupan);
                          // getCoupanVal(coupan);
                        });
                      }
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
                  trackInvoice1(GroceryAppConstant.username)
                      .then((usersFromServe) {
                    if (usersFromServe != null) {
                      setState(() {
                        list = usersFromServe;
                        print("InVOICE LIST  ${list.length}");
                        if (list.length > 0) {
                          applyButtonLoader = false;
                          showLongToast("Invalid and Expire Coupon");
                        } else {
                          checkvalue(coupan);
                        }
                      });
                    }
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
        }
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
        if (prodctlist1[i].pid?.trim() ==
            coupan.data!.couponCodes![0].pro_id?.trim()) {
          //getCoupanVal(coupan);
          if (coupan.data?.couponCodes![0].type == "per") {
            double differ = double.parse(calDiscount1(
                prodctlist1[i].pprice.toString(),
                coupan.data!.couponCodes![0].val ?? ""));
            print("differ$differ");
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
                showLongToast("Coupon code applied successfullly...");
              } else {
                difference = differ;
                finalamount = finalamount! - difference!;
              }
              applyButtonLoader = false;
              hideApplyButton = true;
              showLongToast("Coupon code applied successfullly...");
            });
          } else {
            setState(() {
              difference = double.parse(coupan.data!.couponCodes![0].val ?? "");
              discountval_flag = true;
              finalamount = finalamount! - difference!;
            });
            applyButtonLoader = false;
            hideApplyButton = true;
            showLongToast("Coupon code applied successfullly...");
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
      calcutateAmount = GroceryAppConstant.totalAmount;
      getCoupanVal(coupan);

      print("calcutateAmount  $calcutateAmount");
    }
  }

  getCoupanVal(Coupan coupan) {
    setState(() {
      coupancode = coupanController.text;
      String name = GroceryAppConstant.username;
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
              print("value1  $val");
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
                  showLongToast("Coupon code applied successfullly...");
                } else {
                  difference = double.parse(val1);
                  finalamount = finalamount! - difference!;
                  applyButtonLoader = false;
                  hideApplyButton = true;
                  showLongToast("Coupon code applied successfullly...");
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
              showLongToast("Coupon code applied successfullly...");
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
                showLongToast("Coupon code applied successfullly...");
              } else {
                difference = double.parse(val1);
                finalamount = finalamount! - difference!;
              }
              applyButtonLoader = false;
              hideApplyButton = true;
              showLongToast("Coupon code applied successfullly...");
            });
          } else {
            setState(() {
              difference = double.parse(coupan.data!.couponCodes![0].val ?? "");
              discountval_flag = true;
              finalamount = finalamount! - difference!;
            });
            applyButtonLoader = false;
            hideApplyButton = true;
            showLongToast("Coupon code applied successfullly...");
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

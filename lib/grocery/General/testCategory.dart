/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:prepzap/APIModels/TestCategoryModel.dart';
import 'package:prepzap/APIModels/TestseriesModel.dart';
import 'package:prepzap/APIModels/TsAllquizzesModel.dart';
import 'package:prepzap/APIModels/TsquizzesModel.dart';
import 'package:prepzap/APIModels/paystatusModel.dart';
import 'package:prepzap/AppSize/appsize.dart';
import 'package:prepzap/AppSize/divider.dart';
import 'package:get/get.dart';
import 'package:prepzap/Appcolor/appcolor.dart';
import 'package:prepzap/WebService/dbhelper.dart';
import 'package:prepzap/drawerPages/attemptexamanalysis.dart';
import 'package:prepzap/drawerPages/attemptexamsolution.dart';
import 'package:prepzap/quiz/quiz.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class testCategory extends StatefulWidget {
  String id;
  TestseriesModel data;

  testCategory(this.id, this.data);

  @override
  _TestSeriesState createState() => _TestSeriesState();
}

class _TestSeriesState extends State<testCategory> {
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  double totalamt=0.0;
  List<TestCategoryModel> list1 = new List<TestCategoryModel>();
  // List<TsquizzesModel> list2 = new List<TsquizzesModel>();
  List<paystatusModel> list2 = new List<paystatusModel>();

  bool checkpay = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get_testcategories("3", widget.id).then((usersFromServe) {
      setState(() {
        list1 = usersFromServe;
      });
    });
    checkdata();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  checkdata() {
   */
/* get_tsquizzes(widget.id, widget.id).then((usersFromServe) {
      setState(() {
        list2 = usersFromServe;
        if (list2 != null && list2.length > 0)
          list2[0].payStatus == "paid" ? checkpay = true : checkpay = false;
      });
    });*//*

    get_paystatus(widget.id).then((usersFromServe) {
      setState(() {
        list2 = usersFromServe;
        if (list2 != null && list2.length > 0)
          list2[0].payStatus == "paid" ? checkpay = true : checkpay = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(double amt) async {
    totalamt=amt;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': totalamt * 100,
      'name': Constant.appname,
      'description': Constant.appname,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    _paymentUpdate(response);
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT);
  }

  Future _paymentUpdate(PaymentSuccessResponse response) async {
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    String md5 = Constant.user_id + widget.id + response.paymentId;

    print(generateMd5(md5));
//  searchdatasave(query);

    var map = new Map<String, dynamic>();
    map['txn_id'] = response.paymentId;
    map['user_id'] = Constant.user_id;
    map['amount'] = totalamt;
    map['series_id'] = widget.id;
    map['key'] = generateMd5(md5);
    print(map.toString());
   print(Constant.update_ts_payment_URL);

    try {
      final response =
          await http.post(Constant.update_ts_payment_URL, body: map);

      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.toString());
        print("++++++++++++++++++++++"+Constant.update_ts_payment_URL);
        Fluttertoast.showToast(
            msg: "SUCCESS: +++++++++++", toastLength: Toast.LENGTH_SHORT);

        // print(jsonDecode(response.body)["data"]);
        // U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
        */
/*if (jsonDecode(response.body)["responce"]) {
          checkdata();
          print(jsonDecode(response.body)["data"]);
        } else {
          print(jsonDecode(response.body)["data"]);
          // print(user.img);
        }*//*

      } else
        throw Exception("Unable to get Employee list");
    } catch (Exception) {}
  }

  var controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScrollAppBar(
          controller: controller,
          title: Text(
            widget.data.testSeriesName,
            style: TextStyle(color: Constant.btntextcolor),
          ),
          elevation: 0,
          backgroundColor: Constant.appbarcolor,
          */
/*actions: [
          GestureDetector(
            onTap: () {
              _showbottomsheet();
            },
            child: Row(
              children: [
                Text(
                  "All",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: Appsizes.sigUptextsize,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Constant.btnbgcolor,
                )
              ],
            ),
          ),
          // Icon(Icons.notification_important,color: Constant.noticolor,)
        ],*//*

        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: Appsizes.sizeboxheight,),
              list1 != null && list1.length > 0 ? freeMock() : Container(),
              SizedBox(
                height: Appsizes.sizeboxheight,
              ),
            ],
          ),
        ));
  }

  Widget freeMock() {
    return Container(
        // width: double.maxFinite,
        // height: Appsizes.width,
        margin: EdgeInsets.only(
          left: Appsizes.spacebwtxt,
          right: Appsizes.spacebwtxt,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Appsizes.sizeboxheight)),
        // padding: EdgeInsets.only(top: Appsizes.padding),
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height:20,),
                Container(
                  // width: Appsizes.contht,
                  // height: Appsizes.width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10,
                        left: Appsizes.lefpadding,
                        right: Appsizes.rightpadding,
                        bottom: Appsizes.padding),
                    child: Text(
                      list1[index].categoryName,
                      style: TextStyle(
                        color: Constant.textcolor,
                        fontSize: Appsizes.sizeboxheight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  // width: double.maxFinite,
                  // height: Appsizes.width,
                  child: FutureBuilder(
                      future: get_tsAllquizzes(widget.id, list1[index].tsCatId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: Appsizes.spacebwtxt,
                                bottom: 0,
                                right: Appsizes.spacebwtxt),
                            width: double.maxFinite,
                            height: snapshot.data.length == 1 ? 260 / 2 : 260,
                            margin: EdgeInsets.only(
                                left: Appsizes.spacebwtxt,
                                right: Appsizes.spacebwtxt),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Appsizes.sizeboxheight)),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          snapshot.data.length == 1 ? 1 : 2,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2,
                                      mainAxisExtent: 300),
                              itemBuilder: (context, index) {
                                TsAllquizzesModel item = snapshot.data[index];
                                return InkWell(
                                  onTap: () {
                                    checkpay
                                        ? openCheckout(double.parse(item.price))
                                        : Navigator.push(
                                            context,
                                            // MaterialPageRoute(builder: (context) => QuizScreen(entry.id)),
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Quiz(item.quizId)),
                                          );
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: Appsizes.padding),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: Appsizes.padding,
                                              right: Appsizes.padding),
                                          child: Container(
                                            height: Appsizes.contheight,
                                            width: Appsizes.contheight,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              border: Border.all(
                                                  color: Constant.textgrey,
                                                  width: Appsizes
                                                      .textfileborderside),
                                            ),
                                            child: Icon(
                                              Icons.alarm,
                                              color: Constant.btnbgcolor,
                                              size: Appsizes.btnsize,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.quizTitle,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      color: Constant.textcolor,
                                                      fontSize:
                                                          Appsizes.txtsize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Appsizes.spacebwtxt,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    item.quizDesc,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      color: Constant.textcolor,
                                                      fontSize: Appsizes.txtsze,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Appsizes.spacebwtxt,
                                                ),
                                                Text(
                                                  "190 attempts",
                                                  style: TextStyle(
                                                    color: Constant.textgrey,
                                                    fontSize: Appsizes.textsize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Appsizes.spacebwtxt,
                                                ),
                                                Text(
                                                  "15 Questions | 12mins",
                                                  style: TextStyle(
                                                    color: Constant.textgrey,
                                                    fontSize: Appsizes.textsize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      checkpay
                                                          ? "Pay Now"
                                                          : "Start Quiz",
                                                      style: TextStyle(
                                                        color:
                                                            Constant.btnbgcolor,
                                                        fontSize: Appsizes
                                                            .sigUptextsize,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          Appsizes.spacebwtxt,
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color:
                                                          Constant.btnbgcolor,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data.length == null
                                  ? 0
                                  : snapshot.data.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          );
                          // Container(
                          //     height: Appsizes.width,
                          //     child: ListView.builder(
                          //       padding: EdgeInsets.only(bottom: Appsizes.padding),
                          //         physics: ClampingScrollPhysics(),
                          //         scrollDirection: Axis.vertical,
                          //         itemCount: snapshot.data.length == null
                          //             ? 0
                          //             : snapshot.data.length,
                          //         itemBuilder:
                          //             (BuildContext context, int index) {
                          //
                          //               TsAllquizzesModel item = snapshot.data[index];
                          //           return freeMock1(item);
                          //         }));

                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ),
                Divider(),
              ],
            );
          },
          itemCount: list1.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
        ));
  }

  Widget freeMock1(TsAllquizzesModel entry) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => QuizScreen(entry.id)),
        MaterialPageRoute(builder: (context) => Quiz(entry.quizId)),
      ),
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.all(Appsizes.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: Constant.textgrey,
                    height: 70,
                    width: Appsizes.imagesize,
                    child: Icon(
                      Icons.alarm,
                      color: Constant.btnbgcolor,
                      size: 40,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: Appsizes.btnheight,
                    width: Appsizes.imagesize,
                    color: Constant.btnbgcolor,
                    child: Text(
                      "Start Quiz",
                      style: TextStyle(
                        color: Constant.noticolor,
                        fontSize: Appsizes.sigUptextsize,
                      ),
                    ),
                  )
                ],
              )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: Appsizes.padding),
              child: Column(
                children: [
                  Text(
                    entry.quizTitle,
                    style: TextStyle(
                        color: Constant.textcolor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: Appsizes.spacebwtxt,
                  ),
                  */
/*Text(
                   entry.quizDesc,
                    style: TextStyle(
                        color: Constant.textcolor,
                        fontSize: 10,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: Appsizes.spacebwtxt,
                  ),*//*

                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Constant.btnbgcolor,
                      ),
                      SizedBox(
                        width: Appsizes.spacebwtxt,
                      ),
                      Text(
                        entry.quizTime,
                        style: TextStyle(
                            color: Constant.btnbgcolor,
                            fontSize: Appsizes.textsize),
                      ),
                      SizedBox(
                        width: Appsizes.spacebwtxt,
                      ),
                      Text(
                        "798 attempts",
                        style: TextStyle(
                            color: Constant.textgrey,
                            fontSize: Appsizes.textsize),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget upcomingSeries() {
    return Container(
        width: Appsizes.contwithd,
        height: Appsizes.imagesize,
        margin: EdgeInsets.only(
          left: Appsizes.spacebwtxt,
          right: Appsizes.spacebwtxt,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Appsizes.sizeboxheight)),
        padding: EdgeInsets.only(top: Appsizes.padding),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Appsizes.lefpadding,
                          right: Appsizes.rightpadding,
                          bottom: Appsizes.padding),
                      child: Text(
                        "SUPER TET (UP Assitant Teacher) 2021",
                        style: TextStyle(
                          color: Constant.textcolor,
                          fontSize: Appsizes.sigUptextsize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Appsizes.lefpadding,
                          right: Appsizes.rightpadding,
                          bottom: Appsizes.padding),
                      child: Text(
                        "Starts on 05 may",
                        style: TextStyle(
                          color: Constant.textgrey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: Appsizes.lefpadding,
                            right: Appsizes.rightpadding,
                            bottom: Appsizes.padding,
                            top: Appsizes.padding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "900 students have already registered",
                              style: TextStyle(
                                color: Constant.textcolor,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: Appsizes.sigUptextsize,
                            ),
                            Text(
                              "Register",
                              style: TextStyle(
                                color: Constant.btnbgcolor,
                                fontSize: Appsizes.sigUptextsize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                  ],
                ));
          },
          itemCount: 10,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
        ));
  }

  Widget performance() {
    return Container(
      height: MediaQuery.of(context).size.height * .6,
      width: MediaQuery.of(context).size.width,
    );
  }
}
*/

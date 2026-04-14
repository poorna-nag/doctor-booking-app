// ignore_for_file: missing_return

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ecoshine24/General/AppConstant.dart';
import 'package:ecoshine24/dbhelper/database_helper.dart';
import 'package:ecoshine24/model/CancleandRefundmodel.dart';
import 'package:ecoshine24/model/InvoiceTrackmodel.dart';
import 'package:http/http.dart' as http;
import 'package:ecoshine24/screen/myorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinalOrderTracker extends StatelessWidget {
  final String? invoiceno;
  final String? dateval;
  final String? status;
  int? difference;
  int? daliverydate;
  FinalOrderTracker(this.invoiceno, this.dateval, this.status);
  List<String>? list;
  getSuvstring() {
    String date = dateval!.substring(0, 10);
    list = date.split("-");
    int a = int.parse(list![0]);
    int b = int.parse(list![1]);
    int c = int.parse(list![2]);
    daliverydate = int.parse(list![2]);
    final birthday = DateTime(a, b, c);
    final date2 = DateTime.now();

    difference = date2.difference(birthday).inDays;
  }

  @override
  Widget build(BuildContext context) {
    getSuvstring();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Your Order",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Column(
        children: <Widget>[
//          createHeader(),
//        createSubTitle(),
          Expanded(
              child: FutureBuilder(
                  future: trackInvoiceOrder(invoiceno ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data?.length == null
                                  ? 0
                                  : snapshot.data?.length,
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                InvoiceInvoice item = snapshot.data![index];
                                return Stack(
                                  children: <Widget>[
//                              Expanded(
////              padding: EdgeInsets.only(right: 8, top: 4),
//                                child: Container(
//                                  margin: EdgeInsets.only(left: 10,right: 10),
//                                  child: Text(item.productName==null? 'name':item.productName,
//                                    maxLines: 2,
//                                    softWrap: true,
//                                    style:TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black)
//                                        .copyWith(fontSize: 14),
//                                  ),
//                                ),
//                              ),

                                    InkWell(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => ProductDetails1(item.productId)),
                                        // );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 16, top: 16),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16))),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 8,
                                                  left: 0,
                                                  top: 8,
                                                  bottom: 8),
                                              width: 90,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(14)),
                                                  color: Colors.blue.shade200,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        FoodAppConstant
                                                                .Product_Imageurl1 +
                                                            item.image
                                                                .toString(),
                                                      ))),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Expanded(
                                                            child: Text(
                                                              item.productName ==
                                                                      null
                                                                  ? 'name'
                                                                  : item.productName ??
                                                                      "",
                                                              maxLines: 2,
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black)
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 6),

                                                    /* Row(
                                                children: <Widget>[
                                                  Text(
                                                    'COLOR: ${item.color}',
                                                    style:TextStyle( fontWeight: FontWeight.w400, color: Colors.black)
                                                        .copyWith(color: Colors.grey, fontSize: 14),
                                                  ),
                                                  SizedBox(width: 20),


                                                ],
                                              ),*/

                                                    // Text(
                                                    //   'Quantity: ${item.quantity}',
                                                    //   style: TextStyle(
                                                    //           fontWeight:
                                                    //               FontWeight
                                                    //                   .w400,
                                                    //           color:
                                                    //               Colors.black)
                                                    //       .copyWith(
                                                    //           color:
                                                    //               Colors.grey,
                                                    //           fontSize: 14),
                                                    // ),
//                      SizedBox(height: 3),
                                                    /*  Text(
                                                'Size: ${item.size}',
                                                style:TextStyle( fontWeight: FontWeight.w400, color: Colors.black)
                                                    .copyWith(color: Colors.grey, fontSize: 14),
                                              ),*/
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            item.price == null
                                                                ? '100'
                                                                : '\u{20B9} ${calDiscount(item.price ?? "", item.userPer ?? "")}',
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ).copyWith(
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                          status == "Delivered"
                                                              ? ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        FoodAppColors
                                                                            .red,
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(24))),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    showDilogueReviw(
                                                                        context,
                                                                        item.productId ??
                                                                            "");
                                                                  },
                                                                  child: Text(
                                                                    "Review",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              : Row(),

                                                          //Add review Button
                                                        ],
                                                      ),
                                                    ),

                                                    // status == "Complete"
                                                    //     ? Row(
                                                    //         mainAxisAlignment:
                                                    //             MainAxisAlignment
                                                    //                 .end,
                                                    //         children: [
                                                    //           InkWell(
                                                    //             onTap: () {
                                                    //               Navigator
                                                    //                   .push(
                                                    //                 context,
                                                    //                 MaterialPageRoute(
                                                    //                     builder:
                                                    //                         (context) =>
                                                    //                             shopreviewrating(item.mv ?? "")),
                                                    //               );
                                                    //             },
                                                    //             child:
                                                    //                 Container(
                                                    //               padding:
                                                    //                   EdgeInsets
                                                    //                       .all(
                                                    //                           8),
                                                    //               margin:
                                                    //                   EdgeInsets
                                                    //                       .all(
                                                    //                           0),
                                                    //               decoration:
                                                    //                   BoxDecoration(
                                                    //                 borderRadius:
                                                    //                     BorderRadius.circular(
                                                    //                         10),
                                                    //                 color: Colors
                                                    //                     .amber,
                                                    //                 border: Border.all(
                                                    //                     width:
                                                    //                         03,
                                                    //                     color: FoodAppColors
                                                    //                         .white),
                                                    //               ),
                                                    //               child: Text(
                                                    //                 "Rate Vendor",
                                                    //                 textAlign:
                                                    //                     TextAlign
                                                    //                         .center,
                                                    //                 style: TextStyle(
                                                    //                     color: FoodAppColors
                                                    //                         .white,
                                                    //                     fontSize:
                                                    //                         12),
                                                    //               ),
                                                    //             ),
                                                    //           ),
                                                    //         ],
                                                    //       )
                                                    //     : Container(),
                                                  ],
                                                ),
                                              ),
                                              flex: 100,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })),
          footer(context),
        ],
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              daliverydate == 00
                  ? ((status != 'Cancelled')
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FoodAppColors.tela,
                            padding: EdgeInsets.only(
                                top: 12, left: 60, right: 60, bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                          ),
                          onPressed: () {
                            showDilogue(context);
                            val = "can";
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Row())
                  : Row(),
              SizedBox(
                width: 15.0,
              ),
              // daliverydate != 00
              //     ? ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.black,
              //           padding: EdgeInsets.only(
              //               top: 12, left: 60, right: 60, bottom: 12),
              //           shape: RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.all(Radius.circular(24))),
              //         ),
              //         onPressed: () {
              //           showDilogue(context);
              //           val = "rep";
              //         },
              //         child: Text(
              //           "Return",
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       )
              //     : Row(),
            ],
          ),
          SizedBox(height: 8),
//          RaisedButton(
//            onPressed: () {
//
//
//            },
//            color: Colors.amberAccent,
//            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(24))),
//            child: Text(
//              "Buy Now",
//
//            ),
//          ),
          SizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  var _formKey12 = GlobalKey<FormState>();
  String val = "";
  final resignofcause = TextEditingController();
  final resignofcause1 = TextEditingController();
  double? _ratingController;

  showDilogue(BuildContext context) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 250.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey12,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      maxLines: 4,
//                    keyboardType: TextInputType.number, // Use mobile input type for emails.
                      controller: resignofcause,
                      validator: (String? value) {
                        //  print("Length${value.length}");
                        if (value == null ||
                            value.isEmpty && value.length > 10) {
                          return "  Enter the reason";
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        hintText: 'Reason',
                        labelText: 'Please mention reason',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),

//                                      icon: new Icon(Icons.queue_play_next),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),
                      ))),
            ),
            TextButton(
                onPressed: () {
                  cancleandRefund(val, context);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Submit!',
                  style: TextStyle(color: FoodAppColors.pink, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  cancleandRefund(String val, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? mobile = pref.getString("mobile");

    String link = FoodAppConstant.base_url + "api/order_status.php";
    var map = new Map<String, dynamic>();
    map['user_id'] = mobile;
    map['order_id'] = invoiceno;
    map['status'] = val;
    map['note'] = resignofcause.text;
    map['api_id'] = FoodAppConstant.Shop_id;
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
      CancleandRefund user =
          CancleandRefund.fromJson(jsonDecode(response.body));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrackOrder()),
      );

      showLongToast(user.message.toString());
    }
  }

  senReview(BuildContext context, String id) async {
    String link = FoodAppConstant.base_url + "manage/api/reviews/add";

    print(FoodAppConstant.user_id);
    print(FoodAppConstant.API_KEY);
    print(_ratingController.toString());
    print(resignofcause1.text);
    print(id);
    var map = new Map<String, dynamic>();
    map['user_id'] = FoodAppConstant.user_id;
    map['X-Api-Key'] = FoodAppConstant.API_KEY;
    map['stars'] =
        (_ratingController!.toStringAsFixed(FoodAppConstant.val)).toString();
    map['review'] = resignofcause1.text;
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['product'] = id;
    map['dates'] = " ";
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
      CancleandRefund1 user =
          CancleandRefund1.fromJson(jsonDecode(response.body));
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => TrackOrder()),);

//        showLongToast("Rivew submitted successfully");
      showLongToast(user.message.toString());
    } else {
      throw Exception("Nothing is generated");
    }
  }

  showDilogueReviw(BuildContext context, String id) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 250.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey12,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      maxLines: 4,
//                      keyboardType: TextInputType.number, // Use mobile input type for emails.
                      controller: resignofcause1,
                      validator: (String? value) {
                        //print("Length${value.length}");
                        if (value == null ||
                            value.isEmpty && value.length > 10) {
                          return "write a review";
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        hintText: 'review',
                        labelText: 'Please write a review',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),

//                                      icon: new Icon(Icons.queue_play_next),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),
                      ))),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _ratingController = rating;
                print(_ratingController);
              },
            ),
            TextButton(
                onPressed: () {
                  senReview(context, id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Submit !',
                  style: TextStyle(color: FoodAppColors.pink, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }
}

//  createSubTitle() {
//    return Container(
//      alignment: Alignment.topLeft,
//      child: Text(
//        'Total (${Constant.itemcount}) Items',
//        style: CustomTextStyle.textFormFieldBold
//            .copyWith(fontSize: 12, color: Colors.grey),
//      ),
//      margin: EdgeInsets.only(left: 12, top: 4),
//    );
//  }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/CancleandRefundmodel.dart';
import 'package:ecoshine24/grocery/model/InvoiceTrackmodel.dart';
import 'package:ecoshine24/grocery/screen/detailpage1.dart';
import 'package:http/http.dart' as http;
import 'package:ecoshine24/grocery/screen/myorder.dart';
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
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1E88E5), // Medical blue from grocery home
              Color(0xff42A5F5), // Lighter medical blue
              Color(0xff42A5F5), // Even lighter medical blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff1E88E5), // Medical blue
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "My Appointments",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(width: 36), // For symmetry
                    ],
                  ),
                ),
              ),
              // Body Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: FutureBuilder(
                              future: trackInvoiceOrder(invoiceno ?? ""),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data?.length ?? 0,
                                    shrinkWrap: true,
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      InvoiceInvoice item =
                                          snapshot.data![index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 16),
                                        child: Card(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  Color(0xff1E88E5) // Medical blue
                                                      .withOpacity(0.02),
                                                ],
                                              ),
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onTap: () {
                                                // Check if productId is valid before navigation
                                                // if (item.productId != null &&
                                                //     item.productId!
                                                //         .isNotEmpty) {
                                                //   Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             ProductDetails1(item
                                                //                 .productId!)),
                                                //   );
                                                // } else {
                                                //   // Show error message if productId is invalid
                                                //   ScaffoldMessenger.of(context)
                                                //       .showSnackBar(
                                                //     SnackBar(
                                                //       content: Text(
                                                //           "Product details not available"),
                                                //       backgroundColor:
                                                //           const Color.fromARGB(
                                                //               255,
                                                //               39,
                                                //               118,
                                                //               209),
                                                //       duration:
                                                //           Duration(seconds: 2),
                                                //     ),
                                                //   );
                                                // }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                child: Row(
                                                  children: [
                                                    // Product Image
                                                    Container(
                                                      width: 90,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Color(0xff1E88E5) // Medical blue
                                                                .withOpacity(0.1),
                                                            Color(
                                                                    0xff42A5F5) // Lighter medical blue
                                                                .withOpacity(
                                                                    0.05),
                                                          ],
                                                        ),
                                                        border: Border.all(
                                                          color: Color(
                                                                  0xff1E88E5) // Medical blue
                                                              .withOpacity(0.2),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        child: Image.network(
                                                          GroceryAppConstant
                                                                  .Product_Imageurl1 +
                                                              item.image
                                                                  .toString(),
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                        0xff1E88E5) // Medical blue
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .medical_services_outlined, // Medical icon
                                                                color: Color(
                                                                    0xff1E88E5), // Medical blue
                                                                size: 40,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 16),
                                                    // Product Details
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Product Name
                                                          Text(
                                                            item.productName ==
                                                                    null
                                                                ? 'Product Name'
                                                                : item.productName ??
                                                                    "",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xff1E88E5), // Medical blue
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          SizedBox(height: 8),
                                                          // Product Details Row
                                                          Row(
                                                            children: [
                                                              if (item.color !=
                                                                      null &&
                                                                  item.color!
                                                                      .isNotEmpty)
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                            0xff1E88E5) // Medical blue
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Text(
                                                                    'COLOR: ${item.color}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xff1E88E5), // Medical blue
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (item.color !=
                                                                      null &&
                                                                  item.color!
                                                                      .isNotEmpty)
                                                                SizedBox(
                                                                    width: 8),
                                                            ],
                                                          ),
                                                          SizedBox(height: 6),
                                                          // Quantity
                                                          if (item.quantity !=
                                                              null)
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                        0xff42A5F5) // Lighter medical blue
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Text(
                                                                'Quantity: ${item.quantity}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xff1E88E5), // Medical blue
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          SizedBox(height: 6),
                                                          // Size
                                                          if (item.size !=
                                                                  null &&
                                                              item.size!
                                                                  .isNotEmpty)
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                        0xff64B5F6) // Even lighter medical blue
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Text(
                                                                'Size: ${item.size}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xff1E88E5), // Medical blue
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          SizedBox(height: 12),
                                                          // Price and Review Button Row
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                item.price ==
                                                                        null
                                                                    ? '₹100'
                                                                    : '₹${calDiscount(item.price ?? "", item.userPer ?? "")}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff1E88E5), // Medical blue
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              if (status ==
                                                                  "Delivered")
                                                                Container(
                                                                  height: 35,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                            0xff1E88E5), // Medical blue
                                                                        Color(
                                                                            0xff42A5F5), // Lighter medical blue
                                                                      ],
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Color(0xff1E88E5) // Medical blue
                                                                            .withOpacity(0.3),
                                                                        spreadRadius:
                                                                            1,
                                                                        blurRadius:
                                                                            4,
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shadowColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18),
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
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
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  );
                                }
                              })),
                      footer(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel Button
          if (daliverydate == 00 && status != 'Cancelled')
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 26, 129, 202),
                      const Color.fromARGB(255, 35, 136, 194),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 28, 133, 208)
                          .withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    showDilogue(context);
                    val = "can";
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Refund Button
          if (daliverydate != 00)
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(
                    left: daliverydate == 00 && status != 'Cancelled' ? 8 : 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1E88E5), // Medical blue
                      Color(0xff42A5F5), // Lighter medical blue
                      Color(0xff64B5F6), // Even lighter medical blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff1E88E5).withOpacity(0.3), // Medical blue
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    showDilogue(context);
                    val = "ref";
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Refund",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 12, top: 12),
      child: Text(
        "SHOPPING CART",
      ),
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
                        // print("Length${value.length}");
                        if (value == null ||
                            value.isEmpty && value.length > 10) {
                          return " Please enter the  resion";
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        hintText: 'Resion',
                        labelText: 'Please mention resion',
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
                  'Submit !',
                  style:
                      TextStyle(color: GroceryAppColors.pink, fontSize: 18.0),
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

    String link = GroceryAppConstant.base_url + "api/order_status.php";
    var map = new Map<String, dynamic>();
    map['user_id'] = mobile;
    map['order_id'] = invoiceno;
    map['status'] = val;
    map['note'] = resignofcause.text;
    map['api_id'] = GroceryAppConstant.Shop_id;
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
    String link = GroceryAppConstant.base_url + "manage/api/reviews/add";

    print(GroceryAppConstant.user_id);
    print(GroceryAppConstant.API_KEY);
    print(_ratingController.toString());
    print(resignofcause1.text);
    print(id);
    var map = new Map<String, dynamic>();
    map['user_id'] = GroceryAppConstant.user_id;
    map['X-Api-Key'] = GroceryAppConstant.API_KEY;
    map['stars'] =
        (_ratingController!.toStringAsFixed(GroceryAppConstant.val)).toString();
    map['review'] = resignofcause1.text;
    map['shop_id'] = GroceryAppConstant.Shop_id;
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
      showLongToast(user.message ?? "");
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
                        // print("Length${value.length}");
                        if (value == null ||
                            value.isEmpty && value.length > 10) {
                          return " Please enter the  review";
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        hintText: 'Review',
                        labelText: 'Please mention review',
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
                  style:
                      TextStyle(color: GroceryAppColors.pink, fontSize: 18.0),
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

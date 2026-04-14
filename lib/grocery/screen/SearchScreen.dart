import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/grocery/Auth/signin.dart';
import 'package:ecoshine24/grocery/General/AnimatedSplashScreen.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:ecoshine24/grocery/screen/detailpage.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserFilterDemo extends StatefulWidget {
  UserFilterDemo() : super();

  @override
  UserFilterDemoState createState() => UserFilterDemoState();
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

class UserFilterDemoState extends State<UserFilterDemo> {
  // https://jsonplaceholder.typicode.com/users

  final _debouncer = Debouncer(milliseconds: 500);
  List<Products> users = [];
  static List<Products> topProducts1 = [];

  List<Products> suggestionList = [];
  bool _progressBarActive = false;
  int _current = 0;
  int total = 000;
  int actualprice = 200;
  double? mrp, totalmrp = 000;
  int _count = 1;

  int cc = 0;

  double? sgst1, cgst1, dicountValue, admindiscountprice;

  @override
  void initState() {
    super.initState();
    setState(() {
      // users = SplashScreenState.filteredUsers;
      // print(users.toString());
      // suggestionList = users;
    });

    DatabaseHelper.getAllProductSearch("", '10000000', '')
        .then((usersFromServe) {
      setState(() {
        users = usersFromServe!;
        suggestionList = users;
      });
    });
  }

  void getcartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cCount = pref.getInt("cc");
    setState(() {
      //log("cart get count------------------->>$cCount");
      if (cCount != null) {
        if (cCount == 0 || cCount < 0) {
          cc = 0;
          AppConstent.cc = 0;
          //log(" AppConstent.cc------------------->>${AppConstent.cc}");
        } else {
          setState(() {
            cc = cCount;
            AppConstent.cc = cCount;
          });
        }
      }
      //log("cart count------------------->>$cc");
    });
  }

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GroceryAppConstant.isLogin = false;
    int? Count = pref.getInt("itemCount");
    bool? ligin = pref.getBool("isLogin");
    setState(() {
      if (ligin != null) {
        GroceryAppConstant.isLogin = ligin;
      }
      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
      }
      print(
          GroceryAppConstant.groceryAppCartItemCount.toString() + "itemCount");
    });
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff1E88E5), // Medical blue from grocery home
                Color(0xff42A5F5), // Lighter medical blue
                Color(0xff64B5F6), // Even lighter medical blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
            padding: EdgeInsets.only(left: 0.0),
            child: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: GroceryAppColors.white,
              ),
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 90,
              padding: EdgeInsets.symmetric(
//              vertical: 10,
//                  horizontal: 10,
                  ),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: GroceryAppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                    color: Color(0xff1E88E5).withOpacity(0.2), // Medical blue
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff1E88E5).withOpacity(0.1), // Medical blue
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                      child: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      onChanged: (string) {
                        DatabaseHelper.getAllProductSearch(
                                "", "10000000", string)
                            .then((usersFromServe) {
                          setState(() {
                            users = usersFromServe!;
                            suggestionList = users;
                          });
                        });

                        _debouncer.run(() {
                          setState(() {
                            suggestionList = users
                                .where((u) => (u.productName!
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                                .toList();
                          });
                        });
                      },
                      style:
                          TextStyle(color: Color(0xff1E88E5)), // Medical blue
                      decoration: InputDecoration(
                        hintText: 'Search Medical Services...',
                        hintStyle: TextStyle(
                            color: Color(0xff42A5F5)
                                .withOpacity(0.7)), // Lighter medical blue
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff1E88E5), // Medical blue
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            ),

//             Container(
//               width: MediaQuery.of(context).size.width - 90,
//               padding: EdgeInsets.symmetric(
// //              vertical: 10,
// //                  horizontal: 10,
//                   ),
//               child: Material(
//                 color: Colors.white,
//                 elevation: 0.0,
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(
//                     color: Colors.white,
//                   ),
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(20),
//                   ),
//                 ),
//                 clipBehavior: Clip.antiAlias,
//                 child: InkWell(
//                     child: Padding(
//                   padding: EdgeInsets.only(top: 5.0),
//                   child: TextField(
//                     onChanged: (string) {
            // if (string != null) {
            //  DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
            //     setState(() {
            //       users = usersFromServe;
            //       if (users != null) {
            //         suggestionList = users;
            //       }
            //     });
            //   });
            // }

            // _debouncer.run(() {
            //   setState(() {
            //     suggestionList = users.where((u) => (u.productName.toLowerCase().contains(string.toLowerCase()))).toList();
            //   });
            // });
//                     },
//                     style: TextStyle(color: Colors.green[900]),
//                     decoration: InputDecoration(
//                       hintText: 'Search Your Product',
//                       hintStyle: TextStyle(color: GroceryAppColors.black),
//                       prefixIcon: Icon(
//                         Icons.search,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 )),
//               ),
//             ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF8FBFF), // Light medical blue background
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemCount: suggestionList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin:
                        EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            GroceryAppColors.white,
                            Color(0xffF8FBFF)
                          ], // Light medical blue
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          color: Color(0xff1E88E5)
                              .withOpacity(0.2), // Medical blue
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff1E88E5)
                                .withOpacity(0.1), // Medical blue
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(suggestionList[index])),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  right: 8, left: 8, top: 8, bottom: 8),
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff1E88E5) // Medical blue
                                          .withOpacity(0.3),
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff1E88E5) // Medical blue
                                          .withOpacity(0.1),
                                      Color(0xff42A5F5) // Lighter medical blue
                                          .withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        GroceryAppConstant.Product_Imageurl +
                                            suggestionList[index].img!,
                                      ))),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        suggestionList[index].productName ==
                                                null
                                            ? 'name'
                                            : suggestionList[index]
                                                    .productName ??
                                                "",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(
                                                    0xff1E88E5)) // Medical blue
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, bottom: 1),
                                          child: Text(
                                              '\u{20B9} ${calDiscount(suggestionList[index].buyPrice ?? "", suggestionList[index].discount ?? "")} ${suggestionList[index].unit_type != null ? suggestionList[index].unit_type : ""}',
                                              style: TextStyle(
                                                color: Color(
                                                    0xff1E88E5), // Medical blue
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '(\u{20B9} ${suggestionList[index].buyPrice})',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                color: Color(
                                                        0xff42A5F5) // Lighter medical blue
                                                    .withOpacity(0.7),
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 0.0, right: 10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 0.0,
                                              height: 10.0,
                                            ),

//                                                   Column(
//                                                     children: <Widget>[
//                                                       Row(
//                                                         mainAxisAlignment: MainAxisAlignment.end,
//                                                         children: <Widget>[
//                                                           Container(
//                                                               height: 25,
//                                                               width: 35,
//                                                               child: Material(
//                                                                 color: GroceryAppColors.tela,
//                                                                 elevation: 0.0,
//                                                                 shape: RoundedRectangleBorder(
//                                                                   borderRadius: BorderRadius.all(
//                                                                     Radius.circular(15),
//                                                                   ),
//                                                                 ),
//                                                                 clipBehavior: Clip.antiAlias,
//                                                                 child: Padding(
//                                                                   padding: EdgeInsets.only(bottom: 10),
//                                                                   child: InkWell(
//                                                                       onTap: () {
//                                                                         print(suggestionList[index].count);
//                                                                         if (suggestionList[index].count != "1") {
//                                                                           setState(() {
// //                                                                                _count++;

//                                                                             String quantity = suggestionList[index].count;
//                                                                             int totalquantity = int.parse(quantity) - 1;
//                                                                             suggestionList[index].count = totalquantity.toString();
//                                                                           });
//                                                                         }

// //
//                                                                       },
//                                                                       child: Padding(
//                                                                         padding: EdgeInsets.only(
//                                                                           top: 10.0,
//                                                                         ),
//                                                                         child: Icon(
//                                                                           Icons.maximize,
//                                                                           size: 20,
//                                                                           color: Colors.white,
//                                                                         ),
//                                                                       )),
//                                                                 ),
//                                                               )),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
//                                                             child: Center(
//                                                               child: Text(
//                                                                   suggestionList[index].count != null ? '${suggestionList[index].count}' : '$_count',
//                                                                   style: TextStyle(
//                                                                       color: Colors.black,
//                                                                       fontSize: 19,
//                                                                       fontFamily: 'Roboto',
//                                                                       fontWeight: FontWeight.bold)),
//                                                             ),
//                                                           ),
//                                                           Container(
//                                                               margin: EdgeInsets.only(left: 3.0),
//                                                               height: 25,
//                                                               width: 35,
//                                                               child: Material(
//                                                                 color: GroceryAppColors.tela,
//                                                                 elevation: 0.0,
//                                                                 shape: RoundedRectangleBorder(
//                                                                   borderRadius: BorderRadius.all(
//                                                                     Radius.circular(15),
//                                                                   ),
//                                                                 ),
//                                                                 clipBehavior: Clip.antiAlias,
//                                                                 child: InkWell(
//                                                                   onTap: () {
//                                                                     if (int.parse(suggestionList[index].count) <=
//                                                                         int.parse(suggestionList[index].quantityInStock)) {
//                                                                       setState(() {
// //                                                                                _count++;

//                                                                         String quantity = suggestionList[index].count;
//                                                                         int totalquantity = int.parse(quantity) + 1;
//                                                                         suggestionList[index].count = totalquantity.toString();
//                                                                       });
//                                                                     } else {
//                                                                       showLongToast('Only  ${suggestionList[index].count}  products in stock ');
//                                                                     }
//                                                                   },
//                                                                   child: Icon(
//                                                                     Icons.add,
//                                                                     size: 20,
//                                                                     color: Colors.white,
//                                                                   ),
//                                                                 ),
//                                                               )),
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
                                            // SizedBox(width: 25,),

                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(
                                                            0xff1E88E5), // Medical blue
                                                        Color(
                                                            0xff42A5F5), // Lighter medical blue
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(
                                                                0xff1E88E5) // Medical blue
                                                            .withOpacity(0.3),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if (GroceryAppConstant
                                                            .isLogin) {
                                                          SharedPreferences
                                                              pref =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          String mrp_price = calDiscount(
                                                              suggestionList[
                                                                          index]
                                                                      .buyPrice ??
                                                                  "",
                                                              suggestionList[
                                                                          index]
                                                                      .discount ??
                                                                  "");
                                                          totalmrp =
                                                              double.parse(
                                                                  mrp_price);

                                                          double dicountValue =
                                                              double.parse(suggestionList[
                                                                              index]
                                                                          .buyPrice ??
                                                                      "") -
                                                                  totalmrp!;
                                                          String gst_sgst = calGst(
                                                              mrp_price,
                                                              suggestionList[
                                                                          index]
                                                                      .sgst ??
                                                                  "");
                                                          String gst_cgst = calGst(
                                                              mrp_price,
                                                              suggestionList[
                                                                          index]
                                                                      .cgst ??
                                                                  "");

                                                          String adiscount = calDiscount(
                                                              suggestionList[
                                                                          index]
                                                                      .buyPrice ??
                                                                  "",
                                                              suggestionList[index]
                                                                          .msrp !=
                                                                      null
                                                                  ? suggestionList[
                                                                              index]
                                                                          .msrp ??
                                                                      ""
                                                                  : "0");

                                                          admindiscountprice =
                                                              (double.parse(
                                                                      suggestionList[index]
                                                                              .buyPrice ??
                                                                          "") -
                                                                  double.parse(
                                                                      adiscount));

                                                          String color = "";
                                                          String size = "";
                                                          _addToproducts(
                                                              suggestionList[index]
                                                                      .productIs ??
                                                                  "",
                                                              suggestionList[
                                                                          index]
                                                                      .productName ??
                                                                  "",
                                                              suggestionList[
                                                                          index]
                                                                      .img ??
                                                                  "",
                                                              int
                                                                  .parse(
                                                                      mrp_price),
                                                              int
                                                                  .parse(
                                                                      suggestionList[
                                                                                  index]
                                                                              .count ??
                                                                          ""),
                                                              color,
                                                              size,
                                                              suggestionList[
                                                                          index]
                                                                      .productDescription ??
                                                                  "",
                                                              gst_sgst,
                                                              gst_cgst,
                                                              suggestionList[
                                                                          index]
                                                                      .discount ??
                                                                  "",
                                                              dicountValue
                                                                  .toString(),
                                                              suggestionList[
                                                                          index]
                                                                      .APMC ??
                                                                  "",
                                                              admindiscountprice
                                                                  .toString(),
                                                              suggestionList[
                                                                          index]
                                                                      .buyPrice ??
                                                                  "",
                                                              suggestionList[
                                                                          index]
                                                                      .shipping ??
                                                                  "",
                                                              suggestionList[
                                                                          index]
                                                                      .quantityInStock ??
                                                                  "");

                                                          setState(() {
                                                            GroceryAppConstant
                                                                .carditemCount++;
                                                            cartItemcount(
                                                                GroceryAppConstant
                                                                    .carditemCount);
                                                            AppConstent.cc++;

                                                            pref.setInt("cc",
                                                                AppConstent.cc);
                                                          });
                                                          // Navigator.of(
                                                          //         context)
                                                          //     .pushAndRemoveUntil(
                                                          //         MaterialPageRoute(
                                                          //           builder: (context) => GroceryApp(),
                                                          //         ),
                                                          //         (route) =>
                                                          //             false);
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SignInPage()),
                                                          );
                                                        }
                                                      },
                                                      child: Center(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    top: 8,
                                                                    bottom: 8,
                                                                    right: 20),
                                                            child: Center(
                                                              child: Text(
                                                                "Book",
                                                                style: TextStyle(
                                                                    color: GroceryAppColors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // Icon(Icons.add_shopping_cart,color: Colors.white,),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                  // double.parse(suggestionList[index].discount) > 0 ? showSticker(index, suggestionList) : Row()
                },
              ),
            ),
          ],
        ),
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

    returnStr = discount.toStringAsFixed(GroceryAppConstant.val);
    print(returnStr);
    return returnStr;
  }

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart? products1;
//cost_price=buyprice

  void _addToproducts(
      String pID,
      String p_name,
      String image,
      int price,
      int quantity,
      String c_val,
      String p_size,
      String p_disc,
      String sgst,
      String cgst,
      String discount,
      String dis_val,
      String adminper,
      String adminper_val,
      String cost_price,
      String shippingcharge,
      String totalQun) {
//      print(pID+"......");
//      print(p_name);
//      print(image);
//      print(price);
//      print(quantity);
//      print(c_val);
//      print(p_size);
//      print(p_disc);
//      print(sgst);
//      print(cgst);
//      print(discount);
//      print(dis_val);
//      print(adminper);
//      print(adminper_val);
//      print(cost_price);
    ProductsCart st = new ProductsCart(
        pid: pID,
        pname: p_name,
        pimage: image,
        pprice: (price * quantity).toString(),
        pQuantity: quantity,
        pcolor: c_val,
        psize: p_size,
        pdiscription: p_disc,
        sgst: sgst,
        cgst: cgst,
        discount: discount,
        discountValue: dis_val,
        adminper: adminper,
        adminpricevalue: adminper_val,
        costPrice: cost_price,
        shipping: shippingcharge,
        totalQuantity: totalQun);
    dbmanager.insertStudent(st).then((id) => {
          showLongToast(" Services  is added to cart "),
          print(' Added to Db ${id}')
        });
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    if (sgst.length > 1) {
      returnStr = discount.toString();
      double byprice1 = double.parse(byprice);
      print(sgst);

      double discount1 = double.parse(sgst);

      discount = ((byprice1 * discount1) / (100.0 + discount1));

      returnStr = discount.toStringAsFixed(2);
      print(returnStr);
      return returnStr;
    } else {
      return '0';
    }
  }
}

Future cartItemcount(int val) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  pref.setInt("itemCount", val);
  print(val.toString() + "shair....");
}

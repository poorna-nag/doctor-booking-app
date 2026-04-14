import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/grocery/Auth/signin.dart';
import 'package:ecoshine24/grocery/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:ecoshine24/grocery/screen/SearchScreen.dart';
import 'package:ecoshine24/grocery/screen/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  final String cat, title;
  const ProductList(this.cat, this.title) : super();

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showFab = true;
  int _current = 0;
  int total = 000;
  int actualprice = 200;
  double? mrp, totalmrp = 000;
  int _count = 1;
  int cc = 0;
  double? sgst1, cgst1, dicountValue, admindiscountprice;

  List<Products> products1 = [];
  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    setState(() {
      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
      }
      print(
          GroceryAppConstant.groceryAppCartItemCount.toString() + "itemCount");
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

  @override
  void initState() {
    super.initState();
    getcartCount();
    gatinfoCount();
    print(widget.title);

    if (widget.cat == "new") {
      DatabaseHelper.getTopProduct1(widget.cat, "1000").then((usersFromServe) {
        if (usersFromServe != null) {
          setState(() {
            products1 = usersFromServe;
          });
        }
      });
    } else if (widget.title == 'Featured Products') {
      DatabaseHelper.getfeature('yes', "100").then((usersFromServe) {
        setState(() {
          products1 = usersFromServe!;
        });
      });
    } else {
      // Fixed: getTopProduct(deals_type, category_id)
      // First parameter is deals type (empty for all), second is category ID
      DatabaseHelper.getTopProduct("", widget.cat).then((usersFromServe) {
        setState(() {
          products1 = usersFromServe!;
          print("${products1.length}itemCount");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1E88E5), // Medical blue from home screen
                    Color(0xff42A5F5), // Medical blue secondary
                    Color(0xff42A5F5), // Medical blue light
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1E88E5).withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserFilterDemo()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
            title: Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title.isEmpty ? "HealthCare Plus" : widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffF8FBFF), // Medical light background
                  Color(0xffEBF4FF), // Even lighter medical blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                // Medical Header Section
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xffF8FBFF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xff1E88E5).withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff1E88E5).withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xff1E88E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.medical_services_outlined,
                          color: Color(0xff1E88E5),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Medical Services",
                              style: TextStyle(
                                color: Color(0xff1E88E5),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Professional healthcare at your doorstep",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xff1E88E5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${products1.length} Services",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: products1.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: products1.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Color(0xffF8FBFF),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(
                                      color: Color(0xff1E88E5).withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xff1E88E5).withOpacity(0.15),
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    products1[index])),
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 12,
                                                left: 12,
                                                top: 12,
                                                bottom: 12),
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(18)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xff1E88E5)
                                                        .withOpacity(0.1),
                                                    Color(0xff42A5F5)
                                                        .withOpacity(0.1),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                border: Border.all(
                                                  color: Color(0xff1E88E5)
                                                      .withOpacity(0.3),
                                                  width: 2,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff1E88E5)
                                                        .withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      products1[index].img !=
                                                              null
                                                          ? GroceryAppConstant
                                                                  .Product_Imageurl +
                                                              products1[index]
                                                                  .img
                                                                  .toString()
                                                          : "https://www.bigwelt.com/manage/uploads/gallery/no-img.png",
                                                    ))),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      products1[index]
                                                                  .productName ==
                                                              null
                                                          ? 'Medical Service'
                                                          : products1[index]
                                                                  .productName ??
                                                              "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff2C3E50),
                                                        letterSpacing: 0.3,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 2.0,
                                                                bottom: 1),
                                                        child: Text(
                                                            '\u{20B9} ${calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "")} ${products1[index].unit_type != null ? "/" + products1[index].unit_type.toString() : ""}',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff1E88E5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '(\u{20B9} ${products1[index].buyPrice})',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .grey[500],
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 0.0,
                                                    height: 10.0,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0.0, right: 10),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          // Column(
                                                          //   children: <
                                                          //       Widget>[
                                                          //     Row(
                                                          //       mainAxisAlignment:
                                                          //           MainAxisAlignment
                                                          //               .end,
                                                          //       children: <
                                                          //           Widget>[
//                                                                       Container(
//                                                                           height:
//                                                                               25,
//                                                                           width:
//                                                                               35,
//                                                                           child:
//                                                                               Material(
//                                                                             color:
//                                                                                 GroceryAppColors.tela,
//                                                                             elevation:
//                                                                                 0.0,
//                                                                             shape:
//                                                                                 RoundedRectangleBorder(
//                                                                               borderRadius: BorderRadius.all(
//                                                                                 Radius.circular(15),
//                                                                               ),
//                                                                             ),
//                                                                             clipBehavior:
//                                                                                 Clip.antiAlias,
//                                                                             child:
//                                                                                 Padding(
//                                                                               padding: EdgeInsets.only(bottom: 10),
//                                                                               child: InkWell(
//                                                                                   onTap: () {
//                                                                                     print(products1[index].count);
//                                                                                     if (products1[index].count != "1") {
//                                                                                       setState(() {
// //                                                                                _count++;

//                                                                                         String quantity = products1[index].count ?? "";
//                                                                                         int totalquantity = int.parse(quantity) - 1;
//                                                                                         products1[index].count = totalquantity.toString();
//                                                                                       });
//                                                                                     }

// //
//                                                                                   },
//                                                                                   child: Padding(
//                                                                                     padding: EdgeInsets.only(
//                                                                                       top: 10.0,
//                                                                                     ),
//                                                                                     child: Icon(
//                                                                                       Icons.maximize,
//                                                                                       size: 20,
//                                                                                       color: Colors.white,
//                                                                                     ),
//                                                                                   )),
//                                                                             ),
//                                                                           )),
//                                                                       Padding(
//                                                                         padding: EdgeInsets.only(
//                                                                             top:
//                                                                                 0.0,
//                                                                             left:
//                                                                                 5.0,
//                                                                             right:
//                                                                                 5.0),
//                                                                         child:
//                                                                             Center(
//                                                                           child: Text(
//                                                                               products1[index].count != null ? '${products1[index].count}' : '$_count',
//                                                                               style: TextStyle(color: Colors.black, fontSize: 19, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
//                                                                         ),
//                                                                       ),
//                                                                       Container(
//                                                                           margin: EdgeInsets.only(
//                                                                               left:
//                                                                                   3.0),
//                                                                           height:
//                                                                               25,
//                                                                           width:
//                                                                               35,
//                                                                           child:
//                                                                               Material(
//                                                                             color:
//                                                                                 GroceryAppColors.tela,
//                                                                             elevation:
//                                                                                 0.0,
//                                                                             shape:
//                                                                                 RoundedRectangleBorder(
//                                                                               borderRadius: BorderRadius.all(
//                                                                                 Radius.circular(15),
//                                                                               ),
//                                                                             ),
//                                                                             clipBehavior:
//                                                                                 Clip.antiAlias,
//                                                                             child:
//                                                                                 InkWell(
//                                                                               onTap: () {
//                                                                                 if (int.parse(products1[index].count ?? "") < int.parse(products1[index].quantityInStock ?? "")) {
//                                                                                   setState(() {
// //                                                                                _count++;

//                                                                                     String quantity = products1[index].count ?? "";
//                                                                                     int totalquantity = int.parse(quantity) + 1;
//                                                                                     products1[index].count = totalquantity.toString();
//                                                                                   });
//                                                                                 } else {
//                                                                                   showLongToast('Only  ${products1[index].quantityInStock}  products in stock ');
//                                                                                 }
//                                                                               },
//                                                                               child: Icon(
//                                                                                 Icons.add,
//                                                                                 size: 20,
//                                                                                 color: Colors.white,
//                                                                               ),
//                                                                             ),
//                                                                           )),
//                                                                     ],
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                               // SizedBox(width: 10,),

                                                          Flexible(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: <Widget>[
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                            0xff1E88E5),
                                                                        Color(
                                                                            0xff42A5F5),
                                                                      ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(12)),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Color(0xff1E88E5)
                                                                            .withOpacity(0.3),
                                                                        blurRadius:
                                                                            8,
                                                                        offset: Offset(
                                                                            0,
                                                                            3),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        SharedPreferences
                                                                            pref =
                                                                            await SharedPreferences.getInstance();
                                                                        if (GroceryAppConstant
                                                                            .isLogin) {
                                                                          String
                                                                              mrp_price =
                                                                              calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "");
                                                                          totalmrp =
                                                                              double.parse(mrp_price);

                                                                          double
                                                                              dicountValue =
                                                                              double.parse(products1[index].buyPrice ?? "") - totalmrp!;
                                                                          String
                                                                              gst_sgst =
                                                                              calGst(mrp_price, products1[index].sgst ?? "");
                                                                          String
                                                                              gst_cgst =
                                                                              calGst(mrp_price, products1[index].cgst ?? "");

                                                                          String
                                                                              adiscount =
                                                                              calDiscount(products1[index].buyPrice ?? "", products1[index].msrp != null ? products1[index].msrp ?? "" : "0");

                                                                          admindiscountprice =
                                                                              (double.parse(products1[index].buyPrice ?? "") - double.parse(adiscount));

                                                                          String
                                                                              color =
                                                                              "";
                                                                          String
                                                                              size =
                                                                              "";
                                                                          _addToproducts(
                                                                            products1[index].productIs ??
                                                                                "",
                                                                            products1[index].productName ??
                                                                                "",
                                                                            products1[index].img ??
                                                                                "",
                                                                            int.parse(mrp_price),
                                                                            int.parse(products1[index].count ??
                                                                                ""),
                                                                            color,
                                                                            size,
                                                                            products1[index].productDescription ??
                                                                                "",
                                                                            gst_sgst,
                                                                            gst_cgst,
                                                                            products1[index].discount ??
                                                                                "",
                                                                            dicountValue.toString(),
                                                                            products1[index].APMC ??
                                                                                "",
                                                                            admindiscountprice.toString(),
                                                                            products1[index].buyPrice ??
                                                                                "",
                                                                            products1[index].shipping ??
                                                                                "",
                                                                            products1[index].quantityInStock ??
                                                                                "",
                                                                          );

                                                                          setState(
                                                                              () {
//                                                                              cartvalue++;
                                                                            GroceryAppConstant.groceryAppCartItemCount++;
                                                                            groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
                                                                          });
                                                                          setState(
                                                                              () {
                                                                            AppConstent.cc++;

                                                                            pref.setInt("cc",
                                                                                AppConstent.cc);
                                                                          });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                                        } else {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => SignInPage()),
                                                                          );
                                                                        }

//
                                                                      },
                                                                      child: Padding(
                                                                          padding: EdgeInsets.only(
                                                                            top:
                                                                                8,
                                                                            bottom:
                                                                                8,
                                                                          ),
                                                                          child: Center(
                                                                            child:
                                                                                Text(
                                                                              "Add Services",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.visible,
                                                                              style: TextStyle(color: GroceryAppColors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            // Icon(Icons.add_shopping_cart,color: Colors.white,),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5.0),
                                                            height: 40,
                                                            // width: 60,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xff42A5F5),
                                                                    Color(
                                                                        0xff1E88E5),
                                                                  ],
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xff42A5F5)
                                                                        .withOpacity(
                                                                            0.3),
                                                                    blurRadius:
                                                                        8,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            3),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Card(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 0.0,
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    SharedPreferences
                                                                        pref =
                                                                        await SharedPreferences
                                                                            .getInstance();
                                                                    if (GroceryAppConstant
                                                                        .isLogin) {
                                                                      if (num.parse(products1[index].quantityInStock ??
                                                                              '0') >
                                                                          0) {
                                                                        String mrp_price = calDiscount(
                                                                            products1[index].buyPrice ??
                                                                                "",
                                                                            products1[index].discount ??
                                                                                "");
                                                                        totalmrp =
                                                                            double.parse(mrp_price);
                                                                        double
                                                                            dicountValue =
                                                                            double.parse(products1[index].buyPrice ?? "") -
                                                                                totalmrp!;
                                                                        String gst_sgst = calGst(
                                                                            mrp_price,
                                                                            products1[index].sgst ??
                                                                                "");
                                                                        String gst_cgst = calGst(
                                                                            mrp_price,
                                                                            products1[index].cgst ??
                                                                                "");
                                                                        String adiscount = calDiscount(
                                                                            products1[index].buyPrice ??
                                                                                "",
                                                                            products1[index].msrp != null
                                                                                ? products1[index].msrp ?? ""
                                                                                : "0");
                                                                        admindiscountprice =
                                                                            (double.parse(products1[index].buyPrice ?? "") -
                                                                                double.parse(adiscount));
                                                                        String
                                                                            color =
                                                                            "";
                                                                        String
                                                                            size =
                                                                            "";
                                                                        _addToproducts1(
                                                                            products1[index].productIs ??
                                                                                "",
                                                                            products1[index].productName ??
                                                                                "",
                                                                            products1[index].img ??
                                                                                "",
                                                                            int.parse(
                                                                                mrp_price),
                                                                            int.parse(products1[index].count ??
                                                                                ""),
                                                                            color,
                                                                            size,
                                                                            products1[index].productDescription ??
                                                                                "",
                                                                            gst_sgst,
                                                                            gst_cgst,
                                                                            products1[index].discount ??
                                                                                "",
                                                                            dicountValue
                                                                                .toString(),
                                                                            products1[index].APMC ??
                                                                                "",
                                                                            admindiscountprice
                                                                                .toString(),
                                                                            products1[index].buyPrice ??
                                                                                "",
                                                                            products1[index].shipping ??
                                                                                "",
                                                                            products1[index].quantityInStock ??
                                                                                "",
                                                                            products1[index].youtube ??
                                                                                "",
                                                                            products1[index].mv ??
                                                                                "");
                                                                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        //   content: Text("Service added to cart"),
                                                                        //   backgroundColor: Colors.green,
                                                                        //   behavior: SnackBarBehavior.floating,
                                                                        // ));
                                                                        await Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => WishList()),
                                                                        );
                                                                        setState(
                                                                            () {});
                                                                        // Navigator.push(
                                                                        //   context,
                                                                        //   MaterialPageRoute(builder: (context) => ShowAddress("0")),
                                                                        // );
                                                                        // setState(() {
                                                                        //                 AppConstant.cc++;
                                                                        //   Constant.carditemCount++;
                                                                        //   cartItemcount(Constant.carditemCount);
                                                                        // });
                                                                        // Navigator.push(
                                                                        //   context,
                                                                        //   MaterialPageRoute(builder: (context) => MyApp1()),
                                                                        // );
                                                                      } else {
                                                                        showLongToast(
                                                                            "Product is out of stock");
                                                                      }
                                                                    } else {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SignInPage()),
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                        // left: 8,
                                                                        top: 8,
                                                                        bottom:
                                                                            8,
                                                                        // right: 8
                                                                      ),
                                                                      child: Center(
                                                                        child:
                                                                            Text(
                                                                          "Book Now",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.visible,
                                                                          style: TextStyle(
                                                                              color: GroceryAppColors.white,
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        // Icon(Icons.add_shopping_cart,color: Colors.white,),
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                          ))
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
                                ),
                                double.parse(products1[index].discount ?? "") >
                                        0
                                    ? showSticker(index, products1)
                                    : Row(),
                              ],
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),

          /*
        }
      )*/
        ));
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

  ProductsCart? products2;
//cost_price=buyprice

  void _addToproducts1(
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
      String totalQun,
      String varient,
      String mv) {
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
        totalQuantity: totalQun,
        varient: varient,
        mv: int.parse(mv));
    dbmanager.getProductList1(pID).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          if (usersFromServe.length > 0) {
            products2 = usersFromServe[0];
            st.quantity = products2!.quantity + st.quantity;
            st.pprice =
                (double.parse(products2!.pprice ?? "") + (totalmrp! * quantity))
                    .toString();

            st.quantity++;
            if (st.quantity <= int.parse(totalQun)) {
              dbmanager.updateStudent1(st).then((id) => {
                    showLongToast(' Services added your cart'),
                  });
            } else {
              showLongToast(' Services added your cart');
            }
          } else {
            dbmanager.insertStudent(st).then((id) => {
                  showLongToast("Products is upadated to cart ' "),
                  setState(() {
                    GroceryAppConstant.groceryAppCartItemCount++;
                    groceryCartItemCount(
                        GroceryAppConstant.groceryAppCartItemCount);
                  })
                });
          }
        });
      }
    });
  }

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
    if (products2 == null) {
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

  // Medical themed discount sticker matching home screen
  Widget showSticker(int index, List<Products> products) {
    return Positioned(
      top: 12,
      right: 20,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1E88E5),
              Color(0xff42A5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E88E5).withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          "${products[index].discount}% OFF",
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

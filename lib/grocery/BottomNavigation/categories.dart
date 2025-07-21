import 'dart:developer';
import 'dart:io';
import 'package:aladdinmart/Auth/signin.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/model/CategaryModal.dart';
import 'package:aladdinmart/grocery/screen/SearchScreen.dart';
import 'package:aladdinmart/grocery/screen/detailpage.dart';
import 'package:aladdinmart/grocery/screen/secondtabview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constent/app_constent.dart';
import '../../model/productmodel.dart';

class Cgategorywise extends StatefulWidget {
  final String id;
  final bool appbar;
  Cgategorywise(this.id, this.appbar);

  @override
  _CgategorywiseState createState() => _CgategorywiseState();
}

class _CgategorywiseState extends State<Cgategorywise> {
  List<Categary> cat_list = [];
  List<Categary> sub_cat_list = [];
  bool flag = false;
  int _selectedIndex = 0;
  int grid = -1;
  String id = "";
  String id2 = "";
  List<Products> products1 = [];
  List<Categary> list1 = [];
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  double? mrp, totalmrp = 000;
  void initState() {
    super.initState();
    getData("0").then((usersFromServe) {
      setState(() {
        list1 = usersFromServe!;
        id2 = list1[0].pcatId!;
        log(" =======>>$id2");
      });
    });
  }

  exitWillspop() async {
    await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Do you really want to exit'),
              actions: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () => {
                    exit(0),
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbar
          ? AppBar(
              backgroundColor: GroceryAppColors.tela,
              title: Text('Categories'),
            )
          : null,
      backgroundColor: GroceryAppColors.white,
      body: Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              color: Color.fromARGB(255, 255, 255, 255),
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                  future: getData("0"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            Categary item = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                if (grid != index) {
                                  GridShowColor(index);

                                  setState(() {
                                    _selectedIndex = index;
                                    products1 = [];
                                    grid = index;
                                    id = item.pcatId!;
                                    id2 = item.pcatId!;
                                  });
                                  // loadData(cat_list[index].pcatId);
                                } else {
                                  setState(() {
                                    grid = -1;
                                    _selectedIndex = index;
                                    // loadData(cat_list[index].pcatId);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : Colors.white,
                                ),
                                padding: EdgeInsets.only(left: 5),
                                margin: EdgeInsets.only(left: 3),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 75,
                                        child: Column(
                                          children: [
                                            Stack(children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //     color: GroceryAppColors.tela,
                                                  //     width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: new SizedBox(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  child: item.img!.length > 0
                                                      ? Image.network(
                                                          GroceryAppConstant
                                                                  .base_url +
                                                              "manage/uploads/p_category/" +
                                                              item.img!,
                                                          fit: BoxFit.fill)
                                                      : Image.asset(
                                                          "assets/images/logo.png"),
                                                ),
                                              ),
                                              // Container(
                                              //   margin:
                                              //       EdgeInsets.only(top: 5),
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(
                                              //             20),
                                              //   ),
                                              //   child: CircleAvatar(
                                              //     radius: 25,
                                              //     backgroundColor:
                                              //         GroceryAppColors
                                              //             .white
                                              //             .withOpacity(0.0),
                                              //   ),
                                              // ),
                                            ]),
                                            Container(
                                                alignment: Alignment.center,
                                                height: 50,
                                                child: Text(
                                                  item.pCats!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          _selectedIndex ==
                                                                  index
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                      fontSize: 13),
                                                )),
                                          ],
                                        )),
                                    _selectedIndex == index
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              color: GroceryAppColors.tela,
                                            ),
                                            height: 100,
                                            width: 6,
                                          )
                                        : Row()
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: snapshot.data?.length == null
                              ? 0
                              : snapshot.data?.length,
                        ),
                      );
                    }
                    return Container(
                      color: Color(0xfff3f5f5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 85,
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.white,
                            ),
                            padding: EdgeInsets.only(left: 5),
                            margin: EdgeInsets.only(left: 3),
                            child: Row(
                              children: [
                                Container(
                                    width: 75,
                                    child: Column(
                                      children: [
                                        Stack(children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ClipOval(
                                              child: new SizedBox(
                                                width: 40.0,
                                                height: 40.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: GroceryAppColors
                                                  .tela
                                                  .withOpacity(0.24),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    )),
                                _selectedIndex == index
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          color: GroceryAppColors.tela,
                                        ),
                                        height: 100,
                                        width: 6,
                                      )
                                    : Row()
                              ],
                            ),
                          );
                        },
                        itemCount: 10,
                      ),
                    );
                    // Center(child: CircularProgressIndicator());
                  }),
            ),
            grid == _selectedIndex
                ? Expanded(
                    child: Container(
                        color: Color(0xfff3f5f5),
                        child: FutureBuilder(
                            future: catby_productData(id!, "0"),
                            builder: (context, snapshot) {
                              print(id! + "pcatid");
                              var datanew = snapshot.data;
                              if (snapshot.hasData) {
                                return snapshot.data == null
                                    ? shimmer()
                                    // Center(
                                    //     child: CircularProgressIndicator())
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 4,
                                              crossAxisSpacing: 2,
                                              crossAxisCount: 2,
                                              mainAxisExtent: 260,
                                            ),
                                            itemCount: datanew?.length,
                                            itemBuilder: (context, index) {
                                              var data = datanew![index];
                                              return data.img!.length > 0
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xfff3f5f5),
                                                        // border: Border.all(
                                                        //     width: 0.8,
                                                        //     color: Colors.grey[300])
                                                      ),
                                                      // color: Colors.white,
                                                      // width: 155,
                                                      // margin:
                                                      //     EdgeInsets.only(right: 12, bottom: 8),
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        elevation: 0,
                                                        child: Column(
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProductDetails(
                                                                              data)),
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                height: 130,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    imageUrl: GroceryAppConstant
                                                                            .Product_Imageurl +
                                                                        data.img!!,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        new Icon(
                                                                            Icons.error),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            2,
                                                                        top: 5),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 3,
                                                                        right:
                                                                            5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: GroceryAppColors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(10),
                                                                          bottomRight:
                                                                              Radius.circular(10),
                                                                        )),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        data.productName!!,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                GroceryAppColors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                      data.unit_type!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: GroceryAppColors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 12.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                '\u{20B9} ${data.buyPrice!}',
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 0.0, bottom: 6),
                                                                                child: Text('\u{20B9} ${calDiscount(data.buyPrice!, data.discount!)}', style: TextStyle(color: GroceryAppColors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              right: 2.0,
                                                                              top: 20),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              SharedPreferences pref = await SharedPreferences.getInstance();
                                                                              String? mv = pref.getString(
                                                                                "mvid",
                                                                              );
                                                                              if (GroceryAppConstant.isLogin) {
                                                                                pref.setString("mvid", data.mv!);
                                                                                print(pref.getString("mvid"));

                                                                                String mrp_price = calDiscount(data.buyPrice!, data.discount!);
                                                                                totalmrp = double.parse(mrp_price);

                                                                                double dicountValue = double.parse(data.buyPrice!) - totalmrp!;
                                                                                String gst_sgst = calGst(mrp_price, data.sgst!);
                                                                                String gst_cgst = calGst(mrp_price, data.cgst!);

                                                                                String adiscount = calDiscount(data.buyPrice!, data.msrp! != null ? data.msrp! : "0");

                                                                                admindiscountprice = (double.parse(data.buyPrice!) - double.parse(adiscount));

                                                                                String color = "";
                                                                                String size = "";

                                                                                // String mv=  pref.getString("mvid",);

                                                                                _addToproducts1(data.productIs!, data.productName!, data.img!, int.parse(mrp_price), int.parse(data.count!), color, size, data.productDescription!, gst_sgst, gst_cgst, data.discount!, dicountValue.toString(), data.APMC!, admindiscountprice.toString(), data.buyPrice!, data.shipping!, data.quantityInStock!, data.youtube!, data.mv!);
                                                                                setState(() {});
                                                                              } else {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) => SignInPage()),
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                  color: GroceryAppColors.tela1.withOpacity(0.1),
                                                                                  borderRadius: BorderRadius.circular(6),
                                                                                  border: Border.all(
                                                                                    color: GroceryAppColors.tela1,
                                                                                    width: 1,
                                                                                  )),
                                                                              height: 24,
                                                                              width: 64,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Book",
                                                                                  style: TextStyle(fontSize: 14, color: GroceryAppColors.tela1),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //     Container(
                                                                            //   height: 40,
                                                                            //   width: 40,
                                                                            //   child: Card(
                                                                            //     elevation:
                                                                            //         5,
                                                                            //     shape:
                                                                            //         RoundedRectangleBorder(
                                                                            //       borderRadius:
                                                                            //           BorderRadius.circular(
                                                                            //               5),
                                                                            //     ),
                                                                            //     child: Icon(
                                                                            //       Icons.add,
                                                                            //       color: GroceryAppColors
                                                                            //           .tela,
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      "assets/images/logo.png",
                                                      height: 35,
                                                      width: 35,
                                                    );
                                            }),
                                      );
                              } else {
                                Center(
                                  child: Text('Products not available'),
                                );
                              }
                              return shimmer();
                              // Center(
                              //   child: CircularProgressIndicator(),
                              // );
                            })))
                : Expanded(
                    child: Container(
                        color: Color(0xfff3f5f5),
                        child: FutureBuilder(
                            future: catby_productData(id2!, "0"),
                            builder: (context, snapshot) {
                              // print(id + "pcatid");
                              var datanew = snapshot.data;
                              if (snapshot.hasData) {
                                return snapshot.data == null
                                    ? shimmer()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 4,
                                              crossAxisSpacing: 2,
                                              crossAxisCount: 2,
                                              mainAxisExtent: 260,
                                            ),
                                            itemCount: datanew!.length,
                                            itemBuilder: (context, index) {
                                              var data = datanew[index];
                                              return data.img!.length > 0
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xfff3f5f5),
                                                        // border: Border.all(
                                                        //     width: 0.8,
                                                        //     color: Colors.grey[300])
                                                      ),
                                                      // color: Colors.white,
                                                      // width: 155,
                                                      // margin:
                                                      //     EdgeInsets.only(right: 12, bottom: 8),
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        elevation: 0,
                                                        child: Column(
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProductDetails(
                                                                              data)),
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                height: 130,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    imageUrl: GroceryAppConstant
                                                                            .Product_Imageurl +
                                                                        data.img!!,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        new Icon(
                                                                            Icons.error),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            2,
                                                                        top: 5),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 3,
                                                                        right:
                                                                            5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: GroceryAppColors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(10),
                                                                          bottomRight:
                                                                              Radius.circular(10),
                                                                        )),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        data.productName!!,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                GroceryAppColors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                      data.unit_type!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: GroceryAppColors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 12.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                '\u{20B9} ${data.buyPrice!}',
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 0.0, bottom: 6),
                                                                                child: Text('\u{20B9} ${calDiscount(data.buyPrice!, data.discount!)}', style: TextStyle(color: GroceryAppColors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              right: 2.0,
                                                                              top: 20),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              SharedPreferences pref = await SharedPreferences.getInstance();
                                                                              String? mv = pref.getString(
                                                                                "mvid",
                                                                              );
                                                                              if (GroceryAppConstant.isLogin) {
                                                                                pref.setString("mvid", data.mv!);
                                                                                print(pref.getString("mvid"));

                                                                                String mrp_price = calDiscount(data.buyPrice!, data.discount!);
                                                                                totalmrp = double.parse(mrp_price);

                                                                                double dicountValue = double.parse(data.buyPrice!) - totalmrp!;
                                                                                String gst_sgst = calGst(mrp_price, data.sgst!);
                                                                                String gst_cgst = calGst(mrp_price, data.cgst!);

                                                                                String adiscount = calDiscount(data.buyPrice!, data.msrp! != null ? data.msrp! : "0");

                                                                                admindiscountprice = (double.parse(data.buyPrice!) - double.parse(adiscount));

                                                                                String color = "";
                                                                                String size = "";

                                                                                // String mv=  pref.getString("mvid",);

                                                                                _addToproducts1(data.productIs!, data.productName!, data.img!, int.parse(mrp_price), int.parse(data.count!), color, size, data.productDescription!, gst_sgst, gst_cgst, data.discount!, dicountValue.toString(), data.APMC!, admindiscountprice.toString(), data.buyPrice!, data.shipping!, data.quantityInStock!, data.youtube!, data.mv!);
                                                                                setState(() {});
                                                                              } else {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) => SignInPage()),
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                  color: GroceryAppColors.tela1.withOpacity(0.1),
                                                                                  borderRadius: BorderRadius.circular(6),
                                                                                  border: Border.all(
                                                                                    color: GroceryAppColors.tela1,
                                                                                    width: 1,
                                                                                  )),
                                                                              height: 24,
                                                                              width: 64,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Book",
                                                                                  style: TextStyle(fontSize: 14, color: GroceryAppColors.tela1),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //     Container(
                                                                            //   height: 40,
                                                                            //   width: 40,
                                                                            //   child: Card(
                                                                            //     elevation:
                                                                            //         5,
                                                                            //     shape:
                                                                            //         RoundedRectangleBorder(
                                                                            //       borderRadius:
                                                                            //           BorderRadius.circular(
                                                                            //               5),
                                                                            //     ),
                                                                            //     child: Icon(
                                                                            //       Icons.add,
                                                                            //       color: GroceryAppColors
                                                                            //           .tela,
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      "assets/images/logo.png",
                                                      height: 35,
                                                      width: 35,
                                                    );
                                            }),
                                      );
                              } else {
                                Center(
                                  child: Text('Products Not Available'),
                                );
                              }
                              return shimmer();
                            })))
          ],
        ),
      ),
    );
  }

  int val = -1;

  ShowColor(int index) {
    setState(() {
      val = index;
    });
  }

  GridShowColor(int index) {
    setState(() {
      grid = index;
    });
  }

  Widget show_catnam() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: GroceryAppColors.tela1),
          color: GroceryAppColors.white),
      width: 120,
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Screen2(
                                  cat_list[index].pcatId,
                                  cat_list[index].pCats)),
                        );
                        ShowColor(index);
                      },
                      child: Container(
                        color: val == index
                            ? GroceryAppColors.tela1
                            : GroceryAppColors.white,
                        width: 93,
                        height: 40,
                        child: Center(
                          child: Text(
                            cat_list[index].pCats!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: val == index
                                    ? GroceryAppColors.white
                                    : GroceryAppColors.black),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          //getlistval(cat_list[index].pcatId);
                          flag = true;
                          ShowColor(index);
                        });
                      },
                      child: Container(
                          // padding:EdgeInsets.all(1),
                          child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 25,
                        color: GroceryAppColors.black,
                      )),
                    )
                  ],
                ),
                Divider(
                  color: GroceryAppColors.tela1,
                ),
              ],
            );
          }),
    );
  }

  Widget show_cat_subnam() {
    return Container(
      // width: 150,
      margin: EdgeInsets.only(left: 100),
      child: ListView.builder(
          // separatorBuilder: (context, index) => Divider(
          //   color: Colors.grey,
          // ),
          shrinkWrap: true,
          primary: false,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: sub_cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5, right: 5),
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    // color: Colors.grey,
                    child: ListTile(
                      title: Text(
                        sub_cat_list[index].pCats!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: GroceryAppColors.black, fontSize: 12),
                      ),
                      trailing: Icon(
                        grid != index
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: GroceryAppColors.black,
                      ),
                      onTap: () {
                        if (grid != index) {
                          GridShowColor(index);
                        } else {
                          setState(() {
                            grid = -1;
                          });
                        }
                      },
                    )

                    // Text(sub_cat_list[index].pCats,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: GroceryAppColors.black),) ,
                    ),
                Divider(
                  color: GroceryAppColors.black,
                ),
                grid == index
                    ? Container(
                        color: GroceryAppColors.tela1,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        // height: 90,
                        child: FutureBuilder(
                            future: getData(sub_cat_list[index].pcatId!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: GridView.builder(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                      left: 6,
                                      right: 6,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemBuilder: (context, index) {
                                      Categary item = snapshot.data![index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Screen2(
                                                    item.pcatId, item.pCats)),
                                          );
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.white,
                                                  child: ClipOval(
                                                    child: new SizedBox(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      child: item.img!.length >
                                                              0
                                                          ? Image.network(
                                                              GroceryAppConstant
                                                                      .base_url +
                                                                  "manage/uploads/p_category/" +
                                                                  item.img!,
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              "assets/images/logo.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  item.pCats!,
                                                  maxLines: 2,
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data!.length == null
                                        ? 0
                                        : snapshot.data!.length,
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      )
                    : Row(),
              ],
            );
          }),
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

  late ProductsCart products4;
//cost_price=buyprice
  final DbProductManager dbmanager2 = new DbProductManager();
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
        pcolor: c_val ?? "",
        psize: p_size ?? "",
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
    dbmanager2.getProductList1(pID).then((usersFromServe) async {
      // SharedPreferences prefer = await SharedPreferences.getInstance();
      SharedPreferences prefers = await SharedPreferences.getInstance();
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (this.mounted) {
        setState(() {
          if (usersFromServe.length > 0) {
            products4 = usersFromServe[0];
            st.quantity = products4.quantity + st.quantity;
            st.pprice =
                (double.parse(products4.pprice!) + (totalmrp! * quantity))
                    .toString();

            // st.quantity++;
            if (st.quantity <= int.parse(totalQun)) {
              dbmanager2.updateStudent1(st).then((id) => {
                    setState(() {}),
                    print("2/////////"),
                    showLongToast('Service added to your cart '),
                  });
            } else {
              showLongToast('Service added to your cart 3rd ');
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishList(),
                ),
              );*/
            }
          } else {
            dbmanager2.insertStudent(st).then((id) => {
                  // SharedPreferences prefer =
                  //           await SharedPreferences.getInstance(),
                  setState(() {
                    GroceryAppConstant.carditemCount++;
                    cartItemcount(GroceryAppConstant.carditemCount);
                    AppConstent.cc++;

                    pref.setInt("cc", AppConstent.cc);
                    // CartConstent.cc++;
                    // print("4/////////");
                    // prefers.setInt("cc", CartConstent.cc);
                  }),
                  showLongToast('Serviceadded to your cart '),
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WishList(),
                    ),
                  ),*/
                });
          }
        });
      }
    });
  }

  shimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            crossAxisCount: 2,
            mainAxisExtent: 250,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: GroceryAppColors.white,
              ),
              child: Card(
                color: GroceryAppColors.tela.withOpacity(0.24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            );
          }),
    );
  }
}

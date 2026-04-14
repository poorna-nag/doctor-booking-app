// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ecoshine24/Auth/signin.dart';
// import 'package:ecoshine24/BottomNavigation/wishlist.dart';
// import 'package:ecoshine24/General/AppConstant.dart';
// import 'package:ecoshine24/dbhelper/CarrtDbhelper.dart';
// import 'package:ecoshine24/dbhelper/database_helper.dart';
// import 'package:ecoshine24/dbhelper/wishlistdart.dart';
// import 'package:ecoshine24/model/Gallerymodel.dart';
// import 'package:ecoshine24/model/GroupProducts.dart';
// import 'package:ecoshine24/model/Varient.dart';
// import 'package:ecoshine24/model/productmodel.dart';
// import 'package:ecoshine24/screen/detailpage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../grocery/screen/Zoomimage.dart';

// class ProductDetails1 extends StatefulWidget {
//   final String id;
//   const ProductDetails1(this.id) : super();

//   @override
//   _ProductDetailsState createState() => _ProductDetailsState();
// }

// class _ProductDetailsState extends State<ProductDetails1> {
//   List<PVariant> pvarlist = [];
//   String name = "";
//   String textval = "Select varient";
//   _displayDialog(BuildContext context, int position) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             scrollable: true,
//             title: Text('Select Variant'),
//             content: Container(
//               width: double.maxFinite,
//               height: pvarlist.length * 50.0,
//               child: ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: pvarlist.length == null ? 0 : pvarlist.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Container(
//                       width: pvarlist[index] != 0 ? 130.0 : 230.0,
//                       color: Colors.white,
//                       margin: EdgeInsets.only(right: 10),
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             total = int.parse(pvarlist[index].price ?? "");
//                             String mrp_price = calDiscount(
//                                 pvarlist[index].price ?? "",
//                                 pvarlist[index].discount ?? "");
//                             totalmrp = double.parse(mrp_price);
//                             textval = pvarlist[index].variant ?? "";
//                             name = pvarlist[index].variant ?? "";
//                             // imgList1[position].

//                             Navigator.pop(context);
//                           });
//                         },
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(left: 10, right: 10),
//                               child: Text(
//                                 pvarlist[index].variant ?? "",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: FoodAppColors.black,
//                                 ),
//                               ),
//                             ),
//                             Divider(
//                               color: FoodAppColors.black,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             actions: <Widget>[
//               new TextButton(
//                 child: new Text('CANCEL'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   }

//   int _current = 0;
//   bool flag = true;
//   bool wishflag = true;
//   int? wishid;
//   String? url;
//   List<Products> products1 = [];
//   List<String> catid = [];

//   final List<String> imgList1 = [
//     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   ];
//   List<GroupProducts> group = [];

//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }

//   int _count = 1;
//   String? _dropDownValue, groupname = "";
//   String? _dropDownValue1;
//   int? total;
//   int actualprice = 200;
//   double? mrp, totalmrp;
//   double? sgst1, cgst1, dicountValue, admindiscountprice;
//   List<String>? size;
//   List<String>? color;

//   List<Gallery> galiryImage1 = [];
//   List<Products> productdetails = [];
//   ProductsCart? products;
//   Products? prod;
//   final DbProductManager dbmanager = new DbProductManager();

// //  DatabaseHelper helper = DatabaseHelper();
// //  Note note ;

//   void gatinfoCount() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     int? Count = pref.getInt("itemCount");
//     bool? ligin = pref.getBool("isLogin");

//     setState(() {
//       FoodAppConstant.isLogin = ligin!;

//       if (Count == null) {
//         FoodAppConstant.foodAppCartItemCount = 0;
//       } else {
//         FoodAppConstant.foodAppCartItemCount = Count;
//       }
// //      print(Constant.carditemCount.toString()+"itemCount");
//     });
//   }

//   String? id;
//   @override
//   void initState() {
//     super.initState();

//     gatinfoCount();
//     productdetail(widget.id).then((usersFromServe) {
//       setState(() {
//         productdetails = usersFromServe!;
//         if (productdetails.length > 0) {
//           setState(() {
//             url = productdetails[0].img;
//             id = productdetails[0].productIs;
//             actualprice = int.parse(productdetails[0].buyPrice ?? "");
//             total = actualprice;

//             String mrp_price = calDiscount(productdetails[0].buyPrice ?? "",
//                 productdetails[0].discount ?? "");
//             totalmrp = double.parse(mrp_price);

//             String adiscount = calDiscount(
//                 productdetails[0].buyPrice ?? "", productdetails[0].msrp ?? "");
//             admindiscountprice =
//                 (double.parse(productdetails[0].buyPrice ?? "") -
//                     double.parse(adiscount));
//             dicountValue =
//                 double.parse(productdetails[0].buyPrice ?? "") - totalmrp!;
//             String gst_sgst =
//                 calGst(totalmrp.toString(), productdetails[0].sgst ?? "");
//             String gst_cgst =
//                 calGst(totalmrp.toString(), productdetails[0].cgst ?? "");
//             color = productdetails[0].productColor!.split(',');
//             size = productdetails[0].productScale!.split(',');

//             sgst1 = double.parse(gst_sgst);
//             cgst1 = double.parse(gst_cgst);
//             print(productdetails[0].productLine! + "product id");
//             catid = productdetails[0].productLine!.split(',');
//             catby_productData(catid.length > 0 ? catid[0] : "0", "0",
//                     productdetails[0].mv ?? "")
//                 .then((usersFromServe) {
//               setState(() {
//                 products1 = usersFromServe!;
//               });
//             });

//             GroupPro(productdetails[0].productIs ?? "").then((usersFromServe) {
//               setState(() {
//                 group = usersFromServe!;
//                 group != null ? groupname = group[0].name : groupname = "";
//               });
//             });

//             dbmanager1.getProductList().then((usersFromServe) {
//               setState(() {
//                 prodctlist1 = usersFromServe;
//                 for (var i = 0; i < prodctlist1!.length; i++) {
//                   if (prodctlist1![i].pid == id) {
//                     wishflag = false;
//                     wishid = prodctlist1![i].id;
//                     break;
//                   }
//                 }
//               });
//             });
//           });
//         }
//       });
//     });
//     DatabaseHelper.getImage(widget.id).then((usersFromServe) {
//       setState(() {
//         galiryImage1 = usersFromServe!;
//         imgList1.clear();
//         for (var i = 0; i < galiryImage1.length; i++) {
//           imgList1.add(galiryImage1[i].img ?? "");
//         }
//       });
//     });

//     getPvarient(widget.id).then((usersFromServe) {
//       setState(() {
//         pvarlist = usersFromServe!;
//       });
//     });
//   }

//   bool showdis = false;

//   static List<WishlistsCart>? prodctlist1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: FoodAppColors.tela1,
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: FoodAppColors.tela,
//         title: Text(
//           "Service Details",
//           style: TextStyle(color: FoodAppColors.white),
//         ),
//         actions: <Widget>[
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => WishList()),
//               );
//             },
//             child: Stack(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(right: 40, top: 17),
//                   child: Icon(
//                     Icons.add_shopping_cart,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
// //                showCircle(),

//                 Align(
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 15, bottom: 18),
//                     child: Container(
//                       padding: const EdgeInsets.all(5.0),
//                       decoration: new BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: FoodAppColors.telamoredeep,
//                       ),
//                       child: Text('${FoodAppConstant.foodAppCartItemCount}',
//                           style:
//                               TextStyle(color: Colors.white, fontSize: 15.0)),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         color: FoodAppColors.tela1,
//         child: SafeArea(
//             top: false,
//             left: false,
//             right: false,
//             child: CustomScrollView(slivers: <Widget>[
//               SliverList(
//                 // Use a delegate to build items as they're scrolled on screen.
//                 delegate: SliverChildBuilderDelegate(
//                   // The builder function returns a ListTile with a title that
//                   // displays the index of the current item.
//                   (context, index) => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       imgList1 != null
//                           ? imgList1.length > 0
//                               ? Container(
//                                   // height: MediaQuery.of(context).size.height/2.6,
//                                   child: CarouselSlider.builder(
//                                       itemCount: imgList1.length,
//                                       options: CarouselOptions(
//                                         aspectRatio: 2.0,
//                                         enlargeCenterPage: true,
//                                         autoPlay: true,
//                                       ),
//                                       itemBuilder: (ctx, index, realIdx) {
//                                         return InkWell(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ZoomImage(imgList1)),
//                                             );
//                                           },
//                                           child: Container(
//                                             decoration: new BoxDecoration(
//                                               color: FoodAppColors.tela1,
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                             ),
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             child: Container(
//                                                 margin: EdgeInsets.all(5.0),
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(8.0)),
//                                                   child:
//                                                       /*Image.network(
//                                                 Constant.Product_Imageurl+imgUrl,
//                                                   fit: BoxFit.fill,
//                                               ),*/
//                                                       CachedNetworkImage(
//                                                     fit: BoxFit.fill,
//                                                     imageUrl: FoodAppConstant
//                                                             .Product_Imageurl2 +
//                                                         imgList1[index],
//                                                     placeholder: (context,
//                                                             url) =>
//                                                         Center(
//                                                             child:
//                                                                 CircularProgressIndicator()),
//                                                     errorWidget: (context, url,
//                                                             error) =>
//                                                         new Icon(Icons.error),
//                                                   ),
//                                                 )),
//                                           ),
//                                         );
//                                       }))
//                               : Row()
//                           : Row(),
//                       FutureBuilder(
//                           future: productdetail(widget.id),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               return snapshot.data == null
//                                   ? Center(
//                                       child: CircularProgressIndicator(),
//                                     )
//                                   : ListView.builder(
//                                       itemCount: snapshot.data!.length == null
//                                           ? 0
//                                           : snapshot.data!.length,
//                                       shrinkWrap: true,
//                                       primary: false,
//                                       scrollDirection: Axis.vertical,
//                                       itemBuilder:
//                                           (BuildContext context, int index) {
//                                         Products item = snapshot.data![index];
//                                         return Container(
//                                           child: Column(
//                                             children: <Widget>[
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: map<Widget>(imgList1,
//                                                     (index, url) {
//                                                   return Container(
//                                                     width: 25.0,
//                                                     height: 0.0,
//                                                     child: Container(
//                                                       child: Divider(
//                                                         height: 20,
//                                                         color: _current == index
//                                                             ? Colors.orange
//                                                             : Colors.grey,

//                                                         thickness: 2.0,
// //                                  endIndent: 30.0,
//                                                       ),
//                                                     ),
//                                                     margin:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 4.0,
//                                                             vertical: 7.0),
// //                                decoration: BoxDecoration(
// //                                  shape: BoxShape.rectangle,
// //                                  color: _current == index ? Colors.orange : Colors.grey,
// //                                ),
//                                                   );
//                                                 }),
//                                               ),

// //                          productName1(),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10.0,
//                                                     bottom: 5,
//                                                     left: 10),
//                                                 child: Text(
//                                                     '${name = item.productName ?? ""}',
//                                                     style: TextStyle(
//                                                       color: FoodAppColors
//                                                           .product_title_name,
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                     )),
//                                               ),
//                                               SizedBox(
//                                                 height: 20,
//                                               ),

//                                               Container(
//                                                 margin: EdgeInsets.only(
//                                                     left: 20,
//                                                     top: 10,
//                                                     right: 50),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: <Widget>[
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 2.0,
//                                                               bottom: 1),
//                                                       child: Text(
//                                                           '\u{20B9} ${total}',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w700,
//                                                               fontStyle:
//                                                                   FontStyle
//                                                                       .italic,
//                                                               color:
//                                                                   FoodAppColors
//                                                                       .mrp,
//                                                               decoration:
//                                                                   TextDecoration
//                                                                       .lineThrough)),
//                                                     ),
// //                               priceold(),
//                                                     SizedBox(
//                                                       width: 40,
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 2.0,
//                                                               bottom: 1),
//                                                       child: Text(
//                                                           totalmrp != null
//                                                               ? '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(2)}'
//                                                               : '1000',
// //                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
//                                                           style: TextStyle(
//                                                             color: FoodAppColors
//                                                                 .sellp,
//                                                             fontWeight:
//                                                                 FontWeight.w700,
//                                                           )),
//                                                     ),
// //                                priceNew(),
//                                                   ],
//                                                 ),
//                                               ),

//                                               Container(
// //                        height: 90,

//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                 ),

//                                                 margin: EdgeInsets.only(
//                                                     left: 10, right: 20),
//                                                 padding: EdgeInsets.all(10),
//                                                 child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: <Widget>[
//                                                       item.productColor!
//                                                                   .length <
//                                                               2
//                                                           ? Container()
//                                                           : Container(
//                                                               width: 60,
//                                                               height: 25,
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             15),
//                                                                 color:
//                                                                     Colors.red,
//                                                               ),
//                                                               child: Text(""),
//                                                             ),
//                                                       item.productColor!
//                                                                   .length <
//                                                               2
//                                                           ? Container()
//                                                           : Container(
//                                                               width: 120,
//                                                               child: Padding(
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .all(5),
//                                                                 child:
//                                                                     DropdownButton(
//                                                                   elevation: 0,
//                                                                   hint: _dropDownValue ==
//                                                                           null
//                                                                       ? Text(
//                                                                           'Select color')
//                                                                       : Text(
//                                                                           _dropDownValue ??
//                                                                               "",
//                                                                           style:
//                                                                               TextStyle(color: Colors.blue),
//                                                                         ),
//                                                                   isExpanded:
//                                                                       true,
//                                                                   iconSize:
//                                                                       30.0,
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .blue),
//                                                                   items: color!
//                                                                       .map(
//                                                                     (val) {
//                                                                       return DropdownMenuItem<
//                                                                           String>(
//                                                                         value:
//                                                                             val,
//                                                                         child: Text(
//                                                                             val),
//                                                                       );
//                                                                     },
//                                                                   ).toList(),
//                                                                   onChanged:
//                                                                       (val) {
//                                                                     setState(
//                                                                       () {
//                                                                         _dropDownValue =
//                                                                             val;
//                                                                       },
//                                                                     );
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                       SizedBox(
//                                                         width: 20,
//                                                       ),
//                                                       Expanded(
//                                                         child:
//                                                             item.productScale!
//                                                                         .length <
//                                                                     2
//                                                                 ? Container()
//                                                                 : Container(
//                                                                     width: 120,
//                                                                     child:
//                                                                         DropdownButton(
//                                                                       hint: _dropDownValue1 ==
//                                                                               null
//                                                                           ? Text(
//                                                                               'Select Size')
//                                                                           : Text(
//                                                                               _dropDownValue1 ?? "",
//                                                                               style: TextStyle(color: Colors.blue),
//                                                                             ),
//                                                                       isExpanded:
//                                                                           true,
//                                                                       iconSize:
//                                                                           30.0,
//                                                                       style: TextStyle(
//                                                                           color:
//                                                                               Colors.blue),
//                                                                       items: size!
//                                                                           .map(
//                                                                         (val) {
//                                                                           return DropdownMenuItem<
//                                                                               String>(
//                                                                             value:
//                                                                                 val,
//                                                                             child:
//                                                                                 Text(val),
//                                                                           );
//                                                                         },
//                                                                       ).toList(),
//                                                                       onChanged:
//                                                                           (val) {
//                                                                         setState(
//                                                                           () {
//                                                                             _dropDownValue1 =
//                                                                                 val;
//                                                                           },
//                                                                         );
//                                                                       },
//                                                                     ),
//                                                                   ),
//                                                       )
//                                                     ]),
//                                               ),

//                                               SizedBox(
//                                                 height: 15,
//                                               ),

//                                               Container(
//                                                 margin: EdgeInsets.only(
//                                                     left: 0.0, right: 30),
//                                                 child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: <Widget>[
//                                                       SizedBox(
//                                                         width: 0.0,
//                                                         height: 10.0,
//                                                       ),
//                                                       Column(
//                                                         children: <Widget>[
//                                                           Row(
//                                                             children: <Widget>[
//                                                               Container(
//                                                                   height: 33,
//                                                                   width: 45,
//                                                                   child:
//                                                                       Material(
//                                                                     color: FoodAppColors
//                                                                         .teladep,
//                                                                     elevation:
//                                                                         0.0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       side:
//                                                                           BorderSide(
//                                                                         color: Colors
//                                                                             .white,
//                                                                       ),
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .all(
//                                                                         Radius.circular(
//                                                                             20),
//                                                                       ),
//                                                                     ),
//                                                                     clipBehavior:
//                                                                         Clip.antiAlias,
//                                                                     child: InkWell(
//                                                                         onTap: () {
//                                                                           if (_count !=
//                                                                               1) {
//                                                                             setState(() {
//                                                                               _count--;
// //                                                        totalmrp=mrp * _count;
//                                                                             });
//                                                                           }
//                                                                         },
//                                                                         child: Padding(
//                                                                           padding:
//                                                                               EdgeInsets.only(
//                                                                             top:
//                                                                                 10.0,
//                                                                           ),
//                                                                           child:
//                                                                               Icon(
//                                                                             Icons.maximize,
//                                                                             size:
//                                                                                 30,
//                                                                             color:
//                                                                                 Colors.white,
//                                                                           ),
//                                                                         )),
//                                                                   )),
//                                                               Padding(
//                                                                 padding: EdgeInsets
//                                                                     .only(
//                                                                         top:
//                                                                             0.0,
//                                                                         left:
//                                                                             15.0,
//                                                                         right:
//                                                                             8.0),
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                       '$_count',
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               19,
//                                                                           fontFamily:
//                                                                               'Roboto',
//                                                                           fontWeight:
//                                                                               FontWeight.bold)),
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                   margin: EdgeInsets
//                                                                       .only(
//                                                                           left:
//                                                                               3.0),
//                                                                   height: 33,
//                                                                   width: 45,
//                                                                   child:
//                                                                       Material(
//                                                                     color: FoodAppColors
//                                                                         .teladep,
//                                                                     elevation:
//                                                                         0.0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       side:
//                                                                           BorderSide(
//                                                                         color: Colors
//                                                                             .white,
//                                                                       ),
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .all(
//                                                                         Radius.circular(
//                                                                             20),
//                                                                       ),
//                                                                     ),
//                                                                     clipBehavior:
//                                                                         Clip.antiAlias,
//                                                                     child:
//                                                                         InkWell(
//                                                                       onTap:
//                                                                           () {
//                                                                         if (_count <=
//                                                                             int.parse(item.quantityInStock ??
//                                                                                 "")) {
//                                                                           print(
//                                                                               item.quantityInStock);
//                                                                           setState(
//                                                                               () {
//                                                                             print(_count);
//                                                                             _count++;
// //                                                     totalmrp=mrp * _count;
//                                                                           });
//                                                                         } else {
//                                                                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                                                               content: Text(" Products  is not avaliable "),
//                                                                               duration: Duration(seconds: 1)));
//                                                                         }
//                                                                       },
//                                                                       child:
//                                                                           Icon(
//                                                                         Icons
//                                                                             .add,
//                                                                         size:
//                                                                             30,
//                                                                         color: Colors
//                                                                             .white,
//                                                                       ),
//                                                                     ),
//                                                                   )),
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
//                                                       Column(
//                                                         children: <Widget>[
//                                                           Row(
//                                                             children: <Widget>[
//                                                               SizedBox(
//                                                                   width: 20),
//                                                               Container(
//                                                                   margin: EdgeInsets
//                                                                       .only(
//                                                                           left:
//                                                                               3.0),
//                                                                   height: 30,
//                                                                   child:
//                                                                       Material(
//                                                                     color:
//                                                                         FoodAppColors
//                                                                             .pink,
//                                                                     elevation:
//                                                                         0.0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       side:
//                                                                           BorderSide(
//                                                                         color: Colors
//                                                                             .white,
//                                                                       ),
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .all(
//                                                                         Radius.circular(
//                                                                             20),
//                                                                       ),
//                                                                     ),
//                                                                     clipBehavior:
//                                                                         Clip.antiAlias,
//                                                                     child:
//                                                                         InkWell(
//                                                                       onTap:
//                                                                           () {
//                                                                         if (FoodAppConstant
//                                                                             .isLogin) {
// //
//                                                                           if (item.productColor!.length > 0 &&
//                                                                               item.productScale!.length >
//                                                                                   0) {
//                                                                             if (_dropDownValue != null &&
//                                                                                 _dropDownValue1 != null) {
//                                                                               if (int.parse(item.quantityInStock ?? "") > 0) {
//                                                                                 _addToproducts(context);
//                                                                                 FoodAppConstant.foodAppCartItemCount++;
//                                                                                 foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
//                                                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" succesfully added to cart "), duration: Duration(seconds: 1)));
//                                                                                 setState(() {
//                                                                                   FoodAppConstant.itemcount++;

// //                                                  print( Constant.totalAmount);
//                                                                                 });
//                                                                               } else {
//                                                                                 showLongToast("Product is out of stock");
//                                                                               }
//                                                                             } else {
//                                                                               showLongToast("Please select color and size");
//                                                                             }
//                                                                           } else if (item.productColor!.length >
//                                                                               2) {
//                                                                             if (_dropDownValue !=
//                                                                                 null) {
//                                                                               if (int.parse(item.quantityInStock ?? "") > 0) {
//                                                                                 _addToproducts(context);
//                                                                                 FoodAppConstant.foodAppCartItemCount++;
//                                                                                 foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
//                                                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" successfully added to cart "), duration: Duration(seconds: 1)));
//                                                                                 setState(() {
//                                                                                   FoodAppConstant.itemcount++;

// //                                                  print( Constant.totalAmount);
//                                                                                 });
//                                                                               } else {
//                                                                                 showLongToast("Product is out of stock");
//                                                                               }
//                                                                             } else {
//                                                                               showLongToast("Please select color");
//                                                                             }
//                                                                           } else if (item.productScale!.length >
//                                                                               2) {
//                                                                             if (_dropDownValue1 !=
//                                                                                 null) {
//                                                                               if (int.parse(item.quantityInStock ?? "") > 0) {
//                                                                                 _addToproducts(context);
//                                                                                 FoodAppConstant.foodAppCartItemCount++;
//                                                                                 foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
//                                                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" successfully added to cart "), duration: Duration(seconds: 1)));
//                                                                                 setState(() {
//                                                                                   FoodAppConstant.itemcount++;

// //                                                  print( Constant.totalAmount);
//                                                                                 });
//                                                                               } else {
//                                                                                 showLongToast("Product is out of stock");
//                                                                               }
//                                                                             } else {
//                                                                               showLongToast("Please select size");
//                                                                             }
//                                                                           } else {
//                                                                             if (int.parse(item.quantityInStock ?? "") >
//                                                                                 0) {
//                                                                               _addToproducts(context);
//                                                                               FoodAppConstant.foodAppCartItemCount++;
//                                                                               foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
//                                                                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" successfully added to cart "), duration: Duration(seconds: 1)));
//                                                                               setState(() {
//                                                                                 FoodAppConstant.itemcount++;

// //                                                  print( Constant.totalAmount);
//                                                                               });
//                                                                             } else {
//                                                                               showLongToast("Product is out of stock");
//                                                                             }
//                                                                           }
//                                                                         } else {
//                                                                           Navigator
//                                                                               .push(
//                                                                             context,
//                                                                             MaterialPageRoute(builder: (context) => SignInPage()),
//                                                                           );
//                                                                         }
//                                                                       },
//                                                                       child: Padding(
//                                                                           padding: EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
//                                                                           child: Center(
//                                                                             child:
//                                                                                 Text(
//                                                                               "Add to Bag",
//                                                                               style: TextStyle(color: FoodAppColors.white),
//                                                                             ),
//                                                                           )),
//                                                                     ),
//                                                                   )),
//                                                               wishflag
//                                                                   ? InkWell(
//                                                                       onTap:
//                                                                           () {
//                                                                         if (FoodAppConstant
//                                                                             .isLogin) {
//                                                                           _addToproducts1(
//                                                                               context);

//                                                                           showLongToast(
//                                                                               " Products is added to wishlist ");

//                                                                           setState(
//                                                                               () {
//                                                                             wishflag =
//                                                                                 false;
//                                                                             FoodAppConstant.wishlist++;
//                                                                             _countList(FoodAppConstant.wishlist);

// //                                                  print( Constant.totalAmount);
//                                                                           });
//                                                                         } else {
//                                                                           Navigator
//                                                                               .push(
//                                                                             context,
//                                                                             MaterialPageRoute(builder: (context) => SignInPage()),
//                                                                           );
//                                                                         }
//                                                                       },
//                                                                       child:
//                                                                           Container(
//                                                                         margin: EdgeInsets.only(
//                                                                             left:
//                                                                                 3.0),
//                                                                         height:
//                                                                             33,
//                                                                         width:
//                                                                             45,
//                                                                         child: Icon(
//                                                                             Icons
//                                                                                 .favorite_border,
//                                                                             size:
//                                                                                 30,
//                                                                             color:
//                                                                                 FoodAppColors.pink),
//                                                                       ),
//                                                                     )
//                                                                   : InkWell(
//                                                                       onTap:
//                                                                           () {
//                                                                         setState(
//                                                                             () {
//                                                                           dbmanager1
//                                                                               .deleteProducts(wishid!);
//                                                                           wishflag =
//                                                                               true;
//                                                                         });
//                                                                       },
//                                                                       child:
//                                                                           Container(
//                                                                         margin: EdgeInsets.only(
//                                                                             left:
//                                                                                 3.0),
//                                                                         height:
//                                                                             33,
//                                                                         width:
//                                                                             45,
//                                                                         child: Icon(
//                                                                             Icons
//                                                                                 .favorite,
//                                                                             size:
//                                                                                 30,
//                                                                             color:
//                                                                                 FoodAppColors.pink),
//                                                                       ),
//                                                                     ),
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ]),
//                                               ),

//                                               pvarlist.length > 0
//                                                   ? Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       children: <Widget>[
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   left: 16.0,
//                                                                   top: 18.0),
//                                                           child: new Text(
//                                                             ' Variant:',
//                                                             style:
//                                                                 new TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 16.0,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 16.0,
//                                                                     top: 8.0),
//                                                             child: InkWell(
//                                                               onTap: () {
//                                                                 _displayDialog(
//                                                                     context,
//                                                                     index);
//                                                                 // _showSelectionDialog(context);
//                                                               },
//                                                               child: Container(
//                                                                 // width: MediaQuery.of(context).size.width/1.5,
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                         .only(
//                                                                   left: 10.0,
//                                                                   top: 0.0,
//                                                                   right: 10.0,
//                                                                 ),
//                                                                 margin:
//                                                                     const EdgeInsets
//                                                                         .only(
//                                                                   top: 5.0,
//                                                                 ),

//                                                                 child: Center(
//                                                                     child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .end,
//                                                                   children: [
//                                                                     Padding(
//                                                                       padding: EdgeInsets.only(
//                                                                           left:
//                                                                               10,
//                                                                           right:
//                                                                               10),
//                                                                       child:
//                                                                           Text(
//                                                                         textval.length >
//                                                                                 20
//                                                                             ? textval.substring(0, 20) +
//                                                                                 ".."
//                                                                             : textval,

//                                                                         overflow:
//                                                                             TextOverflow.fade,
//                                                                         // maxLines: 2,
//                                                                         style:
//                                                                             TextStyle(
//                                                                           fontSize:
//                                                                               15,
//                                                                           color:
//                                                                               FoodAppColors.black,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     Padding(
//                                                                         padding: EdgeInsets.only(
//                                                                             left:
//                                                                                 0),
//                                                                         child:
//                                                                             Icon(
//                                                                           Icons
//                                                                               .expand_more,
//                                                                           color:
//                                                                               Colors.black,
//                                                                           size:
//                                                                               30,
//                                                                         ))
//                                                                   ],
//                                                                 )),

//                                                                 decoration: BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: Colors
//                                                                             .black)),
//                                                               ),
//                                                             )),

//                                                         /*Container(
//                                  color: AppColors.black,
//                                    margin:EdgeInsets.only(left: 10,top: 10,right: 10) ,
//                                    height: 45,
//                                    child: Padding(
//                                      padding: EdgeInsets.only(left: 0,top: 0,right: 0),
//                                      child: TextField(
//                                          minLines: 1,
//                                          maxLines: 3,
//                                          decoration: InputDecoration(
//                                            prefixIcon: Icon(Icons.expand_more),
//                                              hintText: "Select varient",
//                                              border: OutlineInputBorder()
//                                          )),))*/
//                                                       ],
//                                                     )
//                                                   : Row(),

//                                               SizedBox(
//                                                 height: 20,
//                                               ),

//                                               Row(
//                                                 children: <Widget>[
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 16.0,
//                                                             top: 8.0),
//                                                     child: new Text(
//                                                       'Service Details:',
//                                                       style: new TextStyle(
//                                                         color: Colors.black54,
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   InkWell(
//                                                     onTap: () {
//                                                       if (showdis) {
//                                                         setState(() {
//                                                           showdis = false;
//                                                         });
//                                                       } else {
//                                                         setState(() {
//                                                           showdis = true;
//                                                         });
//                                                       }
//                                                     },
//                                                     child: Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 left: 16.0,
//                                                                 top: 8.0),
//                                                         child: Icon(
//                                                             showdis
//                                                                 ? Icons
//                                                                     .keyboard_arrow_up
//                                                                 : Icons
//                                                                     .keyboard_arrow_down,

// //                                        Icons.keyboard_arrow_down,
//                                                             size: 30,
//                                                             color: FoodAppColors
//                                                                 .black)),
//                                                   )
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               showdis
//                                                   ? Column(
//                                                       children: <Widget>[
//                                                         // discription("Warranty: ",item.warrantys),

//                                                         /*Row(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                                       child:  Text("Return: " ,
//                                                         overflow: TextOverflow.fade,
//                                                         style: new TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: 15.0,fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                                       child:  Text(item.returns=="0"?"No":item.returns+"day",
//                                                         overflow: TextOverflow.fade,
//                                                         style: new TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: 14.0,
//                                                         ),
//                                                       ),
//                                                     ),

//                                                   ],
//                                                 ),*/
// //                             discription("Return: ",widget.plist.returns),
// //                                                 discription("Brand: ",item.productVendor),
//                                                         /*Row(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                                       child:  Text("Cancel: " ,
//                                                         overflow: TextOverflow.fade,
//                                                         style: new TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: 15.0,fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                                       child:  Text(item.cancels=="0"?"No":item.cancels+"day",
//                                                         overflow: TextOverflow.fade,
//                                                         style: new TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: 14.0,
//                                                         ),
//                                                       ),
//                                                     ),

//                                                   ],
//                                                 ),*/
//                                                         discription(
//                                                             "",
//                                                             item.productDescription ??
//                                                                 ""),
//                                                       ],
//                                                     )
//                                                   : Container(),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     );
//                             } else {
//                               return Center(child: CircularProgressIndicator());
//                             }
//                           }),
//                       group != null
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 group != null
//                                     ? Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 10.0, top: 8.0),
//                                         child: Text(
//                                           groupname ?? "",
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 16.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       )
//                                     : Row(),
//                                 Container(
//                                   margin: EdgeInsets.symmetric(vertical: 8.0),
//                                   height: 78.0,
//                                   child: group != null
//                                       ? ListView.builder(
//                                           scrollDirection: Axis.horizontal,
//                                           itemCount: group.length,
//                                           itemBuilder: (BuildContext context,
//                                               int index) {
//                                             return group[index].img!.length > 2
//                                                 ? Container(
//                                                     width: 70.0,
//                                                     child: Card(
//                                                       shape:
//                                                           RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10.0),
//                                                       ),
//                                                       clipBehavior:
//                                                           Clip.antiAlias,
//                                                       child: InkWell(
//                                                         onTap: () {
// //                                              setState(() {
// //
// //                                                url=imgList1[index];
// //                                                showLongToast("Product is selected ");
// //                                              });
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                                 builder: (context) =>
//                                                                     ProductDetails1(
//                                                                         group[index].productIs ??
//                                                                             "")),
//                                                           );
// //
//                                                         },
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: <Widget>[
//                                                             SizedBox(
//                                                               height: 70,
//                                                               child:
//                                                                   CachedNetworkImage(
//                                                                 fit: BoxFit
//                                                                     .cover,
//                                                                 imageUrl: FoodAppConstant
//                                                                         .Product_Imageurl1 +
//                                                                     group[index]
//                                                                         .img
//                                                                         .toString(),
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                                 placeholder: (context,
//                                                                         url) =>
//                                                                     Center(
//                                                                         child:
//                                                                             CircularProgressIndicator()),
//                                                                 errorWidget: (context,
//                                                                         url,
//                                                                         error) =>
//                                                                     new Icon(Icons
//                                                                         .error),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : Row();
//                                           })
//                                       : CircularProgressIndicator(),
//                                 ),
//                               ],
//                             )
//                           : Row(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 top: 8.0, left: 8.0, right: 8.0),
//                             child: Text(
//                               'SIMILAR PRODUCTS',
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 17,
//                                   fontFamily: 'Roboto',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           // Padding(
//                           //   padding: const EdgeInsets.only(
//                           //       right: 8.0, top: 8.0, left: 8.0),
//                           //   child: RaisedButton(
//                           //       color: Colors.white,
//                           //       child: Text('View All',
//                           //           style: TextStyle(color: Colors.blueGrey)),
//                           //       onPressed: () {
//                           //         print(catid.length);
//                           //         Navigator.push(
//                           //           context,
//                           //           MaterialPageRoute(builder: (context) =>Screen2(catid.length>0?catid[0]:"0","RELATED PRODUCTS")),
//                           //         );
//                           //       }),
//                           // )
//                         ],
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 8.0),
//                         height: 135.0,
//                         child: products1 != null
//                             ? ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: products1.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Container(
//                                     width: 130.0,
//                                     child: Card(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                       ),
//                                       clipBehavior: Clip.antiAlias,
//                                       child: InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ProductDetails(
//                                                         products1[index])),
//                                           );
// //
//                                         },
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: <Widget>[
//                                             SizedBox(
//                                               height: 127,
//                                               child: CachedNetworkImage(
//                                                 fit: BoxFit.cover,
//                                                 imageUrl: FoodAppConstant
//                                                         .Product_Imageurl +
//                                                     products1[index]
//                                                         .img
//                                                         .toString(),
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                 placeholder: (context, url) =>
//                                                     Center(
//                                                         child:
//                                                             CircularProgressIndicator()),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                         new Icon(Icons.error),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 })
//                             : CircularProgressIndicator(),
//                       ),
//                     ],
//                   ),
//                   // Builds 1000 ListTiles
//                   childCount: 1,
//                 ),
//               )
//             ])),
//       ),
//     );
//   }

//   productName1() {
//     actualprice = int.parse(productdetails[0].buyPrice ?? "");
//     total = actualprice;

//     String mrp_price = calDiscount(
//         productdetails[0].buyPrice ?? "", productdetails[0].discount ?? "");
//     totalmrp = double.parse(mrp_price);

//     Padding(
//       padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 10),
//       child: Text(
//           productdetails[0].productName == null
//               ? productdetails[0].productName!.length.toString()
//               : "sanjar",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 15,
//             fontWeight: FontWeight.w400,
//           )),
//     );
//   }

//   priceold() {
//     Padding(
//       padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//       child: Text('\u{20B9} $total',
//           style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontStyle: FontStyle.italic,
//               color: FoodAppColors.mrp,
//               decoration: TextDecoration.lineThrough)),
//     );
//   }

//   priceNew() {
//     Padding(
//       padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//       child: Text(
//           totalmrp != null
//               ? '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(2)}'
//               : '1000',
// //                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
//           style: TextStyle(
//             color: FoodAppColors.sellp,
//             fontWeight: FontWeight.w700,
//           )),
//     );
//   }

//   productDetails() {
//     Padding(
//       padding: const EdgeInsets.only(left: 16.0, top: 8.0),
//       child: Text(
//         productdetails[0].productDescription??"",
//         style: new TextStyle(
//           color: Colors.black,
//           fontSize: 14.0,
//         ),
//       ),
//     );
//   }

// //  discountValue;
// //  String adminper;
// //  String adminpricevalue;
// //  String costPrice;

//   void _addToproducts(BuildContext context) {
//     if (products == null) {
//       ProductsCart st = new ProductsCart(
//           pid: productdetails[0].productIs,
//           pname: productdetails[0].productName,
//           pimage: url,
//           pprice: (totalmrp! * _count).toString(),
//           pQuantity: _count,
//           pcolor: _dropDownValue,
//           psize: _dropDownValue1,
//           pdiscription: productdetails[0].productDescription,
//           sgst: sgst1.toString(),
//           cgst: cgst1.toString(),
//           discount: productdetails[0].discount,
//           discountValue: dicountValue.toString(),
//           adminper: productdetails[0].msrp,
//           adminpricevalue: admindiscountprice.toString(),
//           costPrice: total.toString(),
//           shipping: productdetails[0].shipping,
//           totalQuantity: productdetails[0].quantityInStock,
//           varient: textval,
//           mv: int.parse(productdetails[0].mv??""));
//       dbmanager
//           .insertStudent(st)
//           .then((id) => {print('Student Added to Db ${id}')});
//     }
//   }

//   WishlistsCart? nproducts;
//   final DbProductManager1 dbmanager1 = new DbProductManager1();

//   void _addToproducts1(BuildContext context) {
//     if (nproducts == null) {
//       WishlistsCart st1 = new WishlistsCart(
//           pid: productdetails[0].productIs,
//           pname: productdetails[0].productName,
//           pimage: url,
//           pprice: totalmrp.toString(),
//           pQuantity: _count,
//           pcolor: _dropDownValue,
//           psize: _dropDownValue1,
//           pdiscription: productdetails[0].productDescription,
//           sgst: sgst1.toString(),
//           cgst: cgst1.toString(),
//           discount: productdetails[0].discount,
//           discountValue: dicountValue.toString(),
//           adminper: productdetails[0].msrp,
//           adminpricevalue: admindiscountprice.toString(),
//           costPrice: productdetails[0].buyPrice);
//       dbmanager1.insertStudent(st1).then((id) => {
//             setState(() {
//               wishid = id;

//               print('Student Added to Db ${wishid}');
//               print(FoodAppConstant.totalAmount);
//             })
//           });
//     }
//   }

//   String calDiscount(String byprice, String discount2) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(discount2);

//     discount = (byprice1 - (byprice1 * discount1) / 100.0);

//     returnStr = discount.toStringAsFixed(2);
//     print(returnStr);
//     return returnStr;
//   }

//   String calGst(String byprice, String sgst) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(sgst);

//     discount = ((byprice1 * discount1) / (100.0 + discount1));

//     returnStr = discount.toStringAsFixed(2);
//     print(returnStr);
//     return returnStr;
//   }

//   void showLongToast(String s) {
//     Fluttertoast.showToast(
//       msg: s,
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }

//   Widget discription(String name, String Discription) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0, top: 8.0),
//             child: Text(
//               name,
//               overflow: TextOverflow.fade,
//               style: new TextStyle(
//                 color: Colors.black,
//                 fontSize: 15.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0, top: 8.0),
//               child: Text(
//                 Discription != null ? Discription : "",
//                 overflow: TextOverflow.fade,
//                 style: new TextStyle(
//                   color: Colors.black,
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future _countList(int val) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setInt("wcount", val);
//   }
// }

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:aladdinmart/Auth/signin.dart';
// import 'package:aladdinmart/BottomNavigation/wishlist.dart';
// import 'package:aladdinmart/General/AppConstant.dart';
// import 'package:aladdinmart/dbhelper/CarrtDbhelper.dart';
// import 'package:aladdinmart/dbhelper/database_helper.dart';
// import 'package:aladdinmart/model/CategaryModal.dart';
// import 'package:aladdinmart/model/productmodel.dart';
// import 'package:aladdinmart/model/slidermodal.dart';
// import 'package:aladdinmart/screen/detailpage.dart';
// import 'package:page_indicator/page_indicator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MV_products extends StatefulWidget {
//   final String title;
//   final String mvid;
//   final String catid;
//   const MV_products(this.title, this.mvid, this.catid) : super();
//   @override
//   _Sbcategory createState() => _Sbcategory();
// }

// class _Sbcategory extends State<MV_products> {
//   double? sgst1, cgst1, dicountValue, admindiscountprice;

//   bool product = false;
//   List<Products> products = [];
//   bool flag = true;
//   double? mrp, totalmrp = 000;
//   int _count = 1;
//   List<Products> products1 = [];

//   String textval = "Select variant";

//   int _current = 0;
//   SharedPreferences? pref;

//   List<Categary> list1 = [];
//   void gatinfoCount() async {
//     pref = await SharedPreferences.getInstance();

//     int? Count = pref!.getInt("itemCount");
//     setState(() {
//       if (Count == null) {
//         FoodAppConstant.foodAppCartItemCount = 0;
//       } else {
//         FoodAppConstant.foodAppCartItemCount = Count;
//       }
// //      print(Constant.carditemCount.toString()+"itemCount");
//     });
//   }

//   List<Slider1> sliderlist = [];

//   @override
//   void initState() {
//     super.initState();
//     gatinfoCount();
//     // getSliderforMedicalShop(widget.mvid).then((usersFromServe1) {
//     //   if (this.mounted) {
//     //     setState(() {
//     //       sliderlist = usersFromServe1;
//     //
//     //     });
//     //   }
//     // });

//     getlist(countval);

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         setState(() {
//           countval = countval + 10;
//           getlist(countval);
//         });
//       }
//     });
//   }

//   int countval = 0;
//   ScrollController _scrollController = new ScrollController();

//   getlist(int lim) {
//     getTServicebymv_id(widget.mvid, widget.catid, lim.toString())
//         .then((usersFromServe) {
//       setState(() {
//         products1.addAll(usersFromServe!);
//         if (products1.length == 0) {
//           product = true;
//           print(product);
//         }
//       });
//     });
//   }

//   double? _height;
//   double? _width;
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _height = MediaQuery.of(context).size.height;
//     _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         backgroundColor: FoodAppColors.white,
//         appBar: AppBar(
//           backgroundColor: FoodAppColors.tela,
//           leading: Padding(
//               padding: EdgeInsets.only(left: 0.0),
//               child: InkWell(
//                 onTap: () {
//                   if (Navigator.canPop(context)) {
//                     Navigator.pop(context);
//                   } else {
//                     SystemNavigator.pop();
//                   }
//                 },
//                 child: Icon(
//                   Icons.arrow_back,
//                   size: 24,
//                   color: FoodAppColors.white,
//                 ),
//               )),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 20),
//                   child: Text(
//                     widget.title != null ? widget.title : "ServiceList",
//                     maxLines: 2,

//                     // overflow:TextOverflow.ellipsis ,
//                     style: TextStyle(color: FoodAppColors.white),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   /* InkWell(
//                     onTap: () {
//                       Navigator.pop(context);

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => UserFilterDemo(widget.mvid)),
//                       );
//                     },
//                     child: Stack(
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(top: 3),
//                           child: Icon(
//                             Icons.search,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
// //                    showCircle(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: 12,
//                   ),*/
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => WishList()),
//                       );
//                     },
//                     child: Stack(
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(top: 13),
//                           child: Icon(
//                             Icons.add_shopping_cart,
//                             color: FoodAppColors.white,
//                           ),
//                         ),
//                         showCircle(),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//         body: CustomScrollView(slivers: <Widget>[
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
// /*
//                   sliderlist.length>0? Container(
//                       height:MediaQuery.of(context).size.height/4,
//                       width: _width,
//                       child: Stack(
//                         children: <Widget>[
//                           PageIndicatorContainer (
//                               align: IndicatorAlign.bottom,
//                               length:sliderlist.length,
//                               indicatorColor: Colors.grey,
//                               indicatorSelectorColor: Colors.pink,
//                               size: 10.0,
//                               indicatorSpace: 10.0,
//                               pageView:
//                               PageView.builder(
//                                   itemCount: sliderlist.length,

//                                   itemBuilder: (BuildContext context,int i){

//                                     return  Container(
//                                       child:   CachedNetworkImage(
//                                         fit: BoxFit.cover,
//                                         imageUrl:Constant.Base_Imageurl + sliderlist[i].img,
//                                         placeholder: (context, url) =>
//                                             Center(
//                                                 child:
//                                                 CircularProgressIndicator()),
//                                         errorWidget:
//                                             (context, url, error) =>
//                                         new Icon(Icons.error),

//                                       ),
//                                     );
//                                   })),

//                         ],
//                       )



// //                    Image.network( list.restaurantPhoto!=null?
// //                      list.restaurantPhoto:"",
// //                      fit: BoxFit.cover,
// //                    )

//                   ):Container(),


//                   SizedBox(height: 20,),*/

//                   product
//                       ? Container(
//                           child: Center(
//                             child: Text("The Serviceis NOT available "),
//                           ),
//                         )
//                       : products1.length > 0
//                           ? Container(
//                               // color: AppColors.tela1,
//                               child: ListView.builder(
//                                 controller: _scrollController,
//                                 shrinkWrap: true,
//                                 primary: false,
//                                 scrollDirection: Axis.vertical,
//                                 itemCount: products1.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Container(
//                                     margin: EdgeInsets.only(
//                                         left: 0, right: 0, top: 6, bottom: 6),
//                                     // decoration: BoxDecoration(
//                                     //     color: Colors.white,
//                                     //     borderRadius: BorderRadius.all(Radius.circular(16))),
//                                     child: InkWell(
//                                       onTap: () {
//                                         // _modalBottomSheetMenu(index);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ProductDetails(
//                                                       products1[index])),
//                                         );
//                                       },
//                                       child: Card(
//                                         child: Row(
//                                           children: <Widget>[
//                                             SizedBox(
//                                               width: 20,
//                                             ),
//                                             Expanded(
//                                               child: Container(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.max,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Container(
//                                                       child: Text(
//                                                         products1[index]
//                                                                     .productName ==
//                                                                 null
//                                                             ? 'name'
//                                                             : products1[index]
//                                                                     .productName ??
//                                                                 "",
//                                                         overflow:
//                                                             TextOverflow.fade,
//                                                         style: TextStyle(
//                                                                 fontSize: 15,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400,
//                                                                 color: Colors
//                                                                     .black)
//                                                             .copyWith(
//                                                                 fontSize: 14),
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 6),
//                                                     Row(
//                                                       children: <Widget>[
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   top: 2.0,
//                                                                   bottom: 1),
//                                                           child: Text(
//                                                               '\u{20B9} ${calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "")}',
//                                                               style: TextStyle(
//                                                                 color:
//                                                                     FoodAppColors
//                                                                         .sellp,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                               )),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 20,
//                                                         ),
//                                                         Expanded(
//                                                           child: Text(
//                                                             '(\u{20B9} ${products1[index].buyPrice})',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             maxLines: 2,
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontStyle:
//                                                                     FontStyle
//                                                                         .italic,
//                                                                 color:
//                                                                     FoodAppColors
//                                                                         .mrp,
//                                                                 decoration:
//                                                                     TextDecoration
//                                                                         .lineThrough),
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     products1[index].p_id ==
//                                                             null
//                                                         ? Container()
//                                                         : Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 0.0,
//                                                                     top: 8.0),
//                                                             child: InkWell(
//                                                               onTap: () {
//                                                                 _displayDialog(
//                                                                     context,
//                                                                     products1[index]
//                                                                             .productIs ??
//                                                                         "",
//                                                                     index);
//                                                                 // _showSelectionDialog(context);
//                                                               },
//                                                               child: Container(
//                                                                 decoration: BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: Colors
//                                                                             .grey)),
//                                                                 width: MediaQuery.of(
//                                                                             context)
//                                                                         .size
//                                                                         .width /
//                                                                     2,
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                         .only(
//                                                                   left: 5.0,
//                                                                   top: 0.0,
//                                                                   right: 5.0,
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
//                                                                               0),
//                                                                       child:
//                                                                           Text(
//                                                                         // textval.length>15?textval.substring(0,15)+"..": textval,
//                                                                         products1[index].youtube!.length >
//                                                                                 1
//                                                                             ? products1[index].youtube!.length > 15
//                                                                                 ? products1[index].youtube!.substring(0, 15) + ".."
//                                                                                 : products1[index].youtube ?? ""
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
//                                                               ),
//                                                             )),
//                                                     Container(
//                                                       margin: EdgeInsets.only(
//                                                           left: 0.0, right: 10),
//                                                       child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .start,
//                                                           children: <Widget>[
//                                                             SizedBox(
//                                                               width: 0.0,
//                                                               height: 10.0,
//                                                             ),
//                                                             Container(
//                                                               alignment: Alignment
//                                                                   .bottomCenter,
//                                                               margin: EdgeInsets
//                                                                   .only(
//                                                                       left: 0.0,
//                                                                       right:
//                                                                           10),
//                                                               child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .center,
//                                                                   children: <
//                                                                       Widget>[
//                                                                     Card(
//                                                                       color: FoodAppColors
//                                                                           .white,
//                                                                       elevation:
//                                                                           0.0,
//                                                                       shape:
//                                                                           RoundedRectangleBorder(
//                                                                         side:
//                                                                             BorderSide(
//                                                                           color:
//                                                                               FoodAppColors.black,
//                                                                         ),
//                                                                         borderRadius:
//                                                                             BorderRadius.all(
//                                                                           Radius.circular(
//                                                                               15),
//                                                                         ),
//                                                                       ),
//                                                                       clipBehavior:
//                                                                           Clip.antiAlias,
//                                                                       child:
//                                                                           Padding(
//                                                                         padding:
//                                                                             const EdgeInsets.all(4.0),
//                                                                         child:
//                                                                             Row(
//                                                                           mainAxisAlignment:
//                                                                               MainAxisAlignment.center,
//                                                                           children: <
//                                                                               Widget>[
//                                                                             GestureDetector(
//                                                                               onTap: () {
//                                                                                 print(products1[index].count);
//                                                                                 if (products1[index].count != "1" && int.parse(products1[index].count ?? "") > 1) {
//                                                                                   setState(() {
// //                                                                                _count++;

//                                                                                     String quantity = products1[index].count ?? "";
//                                                                                     print(int.parse(products1[index].moq ?? ""));
//                                                                                     int totalquantity = int.parse(quantity) - int.parse(products1[index].moq ?? "");
//                                                                                     products1[index].count = totalquantity.toString();
//                                                                                   });
//                                                                                 }

// //
//                                                                               },
//                                                                               child: Container(
//                                                                                   height: 20,
//                                                                                   width: 20,
//                                                                                   child: Material(
//                                                                                     color: FoodAppColors.white,
//                                                                                     elevation: 0.0,
//                                                                                     shape: RoundedRectangleBorder(
//                                                                                       side: BorderSide(
//                                                                                         color: Colors.white,
//                                                                                       ),
//                                                                                       borderRadius: BorderRadius.all(
//                                                                                         Radius.circular(17),
//                                                                                       ),
//                                                                                     ),
//                                                                                     clipBehavior: Clip.antiAlias,
//                                                                                     child: InkWell(
//                                                                                         onTap: () {
//                                                                                           print(products1[index].count);
//                                                                                           if (products1[index].count != "1") {
//                                                                                             setState(() {
// //                                                                                _count++;

//                                                                                               String quantity = products1[index].count ?? "";
//                                                                                               print(int.parse(products1[index].moq ?? ""));
//                                                                                               int totalquantity = int.parse(quantity) - int.parse(products1[index].moq ?? "");
//                                                                                               products1[index].count = totalquantity.toString();
//                                                                                             });
//                                                                                           }
//                                                                                         },
//                                                                                         child: Padding(
//                                                                                           padding: EdgeInsets.only(
//                                                                                             top: 8.0,
//                                                                                           ),
//                                                                                           child: Icon(
//                                                                                             Icons.maximize,
//                                                                                             size: 20,
//                                                                                             color: FoodAppColors.black,
//                                                                                           ),
//                                                                                         )),
//                                                                                   )),
//                                                                             ),
//                                                                             Padding(
//                                                                               padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
//                                                                               child: Center(
//                                                                                 child: Text(
//                                                                                     products1[index].count != null
//                                                                                         ? products1[index].count == "1"
//                                                                                             ? "1"
//                                                                                             : '${products1[index].count}'
//                                                                                         : '$_count',
//                                                                                     style: TextStyle(color: FoodAppColors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
//                                                                               ),
//                                                                             ),
//                                                                             Container(
//                                                                                 margin: EdgeInsets.only(left: 3.0),
//                                                                                 height: 20,
//                                                                                 width: 20,
//                                                                                 child: Material(
//                                                                                   color: FoodAppColors.white,
//                                                                                   elevation: 0.0,
//                                                                                   shape: RoundedRectangleBorder(
//                                                                                     side: BorderSide(
//                                                                                       color: Colors.white,
//                                                                                     ),
//                                                                                     borderRadius: BorderRadius.all(
//                                                                                       Radius.circular(17),
//                                                                                     ),
//                                                                                   ),
//                                                                                   clipBehavior: Clip.antiAlias,
//                                                                                   child: InkWell(
//                                                                                     onTap: () {
//                                                                                       if (int.parse(products1[index].count ?? "") < int.parse(products1[index].quantityInStock ?? "")) {
//                                                                                         setState(() {
// //                                                                                _count++;

//                                                                                           String quantity = products1[index].count ?? "";
//                                                                                           int totalquantity = int.parse(quantity) + 1;

//                                                                                           // int totalquantity=int.parse(quantity=="1"?"0":quantity)+int.parse(products1[index].moq);
//                                                                                           products1[index].count = totalquantity.toString();
//                                                                                         });
//                                                                                       } else {
//                                                                                         showLongToast('Only  ${products1[index].quantityInStock}  products in stock ');
//                                                                                       }
//                                                                                     },
//                                                                                     child: Icon(
//                                                                                       Icons.add,
//                                                                                       size: 20,
//                                                                                       color: FoodAppColors.black,
//                                                                                     ),
//                                                                                   ),
//                                                                                 )),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     // SizedBox(width: 25,),
//                                                                   ]),
//                                                             ),
//                                                           ]),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             Stack(
//                                               children: [
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                       right: 8,
//                                                       left: 8,
//                                                       top: 8,
//                                                       bottom: 8),
//                                                   width: 110,
//                                                   height: 110,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                               Radius.circular(
//                                                                   14)),
//                                                       color:
//                                                           FoodAppColors.tela1,
//                                                       image: DecorationImage(
//                                                           fit: BoxFit.cover,
//                                                           image: NetworkImage(
//                                                             products1[index]
//                                                                         .img !=
//                                                                     null
//                                                                 ? FoodAppConstant
//                                                                         .Product_Imageurl +
//                                                                     products1[
//                                                                             index]
//                                                                         .img
//                                                                         .toString()
//                                                                 : "https://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
//                                                           ))),
//                                                 ),
//                                                 /*Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.end,
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.end,
//                                             crossAxisAlignment: CrossAxisAlignment.end,
//                                             children: <Widget>[

//                                               Container(
//                                                   margin: EdgeInsets.only(top: 100.0,left:30.0),
//                                                   height: 30,
//                                                   width: 70,

//                                                   child:
//                                                   Material(

//                                                     color: AppColors.white,
//                                                     elevation: 0.0,
//                                                     shape: RoundedRectangleBorder(
//                                                       side: BorderSide(
//                                                         color: AppColors.tela,
//                                                       ),
//                                                       borderRadius: BorderRadius.all(
//                                                         Radius.circular(10),
//                                                       ),
//                                                     ),
//                                                     clipBehavior: Clip.antiAlias,
//                                                     child: InkWell(
//                                                       onTap: () {


//                                                         if(Constant.isLogin){

//                                                           String mv=  pref.getString("mvid",);
//                                                           if(mv==null||mv.isEmpty||products1[index].mv==pref.getString("mvid")) {
//                                                             pref.setString("mvid",products1[index].mv);
//                                                             print(pref.getString("mvid"));



//                                                             String mrp_price = calDiscount(
//                                                                 products1[index]
//                                                                     .buyPrice,
//                                                                 products1[index]
//                                                                     .discount);
//                                                             totalmrp =
//                                                                 double
//                                                                     .parse(
//                                                                     mrp_price);


//                                                             double dicountValue = double
//                                                                 .parse(
//                                                                 products1[index]
//                                                                     .buyPrice) -
//                                                                 totalmrp;
//                                                             String gst_sgst = calGst(
//                                                                 mrp_price,
//                                                                 products1[index]
//                                                                     .sgst);
//                                                             String gst_cgst = calGst(
//                                                                 mrp_price,
//                                                                 products1[index]
//                                                                     .cgst);

//                                                             String adiscount = calDiscount(
//                                                                 products1[index]
//                                                                     .buyPrice,
//                                                                 products1[index]
//                                                                     .msrp !=
//                                                                     null
//                                                                     ? products1[index]
//                                                                     .msrp
//                                                                     : "0");

//                                                             admindiscountprice =
//                                                             (double
//                                                                 .parse(
//                                                                 products1[index]
//                                                                     .buyPrice) -
//                                                                 double
//                                                                     .parse(
//                                                                     adiscount));


//                                                             String color = "";
//                                                             String size = "";

//                                                             // String mv=  pref.getString("mvid",);

//                                                             _addToproducts(
//                                                                 products1[index]
//                                                                     .productIs,
//                                                                 products1[index]
//                                                                     .productName,
//                                                                 products1[index]
//                                                                     .img,
//                                                                 int
//                                                                     .parse(
//                                                                     mrp_price),
//                                                                 int
//                                                                     .parse(
//                                                                     products1[index]
//                                                                         .count),
//                                                                 color,
//                                                                 size,
//                                                                 products1[index]
//                                                                     .productDescription,
//                                                                 gst_sgst,
//                                                                 gst_cgst,
//                                                                 products1[index]
//                                                                     .discount,
//                                                                 dicountValue
//                                                                     .toString(),
//                                                                 products1[index]
//                                                                     .APMC,
//                                                                 admindiscountprice
//                                                                     .toString(),
//                                                                 products1[index]
//                                                                     .buyPrice,
//                                                                 products1[index]
//                                                                     .shipping,
//                                                                 products1[index]
//                                                                     .quantityInStock,
//                                                                 products1[index]
//                                                                     .youtube,
//                                                                 products1[index]
//                                                                     .mv);




// //                                                                Navigator.push(context,
// //                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
//                                                           }



//                                                           else{



//                                                             showAlertDialog(context,products1[index]);



//                                                           }


//                                                         }





//                                                         else{


//                                                           Navigator.push(context,
//                                                             MaterialPageRoute(builder: (context) => SignInPage()),);
//                                                         }

// //

//                                                       },
//                                                       child:Padding(padding: EdgeInsets.only(left: 5,top: 5,bottom: 5,right: 5),
//                                                           child:Center(

//                                                               child:Text("ADD",style: TextStyle(color: AppColors.tela),)
//                                                             // Icon(Icons.add_shopping_cart,color: Colors.white,),

//                                                           )),),
//                                                   )),









//                                             ],
//                                           ),

//                                         ],
//                                       ),*/

//                                                 addProduct(index, 0)
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             )
//                           : Center(child: CircularProgressIndicator())
//                   //  : Container(
//                   // child: Center(
//                   //   child: Text("No product is avaliable"),)),

//                   // )

// //            showTab(),
//                 ],
//               ),
//               childCount: 1,
//             ),
//           )
//         ]));
//   }

//   Widget addProduct(int index, int val) {
//     return Align(
//       alignment: Alignment.bottomLeft,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               Container(
//                   margin: EdgeInsets.only(
//                       top: val == 0 ? 100.0 : 10, left: val == 0 ? 30.0 : 20),
//                   height: 30,
//                   width: 70,
//                   child: Material(
//                     color: FoodAppColors.white,
//                     elevation: 0.0,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                         color: FoodAppColors.black,
//                       ),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                     clipBehavior: Clip.antiAlias,
//                     child: InkWell(
//                       onTap: () {
//                         if (FoodAppConstant.isLogin) {
//                           String mv = pref!
//                               .getString(
//                                 "mvid",
//                               )
//                               .toString();
//                           if (mv == null ||
//                               mv.isEmpty ||
//                               products1[index].mv == pref!.getString("mvid")) {
//                             pref!.setString("mvid", products1[index].mv ?? "");
//                             print(pref!.getString("mvid"));

//                             String mrp_price = calDiscount(
//                                 products1[index].buyPrice ?? "",
//                                 products1[index].discount ?? "");
//                             totalmrp = double.parse(mrp_price);

//                             double dicountValue =
//                                 double.parse(products1[index].buyPrice ?? "") -
//                                     totalmrp!;
//                             String gst_sgst =
//                                 calGst(mrp_price, products1[index].sgst ?? "");
//                             String gst_cgst =
//                                 calGst(mrp_price, products1[index].cgst ?? "");

//                             String adiscount = calDiscount(
//                                 products1[index].buyPrice ?? "",
//                                 products1[index].msrp != null
//                                     ? products1[index].msrp ?? ""
//                                     : "0");

//                             admindiscountprice =
//                                 (double.parse(products1[index].buyPrice ?? "") -
//                                     double.parse(adiscount));

//                             String color = "";
//                             String size = "";

//                             // String mv=  pref.getString("mvid",);

//                             _addToproducts(
//                                 products1[index].productIs ?? "",
//                                 products1[index].productName ?? "",
//                                 products1[index].img ?? "",
//                                 int.parse(mrp_price),
//                                 int.parse(products1[index].count ?? ""),
//                                 color,
//                                 size,
//                                 products1[index].productDescription ?? "",
//                                 gst_sgst,
//                                 gst_cgst,
//                                 products1[index].discount ?? "",
//                                 dicountValue.toString(),
//                                 products1[index].APMC ?? "",
//                                 admindiscountprice.toString(),
//                                 products1[index].buyPrice ?? "",
//                                 products1[index].shipping ?? "",
//                                 products1[index].quantityInStock ?? "",
//                                 products1[index].youtube ?? "",
//                                 products1[index].mv ?? "");

// //                                                                Navigator.push(context,
// //                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
//                           } else {
//                             showAlertDialog(context, products1[index]);
//                           }
//                         } else {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SignInPage()),
//                           );
//                         }

// //
//                       },
//                       child: Padding(
//                           padding: EdgeInsets.only(
//                               left: 5, top: 5, bottom: 5, right: 5),
//                           child: Center(
//                               child: Text(
//                             "ADD",
//                             style: TextStyle(color: FoodAppColors.black),
//                           )
//                               // Icon(Icons.add_shopping_cart,color: Colors.white,),

//                               )),
//                     ),
//                   )),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String calDiscount(String byprice, String discount2) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(discount2);

//     discount = (byprice1 - (byprice1 * discount1) / 100.0);

//     returnStr = discount.toStringAsFixed(FoodAppConstant.val);
//     print(returnStr);
//     return returnStr;
//   }

//   int? total;

//   _displayDialog(BuildContext context, String id, int index1) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             scrollable: true,
//             title: Text('Select Varant'),
//             content: Container(
//               width: double.maxFinite,
//               height: 200,
//               child: FutureBuilder(
//                   future: getPvarient(id),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return snapshot.data == null
//                           ? Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : ListView.builder(
//                               scrollDirection: Axis.vertical,
//                               itemCount: snapshot.data!.length == null
//                                   ? 0
//                                   : snapshot.data?.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Container(
//                                   width:
//                                       snapshot.data![index] != 0 ? 130.0 : 230.0,
//                                   color: Colors.white,
//                                   margin: EdgeInsets.only(right: 10),
//                                   child: InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         products1[index1].buyPrice =
//                                             snapshot.data![index].price;
//                                         products1[index1].discount =
//                                             snapshot.data![index].discount;

//                                         // total= int.parse(snapshot.data[index].price);
//                                         // String  mrp_price=calDiscount(snapshot.data[index].price,snapshot.data[index].discount);
//                                         // totalmrp= double.parse(mrp_price);
//                                         products1[index1].youtube =
//                                             snapshot.data![index].variant;

//                                         Navigator.pop(context);
//                                       });
//                                     },
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 10, right: 10),
//                                           child: Text(
//                                             snapshot.data![index].variant ?? "",
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 2,
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               color: FoodAppColors.black,
//                                             ),
//                                           ),
//                                         ),
//                                         Divider(
//                                           color: FoodAppColors.black,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               });
//                     }
//                     return Center(child: CircularProgressIndicator());
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

//   showAlertDialog(BuildContext context, Products pro) {
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: Text("Yes"),
//       onPressed: () {
//         dbmanager.deleteallProducts();

//         FoodAppConstant.itemcount = 0;
//         FoodAppConstant.foodAppCartItemCount = 0;
//         foodCartItemCount(FoodAppConstant.foodAppCartItemCount);

//         String mrp_price = calDiscount(pro.buyPrice ?? "", pro.discount ?? "");
//         totalmrp = double.parse(mrp_price);
//         String color = "";
//         String size = "";
//         double dicountValue = double.parse(pro.buyPrice ?? "") - totalmrp!;
//         String gst_sgst = calGst(mrp_price, pro.sgst ?? "");
//         String gst_cgst = calGst(mrp_price, pro.cgst ?? "");
//         String adiscount = calDiscount(
//             pro.buyPrice ?? "", pro.msrp != null ? pro.msrp ?? "" : "0");
//         admindiscountprice =
//             (double.parse(pro.buyPrice ?? "") - double.parse(adiscount));

//         pref!.setString("mvid", pro.mv ?? "");
//         _addToproducts(
//             pro.productIs ?? "",
//             pro.productName ?? "",
//             pro.img ?? "",
//             int.parse(mrp_price),
//             int.parse(pro.count ?? ""),
//             color,
//             size,
//             pro.productDescription ?? "",
//             gst_sgst,
//             gst_cgst,
//             pro.discount ?? "",
//             dicountValue.toString(),
//             pro.APMC ?? "",
//             admindiscountprice.toString(),
//             pro.buyPrice ?? "",
//             pro.shipping ?? "",
//             pro.quantityInStock ?? "",
//             pro.youtube ?? "",
//             pro.mv ?? "");

//         setState(() {
// //                                                                              cartvalue++;
// //           Constant.carditemCount++;
// //           cartItemcount(Constant.carditemCount);

//           Navigator.of(context).pop();
//           // _ProductList1Stateq.val=Constant.carditemCount++;
//         });

//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductShow(widget.cat,widget.title)),);
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text("No"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Replace cart item?",
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       content: Text(
//           "Your cart contains dishes from different Restaurant. Do you want to discard the selection and add this" +
//               pro.productName.toString()),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   final DbProductManager dbmanager = new DbProductManager();

//   ProductsCart? products2;
// //cost_price=buyprice

//   void _addToproducts(
//       String pID,
//       String p_name,
//       String image,
//       int price,
//       int quantity,
//       String c_val,
//       String p_size,
//       String p_disc,
//       String sgst,
//       String cgst,
//       String discount,
//       String dis_val,
//       String adminper,
//       String adminper_val,
//       String cost_price,
//       String shippingcharge,
//       String totalQun,
//       String varient,
//       String mv) {
//     ProductsCart st = new ProductsCart(
//         pid: pID,
//         pname: p_name,
//         pimage: image,
//         pprice: (price * quantity).toString(),
//         pQuantity: quantity,
//         pcolor: c_val ?? "",
//         psize: p_size ?? "",
//         pdiscription: p_disc,
//         sgst: sgst,
//         cgst: cgst,
//         discount: discount,
//         discountValue: dis_val,
//         adminper: adminper,
//         adminpricevalue: adminper_val,
//         costPrice: cost_price,
//         shipping: shippingcharge,
//         totalQuantity: totalQun,
//         varient: varient,
//         mv: int.parse(mv));
//     dbmanager.getProductList1(pID).then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           if (usersFromServe.length > 0) {
//             products2 = usersFromServe[0];
//             st.quantity = products2!.quantity + st.quantity;
//             st.pprice = (double.parse(products2!.pprice??"") + (totalmrp! * quantity))
//                 .toString();

//             // st.quantity++;
//             if (st.quantity <= int.parse(totalQun)) {
//               dbmanager.updateStudent1(st).then((id) => {
//                     showLongToast('Serviceadded to your cart'),
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WishList(),
//                       ),
//                     ),
//                   });
//             } else {
//               showLongToast('Serviceadded to your cart');
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => WishList(),
//                 ),
//               );
//             }
//           } else {
//             dbmanager.insertStudent(st).then((id) => {
//                   showLongToast('Serviceadded to your cart'),
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WishList(),
//                     ),
//                   ),
//                   setState(() {
//                     FoodAppConstant.foodAppCartItemCount++;
//                     foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
//                   })
//                 });
//           }
//         });
//       }
//     });
//   }

//   String calGst(String byprice, String sgst) {
//     String returnStr;
//     double discount = 0.0;
//     if (sgst.length > 1) {
//       returnStr = discount.toString();
//       double byprice1 = double.parse(byprice);
//       print(sgst);

//       double discount1 = double.parse(sgst);

//       discount = ((byprice1 * discount1) / (100.0 + discount1));

//       returnStr = discount.toStringAsFixed(2);
//       print(returnStr);
//       return returnStr;
//     } else {
//       return '0';
//     }
//   }

//   void _modalBottomSheetMenu(int index) {
//     showModalBottomSheet(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         context: context,
//         isScrollControlled: true,
//         builder: (builder) {
//           return new Container(
//             height: MediaQuery.of(context).size.height / 2,

//             color: Colors.transparent, //could change this to Color(0xFF737373),
//             //so you don't have to change MaterialApp canvasColor
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
//                   width: MediaQuery.of(context).size.width,
//                   height: 200,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(14)),
//                       color: Colors.blue.shade200,
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: NetworkImage(
//                             products1[index].img != null
//                                 ? FoodAppConstant.Base_Imageurl +
//                                     products1[index].img.toString()
//                                 : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
//                           ))),
//                 ),
//                 Container(
//                   margin:
//                       EdgeInsets.only(right: 8, left: 10, top: 8, bottom: 8),
//                   child: Text(
//                     products1[index].productName == null
//                         ? 'name'
//                         : products1[index].productName??"",
//                     overflow: TextOverflow.fade,
//                     style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black)
//                         .copyWith(fontSize: 14),
//                   ),
//                 ),
//                 SizedBox(height: 6),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: 10,
//                     right: 10,
//                   ),
//                   child: Text(
//                     "${products1[index].productDescription}",
//                     maxLines: 4,
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.justify,
//                   ),
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(top: 2.0, bottom: 1, left: 10),
//                       child: Text(
//                           '\u{20B9} ${calDiscount(products1[index].buyPrice??"", products1[index].discount??"")}',
//                           style: TextStyle(
//                             color: FoodAppColors.sellp,
//                             fontWeight: FontWeight.w700,
//                           )),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Expanded(
//                       child: Text(
//                         '(\u{20B9} ${products1[index].buyPrice})',
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontStyle: FontStyle.italic,
//                             color: FoodAppColors.mrp,
//                             decoration: TextDecoration.lineThrough),
//                       ),
//                     )
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(right: 20),
//                         child: addProduct(index, 1)),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }

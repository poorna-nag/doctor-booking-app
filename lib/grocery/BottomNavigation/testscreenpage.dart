// import 'dart:math';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:aladdinmart/grocery/Auth/signin.dart';
// import 'package:aladdinmart/grocery/General/AppConstant.dart';
// import 'package:aladdinmart/grocery/General/Home.dart';
// import 'package:aladdinmart/grocery/dbhelper/CarrtDbhelper.dart';
// import 'package:aladdinmart/grocery/BottomNavigation/categories.dart';

// import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
// import 'package:aladdinmart/grocery/model/CategaryModal.dart';
// import 'package:aladdinmart/grocery/model/Gallerymodel.dart';
// import 'package:aladdinmart/grocery/model/productmodel.dart';
// import 'package:aladdinmart/grocery/model/slidermodal.dart';
// import 'package:aladdinmart/grocery/screen/SearchScreen.dart';
// import 'package:aladdinmart/grocery/screen/SubCategry.dart';
// import 'package:aladdinmart/grocery/screen/detailpage.dart';
// import 'package:aladdinmart/grocery/screen/detailpage1.dart';
// import 'package:aladdinmart/grocery/screen/productlist.dart';
// import 'package:aladdinmart/grocery/screen/secondtabview.dart';
// import 'package:new_version/new_version.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Screen extends StatefulWidget {
//   @override
//   ScreenState createState() => ScreenState();
// }

// class ScreenState extends State<Screen> {
//   static int cartvalue = 0;

//   bool progressbar = true;

//   static List<String> imgList5 = [
//     'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
//     'https://www.thebalanceeveryday.com/thmb/lMeVfLyCZWVPdU5eyjFLyK4AYQs=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/metrostyle-catalog-df95d1ece06c4197b1da85e316a05f90.jpg',
//     'https://rukminim1.flixcart.com/image/400/450/k3xcdjk0pkrrdj/sari/h/d/x/free-multicolor-combosr-28001-ishin-combosr-28001-original-imafa5257bxdzm5j.jpeg?q=90',
//     'https://i.pinimg.com/474x/62/4e/ce/624ece8daf9650f1a382995b340dc1e9.jpg'
//   ];

//   int _current = 0;
//   var _start = 0;
//   static List<Categary> list = new List<Categary>();
//   static List<Categary> list1 = new List<Categary>();
//   static List<Categary> list2 = new List<Categary>();
//   static List<Slider1> sliderlist = List<Slider1>();

//   static List<Products> topProducts = List();
//   static List<Products> topProducts1 = List();
//   static List<Products> dilofdayProducts = [];
//   static List<Slider1> bannerSlider = List();
//   List<Gallery> galiryImage = List();
//   final List<String> imgL = List();
//   List<Products> products1 = List();
//   double sgst1, cgst1, dicountValue, admindiscountprice;

//   double mrp, totalmrp = 000;
//   int _count = 1;

//   // PackageInfo packageInfo ;
//   // AppUpdateInfo _updateInfo;
//   String lastversion = "0";
//   int valcgeck;
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

//   /* Future<void> checkForUpdate(BuildContext contex) async {
//     packageInfo = await PackageInfo.fromPlatform();
//     String version = packageInfo.version;
//     lastversion=version.substring(version.lastIndexOf(".")+1);

//     InAppUpdate.checkForUpdate().then((info) {
//       setState(() {
//         valcgeck=int.parse(lastversion);
//         _updateInfo = info;
//         if(_updateInfo?.updateAvailable){
//           Showpop();
//         }
//         _updateInfo?.updateAvailable == true;
//         print(_updateInfo);
//         print(version);
//         print(_updateInfo.availableVersionCode-valcgeck);
//         print(lastversion);
//         print("_updateInfo.......");

// //        showDilogue(contex);
//         print(_updateInfo);
//       });
//     }).catchError((e) => _showError(e));
//   }*/

//   getPackageInfo() async {
//     NewVersion newVersion = NewVersion(context: context);
//     final status = await newVersion.getVersionStatus();
//     // status.canUpdate; // (true)
//     // status.localVersion ;// (1.2.1)
//     // status.storeVersion; // (1.2.3)
//     // status.appStoreLink;
//     newVersion.showAlertIfNecessary();
//     // print(status.canUpdate);
//     // print(status.localVersion);
//     // print(status.storeVersion);
//     // print(status.appStoreLink);
//   }

//   final addController = TextEditingController();

//   Position position;
//   getAddress(double lat, double long) async {
//     final coordinates = new Coordinates(lat, long);
//     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     setState(() {
//       var address = first.subLocality.toString() +
//           " " +
//           first.subAdminArea.toString() +
//           " " +
//           first.featureName.toString() +
//           " " +
//           first.thoroughfare.toString();

//       addController.text = address.replaceAll("null", "");
//       // print('Rahul ${address}');
//       // pref.setString("lat", lat.toString());
//       // pref.setString("lat", lat.toString());
//       // pref.setString("add", address.toString().replaceAll("null", ""));
//     });
//   }

//   void _getCurrentLocation() async {
//     Position res = await Geolocator.getCurrentPosition();
//     setState(() {
//       position = res;
//       GroceryAppConstant.latitude = position.latitude;
//       GroceryAppConstant.longitude = position.longitude;
//       print(' lat ${GroceryAppConstant.latitude},${GroceryAppConstant.longitude}');
//       getAddress(GroceryAppConstant.latitude, GroceryAppConstant.longitude);
//     });
//   }

//   @override
//   void initState() {
//     _getCurrentLocation();
//     super.initState();

//     if (GroceryAppConstant.Checkupdate) {
//       getPackageInfo();
//       GroceryAppConstant.Checkupdate = false;
//     }
//     // checkForUpdate(context);

//     DatabaseHelper.getData("0").then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           list = usersFromServe;
//         });
//       }
//     });

//     DatabaseHelper.getSlider().then((usersFromServe1) {
//       if (this.mounted) {
//         setState(() {
//           sliderlist = usersFromServe1;
//         });
//       }
//     });

//     DatabaseHelper.getTopProduct("top", "0").then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           ScreenState.topProducts = usersFromServe;
// //          ScreenState.topProducts.add(topProducts[0]);
//         });
//       }
//     });
//     DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           ScreenState.topProducts1 = usersFromServe;
// //          ScreenState.topProducts.add(topProducts[0]);
//         });
//       }
//     });

//     DatabaseHelper.getfeature("yes", "10").then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           products1 = usersFromServe;
// //          ScreenState.topProducts.add(topProducts[0]);
//         });
//       }
//     });
//     getBanner().then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           bannerSlider = usersFromServe;
// //          ScreenState.topProducts.add(topProducts[0]);
//         });
//       }
//     });

// //    search
//     DatabaseHelper.getTopProduct1("new", "0").then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           ScreenState.dilofdayProducts = usersFromServe;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     addController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
// //    showDilogue(context);
//     return Container(
//         color: GroceryAppColors.white,
//         child: CustomScrollView(slivers: <Widget>[
//           SliverList(
//             // Use a delegate to build items as they're scrolled on screen.
//             delegate: SliverChildBuilderDelegate(
//               // The builder function returns a ListTile with a title that
//               // displays the index of the current item.
//               (context, index) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     color: GroceryAppColors.tela,
//                     child: GestureDetector(
//                       onTap: () {
//                         _getCurrentLocation();
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => UserFilterDemo()),);
//                       },
//                       child: Card(
//                         color: GroceryAppColors.tela,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         elevation: 0.0,
//                         child: Container(
//                           height: 40,
//                           color: GroceryAppColors.white,
//                           margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//                           padding: EdgeInsets.only(top: 0, bottom: 0),
//                           child: TextField(
//                             controller: addController,
//                             enabled: false,
//                             style: TextStyle(fontSize: 12),
//                             obscureText: false,
//                             decoration: InputDecoration(
//                                 hintText: "Your current location",
//                                 hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
//                                 prefixIcon: Icon(
//                                   Icons.location_on,
//                                   color: GroceryAppColors.tela,
//                                 )),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   sliderlist != null
//                       ? sliderlist.length > 0
//                           ? Container(
//                               color: GroceryAppColors.white,
//                               height: 170.0,
//                               child: sliderlist != null
//                                   ? sliderlist.length > 0
//                                       ? CarouselSlider.builder(
//                                           itemCount: sliderlist.length,
//                                           options: CarouselOptions(
//                                             aspectRatio: 2.4,
//                                             viewportFraction: 0.92,
//                                             // enlargeCenterPage: true,
//                                             autoPlay: true,
//                                           ),
//                                           itemBuilder: (ctx, index, realIdx) {
//                                             return Container(
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   if (!sliderlist[index].title.isEmpty) {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(builder: (context) => Screen2(sliderlist[index].title, "")),
//                                                     );
//                                                   } else if (!sliderlist[index].description.isEmpty) {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(builder: (context) => ProductDetails1(sliderlist[index].description)),
//                                                     );
// //

//                                                   }
//                                                 },
//                                                 child: Container(
//                                                     margin: EdgeInsets.only(left: 5.0, right: 5),
//                                                     child: ClipRRect(
//                                                         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                                         child: CachedNetworkImage(
//                                                           width: MediaQuery.of(context).size.width - 30,
//                                                           fit: BoxFit.fill,
//                                                           imageUrl: GroceryAppConstant.Base_Imageurl + sliderlist[index].img,
//                                                           placeholder: (context, url) => Center(child: CircularProgressIndicator()),
//                                                           errorWidget: (context, url, error) => new Icon(Icons.error),
//                                                         ))),
//                                               ),
//                                             );
//                                           },
//                                         )
//                                       : Center(
//                                           child: CircularProgressIndicator(
//                                             backgroundColor: GroceryAppColors.tela,
//                                           ),
//                                         )
//                                   : Row())
//                           : Container()
//                       : Container(),

//                   Container(
//                     height: 100,
//                     width: MediaQuery.of(context).size.width,
//                     margin: EdgeInsets.all(8),
//                     padding: EdgeInsets.all(10),
//                     decoration: new BoxDecoration(
// //                              color: AppColors.white,
//                       border: Border.all(color: Colors.green),

//                       image: DecorationImage(
//                         fit: BoxFit.fill,
//                         image: AssetImage("assets/images/banner1.jpeg"),
//                       ),
//                       borderRadius: BorderRadius.circular(10),

//                       color: Colors.white,
//                     ),
//                   ),

//                   list != null
//                       ? list.length > 0
//                           ? Container(
//                               color: GroceryAppColors.white,
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                                     child: Text(
//                                       "Shop By Categories",
//                                       style: TextStyle(
//                                           color: GroceryAppColors.product_title_name,
//                                           fontSize: 15,
//                                           fontFamily: 'Roboto',
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Container()
//                       : Container(),
//                   list != null
//                       ? Container(
//                           color: GroceryAppColors.white,
//                           padding: EdgeInsets.symmetric(vertical: 0.0),
// //                    margin: EdgeInsets.symmetric(vertical: 8.0),
//                           height: 170.0,

//                           child: list != null
//                               ? list.length != null
//                                   ? ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: list.length == null ? 0 : list.length,
//                                       itemBuilder: (BuildContext context, int index) {
//                                         return Container(
//                                             margin: EdgeInsets.symmetric(horizontal: 5),
//                                             child: Column(
//                                               children: <Widget>[
//                                                 Card(
//                                                   // color: AppColors.black,

//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(10.0),
//                                                   ),
//                                                   child: Material(
//                                                     color: GroceryAppColors.white,
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(builder: (context) => Cgategorywise("0")),
//                                                         );
//                                                         // Navigator.push(context, MaterialPageRoute(builder: (context) => Sbcategory(list[index].pCats, list[index].pcatId)),);
//                                                       },
//                                                       child: Container(
//                                                         height: 150.0,
//                                                         width: 150.0,
//                                                         decoration: new BoxDecoration(
//                                                             borderRadius: BorderRadius.circular(10),
//                                                             image: DecorationImage(
//                                                                 image: list[index].img.isEmpty
//                                                                     ? AssetImage(
//                                                                         "assets/images/logo.png",
//                                                                       )
//                                                                     : NetworkImage(
//                                                                         GroceryAppConstant.base_url + "manage/uploads/p_category/" + list[index].img),
//                                                                 fit: BoxFit.cover)),
//                                                         child: Container(
// //
//                                                           decoration: BoxDecoration(
//                                                             // color: AppColors.tela1,
//                                                             borderRadius: BorderRadius.circular(10),
//                                                           ),
//                                                           child: Align(
//                                                               alignment: Alignment.bottomCenter,
//                                                               child: Container(
//                                                                 alignment: Alignment.center,
//                                                                 decoration: BoxDecoration(
//                                                                   color: GroceryAppColors.tela,
//                                                                   borderRadius: BorderRadius.only(
//                                                                       bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
//                                                                 ),
//                                                                 width: MediaQuery.of(context).size.width,
//                                                                 height: 28,
//                                                                 child: Text(
//                                                                   list[index].pCats,
//                                                                   maxLines: 1,
//                                                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
//                                                                 ),
//                                                               )),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ));
//                                       },
//                                     )
//                                   : Center(
//                                       child: CircularProgressIndicator(
//                                         backgroundColor: GroceryAppColors.tela,
//                                       ),
//                                     )
//                               : Container(),
//                         )
//                       : Row(),

//                   Container(
//                     height: 110,
//                     width: MediaQuery.of(context).size.width,
//                     margin: EdgeInsets.all(8),
//                     padding: EdgeInsets.all(10),
//                     decoration: new BoxDecoration(
// //                              color: AppColors.white,

//                       image: DecorationImage(
//                         fit: BoxFit.fill,
//                         image: AssetImage("assets/images/banner2.jpeg"),
//                       ),
//                       borderRadius: BorderRadius.circular(10),

//                       color: Colors.white,
//                     ),
//                   ),

//                   topProducts != null
//                       ? topProducts.length > 0
//                           ? Container(
//                               color: GroceryAppColors.white,
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                                     child: Text(
//                                       GroceryAppConstant.AProduct_type_Name1,
//                                       style: TextStyle(
//                                           color: GroceryAppColors.product_title_name,
//                                           fontSize: 15,
//                                           fontFamily: 'Roboto',
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
//                                     child: RaisedButton(
//                                         color: GroceryAppColors.tela,
//                                         child: Text('View All', style: TextStyle(color: Colors.black)),
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => ProductList("Top", GroceryAppConstant.AProduct_type_Name1)),
//                                           );
//                                         }),
//                                   )
//                                 ],
//                               ),
//                             )
//                           : Container()
//                       : Container(),

//                   topProducts != null
//                       ? topProducts.length > 0
//                           ? Container(
// //                            color: AppColors.black,
//                               height: 280.0,

//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(0),
//                                   gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
//                                     Colors.blue.withOpacity(.4),
//                                     Colors.teal.withOpacity(.1),
//                                   ])),
//                               child: topProducts != null
//                                   ? Container(
// //                              color: AppColors.tela,
//                                       margin: EdgeInsets.only(left: 8.0, top: 20, bottom: 20),
//                                       height: 230.0,
//                                       child: ListView.builder(
//                                           scrollDirection: Axis.horizontal,
//                                           itemCount: topProducts.length == null ? 0 : topProducts.length,
//                                           itemBuilder: (BuildContext context, int index) {
//                                             return Stack(
//                                               children: [
//                                                 Container(
//                                                   width: topProducts[index] != 0 ? 160.0 : 230.0,
//                                                   color: Colors.white,
//                                                   margin: EdgeInsets.only(right: 10),
//                                                   child: Column(
//                                                     children: <Widget>[
// //                                          shape: RoundedRectangleBorder(
// //                                            borderRadius: BorderRadius.circular(
// //                                                10.0),
// //                                          ),

//                                                       InkWell(
//                                                         onTap: () {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(builder: (context) => ProductDetails(topProducts[index])),
//                                                           );
// //
//                                                         },
//                                                         child: Column(
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: <Widget>[
//                                                             SizedBox(
//                                                               height: 130,
// //                                            width: 162,

//                                                               child: topProducts[index].img != null
//                                                                   ? Image.network(
//                                                                       GroceryAppConstant.Product_Imageurl + topProducts[index].img,
//                                                                       fit: BoxFit.fill,
//                                                                     )
//                                                                   /* CachedNetworkImage(
//                                                           fit: BoxFit.cover,
//                                                           imageUrl: Constant
//                                                               .Product_Imageurl +
//                                                               topProducts[index].img,
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                           placeholder: (context, url) =>
//                                                               Center(
//                                                                   child:
//                                                                   CircularProgressIndicator()),
//                                                           errorWidget:
//                                                               (context, url, error) =>
//                                                           new Icon(Icons.error),

//                                                         )*/
//                                                                   : Image.asset("assets/images/logo.png"),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),

//                                                       Expanded(
//                                                         child: Container(
//                                                           margin: EdgeInsets.only(left: 5, right: 5, top: 5),
//                                                           padding: EdgeInsets.only(left: 3, right: 5),
//                                                           color: GroceryAppColors.white,
//                                                           child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: <Widget>[
//                                                               Text(
//                                                                 topProducts[index].productName,
//                                                                 overflow: TextOverflow.ellipsis,
//                                                                 maxLines: 2,
//                                                                 style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   color: GroceryAppColors.black,
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 8,
//                                                               ),
//                                                               Text(
//                                                                 '(\u{20B9} ${topProducts[index].buyPrice})',
//                                                                 overflow: TextOverflow.ellipsis,
//                                                                 maxLines: 2,
//                                                                 style: TextStyle(
//                                                                     fontWeight: FontWeight.w700,
//                                                                     fontStyle: FontStyle.italic,
//                                                                     fontSize: 12,
//                                                                     color: GroceryAppColors.black,
//                                                                     decoration: TextDecoration.lineThrough),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 8,
//                                                               ),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                                                 child: Text(
//                                                                     '\u{20B9} ${calDiscount(topProducts[index].buyPrice, topProducts[index].discount)} ${topProducts[index].unit_type != null ? "/" + topProducts[index].unit_type : ""}',
//                                                                     style: TextStyle(
//                                                                         color: GroceryAppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 double.parse(topProducts[index].discount) > 0 ? showSticker(index, topProducts) : Row()
//                                               ],
//                                             );
//                                           }),
//                                     )
//                                   : Center(
//                                       child: CircularProgressIndicator(
//                                         backgroundColor: GroceryAppColors.tela,
//                                       ),
//                                     ),
//                             )
//                           : Container()
//                       : Container(),

//                   topProducts1 != null
//                       ? topProducts1.length > 0
//                           ? Container(
//                               color: GroceryAppColors.white,
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                                     child: Text(
//                                       'Deals of the day',
//                                       style: TextStyle(
//                                           color: GroceryAppColors.product_title_name,
//                                           fontSize: 15,
//                                           fontFamily: 'Roboto',
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
//                                     child: RaisedButton(
//                                         color: GroceryAppColors.tela,
//                                         child: Text('View All', style: TextStyle(color: Colors.black)),
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => ProductList("day", "Deals of the day")),
//                                           );
//                                         }),
//                                   )
//                                 ],
//                               ),
//                             )
//                           : Container()
//                       : Container(),
//                   topProducts1 != null
//                       ? topProducts1.length > 0
//                           ? Container(
//                               // color: AppColors.black,
//                               margin: EdgeInsets.only(left: 8.0, top: 20, bottom: 20),
//                               height: 230.0,
//                               child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: topProducts1.length == null ? 0 : topProducts1.length,
//                                   itemBuilder: (BuildContext context, int index) {
//                                     return Stack(
//                                       children: [
//                                         Container(
//                                           width: topProducts1[index] != 0 ? 170.0 : 230.0,
//                                           color: Colors.white,
//                                           margin: EdgeInsets.only(right: 10),
//                                           child: Card(
//                                             child: Column(
//                                               children: <Widget>[
// //                                          shape: RoundedRectangleBorder(
// //                                            borderRadius: BorderRadius.circular(
// //                                                10.0),
// //                                          ),

//                                                 InkWell(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(builder: (context) => ProductDetails(topProducts1[index])),
//                                                     );
// //
//                                                   },
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: <Widget>[
//                                                       SizedBox(
//                                                         height: 130,
// //                                            width: 162,

//                                                         child: topProducts1[index].img != null
//                                                             ? Image.network(
//                                                                 GroceryAppConstant.Product_Imageurl + topProducts1[index].img,
//                                                                 fit: BoxFit.fill,
//                                                               )

//                                                             /*  CachedNetworkImage(
//                                                           fit: BoxFit.cover,
//                                                           imageUrl: Constant
//                                                               .Product_Imageurl +
//                                                               topProducts1[index].img,
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                           placeholder: (context, url) =>
//                                                               Center(
//                                                                   child:
//                                                                   CircularProgressIndicator()),
//                                                           errorWidget:
//                                                               (context, url, error) =>
//                                                           new Icon(Icons.error),

//                                                         )*/

//                                                             : Image.asset("assets/images/logo.png"),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),

//                                                 Expanded(
//                                                   child: Container(
//                                                     margin: EdgeInsets.only(left: 5, right: 5, top: 5),
//                                                     padding: EdgeInsets.only(left: 3, right: 5),
//                                                     color: GroceryAppColors.white,
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: <Widget>[
//                                                         Text(
//                                                           topProducts1[index].productName,
//                                                           overflow: TextOverflow.ellipsis,
//                                                           maxLines: 2,
//                                                           style: TextStyle(
//                                                             fontSize: 12,
//                                                             color: GroceryAppColors.black,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 8,
//                                                         ),
//                                                         Text(
//                                                           '(\u{20B9} ${topProducts1[index].buyPrice})',
//                                                           overflow: TextOverflow.ellipsis,
//                                                           maxLines: 2,
//                                                           style: TextStyle(
//                                                               fontWeight: FontWeight.w700,
//                                                               fontStyle: FontStyle.italic,
//                                                               fontSize: 12,
//                                                               color: GroceryAppColors.black,
//                                                               decoration: TextDecoration.lineThrough),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 8,
//                                                         ),
//                                                         Padding(
//                                                           padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                                           child: Text(
//                                                               '\u{20B9} ${calDiscount(topProducts1[index].buyPrice, topProducts1[index].discount)} ${topProducts1[index].unit_type != null ? "/" + topProducts1[index].unit_type : ""}',
//                                                               style: TextStyle(
//                                                                   color: GroceryAppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         double.parse(topProducts1[index].discount) > 0 ? showSticker(index, topProducts1) : Row()
//                                       ],
//                                     );
//                                   }),
//                             )
//                           : Container()
//                       : Container(),
//                   Container(
//                     height: 150,
//                     width: MediaQuery.of(context).size.width,
//                     margin: EdgeInsets.only(bottom: 5, left: 8, right: 8, top: 5),
//                     padding: EdgeInsets.all(8),
//                     decoration: new BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(10),

// //                              color: AppColors.white,
//                       image: DecorationImage(
//                         fit: BoxFit.fill,
//                         image: AssetImage("assets/images/banner2.jpeg"),
//                       ),

//                       // color: Colors.white,
//                     ),
//                   ),

//                   /* FutureBuilder(
//                               future: getBanner(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ListView.builder(
//                                     itemCount: snapshot.data.length == null
//                                         ? 0
//                                         : snapshot.data.length,

//                                     shrinkWrap: true,
//                                     primary: false,
//                                     scrollDirection: Axis.vertical,
//                                     itemBuilder: (BuildContext context,
//                                         int index) {
//                                       Slider1 item = snapshot.data[index];
//                                       return InkWell(
//                                           onTap: () {
//                                             // print(item.title + "TITLE");
//                                             // print(item.description + "DESCR");
//                                             if (!item.title.isEmpty) {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         Screen2(
//                                                             item.title, "")),
//                                               );
//                                             }
//                                             else
//                                             if (!item.description.isEmpty) {
//                                               Navigator.push(context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ProductDetails1(item
//                                                             .description)),);
// //

//                                             }
//                                           },

//                                           child: Container(
//                                             padding: EdgeInsets.only(
//                                                 top: 6.0,
//                                                 left: 8.0,
//                                                 right: 8.0,
//                                                 bottom: 5),
//                                             child: CachedNetworkImage(
//                                               fit: BoxFit.cover,
//                                               imageUrl: Constant
//                                                   .Product_Imageurl5 + item.img,
//                                               placeholder: (context, url) =>
//                                                   Center(
//                                                       child:
//                                                       CircularProgressIndicator()),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                               new Icon(Icons.error),

//                                             ),
//                                           )
//                                       );
//                                     },

//                                   );
//                                 }
//                                 else {
//                                   return Center(
//                                       child: CircularProgressIndicator());
//                                 }
//                               }
//                           ),*/

//                   bannerSlider != null
//                       ? bannerSlider.length > 0
//                           ? Container(
//                               padding: EdgeInsets.only(bottom: 10),
//                               color: GroceryAppColors.tela1,
//                               child: GridView.count(
//                                   physics: ClampingScrollPhysics(),
//                                   controller: new ScrollController(keepScrollOffset: false),
//                                   shrinkWrap: true,
//                                   crossAxisCount: 2,
//                                   childAspectRatio: 0.8,
//                                   padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 0),
//                                   children: List.generate(bannerSlider.length, (index) {
//                                     return InkWell(
//                                         onTap: () {
//                                           // print(item.title + "TITLE");
//                                           // print(item.description + "DESCR");
//                                           if (!bannerSlider[index].title.isEmpty) {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(builder: (context) => Screen2(bannerSlider[index].title, "")),
//                                             );
//                                           } else if (!bannerSlider[index].description.isEmpty) {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(builder: (context) => ProductDetails1(bannerSlider[index].description)),
//                                             );
// //

//                                           }
//                                         },
//                                         child: Container(
//                                             padding: EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0, bottom: 5),
//                                             child: Image.network(
//                                               GroceryAppConstant.Product_Imageurl5 + bannerSlider[index].img,
//                                               fit: BoxFit.fill,
//                                             )

//                                             /*CachedNetworkImage(
//                                           fit: BoxFit.fill,
//                                           imageUrl: Constant
//                                               .Product_Imageurl5 + bannerSlider[index].img,
//                                           placeholder: (context, url) =>
//                                               Center(
//                                                   child:
//                                                   CircularProgressIndicator()),
//                                           errorWidget:
//                                               (context, url, error) =>
//                                           new Icon(Icons.error),

//                                         ),*/
//                                             ));
//                                   })),
//                             )
//                           : Container()
//                       : Container(),

//                   dilofdayProducts != null
//                       ? dilofdayProducts.length > 0
//                           ? Container(
//                               color: Colors.white,
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                                     child: Text(
//                                       GroceryAppConstant.AProduct_type_Name2,
//                                       style: TextStyle(
//                                           color: GroceryAppColors.product_title_name,
//                                           fontSize: 15,
//                                           fontFamily: 'Roboto',
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
//                                     child: RaisedButton(
//                                         color: GroceryAppColors.tela,
//                                         child: Text('View All', style: TextStyle(color: Colors.black)),
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => ProductList("new", GroceryAppConstant.AProduct_type_Name2)),
//                                           );
//                                         }),
//                                   )
//                                 ],
//                               ),
//                             )
//                           : Container()
//                       : Container(),

//                   dilofdayProducts != null
//                       ? dilofdayProducts.length > 0
//                           ? Container(
//                               color: GroceryAppColors.tela1,
//                               child: GridView.count(
//                                   physics: ClampingScrollPhysics(),
//                                   controller: new ScrollController(keepScrollOffset: false),
//                                   shrinkWrap: true,
//                                   crossAxisCount: 2,
//                                   childAspectRatio: 0.7,
//                                   padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 0),
//                                   children: List.generate(dilofdayProducts.length, (index) {
//                                     return Stack(
//                                       children: [
//                                         Container(
//                                           // height: 190,
//                                           child: Card(
//                                             elevation: 2.0,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(10.0),
//                                             ),
//                                             child: Column(
//                                               children: <Widget>[
//                                                 InkWell(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(builder: (context) => ProductDetails(dilofdayProducts[index],)),
//                                                     );
// //
//                                                   },
//                                                   child: SizedBox(
//                                                     height: 145,
//                                                     width: double.infinity,
//                                                     child: dilofdayProducts[index].img != null
//                                                         ? Image.network(
//                                                             GroceryAppConstant.Product_Imageurl5 + dilofdayProducts[index].img,
//                                                             fit: BoxFit.fill,
//                                                           )
// /*
//                                                   CachedNetworkImage(
//                                                     fit: BoxFit.cover,
//                                                     imageUrl: Constant
//                                                         .Product_Imageurl +
//                                                         dilofdayProducts[index].img,
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                     placeholder: (context, url) =>
//                                                         Center(
//                                                             child:
//                                                             CircularProgressIndicator()),
//                                                     errorWidget:
//                                                         (context, url, error) =>
//                                                     new Icon(Icons.error),

//                                                   )
// */
//                                                         : Image.asset("assets/images/logo.png"),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin: EdgeInsets.only(left: 5, right: 5, top: 5),
//                                                   padding: EdgeInsets.only(left: 3, right: 5),
//                                                   color: GroceryAppColors.white,
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: <Widget>[
//                                                       Text(
//                                                         dilofdayProducts[index].productName,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         maxLines: 2,
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           color: GroceryAppColors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 4,
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Text(
//                                                             '(\u{20B9} ${dilofdayProducts[index].buyPrice})',
//                                                             overflow: TextOverflow.ellipsis,
//                                                             maxLines: 2,
//                                                             style: TextStyle(
//                                                                 fontWeight: FontWeight.w700,
//                                                                 fontStyle: FontStyle.italic,
//                                                                 fontSize: 12,
//                                                                 color: GroceryAppColors.black,
//                                                                 decoration: TextDecoration.lineThrough),
//                                                           ),
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(top: 2.0, bottom: 1, right: 10),
//                                                             child: Text(
//                                                                 '\u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice, dilofdayProducts[index].discount)} ${dilofdayProducts[index].unit_type != null ? "/" + dilofdayProducts[index].unit_type : ""}',
//                                                                 style: TextStyle(
//                                                                     color: GroceryAppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         double.parse(dilofdayProducts[index].discount) > 0 ? showSticker(index, dilofdayProducts) : Row()
//                                       ],
//                                     );
//                                   })),
//                             )
//                           : Container()
//                       : Container(),
//                   //Feature Product
//                   Container(
//                     height: 5,
//                     color: GroceryAppColors.tela1,
//                   ),

//                   products1 != null
//                       ? products1.length > 0
//                           ? Container(
//                               color: Colors.white,
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                                     child: Text(
//                                       "Featured Products",
//                                       style: TextStyle(
//                                           color: GroceryAppColors.product_title_name,
//                                           fontSize: 15,
//                                           fontFamily: 'Roboto',
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
//                                     child: RaisedButton(
//                                         color: GroceryAppColors.tela,
//                                         child: Text('View All', style: TextStyle(color: Colors.black)),
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => ProductList("yes", "Featured Products")),
//                                           );
//                                         }),
//                                   )
//                                 ],
//                               ),
//                             )
//                           : Container()
//                       : Container(),
//                   Container(
//                     height: 10,
//                     color: GroceryAppColors.tela1,
//                   ),

//                   products1 != null
//                       ? products1.length > 0
//                           ? Container(
//                               color: GroceryAppColors.tela1,
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 primary: false,
//                                 scrollDirection: Axis.vertical,
//                                 itemCount: products1.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Stack(
//                                     children: [
//                                       Container(
//                                         margin: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
//                                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
//                                         child: InkWell(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(builder: (context) => ProductDetails(products1[index])),
//                                             );
//                                           },
//                                           child: Container(
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Container(
//                                                   margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
//                                                   width: 110,
//                                                   height: 110,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.all(Radius.circular(14)),
//                                                       color: Colors.blue.shade200,
//                                                       image: DecorationImage(
//                                                           fit: BoxFit.cover,
//                                                           image: NetworkImage(
//                                                             products1[index].img != null
//                                                                 ? GroceryAppConstant.Product_Imageurl + products1[index].img
//                                                                 : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
//                                                           ))),
//                                                 ),
//                                                 Expanded(
//                                                   child: Container(
//                                                     padding: const EdgeInsets.all(8.0),
//                                                     child: Column(
//                                                       mainAxisSize: MainAxisSize.max,
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: <Widget>[
//                                                         Container(
//                                                           child: Text(
//                                                             products1[index].productName == null ? 'name' : products1[index].productName,
//                                                             overflow: TextOverflow.fade,
//                                                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)
//                                                                 .copyWith(fontSize: 14),
//                                                           ),
//                                                         ),
//                                                         SizedBox(height: 6),
//                                                         Row(
//                                                           children: <Widget>[
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                                               child: Text(
//                                                                   '\u{20B9} ${calDiscount(products1[index].buyPrice, products1[index].discount)}  ${products1[index].unit_type != null ? "/" + products1[index].unit_type : ""}',
//                                                                   style: TextStyle(
//                                                                     color: GroceryAppColors.sellp,
//                                                                     fontWeight: FontWeight.w700,
//                                                                   )),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 20,
//                                                             ),
//                                                             Expanded(
//                                                               child: Text(
//                                                                 '(\u{20B9} ${products1[index].buyPrice})',
//                                                                 overflow: TextOverflow.ellipsis,
//                                                                 maxLines: 2,
//                                                                 style: TextStyle(
//                                                                     fontWeight: FontWeight.w700,
//                                                                     fontStyle: FontStyle.italic,
//                                                                     color: GroceryAppColors.mrp,
//                                                                     decoration: TextDecoration.lineThrough),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),

//                                                         /* Container(
//                                                         margin: EdgeInsets.only(left: 0.0,right: 10),
//                                                         child: Row(
//                                                             mainAxisAlignment: MainAxisAlignment.end,
//                                                             children: <Widget>[
//                                                               SizedBox(width: 0.0,height: 10.0,),

//                                                               Column(
//                                                                 children: <Widget>[
//                                                                   Row(
//                                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                                     children: <Widget>[
//                                                                       Container(
//                                                                           height: 25,
//                                                                           width: 35,
//                                                                           child:
//                                                                           Material(

//                                                                             color: AppColors.teladep,
//                                                                             elevation: 0.0,
//                                                                             shape: RoundedRectangleBorder(
//                                                                               side: BorderSide(
//                                                                                 color: Colors.white,
//                                                                               ),
//                                                                               borderRadius: BorderRadius.all(
//                                                                                 Radius.circular(15),
//                                                                               ),
//                                                                             ),
//                                                                             clipBehavior: Clip.antiAlias,
//                                                                             child:Padding (
//                                                                               padding: EdgeInsets.only(bottom: 10),
//                                                                               child: InkWell(
//                                                                                   onTap: () {
//                                                                                     print(products1[index].count);
//                                                                                     if(products1[index].count!="1"){
//                                                                                       setState(() {
// //                                                                                _count++;

//                                                                                         String  quantity=products1[index].count;
//                                                                                         int totalquantity=int.parse(quantity)-1;
//                                                                                         products1[index].count=totalquantity.toString();

//                                                                                       });
//                                                                                     }



// //



//                                                                                   },
//                                                                                   child:Padding(padding: EdgeInsets.only(top:10.0,),

//                                                                                     child:Icon(
//                                                                                       Icons.maximize,size: 20,
//                                                                                       color: Colors.white,
//                                                                                     ),


//                                                                                   )
//                                                                               ),
//                                                                             ),
//                                                                           )),

//                                                                       Padding(
//                                                                         padding:
//                                                                         EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
//                                                                         child:Center(
//                                                                           child:
//                                                                           Text(products1[index].count!=null?'${products1[index].count}':'$_count',

//                                                                               style: TextStyle(
//                                                                                   color: Colors.black,
//                                                                                   fontSize: 19,
//                                                                                   fontFamily: 'Roboto',
//                                                                                   fontWeight: FontWeight.bold)),

//                                                                         ),),

//                                                                       Container(
//                                                                           margin: EdgeInsets.only(left: 3.0),
//                                                                           height: 25,
//                                                                           width: 35,
//                                                                           child:
//                                                                           Material(

//                                                                             color: AppColors.teladep,
//                                                                             elevation: 0.0,
//                                                                             shape: RoundedRectangleBorder(
//                                                                               side: BorderSide(
//                                                                                 color: Colors.white,
//                                                                               ),
//                                                                               borderRadius: BorderRadius.all(
//                                                                                 Radius.circular(15),
//                                                                               ),
//                                                                             ),
//                                                                             clipBehavior: Clip.antiAlias,
//                                                                             child: InkWell(
//                                                                               onTap: () {
//                                                                                 if(int.parse(products1[index].count) <= int.parse(products1[index].quantityInStock)){
//                                                                                   setState(() {
// //                                                                                _count++;

//                                                                                     String  quantity=products1[index].count;
//                                                                                     int totalquantity=int.parse(quantity)+1;
//                                                                                     products1[index].count=totalquantity.toString();

//                                                                                   });
//                                                                                 }
//                                                                                 else{
//                                                                                   showLongToast('Only  ${products1[index].count}  products in stock ');
//                                                                                 }


//                                                                               },


//                                                                               child:Icon(
//                                                                                 Icons.add,size: 20,
//                                                                                 color: Colors.white,
//                                                                               ),


//                                                                             ),
//                                                                           )),
//                                                                     ],
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                               // SizedBox(width: 10,),

//                                                               Column(
//                                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                                                 children: <Widget>[

//                                                                   Container(
//                                                                       margin: EdgeInsets.only(left: 3.0),
//                                                                       height: 40,

//                                                                       child:
//                                                                       Material(

//                                                                         color: AppColors.sellp,
//                                                                         elevation: 0.0,
//                                                                         shape: RoundedRectangleBorder(
//                                                                           side: BorderSide(
//                                                                             color: Colors.white,
//                                                                           ),
//                                                                           borderRadius: BorderRadius.all(
//                                                                             Radius.circular(20),
//                                                                           ),
//                                                                         ),
//                                                                         clipBehavior: Clip.antiAlias,
//                                                                         child: InkWell(
//                                                                           onTap: () {
//                                                                             if(Constant.isLogin){


//                                                                               String  mrp_price=calDiscount(products1[index].buyPrice,products1[index].discount);
//                                                                               totalmrp= double.parse(mrp_price);


//                                                                               double dicountValue=double.parse(products1[index].buyPrice)-totalmrp;
//                                                                               String gst_sgst=calGst(mrp_price,products1[index].sgst);
//                                                                               String gst_cgst=calGst(mrp_price,products1[index].cgst);

//                                                                               String  adiscount=calDiscount(products1[index].buyPrice,products1[index].msrp!=null?products1[index].msrp:"0");

//                                                                               admindiscountprice=(double.parse(products1[index].buyPrice)-double.parse(adiscount));



//                                                                               String color="";
//                                                                               String size="";
//                                                                               _addToproducts(products1[index].productIs,products1[index].productName,products1[index].img,int.parse(mrp_price),int.parse(products1[index].count),color,size,products1[index].productDescription,gst_sgst,gst_cgst,
//                                                                                   products1[index].discount,dicountValue.toString(), products1[index].APMC, admindiscountprice.toString(),products1[index].buyPrice,products1[index].shipping,products1[index].quantityInStock);


//                                                                               setState(() {
// //                                                                              cartvalue++;
//                                                                                 Constant.carditemCount++;
//                                                                                 cartItemcount(Constant.carditemCount);

//                                                                               });

// //                                                                Navigator.push(context,
// //                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

//                                                                             }
//                                                                             else{


//                                                                               Navigator.push(context,
//                                                                                 MaterialPageRoute(builder: (context) => SignInPage()),);
//                                                                             }

// //

//                                                                           },
//                                                                           child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
//                                                                               child:Center(

//                                                                                 child:Icon(Icons.add_shopping_cart,color: Colors.white,),

//                                                                               )),),
//                                                                       )),









//                                                                 ],
//                                                               ),






//                                                             ]
//                                                         ) ,
//                                                       ),*/
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       double.parse(products1[index].discount) > 0 ? showSticker(index, products1) : Row()
//                                     ],
//                                   );
//                                 },
//                               ),
//                             )
//                           : Center(child: Container())
//                       : Row(),

//                   SizedBox(height: 20),
//                 ],
//               ),
//               // Builds 1000 ListTiles
//               childCount: 1,
//             ),
//           )
//         ]));
//   }

//   /*Showpop(){
//     showDialog(
//       barrierDismissible: false, // JUST MENTION THIS LINE
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return WillPopScope(
//           onWillPop: () {},
//           child: AlertDialog(
//               content: Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child:  Container(
//                   height: 110.0,
//                   width: 320.0,

//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                           padding:  EdgeInsets.all(5.0),
//                           child: Text("New Version is avaliable on Playstore",style: TextStyle(fontSize: 18,color: Colors.black),)
//                       ),
// //          Padding(
// //              padding:  EdgeInsets.all(10.0),
// //              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
// //          ),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           (_updateInfo.availableVersionCode-valcgeck)<3? FlatButton(
//                               onPressed: (){
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('Cancel !', style: TextStyle(color: AppColors.black, fontSize: 18.0),)):Row(),

//                           FlatButton(
//                               onPressed: (){
//                                 Navigator.of(context).pop();
//                                 // _launchURL();
//                               },
//                               child: Text('Update ', style: TextStyle(color: AppColors.green, fontSize: 18.0),)),

//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//           ),
//         );
//       },
//     );
//   }*/

// //  showDilogue(BuildContext context) {
// //    Dialog errorDialog = Dialog(
// //      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
// //      //this right here
// //      child: Container(
// //        height: 160.0,
// //        width: 300.0,
// //
// //        child: Column(
// //          mainAxisAlignment: MainAxisAlignment.center,
// //          children: <Widget>[
// //            Padding(
// //                padding: EdgeInsets.all(10.0),
// //                child: Text("New Version is avaliable on Playstore",
// //                  style: TextStyle(fontSize: 18, color: Colors.black),)
// //            ),
// ////          Padding(
// ////              padding:  EdgeInsets.all(10.0),
// ////              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
// ////          ),
// //
// //            Row(
// //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //              children: <Widget>[
// //                FlatButton(
// //                    onPressed: () {
// //                      Navigator.of(context).pop();
// //                    },
// //                    child: Text('Cancel !', style: TextStyle(
// //                        color: AppColors.black, fontSize: 18.0),)),
// //
// //                FlatButton(
// //                    onPressed: () {
// //                      Navigator.of(context).pop();
// //                      _launchURL();
// //                    },
// //                    child: Text('Update Now ', style: TextStyle(
// //                        color: AppColors.green, fontSize: 18.0),)),
// //
// //              ],
// //            )
// //          ],
// //        ),
// //      ),
// //    );
// //    showDialog(
// //        context: context, builder: (BuildContext context) => errorDialog);
// //  }

//   String calDiscount(String byprice, String discount2) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(discount2);

//     discount = (byprice1 - (byprice1 * discount1) / 100.0);

//     returnStr = discount.toStringAsFixed(GroceryAppConstant.val);
//     print(returnStr);
//     return returnStr;
//   }

//   final DbProductManager dbmanager = new DbProductManager();

//   ProductsCart products2;
// //cost_price=buyprice
//   void _addToproducts(String pID, String p_name, String image, int price, int quantity, String c_val, String p_size, String p_disc, String sgst,
//       String cgst, String discount, String dis_val, String adminper, String adminper_val, String cost_price, String shippingcharge, String totalQun) {
//     if (products2 == null) {
// //      print(pID+"......");
// //      print(p_name);
// //      print(image);
// //      print(price);
// //      print(quantity);
// //      print(c_val);
// //      print(p_size);
// //      print(p_disc);
// //      print(sgst);
// //      print(cgst);
// //      print(discount);
// //      print(dis_val);
// //      print(adminper);
// //      print(adminper_val);
// //      print(cost_price);
//       ProductsCart st = new ProductsCart(
//           pid: pID,
//           pname: p_name,
//           pimage: image,
//           pprice: (price * quantity).toString(),
//           pQuantity: quantity,
//           pcolor: c_val,
//           psize: p_size,
//           pdiscription: p_disc,
//           sgst: sgst,
//           cgst: cgst,
//           discount: discount,
//           discountValue: dis_val,
//           adminper: adminper,
//           adminpricevalue: adminper_val,
//           costPrice: cost_price,
//           shipping: shippingcharge,
//           totalQuantity: totalQun);
//       dbmanager.insertStudent(st).then((id) => {showLongToast(" Services  is added to cart "), print(' Added to Db ${id}')});
//     }
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

//   _launchURL() async {
//     const url = 'https://play.google.com/store/apps/details?id=com.sanjarcreation';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }

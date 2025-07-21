import 'dart:convert';
import 'dart:developer';
import 'package:aladdinmart/grocery/BottomNavigation/allcategory.dart';
import 'package:aladdinmart/grocery/BottomNavigation/categories.dart';
import 'package:aladdinmart/grocery/screen/SubCategry.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aladdinmart/constent/app_constent.dart';
import 'package:aladdinmart/grocery/Auth/signin.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/model/CategaryModal.dart';
import 'package:aladdinmart/grocery/model/Gallerymodel.dart';
import 'package:aladdinmart/grocery/model/productmodel.dart';
import 'package:aladdinmart/grocery/model/slidermodal.dart';
import 'package:aladdinmart/grocery/screen/SearchScreen.dart';
import 'package:aladdinmart/grocery/screen/detailpage.dart';
import 'package:aladdinmart/grocery/screen/detailpage1.dart';
import 'package:aladdinmart/grocery/screen/productlist.dart';
import 'package:aladdinmart/grocery/screen/secondtabview.dart';
import 'package:aladdinmart/grocery/screen/vendor_Screen.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Future<PromotionBanner> createAlbum(String shop_id) async {
  var body = {"shop_id": GroceryAppConstant.Shop_id};
  final response = await http.post(
      Uri.parse('https://www.bigwelt.com/api/app-promo-banner.php'),
      body: body);
  print("response------>" + response.body);

  print("jsonDecode(response.body)---> ${jsonDecode(response.body)}");
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return PromotionBanner.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class PromotionBanner {
  String? shopId;
  String? images;
  bool? status;
  String? msg;
  String? path;

  PromotionBanner({this.shopId, this.images, this.status, this.msg, this.path});

  PromotionBanner.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    images = json['images'];
    status = json['status'];
    msg = json['msg'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['images'] = this.images;
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['path'] = this.path;
    return data;
  }
}

class GroceryAppHomeScreen extends StatefulWidget {
  @override
  GroceryAppHomeScreenState createState() => GroceryAppHomeScreenState();
}

class GroceryAppHomeScreenState extends State<GroceryAppHomeScreen> {
  static int cartvalue = 0;

  bool progressbar = true;

  static List<String> imgList5 = [
    'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
    'https://www.thebalanceeveryday.com/thmb/lMeVfLyCZWVPdU5eyjFLyK4AYQs=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/metrostyle-catalog-df95d1ece06c4197b1da85e316a05f90.jpg',
    'https://rukminim1.flixcart.com/image/400/450/k3xcdjk0pkrrdj/sari/h/d/x/free-multicolor-combosr-28001-ishin-combosr-28001-original-imafa5257bxdzm5j.jpeg?q=90',
    'https://i.pinimg.com/474x/62/4e/ce/624ece8daf9650f1a382995b340dc1e9.jpg'
  ];

  int _current = 0;
  var _start = 0;
  static List<Categary> list = [];
  static List<Categary> list1 = [];
  static List<Categary> list2 = [];
  static List<Slider1> sliderlist = [];

  static List<Products> topProducts = [];
  static List<Products> topProducts1 = [];

  static List<Products> dilofdayProducts = [];
  static List<Slider1> bannerSlider = [];
  List<Gallery> galiryImage = [];
  final List<String> imgL = [];
  List<Products> products1 = [];
  List<Products> products3 = [];
  List<Products> bestProducts = [];
  static List reversedilofdayProducts = [];
  static List reversedtopProducts = [];
  static List revesreProducts3 = [];
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  PromotionBanner promotionBanner = PromotionBanner();
  String imageUrl = '';
  int cc = 0;

  double? mrp, totalmrp = 000;
  int _count = 1;

  // PackageInfo packageInfo ;
  // AppUpdateInfo _updateInfo;
  String lastversion = "0";
  int? valcgeck;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  /* Future<void> checkForUpdate(BuildContext contex) async {
    packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    lastversion=version.substring(version.lastIndexOf(".")+1);

    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        valcgeck=int.parse(lastversion);
        _updateInfo = info;
        if(_updateInfo?.updateAvailable){
          Showpop();
        }
        _updateInfo?.updateAvailable == true;
        print(_updateInfo);
        print(version);
        print(_updateInfo.availableVersionCode-valcgeck);
        print(lastversion);
        print("_updateInfo.......");

//        showDilogue(contex);
        print(_updateInfo);
      });
    }).catchError((e) => _showError(e));
  }*/

  getPackageInfo() async {
    NewVersion version = NewVersion();
    final status = await version.getVersionStatus();
    // status.canUpdate; // (true)
    // status.localVersion ;// (1.2.1)
    // status.storeVersion; // (1.2.3)
    // status.appStoreLink;
    version.showAlertIfNecessary(context: context);
    // print(status.canUpdate);
    // print(status.localVersion);
    // print(status.storeVersion);
    // print(status.appStoreLink);
  }

  final addController = TextEditingController();

  Position? position;

  getAddress(double lat, double long) async {
    var addresses = await placemarkFromCoordinates(lat, long);
    var first = addresses.first;
    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.subThoroughfare.toString() +
          " " +
          first.thoroughfare.toString();

      addController.text = address.replaceAll("null", "");
      // print('Rahul ${address}');
      // pref.setString("lat", lat.toString());
      // pref.setString("lat", lat.toString());
      // pref.setString("add", address.toString().replaceAll("null", ""));
    });
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      GroceryAppConstant.latitude = position!.latitude;
      GroceryAppConstant.longitude = position!.longitude;
      print(
          ' lat ${GroceryAppConstant.latitude},${GroceryAppConstant.longitude}');
      getAddress(GroceryAppConstant.latitude, GroceryAppConstant.longitude);
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();

    if (GroceryAppConstant.Checkupdate) {
      getPackageInfo();
      GroceryAppConstant.Checkupdate = false;
    }
    getData("0").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            list = usersFromServe;
          });
        }
      }
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        if (usersFromServe1 != null) {
          setState(() {
            sliderlist = usersFromServe1;
          });
        }
      }
    });

    DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            topProducts1 = usersFromServe;
          });
        }
      }
    });
    DatabaseHelper.getTopProduct("top", "0").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            topProducts = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
          });
        }
      }
    });
    DatabaseHelper.getTopProduct1("", "0").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            dilofdayProducts = usersFromServe;
          });
        }
      }
    });
    DatabaseHelper.getfeature("yes", "10").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            products1 = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
          });
        }
      }
    });
    DatabaseHelper.getTopProduct("best", "0").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            bestProducts = usersFromServe;
          });
        }
      }
    });

    getBanner().then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            bannerSlider = usersFromServe;
          });
        }
      }
    });
    DatabaseHelper.getPromotionBanner(GroceryAppConstant.Shop_id).then((value) {
      if (this.mounted) {
        // print("valueee--> ${value.path}");
        promotionBanner = value!;
        imageUrl = value.path ?? "";
        setState(() {});
      }
      print("my url--------->");
      print(GroceryAppConstant.mainurl +
          promotionBanner.path.toString() +
          promotionBanner.images.toString());
      var url = GroceryAppConstant.mainurl +
          promotionBanner.path.toString() +
          promotionBanner.images.toString();
    });
  }

  void getcartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cCount = pref.getInt("cc");
    setState(() {
      if (cCount != null) {
        //log("cart get count------------------->>$cCount");
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
        //log("cart count------------------->>$cc");
      }
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
      // print(
      //     GroceryAppConstant.groceryAppCartItemCount.toString() + "itemCount");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // gatinfoCount();
    reversedilofdayProducts = dilofdayProducts.reversed.toList();
    revesreProducts3 = products3.reversed.toList();
    reversedtopProducts = topProducts.reversed.toList();
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 10) / 3;
    final double itemWidth = size.width / 2;
//    showDilogue(context);
    return Scaffold(
      //   backgroundColor: Color.fromARGB(255, 241, 251, 255),
      body: SafeArea(
        child: Container(
          // color: GroceryAppColors.tela,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UserFilterDemo()),);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 10),
                          child: Material(
                            color: Color.fromARGB(255, 255, 255, 255),
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserFilterDemo()),
                                  );
                                },
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide()),
                                  child: CupertinoSearchTextField(
                                    padding: EdgeInsets.symmetric(vertical: 13),
                                    backgroundColor: Colors.grey,
                                    placeholder: 'Search your service here',
                                    enabled: false,
                                    // decoration: BoxDecoration(
                                    //   //  color: Color.fromARGB(255, 66, 14, 14),
                                    //   borderRadius: BorderRadius.circular(10),
                                    // ),

                                    //  obscureText: false,
                                    // decoration: InputDecoration(
                                    //     hintText: "Search for any product",
                                    //     hintStyle: TextStyle(
                                    //         fontSize: 14.0, color: Colors.grey),
                                    //     prefixIcon: Icon(
                                    //       Icons.search,
                                    //       color: GroceryAppColors.tela,
                                    //     )),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            // get data (categoires) end
                            SizedBox(
                              height: 10,
                            ),
                            slider1Widget(),
                            categoryWidget(),

                            //  gettopproduct("top","0") Trending Services start
                            topProducts.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 8, bottom: 6, top: 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              GroceryAppConstant
                                                  .AProduct_type_Name1,
                                              style: TextStyle(
                                                  color: GroceryAppColors
                                                      .product_title_name,
                                                  fontSize: 15,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 14.0,
                                                  top: 8.0,
                                                  left: 8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductList(
                                                                "Top",
                                                                GroceryAppConstant
                                                                    .AProduct_type_Name1)),
                                                  );
                                                },
                                                child: Text('See all',
                                                    style: TextStyle(
                                                      color:
                                                          GroceryAppColors.tela,
                                                      fontSize: 14,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                        // Divider(
                                        //   color: GroceryAppColors
                                        //       .lightGray, //color of divider
                                        //   height:
                                        //       10, //height spacing of divider
                                        //   thickness:
                                        //       0.5, //thickness of divier line
                                        //   indent:
                                        //       14, //spacing at the start of divider
                                        //   endIndent:
                                        //       14, //spacing at the end of divider
                                        // ),
                                        Container(
                                            height: 245.0,
                                            child: topProducts != null
                                                ? topProducts.isNotEmpty
                                                    ? Container(
                                                        height: 230.0,
                                                        child: ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                topProducts
                                                                        .isEmpty
                                                                    ? 0
                                                                    : topProducts
                                                                        .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Stack(
                                                                children: [
                                                                  Card(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    elevation:
                                                                        5,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        // border: Border.all(
                                                                        //     color:
                                                                        //         GroceryAppColors.tela,
                                                                        //     width: 1),
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      width: topProducts.length !=
                                                                              0
                                                                          ? 165.0
                                                                          : 240.0,
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => ProductDetails(topProducts[index])),
                                                                              );
                                                                            },
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                                                              child: CachedNetworkImage(
                                                                                fit: BoxFit.fill,
                                                                                height: 120,
                                                                                imageUrl: GroceryAppConstant.Product_Imageurl + topProducts[index].img!,
                                                                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                            padding: EdgeInsets.only(
                                                                                left: 3,
                                                                                right: 5,
                                                                                top: 10),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  topProducts[index].productName!,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    color: GroceryAppColors.black,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          '\u{20B9} ${topProducts[index].buyPrice}',
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          maxLines: 2,
                                                                                          style: TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, fontSize: 12, color: GroceryAppColors.black, decoration: TextDecoration.lineThrough),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 2.0, bottom: 1, right: 10),
                                                                                          child: Text('\u{20B9} ${calDiscount(topProducts[index].buyPrice!, topProducts[index].discount!)}', style: TextStyle(color: GroceryAppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                // add button start

                                                                                // Row(
                                                                                //   mainAxisAlignment: MainAxisAlignment.end,
                                                                                //   children: <Widget>[
                                                                                //     Container(
                                                                                //         height: 20,
                                                                                //         width: 25,
                                                                                //         child: Material(
                                                                                //           color: GroceryAppColors.teladep,
                                                                                //           elevation: 0.0,
                                                                                //           shape: RoundedRectangleBorder(
                                                                                //             side: BorderSide(
                                                                                //               color: Colors.white,
                                                                                //             ),
                                                                                //             borderRadius: BorderRadius.all(
                                                                                //               Radius.circular(15),
                                                                                //             ),
                                                                                //           ),
                                                                                //           clipBehavior: Clip.antiAlias,
                                                                                //           child: Padding(
                                                                                //             padding: EdgeInsets.only(bottom: 10),
                                                                                //             child: InkWell(
                                                                                //                 onTap: () {
                                                                                //                   print(topProducts[index].count);
                                                                                //                   if (topProducts[index].count != "1") {
                                                                                //                     setState(() {
                                                                                //                       //                                                                                _count++;

                                                                                //                       String quantity = topProducts[index].count!;
                                                                                //                       int totalquantity = int.parse(quantity) - 1;
                                                                                //                       topProducts[index].count = totalquantity.toString();
                                                                                //                     });
                                                                                //                   }

                                                                                //                   //
                                                                                //                 },
                                                                                //                 child: Padding(
                                                                                //                   padding: EdgeInsets.only(
                                                                                //                     top: 10.0,
                                                                                //                   ),
                                                                                //                   child: Icon(
                                                                                //                     Icons.maximize,
                                                                                //                     size: 15,
                                                                                //                     color: Colors.white,
                                                                                //                   ),
                                                                                //                 )),
                                                                                //           ),
                                                                                //         )),
                                                                                //     Padding(
                                                                                //       padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                                                                                //       child: Center(
                                                                                //         child: Text(topProducts[index].count != null ? '${topProducts[index].count}' : '$_count', style: TextStyle(color: Colors.black, fontSize: 19, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                                                                                //       ),
                                                                                //     ),
                                                                                //     Container(
                                                                                //         margin: EdgeInsets.only(left: 3.0),
                                                                                //         height: 20,
                                                                                //         width: 25,
                                                                                //         child: Material(
                                                                                //           color: GroceryAppColors.teladep,
                                                                                //           elevation: 0.0,
                                                                                //           shape: RoundedRectangleBorder(
                                                                                //             side: BorderSide(
                                                                                //               color: Colors.white,
                                                                                //             ),
                                                                                //             borderRadius: BorderRadius.all(
                                                                                //               Radius.circular(15),
                                                                                //             ),
                                                                                //           ),
                                                                                //           clipBehavior: Clip.antiAlias,
                                                                                //           child: InkWell(
                                                                                //             onTap: () {
                                                                                //               if (int.parse(topProducts[index].count!) <= int.parse(topProducts[index].quantityInStock!)) {
                                                                                //                 setState(() {
                                                                                //                   //                                                                                _count++;

                                                                                //                   String quantity = topProducts[index].count!;
                                                                                //                   int totalquantity = int.parse(quantity) + 1;
                                                                                //                   topProducts[index].count = totalquantity.toString();
                                                                                //                 });
                                                                                //               } else {
                                                                                //                 showLongToast('Only  ${topProducts[index].count}  products in stock ');
                                                                                //               }
                                                                                //             },
                                                                                //             child: Icon(
                                                                                //               Icons.add,
                                                                                //               size: 15,
                                                                                //               color: Colors.white,
                                                                                //             ),
                                                                                //           ),
                                                                                //         )),
                                                                                //   ],
                                                                                // )

                                                                                // SizedBox(width: 10,),

                                                                                // end add button
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          Container(
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                Material(
                                                                              color: GroceryAppColors.tela1,
                                                                              elevation: 0.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                  color: Colors.white,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(10),
                                                                                ),
                                                                              ),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  if (GroceryAppConstant.isLogin) {
                                                                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                    String mrp_price = calDiscount(topProducts[index].buyPrice!, topProducts[index].discount!);
                                                                                    totalmrp = double.parse(mrp_price);

                                                                                    double dicountValue = double.parse(topProducts[index].buyPrice!) - totalmrp!;
                                                                                    String gst_sgst = calGst(mrp_price, topProducts[index].sgst!);
                                                                                    String gst_cgst = calGst(mrp_price, topProducts[index].cgst!);

                                                                                    String adiscount = calDiscount(topProducts[index].buyPrice!, topProducts[index].msrp! != null ? topProducts[index].msrp! : "0");

                                                                                    admindiscountprice = (double.parse(topProducts[index].buyPrice!) - double.parse(adiscount));

                                                                                    String color = "";
                                                                                    String size = "";
                                                                                    _addToproducts(topProducts[index].productIs!, topProducts[index].productName!, topProducts[index].img!, int.parse(mrp_price), int.parse(topProducts[index].count!), color, size, topProducts[index].productDescription!, gst_sgst, gst_cgst, topProducts[index].discount!, dicountValue.toString(), topProducts[index].APMC!, admindiscountprice.toString(), topProducts[index].buyPrice!, topProducts[index].shipping!, topProducts[index].quantityInStock!);

                                                                                    setState(() {
                                                                                      //                                                                              cartvalue++;
                                                                                      GroceryAppConstant.carditemCount++;
                                                                                      cartItemcount(GroceryAppConstant.carditemCount);
                                                                                      AppConstent.cc++;

                                                                                      pref.setInt("cc", AppConstent.cc);
                                                                                    });

                                                                                    //                                                                Navigator.push(context,
                                                                                    //                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                                                  } else {
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(builder: (context) => SignInPage()),
                                                                                    );
                                                                                  }

                                                                                  //
                                                                                },
                                                                                child: Padding(
                                                                                    padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        'Book',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                      )
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          backgroundColor:
                                                              GroceryAppColors
                                                                  .tela,
                                                        ),
                                                      )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          GroceryAppColors.tela,
                                                    ),
                                                  ))
                                      ],
                                    ),
                                  )
                                : Container(),

                            //  gettopproduct("top","0") Trending Services ends

                            //  bannerSlider starts
                            bannerSlider != null
                                ? bannerSlider.length > 0
                                    ? Container(
                                        height: 180.0,
                                        child: bannerSlider != null
                                            ? bannerSlider.length > 0
                                                ? CarouselSlider.builder(
                                                    itemCount:
                                                        bannerSlider.length,
                                                    options: CarouselOptions(
                                                      aspectRatio: 2.4,
                                                      viewportFraction: 1.5,
                                                      // enlargeCenterPage: true,
                                                      autoPlay: false,
                                                    ),
                                                    itemBuilder:
                                                        (ctx, index, realIdx) {
                                                      return Container(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (!bannerSlider[
                                                                    index]
                                                                .title!
                                                                .isEmpty) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        Screen2(
                                                                            sliderlist[index].title ??
                                                                                "",
                                                                            "")),
                                                              );
                                                            } else if (!bannerSlider[
                                                                    index]
                                                                .description!
                                                                .isEmpty) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ProductDetails1(bannerSlider[index].description ??
                                                                            "")),
                                                              );
//
                                                            }
                                                          },
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5.0,
                                                                      right: 5),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8.0)),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        30,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    imageUrl: GroceryAppConstant
                                                                            .Base_Imageurl +
                                                                        bannerSlider[index]
                                                                            .img
                                                                            .toString(),
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ))),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          GroceryAppColors.tela,
                                                    ),
                                                  )
                                            : Row())
                                    : Container()
                                : Container(),
                            //  bannerSlider ends

                            // // gettopproducts("best""0")best deals starts
                            // bestProducts != null
                            //     ? bestProducts.length > 0
                            //         ? Container(
                            //             color: Colors.white,
                            //             padding: EdgeInsets.only(bottom: 10),
                            //             child: Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               children: <Widget>[
                            //                 Padding(
                            //                   padding: EdgeInsets.only(
                            //                       top: 8.0,
                            //                       left: 8.0,
                            //                       right: 8.0),
                            //                   child: Text(
                            //                     "BEST DEALS",
                            //                     style: TextStyle(
                            //                         color: GroceryAppColors
                            //                             .product_title_name,
                            //                         fontSize: 14,
                            //                         fontFamily: 'Roboto',
                            //                         fontWeight:
                            //                             FontWeight.bold),
                            //                   ),
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.only(
                            //                       right: 8.0,
                            //                       top: 8.0,
                            //                       left: 8.0),
                            //                   child: ElevatedButton(
                            //                       style:
                            //                           ElevatedButton.styleFrom(
                            //                         backgroundColor:
                            //                             GroceryAppColors.tela,
                            //                         textStyle: TextStyle(
                            //                           color: Colors.white,
                            //                         ),
                            //                       ),
                            //                       child: Text('View All',
                            //                           style: TextStyle(
                            //                               color:
                            //                                   GroceryAppColors
                            //                                       .white)),
                            //                       onPressed: () {
                            //                         Navigator.push(
                            //                           context,
                            //                           MaterialPageRoute(
                            //                             builder: (context) =>
                            //                                 ProductList("best",
                            //                                     "Best Deals"),
                            //                           ),
                            //                         );
                            //                       }),
                            //                 )
                            //               ],
                            //             ),
                            //           )
                            //         : Container()
                            //     : Container(),

                            // bestProducts != null
                            //     ? bestProducts.length > 0
                            //         ? Container(
                            //             child: ListView.builder(
                            //               shrinkWrap: true,
                            //               primary: false,
                            //               scrollDirection: Axis.vertical,
                            //               itemCount: bestProducts.length,
                            //               itemBuilder: (BuildContext context,
                            //                   int index) {
                            //                 return Stack(
                            //                   children: [
                            //                     Container(
                            //                       margin: EdgeInsets.only(
                            //                           left: 10,
                            //                           right: 10,
                            //                           top: 6,
                            //                           bottom: 6),
                            //                       child: Card(
                            //                         elevation: 10,
                            //                         shape:
                            //                             RoundedRectangleBorder(
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   10),
                            //                         ),
                            //                         child: InkWell(
                            //                           onTap: () {
                            //                             Navigator.push(
                            //                               context,
                            //                               MaterialPageRoute(
                            //                                   builder: (context) =>
                            //                                       ProductDetails(
                            //                                           bestProducts[
                            //                                               index])),
                            //                             );
                            //                           },
                            //                           child: Container(
                            //                             child: Row(
                            //                               children: <Widget>[
                            //                                 Expanded(
                            //                                   child: Container(
                            //                                     padding:
                            //                                         const EdgeInsets
                            //                                                 .all(
                            //                                             8.0),
                            //                                     child: Column(
                            //                                       mainAxisSize:
                            //                                           MainAxisSize
                            //                                               .max,
                            //                                       crossAxisAlignment:
                            //                                           CrossAxisAlignment
                            //                                               .start,
                            //                                       children: <
                            //                                           Widget>[
                            //                                         Container(
                            //                                           child:
                            //                                               Text(
                            //                                             bestProducts[index].productName ==
                            //                                                     null
                            //                                                 ? 'name'
                            //                                                 : bestProducts[index].productName.toString(),
                            //                                             overflow:
                            //                                                 TextOverflow.fade,
                            //                                             style: TextStyle(
                            //                                                     fontSize: 15,
                            //                                                     fontWeight: FontWeight.w400,
                            //                                                     color: Colors.black)
                            //                                                 .copyWith(fontSize: 14),
                            //                                           ),
                            //                                         ),
                            //                                         SizedBox(
                            //                                             height:
                            //                                                 6),
                            //                                         Row(
                            //                                           children: <
                            //                                               Widget>[
                            //                                             Padding(
                            //                                               padding: const EdgeInsets.only(
                            //                                                   top: 2.0,
                            //                                                   bottom: 1),
                            //                                               child: Text(
                            //                                                   '\u{20B9} ${calDiscount(bestProducts[index].buyPrice ?? "", bestProducts[index].discount ?? "")}  ${bestProducts[index].unit_type != null ? bestProducts[index].unit_type : ""}',
                            //                                                   style: TextStyle(
                            //                                                     color: GroceryAppColors.sellp,
                            //                                                     fontWeight: FontWeight.w700,
                            //                                                   )),
                            //                                             ),
                            //                                             SizedBox(
                            //                                               width:
                            //                                                   20,
                            //                                             ),
                            //                                             Expanded(
                            //                                               child:
                            //                                                   Text(
                            //                                                 '\u{20B9} ${bestProducts[index].buyPrice}',
                            //                                                 overflow:
                            //                                                     TextOverflow.ellipsis,
                            //                                                 maxLines:
                            //                                                     2,
                            //                                                 style: TextStyle(
                            //                                                     fontWeight: FontWeight.w700,
                            //                                                     fontStyle: FontStyle.italic,
                            //                                                     color: GroceryAppColors.mrp,
                            //                                                     decoration: TextDecoration.lineThrough),
                            //                                               ),
                            //                                             )
                            //                                           ],
                            //                                         ),
                            //                                       ],
                            //                                     ),
                            //                                   ),
                            //                                 ),
                            //                                 Container(
                            //                                   margin: EdgeInsets
                            //                                       .only(
                            //                                           right: 8,
                            //                                           left: 8,
                            //                                           top: 8,
                            //                                           bottom:
                            //                                               8),
                            //                                   width: 110,
                            //                                   height: 110,
                            //                                   decoration:
                            //                                       BoxDecoration(
                            //                                           border: Border.all(
                            //                                               color: GroceryAppColors
                            //                                                   .tela,
                            //                                               width:
                            //                                                   0.2),
                            //                                           borderRadius:
                            //                                               BorderRadius
                            //                                                   .all(
                            //                                             Radius.circular(
                            //                                                 55),
                            //                                           ),
                            //                                           color: Colors
                            //                                               .blue
                            //                                               .shade200,
                            //                                           image: DecorationImage(
                            //                                               fit: BoxFit.cover,
                            //                                               image: NetworkImage(
                            //                                                 bestProducts[index].img != null
                            //                                                     ? GroceryAppConstant.Product_Imageurl + bestProducts[index].img.toString()
                            //                                                     : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                            //                                               ))),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                     //double.parse(products1[index].discount)>0?  showSticker(index,products1):Row(),
                            //                   ],
                            //                 );
                            //               },
                            //             ),
                            //           )
                            //         : Row()
                            //     : Row(),
                            // // gettopproducts("best""0")best deals ends

                            //  gettopproduct("day","0") deals of the day  starts
                            topProducts1 != null
                                ? topProducts1.length > 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 6,
                                            top: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            //color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: Colors.grey[300],
                                            //     blurRadius: 2,
                                            //     spreadRadius: 1,
                                            //   )
                                            // ],
                                          ),
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'DEALS OF THE DAY',
                                                    style: TextStyle(
                                                        color: GroceryAppColors
                                                            .product_title_name,
                                                        fontSize: 15,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 14.0,
                                                            top: 8.0,
                                                            left: 8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductList(
                                                                      "day",
                                                                      "Deals of the day")),
                                                        );
                                                      },
                                                      child: Text('See all',
                                                          style: TextStyle(
                                                            color:
                                                                GroceryAppColors
                                                                    .tela,
                                                            fontSize: 14,
                                                          )),
                                                    ),
                                                  )
                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                                  //   child: RaisedButton(
                                                  //       color: GroceryAppColors.tela,
                                                  //       child: Text('View All', style: TextStyle(color: GroceryAppColors.white)),
                                                  //       onPressed: () {
                                                  //         Navigator.push(
                                                  //           context,
                                                  //           MaterialPageRoute(builder: (context) => ProductList("day", "Deals of the day")),
                                                  //         );
                                                  //       }),
                                                  // )
                                                ],
                                              ),
                                              // Divider(
                                              //   color: GroceryAppColors
                                              //       .lightGray, //color of divider
                                              //   height:
                                              //       10, //height spacing of divider
                                              //   thickness:
                                              //       0.5, //thickness of divier line
                                              //   indent:
                                              //       14, //spacing at the start of divider
                                              //   endIndent:
                                              //       14, //spacing at the end of divider
                                              // ),
                                              Container(
                                                child: topProducts1 != null
                                                    ? topProducts1.length > 0
                                                        ? Container(
                                                            // color: GroceryAppColors.black,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8.0,
                                                                    top: 10,
                                                                    bottom: 20),
                                                            height: 220.0,
                                                            child: ListView
                                                                .builder(
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount: topProducts1.length ==
                                                                            null
                                                                        ? 0
                                                                        : topProducts1
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Stack(
                                                                        children: [
                                                                          Container(
                                                                            width: topProducts1.isNotEmpty
                                                                                ? 170.0
                                                                                : 230.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              // color: GroceryAppColors.black,
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(right: 10),
                                                                            child:
                                                                                Card(
                                                                              child: Container(
                                                                                child: Column(
                                                                                  children: <Widget>[
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(builder: (context) => ProductDetails(topProducts1[index])),
                                                                                        );
//
                                                                                      },
                                                                                      child: Container(
                                                                                        // height: 155,
                                                                                        // width: 150,
                                                                                        child: ClipRRect(
                                                                                          // borderRadius: BorderRadius.circular(20),
                                                                                          child: CachedNetworkImage(
                                                                                            fit: BoxFit.fill,
                                                                                            imageUrl: GroceryAppConstant.Product_Imageurl + topProducts1[index].img!,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,

                                                                                            height: 160,
                                                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                                                            errorWidget: (context, url, error) => new Icon(Icons.error),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                                                                                        padding: EdgeInsets.only(left: 3, right: 5),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              topProducts1[index].productName!,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                fontSize: 12,
                                                                                                color: GroceryAppColors.black,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 8,
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Text(
                                                                                                  '\u{20B9} ${topProducts1[index].buyPrice}',
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                  maxLines: 2,
                                                                                                  style: TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, fontSize: 12, color: GroceryAppColors.black, decoration: TextDecoration.lineThrough),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                                                                                  child: Text('\u{20B9} ${calDiscount(topProducts1[index].buyPrice!, topProducts1[index].discount!)} ${topProducts1[index].unit_type != null ? topProducts1[index].unit_type : ""}', style: TextStyle(color: GroceryAppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          double.parse(topProducts1[index].discount!) > 0
                                                                              ? showSticker1(index, topProducts1)
                                                                              : Row()
                                                                        ],
                                                                      );
                                                                    }),
                                                          )
                                                        : Container()
                                                    : Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container()
                                : Container(),

                            //  gettopproduct("day","0")  deals of the day ends

                            // gettopproducts1("","0")  arrival starts
                            dilofdayProducts.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(20),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey[300],
                                        //     blurRadius: 2,
                                        //     spreadRadius: 1,
                                        //   )
                                        // ],
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                GroceryAppConstant
                                                    .AProduct_type_Name2,
                                                style: TextStyle(
                                                    color: GroceryAppColors
                                                        .product_title_name,
                                                    fontSize: 15,
                                                    fontFamily: 'Roboto',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 14.0,
                                                    top: 8.0,
                                                    left: 8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductList(
                                                                  "new",
                                                                  GroceryAppConstant
                                                                      .AProduct_type_Name2)),
                                                    );
                                                  },
                                                  child: Text('See all',
                                                      style: TextStyle(
                                                        color: GroceryAppColors
                                                            .tela,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                              )

                                              // Padding(
                                              //   padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                              //   child: RaisedButton(
                                              //       color: GroceryAppColors.tela,
                                              //       child: Text('View All', style: TextStyle(color: GroceryAppColors.white)),
                                              //       onPressed: () {
                                              //         Navigator.push(
                                              //           context,
                                              //           MaterialPageRoute(builder: (context) => ProductList("new", GroceryAppConstant.AProduct_type_Name2)),
                                              //         );
                                              //       }),
                                              // )
                                            ],
                                          ),
                                          // Divider(
                                          //   color: GroceryAppColors
                                          //       .lightGray, //color of divider
                                          //   height:
                                          //       10, //height spacing of divider
                                          //   thickness:
                                          //       0.5, //thickness of divier line
                                          //   indent:
                                          //       14, //spacing at the start of divider
                                          //   endIndent:
                                          //       14, //spacing at the end of divider
                                          // ),
                                          Container(
                                              height: 230,
                                              child: GridView.builder(
                                                  scrollDirection: Axis
                                                      .horizontal,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 1,
                                                          mainAxisExtent: 180,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10),
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  controller:
                                                      new ScrollController(
                                                          keepScrollOffset:
                                                              false),
                                                  shrinkWrap: true,
                                                  // crossAxisCount: 2,
                                                  // childAspectRatio: 0.68,
                                                  padding: EdgeInsets.only(
                                                      top: 8,
                                                      left: 6,
                                                      right: 6,
                                                      bottom: 0),
                                                  itemCount:
                                                      dilofdayProducts.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Card(
                                                      elevation: 3,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      // decoration: BoxDecoration(
                                                      //   // border: Border.all(
                                                      //   //     color:
                                                      //   //         GroceryAppColors
                                                      //   //             .tela,
                                                      //   //     width: 1),
                                                      //   color: Colors.white,
                                                      //   borderRadius:
                                                      //       BorderRadius
                                                      //           .circular(10),
                                                      // ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ProductDetails(
                                                                            dilofdayProducts[index])),
                                                              );
//
                                                            },
                                                            child: SizedBox(
                                                              // height: 100,
                                                              width: double
                                                                  .infinity,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10)),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  imageUrl: GroceryAppConstant
                                                                          .Product_Imageurl +
                                                                      dilofdayProducts[
                                                                              index]
                                                                          .img!,
                                                                  height: 150,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Center(
                                                                          child:
                                                                              CircularProgressIndicator()),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      new Icon(Icons
                                                                          .error),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      top: 8,
                                                                      bottom:
                                                                          5),
                                                              color:
                                                                  GroceryAppColors
                                                                      .white,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    dilofdayProducts[
                                                                            index]
                                                                        .productName!,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: GroceryAppColors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '\u{20B9} ${dilofdayProducts[index].buyPrice}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                2,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w700,
                                                                                fontStyle: FontStyle.italic,
                                                                                fontSize: 12,
                                                                                color: GroceryAppColors.black,
                                                                                decoration: TextDecoration.lineThrough),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 2.0,
                                                                                bottom: 1,
                                                                                right: 10),
                                                                            child:
                                                                                Text('\u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice!, dilofdayProducts[index].discount!)}', style: TextStyle(color: GroceryAppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Material(
                                                                        color: GroceryAppColors
                                                                            .tela1,
                                                                        elevation:
                                                                            0.0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          side:
                                                                              BorderSide(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(10),
                                                                          ),
                                                                        ),
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            if (GroceryAppConstant.isLogin) {
                                                                              SharedPreferences pref = await SharedPreferences.getInstance();
                                                                              String mrp_price = calDiscount(dilofdayProducts[index].buyPrice!, dilofdayProducts[index].discount!);
                                                                              totalmrp = double.parse(mrp_price);

                                                                              double dicountValue = double.parse(dilofdayProducts[index].buyPrice!) - totalmrp!;
                                                                              String gst_sgst = calGst(mrp_price, dilofdayProducts[index].sgst!);
                                                                              String gst_cgst = calGst(mrp_price, dilofdayProducts[index].cgst!);

                                                                              String adiscount = calDiscount(dilofdayProducts[index].buyPrice!, dilofdayProducts[index].msrp! != null ? dilofdayProducts[index].msrp! : "0");

                                                                              admindiscountprice = (double.parse(dilofdayProducts[index].buyPrice!) - double.parse(adiscount));

                                                                              String color = "";
                                                                              String size = "";
                                                                              _addToproducts(
                                                                                dilofdayProducts[index].productIs!,
                                                                                dilofdayProducts[index].productName!,
                                                                                dilofdayProducts[index].img!,
                                                                                int.parse(mrp_price),
                                                                                int.parse(dilofdayProducts[index].count!),
                                                                                color,
                                                                                size,
                                                                                dilofdayProducts[index].productDescription!,
                                                                                gst_sgst,
                                                                                gst_cgst,
                                                                                dilofdayProducts[index].discount!,
                                                                                dicountValue.toString(),
                                                                                dilofdayProducts[index].APMC!,
                                                                                admindiscountprice.toString(),
                                                                                dilofdayProducts[index].buyPrice!,
                                                                                dilofdayProducts[index].shipping!,
                                                                                dilofdayProducts[index].quantityInStock!,
                                                                              );

                                                                              setState(() {
//                                                                              cartvalue++;
                                                                                GroceryAppConstant.carditemCount++;
                                                                                cartItemcount(GroceryAppConstant.carditemCount);
                                                                                AppConstent.cc++;

                                                                                pref.setInt("cc", AppConstent.cc);
                                                                              });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                                            } else {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => SignInPage()),
                                                                              );
                                                                            }

//
                                                                          },
                                                                          child: Padding(
                                                                              padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'Book',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  })),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),

                            //  promotional banner starts

                            imageUrl != null
                                ? imageUrl.length > 0
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          height: 170.0,
                                          child: imageUrl != null
                                              ? imageUrl.length > 0
                                                  ? CarouselSlider.builder(
                                                      itemCount:
                                                          imageUrl.length,
                                                      options: CarouselOptions(
                                                        aspectRatio: 2.4,
                                                        viewportFraction: 1,
                                                        // enlargeCenterPage: true,
                                                        autoPlay: true,
                                                      ),
                                                      itemBuilder: (ctx, index,
                                                          realIdx) {
                                                        return Container(
                                                          child:
                                                              GestureDetector(
                                                            child: Container(
                                                              height: 170,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin: EdgeInsets
                                                                  .all(8),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                //                              color: GroceryAppColors.white,

                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image: imageUrl
                                                                          .isEmpty
                                                                      ? AssetImage(
                                                                              "assets/images/logo.png")
                                                                          as ImageProvider
                                                                      : NetworkImage(
                                                                          "${GroceryAppConstant.mainurl + promotionBanner.path.toString() + promotionBanner.images.toString()}"),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),

                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            GroceryAppColors
                                                                .tela,
                                                      ),
                                                    )
                                              : Row(),
                                        ),
                                      )
                                    : Container()
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget slider1Widget() {
    return sliderlist != null
        ? sliderlist.length > 0
            ? sliderlist != null
                ? sliderlist.length > 0
                    ? CarouselSlider.builder(
                        itemCount: sliderlist.length,
                        options: CarouselOptions(
                          aspectRatio: 2.7,
                          viewportFraction: 1,
                          // enlargeCenterPage: true,
                          autoPlay: true,
                        ),
                        itemBuilder: (ctx, index, realIdx) {
                          return Container(
                            child: GestureDetector(
                              onTap: () {
                                if (!sliderlist[index].title!.isEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Screen2(
                                            sliderlist[index].title.toString(),
                                            "")),
                                  );
                                } else if (!sliderlist[index]
                                    .description!
                                    .isEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails1(
                                            sliderlist[index].description ??
                                                "")),
                                  );
                                  //
                                }
                              },
                              child: Card(
                                  elevation: 3,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                30,
                                        fit: BoxFit.fill,
                                        imageUrl: GroceryAppConstant
                                                .Base_Imageurl +
                                            sliderlist[index].img.toString(),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ))),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          backgroundColor: GroceryAppColors.tela,
                        ),
                      )
                : Row()
            //  )
            : Container()
        : Container();
  }

  Widget categoryWidget() {
    return list.isNotEmpty
        ? list.length > 0
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 14.0, right: 14.0, bottom: 0.0, top: 14),
                child: Container(
                  decoration: BoxDecoration(
                    //  color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 10),
                            child: Text(
                              "Categories",
                              style: TextStyle(
                                  color: GroceryAppColors.product_title_name,
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          list.length > 4
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 14.0,
                                      top: 8.0,
                                      left: 8.0,
                                      bottom: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllCategory("Category", '0')),
                                      );
                                    },
                                    child: Text('See all',
                                        style: TextStyle(
                                          color: GroceryAppColors.tela,
                                          fontSize: 14,
                                        )),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisExtent: 120,
                          ),
                          shrinkWrap: true,
                          primary: false,
                          //   scrollDirection: Axis.horizontal,
                          itemCount: list.length > 8 ? 8 : list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                var i = list[index].pcatId;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Sbcategory(
                                      list[index].pCats.toString(),
                                      list[index].pcatId.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                elevation: 0,
                                shadowColor: Color.fromARGB(225, 255, 255, 255),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(color: GroceryAppColors.tela, width: 4),
                                      //   borderRadius: BorderRadius.circular(35),
                                      // ),
                                      width: 60,
                                      height: 60,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Padding(
                                            padding: EdgeInsets.all(0.0),
                                            child: list[index].img == null ||
                                                    list[index].img == ""
                                                ? Image.asset(
                                                    "assets/images/logo.png",
                                                    fit: BoxFit.fill)
                                                : Image.network(
                                                    GroceryAppConstant
                                                            .logo_Image_Pcat +
                                                        list[index].img!,
                                                    fit: BoxFit.fill),
                                          )),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          list[index].pCats!,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: GroceryAppColors.black,
                                          ),
                                        ),
                                        SizedBox(height: 3)
                                      ],
                                    ),
                                    //SizedBox(width: 2),
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              )
            : Row()
        : Row();
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

  final DbProductManager dbmanager = DbProductManager();

  ProductsCart? products2;

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
      ProductsCart st = ProductsCart(
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

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.gharbazar';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future cartItemcount(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setInt("itemCount", val);
    print(val.toString() + "shair....");
  }
}

import 'package:ecoshine24/widgets/html_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/grocery/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/dbhelper/wishlistdart.dart';
import 'package:ecoshine24/grocery/model/Gallerymodel.dart';
import 'package:ecoshine24/grocery/model/GroupProducts.dart';
import 'package:ecoshine24/grocery/model/Varient.dart';
import 'package:ecoshine24/grocery/model/aminities_model.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:ecoshine24/grocery/screen/Zoomimage.dart';
import 'package:ecoshine24/grocery/screen/detailpage1.dart';
import 'package:ecoshine24/grocery/screen/secondtabview.dart';
import 'package:ecoshine24/grocery/screen/ShowAddress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart';

import '../../Auth/signin.dart';

class ProductDetails extends StatefulWidget {
  final Products plist;

  const ProductDetails(this.plist) : super();

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  List<PVariant> pvarlist = [];
  AmenitiesModel amenitiesModel = AmenitiesModel();

  String name = "";
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement!.text;

    return parsedString;
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select Variant'),
            content: Container(
              width: double.maxFinite,
              height: pvarlist.length * 50.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: pvarlist.length == null ? 0 : pvarlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: pvarlist[index] != 0 ? 130.0 : 230.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            total = int.parse(pvarlist[index].price ?? "");
                            String mrp_price = calDiscount(
                                pvarlist[index].price ?? "",
                                pvarlist[index].discount ?? "");
                            totalmrp = double.parse(mrp_price);
                            textval = pvarlist[index].variant ?? "";
                            name = pvarlist[index].variant ?? "";
                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                pvarlist[index].variant ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: GroceryAppColors.black,
                                ),
                              ),
                            ),
                            Divider(
                              color: GroceryAppColors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  int _current = 0;
  bool flag = true;
  int? wishid;
  bool wishflag = true;
  String url = "";
  String textval = "Select varient";

  // List<Products> products1 = List();
  List<Products> topProducts1 = [];

  final List<String> imgList1 = [];
  List<Products> products1 = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final List<String> _currencies = ['ram', 'mohan'];
  int _count = 1;
  String? _dropDownValue;
  String? _dropDownValue2;
  String? _dropDownValue1, groupname = "";
  int? total;
  int? actualprice = 200;
  double? mrp, totalmrp;
  double? sgst1, cgst1, dicountValue, admindiscountprice;

  List<Gallery> galiryImage1 = [];
  List<GroupProducts> group = [];
  List<Products> productdetails = [];
  List<String>? size;
  List<String>? color;
  List<String> catid = [];
  ProductsCart? products;
  WishlistsCart? nproducts;
  final DbProductManager dbmanager = DbProductManager();
  final DbProductManager1 dbmanager1 = DbProductManager1();
  int cc = 0;
//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;

  void getcartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cCount = pref.getInt("cc");
    setState(() {
      //log("cart get count------------------->>$cCount");
      if (cCount != null) {
        if (cCount == 0 || cCount < 0) {
          cc = 0;
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

  static List<WishlistsCart>? prodctlist1;

  // final DbProductManager1 dbmanager12 =  DbProductManager1();

  @override
  void initState() {
    super.initState();
    getcartCount();
    name = widget.plist.productName ?? "";
    gatinfoCount();
    print(' product id ${widget.plist.productIs}');

    getPvarient(widget.plist.productIs ?? "").then((usersFromServe) {
      if (usersFromServe != null) {
        setState(() {
          pvarlist = usersFromServe;
        });
      }
    });
    getAmenities();

    dbmanager1.getProductList3().then((usersFromServe) {
      setState(() {
        prodctlist1 = usersFromServe;
        for (var i = 0; i < prodctlist1!.length; i++) {
          if (prodctlist1![i].pid == widget.plist.productIs) {
            wishid = prodctlist1![i].id;
            wishflag = false;
          }
        }
      });
    });

    catid = widget.plist.productLine!.split(',');
    size = widget.plist.productScale!.split(',');
    color = widget.plist.productColor!.split(',');

    DatabaseHelper.getImage(widget.plist.productIs ?? "")
        .then((usersFromServe) {
      if (usersFromServe != null) {
        setState(() {
          galiryImage1 = usersFromServe;
          imgList1.clear();
          for (var i = 0; i < galiryImage1.length; i++) {
            imgList1.add(galiryImage1[i].img ?? "");
          }
        });
      }
    });

    GroupPro(widget.plist.productIs ?? "").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            group = usersFromServe;
            print(group != null);
            groupname = group[0].name;
            print(group.toString() + "group info");
          });
        }
      }
    });
    catby_productData(catid.length > 0 ? catid[0] : "0", "0")
        .then((usersFromServe) {
      setState(() {
        topProducts1 = usersFromServe;
      });
    });

    setState(() {
      actualprice = int.parse(widget.plist.buyPrice ?? "");
      total = actualprice;
      url = widget.plist.img ?? "";
      String mrp_price =
          calDiscount(widget.plist.buyPrice ?? "", widget.plist.discount ?? "");
      totalmrp = double.parse(mrp_price);

      dicountValue = double.parse(widget.plist.buyPrice ?? "") - totalmrp!;
      String gst_sgst = calGst(totalmrp.toString(), widget.plist.sgst ?? "");
      String gst_cgst = calGst(totalmrp.toString(), widget.plist.cgst ?? "");

      sgst1 = double.parse(gst_sgst);
      cgst1 = double.parse(gst_cgst);
    });
  }

  bool showdis = false;

  Future<void> getAmenities() async {
    await DatabaseHelper.getAmenities(widget.plist.productIs ?? "")
        .then((value) {
      amenitiesModel = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff1E88E5), // Medical blue
            Color(0xff42A5F5), // Lighter medical blue
            Color(0xffF8FBFF), // Medical light background
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xff1E88E5), // Medical blue
                  size: 20,
                ),
              ),
            ),
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.medical_services_rounded,
                    color: Color(0xff1E88E5),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Doctor Appointment Details",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff1E88E5), // Medical blue
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WishList()),
                    );
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.bookmark_add_outlined,
                        color: Color(0xff1E88E5), // Medical blue
                        size: 24,
                      ),
                      if (cc > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.red.shade700],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              cc.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          body: Container(
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        margin: EdgeInsets.only(
                            top: 80), // Add top margin for app bar
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Modern Image Carousel Section
                            Container(
                              margin: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    child: imgList1 != null &&
                                            imgList1.length > 0
                                        ? Container(
                                            height: 280,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: CarouselSlider.builder(
                                              itemCount: imgList1.length,
                                              options: CarouselOptions(
                                                height: 280,
                                                aspectRatio: 1.0,
                                                enlargeCenterPage: false,
                                                autoPlay: true,
                                                autoPlayInterval:
                                                    Duration(seconds: 3),
                                                viewportFraction: 1.0,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    _current = index;
                                                  });
                                                },
                                              ),
                                              itemBuilder:
                                                  (ctx, index, realIdx) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ZoomImage(imgList1),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: GroceryAppConstant
                                                              .Product_Imageurl2 +
                                                          imgList1[index],
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        color: Colors.grey[100],
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Color(
                                                                        0xff1E88E5)),
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        color: Colors.grey[100],
                                                        child: Center(
                                                          child: Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: 60,
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            height: 280,
                                            color: Colors.grey[100],
                                            child: Center(
                                              child: Icon(
                                                Icons.image_outlined,
                                                size: 80,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                  ),

                                  // Modern Carousel Indicators
                                  if (imgList1.isNotEmpty)
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            map<Widget>(imgList1, (index, url) {
                                          return Container(
                                            width: _current == index ? 24 : 8,
                                            height: 8,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              gradient: _current == index
                                                  ? LinearGradient(
                                                      colors: [
                                                        Color(0xff1E88E5),
                                                        Color(0xff42A5F5)
                                                      ],
                                                    )
                                                  : null,
                                              color: _current == index
                                                  ? null
                                                  : Colors.grey[300],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Modern Product Info Card
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header with icon
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xff1E88E5), // Medical blue
                                              Color(
                                                  0xff42A5F5) // Lighter medical blue
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Icon(
                                          Icons.local_hospital_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Medical Appointment",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff1E88E5),
                                              ),
                                            ),
                                            Text(
                                              "Professional healthcare service",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20),

                                  // Service Name
                                  Text(
                                    widget.plist.productName ??
                                        "Medical Service",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  // Variant/Type if exists
                                  if (name.isNotEmpty &&
                                      name != widget.plist.productName)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff1E88E5).withOpacity(0.1),
                                            Color(0xff42A5F5).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Color(0xff1E88E5)
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff1E88E5),
                                        ),
                                      ),
                                    ),

                                  SizedBox(height: 20),

                                  // Modern Price Section
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff1E88E5).withOpacity(0.05),
                                          Color(0xff42A5F5).withOpacity(0.02),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color:
                                            Color(0xff1E88E5).withOpacity(0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          color: Color(0xff1E88E5),
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Consultation Fee",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  // Current Price
                                                  Text(
                                                    '₹${(totalmrp! * _count).toStringAsFixed(GroceryAppConstant.val)}',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color(0xff1E88E5),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),

                                                  // Original Price (if different)
                                                  if (total != null &&
                                                      total !=
                                                          (totalmrp! * _count)
                                                              .round())
                                                    Text(
                                                      '₹$total',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey[500],
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Discount Badge
                                        if (total != null &&
                                            total !=
                                                (totalmrp! * _count).round())
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.green,
                                                  Colors.green.shade600
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.green
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.local_offer,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${total! > 0 ? (((total! - (totalmrp! * _count)) / total!) * 100).abs().toStringAsFixed(0) : "0"}% OFF',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Rating Section
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff1E88E5).withOpacity(0.1),
                                          Color(0xff1E88E5).withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            Color(0xff1E88E5).withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        ...List.generate(
                                            4,
                                            (index) => Icon(
                                                  Icons.star_rounded,
                                                  size: 16,
                                                  color: Colors.amber,
                                                )),
                                        Icon(
                                          Icons.star_border_rounded,
                                          size: 16,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "4.8",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "(450+ patients)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Modern Controls Section
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  // Color and Size Selection
                                  if (widget.plist.productColor!.length >= 2 ||
                                      widget.plist.productScale!.length >= 2)
                                    Container(
                                      padding: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.95),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Header
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xff1E88E5),
                                                      Color(0xff42A5F5)
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Icon(
                                                  Icons
                                                      .medical_information_rounded,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Text(
                                                "Appointment Options",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff1E88E5),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 24),

                                          // Color Selection
                                          if (widget
                                                  .plist.productColor!.length >=
                                              2) ...[
                                            Text(
                                              "Select Appointment Type",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 4),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xff1E88E5)
                                                        .withOpacity(0.05),
                                                    Color(0xff42A5F5)
                                                        .withOpacity(0.02),
                                                  ],
                                                ),
                                                border: Border.all(
                                                  color: Color(0xff1E88E5)
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: DropdownButton<String>(
                                                value: _dropDownValue,
                                                hint: Text(
                                                  'Choose appointment type',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                isExpanded: true,
                                                underline: SizedBox(),
                                                icon: Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff1E88E5)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Color(0xff1E88E5),
                                                    size: 20,
                                                  ),
                                                ),
                                                items:
                                                    color!.map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8),
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _dropDownValue = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],

                                          // Size Selection
                                          if (widget
                                                  .plist.productScale!.length >=
                                              2) ...[
                                            if (widget.plist.productColor!
                                                    .length >=
                                                2)
                                              SizedBox(height: 20),
                                            Text(
                                              "Select Duration",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 4),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xff1E88E5)
                                                        .withOpacity(0.05),
                                                    Color(0xff42A5F5)
                                                        .withOpacity(0.02),
                                                  ],
                                                ),
                                                border: Border.all(
                                                  color: Color(0xff1E88E5)
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: DropdownButton<String>(
                                                value: _dropDownValue1,
                                                hint: Text(
                                                  'Choose duration',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                isExpanded: true,
                                                underline: SizedBox(),
                                                icon: Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff1E88E5)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Color(0xff1E88E5),
                                                    size: 20,
                                                  ),
                                                ),
                                                items:
                                                    size!.map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8),
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _dropDownValue1 = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                  SizedBox(height: 16),

                                  // Quantity controls removed as per client requirement
                                ],
                              ),
                            ),
                            // Modern Book Appointment Button - Enhanced Design
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff1E88E5), // Medical blue
                                      Color(0xff42A5F5), // Lighter medical blue
                                      Color(0xff64B5F6) // Lightest medical blue
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff1E88E5).withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () async {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      if (GroceryAppConstant.isLogin) {
                                        if (widget.plist.productColor!.length >
                                                2 &&
                                            widget.plist.productScale!.length >
                                                2) {
                                          if (_dropDownValue != null &&
                                              _dropDownValue1 != null) {
                                            addTocardval();
                                            GroceryAppConstant
                                                .groceryAppCartItemCount++;
                                            groceryCartItemCount(
                                                GroceryAppConstant
                                                    .groceryAppCartItemCount);
                                            setState(() {
                                              AppConstent.cc++;
                                              pref.setInt("cc", AppConstent.cc);
                                            });
                                          } else {
                                            showLongToast(
                                                "Please select appointment type and duration");
                                          }
                                        } else if (widget
                                                .plist.productColor!.length >
                                            2) {
                                          if (_dropDownValue != null) {
                                            addTocardval();
                                            GroceryAppConstant
                                                .groceryAppCartItemCount++;
                                            groceryCartItemCount(
                                                GroceryAppConstant
                                                    .groceryAppCartItemCount);
                                            setState(() {
                                              AppConstent.cc++;
                                              pref.setInt("cc", AppConstent.cc);
                                            });
                                          } else {
                                            showLongToast(
                                                "Please select appointment type");
                                          }
                                        } else if (widget
                                                .plist.productScale!.length >
                                            2) {
                                          if (_dropDownValue1 != null) {
                                            addTocardval();
                                            GroceryAppConstant
                                                .groceryAppCartItemCount++;
                                            groceryCartItemCount(
                                                GroceryAppConstant
                                                    .groceryAppCartItemCount);
                                            setState(() {
                                              AppConstent.cc++;
                                              pref.setInt("cc", AppConstent.cc);
                                            });
                                          } else {
                                            showLongToast(
                                                "Please select duration");
                                          }
                                        } else {
                                          addTocardval();
                                        }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()),
                                        );
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 18),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "Book Appointment Now",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            pvarlist.isNotEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, top: 18.0),
                                        child: Text(
                                          ' Variant:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              _displayDialog(context);
                                              // _showSelectionDialog(context);
                                            },
                                            child: Container(
                                              // width: MediaQuery.of(context).size.width/1.5,
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 0.0,
                                                right: 10.0,
                                              ),
                                              margin: const EdgeInsets.only(
                                                top: 5.0,
                                              ),

                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Text(
                                                      textval.length > 20
                                                          ? textval.substring(
                                                                  0, 20) +
                                                              ".."
                                                          : textval,

                                                      overflow:
                                                          TextOverflow.fade,
                                                      // maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: GroceryAppColors
                                                            .black,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0),
                                                      child: Icon(
                                                        Icons.expand_more,
                                                        color: Colors.black,
                                                        size: 30,
                                                      ))
                                                ],
                                              )),

                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                            ),
                                          )),

                                      /*Container(
                                 color: AppColors.black,
                                   margin:EdgeInsets.only(left: 10,top: 10,right: 10) ,
                                   height: 45,
                                   child: Padding(
                                     padding: EdgeInsets.only(left: 0,top: 0,right: 0),
                                     child: TextField(
                                         minLines: 1,
                                         maxLines: 3,
                                         decoration: InputDecoration(
                                           prefixIcon: Icon(Icons.expand_more),
                                             hintText: "Select varient",
                                             border: OutlineInputBorder()
                                         )),))*/
                                    ],
                                  )
                                : Row(),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                if (showdis) {
                                  setState(() {
                                    showdis = false;
                                  });
                                } else {
                                  setState(() {
                                    showdis = true;
                                  });
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Medical Details:',
                                        style: TextStyle(
                                          color: Color(0xff1E88E5),
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 12.0, top: 4.0),
                                        child: Icon(
                                            showdis
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,

//                                        Icons.keyboard_arrow_down,
                                            size: 26,
                                            color: GroceryAppColors.black))
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            showdis
                                ? Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        constraints: BoxConstraints(
                                          maxHeight: 200, // Reduced from 300
                                        ),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                BouncingScrollPhysics(), // Allow scrolling if needed
                                            itemCount: amenitiesModel.data!
                                                .customFieldsValue!.length,
                                            itemBuilder: (context, index) {
                                              final name = amenitiesModel
                                                  .data!
                                                  .customFieldsValue![index]
                                                  .fieldsName;
                                              final value = amenitiesModel
                                                  .data!
                                                  .customFieldsValue![index]
                                                  .fieldValue;
                                              final key = name!
                                                  .substring(
                                                      0, name.indexOf(','))
                                                  .replaceAll("_", " ");

                                              print(
                                                  "amenitiesModel.data.customFieldsValue.length--> ${amenitiesModel.data!.customFieldsValue!.length}");
                                              return _amenitiesCard(
                                                  key: key, value: value!);
                                            }),
                                      ),
                                      // discription(
                                      //     "Warranty: ", widget.plist.warrantys ?? ""),

                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: <Widget>[
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(
                                      //           left: 16.0, top: 8.0),
                                      //       child: Text(
                                      //         "Return: ",
                                      //         overflow: TextOverflow.fade,
                                      //         style: TextStyle(
                                      //           color: Colors.black,
                                      //           fontSize: 15.0,
                                      //           fontWeight: FontWeight.bold,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(
                                      //           left: 16.0, top: 8.0),
                                      //       child: Text(
                                      //         widget.plist.returns == "0"
                                      //             ? "No"
                                      //             : widget.plist.returns ??
                                      //                 "" + "day",
                                      //         overflow: TextOverflow.fade,
                                      //         style: TextStyle(
                                      //           color: Colors.black,
                                      //           fontSize: 14.0,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
//                             discription("Return: ",widget.plist.returns),
                                      // discription("Brand: ",
                                      //     widget.plist.productVendor ?? ""),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: <Widget>[
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(
                                      //           left: 16.0, top: 8.0),
                                      //       child: Text(
                                      //         "Cancel: ",
                                      //         overflow: TextOverflow.fade,
                                      //         style: TextStyle(
                                      //           color: Colors.black,
                                      //           fontSize: 15.0,
                                      //           fontWeight: FontWeight.bold,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(
                                      //           left: 16.0, top: 8.0),
                                      //       child: Text(
                                      //         widget.plist.cancels == "0"
                                      //             ? "No"
                                      //             : widget.plist.cancels ??
                                      //                 "" + "day",
                                      //         overflow: TextOverflow.fade,
                                      //         style: TextStyle(
                                      //           color: Colors.black,
                                      //           fontSize: 14.0,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
//                             discription("Cancel: ",widget.plist.cancels),
//                             discription("Delivery: ",widget.plist.cancels),
                                      // Modern Description Section
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.95),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 20,
                                              offset: Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF1B5E20),
                                                        Color(0xFF2E7D32)
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Icon(
                                                    Icons.description,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Text(
                                                  "Service Details",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF1B5E20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16),
                                            // Description Content
                                            HtmlViewWidget(
                                                discription: widget
                                                    .plist.productDescription
                                                    .toString()),
                                          ],
                                        ),
                                      ),
//                             Padding(
//                                padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                child:  Text(widget.plist.productDescription,
//                                  overflow: TextOverflow.fade,
//                                  style:  TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 14.0,
//                                  ),
//                                ),
//                              ),
                                    ],
                                  )
                                : Container(),
                            group.isEmpty
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      group != null
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0, top: 8.0),
                                              child: Text(
                                                groupname ?? "",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Row(),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        height: 78.0,
                                        child: group != null
                                            ? ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: group.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return group[index]
                                                              .img!
                                                              .length >
                                                          2
                                                      ? Container(
                                                          width: 70.0,
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            child: InkWell(
                                                              onTap: () {
//                                              setState(() {
//
//                                                url=imgList1[index];
//                                                showLongToast("Product is selected ");
//                                              });
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProductDetails1(group[index].productIs ??
                                                                              "")),
                                                                );
//
                                                              },
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  group[index]
                                                                              .img!
                                                                              .length >
                                                                          2
                                                                      ? SizedBox(
                                                                          height:
                                                                              70,
                                                                          child:
                                                                              Image.network(
                                                                            GroceryAppConstant.Product_Imageurl1 +
                                                                                group[index].img.toString(),
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )
                                                                          /*  CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:Constant.Product_Imageurl1+group[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                    placeholder: (context, url) =>
                                                        Center(
                                                            child:
                                                            CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                     Icon(Icons.error),

                                                  ),*/
                                                                          )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Row();
                                                })
                                            : CircularProgressIndicator(),
                                      ),
                                    ],
                                  ),
                            // Modern Related Services Header
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF6B35).withOpacity(
                                        0.1), // Primary orange with opacity
                                    Color(0xFFFF8A50).withOpacity(
                                        0.05), // Light orange with opacity
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color(0xFF1B5E20).withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF1B5E20),
                                          Color(0xFF2E7D32)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.recommend,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Related Services',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1B5E20),
                                          ),
                                        ),
                                        Text(
                                          'Other services you might like',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                height: 220.0,
                                child: topProducts1 != null
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: topProducts1.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                width: topProducts1.isNotEmpty
                                                    ? 140.0
                                                    : 180.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Card(
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  child: Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ProductDetails(
                                                                          topProducts1[
                                                                              index])),
                                                            );
                                                          },
                                                          child: Container(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          14),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          14)),
                                                              child: Container(
                                                                height: 120.0,
                                                                width: double
                                                                    .infinity,
                                                                child: topProducts1[index]
                                                                            .img !=
                                                                        null
                                                                    ? CachedNetworkImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl:
                                                                            (() {
                                                                          final String?
                                                                              imgUrlField =
                                                                              topProducts1[index].img_url;
                                                                          final String?
                                                                              imgField =
                                                                              topProducts1[index].img;
                                                                          String
                                                                              finalUrl;
                                                                          if (imgUrlField != null &&
                                                                              imgUrlField
                                                                                  .isNotEmpty) {
                                                                            finalUrl =
                                                                                imgUrlField;
                                                                          } else if (imgField != null &&
                                                                              imgField.isNotEmpty &&
                                                                              imgField != 'no-img.png' &&
                                                                              imgField != 'no-cover.png') {
                                                                            if (imgField.startsWith('http://') ||
                                                                                imgField.startsWith('https://')) {
                                                                              finalUrl = imgField;
                                                                            } else {
                                                                              final String imageName = imgField.split('/').last;
                                                                              finalUrl = GroceryAppConstant.Product_Imageurl + imageName;
                                                                            }
                                                                          } else {
                                                                            finalUrl =
                                                                                "https://www.bigwelt.com/manage/uploads/gallery/no-img.png";
                                                                          }
                                                                          return finalUrl;
                                                                        })(),
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Container(
                                                                          color:
                                                                              Colors.grey[100],
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(GroceryAppColors.tela),
                                                                              strokeWidth: 2,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Container(
                                                                          color:
                                                                              Colors.grey[100],
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Icon(
                                                                              Icons.image_outlined,
                                                                              size: 40,
                                                                              color: Colors.grey[400],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        color: Colors
                                                                            .grey[100],
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.image_outlined,
                                                                            size:
                                                                                40,
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 6,
                                                                    right: 6,
                                                                    top: 6),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4,
                                                                    right: 6),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                SizedBox(
                                                                  height: 30,
                                                                  child: Text(
                                                                    (() {
                                                                      final name =
                                                                          topProducts1[index].productName ??
                                                                              '';
                                                                      return name.length >
                                                                              20
                                                                          ? name.substring(0, 20) +
                                                                              '...'
                                                                          : name;
                                                                    })(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: GroceryAppColors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 6),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      '\u{20B9} ${topProducts1[index].buyPrice}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          fontSize:
                                                                              11,
                                                                          color: GroceryAppColors
                                                                              .black,
                                                                          decoration:
                                                                              TextDecoration.lineThrough),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              2.0,
                                                                          bottom:
                                                                              1),
                                                                      child: Text(
                                                                          '\u{20B9} ${calDiscount(topProducts1[index].buyPrice ?? "", topProducts1[index].discount ?? "")}',
                                                                          style: TextStyle(
                                                                              color: GroceryAppColors.green,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12)),
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
                                              double.parse(topProducts1[index]
                                                              .discount ??
                                                          "0") >
                                                      0
                                                  ? Positioned(
                                                      top: 8,
                                                      left: 8,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6,
                                                                vertical: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          '${topProducts1[index].discount}% OFF',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          );
                                        })
                                    : CircularProgressIndicator(),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ),
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//  discountValue;
//  String adminper;
//  String adminpricevalue;
//  String costPrice;
  void _addToproducts(BuildContext context) {
    // Client requirement: Only one item with quantity 1 allowed in cart
    // Clear all existing items from cart first
    dbmanager.deleteallProducts().then((_) {
      print((totalmrp! * 1).toString() + "............");
      // Create new product with quantity 1
      ProductsCart st = ProductsCart(
          pid: widget.plist.productIs,
          pname: widget.plist.productName,
          pimage: url,
          pprice: totalmrp!.toString(), // Always price for quantity 1
          pQuantity: 1, // Always quantity 1 as per requirement
          pcolor: _dropDownValue != null ? _dropDownValue : "",
          psize: _dropDownValue1 != null ? _dropDownValue1 : "",
          pdiscription: widget.plist.productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: widget.plist.discount,
          discountValue: dicountValue.toString(),
          adminper: widget.plist.msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: total.toString(),
          shipping: widget.plist.shipping,
          totalQuantity: widget.plist.quantityInStock,
          varient: textval,
          mv: int.parse(widget.plist.mv ?? ""));

      // Add the new product as the only item in cart
      dbmanager.insertStudent(st).then((id) {
        if (this.mounted) {
          setState(() {
            // Reset cart count to 1 since we only have one item
            GroceryAppConstant.groceryAppCartItemCount = 1;
            GroceryAppConstant.carditemCount = 1;
            AppConstent.cc = 1;
          });

          // Update shared preferences
          SharedPreferences.getInstance().then((pref) {
            pref.setInt("cc", AppConstent.cc);
          });

          print(
              'Product Added to Cart - ID: ${id}, Name: ${widget.plist.productName}');
          showLongToast(" Services  is added to cart ");

          // Navigate to address selection after successful cart addition
          _navigateToCheckout();
        }
      }).catchError((error) {
        print('Error adding product to cart: $error');
        showLongToast("Failed to add item to cart");
      });
    }).catchError((error) {
      print('Error clearing cart: $error');
      showLongToast("Failed to clear cart");
    });
  }

  void _addToproducts1(BuildContext context) {
    if (nproducts == null) {
      WishlistsCart st1 = WishlistsCart(
          pid: widget.plist.productIs,
          pname: widget.plist.productName,
          pimage: url,
          pprice: totalmrp.toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: widget.plist.productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: widget.plist.discount,
          discountValue: dicountValue.toString(),
          adminper: widget.plist.msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: widget.plist.buyPrice);
      dbmanager1.insertStudent(st1).then((id) => {
            setState(() {
              wishid = id;

              print('Student Added to Db ${wishid}');
              print(GroceryAppConstant.totalAmount);
            })
          });
    }
  }

  _amenitiesCard({String? key, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 2.0), // Reduced vertical padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Reduced width from 120
            child: Text(
              key ?? "s" + ":",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0, // Reduced from 13
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 6), // Reduced from 8
          Expanded(
            child: Text(
              value ?? '',
              softWrap: true,
              maxLines: 2, // Reduced from 3
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 11.0, // Reduced from 12
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _discriptionText() {
    return TextStyle(
      color: Colors.black,
      fontSize: 14.0,
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

  void _navigateToCheckout() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowAddress("0")),
      );
    }
  }

  void addTocardval() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (int.parse(widget.plist.quantityInStock ?? "") > 0) {
      _addToproducts(context);
      // Navigation is now handled inside _addToproducts method after successful database insertion
    } else {
      showLongToast("Product is out of stock");
    }
  }

  // Helper method to get color from name
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return Color(0xFF1B5E20); // Default to dark green
    }
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _countList(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("wcount", val);
  }

  Widget discription(String name, String Discription) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              name,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                Discription != null ? Discription : "",
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

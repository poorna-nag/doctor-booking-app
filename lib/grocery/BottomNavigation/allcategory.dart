import 'package:ecoshine24/constent/app_constent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoshine24/grocery/Auth/signin.dart';
import 'package:ecoshine24/grocery/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/CategaryModal.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:ecoshine24/grocery/screen/SearchScreen.dart';
import 'package:ecoshine24/grocery/screen/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllCategory extends StatefulWidget {
  final String title;
  final String id;
  const AllCategory(this.title, this.id) : super();
  @override
  _AllCategory createState() => _AllCategory();
}

class _AllCategory extends State<AllCategory> {
  double? sgst1, cgst1, dicountValue, admindiscountprice;

  bool product = false;
  List<Products> products = [];
  bool flag = true;
  double? mrp, totalmrp = 000;
  int _count = 1;
  List<Products> products1 = [];
  int cc = 0;

  String textval = "Select varient";

  int _current = 0;
  List<Categary> list1 = [];
  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    setState(() {
      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
      }
//      print(Constant.carditemCount.toString()+"itemCount");
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

  @override
  void initState() {
    super.initState();
    gatinfoCount();
    getcartCount();
    DatabaseHelper.getData(widget.id).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          list1 = usersFromServe!;
          if (list1.length == 0) {
            flag = false;
          }
          print(list1.length);
        });
      }
    });

    getlist(countval);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          countval = countval + 10;
          getlist(countval);
        });
      }
    });
  }

  int countval = 0;
  ScrollController _scrollController = new ScrollController();

  getlist(int lim) {
    catby_productData(widget.id, lim.toString()).then((usersFromServe) {
      setState(() {
        products1.addAll(usersFromServe);
        if (products1.length == 0) {
          product = true;
          print(product);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();

    return Scaffold(
        backgroundColor: Color(0xFFF8FBFF), // Light medical background
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff1E88E5), // Medical blue
                  Color(0xff1E88E5), // Lighter medical blue
                  Color(0xff1E88E5), // Lightest medical blue
                ],
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
          leading: Container(
            margin: EdgeInsets.only(left: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              borderRadius: BorderRadius.circular(14),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          title: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.medical_services_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title.isEmpty ? "All Categories" : widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "Medical Services",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserFilterDemo()),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WishList()),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            if (cc > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red,
                                        Colors.red[700]!,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '$cc',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
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
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          child: flag
              ? list1.length > 0
                  ? Container(
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        physics: ClampingScrollPhysics(),
                        controller:
                            new ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 4.5,
                        ),
                        itemBuilder: (context, index) {
                          Categary item = list1[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllCategory(
                                        item.pCats ?? "", item.pcatId ?? "")),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color:
                                            Color(0xFF1B5E20).withOpacity(0.1),
                                        border: Border.all(
                                          color: Color.fromARGB(255, 27, 37, 94)
                                              .withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: item.img != null &&
                                                item.img!.isNotEmpty
                                            ? Image(
                                                image:
                                                    getGroceryCategoryImageProvider(
                                                        item.img),
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Color.fromARGB(
                                                            255, 74, 147, 199)
                                                        .withOpacity(0.1),
                                                    child: Icon(
                                                      Icons.category_outlined,
                                                      color: Color.fromARGB(
                                                          255, 74, 147, 199),
                                                      size: 24,
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(
                                                color: Color(0xFF1B5E20)
                                                    .withOpacity(0.1),
                                                child: Icon(
                                                  Icons.category_outlined,
                                                  color: Color.fromARGB(
                                                      255, 74, 147, 19),
                                                  size: 24,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.pCats ?? "",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 47, 103, 143),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Explore services",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color.fromARGB(255, 74, 147, 199),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: list1.length,
                      ))
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                      ),
                    )
              : !product
                  ? products1.length > 0
                      ? Column(
                          children: [
                            Expanded(
                              child: Container(
                                  child: ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: products1.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Color(0xFFF8FBFF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            Color(0xff1E88E5).withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xff1E88E5)
                                              .withOpacity(0.12),
                                          blurRadius: 15,
                                          offset: Offset(0, 5),
                                          spreadRadius: 0,
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
                                                    products1[index],
                                                  )),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: <Widget>[
                                            // Product Image
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
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
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: products1[index].img !=
                                                        null
                                                    ? Image.network(
                                                        GroceryAppConstant
                                                                .Product_Imageurl +
                                                            products1[index]
                                                                .img
                                                                .toString(),
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color(0xff1E88E5)
                                                                      .withOpacity(
                                                                          0.15),
                                                                  Color(0xff42A5F5)
                                                                      .withOpacity(
                                                                          0.15),
                                                                ],
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .local_hospital_outlined,
                                                              color: Color(
                                                                  0xff1E88E5),
                                                              size: 40,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0xff1E88E5)
                                                                  .withOpacity(
                                                                      0.15),
                                                              Color(0xff42A5F5)
                                                                  .withOpacity(
                                                                      0.15),
                                                            ],
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .local_hospital_outlined,
                                                          color:
                                                              Color(0xff1E88E5),
                                                          size: 40,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            SizedBox(width: 16),

                                            // Product Details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  // Service Name
                                                  Text(
                                                    products1[index]
                                                            .productName ??
                                                        'Medical Service',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff2C3E50),
                                                      letterSpacing: 0.3,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 8),

                                                  // Price Section
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        '₹${calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "")}',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff1E88E5),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        '₹${products1[index].buyPrice}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[500],
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                      if (products1[index]
                                                                  .unit_type !=
                                                              null &&
                                                          products1[index]
                                                              .unit_type!
                                                              .isNotEmpty)
                                                        Text(
                                                          " /${products1[index].unit_type}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),

                                                  // Variant Selector
                                                  if (products1[index].p_id !=
                                                      null)
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xff1E88E5)
                                                                .withOpacity(
                                                                    0.05),
                                                            Color(0xff42A5F5)
                                                                .withOpacity(
                                                                    0.05),
                                                          ],
                                                        ),
                                                        border: Border.all(
                                                            color: Color(
                                                                    0xff1E88E5)
                                                                .withOpacity(
                                                                    0.3)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          _displayDialog(
                                                              context,
                                                              products1[index]
                                                                      .productIs ??
                                                                  "",
                                                              index);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                products1[index]
                                                                            .youtube!
                                                                            .length >
                                                                        1
                                                                    ? products1[index].youtube!.length >
                                                                            20
                                                                        ? products1[index].youtube!.substring(0,
                                                                                20) +
                                                                            ".."
                                                                        : products1[index].youtube ??
                                                                            ""
                                                                    : "Select variant",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff1E88E5),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons.expand_more,
                                                              color: Color(
                                                                  0xff1E88E5),
                                                              size: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  SizedBox(height: 12),

                                                  // Action Buttons
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 42,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                if (GroceryAppConstant
                                                                    .isLogin) {
                                                                  String mrp_price = calDiscount(
                                                                      products1[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      products1[index]
                                                                              .discount ??
                                                                          "");
                                                                  totalmrp =
                                                                      double.parse(
                                                                          mrp_price);
                                                                  double
                                                                      dicountValue =
                                                                      double.parse(products1[index].buyPrice ??
                                                                              "") -
                                                                          totalmrp!;
                                                                  String gst_sgst = calGst(
                                                                      mrp_price,
                                                                      products1[index]
                                                                              .sgst ??
                                                                          "");
                                                                  String gst_cgst = calGst(
                                                                      mrp_price,
                                                                      products1[index]
                                                                              .cgst ??
                                                                          "");
                                                                  String adiscount = calDiscount(
                                                                      products1[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      products1[index].msrp !=
                                                                              null
                                                                          ? products1[index].msrp ??
                                                                              ""
                                                                          : "0");
                                                                  admindiscountprice = (double.parse(
                                                                          products1[index].buyPrice ??
                                                                              "") -
                                                                      double.parse(
                                                                          adiscount));
                                                                  String color =
                                                                      "";
                                                                  String size =
                                                                      "";
                                                                  _addToproducts(
                                                                      products1[index].productIs ??
                                                                          "",
                                                                      products1[index].productName ??
                                                                          "",
                                                                      products1[index].img ??
                                                                          "",
                                                                      int.parse(
                                                                          mrp_price),
                                                                      int.parse(
                                                                          products1[index].count ??
                                                                              ""),
                                                                      color,
                                                                      size,
                                                                      products1[index]
                                                                              .productDescription ??
                                                                          "",
                                                                      gst_sgst,
                                                                      gst_cgst,
                                                                      products1[index]
                                                                              .discount ??
                                                                          "",
                                                                      dicountValue
                                                                          .toString(),
                                                                      products1[index]
                                                                              .APMC ??
                                                                          "",
                                                                      admindiscountprice
                                                                          .toString(),
                                                                      products1[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      products1[index]
                                                                              .shipping ??
                                                                          "",
                                                                      products1[index]
                                                                              .quantityInStock ??
                                                                          "",
                                                                      products1[index]
                                                                              .youtube ??
                                                                          "",
                                                                      products1[index]
                                                                              .mv ??
                                                                          "");
                                                                } else {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                SignInPage()),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                foregroundColor:
                                                                    Color(
                                                                        0xFF1E88E5),
                                                                elevation: 0,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            10),
                                                                side: BorderSide(
                                                                    color: Color(
                                                                        0xFF1E88E5),
                                                                    width: 1.5),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .shopping_cart_outlined,
                                                                      size: 14),
                                                                  SizedBox(
                                                                      width: 4),
                                                                  Flexible(
                                                                    child: Text(
                                                                      "Add to Cart",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        letterSpacing:
                                                                            0.3,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 42,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (GroceryAppConstant
                                                                    .isLogin) {
                                                                  if (num.parse(
                                                                          products1[index].quantityInStock ??
                                                                              '0') >
                                                                      0) {
                                                                    String mrp_price = calDiscount(
                                                                        products1[index].buyPrice ??
                                                                            "",
                                                                        products1[index].discount ??
                                                                            "");
                                                                    totalmrp =
                                                                        double.parse(
                                                                            mrp_price);
                                                                    double
                                                                        dicountValue =
                                                                        double.parse(products1[index].buyPrice ??
                                                                                "") -
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
                                                                        products1[index].msrp !=
                                                                                null
                                                                            ? products1[index].msrp ??
                                                                                ""
                                                                            : "0");
                                                                    admindiscountprice = (double.parse(products1[index].buyPrice ??
                                                                            "") -
                                                                        double.parse(
                                                                            adiscount));
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
                                                                    await Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              WishList()),
                                                                    );
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    showLongToast(
                                                                        "Product is out of stock");
                                                                  }
                                                                } else {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                SignInPage()),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF1E88E5),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 2,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            10),
                                                                shadowColor: Color(
                                                                        0xFF1E88E5)
                                                                    .withOpacity(
                                                                        0.3),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .event_available,
                                                                      size: 14),
                                                                  SizedBox(
                                                                      width: 4),
                                                                  Flexible(
                                                                    child: Text(
                                                                      "Book Now",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        letterSpacing:
                                                                            0.3,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                            ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1E88E5)),
                          ),
                        )
                  : Container(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 80,
                              color: Color(0xFF1E88E5).withOpacity(0.3),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No Services Found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Try searching for different services or check back later",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7F8C8D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
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

  int? total;

  _displayDialog(BuildContext context, String id, int index1) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Select Variant',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            content: Container(
              width: double.maxFinite,
              height: 200,
              child: FutureBuilder(
                  future: getPvarient(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFF1B5E20).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    products1[index1].buyPrice =
                                        snapshot.data![index].price;
                                    products1[index1].discount =
                                        snapshot.data![index].discount;
                                    products1[index1].youtube =
                                        snapshot.data![index].variant;
                                    Navigator.pop(context);
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Color(0xFF1B5E20),
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          snapshot.data![index].variant ?? "",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF1B5E20),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF1B5E20),
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                      ),
                    );
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart? products2;
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
      String totalQun,
      String varient,
      String mv) {
    ProductsCart st = new ProductsCart(
      id: 0, // Add missing required parameter
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
      mv: int.tryParse(mv) ?? 0, // Convert string to int with null safety
      moq: "", // Add missing required parameter
      time1: "", // Add missing required parameter
      date1: "", // Add missing required parameter
    );
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

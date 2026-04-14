import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/grocery/Auth/signin.dart';
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

class VendorProductDetails extends StatefulWidget {
  final Products plist;
  final String mvId;

  const VendorProductDetails(this.plist, this.mvId) : super();

  @override
  VendorProductDetailsState createState() => VendorProductDetailsState();
}

class VendorProductDetailsState extends State<VendorProductDetails> {
  List<PVariant> pvarlist = [];
  AmenitiesModel amenitiesModel = AmenitiesModel();

  String name = "";

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

  // List<Products> products1 =[];
  List<Products> topProducts1 = [];

  final List<String> imgList1 = [];

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
  int actualprice = 200;
  double? mrp, totalmrp;
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  int cc = 0;
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

//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;

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

  static List<WishlistsCart>? prodctlist1;

  // final DbProductManager1 dbmanager12 =  DbProductManager1();

  @override
  void initState() {
    getcartCount();
    super.initState();
    name = widget.plist.productName ?? "";
    gatinfoCount();
    print(' product id ${widget.plist.productIs}');

    getPvarient(widget.plist.productIs ?? "").then((usersFromServe) {
      setState(() {
        pvarlist = usersFromServe!;
      });
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
      setState(() {
        galiryImage1 = usersFromServe!;
        imgList1.clear();
        for (var i = 0; i < galiryImage1.length; i++) {
          imgList1.add(galiryImage1[i].img ?? "");
        }
      });
    });

    GroupPro(widget.plist.productIs ?? "").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          group = usersFromServe!;
          print(group != null);
          groupname = group[0].name;
          print(group.toString() + "group info");
        });
      }
    });
    getTServicebymv_id(widget.mvId, "", "").then((usersFromServe) {
      setState(() {
        topProducts1 = usersFromServe!;
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
    return Scaffold(
      // backgroundColor: AppColors.tela1,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        backgroundColor: GroceryAppColors.tela,
        title: Text(
          "Service Details",
          style: TextStyle(color: GroceryAppColors.white),
        ),
        actions: <Widget>[
          // Cart icon removed from AppBar as per client requirement
          Container(
              width: 1, height: 1), // Placeholder to maintain actions structure
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(left: 15, bottom: 18),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GroceryAppColors.tela1,
                ),
                child: Text('${cc}',
                    style: TextStyle(color: Colors.white, fontSize: 15.0)),
              ),
            ),
          )
        ],
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
          print(
              'Product Added to Cart - ID: ${id}, Name: ${widget.plist.productName}');

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          key! + ":",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            value ?? "",
            softWrap: true,
            style: _discriptionText(),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
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

  void addTocardval() {
    if (int.parse(widget.plist.quantityInStock ?? "") > 0) {
      _addToproducts(context);
      // Navigation is now handled inside _addToproducts method after successful database insertion
    } else {
      showLongToast("Service is out of stock");
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

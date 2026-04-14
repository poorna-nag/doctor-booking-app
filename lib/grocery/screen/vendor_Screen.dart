import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:ecoshine24/grocery/screen/mv_products.dart';
import 'package:ecoshine24/model/ListModel.dart';
import 'package:ecoshine24/utils/dimensions.dart';
import 'package:ecoshine24/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorList extends StatefulWidget {
  final String cat, title;
  const VendorList(this.cat, this.title) : super();

  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList>
    with SingleTickerProviderStateMixin {
  bool flag = false;
  static const int PAGE_SIZE = 10;

  bool showFab = true;
  int _current = 0;
  List<ListModel> shoplist = [];
  int cc = 0;
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
      // //log("cart get count------------------->>$cCount");
      if (cCount == 0 || cCount! < 0) {
        cc = 0;
        AppConstent.cc = 0;
        //  //log(" AppConstent.cc------------------->>${AppConstent.cc}");
      } else {
        setState(() {
          cc = cCount;
          AppConstent.cc = cCount;
        });
      }
      //  //log("cart count------------------->>$cc");
    });
  }

  ScrollController _scrollController = new ScrollController();

  getdata(int count) {
    getShopListByCat(0, "700000", widget.cat).then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          shoplist.addAll(usersFromServe1);
          shoplist.length > 0 ? flag = false : flag = true;
          // print("sliderlist1.length");
          // print(shoplist.length);
        });
      }
    });
  }

  int countval = 0;
  @override
  void initState() {
    super.initState();
    getcartCount();
    gatinfoCount();

    getdata(countval);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          countval = countval + 6;
          getdata(countval);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: GroceryAppColors.tela,
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
                      Icons.arrow_back,
                      size: 25,
                      color: GroceryAppColors.white,
                    ),
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        widget.title.isEmpty ? "Products" : widget.title,
                        style: TextStyle(
                            color: GroceryAppColors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      /* InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserVenderSerch()),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(
                                Icons.search,
                                color: AppColors.black,
                                size: 30,
                              ),
                            ),
//                    showCircle(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),*/
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WishList()),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 13),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: GroceryAppColors.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, bottom: 18),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: GroceryAppColors.tela1,
                                    // color: Colors.orange,
                                  ),
                                  child: Text('${cc}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.0)),
                                ),
                              ),
                            ),
                            //showCircle(),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 10.0, right: 8.0,bottom: 10.0),
                  child: Center(
                    child: Text(widget.title,
                      style: TextStyle(
                          color: AppColors.product_title_name,
                          fontSize: 17,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
          ),
*/

                  !flag
                      ? Container(
                          // height: 500,
                          child: PagewiseListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          pageSize: PAGE_SIZE,
                          itemBuilder: this._itemBuilder,
                          pageFuture: (pageIndex) => getShopListByCat(
                              pageIndex! * PAGE_SIZE, "700000", widget.cat),
                        ))
                      : Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Column(
                            children: [
                              Image.asset('assets/gifs/nothing-found.gif'),
                              Center(
                                child: Text("No Vendors Available"),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )));
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

  Widget _itemBuilder(context, ListModel entry, int index) {
    return Padding(
      padding: EdgeInsets.only(
        right: Dimensions.PADDING_SIZE_SMALL,
        bottom: Dimensions.PADDING_SIZE_SMALL,
        left: Dimensions.PADDING_SIZE_SMALL,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MvProducts(
                    entry.name ?? "",
                    entry.mvId ?? "",
                    // widget.cat,
                    "",
                    entry.company ?? "",
                    entry.address ?? "",
                    entry.about ?? "",
                    entry.reviews1 ?? '',
                    entry.reviews_total ?? ''),
              ) // entry.cat)),
              );
        },
        child: Container(
          margin: EdgeInsets.only(left: 8, top: 8, right: 8),
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: entry.pp != null
                      ? entry.pp == "no-pp.png"
                          ? Image.asset(
                              "assets/images/logo.png",
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: GroceryAppConstant.logo_Image_mv +
                                  entry.pp.toString(),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                      //color: GroceryAppColors.tela,
                                      )),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            )
                      : Image.asset(
                          "assets/images/logo.png",
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        entry.company ?? '',
                        style: robotoMedium.copyWith(fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    double.parse(entry.reviews1 ?? "") > 0
                        ? Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 25,
                            width: 50,
                            color: GroceryAppColors.sellp,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${(double.parse(entry.reviews1 ?? "") / double.parse(entry.reviews_total ?? "")).toStringAsFixed(1)}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    entry.address ?? '',
                    style: robotoMedium.copyWith(
                        fontSize: 14, color: Theme.of(context).disabledColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

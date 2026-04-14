import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoshine24/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/screen/mv_products.dart';
import 'package:ecoshine24/model/CategaryModal.dart';
import 'package:ecoshine24/model/productmodel.dart';
import 'package:ecoshine24/model/slidermodal.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorProductCategories extends StatefulWidget {
  final String title;
  final String mvid;
  final String about;
  final String catid;
  final String review;
  final String review_totel;
  const VendorProductCategories(this.title, this.mvid, this.catid, this.about,
      this.review, this.review_totel)
      : super();
  @override
  _VendorProductCategories createState() => _VendorProductCategories();
}

class _VendorProductCategories extends State<VendorProductCategories> {
  double? sgst1, cgst1, dicountValue, admindiscountprice;

  bool product = false;
  List<Products> products = [];
  bool flag = true;
  double? mrp, totalmrp = 000;
  int _count = 1;
  List<Products> products1 = [];

  String textval = "Select varient";

  int _current = 0;
  PageController _pageController = PageController();
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

  List<Slider1> sliderlist = [];

  @override
  void initState() {
    super.initState();
    gatinfoCount();
    getSliderforMedicalShop(widget.mvid).then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          sliderlist = usersFromServe1!;
        });
      }
    });
    get_CategoryBYMv(widget.mvid).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          list1 = usersFromServe!;
          if (list1.length == 0) {
            flagval = true;
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
  bool flagval = false;
  getlist(int lim) {
    getTServicebymv_id(widget.mvid, widget.catid, lim.toString())
        .then((usersFromServe) {
      setState(() {
        products1.addAll(usersFromServe!);
        if (products1.length > 0) {
          product = true;
          print(product);
        }
      });
    });
  }

  double? _height;
  double? _width;
  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: GroceryAppColors.white,
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
                  size: 30,
                  color: GroceryAppColors.black,
                ),
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    widget.title.isEmpty ? "Products" : widget.title,
                    maxLines: 1,

                    // overflow:TextOverflow.ellipsis ,
                    style: TextStyle(color: GroceryAppColors.black),
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
                            color: GroceryAppColors.black,
                          ),
                        ),
                        showCircle(),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  sliderlist.length > 0
                      ? Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: _width,
                          child: Stack(
                            children: <Widget>[
                              PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _current = page;
                                    });
                                  },
                                  itemCount: sliderlist.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            GroceryAppConstant.Base_Imageurl +
                                                sliderlist[i].img.toString(),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                    );
                                  }),
                              Positioned(
                                bottom: 10.0,
                                left: 0.0,
                                right: 0.0,
                                child: DotsIndicator(
                                  dotsCount: sliderlist.length,
                                  position: _current,
                                  decorator: DotsDecorator(
                                    color: Colors.grey,
                                    activeColor: Colors.pink,
                                    spacing:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                  ),
                                ),
                              ),
                            ],
                          )

//                    Image.network( list.restaurantPhoto!=null?
//                      list.restaurantPhoto:"",
//                      fit: BoxFit.cover,
//                    )

                          )
                      : Container(),

                  SizedBox(
                    height: 20,
                  ),

                  flagval
                      ? Container(
                          margin: EdgeInsets.only(top: 200),
                          child: Center(
                            child: Text("Not Available"),
                          ),
                        )
                      : list1.length > 0
                          ? Container(
                              color: Colors.white,
                              child: GridView.count(
                                physics: ClampingScrollPhysics(),
                                controller: new ScrollController(
                                    keepScrollOffset: false),
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                childAspectRatio: .7,
                                // crossAxisSpacing: 7,
                                mainAxisSpacing: 14,
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10, bottom: 60),
                                children: List.generate(
                                  list1.length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MvProducts(
                                                list1[index].pCats ?? "",
                                                widget.mvid,
                                                list1[index].pcatId ?? "",
                                                "",
                                                "",
                                                widget.about,
                                                widget.review,
                                                widget.review_totel)),
                                      );
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child:
                                                    getGroceryCategoryImageWidget(
                                                  list1[index].img,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    bottom: 5,
                                                    top: 5),
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 40,
                                                child: Text(
                                                  list1[index].pCats ?? "",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: GroceryAppColors
                                                          .black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // Center(child: Text(items[index].get_title))
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          : Center(child: CircularProgressIndicator()),
                  /* list1.length > 0
                          ? Container(
                              height: MediaQuery.of(context).size.height / 1.65,
                              child: ListView.builder(
                                itemCount: list1.length,
                                shrinkWrap: true,
                                primary: false,
                                //scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 120,
                                    child: Card(
                                      elevation: 3,
                                      color: AppColors.tela,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(child: CircularProgressIndicator())*/
                  //  : Container(
                  // child: Center(
                  //   child: Text("No product is avaliable"),)),

                  // )

//            showTab(),
                ],
              ),
              childCount: 1,
            ),
          )
        ]));
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
            scrollable: true,
            title: Text('Select Variant'),
            content: Container(
              width: double.maxFinite,
              height: 200,
              child: FutureBuilder(
                  future: getPvarient(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length == null
                              ? 0
                              : snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: snapshot.data![index] != 0 ? 130.0 : 230.0,
                              color: Colors.white,
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    products1[index1].buyPrice =
                                        snapshot.data![index].price;
                                    products1[index1].discount =
                                        snapshot.data![index].discount;

                                    // total= int.parse(snapshot.data[index].price);
                                    // String  mrp_price=calDiscount(snapshot.data[index].price,snapshot.data[index].discount);
                                    // totalmrp= double.parse(mrp_price);
                                    products1[index1].youtube =
                                        snapshot.data![index].variant;

                                    Navigator.pop(context);
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        snapshot.data![index].variant ?? "",
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
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('CANCEL'),
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
          totalQuantity: totalQun,
          varient: varient,
          mv: int.parse(mv));
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
}

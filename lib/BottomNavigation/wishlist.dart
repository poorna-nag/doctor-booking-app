import 'package:flutter/material.dart';
import '../Auth/signin.dart';
import '../General/AppConstant.dart';
import '../StyleDecoration/styleDecoration.dart';
import '../dbhelper/CarrtDbhelper.dart';
import '../screen/ShowAddress.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  @override
  WishlistState createState() => WishlistState();
}

class WishlistState extends State<WishList> {
  final DbProductManager dbmanager = new DbProductManager();
  static List<ProductsCart>? prodctlist;
  static List<ProductsCart>? prodctlist1;
  double totalamount = 0;

  int _count = 1;
  bool islogin = false;

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    islogin = pref.getBool("isLogin")!;
    setState(() {
      FoodAppConstant.isLogin = islogin;
    });
  }

  @override
  void initState() {
//    openDBBB();
    super.initState();
    gatinfo();
    dbmanager.getProductList().then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          prodctlist1 = usersFromServe;
          for (var i = 0; i < prodctlist1!.length; i++) {
            print(prodctlist1![i].pprice);
            totalamount =
                totalamount + double.parse(prodctlist1![i].pprice ?? "");
          }

          FoodAppConstant.totalAmount = totalamount;
          FoodAppConstant.itemcount = prodctlist1!.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            createHeader(),
            createSubTitle(),
            Expanded(
                child: ListView.builder(
              itemCount: prodctlist1 == null ? 0 : prodctlist1!.length,
              itemBuilder: (BuildContext context, int index) {
                ProductsCart item = prodctlist1![index];
                var i = item.pQuantity;

                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      dbmanager.deleteProducts(item.id!);

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(" Serviceis removed"),
                          duration: Duration(seconds: 1)));
                    } else {
                      dbmanager.deleteProducts(item.id!);
                      setState(() {
//                        Constant.itemcount--;
////                              Constant.totalAmount= Constant.totalAmount-double.parse(item.pprice);
//                        Constant.carditemCount--;
//                        cartItemcount(Constant.carditemCount);
                      });

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(" Serviceis removed "),
                          duration: Duration(seconds: 1)));
                    }
                    // Remove the item from the data source.
                    setState(() {
                      prodctlist1!.removeAt(index);
                      FoodAppConstant.totalAmount =
                          FoodAppConstant.totalAmount -
                              double.parse(item.pprice ?? "");
                      FoodAppConstant.itemcount--;

                      FoodAppConstant.foodAppCartItemCount--;
                      foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
                    });
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(
                    decoration: BoxDecoration(color: Colors.red),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    height: 100.0,
                    decoration: BoxDecoration(color: Colors.red),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  child: InkWell(
                      onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ProductDetails()),
//                );
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 8, left: 8, top: 8, bottom: 8),
                                    width: 90,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        color: Colors.red.shade200,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: item.pimage != null
                                                ? NetworkImage(
                                                    FoodAppConstant
                                                            .Product_Imageurl +
                                                        item.pimage.toString(),
                                                  )
                                                : AssetImage(
                                                        'assets/images/eco-shine-logo.png')
                                                    as ImageProvider)),
                                  ),
                                  Expanded(
                                    flex: 100,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 8, top: 4),
                                            child: Text(
                                              item.pname == null
                                                  ? 'name'
                                                  : item.pname ?? "",
                                              maxLines: 2,
                                              softWrap: true,
                                              style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)
                                                  .copyWith(fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            item.pprice == null
                                                ? '100'
                                                : '\u{20B9} ${double.parse(item.pprice ?? "").toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ).copyWith(color: Colors.green),
                                          ),
                                          SizedBox(height: 6),

                                          item.pcolor!.length > 0
                                              ? Text(
                                                  'COLOR ${item.pcolor}',
                                                  style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black)
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                )
                                              : Row(),

                                          // SizedBox(height: 6),
                                          item.psize!.length > 0
                                              ? Text(
                                                  'Size ${item.psize}',
                                                  style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black)
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                )
                                              : Row(),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          if (prodctlist1![
                                                                      index]
                                                                  .quantity !=
                                                              1) {
                                                            setState(() {
                                                              String pvalue =
                                                                  calDiscount1(
                                                                      item.costPrice ??
                                                                          "",
                                                                      item.discount ??
                                                                          "");
                                                              double price =
                                                                  double.parse(
                                                                      pvalue);
                                                              FoodAppConstant
                                                                      .totalAmount =
                                                                  FoodAppConstant
                                                                          .totalAmount -
                                                                      price;
                                                              int quantity = item
                                                                  .pQuantity!;
                                                              int totalquantity =
                                                                  quantity - 1;
                                                              double
                                                                  incrementprice =
                                                                  (price *
                                                                      totalquantity);
                                                              prodctlist1![
                                                                          index]
                                                                      .price =
                                                                  incrementprice
                                                                      .toString();
                                                              prodctlist1![
                                                                          index]
                                                                      .quantity =
                                                                  totalquantity;
                                                              dbmanager
                                                                  .updateStudent(
                                                                      item);
                                                            });
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 24,
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors
                                                            .grey.shade200,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 2,
                                                                right: 12,
                                                                left: 12),
                                                        child: Text(item
                                                                    .pQuantity ==
                                                                null
                                                            ? '1'
                                                            : '${prodctlist1![index].quantity}'),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            String pvalue =
                                                                calDiscount1(
                                                                    item.costPrice ??
                                                                        "",
                                                                    item.discount!);
                                                            double price =
                                                                double.parse(
                                                                    pvalue);
                                                            FoodAppConstant
                                                                    .totalAmount =
                                                                FoodAppConstant
                                                                        .totalAmount +
                                                                    price;

                                                            int quantity =
                                                                item.pQuantity!;
                                                            int totalquantity =
                                                                quantity + 1;
                                                            double
                                                                incrementprice =
                                                                (price *
                                                                    totalquantity);
                                                            prodctlist1![index]
                                                                    .price =
                                                                incrementprice
                                                                    .toString();
                                                            prodctlist1![index]
                                                                    .quantity =
                                                                totalquantity;
                                                            dbmanager
                                                                .updateStudent(
                                                                    item);
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 24,
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 10, top: 8),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Colors.red),
                              child: InkWell(
                                onTap: () {
                                  dbmanager.deleteProducts(item.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(" Serviceis removed "),
                                          duration: Duration(seconds: 2)));
                                  setState(() {
                                    prodctlist1!.removeAt(index);
                                    FoodAppConstant.itemcount--;
                                    FoodAppConstant.totalAmount =
                                        FoodAppConstant.totalAmount -
                                            double.parse(item.pprice ?? "");
                                    FoodAppConstant.foodAppCartItemCount--;
                                    foodCartItemCount(
                                        FoodAppConstant.foodAppCartItemCount);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                );
              },
            )),
            footer(context),
          ],
        ),
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black)
                      .copyWith(color: Colors.black, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  '\u{20B9} ${FoodAppConstant.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.yellow.shade700,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FoodAppColors.onselectedBottomicon,
              padding:
                  EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: () {
              if (FoodAppConstant.isLogin) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowAddress("0")),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }
            },
            child: Text(
              "Book Now",
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 12, top: 25),
      child: Text(
        "SHOPPING CART",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 12, top: 4),
      child: Text(
        'Total (${FoodAppConstant.itemcount}) Items',
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  String calDiscount1(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  String calDiscount(String totalamount) {
    setState(() {
      FoodAppConstant.totalAmount = double.parse(totalamount);
    });
    return FoodAppConstant.totalAmount.toStringAsFixed(2).toString();
  }
}

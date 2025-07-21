import 'dart:io';

import 'package:aladdinmart/model/ShopDModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:aladdinmart/Auth/signin.dart';
import 'package:aladdinmart/grocery/BottomNavigation/categories.dart';
import 'package:aladdinmart/grocery/BottomNavigation/profile.dart';
import 'package:aladdinmart/grocery/BottomNavigation/profiledraw.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/General/Home.dart';
import 'package:aladdinmart/grocery/Web/WebviewTermandCondition.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/screen/CustomeOrder.dart';
import 'package:aladdinmart/grocery/screen/ShowAddress.dart';
import 'package:aladdinmart/grocery/screen/myorder.dart';
import 'package:aladdinmart/grocery/screen/newWishlist.dart';
import 'package:aladdinmart/grocery/screen/productlist.dart';
import 'package:aladdinmart/screen/wallecttransation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool islogin = false;
  String? name, email, image, cityname, mobile;
  int? wcount;

  ShopDModel? shopDetails;
  SharedPreferences? pref;
  void gatinfo() async {
    pref = await SharedPreferences.getInstance();
    islogin = pref!.getBool("isLogin")!;
    int wcount1 = pref!.getInt("wcount")!;
    name = pref!.getString("name");
    email = pref!.getString("email");
    image = pref!.getString("pp");
    cityname = pref!.getString("city");
    mobile = pref!.getString("mobile");
    if (islogin == null) {
      islogin = false;
    }

    // print(islogin);
    setState(() {
      GroceryAppConstant.name = name ?? "";
      GroceryAppConstant.email = email ?? "";
      islogin == null
          ? GroceryAppConstant.isLogin = false
          : GroceryAppConstant.isLogin = islogin;
      GroceryAppConstant.image = image ?? "";
      print(GroceryAppConstant.image);
      GroceryAppConstant.citname = cityname ?? "";

      // print( Constant.image.length);
      wcount = wcount1;
    });
  }

  bool check = false;
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select City'),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: FutureBuilder(
                  future: getPcity(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data?.length == null
                                  ? 0
                                  : snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: snapshot.data![index] != 0
                                      ? 130.0
                                      : 230.0,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        check = true;
                                        pref!.setString('city',
                                            snapshot.data![index].places ?? "");
                                        pref!.setString('cityid',
                                            snapshot.data![index].loc_id ?? "");
                                        GroceryAppConstant.cityid =
                                            snapshot.data![index].loc_id ?? "";
                                        GroceryAppConstant.citname =
                                            snapshot.data![index].places ?? "";

                                        Navigator.pop(context);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroceryApp()),
                                        );
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Card(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.all(10),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                snapshot.data![index].places ??
                                                    "",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: GroceryAppColors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Divider(
                                        //
                                        //   color: AppColors.black,
                                        // ),
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
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: check ? Colors.green : Colors.grey),
                ),
                onPressed: () {
                  check
                      ? Navigator.of(context).pop()
                      : showLongToast("Please Select city");
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    gatinfo();
    getShopD().then((value) {
      setState(() {
        shopDetails = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            color: GroceryAppColors.tela,
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                height: 68,
                color: GroceryAppColors.tela,
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 11, right: 12),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroceryApp()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: GroceryAppColors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Menu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: GroceryAppColors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            if (GroceryAppConstant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackOrder()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.shopping_bag,
                            color: GroceryAppColors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /* USER PROFILE DRAWER Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 40,left: 20),
                  color: AppColors.tela1,
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child:CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.white,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child:Constant.image==null? Image.asset('assets/images/logo.png',):Constant.image.length==1?Image.asset('assets/images/logo.png',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? Image.asset('assets/images/logo.png',):Image.network(
                          Constant.image,
                          fit: BoxFit.fill,),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child:Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),) ,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20,bottom: 20),
                  child:Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
                ),
            /*    InkWell(
                  onTap: (){
                    _displayDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20,bottom: 20),
                    child:Text(Constant.citname!=null?Constant.citname:" ",
                      overflow:TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black),),
                  ),
                ),*/
              ],
            ),*/
          ),

          /* UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer-header.jpg'),
                )),
            currentAccountPicture:  CircleAvatar(
              radius:30,
              backgroundColor: Colors.black,
              backgroundImage:Constant.image==null? AssetImage('assets/images/logo.jpg',):Constant.image.length==1?AssetImage('assets/images/logo.jpg',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? AssetImage('assets/images/logo.jpg',):NetworkImage(
                  Constant.image),
            ),
            accountName: Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),),
            accountEmail: Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
          ),*/
          Container(
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: GroceryAppColors.tela),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroceryApp()),
                    );
                  },
                ),
                Divider(),
                ExpansionTile(
                  title: Text(
                    'My Account',
                  ),
                  leading: Icon(Icons.person, color: GroceryAppColors.tela),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: GroceryAppColors.tela,
                          ),
                          title: Text("My Profile"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileViewdraw()),
                            );
                          }),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_bag,
                          color: GroceryAppColors.tela,
                        ),
                        title: Text("My Bookings"),
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackOrder()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.add_road,
                          color: GroceryAppColors.tela,
                        ),
                        title: Text("My Addresses"),
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowAddress("1")),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Divider(),
                /*   ListTile(
                  leading: Icon(Icons.list_alt,
                      color: AppColors.tela),
                  title: Text('Shop By Categories'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
                  },
                ), */

                /* ListTile(
                  leading: Icon(Icons.offline_bolt_rounded,
                      color: AppColors.tela),
                  title: Text('Deals of the Day'),
                  trailing: Text('New',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("day","DEALS OF THE DAY")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.stacked_line_chart,
                      color: AppColors.tela),
                  title: Text('Top Products'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("top","TOP PRODUCTS")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.traffic,
                      color: AppColors.tela),
                  title: Text('New Arrival'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ProductList("day",
                              Constant.AProduct_type_Name2)),);
                  },
                ),*/
//                  ListTile(
//                   leading:
//                   Icon(Icons.favorite, color: GroceryAppColors.tela),
//                   title: Text('My Wishlist'),
//                   /* trailing: Container(
//                     padding: const EdgeInsets.all(10.0),
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     child: Text(wcount!=null?wcount.toString():'0',
//                         style: TextStyle(color: Colors.white, fontSize: 15.0)),
//                   ),*/
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => NewWishList())
// //                        NewWishList()),
// //                      Cat_Product
//                     );
//                   },
//                 ),

                /*  ListTile(
                  leading: Icon(Icons.star_border,
                      color: AppColors.tela),
                  title: Text('Rate US',),
                  onTap: () {
                    Navigator.of(context).pop();

                    String os = Platform.operatingSystem; //in your code
                    if (os == 'android') {
                      final InAppReview inAppReview = InAppReview.instance;
                      inAppReview.requestReview();
                    }
                  },
                ),*/
                // ListTile(
                //   leading: Icon(Icons.analytics_rounded,
                //       color: AppColors.tela),
                //   title: Text('Blog'),
                //   trailing: Text('',
                //       style: TextStyle(color: Theme.of(context).primaryColor)),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //
                //     Navigator.push(context, MaterialPageRoute(
                //         builder: (context) => BlogScreen()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.account_balance_wallet_rounded,
                //     color: GroceryAppColors.tela,
                //   ),
                //   title: Text('My Wallet'),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     if (GroceryAppConstant.isLogin) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WalltReport(),
                //         ),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => SignInPage(),
                //         ),
                //       );
                //     }
                //   },
                // ),
                // Divider(),
                // ListTile(
                //   leading: Icon(
                //     Icons.money_sharp,
                //     color: GroceryAppColors.tela,
                //   ),
                //   title: Text('My Earnings'),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     if (GroceryAppConstant.isLogin) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WebViewClass(
                //             "My Earnings",
                //             "${GroceryAppConstant.base_url}Api_earnings.php?username=$mobile&shop_id=${GroceryAppConstant.Shop_id}",
                //           ),
                //         ),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => SignInPage(),
                //         ),
                //       );
                //     }
                //   },
                // ),
                // Divider(),
                ListTile(
                  leading: Icon(Icons.phone, color: GroceryAppColors.tela),
                  title: Text('Contact Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Contact Us",
                                ""
                                    "${GroceryAppConstant.base_url}contact"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading:
                      Icon(Icons.privacy_tip, color: GroceryAppColors.tela),
                  title: Text('Privacy Policy'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Privacy Policy",
                                ""
                                    "${GroceryAppConstant.base_url}pp"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                 Divider(),
                ListTile(
                  leading:
                      Icon(Icons.privacy_tip, color: GroceryAppColors.tela),
                  title: Text('Shipping Policy'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Shipping Policy",
                                ""
                                    "http://www.oho.w4u.in/cr"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info, color: GroceryAppColors.tela),
                  title: Text('About Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "About Us",
                                ""
                                    "${GroceryAppConstant.base_url}about"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.file_copy, color: GroceryAppColors.tela),
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Terms & Conditions",
                                ""
                                    "${GroceryAppConstant.base_url}tc"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                /* ListTile(
                  leading:
                  Icon(Icons.file_copy, color: AppColors.tela),
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("Terms & Conditions","https://www.freshatdoorstep.com/tc"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                /* ListTile(
                  leading:
                  Icon(Icons.question_answer, color: AppColors.tela),
                  title: Text('FAQ'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("FAQ","https://www.freshatdoorstep.com/faq"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                ListTile(
                  leading: Icon(Icons.mobile_screen_share,
                      color: GroceryAppColors.tela),
                  title: Text('Share'),
                  onTap: () {
                    _shairApp();
                  },
                ),
                Divider(),

                GroceryAppConstant.isLogin
                    ? new Container()
                    : ListTile(
                        leading: Icon(Icons.lock, color: GroceryAppColors.tela),
                        title: Text('Login'),
                        onTap: () {
                          Navigator.of(context).pop();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                      ),
                // Divider(),
//              ListTile(
//                leading:
//                    Icon(Icons.settings, color: AppColors.tela),
//                title: Text('Settings'),
//                onTap: () {
//
//                },
//              ),
                /* Constant.isLogin? ListTile(
                  leading: Icon(Icons.exit_to_app,
                      color: AppColors.tela),
                  title: Text('Logout'),
                  onTap: () async {
                    _callLogoutData();
                  },
                ):new Container()*/

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    height: 130,
                    width: 150,
                    decoration: BoxDecoration(
                        //  color: Colors.red,
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/logo.png',
                            ),
                            fit: BoxFit.cover)),
                    // child: Image.asset(
                    //   'assets/images/logo.png',
                    //   //   width: 80,
                    // ),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                shopDetails != null ? socialMedia(context) : Row(),
              ],
            ),
          )
        ],
      ),
    );
  }

  _shairApp() {
    Share.share("Hi, Looking for best deals online? Download " +
        GroceryAppConstant.appname +
        " app form click on this link  https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}");
  }

  Widget rateUs() {
    return InkWell(
        onTap: () {
          String os = Platform.operatingSystem; //in your code
          if (os == 'android') {
            final InAppReview inAppReview = InAppReview.instance;
            inAppReview.openStoreListing(
              appStoreId: "com.chickenista",
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Rate Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GroceryAppConstant.isLogin = false;
    GroceryAppConstant.email = " ";
    GroceryAppConstant.name = " ";
    GroceryAppConstant.image = " ";
    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  _shareAndroidApp() {
    GroceryAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}.\n Don't forget to use my referral code: ${mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}");
  }

  _shareIosApp() {
    GroceryAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: ${GroceryAppConstant.iosAppLink}.\n Don't forget to use my referral code: ${mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link:${GroceryAppConstant.iosAppLink}");
  }

  Widget socialMedia(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              shopDetails!.mobileNo != null || shopDetails!.mobileNo != ''
                  ? naviagteToFacebook('tel:+91${shopDetails!.mobileNo}')
                  : showLongToast('No Mobile Number');
            },
            child: socialMediaIcons('assets/images/phone.png'),
          ),
          InkWell(
            onTap: () {
              shopDetails!.i != null || shopDetails!.i != ''
                  ? naviagteToInstagram(shopDetails!.i)
                  : showLongToast('No Link Available');
            },
            child: socialMediaIcons('assets/images/insta.png'),
          ),
          // InkWell(
          //   onTap: () {
          //     shopDetails!.t != null || shopDetails!.t != ''
          //         ? naviagteToteligram(shopDetails!.t)
          //         : showLongToast('No Link Available');
          //   },
          //   child: socialMediaIcons('assets/images/teligram.png'),
          // ),
          InkWell(
            onTap: () {
              shopDetails!.w != null || shopDetails!.w != ''
                  ? naviagteTotwitter(shopDetails!.w!.startsWith('+')
                      ? 'https://wa.me/${shopDetails!.w}/?text=Hy '
                      : shopDetails!.w!.startsWith('91')
                          ? 'https://wa.me/+${shopDetails!.w}/?text=Hy '
                          : 'https://wa.me/+91${shopDetails!.w}/?text=Hy ')
                  : showLongToast('No number Available');
            },
            child: socialMediaIcons('assets/images/whatsapp.png'),
          ),
          InkWell(
            onTap: () {
              shopDetails!.f != null || shopDetails!.f != ''
                  ? naviagteToYoutube(shopDetails!.f)
                  : showLongToast('No Link Available');
            },
            child: socialMediaIcons('assets/images/facebook.png'),
          ),
        ],
      ),
    );
  }

  Widget socialMediaIcons(String image) {
    return Container(
      height: 30,
      width: 30,
      decoration:
          BoxDecoration(image: DecorationImage(image: AssetImage(image))),
    );
  }

  Future<void> naviagteToFacebook(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteToInstagram(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteTotwitter(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteToteligram(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteToYoutube(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

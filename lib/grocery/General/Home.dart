import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aladdinmart/constent/app_constent.dart';
import 'package:aladdinmart/grocery/BottomNavigation/categories.dart';
import 'package:aladdinmart/grocery/BottomNavigation/profile.dart';
import 'package:aladdinmart/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:aladdinmart/grocery/BottomNavigation/wishlist.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/model/CategaryModal.dart';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/grocery/screen/SearchScreen.dart';
import 'package:aladdinmart/grocery/screen/custom_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'my_app_bar.dart';

class GroceryApp extends StatefulWidget {
  @override
  GroceryAppState createState() => GroceryAppState();
}

class GroceryAppState extends State<GroceryApp> {
  static int countval = 0;
  int cc = 0;
  SharedPreferences? pref;

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

  // final translator =GoogleTranslator();
  void gatinfoCount() async {
    pref = await SharedPreferences.getInstance();

    int? Count = pref!.getInt("itemCount");
    bool? ligin = pref!.getBool("isLogin");
    String? userid = pref!.getString("user_id");
    String? image = pref!.getString("pp");
    String? lval = pref!.getString("language");
    //  int cCount = pref!.getInt("cc");
    setState(() {
      lngval = lval != null ? lval : "en";
      GroceryAppConstant.image = image ?? "";
      print(image);
      print("Constant.image=image");
      GroceryAppConstant.user_id = userid ?? "";
      setState(() {
        // if (cc == 0 || cc < 0) {
        //   cc = 0;
        // } else {
        //   cc = cCount;
        //   //log("cart count------------------->>$cc");
        // }
      });
      if (ligin != null) {
        GroceryAppConstant.isLogin = ligin;
      } else {
        GroceryAppConstant.isLogin = false;
      }
      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
        countval = Count;
      }
//      print(Constant.carditemCount.toString()+"itemCount");
    });
  }

  Position? position;
  getAddress(double lat, double long) async {
    var addresses = await placemarkFromCoordinates(lat!, long!);
    var first = addresses.first;
    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.subThoroughfare.toString() +
          " " +
          first.thoroughfare.toString();
      print('Rahul ${address}');
      pref!.setString("lat", lat.toString());
      pref!.setString("lat", lat.toString());
      pref!.setString("add", address.toString().replaceAll("null", ""));
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

  int count = 0;
  @override
  void initState() {
    //checckCity();
    getcartCount();
    _getCurrentLocation();
    super.initState();
    gatinfoCount();
  }

  String? lngval;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GroceryAppHomeScreen _screen = GroceryAppHomeScreen();
  final Cgategorywise _categories = Cgategorywise("", false);
  //final My_Cat _categories = My_Cat();
  final WishList _cartitem = WishList();
  final ProfileView _profilePage = ProfileView();
  final CustomOrder _customOrder = CustomOrder();
  int _current = 0;
  int _selectedIndex = 0;
  Widget _showPage = GroceryAppHomeScreen();
  Widget _PageChooser(int page) {
    switch (page) {
      case 0:
        _onItemTapped(0);
        return _screen;
        break;
      case 1:
        _onItemTapped(1);
        return _categories;
        break;
      // case 2:
      //   _onItemTapped(2);
      //   return _customOrder;
      //   break;
      case 2:
        _onItemTapped(2);
        return _cartitem;
        break;
      case 3:
        _onItemTapped(3);
        return _profilePage;
        break;
      default:
        return Container(
          child: Center(
            child: Text('No Page is found'),
          ),
        );
    }
  }

  String? appname;
  String? hm, cat, cart, hlp;
  static String? cathome;
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
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.length == null
                              ? 0
                              : snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              splashColor: Colors.blue[500],

                              // hoverColor: Colors.blue[500],
                              onTap: () {
                                setState(() {
                                  check = true;
                                  pref!.setString('city',
                                      snapshot.data![index].places ?? "");
                                  pref!.setString('cityid',
                                      snapshot.data![index].loc_id.toString());
                                  GroceryAppConstant.cityid =
                                      snapshot.data![index].loc_id.toString();
                                  GroceryAppConstant.citname =
                                      snapshot.data![index].places.toString();
                                  pref!.setBool("firstTimeOpen", false);
                                  Navigator.pop(context);

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => GroceryApp()),
                                  // );
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: Text(
                                        snapshot.data![index].places ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: GroceryAppColors.black,
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
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: check ? Colors.green : Colors.grey),
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  check
                      ? Navigator.of(context).pop()
                      : showLongToast("Please Select city");
                },
              )
            ],
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  exitApp() async {
    await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('Please Confirm'),
              content: Text('Do you really want to exit'),
              actions: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () => {
                    exit(0),
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ));
  }

  checckCity() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pref = await SharedPreferences.getInstance();
      if (pref!.getBool("firstTimeOpen") == null ||
          pref!.getBool("firstTimeOpen") == true) {
        _displayDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();

    return WillPopScope(
      onWillPop: () async {
        return exitApp();
        //}
        // we can now close the app.
        //return true;
      },
      child: Scaffold(
        key: _scaffoldKey,

        drawer: Drawer(
          child: AppDrawer(),
        ),
        appBar: AppBar(
          title: Center(
            child: Text(
              GroceryAppConstant.appname,
              overflow: TextOverflow.visible,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),

          // search box commented
          /*Container(
      margin: EdgeInsets.only(top: 10,bottom: 0),

        height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(

                width: MediaQuery.of(context).size.width/1.5-40,
                margin: EdgeInsets.only(top: 10,bottom: 15),
                child: Material(

                  color: Colors.white,
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
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserFilterDemo()),
                      );
                    },

                      child:Padding(padding: EdgeInsets.only(top:5.0),
                        child:
                        TextField(

                          enabled: false,
                          obscureText: false,
                          decoration: InputDecoration(
                              hintText: "Search Product",
                              hintStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.tela,
                              )),


                        ),)),
                ),
              ),

            ],
          ),
        ),*/
          /* Container(
            height: 40,
            margin: EdgeInsets.only(top: 5,bottom: 5),
            child: Center(
              // padding: EdgeInsets.only(top: 3),
              child: Text('${getTranslated(context, 'appname')}',
              // child: Text('${lng_trans("JAI KISAN",lngval)!=null?lng_trans("JAI KISAN",lngval):Constant.appname}',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18,color: Colors.white),),
            )),*/
          elevation: 0.0,
          backgroundColor: GroceryAppColors.tela,
//                backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: GroceryAppColors.white,
            ),
          ),

          actions: <Widget>[
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
                    padding: EdgeInsets.only(top: 20, right: 15),
                    child: Icon(
                      Icons.shopping_cart,
                      color: GroceryAppColors.white,
                      size: 22,
                    ),
                  ),

                  ///-----------------------------------CART NUMBER---------------------------------------------------------
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 15, bottom: 20, top: 0),
                  //     child: Container(
                  //       padding: const EdgeInsets.all(5.0),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: GroceryAppColors.tela1,
                  //       ),
                  //       child: Text('$cc',
                  //           style: TextStyle(
                  //               color: GroceryAppColors.white, fontSize: 15.0)),
                  //     ),
                  //   ),
                  // ),

                  ///-------------------------------------------------------------------------------------------------------
                  // ScreenState.showCircle(),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _displayDialog(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 0, right: 10),
                child: Icon(
                  Icons.location_on,
                  color: GroceryAppColors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
//              MyAppBar(
//                scaffoldKey: _scaffoldKey,
//              ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon:

                  /* Image.asset("assets/images/home.png",
                color: _selectedIndex == 0 ? AppColors.tela : AppColors.homeiconcolor,
                height: 28,width: 28,fit:BoxFit.fill), */

                  Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0
                    ? GroceryAppColors.homeiconcolor
                    : GroceryAppColors.tela,
                size: 25,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category_rounded,
                color: _selectedIndex == 1
                    ? GroceryAppColors.homeiconcolor
                    : GroceryAppColors.tela,
                size: 25,
              ),
              label: 'Categories',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.add,
            //     color: _selectedIndex == 2
            //         ? GroceryAppColors.homeiconcolor
            //         : GroceryAppColors.tela,
            //     size: 25,
            //   ),
            //   title: Text('Upload List', style: TextStyle(fontSize: 12)),
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_sharp,
                color: _selectedIndex == 2
                    ? GroceryAppColors.homeiconcolor
                    : GroceryAppColors.tela,
                size: 25,
              ),
              label: 'My cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.perm_identity,
                color: _selectedIndex == 3
                    ? GroceryAppColors.homeiconcolor
                    : GroceryAppColors.tela,
                size: 25,
              ),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: GroceryAppColors.onselectedBottomicon,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
//          debugPrint("Current Index is $index");
            setState(() {
              _showPage = _PageChooser(index);
            });
          },
        ),

        body: Container(
            color: GroceryAppColors.tela,
//    margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
            child: _showPage),
      ),
    );
  }
}

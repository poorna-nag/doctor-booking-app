import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/grocery/BottomNavigation/categories.dart';
import 'package:ecoshine24/grocery/BottomNavigation/profile.dart';
import 'package:ecoshine24/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:ecoshine24/grocery/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/screen/custom_order.dart';
import 'package:ecoshine24/grocery/screen/myorder.dart';
import 'package:ecoshine24/grocery/widgets/category_selection_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';

class GroceryApp extends StatefulWidget {
  @override
  GroceryAppState createState() => GroceryAppState();
}

class GroceryAppState extends State<GroceryApp> {
  static int countval = 0;
  int cc = 0;
  SharedPreferences? pref;
  String selectedCategoryId = "0"; // Store selected category ID

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
    var addresses = await placemarkFromCoordinates(lat, long);
    var first = addresses.first;
    setState(() {
      var address =
          "${first.subLocality} ${first.subAdministrativeArea} ${first.subThoroughfare} ${first.thoroughfare}";
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
    _showPage = _screen; // Initialize with home screen
    // _checkFirstLaunchAndShowCategoryModal();
  }

  // Check if it's first launch and show category selection modal
  // void _checkFirstLaunchAndShowCategoryModal() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     String? savedCategoryId = pref.getString("selectedCategoryId");
  //     bool? isFirstLaunch = pref.getBool("isFirstCategorySelection");
  //     bool? skipCategorySelection = pref.getBool("skipCategorySelection");

  //     // If user tapped SKIP button, don't show modal
  //     if (skipCategorySelection == true) {
  //       // Clear the skip flag for next time
  //       await pref.setBool("skipCategorySelection", false);
  //       return;
  //     }

  //     if (isFirstLaunch == null ||
  //         isFirstLaunch == true ||
  //         savedCategoryId == null) {
  //       _showCategorySelectionModal();
  //     } else {
  //       setState(() {
  //         selectedCategoryId = savedCategoryId;
  //       });
  //     }
  //   });
  // }

  // // Show category selection modal
  // void _showCategorySelectionModal() async {
  //   try {
  //     await showModalBottomSheet<String>(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (context) => CategorySelectionModal(
  //         onCategorySelected: (String categoryId) async {
  //           SharedPreferences pref = await SharedPreferences.getInstance();
  //           await pref.setString("selectedCategoryId", categoryId);
  //           await pref.setBool("isFirstCategorySelection", false);

  //           // Wait a moment for modal to close properly
  //           await Future.delayed(Duration(milliseconds: 200));

  //           if (mounted) {
  //             setState(() {
  //               selectedCategoryId = categoryId;
  //               // Reset to home tab to show the updated screen
  //               _selectedIndex = 0;
  //             });
  //           }
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     print("Error in category selection: $e");
  //   }
  // }

  String? lngval;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GroceryAppHomeScreen get _screen =>
      GroceryAppHomeScreen(categoryId: selectedCategoryId);
  final Cgategorywise _categories = Cgategorywise("", false);
  //final My_Cat _categories = My_Cat();
  final WishList _cartitem = WishList();
  final ProfileView _profilePage = ProfileView();
  final CustomOrder _customOrder = CustomOrder();
  final TrackOrder _myBookings = TrackOrder();
  int _current = 0;
  int _selectedIndex = 0;
  Widget? _showPage;

  Widget _PageChooser(int page) {
    switch (page) {
      case 0:
        _onItemTapped(0);
        return _screen;
        break;
      case 1:
        _onItemTapped(1);
        return _myBookings;
        break;
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
            title: Text(
              'Select Area',
              style: TextStyle(
                color: Color(0xff1E88E5), // Medical blue
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  style: TextStyle(
                      color: check
                          ? Color(0xff1E88E5) // Medical blue when active
                          : Colors.grey),
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  check
                      ? Navigator.of(context).pop()
                      : showLongToast("Please Select area");
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
              title: Text(
                'Please Confirm',
                style: TextStyle(color: Color(0xff1E88E5)), // Medical blue
              ),
              content: Text('Do you really want to exit'),
              actions: [
                TextButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Color(0xff1E88E5)), // Medical blue
                  ),
                  onPressed: () => {
                    exit(0),
                  },
                ),
                TextButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.grey),
                  ),
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
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: AppDrawer(),
        ),
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "HealthCare Plus",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          elevation: 0.0,
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
            ),
          ),
          leading: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xffF8FBFF), // Medical light background
            boxShadow: [
              BoxShadow(
                color:
                    Color(0xff1E88E5).withOpacity(0.1), // Medical blue shadow
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? Color(0xff1E88E5)
                            .withOpacity(0.1) // Medical blue background
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home_outlined,
                    color: _selectedIndex == 0
                        ? Color(0xff1E88E5) // Medical blue when selected
                        : Colors.grey[600],
                    size: 24,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? Color(0xff1E88E5)
                            .withOpacity(0.1) // Medical blue background
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: _selectedIndex == 1
                        ? Color(0xff1E88E5) // Medical blue when selected
                        : Colors.grey[600],
                    size: 24,
                  ),
                ),
                label: 'Appointments',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2
                        ? Color(0xff1E88E5)
                            .withOpacity(0.1) // Medical blue background
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        color: _selectedIndex == 2
                            ? Color(0xff1E88E5) // Medical blue when selected
                            : Colors.grey[600],
                        size: 24,
                      ),
                      if (cc > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Color(0xff1E88E5), // Medical blue
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$cc',
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
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3
                        ? Color(0xff1E88E5)
                            .withOpacity(0.1) // Medical blue background
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: _selectedIndex == 3
                        ? Color(0xff1E88E5) // Medical blue when selected
                        : Colors.grey[600],
                    size: 24,
                  ),
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xff1E88E5), // Medical blue when selected
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            onTap: (int index) {
              setState(() {
                _showPage = _PageChooser(index);
              });
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff1E88E5), // Medical blue
                Color(0xff42A5F5), // Lighter medical blue
                Color(0xffF8FBFF), // Medical light background
              ],
              stops: [0.0, 0.3, 1.0],
            ),
          ),
          child: _showPage ?? _screen,
        ),
      ),
    );
  }
}

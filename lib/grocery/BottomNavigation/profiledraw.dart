import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aladdinmart/Auth/signin.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/dbhelper/CarrtDbhelper.dart' as food;
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/General/menu_line.dart';
import 'package:aladdinmart/grocery/dbhelper/CarrtDbhelper.dart' as grocery;
import 'package:aladdinmart/grocery/screen/MyReview.dart';
import 'package:aladdinmart/grocery/screen/ShowAddress.dart';
import 'package:aladdinmart/grocery/screen/changePassword.dart';
import 'package:aladdinmart/grocery/screen/editprofile.dart';
import 'package:aladdinmart/grocery/screen/myorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewdraw extends StatefulWidget {
  final Function? changeView;

  const ProfileViewdraw({Key? key, this.changeView}) : super(key: key);

  @override
  _ProfileViewdrawState createState() => _ProfileViewdrawState();
}

class _ProfileViewdrawState extends State<ProfileViewdraw> {
  String name = "";
  String? image;
  String email = "";
  String user_id = "";
  bool isloginv = false;
  final food.DbProductManager dbmanager1 = new food.DbProductManager();
  final grocery.DbProductManager dbmanager2 = new grocery.DbProductManager();
  //final service.DbProductManager dbmanager3 = new service.DbProductManager();

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    isloginv = pref.getBool("isLogin")!;
    name = pref.getString("name")!;
    email = pref.getString("email")!;
    String image = pref.getString("pp")!;
    String userid = pref.getString("user_id")!;
    if (isloginv == null) {
      isloginv = false;
    }

    setState(() {
      user_id = userid;
      GroceryAppConstant.name = name;
      GroceryAppConstant.email = email;
      GroceryAppConstant.isLogin = isloginv;
      GroceryAppConstant.User_ID = userid;
      GroceryAppConstant.image = image;

      // print(Constant.image.length);
      // print(Constant.name.length);
      // print("Constant.name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GroceryAppConstant.isLogin = false;

    gatinfo();
  }

  @override
  Widget build(BuildContext context) {
    print("Constant.check");
    print(GroceryAppConstant.check);
    if (GroceryAppConstant.check) {
      gatinfo();
      setState(() {
        GroceryAppConstant.check = false;
      });
    }
    //
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: FoodAppColors.tela,
      ),
      // backgroundColor: Colors.grey[300],
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 240,
                  color: GroceryAppColors.tela1,
                  child: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 45),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: GroceryAppColors.white,
                          child: ClipOval(
                            child: new SizedBox(
                              width: 120.0,
                              height: 120.0,
                              child: GroceryAppConstant.image == null
                                  ? Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.fill,
                                    )
                                  : GroceryAppConstant.image.length == 1
                                      ? Image.asset('assets/images/logo.png',
                                          fit: BoxFit.cover)
                                      : GroceryAppConstant.image ==
                                              "https://www.bigwelt.com/manage/uploads/customers/nopp.png"
                                          ? Image.asset(
                                              'assets/images/logo.png',
                                            )
                                          : Image.network(
                                              GroceryAppConstant.image,
                                              fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        GroceryAppConstant.name == null
                            ? "Hello Guest"
                            : GroceryAppConstant.name.length == 1
                                ? "Hello Guest"
                                : GroceryAppConstant.name,
                        style: TextStyle(
                          color: GroceryAppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GroceryAppConstant.isLogin
                        ? Text(
                            GroceryAppConstant.email == null
                                ? " "
                                : GroceryAppConstant.email,
                            style: TextStyle(
                                color: GroceryAppColors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            },
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: GroceryAppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                  ]),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrackOrder()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: Icon(
                                Icons.shopping_bag_rounded,
                                color: GroceryAppColors.tela,
                                size: 25.0,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "My Bookings",
                                  style: TextStyle(
                                    color: GroceryAppColors.darkGray,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: GroceryAppColors.tela,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
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
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.location_on,
                              color: GroceryAppColors.tela,
                              size: 25.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                "Service Address",
                                style: TextStyle(
                                  color: GroceryAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: GroceryAppColors.tela,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  //  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyReview()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.star,
                              color: GroceryAppColors.tela,
                              size: 25.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                "My review",
                                style: TextStyle(
                                  color: GroceryAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: GroceryAppColors.tela,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///--------------------update password--------------------------------------------
                Container(
                  // margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (FoodAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.lock,
                              color: FoodAppColors.tela,
                              size: 25.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Update Password ",
                                style: TextStyle(
                                  color: FoodAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: GroceryAppColors.tela,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  // margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage(user_id)),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.edit,
                              color: GroceryAppColors.tela,
                              size: 30.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                "Update profile",
                                style: TextStyle(
                                  color: GroceryAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: GroceryAppColors.tela,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GroceryAppConstant.isLogin
                    ? Container(
                        //margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                        height: 100,
                        child: InkWell(
                          onTap: () {
                            _callLogoutData();
                          },
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 20),
                                  child: Icon(
                                    Icons.logout,
                                    color: GroceryAppColors.tela,
                                    size: 25.0,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: GroceryAppColors.darkGray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: GroceryAppColors.tela,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        // margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                        height: 100,
                        child: InkWell(
                          onTap: () {
                            if (GroceryAppConstant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            }
                          },
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 20),
                                  child: Icon(
                                    Icons.lock,
                                    color: GroceryAppColors.tela,
                                    size: 25.0,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: GroceryAppColors.darkGray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: GroceryAppColors.tela,
                                  size: 15.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
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
    dbmanager1.deleteallProducts();
    dbmanager2.deleteallProducts();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}

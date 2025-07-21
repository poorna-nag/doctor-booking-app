import 'dart:io';

import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/Web/WebviewTermandCondition.dart';
import 'package:aladdinmart/screen/wallecttransation.dart';
import 'package:flutter/material.dart';
import 'package:aladdinmart/Animation/FadeAnimation.dart';
import 'package:aladdinmart/Auth/signin.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/grocery/screen/changePassword.dart';
import 'package:aladdinmart/screen/MyReview.dart';
import 'package:aladdinmart/screen/ShowAddress.dart';
import 'package:aladdinmart/screen/editprofile.dart';
import 'package:aladdinmart/screen/myorder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  final Function? changeView;

  const ProfileView({Key? key, this.changeView}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String name = "";
  String? image;
  String email = "";
  String? mobile;
  String user_id = "";
  bool isloginv = false;
  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    isloginv = pref.getBool("isLogin") ?? false;
    name = pref.getString("name") ?? "";
    email = pref.getString("email") ?? "";
    String image = pref.getString("pp") ?? "";
    String userid = pref.getString("user_id") ?? "";
    mobile = pref.getString("mobile");
    if (isloginv == null) {
      isloginv = false;
    }

    setState(() {
      user_id = userid;
      FoodAppConstant.name = name;
      FoodAppConstant.email = email;
      FoodAppConstant.isLogin = isloginv;
      FoodAppConstant.User_ID = userid;
      FoodAppConstant.image = image;

      // print(FoodAppConstant.image.length);
      // print(FoodAppConstant.name.length);
      // print("FoodAppConstant.name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FoodAppConstant.isLogin = false;

    gatinfo();
  }

  @override
  Widget build(BuildContext context) {
    print("FoodAppConstant.check");
    print(FoodAppConstant.check);
    if (FoodAppConstant.check) {
      gatinfo();
      setState(() {
        FoodAppConstant.check = false;
      });
    }
    //
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 250, 255),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 200,
                            // decoration: BoxDecoration(
                            //   gradient: LinearGradient(
                            //     begin: Alignment.topCenter,
                            //     end: Alignment.bottomCenter,
                            //     colors: <Color>[
                            //       FoodAppColors.tela,
                            //       FoodAppColors.tela1,
                            //     ],
                            //   ),
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          height: 150.0,
                                          // margin: EdgeInsets.only(top: 45),
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundColor:
                                                FoodAppColors.white,
                                            child: ClipOval(
                                              child: new SizedBox(
                                                width: 120.0,
                                                height: 120.0,
                                                child: FoodAppConstant
                                                        .image.isEmpty
                                                    ? Image.asset(
                                                        'assets/images/logo.png',
                                                        fit: BoxFit.fill,
                                                      )
                                                    : FoodAppConstant
                                                                .image.length ==
                                                            1
                                                        ? Image.asset(
                                                            'assets/images/logo.png',
                                                            fit: BoxFit.cover)
                                                        : FoodAppConstant
                                                                    .image ==
                                                                "https://www.bigwelt.com/manage/uploads/customers/nopp.png"
                                                            ? Image.asset(
                                                                'assets/images/logo.png',
                                                              )
                                                            : Image.network(
                                                                FoodAppConstant
                                                                    .image,
                                                                fit: BoxFit
                                                                    .fill),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  FoodAppConstant.name == null
                                                      ? "Hello Guest"
                                                      : FoodAppConstant.name
                                                                  .length ==
                                                              1
                                                          ? "Hello Guest"
                                                          : FoodAppConstant
                                                              .name,
                                                  style: TextStyle(
                                                    color: FoodAppColors
                                                        .blackLight,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              FoodAppConstant.isLogin
                                                  ? Text(
                                                      FoodAppConstant.email ==
                                                              null
                                                          ? " "
                                                          : FoodAppConstant
                                                              .email,
                                                      style: TextStyle(
                                                          color: FoodAppColors
                                                              .blackLight,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SignInPage()),
                                                        );
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          "Login",
                                                          style: TextStyle(
                                                              color: FoodAppColors
                                                                  .blackLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 35),
                                    child: InkWell(
                                      onTap: () {
                                        if (FoodAppConstant.isLogin) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TrackOrder()),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInPage()),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 65,
                                        //width: 55,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // Image.asset(
                                            //   "assets/images/bag.png",
                                            //   height: 50,
                                            //   width: 50,
                                            // ),
                                            Icon(
                                              Icons.shopping_bag_outlined,
                                              color: FoodAppColors.blackLight,
                                              size: 22.0,
                                            ),
                                            Text(
                                              "BOKKINGS",
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 35),
                                    child: InkWell(
                                      onTap: () {
                                        if (GroceryAppConstant.isLogin) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyReview()),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 65,
                                        width: 55,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: FoodAppColors.blackLight,
                                              size: 22.0,
                                            ),
                                            Text(
                                              " REVIEWS",
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 9),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 35),
                                    child: InkWell(
                                      onTap: () {
                                        if (Platform.isAndroid) {
                                          _shareAndroidApp();
                                        } else {
                                          _shareIosApp();
                                        }
                                      },
                                      child: Container(
                                        //  decoration: BoxDecoration(
                                        //     boxShadow: [
                                        //       // BoxShadow(
                                        //       //     color: FoodAppColors.blackLight
                                        //       //         .withOpacity(0.3),
                                        //       //     blurRadius: 5.0,
                                        //       //     offset: Offset(0.0, 3.0)),
                                        //     ],
                                        //     border: Border.all(
                                        //         color:
                                        //             GroceryAppColors.blackLight),
                                        //     color: Colors.white,
                                        //     borderRadius:
                                        //         BorderRadius.circular(
                                        //             10.0)),
                                        height: 65,
                                        width: 55,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // Image.asset(
                                            //     "assets/images/share.png"),
                                            Icon(
                                              Icons.share,
                                              color: FoodAppColors.blackLight,
                                              size: 22.0,
                                            ),
                                            Text(
                                              "SHARE",
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          ///===================caRD 3====================================
                          SizedBox(
                            height: 8,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, bottom: 10, top: 10),
                                    child: Text(
                                      "Account Overview",
                                      style: TextStyle(
                                        color: FoodAppColors.blackLight,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   height: 50,
                                  //   color: Colors.white,
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       if (FoodAppConstant.isLogin) {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   TrackOrder()),
                                  //         );
                                  //       } else {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   SignInPage()),
                                  //         );
                                  //       }
                                  //     },
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(
                                  //           left: 20, right: 20),
                                  //       child: Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment
                                  //                 .spaceBetween,
                                  //         children: [
                                  //           Container(
                                  //             height: 25,
                                  //             width: 25,
                                  //             decoration: BoxDecoration(
                                  //               color: FoodAppColors
                                  //                   .tela
                                  //                   .withOpacity(0.2),
                                  //               borderRadius:
                                  //                   BorderRadius.all(
                                  //                 Radius.circular(15),
                                  //               ),
                                  //             ),
                                  //             child: Icon(
                                  //               Icons
                                  //                   .shopping_bag_outlined,
                                  //               color:
                                  //                   FoodAppColors.tela,
                                  //               size: 25.0,
                                  //             ),
                                  //           ),
                                  //           SizedBox(width: 20),
                                  //           Text(
                                  //             "My Booking",
                                  //             style: TextStyle(
                                  //               color:
                                  //                   FoodAppColors.blackLight,
                                  //               fontSize: 15,
                                  //               fontWeight:
                                  //                   FontWeight.bold,
                                  //             ),
                                  //           ),
                                  //           Spacer(),
                                  //           Icon(
                                  //             Icons
                                  //                 .arrow_forward_ios_rounded,
                                  //             color: FoodAppColors.blackLight,
                                  //             size: 20.0,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  // Container(
                                  //   height: 2,
                                  //   color: Colors.grey.withOpacity(0.2),
                                  // ),

                                  ///------------------------------------------Service Address------------------------------------------------

                                  Container(
                                    height: 50,
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        if (FoodAppConstant.isLogin) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowAddress("1")),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInPage()),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                // color: Colors.blue
                                                //     .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                // color: Colors.blue,
                                                size: 25.0,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              "Service Address",
                                              style: TextStyle(
                                                color: FoodAppColors.blackLight,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: FoodAppColors.blackLight,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),

                                  ///-------------------------------------------------------my review------------------------------------------->>
                                  // Container(
                                  //   height: 50,
                                  //   color: Colors.white,
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       if (FoodAppConstant.isLogin) {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   MyReview()),
                                  //         );
                                  //       } else {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   SignInPage()),
                                  //         );
                                  //       }
                                  //     },
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(
                                  //           left: 20, right: 20),
                                  //       child: Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           Container(
                                  //             height: 25,
                                  //             width: 25,
                                  //             decoration: BoxDecoration(
                                  //               color: Colors.yellow
                                  //                   .withOpacity(0.2),
                                  //               borderRadius: BorderRadius.all(
                                  //                 Radius.circular(15),
                                  //               ),
                                  //             ),
                                  //             child: Icon(
                                  //               Icons.star,
                                  //               color: Colors.yellow,
                                  //               size: 25.0,
                                  //             ),
                                  //           ),
                                  //           SizedBox(width: 20),
                                  //           Text(
                                  //             "My Review",
                                  //             style: TextStyle(
                                  //               color: FoodAppColors.blackLight,
                                  //               fontSize: 15,
                                  //               fontWeight: FontWeight.bold,
                                  //             ),
                                  //           ),
                                  //           Spacer(),
                                  //           Icon(
                                  //             Icons.arrow_forward_ios_rounded,
                                  //             color: FoodAppColors.blackLight,
                                  //             size: 20.0,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Container(
                                  //   height: 2,
                                  //   color: Colors.grey.withOpacity(0.2),
                                  // ),

                                  ///------------------------------------------------update password-------------------------------------->>>
                                  Container(
                                    height: 50,
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        if (FoodAppConstant.isLogin) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangePassword()),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInPage()),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                // color: Colors.orange
                                                //     .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.password_outlined,
                                                // color: Colors.orange,
                                                size: 25.0,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              "Update Password",
                                              style: TextStyle(
                                                color: FoodAppColors.blackLight,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: FoodAppColors.blackLight,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),

                                  /// --------------------------------------------edit profile-------------------------------->>
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color: Colors.pink
                                      //     .withOpacity(0.2),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (FoodAppConstant.isLogin) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfilePage(user_id)),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInPage()),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                // color: Colors.pink
                                                //     .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.edit_outlined,
                                                // color: Colors.pink,
                                                size: 25.0,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              "Update Profile",
                                              style: TextStyle(
                                                color: FoodAppColors.blackLight,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: FoodAppColors.blackLight,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   height: 2,
                                  //   color: Colors.grey.withOpacity(0.2),
                                  // ),

                                  // Container(
                                  //   height: 12,
                                  // )
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 28.0, right: 58),
                                  //   child: Card(
                                  //     child: Row(children: [
                                  //       Container(
                                  //         height: 75,
                                  //         width: 75,
                                  //         child: Image.asset(
                                  //             "assets/images/gift.gif"),
                                  //       ),
                                  //       Text("Refer And Earn")
                                  //     ]),
                                  //   ),
                                  // ),
                                ]),
                          ),

                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 10, top: 8),
                                  child: Text(
                                    "More ",
                                    style: TextStyle(
                                      color: FoodAppColors.blackLight,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ////========================contact us-=======================================
                                Container(
                                  height: 50,
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      if (FoodAppConstant.isLogin) {
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
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              // color: FoodAppColors.tela
                                              //     .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.phone,
                                              color: FoodAppColors.blackLight,
                                              size: 25.0,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            "CONTACT US",
                                            style: TextStyle(
                                              color: FoodAppColors.blackLight,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: FoodAppColors.blackLight,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                ////==========================================Privacy Policy========================
                                Container(
                                  height: 50,
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      if (FoodAppConstant.isLogin) {
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
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              // color: FoodAppColors.tela
                                              //     .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.privacy_tip_sharp,
                                              color: FoodAppColors.blackLight,
                                              size: 25.0,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            "PRIVACY POLICY",
                                            style: TextStyle(
                                              color: FoodAppColors.blackLight,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: FoodAppColors.blackLight,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.grey.withOpacity(0.2),
                                ),

                                ///========================================ABOUT US===========================
                                Container(
                                  height: 50,
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      if (FoodAppConstant.isLogin) {
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
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              // color: FoodAppColors.tela
                                              //     .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.info,
                                              color: FoodAppColors.blackLight,
                                              size: 25.0,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            "ABOUT US",
                                            style: TextStyle(
                                              color: FoodAppColors.blackLight,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: FoodAppColors.blackLight,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.grey.withOpacity(0.2),
                                ),

                                ///==================================TERMS AND CONDITIONS==========================
                                Container(
                                  height: 50,
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      if (FoodAppConstant.isLogin) {
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
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              // color: FoodAppColors.tela
                                              //     .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.library_books,
                                              color: FoodAppColors.blackLight,
                                              size: 25.0,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            "TERMS AND CONDITIONS",
                                            style: TextStyle(
                                              color: FoodAppColors.blackLight,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: FoodAppColors.blackLight,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                // Container(
                                //   height: 12,
                                // ),

                                FoodAppConstant.isLogin
                                    ? Container(
                                        height: 50,
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () {
                                            _callLogoutData();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    // color: Colors.red
                                                    //     .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.logout_outlined,
                                                    color: Colors.red,
                                                    size: 25.0,
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: FoodAppColors
                                                        .blackLight,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color:
                                                      FoodAppColors.blackLight,
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 50,
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () {
                                            if (FoodAppConstant.isLogin) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignInPage()),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignInPage()),
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    // color: Colors.green
                                                    //     .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.login_outlined,
                                                    color: Colors.green,
                                                    size: 25.0,
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Text(
                                                  "Login ",
                                                  style: TextStyle(
                                                    color: FoodAppColors
                                                        .blackLight,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color:
                                                      FoodAppColors.blackLight,
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "🇮🇳 Made with ❤ in India 🇮🇳",
                                      style: TextStyle(
                                        color: FoodAppColors.blackLight,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FoodAppConstant.isLogin = false;
    FoodAppConstant.email = " ";
    FoodAppConstant.name = " ";
    FoodAppConstant.image = " ";

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
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}.\n Don't forget to use my referral code: $mobile")
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
}

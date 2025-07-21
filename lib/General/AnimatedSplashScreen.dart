import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:aladdinmart/Auth/signin.dart';
import 'package:aladdinmart/grocery/General/Home.dart';
import 'package:aladdinmart/model/productmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppConstant.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  static List<Products> filteredUsers = [];
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  var _visible = true;
  String? logincheck;

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? pin = pref.getString("pin");
    String? cityid = pref.getString("cityid");
    bool? val = pref.getBool("isLogin");

    pref.setString("lat", FoodAppConstant.latitude.toString());
    pref.setString("lng", FoodAppConstant.longitude.toString());

    print("cityid.length");
    print(val);

    setState(() {
      cityid == null
          ? FoodAppConstant.cityid = ""
          : FoodAppConstant.cityid = cityid;
      FoodAppConstant.pinid = pin ?? "";
      val == null
          ? FoodAppConstant.isLogin = false
          : FoodAppConstant.isLogin = val;
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),):
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),):
      if (FoodAppConstant.isLogin) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GroceryApp()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false);
      }
    });

    // print(cityname);
  }

  AnimationController? animationController;
  Animation<double>? animation;
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    checkLogin();

    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => GroceryApp(),
    //     ),
    //     (route) => false);
    /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );*/
  }

  Future<void> determinePosition() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      } else {
        throw Exception('Error');
      }
    } catch (e) {}
  }

  @override
  void initState() {
    determinePosition();
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(
        parent: animationController!, curve: Curves.easeOut);
    animation!.addListener(() => this.setState(() {}));
    animationController!.forward();
    setState(() {
      _visible = !_visible;
    });
/*
    _firebaseMessaging.getToken().then((token) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("firebaseToken", token ?? "");
      print("token----->${pref.get("firebaseToken")}");
    });
*/
    // _firebaseMessaging.requestNotificationPermissions();
    // _firebaseMessaging.configure(
    //   onLaunch: (Map<String, dynamic> message) {
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (context) => GroceryApp()),
    //         (route) => false);
    //   },
    //   onResume: (Map<String, dynamic> message) {
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (context) => GroceryApp()),
    //         (route) => false);
    //     // _showNotificationWithSound;
    //     // showLongToast(message["notification"]["title"]);
    //   },
    //   onMessage: (Map<String, dynamic> message) {
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (context) => GroceryApp()),
    //         (route) => false);
    //   },
    // );
    startTime();
//    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodAppColors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/splash.gif"), fit: BoxFit.fill),
        ),
        // child: new Image.asset(
        //   'assets/videos/splash.gif',
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        // ),
      ),

//       Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           new Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
// //              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/powered_by.png',height: 25.0,fit: BoxFit.scaleDown,))
//             ],
//           ),
//           new Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: new Image.asset(
//                   'assets/images/splash.gif',
//                   width: MediaQuery.of(context).size.width - 100,
//                   height: MediaQuery.of(context).size.height - 100,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
    );
  }
}

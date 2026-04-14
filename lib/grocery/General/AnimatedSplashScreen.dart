import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecoshine24/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppConstant.dart';
import 'Home.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  static List<Products> filteredUsers = [];

  var _visible = true;
  String? logincheck;
  void _changelanguage(String language) async {
    //Locale _locale = await setLocale(language);
    //MyApp.setLocale(context, _locale);
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? cityname = pref.getString("city");
    String? cityid = pref.getString("cityid");
    String? lang_cod = pref.getString("language_code");
    _changelanguage(lang_cod != null ? lang_cod : "en");
    print("lang_cod ${lang_cod}");

    setState(() {
      GroceryAppConstant.cityid = cityid != null ? cityid : "";
      print(GroceryAppConstant.cityid);
      // cityid==null? Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCity()),
      // ):Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryApp()),);
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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroceryApp()),
    );
    /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );*/
  }

  @override
  void initState() {
    super.initState();

    DatabaseHelper.getData("0").then((usersFromServe) {
      if (usersFromServe != null) {
        setState(() {
          GroceryAppHomeScreenState.list = usersFromServe;
        });
      }
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        if (usersFromServe1 != null) {
          setState(() {
            GroceryAppHomeScreenState.sliderlist = usersFromServe1;
          });
        }
      }
    });
//
//
//     DatabaseHelper.getTopProduct("top","10").then((usersFromServe){
//       setState(() {
//         ScreenState.topProducts=usersFromServe;
//       });
//     });
//
// //    search
//     DatabaseHelper.getTopProduct1("new","10").then((usersFromServe){
//       setState(() {
//         ScreenState.dilofdayProducts=usersFromServe;
//       });
//     });

    search("").then((usersFromServe) {
      if (usersFromServe != null) {
        setState(() {
          filteredUsers = usersFromServe;
//        print(filteredUsers.length.toString()+" jkjg");
        });
      }
    });
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(
        parent: animationController!, curve: Curves.easeOut);

    animation?.addListener(() => this.setState(() {}));
    animationController?.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
//    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icon/doctor booking logo 1.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                GroceryAppConstant.appname,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF15324B),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Find the right doctor and book an appointment in a few taps.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF67809A),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

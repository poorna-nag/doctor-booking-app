import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aladdinmart/grocery/Auth/signup.dart';
import 'package:aladdinmart/grocery/Auth/widgets/custom_shape.dart';
import 'package:aladdinmart/grocery/Auth/widgets/customappbar.dart';
import 'package:aladdinmart/grocery/Auth/widgets/responsive_ui.dart';
import 'package:aladdinmart/grocery/Auth/widgets/textformfield.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/grocery/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SignInScreen(),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? name;
  String? mobile;
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false;
  bool _medium = false;
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  var swatch = Stopwatch();

  Timer? _timer;
  int _start = 60;
  String timrvalue = "00:00";

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
            timrvalue = "00 : " + '$_start';
          }
        },
      ),
    );
  }

  Future<List<OtpModal>?> _getEmployeeotp() async {
    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['otp'] = otpController.text;
    map['mobile'] = mobile;
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/step2.php'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      if (user.message.toString() == "OTP Verified Successfully.") {
        showLongToast(user.message.toString());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      } else {
        showLongToast(user.message.toString());
      }
    } else
      throw Exception("Unable to get Employee list");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    gatinfo();
  }

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
    mobile = pref.getString("mobile");
  }

//  @override
//  void dispose() {
////    _timer.cancel();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Opacity(opacity: 0.88, child: CustomAppBar()),
              clipShape(),
              welcomeTextRow(),
//              signInTextRow(),
              form(),

              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 30),
                    child: Text(timrvalue),
                  ),
                ],
              ),
//              forgetPassTextRow(),
              SizedBox(height: _height! / 52),
              button(),
//              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.65,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height! / 5
                  : (_medium ? _height! / 5 : _height! / 7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GroceryAppColors.boxColor1,
                    GroceryAppColors.boxColor2
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height! / 4.5
                  : (_medium ? _height! / 4.25 : _height! / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GroceryAppColors.boxColor1,
                    GroceryAppColors.boxColor2
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height! / 20
                  : (_medium ? _height! / 45 : _height! / 40)),
          child: Image.asset(
            'assets/images/logo.png',
            height: 200,
            width: 200,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(
        left: _width! / 20,
      ),
      child: Row(
        children: <Widget>[
          Text(
            "Get OTP Message",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 40),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height! / 40.0),
//            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: otpController,
      icon: Icons.mobile_screen_share,
      hint: "Enter OTP",
    );
  }

/*  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: passwordController,
      icon: Icons.phone_android,
      obscureText: true,
      hint: "MObile Number",
    );
  }*/

/*  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.orange[200]),
            ),
          )
        ],
      ),
    );
  }*/

  Widget button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0.0),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        textStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (otpController.text.length != 5) {
          showLongToast("Please enter the valied OTP");
        } else {
          _getEmployeeotp();
        }
//        Scaffold
//            .of(context)
//            .showSnackBar(SnackBar(content: Text('Login Successful')));
      },
      child: Container(
        alignment: Alignment.center,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              GroceryAppColors.boxColor1,
              GroceryAppColors.boxColor2
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text("VERIFY OTP",
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: GroceryAppColors.boxColor1,
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}

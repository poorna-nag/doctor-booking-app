import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aladdinmart/grocery/Auth/widgets/responsive_ui.dart';
import 'package:aladdinmart/grocery/Auth/widgets/textformfield.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/model/RegisterModel.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../signup.dart';
import 'custom_shape.dart';
import 'customappbar.dart';
import 'otpverify.dart';

class Register extends StatelessWidget {
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
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false;
  bool _medium = false;
  TextEditingController namelController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> _key1 = GlobalKey();
  @override
  void initState() {
//    _employeeList = _getEmployee();
    super.initState();
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['name'] = namelController.text;
    map['mobile'] = phoneController.text;
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/step1.php'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      User user = User.fromJson(jsonDecode(response.body));
      if (user.message.toString() == "OTP Sent Successfully") {
        _showLongToast(user.message.toString());
        pref.setString("name", namelController.text);
        pref.setString("mobile", phoneController.text);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpVerify()),
        );
      } else {
        _showLongToast(user.message.toString());
      }
    } else
      throw Exception("Unable to get Employee list");
  }

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
//              forgetPassTextRow(),
              SizedBox(height: _height! / 52),
              button(),

              // socialIconsRow(),
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
                  : (_medium ? _height! / 45 : _height! / 50)),
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
            "Register Here",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 40 : (_medium ? 40 : 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width! / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Here",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
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
        key: _key1,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height! / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: namelController,
      icon: Icons.person,
      hint: "Name",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: phoneController,
      icon: Icons.phone_android,
      obscureText: true,
      hint: "Mobile No",
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
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
                  fontWeight: FontWeight.w600,
                  color: GroceryAppColors.boxColor1),
            ),
          )
        ],
      ),
    );
  }

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
        if (namelController.text.length < 1) {
          _showLongToast("Enter the name ");
        } else if (phoneController.text.length != 10) {
          _showLongToast("Please enter ten desigt No");
        } else {
          _getEmployee();
        }

//          _getEmployee();
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => OtpVerify()),
//          );

//        Scaffold
//            .of(context)
//            .showSnackBar(SnackBar(content: Text('Login Successful')));
      },
      child: Container(
        alignment: Alignment.center,
        width:
            _large ? _width! / 4 : (_medium ? _width! / 3.75 : _width! / 3.5),
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
        child: Text('SEND OTP',
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
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

  Widget socialIconsRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 80.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/googlelogo.png"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/fblogo.png"),
          ),
          SizedBox(
            width: 20,
          ),
          /* CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/twitterlogo.png"),
          ),*/
        ],
      ),
    );
  }

  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}

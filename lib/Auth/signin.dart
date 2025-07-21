import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/Auth/forgetPassword.dart';
import 'package:aladdinmart/Auth/widgets/CustomeAppBar1.dart';
import 'package:aladdinmart/Auth/widgets/custom_shape.dart';
import 'package:aladdinmart/Auth/widgets/customappbar.dart';
import 'package:aladdinmart/Auth/widgets/responsive_ui.dart';
import 'package:aladdinmart/Auth/widgets/textformfield.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/grocery/General/Home.dart';
import 'package:aladdinmart/model/LoginModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Form6.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: FoodAppColors.tela,
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
  bool _large = false, flag = false;
  bool _medium = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['mobile'] = nameController.text;
    map['password'] = passwordController.text;

    final response = await http
        .post(Uri.parse(FoodAppConstant.base_url + 'api/login.php'), body: map);
    if (response.statusCode == 200) {
      print(response.toString());
      final jsonBody = json.decode(response.body);
      loginModal user = loginModal.fromJson(jsonDecode(response.body));
      print(jsonBody.toString());
      if (user.message.toString() == "Login is Successful") {
        setState(() {
          flag = false;
        });
        _showLongToast(user.message.toString());
        pref.setString("email", user.email.toString());
        pref.setString("name", user.name.toString());
        pref.setString("city", user.city.toString());
        pref.setString("address", user.address.toString());
        pref.setString("sex", user.sex.toString());
        pref.setString("mobile", user.username.toString());
        pref.setString("pin", user.pincode.toString());
        pref.setString("user_id", user.user_id.toString());
        pref.setString("pp", user.pp.toString());
        pref.setBool("isLogin", true);
        print(user.user_id);
        FoodAppConstant.isLogin = true;
        FoodAppConstant.email = user.email.toString();
        FoodAppConstant.name = user.name.toString();
        FoodAppConstant.user_id = user.user_id.toString();
        FoodAppConstant.image = user.pp.toString();
        FoodAppConstant.User_ID = user.username.toString();
        // pref.setString("pp", user.username);

//        pref.setString("mobile",phoneController.text);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GroceryApp()),
            (route) => false);
      } else {
        _showLongToast(user.message.toString());
        setState(() {
          flag = false;
        });
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
              //  Opacity(opacity: 0.88, child: CustomAppBar1()),
              //SizedBox(height: 20),
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgetPassTextRow(),
              SizedBox(height: 20),
              button(),
              signUpButton(),
              //signUpTextRow(),
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
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height! / 3
                  : (_medium ? _height! / 2.75 : _height! / 2.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [FoodAppColors.tela, FoodAppColors.tela1],
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
                  ? _height! / 3.5
                  : (_medium ? _height! / 2.99999 : _height! / 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [FoodAppColors.tela, FoodAppColors.tela1],
                ),
              ),
            ),
          ),
        ),
        Container(
          // color: Colors.grey,
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: _large
                  ? _height! / 35
                  : (_medium ? _height! / 10 : _height! / 20)),
          child: Container(
            width: 230,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/logo.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
            // child: Image.asset(
            //   'assets/images/logo.png',
            //   height: 260,
            //   width: 260,
            //   fit: BoxFit.fill,
            // ),
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width! / 20, top: _height! / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
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
            "Sign in to your account",
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
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height! / 40.0),
            passwordTextFormField(),
            flag ? circularIndi() : Row(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      obscureText: false,
      keyboardType: TextInputType.number,
      textEditingController: nameController,
      icon: Icons.phone_android,
      hint: "Mobile Number",
    );
  }

  // @override
  // void initState() {
  //   _passwordVisible = false;
  // }
  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: passwordController,
      hint: "Password",
      icon: Icons.lock_outline_rounded,
      obscureText: true,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgetPass()),
              );
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: FoodAppColors.tela),
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);

        if (nameController.text.length != 10) {
          _showLongToast("Please enter a valid Mobile Number");
        } else if (passwordController.text.length < 5) {
          _showLongToast("Password should contain at least 5 letter");
        } else {
          setState(() {
            flag = true;
          });
          _getEmployee();
        }

//          print("Routing to your account");
//          Scaffold
//              .of(context)
//              .showSnackBar(SnackBar(content: Text('Login Successful')));
      },
      child: Container(
        alignment: Alignment.center,
        width:
            _large ? _width! / 4 : (_medium ? _width! / 3.75 : _width! / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[FoodAppColors.tela, FoodAppColors.tela1],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(
              fontSize: _large ? 15 : (_medium ? 12 : 10),
              color: Colors.white,
            )),
      ),
    );
  }

  Widget signUpButton() {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Form6()),
        );
      },

//          print("Routing to your account");
//          Scaffold
//              .of(context)
//              .showSnackBar(SnackBar(content: Text('Login Successful')));
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width:
            _large ? _width! / 1 : (_medium ? _width! / 1.75 : _width! / 1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              FoodAppColors.tela,
              FoodAppColors.tela1,
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('REGISTER',
            style: TextStyle(fontSize: _large ? 15 : (_medium ? 12 : 10))),
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Register()),);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Form6()),
              );
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: FoodAppColors.tela1,
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

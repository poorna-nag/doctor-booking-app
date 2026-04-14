import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecoshine24/grocery/Auth/signin.dart';
import 'package:ecoshine24/grocery/Auth/widgets/custom_shape.dart';
import 'package:ecoshine24/grocery/Auth/widgets/customappbar.dart';
import 'package:ecoshine24/grocery/Auth/widgets/responsive_ui.dart';
import 'package:ecoshine24/grocery/Auth/widgets/textformfield.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name;
  String? mobile;
  bool checkBoxValue = false, flag = false;
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false;
  bool _medium = false;
  TextEditingController namelController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController sponsorController = TextEditingController();

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['name'] = namelController.text;
    map['mobile'] =
        mobileController.text; // Mobile from previous step (already verified)
    map['email'] = emailController.text;
    map['address'] = addressController.text;
    map['cities'] = cityController.text;
    map['pincode'] = pincodeController.text;
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/step3.php'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));

      // Check if success is true before proceeding
      if (user.success == "true") {
        setState(() {
          flag = false;
        });
        _showLongToast(user.message.toString());
        pref.setString("email", user.email.toString());
        pref.setString("name", user.name.toString());
        pref.setString("city", user.city.toString());
        pref.setString("address", user.address.toString());
        pref.setString("mobile", user.username.toString());
        pref.setString("user_id", user.userId.toString());
        pref.setString("pp", user.pp.toString());
        pref.setString("pincode", pincodeController.text);

        pref.setBool("isLogin", true);
        GroceryAppConstant.email = user.email.toString();
        GroceryAppConstant.name = user.name.toString();
        GroceryAppConstant.isLogin = true;
        GroceryAppConstant.image = user.pp.toString();
        if (user.pp == null) {
          GroceryAppConstant.image = "";
        } else {
          GroceryAppConstant.image = user.pp.toString();
        }
        GroceryAppConstant.image = user.pp.toString();

//        pref.setString("mobile",phoneController.text);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      } else {
        // Show error message from API
        _showLongToast(user.message.toString());
      }
    } else {
      _showLongToast("Network error. Please try again.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gatinfo();
  }

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
    mobile = pref.getString("mobile");
    String? add = pref.getString("address");
    String? city = pref.getString("city");
    String? pincode = pref.getString("pincode");
    setState(() {
      namelController.text = name ?? "";
      mobileController.text = mobile ?? "";
      addressController.text = add ?? "";
      cityController.text = city ?? "";
      pincodeController.text = pincode ?? "";
    });
  }

  @override
  void dispose() {
    namelController.dispose();
    mobileController.dispose();
    emailController.dispose();
    cityController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);

    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top section with dark green background
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff1E88E5), // Medical blue from grocery home
                        Color(0xff42A5F5), // Lighter medical blue
                        Color(0xff64B5F6), // Even lighter medical blue
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        // Logo and brand section
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person_add,
                                  size: 35,
                                  color: Color(0xff1E88E5), // Medical blue
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Complete Your Profile",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Fill in your details to create your account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom section with form
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        // Form title
                        Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1E88E5), // Medical blue
                          ),
                        ),
                        SizedBox(height: 20),

                        // Form fields
                        form(),
                        SizedBox(height: 20),

                        // Terms and conditions
                        acceptTermsTextRow(),
                        SizedBox(height: 25),

                        // Register button
                        button(),
                        SizedBox(height: 20),

                        // Sign in option
                        signInTextRow(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height! / 8
                  : (_medium ? _height! / 7 : _height! / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1E88E5), // Medical blue from grocery home
                    Color(0xff42A5F5), // Lighter medical blue
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
                  ? _height! / 15
                  : (_medium ? _height! / 15 : _height! / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1E88E5), // Medical blue from grocery home
                    Color(0xff42A5F5), // Lighter medical blue
                  ],
                ),
              ),
            ),
          ),
        ),

        /* Container(
          height: _height! / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: (){
                print('Adding photo');
              },

              child: Icon(Icons.add_a_photo, size: _large? 40: (_medium? 33: 31),color: Colors.orange[200],)),
        ),*/
//        Positioned(
//          top: _height!/8,
//          left: _width/1.75,
//          child: Container(
//            alignment: Alignment.center,
//            height: _height!/23,
//            padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color:  Colors.orange[100],
//            ),
//            child: GestureDetector(
//                onTap: (){
//                  print('Adding photo');
//                },
//                child: Icon(Icons.add_a_photo, size: _large? 22: (_medium? 15: 13),)),
//          ),
//        ),
      ],
    );
  }

  Widget form() {
    return Form(
      child: Column(
        children: <Widget>[
          _buildModernTextField(
            controller: namelController,
            hintText: "Full Name",
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: mobileController,
            hintText: "Mobile Number",
            prefixIcon: Icons.phone_android,
            keyboardType: TextInputType.number,
            enabled: false, // Make field non-editable
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: emailController,
            hintText: "Email Address",
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: addressController,
            hintText: "Complete Address",
            prefixIcon: Icons.location_on_outlined,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: pincodeController,
                  hintText: "Pincode",
                  prefixIcon: Icons.pin_drop_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildModernTextField(
                  controller: cityController,
                  hintText: "City",
                  prefixIcon: Icons.location_city_outlined,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
          if (flag)
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(
                color: Color(0xff1E88E5), // Medical blue
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.grey[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: enabled ? Colors.grey[200]! : Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        style: TextStyle(
          fontSize: 16,
          color: enabled ? Color(0xff1E88E5) : Colors.grey[600], // Medical blue
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color:
                enabled ? Color(0xff1E88E5) : Colors.grey[500], // Medical blue
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: namelController,
      icon: Icons.person,
      hint: "Name",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: cityController,
      icon: Icons.person,
      hint: "City",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "Email Id",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: mobileController,
      icon: Icons.phone,
      hint: "Mobile No",
      enabled: false, // Make field non-editable
    );
  }

  Widget addressTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: addressController,
      obscureText: false,
      icon: Icons.location_on,
      hint: "Address",
    );
  }

  Widget pincodeTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: pincodeController,
      obscureText: false,
      icon: Icons.pin_drop,
      hint: "Pincode",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffE3F2FD), // Light medical blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Color(0xff1E88E5).withOpacity(0.2)), // Medical blue
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            activeColor: Color(0xff1E88E5), // Medical blue
            checkColor: Colors.white,
            value: checkBoxValue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (bool? newValue) {
              setState(() {
                checkBoxValue = newValue!;
              });
            },
          ),
          Expanded(
            child: Text(
              "I accept all terms and conditions",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xff1E88E5), // Medical blue
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff1E88E5), // Medical blue from grocery home
            Color(0xff42A5F5), // Lighter medical blue
            Color(0xff64B5F6), // Even lighter medical blue
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E88E5).withOpacity(0.4), // Medical blue shadow
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: flag
            ? null
            : () {
                if (namelController.text.length < 2) {
                  _showLongToast("Name is Empty !");
                } else if (emailController.text.length < 2) {
                  _showLongToast("Enter the email");
                } else if (cityController.text.isEmpty) {
                  _showLongToast("Enter the city name");
                } else if (addressController.text.isEmpty) {
                  _showLongToast("Please enter address");
                } else if (pincodeController.text.isEmpty) {
                  _showLongToast("Please enter pincode");
                } else if (!checkBoxValue) {
                  _showLongToast("Please accept terms and conditions");
                } else {
                  setState(() {
                    flag = true;
                  });
                  _getEmployee();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: flag
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
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

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1E88E5), // Medical blue
                  fontSize: 19),
            ),
          )
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

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

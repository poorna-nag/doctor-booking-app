import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecoshine24/Auth/Form5.dart';
import 'package:ecoshine24/Auth/signin.dart';
import 'package:ecoshine24/Auth/widgets/custom_shape.dart';
import 'package:ecoshine24/Auth/widgets/customappbar.dart';
import 'package:ecoshine24/Auth/widgets/responsive_ui.dart';
import 'package:ecoshine24/Auth/widgets/textformfield.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:ecoshine24/grocery/Auth/signin.dart';
import 'package:ecoshine24/grocery/General/Home.dart';

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
  TextEditingController ShopnamelController = TextEditingController();
  TextEditingController SHOPADDRESSController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController sponsorController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  String pinval = "";
  String? message;
  bool isLoading = false;
  Future<void> getLocation() async {
    // PermissionStatus permission = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.location);

    // if (permission == PermissionStatus.denied) {
    //   await PermissionHandler()
    //       .requestPermissions([PermissionGroup.locationAlways]);
    // } else if (permission == PermissionStatus.granted) {
    _getCurrentLocation();
    // showToast('Access granted');

    // var geolocator = Geolocator();

    //
    // GeolocationStatus geolocationStatus =
    // await geolocator.checkGeolocationPermissionStatus();
    //
    // switch (geolocationStatus) {
    //   case GeolocationStatus.denied:
    //     showToast('denied');
    //     break;
    //   case GeolocationStatus.disabled:
    //     showToast('disabled');
    //     break;
    //   case GeolocationStatus.restricted:
    //     showToast('restricted');
    //     break;
    //   case GeolocationStatus.unknown:
    //     showToast('unknown');
    //     break;
    //   case GeolocationStatus.granted:
    //     showToast('Access granted');
    //     _getCurrentLocation();
    // }
  }

  Position? position;
  double? lat, long;

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      lat = position!.latitude;
      long = position!.longitude;
      GroceryAppConstant.latitude = lat!;
      GroceryAppConstant.longitude = long!;

      getAddress();
      print(lat);
      print(long);
    });
  }

  String? valArea;
  getAddress() async {
    var addresses = await placemarkFromCoordinates(lat!, long!);
    var first = addresses.first;
    setState(() {
      valArea = first.subLocality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.subThoroughfare.toString() +
          " " +
          first.thoroughfare.toString();
    });
    // print(
    //     ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(GroceryAppConstant.Shop_id);
    print(namelController.text);
    print(mobileController.text);
    print(emailController.text);
    print(passwordController.text);
    print(SHOPADDRESSController.text);
    print(GroceryAppConstant.latitude.toString());
    print(GroceryAppConstant.longitude.toString());
    print(cityController.text);
    print(pincodeController.text);

    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['name'] = namelController.text;
    map['mobile'] =
        mobileController.text; // Mobile from previous step (already verified)
    map['email'] = emailController.text;
    map['address'] = SHOPADDRESSController.text;
    map['lat'] = GroceryAppConstant.latitude.toString();
    map['lng'] = GroceryAppConstant.longitude.toString();
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
          GroceryAppConstant.user_id = user.userId.toString();
        });
        _showLongToast(user.message.toString());
        pref.setString("email", user.email.toString());
        pref.setString("name", user.name.toString());
        pref.setString("city", user.city.toString());
        pref.setString("address", user.address.toString());
        pref.setString("mobile", user.username.toString());
        pref.setString("user_id", user.userId.toString());
        pref.setString("pp", user.pp.toString());
        pref.setString("lat", GroceryAppConstant.latitude.toString());
        pref.setString("lng", GroceryAppConstant.longitude.toString());
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
        //GroceryAppConstant.image = user.pp.toString();

//        pref.setString("mobile",phoneController.text);

        // Clear temporary registration data after successful registration
        pref.remove("temp_mobile");
        pref.remove("temp_name"); // Also clear temporary name

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GroceryApp()),
            (route) => false);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => Uploadimage(user.userId,user.username)),);
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
    getLocation();
  }

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name =
        pref.getString("temp_name"); // Read from temp key for registration flow
    mobile = pref
        .getString("temp_mobile"); // Read from temp key for registration flow
    String? add = pref.getString("address");
    String? lat = pref.getString("lat");
    String? lng = pref.getString("lng");
    String? pin = pref.getString("pincode");
    String? city = pref.getString("city");
    setState(() {
      namelController.text = name ?? "";
      mobileController.text = mobile ?? "";

      add != null
          ? SHOPADDRESSController.text = add
          : SHOPADDRESSController.text = valArea ?? "";
      pinval = pin != null ? pin : "";
      pincodeController.text = pin != null ? pin : "";
      cityController.text = city != null ? city : "";
      if (lat != null && lng != null) {
        GroceryAppConstant.latitude = double.parse(lat);
        GroceryAppConstant.longitude = double.parse(lng);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // _showPasswordDialog();
      print("Hii RAhul");
    }
  }

  @override
  void dispose() {
    namelController.dispose();
    ShopnamelController.dispose();
    SHOPADDRESSController.dispose();
    mobileController.dispose();
    emailController.dispose();
    cityController.dispose();
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
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                // clipShape(),
                /*      Container(
                  margin: EdgeInsets.only(left: 20,right: 20,top: 20),

                  child: new Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child:  TextFormField(
                    controller:ShopnamelController,
                    validator: (String value){
                      if(value.isEmpty){
                        return " Please enter the name";
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Your Name",
                    ),


                  ),
                ),*/

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: new Text(
                    'Enter Address',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                  child: Container(
                      child: new TextFormField(
                          maxLines: 4,
                          // keyboardType: TextInputType.text, // Use mobile input type for emails.
                          controller: SHOPADDRESSController,
                          validator: (String? value) {
                            // print("Length${value.length}");
                            if (value == null ||
                                value.isEmpty && value.length > 10) {
                              return " Please enter the  address";
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                            hintText: 'Address',
                            labelText: 'Enter the  address',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GroceryAppColors.boxColor1,
                                  width: 3.0), // Eco-shine orange
                            ),

//                                      icon: new Icon(Icons.queue_play_next),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GroceryAppColors.boxColor2,
                                  width: 2.0), // Eco-shine blue
                            ),
                          ))),
                ),

                form(),
                // acceptTermsTextRow(),
                // SizedBox(height: _height/35,),
                button(),
                // infoTextRow(),
                // socialIconsRow(),
                signInTextRow(),
              ],
            ),
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
                  ? _height! / 4
                  : (_medium ? _height! / 3.75 : _height! / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [GroceryAppColors.tela, GroceryAppColors.tela],
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
                  colors: [GroceryAppColors.tela, GroceryAppColors.tela],
                ),
              ),
            ),
          ),
        ),
        Container(
          // color: Colors.grey,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height! / 30
                  : (_medium ? _height! / 25 : _height! / 20)),
          child: Image.asset(
            'assets/images/logo.png',
            height: 120,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 80.0),
      child: Form(
        child: Column(
          children: <Widget>[
            lastNameTextFormField(),
            SizedBox(height: _height! / 60.0),
            firstNameTextFormField(),
            SizedBox(height: _height! / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height! / 60.0),
            emailTextFormField(),
            SizedBox(height: _height! / 60.0),
            cityTextFormField(),
            SizedBox(height: _height! / 60.0),
            pincodeTextFormField(),
            SizedBox(height: _height! / 60.0),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: GroceryAppColors.boxColor1, // Eco-shine orange
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      obscureText: false,
      keyboardType: TextInputType.text,
      textEditingController: namelController,
      icon: Icons.person,
      hint: "Name",
    );
  }

  Widget lastNameTextFormField() {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyMap1()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.location_on_outlined,
                  size: 30, color: GroceryAppColors.black),
            ),
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10, left: 3, right: 3, bottom: 5),
                    child: Text(
                      "Use Current Location",
                      style: TextStyle(
                          fontSize: 13,
                          color: GroceryAppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.all(5),
              child:
                  Icon(Icons.forward, size: 30, color: GroceryAppColors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      obscureText: false,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: mobileController,
      obscureText: false,
      icon: Icons.phone,
      hint: "Mobile Number",
      enabled: false, // Make field non-editable
    );
  }

  Widget cityTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: cityController,
      icon: Icons.location_city,
      obscureText: false,
      hint: "City",
    );
  }

  Widget pincodeTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: pincodeController,
      icon: Icons.pin_drop,
      obscureText: false,
      hint: "Pincode",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: GroceryAppColors.boxColor1, // Eco-shine orange
              value: checkBoxValue,
              onChanged: (bool? newValue) {
                setState(() {
                  checkBoxValue = newValue!;
                });
              }),
          Text(
            "I accept all the terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
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
            _showLongToast("Name is Empty !");
          } else if (emailController.text.length < 1) {
            _showLongToast("Enter the email");
          } else if (cityController.text.isEmpty) {
            _showLongToast("Please enter city");
          } else if (pincodeController.text.isEmpty) {
            _showLongToast("Please enter pincode");
          } else {
            setState(() {
              flag = true;
            });
            _getEmployee();
          }
        },
        child: Container(
          alignment: Alignment.center,
//        height: _height / 20,
          width:
              _large ? _width! / 4 : (_medium ? _width! / 3.75 : _width! / 3.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[GroceryAppColors.tela, GroceryAppColors.tela1],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'SIGN UP',
            style: TextStyle(
                fontSize: _large ? 14 : (_medium ? 12 : 10),
                color: Colors.white),
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
            backgroundImage: AssetImage("assets/images/fblogo.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
          /* CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
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
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                  (route) => false);
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: GroceryAppColors.boxColor1, // Eco-shine orange
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

  getRefferalDetails(String username) async {
    try {
      var link =
          "${GroceryAppConstant.base_url}api/username.php?reffer_id=${username}";
      var response = await http.get(Uri.parse(link));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        var responseData = jsonDecode(response.body);
        if (responseData["success"] == "true") {
          setState(() {
            message = responseData["name"];
          });
        } else if (responseData["message"] == "User Not Found...!") {
          setState(() {
            message = "Incorrect Referral Code...";
            sponsorController.clear();
          });
        }
      } else {
        setState(() {
          message = "Something went wrong...";
          sponsorController.clear();
        });
      }
    } catch (e) {}
  }

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(
          color: GroceryAppColors.boxColor1, // Eco-shine orange
        ),
      ),
    );
  }
}

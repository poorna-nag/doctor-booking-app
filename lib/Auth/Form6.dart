import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:aladdinmart/Auth/signup.dart';
import 'package:aladdinmart/Auth/widgets/custom_shape.dart';
import 'package:aladdinmart/Auth/widgets/customappbar.dart';
import 'package:aladdinmart/Auth/widgets/responsive_ui.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/model/RegisterModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Form6 extends StatefulWidget {
  @override
  _Form6State createState() => _Form6State();
}

class _Form6State extends State<Form6> {
  final updatephoneControler = TextEditingController();

  String result = " ";
  void _onCountryChange(CountryCode countryCode) {
//    this.phoneNumber =  countryCode.toString();
    print("New Country selected: " + countryCode.toString());
  }

  String photo = "", currentText = "";
  bool flag = true;
  bool flag1 = false;
  @override
  void dispose() {
    updatephoneControler.dispose();
    // TODO: implement dispose
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
      child: flag
          ? Container(
              height: _height,
              width: _width,
              padding: EdgeInsets.only(bottom: 5),
              color: Colors.white,
              child: new SingleChildScrollView(
                child: Container(
                  // margin:EdgeInsets.only(left: 20,right: 20,top: 40) ,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Opacity(opacity: 0.88, child: CustomAppBar()),
                      clipShape(),
                      getTitle("Enter your Phone number"),
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: CountryCodePicker(
                                onChanged: _onCountryChange,
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'IN',
                                favorite: ['+91', 'IN'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                              ),
                            ),
                          ),
//                        new SizedBox(
//                          width: ScreenUtil().setWidth(20.0),
//                        ),
                          new Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: TextField(
                                  onChanged: (String str) {
                                    setState(() {
                                      print(str);
                                      result = str;
                                    });
                                  },
                                  onSubmitted: (String str) {
                                    setState(() {
                                      print(str);
                                      result = str;
                                    });
                                  },
                                  controller: updatephoneControler,
                                  maxLength: 10,
                                  minLines: 1,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: new InputDecoration(
                                      helperText: 'Phone number'),
                                ),
                              )),
                        ],
                      ),
                      result.length == 10
                          ? InkWell(
                              onTap: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                if (this.mounted) {
                                  setState(() {
//

                                    sharedPreferences.setString(
                                        "mobile", updatephoneControler.text);
                                    // _checkuserName();
                                    _getEmployee();
//                          Navigator.push(context,
//                              new MaterialPageRoute(builder: (context) => Form1()));
                                  });
                                }
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10, top: 10),
                                  padding:
                                      EdgeInsets.only(bottom: 10, right: 10),
                                  decoration: new BoxDecoration(
                                    color: FoodAppColors.tela,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: getTitle1("Continue"),
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10, top: 10),
                                padding: EdgeInsets.only(bottom: 10, right: 10),
                                decoration: new BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: getTitle1("Continue"),
                              ),
                            ),
                    ],
                  ),
                ),
              ))
          : Material(
              child: Container(
                height: _height,
                width: _width!,
                padding: EdgeInsets.only(bottom: 5),
                // margin: EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                  child: Container(
                    // padding: EdgeInsets.all(6),
                    // margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // Opacity(opacity: 0.88, child: CustomAppBar()),
                        clipShape(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                "Enter the code send to",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, top: 18.0, right: 0.0, bottom: 0),
                              child: Text(
                                updatephoneControler.text != null
                                    ? updatephoneControler.text
                                    : " ",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: FoodAppColors.tela1),
                              ),
                            ),
                          ],
                        ),
                        Container(
//                        color: Colors.white,
                          alignment: Alignment.center,
                          width: 260,
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, top: 20),
                          child: PinCodeTextField(
//                isTextObscure: true,
                            // showFieldAsBox: true,
                            length: 5,

                            onChanged: (String pin) {
                              setState(() {
                                currentText = pin;
                                print(currentText);
                              });
                            },
                            appContext: context, // end onSubmit
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                "Didn't receive the code? ",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  flag = true;
                                  result = "1234567890";
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    top: 18.0,
                                    right: 0.0,
                                    bottom: 0),
                                child: Text(
                                  "RESEND",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                        flag1 ? circularIndi() : Row(),
                        Center(
                          child: Container(
                            width: 120,
                            height: 40,
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: FoodAppColors.tela,
                            ),
                            child: InkWell(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),);

                                  currentText.length == 5
                                      ? _getEmployeeotp()
                                      : showLongToast("Please Enter  the otp!");
//                           Navigator.of(context).push(new SecondPageRoute());
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => Form1()));
                                },
                                child: Text(
                                  "VERIFY",
                                  style: TextStyle(
                                      color: FoodAppColors.black,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(updatephoneControler.text);
    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['name'] = " ";
    map['mobile'] = updatephoneControler.text;
    final response = await http
        .post(Uri.parse(FoodAppConstant.base_url + 'api/step1.php'), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody.toString());
      User user = User.fromJson(jsonDecode(response.body));
      if (user.message.toString() == "OTP Sent Successfully") {
        showLongToast(user.message.toString());
        setState(() {
          flag = false;
        });
      } else {
        showLongToast(user.message.toString());
        print(user.message);
      }
    } else
      throw Exception("Unable to get Employee list");
  }

  Future<List<OtpModal>?> _getEmployeeotp() async {
    print(currentText);
    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['otp'] = currentText;
    map['mobile'] = updatephoneControler.text;
    final response = await http
        .post(Uri.parse(FoodAppConstant.base_url + 'api/step2.php'), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);
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

/*
  Future<List<OtpModal>> _getEmployeeotp() async {
setState(() {
  flag1= true;
});
    var map = new Map<String, dynamic>();
    // map['shop_id']=Constant.Shop_id;
    map['otp']=currentText   ;
    map['mobile']= updatephoneControler.text;
    final response = await http.post(Constant.base_url+'api/cpsms.php',body:map);
    if (response.statusCode == 200) {

      final jsonBody = json.decode(response.body);
      print(jsonBody.toString());
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      if(user.message.toString()== "OTP Verified Successfully." )
      {
        setState(() {
          flag1= false;
        });
        showLongToast(user.message);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Form1()));


      }
      else {
        setState(() {
          flag1= false;
        });
        showLongToast(user.message);

      }

    } else
      throw Exception("Unable to get Employee list");
  }
*/

  Widget getTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget getTitle1(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: FoodAppColors.black),
      ),
    );
  }

  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false;
  bool _medium = false;
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
            width: 200,
            height: 150,
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

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

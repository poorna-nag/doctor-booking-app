import 'dart:convert';
import 'dart:io';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/model/AddressModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/newMap.dart';
import '../Auth/signin.dart';
import '../model/RegisterModel.dart';
import 'ShowAddress.dart';

class UpDateAddress extends StatefulWidget {
  final UserAddress address;
  final String valu;
  const UpDateAddress(this.address, this.valu) : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UpDateAddress> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File>? file;
  String status = '';
  String? user_id;
  String url =
      "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

  var _formKeyad = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();
  final profilescaffoldkey = new GlobalKey<ScaffoldState>();

  int selectedRadio = 1;

  setSelectRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (3 == selectedRadio) {
        setState(() {
          _status = true;
          labelController.clear();
        });
      } else if (2 == selectedRadio) {
        setState(() {
          _status = false;
          labelController.text = "Office";
        });
      } else {
        setState(() {
          _status = false;
          labelController.text = "Home";
        });
      }
    });
  }

  Position? position;

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      FoodAppConstant.latitude = position!.latitude;
      FoodAppConstant.longitude = position!.longitude;
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
    setState(() {
      nameController.text = widget.address.fullName ?? "";
      emailController.text = widget.address.email ?? "";
      stateController.text = "Karnataka";
      pincodeController.text = widget.address.pincode ?? "";
      mobileController.text = widget.address.mobile ?? "";
      cityController.text = widget.address.city ?? "";
      address1.text = widget.address.address1 ?? "";
      address2.text = widget.address.address2 ?? "";
      if (widget.address.label == "Home") {
        selectedRadio = 1;
        labelController.text = widget.address.label ?? "";
      } else if (widget.address.label == "Office") {
        selectedRadio = 2;
        labelController.text = widget.address.label ?? "";
      } else {
        _status = true;

        selectedRadio = 3;
        labelController.text = widget.address.label ?? "";
      }
    });
  }

  Widget getLabel() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: labelController,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return " Please enter the label";
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: "Enter Label",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0.0,
          backgroundColor: FoodAppColors.tela,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Update Address",
            style: TextStyle(color: Colors.white),
          )),
      key: profilescaffoldkey,
      body: Form(
        key: _formKeyad,
        child: Container(
          child: new ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            value: 1,
                            groupValue: selectedRadio,
                            title: Text(
                              "Home",
                              style: TextStyle(fontSize: 16),
                            ),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            value: 2,
                            groupValue: selectedRadio,
                            title: Text(
                              "Profile",
                              style: TextStyle(fontSize: 16),
                            ),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            value: 3,
                            groupValue: selectedRadio,
                            title: Text(
                              "Others",
                              style: TextStyle(fontSize: 16),
                            ),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _status
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Label',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(),
                    _status ? getLabel() : Row(),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[],
                        )),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        controller: nameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return " Please enter the name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Enter Your Name",
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Email Id',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: TextFormField(
                        controller: emailController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return " Please enter the email id";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter Email ID"),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Mobile No',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  'State',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  controller: mobileController,
                                  keyboardType: TextInputType.number,
                                  validator: (String? value) {
                                    if (value == null ||
                                        value.isEmpty && value == 10) {
                                      return " Please enter the mobile No";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: "Enter Mobile No"),
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: stateController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return " Please enter the state";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Enter State"),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  'City',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Pin Code',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  controller: cityController,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return " Please enter the city";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: "Enter City"),
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: pincodeController,
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return " Please enter the pincode";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Enter Pincode"),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Address',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          _getEditIcon(),
                        ],
                      ),
                    ),
                    TextFormField(
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      controller: address1,
                      validator: (String? value) {
                        if (value == null ||
                            value.isEmpty && value.length > 10) {
                          return " Please enter the  address";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, top: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Address',
                        labelText: 'Enter the address',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),
                      ),
                    ),
                    _getActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            child: new Text(
              "Update",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              setState(() {
                if (_formKeyad.currentState!.validate()) {
                  _updateEmployee(widget.address.addId ?? "");
                }
                FocusScope.of(context).requestFocus(new FocusNode());
              });
            },
          ),
        ));
  }

  Widget _getEditIcon() {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapClass(
                    textEditingController: address1,
                    cityController: cityController,
                    stateController: stateController,
                    pincodeController: pincodeController,
                  )),
        );
      },
      label: Text(
        'CURRENT LOCATION',
        style: TextStyle(color: Colors.black),
      ),
      icon: RotatedBox(
        quarterTurns: 45,
        child: Icon(
          Icons.navigation_rounded,
          color: FoodAppColors.tela,
          size: 25.0,
        ),
      ),
    );
  }

//

  Future setInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", address1.text);
    // pref.setString("sex", _dropDownValue1);
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    FoodAppConstant.email = emailController.text;
    FoodAppConstant.name = nameController.text;

    if (FoodAppConstant.isLogin) {
//      Navigator.push(context,
//          new MaterialPageRoute(builder: (context) => CheckOutPage()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  SharedPreferences? pref;
  Future _updateEmployee(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userid = pref.getString("user_id");
    print(userid);
    var map = new Map<String, dynamic>();
    map['add_id'] = id;
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['X-Api-Key'] = FoodAppConstant.API_KEY;
    map['user_id'] = userid;
    map['full_name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['label'] = labelController.text;
    map['address1'] = address1.text;
    map['address2'] = address2.text != null ? address2.text : "";
    map['city'] = cityController.text;
    map['state'] = stateController.text;
    map['pincode'] = pincodeController.text;
    map['lat'] = pref.getString("lat") != null ? pref.getString("lat") : "";
    map['lng'] = pref.getString("lng") != null ? pref.getString("lng") : "";
    String link =
        FoodAppConstant.base_url + "manage/api/user_address/update";
    print(link);
    final response = await http.post(Uri.parse(link), body: map);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);

      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

      showLongToast(user.message.toString());
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),
      );
//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
    } else
      throw Exception("Unable to get Employee list");
  }
}

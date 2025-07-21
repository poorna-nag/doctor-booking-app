import 'dart:convert';
import 'dart:io';
import 'package:aladdinmart/grocery/Auth/newMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ShowAddress.dart';

class AddAddress extends StatefulWidget {
  final String valu;
  const AddAddress(this.valu) : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AddAddress> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File>? file;
  String status = '';
  String? user_id;

  var _formKeyad = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = GlobalKey<ScaffoldState>();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();

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

  SharedPreferences? pre;
  Future<void> getUserInfo() async {
    pre = await SharedPreferences.getInstance();
    String? name = pre!.getString("name");
    String? email = pre!.getString("email");
    String? mobile = pre!.getString("mobile");
    String? pin = pre!.getString("pin");
    String? city = pre!.getString("city");
    String? address = pre!.getString("address");
    String? image = pre!.getString("pp");
    user_id = pre!.getString("user_id");
    print(user_id);

    this.setState(() {
      nameController.text = name ?? "";
      emailController.text = email ?? "";
      stateController.text = 'Karnatka';
      pincodeController.text = pin ?? "";
      mobileController.text = mobile ?? "";
      cityController.text = city ?? "";
      address1.text = address ?? "";

      print("Constant.image");
      print(GroceryAppConstant.image);
      print(GroceryAppConstant.image.length);
    });
  }

  Position? position;

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      GroceryAppConstant.latitude = position!.latitude;
      GroceryAppConstant.longitude = position!.longitude;
    });
  }

  @override
  void initState() {
    getUserInfo();
    _getCurrentLocation();
    super.initState();
    if (selectedRadio == 1) {
      setState(() {
        labelController.text = "Home";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: GroceryAppColors.tela,
          iconTheme: IconThemeData(
            color: Colors.white, // <-- SEE HERE
          ),
          title: Text(
            "Add Address",
            style: TextStyle(color: Colors.white),
          )),
      key: profilescaffoldkey,
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Form(
                    key: _formKeyad,
                    child: Padding(
                      padding: EdgeInsets.all(20),
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
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onChanged: (val) {
                                    print("Radio $val");
                                    setSelectRadio(val!);
                                  },
                                  activeColor: Colors.red,
                                     dense: true, // Makes the RadioListTile more compact
        visualDensity: VisualDensity(horizontal: -4, vertical: -4), 
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  value: 2,
                                  groupValue: selectedRadio,
                                  title: Text(
                                    "Profile",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onChanged: (val) {
                                    print("Radio $val");
                                    setSelectRadio(val!);
                                  },
                                  activeColor: Colors.red,
                                     dense: true, // Makes the RadioListTile more compact
        visualDensity: VisualDensity(horizontal: -4, vertical: -4), 
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  value: 3,
                                  groupValue: selectedRadio,
                                  title: Text(
                                    "Others",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onChanged: (val) {
                                    print("Radio $val");
                                    setSelectRadio(val!);
                                  },
                                  activeColor: Colors.red,
                                  dense:
                                      true, // Makes the RadioListTile more compact
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
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
                            padding: EdgeInsets.only(top: 10.0),
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
                              padding: EdgeInsets.only(top: 10.0),
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
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                _getEditIcon(),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
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
                            child: TextFormField(
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
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Address',
                                labelText: 'Enter the address',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black54, width: 3.0),
                                ),
                              ),
                            ),
                          ),
                          _getActionButtons(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
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
          child: Text(
            "Save",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              if (_formKeyad.currentState!.validate()) {
                if (pincodeController.text.length == 6) {
                  _AddAddress();
                } else {
                  showLongToast("Enter the valide pin");
                }
              }
            });
          },
        ),
      ),
    );
  }

//

/*  Future setInfo() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", address1.text);
    pref.setString("sex", _dropDownValue1);
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    Constant.email=emailController.text;
    Constant.name=nameController.text;

    if(Constant.isLogin){
      Navigator.push(context,
           MaterialPageRoute(builder: (context) => CheckOutPage()));


    }
    else{
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInPage()),);
    }

  }*/

  Future _AddAddress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userid = pref.getString("user_id");
    
    // Validate required fields
    if (user_id == null || user_id!.isEmpty) {
      showLongToast("User not logged in. Please login again.");
      return;
    }
    
    if (nameController.text.isEmpty || 
        mobileController.text.isEmpty || 
        emailController.text.isEmpty || 
        address1.text.isEmpty || 
        cityController.text.isEmpty || 
        stateController.text.isEmpty || 
        pincodeController.text.isEmpty) {
      showLongToast("Please fill all required fields");
      return;
    }
    
    print('Shop ID: ${GroceryAppConstant.Shop_id}');
    print('API Key: ${GroceryAppConstant.API_KEY}');
    print('User ID: $userid');
    print('Name: ${nameController.text}');
    print('Mobile: ${mobileController.text}');
    print('Email: ${emailController.text}');
    print('Address1: ${address1.text}');
    print('Address2: ${address2.text}');
    print('City: ${cityController.text}');
    print('State: ${stateController.text}');
    print('Pincode: ${pincodeController.text}');
    print('Label: ${labelController.text}');
    var map = Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['X-Api-Key'] = GroceryAppConstant.API_KEY;
    map['user_id'] = user_id;
    map['full_name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['address1'] = address1.text;
    map['address2'] = address2.text != null ? address2.text : "";
    map['city'] = cityController.text;
    map['state'] = stateController.text;
    map['pincode'] = pincodeController.text;
    map['label'] = labelController.text;
    // map['lat'] = pre!.getString("lat") != null
    //     ? pre!.getString("lat")!.length > 10
    //         ? pre!.getString("lat")?.substring(0, 10)
    //         : pre!.getString("lat")
    //     : GroceryAppConstant.latitude.toStringAsFixed(10);
    // map['lng'] = pre!.getString("lng") != null
    //     ? pre!.getString("lng")!.length > 10
    //         ? pre!.getString("lng")?.substring(0, 10)
    //         : pre!.getString("lng")

    // Validate latitude and longitude
    if (GroceryAppConstant.latitude == 0.0 || GroceryAppConstant.longitude == 0.0) {
      showLongToast("Please enable location and try again");
      return;
    }

    map['lat'] = GroceryAppConstant.latitude.toString().length > 10
        ? GroceryAppConstant.latitude.toString().substring(0, 9)
        : GroceryAppConstant.latitude.toStringAsFixed(7);
    map['lng'] = GroceryAppConstant.longitude.toString().length > 10
        ? GroceryAppConstant.longitude.toString().substring(0, 9)
        : GroceryAppConstant.longitude.toStringAsFixed(7);
    String link = GroceryAppConstant.base_url + "manage/api/user_address/add";
    print(link);
    print(GroceryAppConstant.longitude.toString());
    print(GroceryAppConstant.latitude.toString());

    try {
      final response = await http.post(Uri.parse(link), body: map);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        OtpModal user = OtpModal.fromJson(jsonBody);

        showLongToast(user.message.toString());
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),
        );
      } else {
        // Handle different error status codes
        String errorMessage = "Failed to add address";
        try {
          final errorBody = json.decode(response.body);
          if (errorBody['message'] != null) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          errorMessage = "Server error: ${response.statusCode}";
        }
        showLongToast(errorMessage);
        print('Error: $errorMessage');
      }
    } catch (e) {
      print('Exception in _AddAddress: $e');
      showLongToast("Network error: Please check your connection and try again");
    }
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
          color: GroceryAppColors.tela,
          size: 25.0,
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:ecoshine24/grocery/Auth/newMap.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/RegisterModel.dart';
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff1E88E5), // Medical blue
                Color(0xff42A5F5), // Lighter medical blue
                Color(0xff64B5F6), // Lightest medical blue
              ],
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Add Medical Address",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ),
      key: profilescaffoldkey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffF8FBFF), // Medical light background
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKeyad,
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // Address Type Selection
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff1E88E5)
                                      .withOpacity(0.05), // Medical blue
                                  Color(0xff42A5F5).withOpacity(
                                      0.03), // Lighter medical blue
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xff1E88E5)
                                    .withOpacity(0.2), // Medical blue border
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Medical Address Type',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1E88E5), // Medical blue
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile(
                                        contentPadding: EdgeInsets.zero,
                                        value: 1,
                                        groupValue: selectedRadio,
                                        title: Text(
                                          "Home",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        onChanged: (val) {
                                          print("Radio $val");
                                          setSelectRadio(val!);
                                        },
                                        activeColor:
                                            Color(0xff1E88E5), // Medical blue
                                        dense: true,
                                        visualDensity: VisualDensity(
                                            horizontal: -4, vertical: -4),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        contentPadding: EdgeInsets.zero,
                                        value: 2,
                                        groupValue: selectedRadio,
                                        title: Text(
                                          "Office",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        onChanged: (val) {
                                          print("Radio $val");
                                          setSelectRadio(val!);
                                        },
                                        activeColor:
                                            Color(0xff1E88E5), // Medical blue
                                        dense: true,
                                        visualDensity: VisualDensity(
                                            horizontal: -4, vertical: -4),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        contentPadding: EdgeInsets.zero,
                                        value: 3,
                                        groupValue: selectedRadio,
                                        title: Text(
                                          "Others",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        onChanged: (val) {
                                          print("Radio $val");
                                          setSelectRadio(val!);
                                        },
                                        activeColor:
                                            Color(0xff1E88E5), // Medical blue
                                        dense: true,
                                        visualDensity: VisualDensity(
                                            horizontal: -4, vertical: -4),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          _status
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Label',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color(0xff1E88E5), // Medical blue
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    getLabel(),
                                    SizedBox(height: 20),
                                  ],
                                )
                              : SizedBox.shrink(),

                          // Name Field
                          _buildModernTextField(
                            label: 'Name',
                            controller: nameController,
                            hintText: "Enter Your Name",
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the name";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Email Field
                          _buildModernTextField(
                            label: 'Email Id',
                            controller: emailController,
                            hintText: "Enter Email ID",
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the email id";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Mobile and State Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildModernTextField(
                                  label: 'Mobile No',
                                  controller: mobileController,
                                  hintText: "Enter Mobile No",
                                  keyboardType: TextInputType.number,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildModernTextField(
                                  label: 'State',
                                  controller: stateController,
                                  hintText: "Enter State",
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // City and Pincode Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildModernTextField(
                                  label: 'City',
                                  controller: cityController,
                                  hintText: "Enter City",
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildModernTextField(
                                  label: 'Pin Code',
                                  controller: pincodeController,
                                  hintText: "Enter Pincode",
                                  keyboardType: TextInputType.number,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Address Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Medical Facility Address',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1E88E5), // Medical blue
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              _getEditIcon(),
                            ],
                          ),
                          SizedBox(height: 8),
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
                                  return "Please enter the address";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xff1E88E5)
                                        .withOpacity(0.3), // Medical blue
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xff1E88E5)
                                        .withOpacity(0.3), // Medical blue
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xff1E88E5), // Medical blue
                                    width: 2,
                                  ),
                                ),
                                hintText: 'Enter the medical facility address',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: Color(0xff1E88E5)
                                    .withOpacity(0.02), // Medical blue tint
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
      padding: const EdgeInsets.only(top: 32.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1E88E5), // Medical blue
              Color(0xff42A5F5), // Lighter medical blue
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E88E5).withOpacity(0.3), // Medical blue shadow
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Save Medical Address",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          onPressed: () {
            setState(() {
              if (_formKeyad.currentState!.validate()) {
                if (pincodeController.text.length == 6) {
                  _AddAddress();
                } else {
                  showLongToast("Enter the valid pin");
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
    map['address2'] = address2.text.isNotEmpty ? address2.text : "";
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
    if (GroceryAppConstant.latitude == 0.0 ||
        GroceryAppConstant.longitude == 0.0) {
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
      showLongToast(
          "Network error: Please check your connection and try again");
    }
  }

  Widget getLabel() {
    return TextFormField(
      controller: labelController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter the label";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xff1E88E5).withOpacity(0.3), // Medical blue
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xff1E88E5).withOpacity(0.3), // Medical blue
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xff1E88E5), // Medical blue
            width: 2,
          ),
        ),
        hintText: "Enter Label",
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Color(0xff1E88E5).withOpacity(0.02), // Medical blue tint
      ),
    );
  }

  Widget _getEditIcon() {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1E88E5).withOpacity(0.1), // Medical blue
              Color(0xff42A5F5).withOpacity(0.05) // Lighter medical blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xff1E88E5).withOpacity(0.3), // Medical blue border
            width: 1,
          ),
        ),
        child: TextButton.icon(
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
            'LOCATION',
            style: TextStyle(
              color: Color(0xff1E88E5), // Medical blue
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
          icon: RotatedBox(
            quarterTurns: 45,
            child: Icon(
              Icons.navigation_rounded,
              color: Color(0xff1E88E5), // Medical blue
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build modern text fields
  Widget _buildModernTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color(0xff1E88E5), // Medical blue
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFF1B5E20).withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFF1B5E20).withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFF1B5E20),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Color(0xFF1B5E20).withOpacity(0.02),
          ),
        ),
      ],
    );
  }
}

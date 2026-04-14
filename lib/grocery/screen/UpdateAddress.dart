import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:ecoshine24/grocery/Auth/newMap.dart';
import 'package:ecoshine24/grocery/Auth/signin.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/AddressModel.dart';
import 'package:ecoshine24/grocery/model/RegisterModel.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
      GroceryAppConstant.latitude = position!.latitude;
      GroceryAppConstant.longitude = position!.longitude;
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
      GroceryAppConstant.latitude = double.parse(widget.address.lat.toString());
      GroceryAppConstant.longitude =
          double.parse(widget.address.lng.toString());

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff1E88E5), // Medical blue
            Color(0xff42A5F5), // Lighter medical blue
            Color(0xffF8FBFF), // Medical light background
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1E88E5),
                  Color(0xff42A5F5),
                  Color(0xff64B5F6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1E88E5).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              title: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit_location_alt_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "HealthCare Plus",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Update Medical Address",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        key: profilescaffoldkey,
        body: SafeArea(
          child: Form(
            key: _formKeyad,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffF8FBFF),
                    Colors.white,
                  ],
                ),
              ),
              child: new ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  // Header Card
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1E88E5).withOpacity(0.1),
                          Color(0xff42A5F5).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xff1E88E5).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff1E88E5), Color(0xff42A5F5)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update Medical Address',
                                style: TextStyle(
                                  color: Color(0xff1E88E5),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Modify your saved medical facility address',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Address Type Selection Card
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff1E88E5).withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xff1E88E5).withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff1E88E5),
                                    Color(0xff42A5F5)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.label_important_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Address Type',
                              style: TextStyle(
                                color: Color(0xff1E88E5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setSelectRadio(1);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: selectedRadio == 1
                                        ? Color(0xff1E88E5).withOpacity(0.1)
                                        : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedRadio == 1
                                          ? Color(0xff1E88E5)
                                          : Colors.grey[300]!,
                                      width: selectedRadio == 1 ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: selectedRadio == 1
                                                ? Color(0xff1E88E5)
                                                : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                          color: selectedRadio == 1
                                              ? Color(0xff1E88E5)
                                              : Colors.transparent,
                                        ),
                                        child: selectedRadio == 1
                                            ? Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          "Home",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: selectedRadio == 1
                                                ? Color(0xff1E88E5)
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setSelectRadio(2);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: selectedRadio == 2
                                        ? Color(0xff1E88E5).withOpacity(0.1)
                                        : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedRadio == 2
                                          ? Color(0xff1E88E5)
                                          : Colors.grey[300]!,
                                      width: selectedRadio == 2 ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: selectedRadio == 2
                                                ? Color(0xff1E88E5)
                                                : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                          color: selectedRadio == 2
                                              ? Color(0xff1E88E5)
                                              : Colors.transparent,
                                        ),
                                        child: selectedRadio == 2
                                            ? Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          "Clinic",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: selectedRadio == 2
                                                ? Color(0xff1E88E5)
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setSelectRadio(3);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: selectedRadio == 3
                                        ? Color(0xff1E88E5).withOpacity(0.1)
                                        : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedRadio == 3
                                          ? Color(0xff1E88E5)
                                          : Colors.grey[300]!,
                                      width: selectedRadio == 3 ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: selectedRadio == 3
                                                ? Color(0xff1E88E5)
                                                : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                          color: selectedRadio == 3
                                              ? Color(0xff1E88E5)
                                              : Colors.transparent,
                                        ),
                                        child: selectedRadio == 3
                                            ? Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          "Others",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: selectedRadio == 3
                                                ? Color(0xff1E88E5)
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Custom Label Input (if Others is selected)
                  _status
                      ? Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff1E88E5).withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Color(0xff1E88E5).withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff1E88E5),
                                          Color(0xff42A5F5)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Custom Label',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1E88E5),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: labelController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return " Please enter the label";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color:
                                            Color(0xff1E88E5).withOpacity(0.3)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Color(0xff1E88E5), width: 2),
                                  ),
                                  hintText: "Enter Custom Label",
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  prefixIcon: Icon(Icons.label_outline,
                                      color: Color(0xff1E88E5)),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),

                  // Personal Information Card
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff1E88E5).withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xff1E88E5).withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff1E88E5),
                                    Color(0xff42A5F5)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1E88E5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Name Field
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return " Please enter the name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Color(0xff1E88E5), width: 2),
                            ),
                            hintText: "Enter Your Name",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(Icons.person_outline,
                                color: Color(0xff1E88E5)),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Email Field
                        Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: emailController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return " Please enter the email id";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Color(0xff1E88E5), width: 2),
                            ),
                            hintText: "Enter Email ID",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Color(0xff1E88E5)),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Mobile and State Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mobile Number',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
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
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xff1E88E5), width: 2),
                                      ),
                                      hintText: "Mobile No",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      prefixIcon: Icon(Icons.phone_outlined,
                                          color: Color(0xff1E88E5)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'State',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: stateController,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return " Please enter the state";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xff1E88E5), width: 2),
                                      ),
                                      hintText: "State",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      prefixIcon: Icon(
                                          Icons.location_city_outlined,
                                          color: Color(0xff1E88E5)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // City and Pincode Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'City',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: cityController,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return " Please enter the city";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xff1E88E5), width: 2),
                                      ),
                                      hintText: "City",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      prefixIcon: Icon(Icons.location_city,
                                          color: Color(0xff1E88E5)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pin Code',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: pincodeController,
                                    keyboardType: TextInputType.number,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return " Please enter the pincode";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xff1E88E5), width: 2),
                                      ),
                                      hintText: "Pincode",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      prefixIcon: Icon(Icons.pin_drop_outlined,
                                          color: Color(0xff1E88E5)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Address Information Card
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff1E88E5).withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xff1E88E5).withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff1E88E5),
                                        Color(0xff42A5F5)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Medical Address',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1E88E5),
                                  ),
                                ),
                              ],
                            ),
                            _getEditIcon(),
                          ],
                        ),
                        SizedBox(height: 16),
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
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff1E88E5), width: 2),
                              ),
                              hintText:
                                  'Enter complete medical facility address',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              labelText: 'Medical Facility Address',
                              labelStyle: TextStyle(color: Color(0xff1E88E5)),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                    top: 12, left: 12, right: 8),
                                child: Icon(Icons.local_hospital_outlined,
                                    color: Color(0xff1E88E5)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _getActionButtons(),
                ],
              ),
            ),
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E88E5).withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Color(0xff1E88E5).withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Update Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1E88E5), Color(0xff42A5F5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1E88E5).withOpacity(0.3),
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
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: () {
                setState(() {
                  if (_formKeyad.currentState!.validate()) {
                    _updateEmployee(widget.address.addId ?? "");
                  }
                  FocusScope.of(context).requestFocus(new FocusNode());
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.system_update_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Update Medical Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12),

          // Cancel/Back Button
          Container(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xff1E88E5), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xff1E88E5),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xff1E88E5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1E88E5), Color(0xff42A5F5)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E88E5).withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
        icon: Icon(
          Icons.edit_location_alt_rounded,
          color: Colors.white,
          size: 18,
        ),
        label: Text(
          'Edit Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
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
    GroceryAppConstant.email = emailController.text;
    GroceryAppConstant.name = nameController.text;

    if (GroceryAppConstant.isLogin) {
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
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['X-Api-Key'] = GroceryAppConstant.API_KEY;
    map['user_id'] = userid;
    map['full_name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['label'] = labelController.text;
    map['address1'] = address1.text;
    map['address2'] = address2.text;
    map['city'] = cityController.text;
    map['state'] = stateController.text;
    map['pincode'] = pincodeController.text;
    // map['lat'] = pref.getString("lat") != null ? pref.getString("lat") : "";
    // map['lng'] = pref.getString("lng") != null ? pref.getString("lng") : "";
    map['lat'] = GroceryAppConstant.latitude.toString().length > 10
        ? GroceryAppConstant.latitude.toString().substring(0, 9)
        : GroceryAppConstant.latitude.toStringAsFixed(7);
    map['lng'] = GroceryAppConstant.longitude.toString().length > 10
        ? GroceryAppConstant.longitude.toString().substring(0, 9)
        : GroceryAppConstant.longitude.toStringAsFixed(7);
    String link =
        GroceryAppConstant.base_url + "manage/api/user_address/update";
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

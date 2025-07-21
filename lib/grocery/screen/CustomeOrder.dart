import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ShowAddress.dart';

class CustomeOrder extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CustomeOrder> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File>? file;
  String status = '';
  String? base64Image, imagevalue;
  File? _image, imageshow1;
  String errMessage = 'Error Uploading Image';
  String? user_id;
  String url =
      "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

  var _formKeyad = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = new GlobalKey<ScaffoldState>();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();
  String? _dropDownValue1;
  Future<File>? profileImg;

  int selectedRadio = 1;

  setSelectRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (3 == selectedRadio) {
        setState(() {
          _status = true;
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

  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? name = pre.getString("name");
    String? email = pre.getString("email");
    String? mobile = pre.getString("mobile");
    String? pin = pre.getString("pin");
    String? city = pre.getString("city");
    String? address = pre.getString("address");
    String? image = pre.getString("pp");
    user_id = pre.getString("user_id");
    print(user_id);

    this.setState(() {
      nameController.text = name ?? "";
      emailController.text = email ?? "";
      stateController.text = 'Karnatka';
      pincodeController.text = pin ?? "";
      mobileController.text = mobile ?? "";
      cityController.text = city ?? "";
      // address1.text= address;
    });
  }

  @override
  void initState() {
    getUserInfo();
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
        title: Container(
            height: 40,
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: Center(
              // padding: EdgeInsets.only(top: 3),
              child: Text(
                "${GroceryAppConstant.appname}",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )),
      ),
      key: profilescaffoldkey,
      body: Container(
        decoration: BoxDecoration(),
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  child: Form(
                    key: _formKeyad,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Contact Us:',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return " Please enter the name";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
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
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      controller: emailController,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return " Please enter the email id";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                    ),
                                  ),
                                ],
                              )),
                          /*Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextFormField(
                                      controller:mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the mobile No";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),*/
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Mobile No',
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
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: TextFormField(
                                        controller: mobileController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          // WhitelistingTextInputFormatter
                                          //     .digitsOnly,
                                          new LengthLimitingTextInputFormatter(
                                              10),
                                        ],
                                        validator: (String? value) {
                                          if (value == null ||
                                              value.isEmpty && value == 10) {
                                            return " Please enter the mobile No";
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Mobile No"),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Please Write Your Orders',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                              child: TextField(
                                  maxLines: 10,
                                  minLines: 4,
                                  controller: address1,
                                  decoration: InputDecoration(
                                      hintText: 'Orders',
                                      labelText: 'Enter the Orders',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ))),
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
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    backgroundColor: GroceryAppColors.tela,
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  child: new Text("Submit"),
                  onPressed: () {
                    setState(() {
                      if (_formKeyad.currentState!.validate()) {
                        _AddAddress();

//                              setInfo();
                      }

//                        _status = true;
//                          FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                ),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: GroceryAppColors.pink,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
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
          new MaterialPageRoute(builder: (context) => CheckOutPage()));


    }
    else{
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInPage()),);
    }

  }*/

  Future _AddAddress() async {
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    print(GroceryAppConstant.Shop_id);
    print(GroceryAppConstant.API_KEY);
    // print(Constant.user_id);
    print(nameController.text);
    print(mobileController.text);
    print(emailController.text);
    print(address1.text);
    print(formatted);

    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['X-Api-Key'] = GroceryAppConstant.API_KEY;
    map['user_ip'] = " ";
    map['name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['massage'] = address1.text;
    map['appointment_dates'] = formatted.toString();
    map['appointment_times'] = "";

    String link = GroceryAppConstant.base_url + "manage/api/contacts/add";
    print(link);
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);

      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

      showLongToast(user.message.toString());
      Navigator.of(context).pop();

      // Navigator.push(context,
      //   MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),);
//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
    } else
      throw Exception("Unable to get Employee list");
  }

  Widget getLabel() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: TextFormField(
        controller: labelController,
        validator: (String? value) {
                                        if (value==null|| value.isEmpty) {
            return " Please enter the label";
          }
        },
        decoration: const InputDecoration(hintText: "Enter Label"),
      ),
    );
  }
}

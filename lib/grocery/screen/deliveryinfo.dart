import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:aladdinmart/grocery/Auth/signin.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/model/UserUpdateModel.dart';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/grocery/screen/checkout.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DliveryInfo extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DliveryInfo> {
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

  var _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = new GlobalKey<ScaffoldState>();
  final resignofcause = TextEditingController();
  String? _dropDownValue1;
  Future<File>? profileImg;

  @override
  void initState() {
    getUserInfo();
    super.initState();
//    getImaformation();
  }

/*  getImage(BuildContext context) async {
    imageshow1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageshow1 != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: imageshow1.path,
          aspectRatio: CropAspectRatio(
              ratioX: 1, ratioY: 1),
          compressQuality: 85,
          maxWidth: 800,
          maxHeight: 800,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false

          ),

          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );

      this.setState((){
        imageshow1 = cropped;

      });
      Navigator.of(context).pop();
    }
    String imagevalue1 = (imageshow1).toString();
    imagevalue = imagevalue1.substring(7,(imagevalue1.lastIndexOf('')-1)).trim();

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      base64Image = base64Encode(imageshow1.readAsBytesSync());
      _image = new File('$imagevalue');
      print('Image Path $_image');
    });
  }




  Future<void> _sowchoiceDiloge(){

    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('MAke a Choice'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Gallery'),
                onTap: (){
                  getImage(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text('Camera'),
                onTap: (){
                  _OpenCamera(context);
                },
              )
            ],
          ),
        ),
      );

    });
  }*/

/*
  _OpenCamera(BuildContext context) async{
    var newImage = await ImagePicker.pickImage(source: ImageSource.camera);

    if(newImage!=null) {
      String imagevalue1 = (newImage).toString();
      imagevalue =
          imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim();

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      this.setState(() {
        base64Image = base64Encode(imageshow1.readAsBytesSync());
        _image = new File('$imagevalue');
        print('Image Path $_image');
      });
    }

  }*/

  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? name = pre.getString("name");
    String? email = pre.getString("email");
    String? mobile = pre.getString("mobile");
    String? pin = pre.getString("pin");
    String? city = pre.getString("city");
    String? address = pre.getString("address");
    String? sex = pre.getString("sex");
    user_id = pre.getString("user_id");
    print(user_id);
    if (GroceryAppConstant.image == null) {
    } else {
      url = GroceryAppConstant.image;
    }

    this.setState(() {
      nameController.text = name ?? "";
      emailController.text = email ?? "";
      stateController.text = '';
      pincodeController.text = pin ?? "";
      mobileController.text = mobile ?? "";
      cityController.text = city ?? "";
      resignofcause.text = address ?? "";
      _dropDownValue1 = sex;
      url = GroceryAppConstant.image;
      print(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.teal[50],
          title: Text(
            "Delivery Information",
            style: TextStyle(color: Colors.teal[200]),
          )),
      key: profilescaffoldkey,
      body: Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 0.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[],
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
                                      enabled: !_status,
                                      autofocus: !_status,
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
                                        'Email ID',
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
                                      enabled: !_status,
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
                                      controller: mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return " Please enter the mobile No";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),
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
                                        'Pin Code',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
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
                                        controller: pincodeController,
                                        keyboardType: TextInputType.number,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return " Please enter the pincode";
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Pin Code"),
                                        enabled: !_status,
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
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter State"),
                                      enabled: !_status,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
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
                                      child: new Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            padding: EdgeInsets.all(0.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: TextFormField(
                                      controller: cityController,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return " Please enter the city";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter City"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: DropdownButton(
                                  hint: _dropDownValue1 == null
                                      ? Text('Select gender')
                                      : Text(
                                          _dropDownValue1 ?? "",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  items: [
                                    'Male',
                                    'Female',
                                  ].map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    setState(
                                      () {
                                        _dropDownValue1 = val;
                                      },
                                    );
                                  },
                                ),
                              )
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                                child: new TextFormField(
                                    maxLines: 4,
                                    keyboardType: TextInputType
                                        .number, // Use mobile input type for emails.
                                    controller: resignofcause,
                                    validator: (String? value) {
                                      //print("Length${value.length}");
                                      if (value == null ||
                                          value.isEmpty && value.length > 10) {
                                        return " Please enter the  address";
                                      }
                                    },
                                    decoration: new InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ),
                                    ))),
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
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: new Text("Place Order"),
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        if (_dropDownValue1 == null) {
                          _showLongToast("Please select gender of persion");
                        } else {
                          setInfo();
//                              _getEmployee();
                        }
                      }

//                        _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                ),
              )),
            ),
            flex: 2,
          ),
          /*  Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        SystemNavigator.pop();
                      }
                      setState(() {
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),*/
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

  Future setInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", resignofcause.text);
    pref.setString("sex", _dropDownValue1 ?? "");
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    GroceryAppConstant.email = emailController.text;
    GroceryAppConstant.name = nameController.text;

    if (GroceryAppConstant.isLogin) {
      // Navigator.push(context,
      //     new MaterialPageRoute(builder: (context) => CheckOutPage()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  void _showLongToast(String message) {
    final snackbar = new SnackBar(content: Text("$message"));
   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

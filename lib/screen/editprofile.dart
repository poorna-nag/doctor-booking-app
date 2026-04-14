import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecoshine24/General/AppConstant.dart';

import 'package:ecoshine24/model/UserUpdateModel.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final String userid;

  const EditProfilePage(this.userid) : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<EditProfilePage> {
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
  String _dropDownValue1 = " ";
  Future<File>? profileImg;

  @override
  void initState() {
    getUserInfo();
    super.initState();
//    getImaformation();
  }

//  getImage(BuildContext context) async {
//    imageshow1 = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if(imageshow1 != null) {
//      File cropped = await ImageCropper.cropImage(
//          sourcePath: imageshow1.path,
//          aspectRatio: CropAspectRatio(
//              ratioX: 1, ratioY: 1),
//          compressQuality: 85,
//          maxWidth: 800,
//          maxHeight: 800,
//          compressFormat: ImageCompressFormat.jpg,
//          androidUiSettings: AndroidUiSettings(
//              toolbarTitle: 'Cropper',
//              toolbarColor: Colors.deepOrange,
//              toolbarWidgetColor: Colors.white,
//              initAspectRatio: CropAspectRatioPreset.original,
//              lockAspectRatio: false
//
//          ),
//
//          iosUiSettings: IOSUiSettings(
//            minimumAspectRatio: 1.0,
//          )
//      );
//
//      this.setState((){
//        imageshow1 = cropped;
//
//      });
//      Navigator.of(context).pop();
//    }
//    String imagevalue1 = (imageshow1).toString();
//    imagevalue = imagevalue1.substring(7,(imagevalue1.lastIndexOf('')-1)).trim();
//
////    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      base64Image = base64Encode(imageshow1.readAsBytesSync());
//      _image = new File('$imagevalue');
//      print('Image Path $_image');
//    });
//  }

//  Future<void> _sowchoiceDiloge(){
//
//    return showDialog(context: context,builder: (BuildContext context){
//      return AlertDialog(
//        title: Text('MAke a Choice'),
//        content: SingleChildScrollView(
//          child: ListBody(
//            children: <Widget>[
//              GestureDetector(
//                child: Text('Gallery'),
//                onTap: (){
//                  getImage(context);
//                },
//              ),
//              Padding(padding: EdgeInsets.all(8.0),),
//              GestureDetector(
//                child: Text('Camera'),
//                onTap: (){
////                  _OpenCamera(context);
//                  getImagefromCamera();
//                },
//              )
//            ],
//          ),
//        ),
//      );
//
//    });
//  }

//  Future getImagefromCamera() async{
//
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
//      _image = image;
//    });
//  }
//
//  _OpenCamera(BuildContext context) async{
//  var newImage = await ImagePicker.pickImage(source: ImageSource.camera);
//
//if(newImage!=null) {
//  String imagevalue1 = (newImage).toString();
//  imagevalue =
//      imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim();
//
////    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//  this.setState(() {
//    base64Image = base64Encode(imageshow1.readAsBytesSync());
//    _image = new File('$imagevalue');
//    print('Image Path $_image');
//  });
//}
//
//}

  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? name = pre.getString("name");
    String? email = pre.getString("email");
    String? mobile = pre.getString("mobile");
    String? pin = pre.getString("pin");
    String? state = pre.getString("state");
    String? city = pre.getString("city");
    String? address = pre.getString("address");
    String? sex = pre.getString("sex");
    String? image = pre.getString("pp");
    user_id = pre.getString("user_id");
    print(user_id);

    this.setState(() {
      nameController.text = FoodAppConstant.name;
      emailController.text = FoodAppConstant.email;
      stateController.text = state ?? "";
      pincodeController.text = pin ?? "";
      mobileController.text = mobile ?? "";
      cityController.text = city ?? "";
      resignofcause.text = address ?? "";
      _dropDownValue1 = sex ?? "";
      FoodAppConstant.image = image ?? "";

      url = FoodAppConstant.image;
      print(url);
      print("FoodAppConstant.image");
      print(FoodAppConstant.image);
      print(FoodAppConstant.image.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: FoodAppColors.tela,
        title: Text(
          "Profile Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      key: profilescaffoldkey,
      body: Container(
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: <Color>[
                      //     FoodAppColors.tela,
                      //     FoodAppColors.tela,
                      //   ],
                      // ),
                      ),
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
//                              alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (camera) {
                                        camera = false;
                                      } else {
                                        camera = true;
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.orange,
                                    child: ClipOval(
                                      child: new SizedBox(
                                        width: 150.0,
                                        height: 150.0,
                                        child: _image != null
                                            ? Image.file(
                                                _image!,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                FoodAppConstant.image,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              camera ? showIcone(context) : Container(),
//                              camera?Container():submitImage(),

//                              Padding(
//                                padding: EdgeInsets.only(top: 85.0),
//                                child: Card(
//                                  color:AppColors.pink,
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(20.0),
//                                  ),
//                                  child: IconButton(
//                                    color: Colors.white,
//                                    icon: Icon(
//                                      Icons.edit,
//                                      size: 15.0,
//                                    ),
//                                    onPressed: () {
////                                      _sowchoiceDiloge();
//                                    },
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                          /* Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _status ? _getEditIcon1() : new Container(),
//                                new CircleAvatar(
//                                  backgroundColor: Colors.red,
//                                  radius: 25.0,
//                                  child: new Icon(
//                                    Icons.camera_alt,
//                                    color: Colors.white,
//                                  ),
//                                )
                              ],
                            )),*/
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  decoration: BoxDecoration(
                      // gradient:
                      //     LinearGradient(begin: Alignment.bottomRight, colors: [
                      //   FoodAppColors.tela.withOpacity(.4),
                      //   FoodAppColors.tela1.withOpacity(.1),
                      // ]),
                      ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
//                          profile(context),
                          Padding(
                              padding: EdgeInsets.only(top: 5.0),
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
                              padding: EdgeInsets.only(top: 10.0),
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
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email',
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
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: "Enter Email ID"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0),
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
                              padding: EdgeInsets.only(top: 10.0),
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
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: "Enter Mobile Number"),
                                      enabled: true,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Pincode',
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
                              padding: EdgeInsets.only(top: 10.0),
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(6)
                                        ],
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
                                      enabled: !_status,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0),
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
                                        ' Gender',
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
                            padding: EdgeInsets.all(0.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
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
                                    enabled: !_status,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  //width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      hint: _dropDownValue1 == null
                                          ? Text('Select gender')
                                          : Text(
                                              _dropDownValue1,
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                            _dropDownValue1 = val!;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),

                          TextFormField(
                            maxLines: 5,
                            keyboardType: TextInputType.text,
                            controller: resignofcause,
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
                  height: 40,
                  child: new ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: new Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (resignofcause.text.length > 5) {
                          _getEmployee();
                        } else {
                          showLongToast("Please add the address");
                        }
                      }

//                        _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                  )),
            ),
            flex: 2,
          ),
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 10.0),
          //     child: Container(
          //         child: new ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.red,
          //         shape: new RoundedRectangleBorder(
          //             borderRadius: new BorderRadius.circular(20.0)),
          //         textStyle: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //       child: new Text("Cancel"),
          //       onPressed: () {
          //         if (Navigator.canPop(context)) {
          //           Navigator.pop(context);
          //         } else {
          //           SystemNavigator.pop();
          //         }
          //         setState(() {});
          //       },
          //     )),
          //   ),
          //   flex: 2,
          // ),
        ],
      ),
    );
  }

//

  Future _ImageUpdate() async {
    var map = new Map<String, dynamic>();
    map['pp'] = "data:image/png;base64," + base64Image.toString();
    map['user_id'] = widget.userid;
    map['mobile'] = mobileController.text;
    map['type'] = "base64";
//    print(base64Image);
//    print(widget.userid);
//    print(mobileController.text);
    try {
      final response = await http.post(
          Uri.parse(FoodAppConstant.base_url + 'api/ppupload.php'),
          body: map);
      if (response.statusCode == 200) {
        print(response.toString());
        U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
        _showLongToast(user.message.toString());
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("pp", user.img ?? "");
        setState(() {
          FoodAppConstant.image = user.img ?? "";
          FoodAppConstant.check = true;
        });
        print(user.img);
      } else
        throw Exception("Unable to get Employee list");
    } catch (Exception) {}
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map['name'] = nameController.text;
    map['X-Api-Key'] = FoodAppConstant.API_KEY;
    map['email'] = emailController.text;
    map['phone'] = mobileController.text;
    map['pincode'] = pincodeController.text;
    map['city'] = cityController.text;
    map['sex'] = _dropDownValue1;
    map['address'] = resignofcause.text;
    map['state'] = stateController.text;
    map['username'] = mobileController.text;
    final response = await http.post(
        Uri.parse(FoodAppConstant.base_url + 'manage/api/customers/update'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody.toString());
      U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
      if (user.message.toString() ==
          "Your data has been successfully updated into the database") {
        _showLongToast(user.message.toString());

        pref.setString("email", emailController.text);
        pref.setString("name", nameController.text);
        pref.setString("state", stateController.text);
        pref.setString("city", cityController.text);
        pref.setString("address", resignofcause.text);
        pref.setString("sex", _dropDownValue1);
        pref.setString("mobile", mobileController.text);
        pref.setString("pin", pincodeController.text);
        pref.setBool("isLogin", true);
//        print(user.name);
        FoodAppConstant.isLogin = true;
        FoodAppConstant.email = emailController.text;
        FoodAppConstant.name = nameController.text;
      } else {
        _showLongToast("You have no changes");
      }
    } else
      _showLongToast("You have no changes");
    throw Exception("Unable to get Employee list");
  }

  void _showLongToast(String message) {
    final snackbar = new SnackBar(content: Text("$message"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget profile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 140),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  if (camera) {
                    camera = false;
                  } else {
                    camera = true;
                  }
                });
              },
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.orange,
                child: ClipOval(
                  child: new SizedBox(
                    width: 150.0,
                    height: 150.0,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            url,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            camera ? showIcone(context) : Container(),
          ],
        ),
      ),
    );
  }

  bool camera = false;

  Widget submitImage() {
    return Container(
      child: InkWell(
          onTap: () {
            _ImageUpdate();
          },
          child: Text("Submit")),
    );
  }

  Widget showIcone(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        InkWell(
            onTap: () {
              getImageC(context);
//              getImage12();

              setState(() {
                camera = false;
              });
            },
            child: Icon(
              Icons.camera_alt,
              size: 35,
            )),
        SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () {
              getImage(context);
              setState(() {
                camera = false;
              });
            },
            child: Icon(
              Icons.storage,
              size: 35,
            )),
      ],
    );
  }

  getImage(BuildContext context) async {
    final data = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageshow1 = File(data!.path);

    String imagevalue1 = (imageshow1).toString();
    imagevalue = imagevalue1 != null
        ? imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
        : imagevalue1;

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      base64Image = base64Encode(imageshow1!.readAsBytesSync());
      _image = new File('$imagevalue');
      print('Image Path $_image');
      _ImageUpdate();
    });
  }

  getImageC(BuildContext context) async {
    final data = await ImagePicker().pickImage(source: ImageSource.camera);
    imageshow1 = File(data!.path);
    String imagevalue1 = (imageshow1).toString();
    imagevalue1.length > 7
        ? imagevalue =
            imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
        : imagevalue1;

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      base64Image = base64Encode(imageshow1!.readAsBytesSync());
      _image = new File('$imagevalue');
      print('Image Path $_image');
      _ImageUpdate();
    });
  }

  final picker = ImagePicker();

  Future getImage12() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
      base64Image = base64Encode(_image!.readAsBytesSync());
      _ImageUpdate();
    });
  }
}

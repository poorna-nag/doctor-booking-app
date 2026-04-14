import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/UserUpdateModel.dart';
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
    String? state = pre.getString("state");
    String? pin = pre.getString("pin");
    String? city = pre.getString("city");
    String? address = pre.getString("address");
    String? sex = pre.getString("sex");
    String? image = pre.getString("pp");
    user_id = pre.getString("user_id");
    print(user_id);

    this.setState(() {
      nameController.text = GroceryAppConstant.name;
      emailController.text = GroceryAppConstant.email;
      stateController.text = state ?? "";
      pincodeController.text = pin ?? "";
      mobileController.text = mobile ?? "";
      cityController.text = city ?? "";
      resignofcause.text = address ?? "";
      _dropDownValue1 = sex ?? "";
      GroceryAppConstant.image = image ?? "";

      url = GroceryAppConstant.image;
      print(url);
      print("Constant.image");
      print(GroceryAppConstant.image);
      print(GroceryAppConstant.image.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GroceryAppColors.lightBlueBg, // Light orange background
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 53, 130, 255), // Primary orange
                const Color.fromARGB(255, 53, 130, 255), // Light orange
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 53, 130, 255).withOpacity(0.4),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
        ),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.medical_services_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Doctor Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Manage your healthcare profile",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      key: profilescaffoldkey,
      body: Container(
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 63, 150, 244)
                            .withOpacity(0.08),
                        GroceryAppColors.lightBlueBg,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 30),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color.fromARGB(
                                              255, 53, 130, 255),
                                          const Color.fromARGB(
                                              255, 53, 130, 255),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 73, 159, 217)
                                              .withOpacity(0.5),
                                          blurRadius: 25,
                                          offset: Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: new SizedBox(
                                          width: 140.0,
                                          height: 140.0,
                                          child: _image != null
                                              ? Image.file(
                                                  _image!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  GroceryAppConstant.image,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            GroceryAppColors
                                                                .lightBlueBg,
                                                            GroceryAppColors
                                                                .lightBlueBg,
                                                          ],
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .local_hospital_outlined,
                                                        size: 60,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 81, 165, 226),
                                                      ),
                                                    );
                                                  },
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              camera ? showIcone(context) : Container(),
                            ],
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF8FBFF),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
//                          profile(context),
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
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 71, 154, 232)),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            GroceryAppColors.lightBlueBg,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                                  255, 80, 155, 241)
                                              .withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 78, 167, 226)
                                                .withOpacity(0.15),
                                            blurRadius: 15,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: nameController,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return " Please enter the name";
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 53, 130, 255),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Enter Patient Name",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 15,
                                          ),
                                          prefixIcon: Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color.fromARGB(
                                                      255, 53, 130, 255),
                                                  const Color.fromARGB(
                                                      255, 53, 130, 255),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 15,
                                          ),
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
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
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 53, 130, 255)),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            GroceryAppColors.lightBlueBg,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                                  255, 53, 130, 255)
                                              .withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 53, 130, 255)
                                                .withOpacity(0.15),
                                            blurRadius: 15,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return " Please enter the email id";
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 53, 130, 255),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Enter Contact Email",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 15,
                                          ),
                                          prefixIcon: Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color.fromARGB(
                                                      255, 53, 130, 255),
                                                  const Color.fromARGB(
                                                      255, 53, 130, 255),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.email_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 15,
                                          ),
                                        ),
                                        enabled: !_status,
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
                                        'Mobile No',
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 53, 130, 255)
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: mobileController,
                                        keyboardType: TextInputType.number,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return " Please enter the mobile No";
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 53, 130, 255),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Enter Mobile Number",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 16,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.phone_outlined,
                                            color: const Color.fromARGB(
                                                255, 53, 130, 255),
                                            size: 20,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 15,
                                          ),
                                        ),
                                        enabled: true,
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
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 82, 167, 210)
                                                  .withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: pincodeController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6)
                                          ],
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return " Please enter the pincode";
                                            }
                                            return null;
                                          },
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 53, 130, 255),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Enter Pin Code",
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 16,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.location_on_outlined,
                                              color: const Color.fromARGB(
                                                  255, 53, 130, 255),
                                              size: 20,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 15,
                                            ),
                                          ),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 53, 130, 255)
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: stateController,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return " Please enter the state";
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 53, 130, 255),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Enter State",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 16,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.map_outlined,
                                            color: const Color.fromARGB(
                                                255, 53, 130, 255),
                                            size: 20,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 15,
                                          ),
                                        ),
                                        enabled: !_status,
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
                                        return null;
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 3),
                                  child: Container(
                                    width: 100,
                                    height: 80,
                                    child: DropdownButton(
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
                                            _dropDownValue1 = val ?? "";
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 53, 130, 255),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                maxLines: 8,
                                keyboardType: TextInputType.text,
                                controller: resignofcause,
                                validator: (String? value) {
                                  if (value == null ||
                                      value.isEmpty && value.length > 10) {
                                    return " Please enter the  address";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      const Color.fromARGB(255, 73, 145, 222),
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  labelText: 'Enter the address',
                                  labelStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 80, 146, 222),
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.home_outlined,
                                    color:
                                        const Color.fromARGB(255, 87, 159, 211),
                                    size: 20,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
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
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  backgroundColor: const Color.fromARGB(255, 83, 160, 222),
                  textStyle: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                child: new Text("Submit"),
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
          ),
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 10.0),
          //     child: Container(
          //         child: new ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         shape: new RoundedRectangleBorder(
          //             borderRadius: new BorderRadius.circular(20.0)),
          //         backgroundColor: Colors.red,
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
          Uri.parse(GroceryAppConstant.base_url + 'api/ppupload.php'),
          body: map);
      if (response.statusCode == 200) {
        print(response.toString());
        U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
        _showLongToast(user.message.toString());
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("pp", user.img ?? "");
        setState(() {
          GroceryAppConstant.image = user.img ?? "";
          GroceryAppConstant.check = true;
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
    map['X-Api-Key'] = GroceryAppConstant.API_KEY;
    map['email'] = emailController.text;
    map['phone'] = mobileController.text;
    map['pincode'] = pincodeController.text;
    map['city'] = cityController.text;
    map['sex'] = _dropDownValue1;
    map['address'] = resignofcause.text;
    map['state'] = stateController.text;
    map['username'] = mobileController.text;
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'manage/api/customers/update'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody.toString());
      U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
      if (user.message.toString() ==
          "Your data has been successfully updated into the database") {
        _showLongToast(user.message ?? "");

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
        GroceryAppConstant.isLogin = true;
        GroceryAppConstant.email = emailController.text;
        GroceryAppConstant.name = nameController.text;
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
                backgroundColor: const Color.fromARGB(255, 88, 181, 247),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              getImageC(context);
              setState(() {
                camera = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 71, 163, 224),
                    const Color.fromARGB(255, 65, 151, 203),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 51, 153, 197)
                        .withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 34,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 35),
          InkWell(
            onTap: () {
              getImage(context);
              setState(() {
                camera = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 72, 149, 185),
                    Color.fromARGB(255, 76, 173, 215),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 83, 172, 235)
                        .withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 34,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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

  getImage(BuildContext context) async {
    final data = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageshow1 = File(data!.path);

    String imagevalue1 = (imageshow1).toString();
    imagevalue =
        imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim();

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

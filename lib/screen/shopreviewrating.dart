import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/dbhelper/database_helper.dart';
import 'package:aladdinmart/model/ListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ShowAddress.dart';

class shopreviewrating extends StatefulWidget {
  String mv;
  shopreviewrating(this.mv);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<shopreviewrating> {
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

  double? _ratingController;
  int selectedRadio = 1;

  List<ListModel>? sliderlist;

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
      // stateController.text ??"";
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
    getShopListby(widget.mv).then((usersFromServe1) {
      setState(() {
        sliderlist = usersFromServe1;
        // Constant.contact=sliderlist.mobileNo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: FoodAppColors.tela,
        leading: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        title: Container(
          // height: 40,
          child: Text(
            'Vendor Rating Form',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
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
                    key: _formKeyad,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          sliderlist != null && sliderlist!.length > 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          /*borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),*/
                                          child: Image.network(
                                            FoodAppConstant.logo_Image_mv +
                                                sliderlist![0].pp.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 25.0),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: new Text(
                                                      sliderlist![0].company ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              sliderlist![0]
                                                      .address
                                                      .toString() +
                                                  " " +
                                                  sliderlist![0]
                                                      .city
                                                      .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 5.0),
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Center(
                                                    child: new Text(
                                                      "Pincode " +
                                                          sliderlist![0]
                                                              .pincode
                                                              .toString(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      /*                     Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 5.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Center(
                                              child: new Text(
                                                "Mobile: " +
                                                    sliderlist[0].mobile,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),*/
                                    ])
                              : Container(),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Column(
                                    children: <Widget>[
                                      Center(
                                        child: new Text(
                                          "Rate this Vendor",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Column(
                                    children: <Widget>[
                                      Center(
                                        child: new Text(
                                          "Tell others what you think",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: RatingBar.builder(
                                        initialRating: 1,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          _ratingController = rating;
                                          print(_ratingController);
                                        },
                                      ),
                                    ),
                                    flex: 2,
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
                                      hintText: 'Describe your experience',
                                      labelText: 'Describe',
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
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 35.0),
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
                    backgroundColor: Colors.green,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    textStyle: TextStyle(
                      color: Colors.white,
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
        backgroundColor: FoodAppColors.pink,
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

  Future _AddAddress() async {
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    print(FoodAppConstant.Shop_id);
    print(FoodAppConstant.API_KEY);
    // print(Constant.user_id);
    print(nameController.text);
    print(mobileController.text);
    print(emailController.text);
    print(address1.text);
    print(formatted);

    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['X-Api-Key'] = FoodAppConstant.API_KEY;
    map['user_id'] = FoodAppConstant.user_id;
    map['mv_id'] = widget.mv;
    map['stars'] = _ratingController.toString();
    map['review'] = address1.text;
    map['status'] = "New";

    String link = FoodAppConstant.base_url + "manage/api/mv_reviews/add";
    print(link);
    print(map.toString());
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);

      // OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

      showLongToast(jsonBody["message"]);
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
        // ignore: missing_return
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return " Please enter the label";
          }
        },
        decoration: const InputDecoration(hintText: "Enter Label"),
      ),
    );
  }
}

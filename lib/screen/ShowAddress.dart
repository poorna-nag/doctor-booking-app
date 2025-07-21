import 'dart:convert';

import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/screen/AddAddress.dart';
import 'package:aladdinmart/model/AddressModel.dart';
import 'package:aladdinmart/model/RegisterModel.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'UpdateAddress.dart';

class ShowAddress extends StatefulWidget {
  final String valu;
  const ShowAddress(this.valu) : super();
  @override
  _ShowAddressState createState() => _ShowAddressState();
}

class _ShowAddressState extends State<ShowAddress> {
  List<UserAddress> add = [];
  bool isloading = false;
//  void checkAddress(){
//    if(widget.valu=="0"&& add.length>0){
//      Navigator.push(context,
//        MaterialPageRoute(builder: (context) => AddAddress()),);
//
//    }
//  }
  bool _status = false;
  @override
  void initState() {
    super.initState();
    isloading = true;
    getAddress().then((usersFromServe) {
      setState(() {
        add = usersFromServe!;
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: FoodAppColors.tela,
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAddress(widget.valu)),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "My Address",
          maxLines: 2,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      body:
          // _status?screen():
          Container(
        child: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : add.isEmpty
                ? Center(
                    child: Text('No Address Found!....'),
                  )
                : add.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: add.length <= 0 ? 0 : add.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (widget.valu == "0") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpDateAddress(
                                          add[index], widget.valu)),
                                );
                              } else {}
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                elevation: 5.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    add[index].label != null
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 6, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                add[index].fullName != null
                                                    ? Text(
                                                        add[index].fullName !=
                                                                null
                                                            ? add[index]
                                                                .fullName!
                                                            : "",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      )
                                                    : SizedBox(),
                                                Text(
                                                  add[index].label != null
                                                      ? add[index].label ?? ""
                                                      : "",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),

                                    add[index].address1!.length > 1
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, top: 5),
                                                  child: Text(
                                                    add[index].address1 != null
                                                        ? add[index].address1 ??
                                                            ""
                                                        : "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: 0,
                                          ),

                                    add[index].mobile!.length > 1
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, top: 5),
                                                child: Text(
                                                  add[index].mobile != null
                                                      ? add[index]
                                                              .mobile
                                                              .toString() +
                                                          ',' +
                                                          add[index]
                                                              .email
                                                              .toString()
                                                      : "",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(),

//                             add[index].city != null
//                                 ? Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Padding(
//                                           padding:
//                                               EdgeInsets.only(left: 10, top: 5),
//                                           child: Text(
//                                             add[index].city != null
//                                                 ? add[index].city.toString() +
//                                                     ", " +
//                                                     add[index]
//                                                         .state
//                                                         .toString() +
//                                                     ", " +
//                                                     add[index]
//                                                         .pincode
//                                                         .toString()
//                                                 : "",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : Row(),

// //                  setContainer("Name",add[index].fullName),
//                             setContainer("Mobile No", add[index].mobile ?? ""),
//                             setContainer("Email Id", add[index].email ?? ""),

                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, top: 2, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        elevation: 0,
                                                        backgroundColor:
                                                            FoodAppColors
                                                                .white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpDateAddress(
                                                                      add[
                                                                          index],
                                                                      widget
                                                                          .valu)),
                                                        );
                                                      },
//              splashColor: AppColors.tela,

                                                      child: Icon(Icons.edit)

                                                      //  Text(
                                                      //   "Update",
                                                      //   style: TextStyle(
                                                      //     fontSize: 12,
                                                      //     color: Colors.white,
                                                      //   ),
                                                      // ),
                                                      )),
                                              Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                    ),
                                                    onPressed: () {
                                                      print("Delete");
                                                      showDilogueReviw(
                                                          context, index);
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    )
                                                    //  Text(
                                                    //   "Delete",
                                                    //   style: TextStyle(
                                                    //     fontSize: 12,
                                                    //     color: Colors.white,
                                                    //   ),
                                                    // ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          // Padding(
                                          //     padding: EdgeInsets.all(2.0),
                                          //     child: ElevatedButton(
                                          //         style:
                                          //             ElevatedButton.styleFrom(
                                          //           elevation: 0,
                                          //           backgroundColor:
                                          //               FoodAppColors.white,
                                          //           shape:
                                          //               RoundedRectangleBorder(
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     20.0),
                                          //           ),
                                          //         ),
                                          //         onPressed: () {
                                          //           Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     CheckOutPage(
                                          //                         add[index])),
                                          //           );
                                          //         },
                                          //         child: Icon(
                                          //           Icons
                                          //               .keyboard_double_arrow_right_rounded,
                                          //           size: 35,
                                          //         )

                                          //         //  Text(
                                          //         //   "Next",
                                          //         //   style: TextStyle(
                                          //         //     fontSize: 12,
                                          //         //     color: Colors.white,
                                          //         //   ),
                                          //         // ),
                                          //         )),
                                        ],
                                      ),
                                    )
//                  getAction(context,index),
//                  setContainer("City",add[index].city),
//                  setContainer("State",add[index].state),
//                  setContainer("Pin",add[index].pincode),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget getAction(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 2, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(2.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FoodAppColors.teladep,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpDateAddress(add[index], widget.valu),
                    ),
                  );
                },
//              splashColor: AppColors.tela,

                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onPressed: () {
//                _deleteAdderss(add[index].addId);
//                add.removeAt(index);
                showDilogueReviw(context, index);
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setContainer(String title, String value) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              title != null ? title + ':' : "",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              value != null ? value : "",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _deleteAdderss(String id, int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userid = pref.getString("user_id");
    var map = Map<String, dynamic>();
    map['add_id'] = id;
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['X-Api-Key'] = FoodAppConstant.API_KEY;
    map['user_id'] = userid;

    final response = await http.post(
        Uri.parse(
            FoodAppConstant.base_url + 'manage/api/user_address/delete/'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      setState(() {
        add.removeAt(index);
      });
//
//      Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => ShowAddress()),);
      showLongToast(user.message ?? "");

//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
    } else
      throw Exception("Unable to get Employee list");
  }

  showDilogueReviw(BuildContext context, int index) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 130.0,
        width: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Do you want to delete!'),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel !',
                      style: TextStyle(color: Colors.red, fontSize: 18.0),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      _deleteAdderss(add[index].addId ?? "", index);

//                  Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => ShowAddress()),);
                    },
                    child: Text(
                      'ok !',
                      style: TextStyle(
                          color: FoodAppColors.success, fontSize: 18.0),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  Widget screen() {
    return Center(
      child: InkWell(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: <Color>[Colors.orange, Colors.deepOrange.shade900],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: Text(
                "No address found",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
//            Text("No address found  ",style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FoodAppColors.telamoredeep,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddAddress(widget.valu)),
                  );
                },
                child: Text(
                  "Add Address",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

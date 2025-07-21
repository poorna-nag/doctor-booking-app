import 'dart:developer';

import 'package:aladdinmart/screen/tracking.dart';
import 'package:flutter/material.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/StyleDecoration/styleDecoration.dart';
import 'package:aladdinmart/dbhelper/database_helper.dart';
import 'package:aladdinmart/map/mainScreen.dart';
import 'package:aladdinmart/model/TrackInvoiceModel.dart';
import 'package:aladdinmart/screen/Finaltracking.dart';
import 'package:aladdinmart/screen/trackorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackOrder extends StatefulWidget {
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  String? mobile;
  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? mob = pre.getString("mobile");
    this.setState(() {
      mobile = mob;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "My Booking",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: trackInvoice(mobile ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //  print(snapshot.data.length);
                return snapshot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : snapshot.data!.isEmpty
                        ? Center(
                            child: Text("No Data"),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data!.length == null
                                ? 0
                                : snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              TrackInvoice item = snapshot.data![index];

                              print("${index}:   ${item.lat},   ${item.lng}");
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FinalOrderTracker(
                                                    item.id ?? "",
                                                    item.deliveryDate ?? "",
                                                    item.states ?? "")),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Invoice Id",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              Text(
                                                item.id ?? "",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        fontSize: 18,
                                                        color: Colors
                                                            .deepOrangeAccent,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          //              Container(
                                          //                width: double.infinity,
                                          //                height: 0.5,
                                          //                margin: EdgeInsets.symmetric(vertical: 4),
                                          //                color: Colors.grey.shade400,
                                          //              ),
                                          //              SizedBox(
                                          //                height: 8,
                                          //              ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "Status",
                                                  style: CustomTextStyle
                                                      .textFormFieldSemiBold
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.black54),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  item.states ?? "",
                                                  style: CustomTextStyle
                                                      .textFormFieldSemiBold
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color: Colors
                                                              .deepOrangeAccent),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Amount",
                                                  style: CustomTextStyle
                                                      .textFormFieldSemiBold
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.black54),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "\u{20B9} ${item.invoiceTotal}",
                                                  style: CustomTextStyle
                                                      .textFormFieldSemiBold
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.black54),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Date",
                                                  style: CustomTextStyle
                                                      .textFormFieldSemiBold
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.black54),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  item.created ?? "",
                                                  style: CustomTextStyle
                                                      .textFormFieldSemiBold
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.black54),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              item.states == "Shipped"
                                                  ? InkWell(
                                                      onTap: () {
                                                        log(item.lat
                                                            .toString());
                                                        log(item.lng
                                                            .toString());
                                                        if (item.lat == '' ||
                                                            item.lng == '' ||
                                                            item.lat!
                                                                .startsWith(
                                                                    '0') ||
                                                            item.lng!
                                                                .startsWith(
                                                                    '0')) {
                                                          showLongToast(
                                                              'Address Not available');
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Tracking(
                                                                          id: item
                                                                              .id,
                                                                          lat: double.parse(
                                                                              item.lat!),
                                                                          long:
                                                                              double.parse(item.lng!),
                                                                        )),
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                        height: 30,
                                                        width: 130,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                              'Track Order',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .deepOrangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              )),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

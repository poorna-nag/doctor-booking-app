import 'package:flutter/material.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/StyleDecoration/styleDecoration.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/model/TrackInvoiceModel.dart';
import 'package:aladdinmart/grocery/screen/Finaltracking.dart';
import 'package:aladdinmart/grocery/screen/trackorder.dart';
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
        backgroundColor: GroceryAppColors.tela,
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          " My Bookings",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: trackInvoice(mobile??""),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data!.length);
                return ListView.builder(
                    itemCount:
                        snapshot.data?.length == null ? 0 : snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      TrackInvoice item = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Card(
                          child: Container(
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
                                        builder: (context) => FinalOrderTracker(
                                            item.id,
                                            item.deliveryDate,
                                            item.states)),
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
                                            item.id??"",
                                            style: CustomTextStyle
                                                .textFormFieldMedium
                                                .copyWith(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.deepOrangeAccent,
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
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Status",
                                              style: CustomTextStyle
                                                  .textFormFieldSemiBold
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: Colors.black54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              item.states??"",
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
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              "Amount",
                                              style: CustomTextStyle
                                                  .textFormFieldSemiBold
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: Colors.black54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              "\u{20B9} ${double.parse(item.invoiceTotal??"") + double.parse(item.shipping??"")}",
                                              style: CustomTextStyle
                                                  .textFormFieldSemiBold
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              "Date",
                                              style: CustomTextStyle
                                                  .textFormFieldSemiBold
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: Colors.black54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              item.created??"",
                                              style: CustomTextStyle
                                                  .textFormFieldSemiBold
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: Colors.black54),
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
                                          InkWell(
                                            onTap: () {
//                                 MyOrdertrack
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyOrdertrack(
                                                            item.awbCode??"")),
                                              );
                                            },
                                            child: item.awbCode == null
                                                ? Container()
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0,
                                                        bottom: 10.0),
                                                    height: 30,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                      child: Text('Track Order',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .deepOrangeAccent,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
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

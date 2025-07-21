import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/StyleDecoration/styleDecoration.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/model/MyReviewModel.dart';
import 'package:aladdinmart/grocery/screen/detailpage1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readmore/readmore.dart';

class MyReview extends StatefulWidget {
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<MyReview> {
  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? userid = pre.getString("user_id");
    this.setState(() {
      GroceryAppConstant.user_id = userid ?? "";
    });
  }

  int line = 2;
  String textval = "Show more";
  bool flag = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    print(GroceryAppConstant.user_id);
    print("Constant.user_id");
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
          "My review",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: myReview(GroceryAppConstant.user_id),
//          future: myReview("2345"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data!.length);
                return ListView.builder(
                    itemCount: snapshot.data!.length == null
                        ? 0
                        : snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Review item = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
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
                                        ProductDetails1(item.product ?? "")),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        item.productName != null
                                            ? item.productName ?? ""
                                            : "",
                                        overflow: TextOverflow.fade,
                                        style: CustomTextStyle
                                            .textFormFieldMedium
                                            .copyWith(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: RatingBar.builder(
                                            initialRating:
                                                double.parse(item.stars ?? ""),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          )),
                                    ],
                                  ),
                                  ReadMoreText(
                                    item.review ?? "",
                                    colorClickableText: Colors.green,
                                  ),

//                                  Row(
//                                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Expanded(
//                                        child: Container(
//                                          padding: EdgeInsets.only(top: 10),
//                                          child: Text(item.review!=null?item.review:"",
//                                            maxLines: line,
//                                            overflow: TextOverflow.ellipsis,
//                                            style: CustomTextStyle.textFormFieldSemiBold
//                                                .copyWith(fontSize: 15, color: Colors.black54),
//                                          ),
//                                        ),
//                                      ),
//
//                                    ],
//                                  ),
                                  /*  Row(
                                    mainAxisAlignment:  MainAxisAlignment.end,

                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {

                                            if(flag){
                                              setState(() {
                                                line=15;
                                                textval="Show less";
                                                flag=false;
                                              });

                                            }
                                            else{
                                              setState(() {
                                                line=2;
                                                textval="Show more";
                                                flag=true;
                                              });

                                            }


                                        },
                                        color: AppColors.red,
                                        padding: EdgeInsets.only( left: 20, right: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(24))),
                                        child: Text(
                                          textval,style: TextStyle(color: Colors.black),

                                        ),
                                      ),
                                    ],
                                  ),*/
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          item.dates ?? "",
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

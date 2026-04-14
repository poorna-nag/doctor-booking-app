import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/MyReviewModel.dart';
import 'package:ecoshine24/grocery/screen/detailpage1.dart';
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
      backgroundColor: Color(0xffF8FBFF), // Medical light background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1E88E5), // Medical blue
              Color(0xff42A5F5), // Lighter medical blue
              Color(0xff64B5F6), // Lightest medical blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff1E88E5), // Medical blue
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.medical_information,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Doctor Reviews",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(width: 36), // For symmetry
                    ],
                  ),
                ),
              ),
              // Body Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: FutureBuilder(
                      future: myReview(GroceryAppConstant.user_id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return _buildEmptyState();
                          }
                          print(snapshot.data!.length);
                          return ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                Review item = snapshot.data![index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white,
                                            Color(0xff1E88E5).withOpacity(
                                                0.02), // Medical blue
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Color(0xff1E88E5)
                                              .withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails1(
                                                        item.product ?? "")),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Doctor name and header
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xff1E88E5)
                                                              .withOpacity(0.1),
                                                          Color(0xff42A5F5)
                                                              .withOpacity(
                                                                  0.05),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color: Color(0xff1E88E5)
                                                            .withOpacity(0.2),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.local_hospital,
                                                      color: Color(
                                                          0xff1E88E5), // Medical blue
                                                      size: 22,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Dr. ${item.productName ?? "Healthcare Provider"}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff1E88E5), // Medical blue
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          "Medical Consultation",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff42A5F5),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 16),

                                              // Rating section
                                              Container(
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xff1E88E5)
                                                          .withOpacity(0.08),
                                                      Color(0xff42A5F5)
                                                          .withOpacity(0.04),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Color(0xff1E88E5)
                                                        .withOpacity(0.1),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star_rate,
                                                      color: Color(0xff1E88E5),
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "Service Rating: ",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff1E88E5),
                                                      ),
                                                    ),
                                                    RatingBar.builder(
                                                      initialRating:
                                                          double.parse(
                                                              item.stars ??
                                                                  "0"),
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 5,
                                                      itemSize: 20,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "(${item.stars ?? "0"}/5)",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff1E88E5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 16),

                                              // Review text
                                              Container(
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF8FBFF),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Color(0xff1E88E5)
                                                        .withOpacity(0.1),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.rate_review,
                                                          color:
                                                              Color(0xff1E88E5),
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          "Medical Service Review",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff1E88E5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    ReadMoreText(
                                                      item.review ??
                                                          "No review provided",
                                                      trimLines: 3,
                                                      colorClickableText:
                                                          Color(0xff1E88E5),
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                          ' Show more',
                                                      trimExpandedText:
                                                          ' Show less',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[700],
                                                        height: 1.4,
                                                      ),
                                                      moreStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1E88E5),
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1E88E5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 16),

                                              // Date and footer
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 12),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xff1E88E5)
                                                          .withOpacity(0.05),
                                                      Color(0xff42A5F5)
                                                          .withOpacity(0.02),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Color(0xff1E88E5)
                                                        .withOpacity(0.1),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.access_time,
                                                          color:
                                                              Color(0xff1E88E5),
                                                          size: 16,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          "Reviewed on: ${item.dates ?? ""}",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff1E88E5)
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Text(
                                                        "Medical Review",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Color(0xff1E88E5),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: GroceryAppColors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: GroceryAppColors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: GroceryAppColors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.rate_review_outlined,
                size: 60,
                color: GroceryAppColors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "No Reviews Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GroceryAppColors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "You haven't written any reviews yet.\nStart shopping and share your experience!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: GroceryAppColors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GroceryAppColors.white,
                    GroceryAppColors.white.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Start Shopping",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 65, 144, 208),
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

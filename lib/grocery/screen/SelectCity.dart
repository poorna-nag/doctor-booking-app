import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/General/Home.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCity extends StatefulWidget {
  @override
  _SelectCityState createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  SharedPreferences? pref;
  void setcity(String val, String cityid) async {
    pref = await SharedPreferences.getInstance();
    pref!.setString('city', val);
    pref!.setString('cityid', cityid);
    setState(() {
      GroceryAppConstant.cityid = cityid;
      GroceryAppConstant.citname = val;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GroceryApp()),
      );
    });
    // snapshot.data[index].loc_id
  }

  exitApp() {
    showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Do you really want to exit'),
              actions: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () => {
                    exit(0),
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return exitApp();
      },
      child: Scaffold(
        backgroundColor: GroceryAppColors.tela1,
        appBar: AppBar(
          backgroundColor: GroceryAppColors.tela,
          // leading: Padding(padding: EdgeInsets.only(left: 0.0),
          //     child:InkWell(
          //       onTap: (){
          //         if (Navigator.canPop(context)) {
          //           Navigator.pop(context);
          //         } else {
          //           SystemNavigator.pop();
          //         }
          //       },
          //
          //       child: Icon(
          //         Icons.arrow_back,size: 30,
          //         color: Colors.white,
          //       ),
          //
          //     )
          // ),

          actions: <Widget>[],
          title: Text("SELECT CITY",
              style: TextStyle(
                  color: GroceryAppColors.white,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold)),
        ),
        body: Container(
          color: GroceryAppColors.tela1,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: getPcity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.length == null
                              ? 0
                              : snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,

                              // color: Colors.white,
                              margin: EdgeInsets.only(right: 10),

                              child: InkWell(
                                onTap: () {
                                  setcity(snapshot.data![index].places ?? "",
                                      snapshot.data![index].loc_id ?? "");
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Card(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(top: 10),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            snapshot.data![index].places ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Divider(
                                    //
                                    //   color: AppColors.black,
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          });
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}

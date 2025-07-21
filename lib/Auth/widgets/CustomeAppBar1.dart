import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aladdinmart/General/AppConstant.dart';

class CustomAppBar1 extends StatefulWidget {
  @override
  _CustomAppBar1State createState() => _CustomAppBar1State();
}

class _CustomAppBar1State extends State<CustomAppBar1> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async {
        // drawer is open then first close it
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        } else {
          showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                    // title: Text('Warning'),
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
        // we can now close the app.
        return true;
      },
      child: Material(
        child: Container(
          height: height / 10,
          width: width,
          padding: EdgeInsets.only(left: 15, top: 25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [FoodAppColors.tela, FoodAppColors.tela1]),
          ),
          // child: Row(
          //   children: <Widget>[
          //     IconButton(
          //         icon: Icon(
          //           Icons.arrow_back,
          //         ),
          //         onPressed: () {})
          //   ],
          // ),
        ),
      ),
    );
  }
}

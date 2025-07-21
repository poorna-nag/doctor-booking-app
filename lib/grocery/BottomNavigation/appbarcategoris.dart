import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final double? height;

   CustomAppBar(this.height,
      {required super.child, required super.preferredSize});

  @override
  Size get preferredSize => Size.fromHeight(height!);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),

      height: preferredSize.height,
      alignment: Alignment.center,
      child: Container(

        margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Material(

          color: Colors.teal[50],
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
              onTap: () {

              },
              child:Padding(padding: EdgeInsets.only(top:5.0),
                child:
                TextField(
                  style: TextStyle(
                      color: Colors.green[900]),
                  decoration: InputDecoration(

                    hintText: 'Search Your Product',
                    hintStyle: TextStyle(color: Colors.teal[200]),

                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),)),
        ),
      ),


    );
  }
}
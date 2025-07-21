import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aladdinmart/model/CategaryModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodAppConstant {
  static String appname = "OHO";
  static const String packageName = "com.ohouserapp";
  static const String iosAppLink = "com.ohouserapp";
  static const String base_url = "https://oho.w4u.in/";
  static const String API_KEY = "A4EXVM96WD5F7N8RUKPJBLGYS2TCQHZ3";
  static const String Shop_id = "35458"; 
  static const String registration = "user.php";
  static const String post = "post.php";
  static const String Subscription = "subscription.php";
  static const String postvalue = "post.php?key=1234&action=add";
  static bool isLogin = false;
  static String logo_Image_mv = base_url + "manage/uploads/mv_list/";
  static String logo_Image_cat = base_url + "manage/uploads/mv_cats/";

  static String Base_Imageurl = base_url + "manage/uploads/gallery/5/";
  static String Product_Imageurl = base_url + "manage/uploads/gallery/3/";
  static String Product_Imageurl2 = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl1 = base_url + "manage/uploads/gallery/1/";
  static String Product_Imageurl5 = base_url + "manage/uploads/gallery/5/";
  static String AppName_showon_Homescreen = "Category";
  static String AppName_showon_Homescreen1 = "Creation";
  static String AProduct_type_Name1 = "TRENDING";
  static String AProduct_type_Name2 = "NEW ARIAVAL";
  static String my_Order = "My Bookings";
  static String Shipping_add = "Service Addresses";
  static String My_Review = "My review";
  static int val = 0;
  static String rad = "20";

  static String cityid = "";
  static String pinid = "";
  static String citname = "";
  static bool Checkupdate = false;
  static String contact = "1234567891";

  static double latitude = 0.0;
  static double longitude = 0.0;
  static String User_ID = "";
  static bool check = false;
  static String Mobile = "";
  static String username = " ";
  static String email11 = "armanarjun9356@gmail.com";
  static String name = " ";
  static String user_id = " ";
  static String email = " ";
  static String image = "";
  static String phone = "tel: 9632114648";
  final String SIGN_IN = 'signin';
  final String SIGN_UP = 'signup';
  static int itemcount = 0;
  static int wishlist = 0;
  static int foodAppCartItemCount = 0;
  static double totalAmount = 0;
  static double shipingAmount = 0;
  static List<Categary> list = [];
  static setvalue() {}
}

class FoodAppColors {
  static const red = Color(0xFFE3F2FD);
  static const black = Color(0xFF222222);
  static const blackLight = Color.fromARGB(197, 0, 0, 0);
  static const blackdrawer = Color(0xFF222222);
  static const product_title_name = Color(0xFF222222);
  static const App_H_name = Color(0xFF222222);
  static const Appname = Color(0xFFFFFFFF);

  static const tela = Color(0xFF2E05A2);
  static const tela1 = Color(0xff0f0bfa);
  static const teladep = Color(0xFF222222);
  static const telamoredeep = Color(0xFF40C4FF);
  static const onselectedBottomicon = Color(0xFFFF8F00);
  static const homeiconcolor = Color(0xFFFF8F00);
  static const category_button_Icon_color = Color(0xFFFF8F00);
  static const categoryicon = Color(0xFF00BCD4);
  static const carticon = Color(0xFFFF80AB);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const mrp = Color(0xFF979797);
  static const sellp = Color(0xFF2AA952);
  static const white = Color(0xFFFFFFFF);
  static const button_text_color = Color(0xFFFFFFFF);
  static const success = Color(0xFF2AA952);
  static const green = Color(0xFF2AA952);
  static const pink = Color(0xFFFF4081);
  static const boxColor1 = tela;
  static const boxColor2 = tela1;
  static const checkoup_paybuttoncolor = Color(0xFF40C4FF);
}

Widget showCircle() {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: EdgeInsets.only(left: 15, bottom: 18),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
          // color: Colors.blue,
        ),
        child: Text('${FoodAppConstant.foodAppCartItemCount}',
            style: TextStyle(color: Colors.white, fontSize: 15.0)),
      ),
    ),
  );
}

showLongToast(String s) {
  Fluttertoast.showToast(
    msg: s,
    toastLength: Toast.LENGTH_LONG,
  );
}

Future foodCartItemCount(int val) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setInt("itemCount", val);
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecoshine24/model/CategaryModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodAppConstant {
  static String appname = "acuityDr";
  static const String packageName = "com.doctorbookingbigweltdemoapp";
  static const String iosAppLink = "com.doctorbookingbigweltdemoapp";
  // ignore: constant_identifier_names
  static const String base_url = "https://bookyourdoctor.w4u.in/";
  static const String API_KEY = "RDM9GHUT2CJFSNLE6PX4V7A3Z5QW8BYK";
  static const String Shop_id = "2892";
  static const String registration = "user.php";
  static const String post = "post.php";
  static const String Subscription = "subscription.php";
  static const String postvalue = "post.php?key=1234&action=add";
  static bool isLogin = false;
  static String logo_Image_mv = "${base_url}manage/uploads/mv_list/";
  static String logo_Image_cat = "${base_url}manage/uploads/mv_cats/";

  static String Base_Imageurl = "${base_url}manage/uploads/gallery/5/";
  static String Product_Imageurl = "${base_url}manage/uploads/gallery/3/";
  static String Product_Imageurl2 = "${base_url}manage/uploads/gallery/";
  static String Product_Imageurl1 = "${base_url}manage/uploads/gallery/1/";
  static String Product_Imageurl5 = "${base_url}manage/uploads/gallery/5/";
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

  // Helper function to get category image widget with fallback
  static Widget getCategoryImageWidget(String? imageUrl,
      {BoxFit fit = BoxFit.fill, double? width, double? height}) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        base_url + "manage/uploads/mv_cats/" + imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _getNoImageWidget(width: width, height: height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _getNoImageWidget(width: width, height: height);
        },
      );
    } else {
      return _getNoImageWidget(width: width, height: height);
    }
  }

  // Helper function for no image widget
  static Widget _getNoImageWidget({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: FoodAppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: (width != null && width < 60) ? 20 : 40,
            color: FoodAppColors.darkGray,
          ),
          if (width == null || width >= 60)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "No Image",
                style: TextStyle(
                  fontSize: 10,
                  color: FoodAppColors.darkGray,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FoodAppColors {
  static const red = Color(0xFFE3F2FD);
  static const black = Color(0xFF222222);
  static const blackLight = Color.fromARGB(225, 0, 0, 0);
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
  // ignore: constant_identifier_names
  static const category_button_Icon_color = Color(0xFFFF8F00);
  static const categoryicon = Color(0xFF00BCD4);
  static const carticon = Color(0xFFFF80AB);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const mrp = Color(0xFF979797);
  static const sellp = Color.fromARGB(255, 42, 167, 81);
  static const white = Color(0xFFFFFFFF);
  // ignore: constant_identifier_names
  static const button_text_color = Color(0xFFFFFFFF);
  static const success = Color(0xFF2AA952);
  static const green = Color(0xFF2AA952);
  static const pink = Color(0xFFFF4081);
  static const boxColor1 = tela;
  static const boxColor2 = tela1;
  // ignore: constant_identifier_names
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

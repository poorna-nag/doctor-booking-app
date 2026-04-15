import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecoshine24/grocery/model/CategaryModal.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart';

class GroceryAppConstant {
  // static const String base_url = "http://www.comelyindia.w4u.in/";
  static String appname = "acuityDr";
  static const String packageName = "com.doctorbookingbigweltdemoapp";
  static const String iosAppLink = "";
  static const String base_url = "https://bookyourdoctor.w4u.in/";
  static const String mainurl = base_url;

  static const String API_KEY = "RDM9GHUT2CJFSNLE6PX4V7A3Z5QW8BYK";
  static const String Shop_id = "2892";
  static const Google_Api_Key = "AIzaSyA-HxLg6FiYIysPv-iZtslRlt0CSny5awI";
  static const String registration = "user.php";
  static const String post = "post.php";
  static const String Subscription = "subscription.php";
  static const String postvalue = "post.php?key=1234&action=add";
  static bool isLogin = false;
  static String logo_Image_cat = base_url + "manage/uploads/mv_cats/";
  static String logo_Image_Pcat = base_url + "manage/uploads/p_category/";
  static String logo_Image_mv = base_url + "manage/uploads/mv_list/";
  static String Base_Imageurl = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl2 = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl1 = base_url + "manage/uploads/gallery/1/";
  static String Product_Imageurl5 = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl6 = base_url + "manage/uploads/manage_pages/";
  static String AppName_showon_Homescreen = "Category";
  static String AppName_showon_Homescreen1 = "Creation";
  static String AProduct_type_Name1 = "Trending Services";
  static String AProduct_type_Name2 = "NEW PRODUCTS";
  static String my_Order = "My Bookings";
  static String Shipping_add = "Service Addresses";
  static String My_Review = "My review";
  static int val = 0;
  static String cityid = "";
  static String pinid = "";
  static String citname = "";
  static bool Checkupdate = false;
  static String contact = "9284310365";

  static double latitude = 0.0;
  static double longitude = 0.0;
  static String User_ID = "";
  static bool check = false;
  static String Mobile = "";
  static String username = " ";
  static String email11 = "surajwagh8586@gmail.com ";
  static String name = " ";
  static String user_id = " ";
  static String email = " ";
  static String image = "";
  static String phone = "tel: 9284310365";
  final String SIGN_IN = 'signin';
  final String SIGN_UP = 'signup';
  static int itemcount = 0;
  static int wishlist = 0;
  static int groceryAppCartItemCount = 0;
  static double totalAmount = 0;
  static double shipingAmount = 0;
  static List<Categary> list = [];

  static int carditemCount = 0;

  static setvalue() {}
}

class GroceryAppColors {
  static const red = Color(0xFFE3F2FD);
  static const black = Color(0xFF222222);
  static const blackdrawer = Color(0xFF222222);
  static const product_title_name = Color(0xFF222222);
  static const App_H_name = Color(0xFF222222);
  static const Appname = Color(0xFFFFFFFF);

  //static const tela = Color(0xff008000);
  static const tela = Color(0xffFF6B35); // Vibrant orange - primary color
  static const bg = Color.fromARGB(255, 247, 251, 253);
  static const lightBlueBg = Color(0xffFFF8F0); // Light orange background
  static const tela1 = Color(0xffFF8A50); // Light orange - secondary color
  // static const tela1 = Color(0xff008000);
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
  static const button_text_color = Color(0xFF607D8B);
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
          color: GroceryAppColors.homeiconcolor,
          // color: Colors.orange,
        ),
        child: Text('${GroceryAppConstant.groceryAppCartItemCount}',
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

Widget showSticker(int index, List<Products> product) {
  // double.parse(products1[index].discount)>0?
  return Align(
    alignment: Alignment.topLeft,
    child: Stack(
      children: [
        Container(
          height: 70,
          width: 80,
          // child: Image.asset("assets/images/rebon.png"),
        ),
        Container(
          padding: const EdgeInsets.only(left: 9.0, top: 11),
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(360 / 192),
            child: new Text(
              "${double.parse(product[index].discount ?? "").toStringAsFixed(0)} % off",
              style: TextStyle(color: GroceryAppColors.white, fontSize: 10),
            ),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.only(left:30.0,top:3),
        //   child: Text("${double.parse(products1[index].discount).toStringAsFixed(0)} % off",style: TextStyle(color: AppColors.white,fontSize: 12),),
        // ),
      ],
    ),
  );
}

Widget showSticker1(int index, List<Products> product) {
  // double.parse(products1[index].discount)>0?
  return Align(
    alignment: Alignment.topLeft,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
            ),
            color: Colors.green,
          ),
          height: 35,
          width: 60,
          child: Center(
              child: new Text(
            "${double.parse(product[index].discount ?? "").toStringAsFixed(0)} % off",
            style: TextStyle(color: GroceryAppColors.white, fontSize: 10),
          )),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left:30.0,top:3),
        //   child: Text("${double.parse(products1[index].discount).toStringAsFixed(0)} % off",style: TextStyle(color: AppColors.white,fontSize: 12),),
        // ),
      ],
    ),
  );
}

Future groceryCartItemCount(int val) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  pref.setInt("itemCount", val);
  print(val.toString() + "shair....");
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

// Helper function to get category image widget with fallback for grocery app
Widget getGroceryCategoryImageWidget(String? imageUrl,
    {BoxFit fit = BoxFit.fill, double? width, double? height}) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return Image.network(
      GroceryAppConstant.base_url + "manage/uploads/p_category/" + imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return _getGroceryNoImageWidget(width: width, height: height);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _getGroceryNoImageWidget(width: width, height: height);
      },
    );
  } else {
    return _getGroceryNoImageWidget(width: width, height: height);
  }
}

// Helper function for no image widget in grocery app
Widget _getGroceryNoImageWidget({double? width, double? height}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: GroceryAppColors.lightGray.withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.category,
          size: (width != null && width < 60) ? 20 : 40,
          color: GroceryAppColors.darkGray,
        ),
        if (width == null || width >= 60)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "No Image",
              style: TextStyle(
                fontSize: 10,
                color: GroceryAppColors.darkGray,
              ),
            ),
          ),
      ],
    ),
  );
}

// Helper function to get ImageProvider for DecorationImage
ImageProvider getGroceryCategoryImageProvider(String? imageUrl) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return NetworkImage(
      GroceryAppConstant.base_url + "manage/uploads/p_category/" + imageUrl,
    );
  } else {
    return AssetImage("assets/icon/app_logo.png"); // Use app icon as fallback
  }
}

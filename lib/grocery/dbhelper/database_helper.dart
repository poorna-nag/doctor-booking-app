import 'dart:convert';
import 'dart:developer';

import 'package:aladdinmart/model/ShopDModel.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:aladdinmart/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/model/AddressModel.dart';
import 'package:aladdinmart/grocery/model/BlogModel.dart';
import 'package:aladdinmart/grocery/model/CategaryModal.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/grocery/model/CityName.dart';
import 'package:aladdinmart/grocery/model/CoupanModel.dart';
import 'package:aladdinmart/grocery/model/Cuponcode.dart';
import 'package:aladdinmart/grocery/model/CustmerModel.dart';
import 'package:aladdinmart/grocery/model/Gallerymodel.dart';
import 'package:aladdinmart/grocery/model/GroupProducts.dart';
import 'package:aladdinmart/grocery/model/InvoiceTrackmodel.dart';
import 'package:aladdinmart/grocery/model/MyReviewModel.dart';
import 'package:aladdinmart/grocery/model/RegisterModel.dart';
import 'package:aladdinmart/grocery/model/TrackInvoiceModel.dart';
import 'package:aladdinmart/grocery/model/Varient.dart';
import 'package:aladdinmart/grocery/model/aminities_model.dart';
import 'package:aladdinmart/grocery/model/productmodel.dart';
import 'package:aladdinmart/grocery/model/slidermodal.dart';
import 'package:aladdinmart/model/ListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/calculate_distance.dart';

// abstract class ArticleRepository {
//   Future<List<Categary>?> getArticles();
// }
//
// class ArticleRepositoryImpl implements ArticleRepository {
//   String link = Constant.base_url + "manage/api/p_category/all/?X-Api-Key=" +Constant.API_KEY +"&start=0&limit=20&field=shop_id&ield=shop_id&filter=" + Constant.Shop_id + "&parent=0&loc_id= ";
//   @override
//   Future<List<Categary>?> getArticles() async {
//     var response = await http.get(Uri.parse(link));
//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       List<dynamic> galleryArray = responseData["data"]["p_category"];
//       List<Categary> glist = Categary.getListFromJson(galleryArray);
//       return glist;
//     } else {
//       throw Exception();
//     }
//   }
//
// }

Future<ShopDModel?> getShopD() async {
  String link = GroceryAppConstant.base_url +
      "api/cp.php?shop_id=" +
      GroceryAppConstant.Shop_id;
  print(" Slider link" + link);

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    ShopDModel user = ShopDModel.fromJson(jsonDecode(response.body));

    return user;
  }
//    print("List Size: ${list.length}");
}

class DatabaseHelper {
  static Future<List<Categary>?> getData(String id) async {
    String link = GroceryAppConstant.base_url +
        "manage/api/p_category/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&type=1&parent=" +
        id +
        "&loc_id=" +
        GroceryAppConstant.cityid;
    print("cat link----->${link}");

    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["p_category"];
      List<Categary> list = Categary.getListFromJson(galleryArray);
      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Slider1>?> getSlider() async {
    String link = GroceryAppConstant.base_url +
        "manage/api/gallery/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=&field=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&place=appslide";
    print(" Slider link" + link);
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["gallery"];
      List<Slider1> list = Slider1.getListFromJson(galleryArray);

      return list;
    }
  }

  static Future<AmenitiesModel?> getAmenities(String productId) async {
    print('productid--> $productId');
    final url = GroceryAppConstant.base_url +
        'manage/api/custom_fields_value/all/?X-Api-Key=${GroceryAppConstant.API_KEY}&shop_id=${GroceryAppConstant.Shop_id}&product_id=$productId';
    try {
      final response = await http.get(Uri.parse(url));
      print("getAmenities response.statusCode--> ${response.body}");
      print("getAmenities response.statusCode--> ${response.statusCode}");
      if (response.statusCode == 200) {
        AmenitiesModel amenitiesModel = AmenitiesModel();
        final result = json.decode(response.body);
        amenitiesModel = AmenitiesModel.fromJson(result);
        return amenitiesModel;
      }
    } catch (e) {
      log('getAmenities error--> $e');
    }
  }

  static Future<PromotionBanner?> getPromotionBanner(String shop_id) async {
    var body = {"shop_id": GroceryAppConstant.Shop_id};

    final url = 'https://www.bigwelt.com/api/app-promo-banner.php';
    try {
      final response = await http.post(Uri.parse(url), body: body);

      print("getSlider response--> ${response.body}");
      print("getSlider response--> ${response.statusCode}");
      print("getSlider response--> ${json.decode(response.body)}");
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        return PromotionBanner.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to create album.');
      }
    } catch (e, s) {
      print('getSlider error --> e:-$e s:-$s');
    }
  }

  static Future<List<Products>?> getTopProduct(String dil, String lim) async {
    List<Products> getTopProductList = [];
    double radiusv = 0.0;
    double disrv;
    num latv;
    num longv;
    String link = GroceryAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&deals=" +
        dil +
        "&field=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&loc_id=" +
        GroceryAppConstant.cityid;
    print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      //   getTopProductList = [];
      //   for (var i = 0; i < list.length; i++) {
      //     getShopListby(list[i].mv!).then((value) {
      //       radiusv = double.parse(value![0].radius.toString());
      //       latv = num.parse(value[0].lat.toString());
      //       longv = num.parse(value[0].lng.toString());
      //       // log(vendorLat.toString());
      //       // log(vendorLat.toString());
      //       log("radiusDis   radius ${radiusv * 1000}  ");

      //       disrv = CalculateDis().calculateDistance(latv, longv,
      //           GroceryAppConstant.latitude, GroceryAppConstant.longitude);
      //       log("radiusDis afterv calc====>" + disrv.toString());
      //       if (disrv <= radiusv) {
      //         // newList = list;
      //         log("radiusDis   radius  checking called  $i");
      //         getTopProductList.add(list[i]);
      //         log("radiusDis newlist length---------->" +
      //             getTopProductList.length.toString());
      //       } else {
      //         log("radiusDis    missmatch");
      //       }
      //     });
      //   }
      return list;
    }
  }

  static Future<List<Products>?> getTopProductSearch(
      String dil, String lim, String q) async {
    String link = GroceryAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&q=" +
        q +
        "&deals=&field=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&loc_id=" +
        GroceryAppConstant.cityid;
    print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getAllProductSearch(
      String dil, String lim, String q) async {
    String link = GroceryAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&q=" +
        q +
        "&deals=&field=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&loc_id=" +
        GroceryAppConstant.cityid;
    print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getfeature(String dil, String lim) async {
    List<Products> getTopfeatureList = [];
    double radiusv = 0.0;
    double disrv;
    num latv;
    num longv;
    String link = GroceryAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&featured=yes&field=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&loc_id=" +
        GroceryAppConstant.cityid;
    print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      // getTopfeatureList = [];
      // for (var i = 0; i < list.length; i++) {
      //   getShopListby(list[i].mv!).then((value) {
      //     radiusv = double.parse(value![0].radius.toString());
      //     latv = num.parse(value[0].lat.toString());
      //     longv = num.parse(value[0].lng.toString());
      //     // log(vendorLat.toString());
      //     // log(vendorLat.toString());
      //     log("radiusDis   radius ${radiusv * 1000}  ");

      //     disrv = CalculateDis().calculateDistance(latv, longv,
      //         GroceryAppConstant.latitude, GroceryAppConstant.longitude);
      //     log("radiusDis afterv calc====>" + disrv.toString());
      //     if (disrv <= radiusv) {
      //       // newList = list;
      //       log("radiusDis   radius  checking called  $i");
      //       getTopfeatureList.add(list[i]);
      //       log("radiusDis newlist length---------->" +
      //           getTopfeatureList.length.toString());
      //     } else {
      //       log("radiusDis    missmatch");
      //     }
      //   });
      // }
      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getTopProduct1(String dil, String lim) async {
    List<Products> getTopProductList1 = [];
    double radiusv = 0.0;
    double disrv;
    num latv;
    num longv;
    String link = GroceryAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&field=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&sort=DESC&loc_id=" +
        GroceryAppConstant.cityid;
    print("new.........." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      // getTopProductList1 = [];
      // for (var i = 0; i < list.length; i++) {
      //   getShopListby(list[i].mv!).then((value) {
      //     radiusv = double.parse(value![0].radius.toString());
      //     latv = num.parse(value[0].lat.toString());
      //     longv = num.parse(value[0].lng.toString());
      //     // log(vendorLat.toString());
      //     // log(vendorLat.toString());
      //     log("radiusDis   radius ${radiusv * 1000}  ");

      //     disrv = CalculateDis().calculateDistance(latv, longv,
      //         GroceryAppConstant.latitude, GroceryAppConstant.longitude);
      //     log("radiusDis afterv calc====>" + disrv.toString());
      //     if (disrv <= radiusv) {
      //       // newList = list;
      //       log("radiusDis   radius  checking called  $i");
      //       getTopProductList1.add(list[i]);
      //       log("radiusDis newlist length---------->" +
      //           getTopProductList1.length.toString());
      //     } else {
      //       log("radiusDis    missmatch");
      //     }
      //   });
      //  }
      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Gallery>?> getImage(String id) async {
    print("Future id" + id);
    String link = GroceryAppConstant.base_url +
        "manage/api/gallery/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=0&limit=10&place=" +
        id;
//print("Slider"+link);
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["gallery"];
      List<Gallery> glist = Gallery.getListFromJson(galleryArray);

      return glist;
    }
//    print("List Size: ${list.length}");
  }

//  Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=5000&cats=" + pcategoryid + "&field=shop_id&filter=" + Const.Shop_id+"&loc_id="
}

Future<List<Categary>?> get_Category(String val) async {
  // String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  String link = GroceryAppConstant.base_url +
      "manage/api/mv_cats/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=100&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&parent=" +
      val +
      "&loc_id= " +
      GroceryAppConstant.cityid;
  print("cat linl  " + link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(response);
    List<dynamic> galleryArray = responseData["data"]["mv_cats"];
    List<Categary> list = Categary.getListFromJson(galleryArray);

    return list;
  }
}

Future<List<Products>?> getTServicebymv_id(
    String mv_id, String catid, String slim) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=" +
      slim +
      "&limit=100&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&sort=DESC&loc_id=&mv=" +
      mv_id +
      "&cats=" +
      catid;
// +Constant.cityid;
  print("new.........." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];
    List<Products> list = Products.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");
}

Future<List<Categary>?> getData(String id) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/p_category/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&parent=" +
      id +
      "&loc_id=" +
      GroceryAppConstant.cityid +
      "&type=1";
  print("1-------->${link}");
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_category"];

    return Categary.getListFromJson(galleryArray);
    ;
  }
}

Future<List<Products>> catby_productData(String id, String lim) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=" +
      lim +
      "&limit=15&cats=" +
      id +
      "&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&loc_only=" +
      GroceryAppConstant.cityid;

  print('linkcatpro   ${link}');
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
  } else {
    return [];
  }
}
/*Future<List<WalletUser>?> get_walletrecord(String val, int lim) async {
  String link =
      Constant.base_url + "manage/api/wallet_user/all?X-Api-Key=" + Constant.API_KEY + "&start=" + lim.toString() + "&limit=10&w_user=" + val;
  print("This is  sub link" + link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(response);
    List<dynamic> galleryArray = responseData["data"]["wallet_user"];
    List<WalletUser> list = WalletUser.getListFromJson(galleryArray);

    return list;
  }
}*/

Future<List<CustmerModel>?> mywallet(String userid) async {
  print(userid);
//  String link = "http://www.sanjarcreation.com/manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=2345&field=shop_id&filter=49" ;
  String link = GroceryAppConstant.base_url +
      "manage/api/customers/all?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&user_id=" +
      userid +
      "&shop_id=" +
      GroceryAppConstant.Shop_id;
  print("wallet link---->$link");
  final response = await http.get(Uri.parse(link));
  print("response----->${response.body}");
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["customers"];

    return CustmerModel.getListFromJson(galleryArray);
    ;
  }
}

Future<List<CuponCode>?> getCoupanlist() async {
  String link = GroceryAppConstant.base_url +
      "manage/api/coupon_codes/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&shop_id=" +
      GroceryAppConstant.Shop_id +
      "&code=";
//      Constant.base_url + "manage/api/coupon_codes/all/?X-Api-Key=" +
//      Constant.API_KEY + "shop_id=" + Constant.Shop_id +"code="+code;
  print("coupon-----.${link}");
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);

    List<dynamic> galleryArray = responseData["data"]["coupon_codes"];
    List<CuponCode> list = CuponCode.getListFromJson(galleryArray);
    return list;
  }
//    print("List Size: ${list.length}");
}

Future<List<TrackInvoice>?> trackInvoice1(String mobile) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/invoices/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=1&field=client_id&filter=" +
      mobile;
  print(link);

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoices"];
    List<TrackInvoice> list = TrackInvoice.getListFromJson(galleryArray);
    print(list.length);

    return list;
  }
}

Future<List<TrackInvoice>?> trackInvoice(String mobile) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/invoices/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&field=client_id&filter=" +
      mobile;
  print(link);

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoices"];

    return TrackInvoice.getListFromJson(galleryArray);
    ;
  }
}

Future<List<InvoiceInvoice>?> trackInvoiceOrder(String invoice) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/invoice_details/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&field=invoice_id&filter=" +
      invoice;

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoice_details"];

    return InvoiceInvoice.getListFromJson(galleryArray);
    ;
  }
}

Future<List<Products>?> productdetail(String id) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=10&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&id=" +
      id;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
//    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
    ;
  }
}

Future<List<Products>?> search(String query) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=10&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&id=";
  print("Serch  ${link}");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
    ;
  }
}

Future<List<Review>?> myReview(String userid) async {
  print(userid);
//  String link = "http://www.sanjarcreation.com/manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=2345&field=shop_id&filter=49" ;
  String link = GroceryAppConstant.base_url +
      "manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=" +
      userid +
      "&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id;
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
//    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["reviews"];

    return Review.getListFromJson(galleryArray);
    ;
  }
}

Future<List<GroupProducts>?> GroupPro(String userid) async {
  String link = "https://www.bigwelt.com/api/pg.php?id=" +
      userid +
      "&shop_id=" +
      GroceryAppConstant.Shop_id;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<GroupProducts> galleryArray = responseData;
//    GroupProducts  groupProducts= GroupProducts.fromMap(json.decode(response.body));
////    List<dynamic> galleryArray = responseData["data"]["reviews"];
//    print(galleryArray.toString()+"Gallery");
    if (galleryArray == null) {
      return galleryArray;
    } else {
      return GroupProducts.getListFromJson(galleryArray);
    }
  }
}

Future<List<Products>?> searchval(String query) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=50&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&q=" +
      query +
      "&user_id=" +
      GroceryAppConstant.User_ID +
      "&id=";
  print(link);
  List<dynamic> galleryArray;
  final date2 = DateTime.now();
//  String md5=Constant.Shop_id+date2.day.toString()+date2.month.toString()+date2.year.toString();
  String md5 =
      GroceryAppConstant.Shop_id + DateFormat("dd-MM-yyyy").format(date2);

  print(md5);
//  searchdatasave(query);
  generateMd5(md5, query);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
  }
}

searchdatasave(String query, String md5) async {
  String link = GroceryAppConstant.base_url +
      "api/search.php?shop_id=" +
      GroceryAppConstant.Shop_id +
      "&user_id=" +
      GroceryAppConstant.User_ID +
      "&q=" +
      query +
      "&key=" +
      md5;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
//      var responseData = json.decode(response.body);
  }
}

void generateMd5(String input, String q) {
  String key = md5.convert(utf8.encode(input)).toString();
  searchdatasave(q, key);
  print(key);
}

Future<List<Slider1>?> getBanner() async {
  String link = GroceryAppConstant.base_url +
      "manage/api/gallery/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=&field=shop_id&filter=" +
      GroceryAppConstant.Shop_id +
      "&place=appbanner";
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["gallery"];
    List<Slider1> list = Slider1.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");
}

Future<List<UserAddress>?> getAddress() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? userid = pref.getString("user_id");
  String link = GroceryAppConstant.base_url +
      "manage/api/user_address/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=&shop_id=" +
      GroceryAppConstant.Shop_id +
      "&user_id=" +
      userid.toString();
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    print(response.body);
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["user_address"];
//    List<UserAddress> list =

    return UserAddress.getListFromJson(galleryArray);
  }
//    print("List Size: ${list.length}");
}

Future<Coupan?> getCoupan(String code) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/coupon_codes/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&shop_id=" +
      GroceryAppConstant.Shop_id +
      "&code=" +
      code;
//      Constant.base_url + "manage/api/coupon_codes/all/?X-Api-Key=" +
//      Constant.API_KEY + "shop_id=" + Constant.Shop_id +"code="+code;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    Coupan coupan = Coupan.fromMap(json.decode(response.body));
    return coupan;
  }
//    print("List Size: ${list.length}");
}

Future<List<PVariant>?> getPvarient(String id) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/p_variant/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=100&pid=" +
      id;
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_variant"];
    List<PVariant> list = PVariant.getListFromJson(galleryArray);

    return list;
  }
}

Future<List<CityName>?> getPcity() async {
  String link = GroceryAppConstant.base_url +
      'manage/api/mv_delivery_locations/all/?X-Api-Key=' +
      GroceryAppConstant.API_KEY +
      '&field=shop_id&filter=' +
      GroceryAppConstant.Shop_id;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_delivery_locations"];
    List<CityName> list = CityName.getListFromJson(galleryArray);

    return list;
  }
}

Future<List<BlogModel>?> getfeature(String dil, String lim) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/manage_pages/all?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=" +
      lim +
      "&wht=blog&shop_id=" +
      GroceryAppConstant.Shop_id +
      "&place=publish&type=";
  print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["manage_pages"];
    List<BlogModel> list = BlogModel.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");
}

Future<List<BlogModel>?> searchBlogs(String q, String lim) async {
  String link = GroceryAppConstant.base_url +
      "manage/api/manage_pages/all?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=" +
      lim +
      "&wht=blog&shop_id=" +
      GroceryAppConstant.Shop_id +
      "&place=publish&type=&q=" +
      q;
  print("${q} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["manage_pages"];
    List<BlogModel> list = BlogModel.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");
}

Future<List<ListModel>?> getMV() async {
  String link = GroceryAppConstant.base_url +
      "manage/api/mv_list/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=100" +
      "&shop_id=" +
      GroceryAppConstant.Shop_id;
  log(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    log(response.body.toString());
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_list"];
    // List<dynamic> galleryArray = responseData["List"];
    List<ListModel> list = ListModel.getListFromJson(galleryArray);
    print("!!!--- VENDOR LIST ---!!! $list");
    return list;
  }
}

Future updateAny(String table, String field, String value) async {
  print(field);
  print(value);
  print(GroceryAppConstant.user_id);
  SharedPreferences pref = await SharedPreferences.getInstance();

  final userId = pref.get("user_id");
  print(userId);

  var map = new Map<String, dynamic>();
  map['Api_key'] = GroceryAppConstant.API_KEY;
  map['shop_id'] = GroceryAppConstant.Shop_id;
  map['table'] = table;
  map['id_name'] = "user_id";
  map['id_no'] = GroceryAppConstant.user_id;
  map['field'] = field;
  map['value'] = value;
  String link = GroceryAppConstant.base_url + "api/upany";
  print(link);
  // print(map.toString());
  final response = await http.post(Uri.parse(link), body: map);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
    print(jsonDecode(response.body));
    if (user.success == "true") showLongToast(user.message.toString());
  }
}

Future<List<ListModel>?> getShopListby(String mvid) async {
  // String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  String link = GroceryAppConstant.base_url +
      "manage/api/mv_list/all/?X-Api-Key=" +
      GroceryAppConstant.API_KEY +
      "&start=0&limit=100&shop_id=" +
      GroceryAppConstant.Shop_id +
      "&mv_id=" +
      mvid;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_list"];
    // ListModel list = ListModel.fromJSON(responseData);
    List<ListModel> list = ListModel.getListFromJson(galleryArray);
    print(list);

    return list;
  }
}

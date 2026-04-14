import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:ecoshine24/General/AppConstant.dart';
// import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/RegisterModel.dart';
import 'package:ecoshine24/model/AddressModel.dart';
import 'package:ecoshine24/model/CategaryModal.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ecoshine24/model/CityName.dart';
import 'package:ecoshine24/model/CoupanModel.dart';
import 'package:ecoshine24/model/Cuponcode.dart';
import 'package:ecoshine24/model/CustmerModel.dart';
import 'package:ecoshine24/model/Gallerymodel.dart';
import 'package:ecoshine24/model/GroupProducts.dart';
import 'package:ecoshine24/model/InvoiceTrackmodel.dart';
import 'package:ecoshine24/model/ListModel.dart';
import 'package:ecoshine24/model/MyReviewModel.dart';
import 'package:ecoshine24/model/ShopDModel.dart';
import 'package:ecoshine24/model/TrackInvoiceModel.dart';
import 'package:ecoshine24/model/Varient.dart';
import 'package:ecoshine24/model/banktransation.dart';
import 'package:ecoshine24/model/productmodel.dart';
import 'package:ecoshine24/model/promotion_banner_model.dart';
import 'package:ecoshine24/model/slidermodal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticleRepository {
  Future<List<Categary>?> getArticles();
}

class ArticleRepositoryImpl implements ArticleRepository {
  String link = FoodAppConstant.base_url +
      "manage/api/p_category/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&parent=0&loc_id=" +
      FoodAppConstant.cityid;
  @override
  Future<List<Categary>?> getArticles() async {
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["p_category"];
      List<Categary> glist = Categary.getListFromJson(galleryArray);
      return glist;
    } else {
      throw Exception();
    }
  }
}

class DatabaseHelper {
  static Future<List<Categary>?> getData(String id) async {
    print(FoodAppConstant.cityid);
    String link = FoodAppConstant.base_url +
        "manage/api/p_category/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&start=0&limit=20&field=shop_id&filter=" +
        FoodAppConstant.Shop_id +
        "&parent=" +
        id +
        "&loc_id=" +
        FoodAppConstant.cityid;
    print("P_category link------>?>>?>>$link");

    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["p_category"];
      List<Categary> list = Categary.getListFromJson(galleryArray);

      return list;
    }
    return null;
//    print("List Size: ${list.length}");
  }

  static Future<PromotionBanner?> getPromotionBanner(String shop_id) async {
    var body = {"shop_id": FoodAppConstant.Shop_id};

    final url = '${FoodAppConstant.base_url}api/app-promo-banner.php';
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
    return null;
  }

  static Future<List<Slider1>?> getSlider() async {
    String link = FoodAppConstant.base_url +
        "manage/api/gallery/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&start=0&limit=&field=shop_id&filter=" +
        FoodAppConstant.Shop_id +
        "&place=appslide";
    print(" Slider link" + link);

    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["gallery"];
      List<Slider1> list = Slider1.getListFromJson(galleryArray);

      return list;
    }
    return null;
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getTopProduct(String dil, String lim) async {
    String link = FoodAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&start=" +
        lim +
        "&limit=10&deals=" +
        dil +
        "&field=shop_id&filter=" +
        FoodAppConstant.Shop_id +
        "&loc_id=" +
        FoodAppConstant.cityid;
    print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
    return null;
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getCategoryWiseProducts(
      String dil, String lim) async {
    String link = FoodAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&start=" +
        lim +
        "&limit=1000&deals=" +
        dil +
        "&field=shop_id&filter=" +
        FoodAppConstant.Shop_id +
        "&loc_id=" +
        FoodAppConstant.cityid;
    print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
    return null;
//    print("List Size: ${list.length}");
  }

  Future updateAny(String table, String field, String value) async {
    print(field);
    print(value);
    var map = new Map<String, dynamic>();
    map['Api_key'] = FoodAppConstant.API_KEY;
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['table'] = table;
    map['id_name'] = "user_id";
    map['id_no'] = FoodAppConstant.user_id;
    map['field'] = field;
    map['value'] = value;
    String link = FoodAppConstant.base_url + "api/upany";
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

  static Future<List<Products>?> getfeature(String dil, String lim) async {
    String link = FoodAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&start=0&limit=" +
        lim +
        dil +
        "&field=shop_id&filter=" +
        FoodAppConstant.Shop_id +
        "&loc_id=" +
        FoodAppConstant.cityid;
    print("${dil} ...." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
    return null;
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getNewArrivals() async {
    String link = FoodAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&start=0&limit=1000&field=shop_id&filter=" +
        FoodAppConstant.Shop_id +
        "&loc_id=" +
        FoodAppConstant.cityid;
    print("NEW......" + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
    return null;
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getTopProduct1(String dil, String lim) async {
    String link = FoodAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&start=" +
        lim +
        "&limit=10&field=shop_id&filter=" +
        FoodAppConstant.Shop_id +
        "&sort=DESC&loc_id=" +
        FoodAppConstant.cityid;
    print("new.........." + link);

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
    return null;
//    print("List Size: ${list.length}");
  }

  static Future<List<Gallery>?> getImage(String id) async {
    print("Future id" + id);
    String link = FoodAppConstant.base_url +
        "manage/api/gallery/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
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
    return null;
//    print("List Size: ${list.length}");
  }

//  Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=5000&cats=" + pcategoryid + "&field=shop_id&filter=" + Const.Shop_id+"&loc_id="
}

Future<List<Categary>?> getData(String id) async {
  String link = FoodAppConstant.base_url +
      "manage/api/p_category/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&parent=" +
      id +
      "&loc_id=" +
      FoodAppConstant.cityid;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_category"];

    return Categary.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<Products>?> catby_productData(
    String id, String lim, String mvid) async {
  String link = FoodAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=" +
      lim +
      "&limit=10&cats=" +
      id +
      "&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&loc_id=" +
      FoodAppConstant.cityid +
      "&mv=" +
      mvid;

  print('linkcatpro   ${link}');
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<TrackInvoice>?> trackInvoice(String mobile) async {
  String link = FoodAppConstant.base_url +
      "manage/api/invoices/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&field=client_id&filter=" +
      mobile;
  print("orderlink---->${link}");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoices"];

    return TrackInvoice.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<InvoiceInvoice>?> trackInvoiceOrder(String invoice) async {
  String link = FoodAppConstant.base_url +
      "manage/api/invoice_details/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=100&field=invoice_id&filter=" +
      invoice;

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoice_details"];

    return InvoiceInvoice.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<Products>?> productdetail(String id) async {
  String link = FoodAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=10&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
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
  return null;
}

Future<List<Products>?> search(String query, String mvid) async {
  String link = FoodAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=10&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&id=&mv=" +
      mvid +
      "&loc_id=" +
      FoodAppConstant.cityid;
  print("Serch123  ${link}");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<Review>?> myReview(String userid) async {
  print(userid);
//  String link = "http://www.sanjarcreation.com/manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=2345&field=shop_id&filter=49" ;
  String link = FoodAppConstant.base_url +
      "manage/api/reviews/all?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&user_id=" +
      userid +
      "&field=shop_id&filter=" +
      FoodAppConstant.Shop_id;
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
//    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["reviews"];

    return Review.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<GroupProducts>?> GroupPro(String userid) async {
  try {
    // Check if userid is valid
    if (userid.isEmpty) {
      print("Error: User ID is empty for GroupPro");
      return [];
    }

    String link = "https://www.bigwelt.com/api/pg.php?id=" +
        userid +
        "&shop_id=" +
        FoodAppConstant.Shop_id;
    print(link);

    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      // Check if responseData is valid and is a list
      if (responseData != null) {
        if (responseData is List) {
          return GroupProducts.getListFromJson(responseData);
        } else {
          print(
              "Error: GroupPro response is not a list: ${responseData.runtimeType}");
          return [];
        }
      } else {
        print("Error: GroupPro response data is null");
        return [];
      }
    } else {
      print(
          "Error: GroupPro HTTP ${response.statusCode} - ${response.reasonPhrase}");
      return [];
    }
  } catch (e) {
    print("Error in GroupPro: $e");
    return [];
  }
}

Future<List<Products>?> searchval(String query, String mvid) async {
  String link = FoodAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=50&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&q=" +
      query +
      "&user_id=" +
      FoodAppConstant.User_ID +
      "&id=&mv=" +
      mvid;
  print(link);
  List<dynamic> galleryArray;
  final date2 = DateTime.now();
//  String md5=Constant.Shop_id+date2.day.toString()+date2.month.toString()+date2.year.toString();
  String md5 = FoodAppConstant.Shop_id + DateFormat("dd-MM-yyyy").format(date2);
  print(md5);
//  searchdatasave(query);
  generateMd5(md5, query);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
  }
  return null;
}

searchdatasave(String query, String md5) async {
  String link = FoodAppConstant.base_url +
      "api/search.php?shop_id=" +
      FoodAppConstant.Shop_id +
      "&user_id=" +
      FoodAppConstant.User_ID +
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
  String link = FoodAppConstant.base_url +
      "manage/api/gallery/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&place=appbanner";
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["gallery"];
    List<Slider1> list = Slider1.getListFromJson(galleryArray);

    return list;
  }
  return null;
//    print("List Size: ${list.length}");
}

Future<List<UserAddress>?> getAddress() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? userid = pref.getString("user_id");
  String link = FoodAppConstant.base_url +
      "manage/api/user_address/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=&shop_id=" +
      FoodAppConstant.Shop_id +
      "&user_id=" +
      userid.toString();
  print('Address get  ${link}');
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    print(response.body);
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["user_address"];
//    List<UserAddress> list =

    return UserAddress.getListFromJson(galleryArray);
  }
  return null;
//    print("List Size: ${list.length}");
}

Future<Coupan?> getCoupan(String code) async {
  String link = FoodAppConstant.base_url +
      "manage/api/coupon_codes/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&shop_id=" +
      FoodAppConstant.Shop_id +
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
  return null;
//    print("List Size: ${list.length}");
}

Future<List<PVariant>?> getPvarient(String id) async {
  String link = FoodAppConstant.base_url +
      "manage/api/p_variant/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=100&pid=" +
      id;
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_variant"];
    List<PVariant> list = PVariant.getListFromJson(galleryArray);

    return list;
  }
  return null;
}

Future<List<CityName>?> getPcity() async {
  String link = FoodAppConstant.base_url +
      'manage/api/mv_delivery_locations/all/?X-Api-Key=' +
      FoodAppConstant.API_KEY +
      '&field=shop_id&filter=' +
      FoodAppConstant.Shop_id;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_delivery_locations"];
    List<CityName> list = CityName.getListFromJson(galleryArray);

    return list;
  }
  return null;
}

// Behlf of lat long get mv list
Future<List<ListModel>?> getShopList(String rad) async {
  // String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  String link = FoodAppConstant.base_url +
      "api/mv_list?shop_id=" +
      FoodAppConstant.Shop_id +
      "&lat=" +
      FoodAppConstant.latitude.toString() +
      "&lng=" +
      FoodAppConstant.longitude.toString() +
      "&rad=" +
      rad +
      "&q=";
  print("Shoplist");
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["List"];
    List<ListModel> list = ListModel.getListFromJson(galleryArray);

    return list;
  }
  return null;
}

List<ListModel> newList = [];
Future<List<ListModel>> getShopListByCat(
    int lim, String rad, String catid) async {
  // String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  String link = FoodAppConstant.base_url +
      "api/mv_list?shop_id=" +
      FoodAppConstant.Shop_id +
      "&start=" +
      lim.toString() +
      "&limit=10&lat=" +
      FoodAppConstant.latitude.toString() +
      "&lng=" +
      FoodAppConstant.longitude.toString() +
      "&rad=" +
      rad +
      "&q=&mv_cat=" +
      catid;
  print("Shoplist");
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    print(response.body);
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["List"];
    List<ListModel> list = ListModel.getListFromJson(galleryArray);

    //   newList = [];
    // for (var i = 0; i < list.length; i++) {
    //   double vendorRadius = double.parse(list[i].radius.toString());
    //   num vendorLat = num.parse(list[i].lat.toString());
    //   num vendorLong = num.parse(list[i].lng.toString());
    //   log("radiusDis   lat ${vendorLat}  ");
    //   log("radiusDis   long ${vendorLong}  ");
    //   // log("radiusDis   radius ${vendorRadius * 1000}  ");
    //   log("radiusDis   long ${g.GroceryAppConstant.longitude}  ");
    //   log("radiusDis   radius ${vendorRadius}  ");

    //   double disRadius = CalculateDis().calculateDistance(
    //       vendorLat, vendorLong, g.GroceryAppConstant.latitude, g.GroceryAppConstant.longitude);
    //   log("radiusDis afterv calc====>" + disRadius.toString());

    //   if (disRadius <= vendorRadius) {
    //     // newList = list;
    //     log("radiusDis   radius  checking called  $i");
    //     newList.add(list[i]);
    //     log("radiusDis     newlist    " + newList.length.toString());
    //   } else {
    //     log("radiusDis    missmatch");
    //   }
    // }
    return list;
  } else {
    return [];
  }
}

Future<List<ListModel>?> getAllMv(int lim) async {
  String link = FoodAppConstant.base_url +
      "manage/api/mv_list/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=" +
      lim.toString() +
      "&limit=10" +
      "&shop_id=" +
      FoodAppConstant.Shop_id +
      "&q=&state=&loc_id=" +
      FoodAppConstant.cityid;

  // String link = Constant.base_url+"api/mv_list?shop_id="+Constant.Shop_id+"&start="+lim.toString()+"&limit=10&shop_id="+  Constant.Shop_id+"&q=&state=&city="+Constant.cityid;
  print("Shoplist");
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData['data']["mv_list"];
    List<ListModel> list = ListModel.getListFromJson(galleryArray);

    return list;
  }
  return null;
}

Future<List<ListModel>?> getShopList1(int slim, String city) async {
  String link = FoodAppConstant.base_url +
      "manage/api/mv_list/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=${slim}&limit=1000" +
      "&shop_id=" +
      FoodAppConstant.Shop_id +
      "&q=&state=&city=" +
      city;
  print("vendor link----->${link}");
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_list"];
    // List<dynamic> galleryArray = responseData["List"];
    List<ListModel> list = ListModel.getListFromJson(galleryArray);
    return list;
  }
  return null;
}

Future<List<ListModel>?> getShopList1ByMV(String mv) async {
  String link = FoodAppConstant.base_url +
      "manage/api/mv_list/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=1" +
      "&shop_id=" +
      FoodAppConstant.Shop_id +
      "&q=&state=&mv_id=" +
      mv;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_list"];
    // List<dynamic> galleryArray = responseData["List"];
    List<ListModel> list = ListModel.getListFromJson(galleryArray);
    return list;
  }
  return null;
}

Future<List<Products>?> getAllProducts(String lim) async {
  String link = FoodAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=" +
      lim +
      "&limit=10&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&loc_id= " +
      FoodAppConstant.cityid;
  print("Serch  ${link}");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<ShopDModel?> getShopD() async {
  String link = FoodAppConstant.base_url +
      "api/cp.php?shop_id=" +
      FoodAppConstant.Shop_id;
  print(" Slider link" + link);

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    ShopDModel user = ShopDModel.fromJson(jsonDecode(response.body));

    return user;
  }
  return null;
//    print("List Size: ${list.length}");
}

Future<List<WalletUser>> get_walletrecord(String val, int lim) async {
  String link = FoodAppConstant.base_url +
      "manage/api/wallet_user/all?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=" +
      lim.toString() +
      "&limit=10&w_user=" +
      val;
  print("This is  sub link" + link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(response);
    List<dynamic> galleryArray = responseData["data"]["wallet_user"];
    List<WalletUser> list = WalletUser.getListFromJson(galleryArray);

    return list;
  } else {
    return [];
  }
}

Future<List<CustmerModel>?> mywallet(String userid) async {
  print(userid);
//  String link = "http://www.sanjarcreation.com/manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=2345&field=shop_id&filter=49" ;
  String link = FoodAppConstant.base_url +
      "manage/api/customers/all?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&user_id=" +
      userid +
      "&shop_id=" +
      FoodAppConstant.Shop_id;
  log("wallet link---->$link");
  final response = await http.get(Uri.parse(link));
  print("response----->${response.body}");
  if (response.statusCode == 200) {
    log(response.body.toString());
    var responseData = json.decode(response.body);
    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["customers"];

    return CustmerModel.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<Categary>?> get_Category(String val) async {
  // String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  String link = FoodAppConstant.base_url +
      "manage/api/mv_cats/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=100&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&parent=" +
      val +
      "&loc_id= " +
      FoodAppConstant.cityid;
  print("cat linl  " + link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    log(response.body.toString());
    List<dynamic> galleryArray = responseData["data"]["mv_cats"];
    List<Categary> list = Categary.getListFromJson(galleryArray);

    return list;
  }
  return null;
}

Future<List<Slider1>?> getSliderforMedicalShop(String mvid) async {
  String link = FoodAppConstant.base_url +
      "manage/api/gallery/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
      "&place=mv&title=" +
      mvid;
  print(" Slider link" + link);

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["gallery"];
    List<Slider1> list = Slider1.getListFromJson(galleryArray);

    return list;
  }
  return null;
}

Future<List<Categary>?> get_CategoryBYMv(String val) async {
  // String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  String link = FoodAppConstant.base_url +
      "api/mv_pro_cats?shop_id=" +
      FoodAppConstant.Shop_id +
      "&mv=" +
      val;
  print("This is  sub link" + link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    log(response.body.toString());
    List<dynamic> galleryArray = responseData["Cats"];
    List<Categary> list = Categary.getListFromJson(galleryArray);

    return list;
  }
  return null;
}

Future<List<Products>?> getTServicebymv_id(
    String mv_id, String catid, String slim) async {
  String link = FoodAppConstant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=" +
      slim +
      "&limit=100&field=shop_id&filter=" +
      FoodAppConstant.Shop_id +
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
  return null;
//    print("List Size: ${list.length}");
}

Future<List<ListModel>?> searchvender(String query, String rad) async {
  String link = FoodAppConstant.base_url +
      "api/mv_list?shop_id=" +
      FoodAppConstant.Shop_id +
      "&lat=" +
      FoodAppConstant.latitude.toString() +
      "&lng=" +
      FoodAppConstant.longitude.toString() +
      "&rad=" +
      rad +
      "&q=";
  print("Serch  ${link}");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["List"];

    return ListModel.getListFromJson(galleryArray);
    ;
  }
  return null;
}

Future<List<TrackInvoice>?> trackInvoice1(String mobile) async {
  String link = FoodAppConstant.base_url +
      "manage/api/invoices/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
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
  return null;
}

Future<List<CuponCode>?> getCoupanlist() async {
  String link = FoodAppConstant.base_url +
      "manage/api/coupon_codes/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&shop_id=" +
      FoodAppConstant.Shop_id +
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
  return null;
//    print("List Size: ${list.length}");
}

SharedPreferences? pre;
Future<List<ListModel>?> IndiVisualvenderDetails() async {
  pre = await SharedPreferences.getInstance();

  String link = FoodAppConstant.base_url +
      "manage/api/mv_list/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=10&shop_id=" +
      FoodAppConstant.Shop_id.toString() +
      "&mv_id=" +
      pre!.getString("mvid").toString();
  print("Serch  ${link}");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_list"];

    return ListModel.getListFromJson(galleryArray);
  }
  return null;
}

Future<List<ListModel>?> getShopListby(String mvid) async {
  // String link =Constant.base_url+'manage/api/mv_delivery_locations/all/?X-Api-Key='+Constant.API_KEY+'&field=shop_id&filter='+Constant.Shop_id;
  String link = FoodAppConstant.base_url +
      "manage/api/mv_list/all/?X-Api-Key=" +
      FoodAppConstant.API_KEY +
      "&start=0&limit=100&shop_id=" +
      FoodAppConstant.Shop_id +
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
  return null;
}

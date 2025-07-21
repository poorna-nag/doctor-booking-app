// To parse this JSON data, do
//
//     final groupProducts = groupProductsFromMap(jsonString);

import 'dart:convert';

List<GroupProducts> groupProductsFromMap(String str) => List<GroupProducts>.from(json.decode(str).map((x) => GroupProducts.fromMap(x)));

String groupProductsToMap(List<GroupProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GroupProducts {
  GroupProducts(
      {
    this.productIs,
    this.productName,
    this.img,
    this.name,
  });

  String? productIs;
  String? productName;
  String? img;
  String? name;

  factory GroupProducts.fromMap(Map<String, dynamic> json) => GroupProducts(
    productIs: json["product_is"],
    productName: json["productName"],
    img: json["img"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "product_is": productIs,
    "productName": productName,
    "name": name,
  };

  static List<GroupProducts> getListFromJson(List<dynamic> list) {
    List<GroupProducts> unitList =[];
    list.forEach((unit) => unitList.add(GroupProducts.fromMap(unit)));
    return unitList;
  }
}



//class GroupProducts {
//  String product_is;
//  String productName;
//  String img;
//
//  GroupProducts(
//  this.product_is,
//  this.productName,
//  this.img);
//
//}
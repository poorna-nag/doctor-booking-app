import 'package:flutter/cupertino.dart';

class Products {
  String? productIs;
  String? productCode;
  String? productName;
  String? productLine;
  String? productLineParent;
  String? productScale;
  String? productVendor;
  String? productDescription;
  String? quantityInStock;
  String? buyPrice;
  String? msrp;
  String? shopId;
  String? discount;
  String? cgst;
  String? sgst;
  String? costPrice;
  String? stock;
  String? productColor;
  String? featured;
  String? deals;
  String? variant;
  String? imgSelect;
  String? cancels;
  String? warrantys;
  String? returns;
  String? youtube;
  String? image;
  String? img;
  String? HSN;
  String? APMC;
  String? shipping;
  String? count;
  String? p_id;
  String? mv;
  String? moq;
  String? name;

  Products(
      {this.productIs,
      this.productCode,
      this.productName,
      this.productLine,
      this.productLineParent,
      this.productScale,
      this.productVendor,
      this.productDescription,
      this.quantityInStock,
      this.buyPrice,
      this.msrp,
      this.shopId,
      this.discount,
      this.cgst,
      this.sgst,
      this.costPrice,
      this.stock,
      this.image,
      this.productColor,
      this.featured,
      this.deals,
      this.variant,
      this.imgSelect,
      this.cancels,
      this.warrantys,
      this.returns,
      this.youtube,
      this.img,
      this.HSN,
      this.APMC,
      this.shipping,
      this.count,
      this.p_id,
      this.mv,
      this.moq,
      this.name});

//  int get count=>this.count;
//  set count(int count){
//    this.count=count;
//  }

  factory Products.fromJSON(Map<String, dynamic> json) {
    return Products(
        productIs: json["product_is"],
        productCode: json["productCode"],
        productName: json["productName"],
        productLine: json["productLine"],
        productLineParent: json["productLineParent"],
        productScale: json["productScale"],
        productVendor: json["productVendor"],
        productDescription: json["productDescription"],
        quantityInStock: json["quantityInStock"],
        buyPrice: json["buyPrice"],
        msrp: json["MSRP"],
        shopId: json["shop_id"],
        discount: json["discount"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        costPrice: json["cost_price"],
        stock: json["stock"],
        image: json["image"],
        productColor: json["productColor"],
        featured: json["featured"],
        deals: json["deals"],
        variant: json["variant"],
        imgSelect: json["img_select"],
        cancels: json["cancels"],
        warrantys: json["warrantys"],
        returns: json["returns"],
        youtube: json["youtube"],
        img: json["img"],
        HSN: json["HSN"],
        APMC: json["APMC"],
        shipping: json["shipping"],
        count: json["count"],
        p_id: json["p_id"],
        mv: json["mv"],
        moq: json["moq"],
        name: json["name"]);
  }

  static List<Products> getListFromJson(List<dynamic> list) {
    List<Products> unitList = [];
    list.forEach((unit) => unitList.add(Products.fromJSON(unit)));
    return unitList;
  }
}

// To parse this JSON data, do
//
//     final coupan = coupanFromMap(jsonString);

import 'dart:convert';

Coupan coupanFromMap(String str) => Coupan.fromMap(json.decode(str));

String coupanToMap(Coupan data) => json.encode(data.toMap());

class Coupan {
  Coupan({
    this.status,
    this.message,
    this.data,
    this.total,
  });

  String? status;
  String? message;
  Data? data;
  int? total;

  factory Coupan.fromMap(Map<String, dynamic> json) => Coupan(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data!.toMap(),
        "total": total,
      };
}

class Data {
  Data({
    this.couponCodes,
  });

  List<CouponCode>? couponCodes;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        couponCodes: List<CouponCode>.from(
            json["coupon_codes"].map((x) => CouponCode.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "coupon_codes": List<dynamic>.from(couponCodes!.map((x) => x.toMap())),
      };
}

class CouponCode {
  CouponCode({
    this.ccId,
    this.code,
    this.productId,
    this.userId,
    this.categoryId,
    this.shopId,
    this.type,
    this.val,
    this.maxVal,
    this.xdate,
    this.addedOn,
    this.minVal,
    this.fortype,
    this.pro_id,
    this.mv_id,
  });

  String? ccId;
  String? code;
  String? productId;
  String? userId;
  String? categoryId;
  String? shopId;
  String? type;
  String? val;
  String? maxVal;
  String? xdate;
  String? addedOn;
  String? minVal;
  String? fortype;
  String? pro_id;
  String? mv_id;

  factory CouponCode.fromMap(Map<String, dynamic> json) => CouponCode(
        ccId: json["cc_id"],
        code: json["code"],
        productId: json["product_id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        shopId: json["shop_id"],
        type: json["type"],
        val: json["val"],
        maxVal: json["maxVal"],
        xdate: json["xdate"],
        addedOn: json["added_on"],
        minVal: json["minVal"],
        fortype: json["for"],
        pro_id: json["pro_id"],
        mv_id: json["mv_id"],
      );

  Map<String, dynamic> toMap() => {
        "cc_id": ccId,
        "code": code,
        "product_id": productId,
        "user_id": userId,
        "category_id": categoryId,
        "shop_id": shopId,
        "type": type,
        "val": val,
        "maxVal": maxVal,
        "xdate": xdate,
        "added_on": addedOn,
        "minVal": minVal,
        "for": fortype,
        "pro_id": pro_id,
        "mv_id": mv_id,
      };
}

// To parse this JSON data, do
//
//     final ShopDModel = ShopDModelFromJson(jsonString);

import 'dart:convert';

ShopDModel ShopDModelFromJson(String str) =>
    ShopDModel.fromJson(json.decode(str));

String ShopDModelToJson(ShopDModel data) => json.encode(data.toJson());

class ShopDModel {
  ShopDModel({
    this.success,
    this.name,
    this.img,
    this.city,
    this.cat,
    this.star,
    this.today,
    this.month,
    this.products,
    this.categories,
    this.users,
    this.sms,
    this.pages,
    this.blogs,
    this.images,
    this.leads,
    this.reviews,
    this.faq,
    this.address,
    this.contactPerson,
    this.pincode,
    this.description,
    this.mobileNo,
    this.emailId,
    this.upi,
    this.f,
    this.t,
    this.i,
    this.w,
    this.l,
  });

  String? success;
  String? name;
  String? img;
  String? city;
  String? cat;
  String? star;
  String? today;
  String? month;
  String? products;
  String? categories;
  String? users;
  String? sms;
  String? pages;
  String? blogs;
  String? images;
  String? leads;
  String? reviews;
  String? faq;
  String? address;
  String? contactPerson;
  String? pincode;
  String? description;
  String? mobileNo;
  String? emailId;
  String? upi;
  String? f;
  String? t;
  String? i;
  String? w;
  String? l;

  factory ShopDModel.fromJson(Map<String, dynamic> json) => ShopDModel(
        success: json["success"],
        name: json["name"],
        img: json["img"],
        city: json["city"],
        cat: json["cat"],
        star: json["star"],
        today: json["today"],
        month: json["month"],
        products: json["products"],
        categories: json["categories"],
        users: json["users"],
        sms: json["sms"],
        pages: json["pages"],
        blogs: json["blogs"],
        images: json["images"],
        leads: json["leads"],
        reviews: json["reviews"],
        faq: json["faq"],
        address: json["address"],
        contactPerson: json["contact_person"],
        pincode: json["pincode"],
        description: json["description"],
        mobileNo: json["mobile_no"],
        emailId: json["email_id"],
        upi: json["upi"],
        f: json["f"],
        t: json["t"],
        i: json["i"],
        w: json["w"],
        l: json["l"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "name": name,
        "img": img,
        "city": city,
        "cat": cat,
        "star": star,
        "today": today,
        "month": month,
        "products": products,
        "categories": categories,
        "users": users,
        "sms": sms,
        "pages": pages,
        "blogs": blogs,
        "images": images,
        "leads": leads,
        "reviews": reviews,
        "faq": faq,
        "address": address,
        "contact_person": contactPerson,
        "pincode": pincode,
        "description": description,
        "mobile_no": mobileNo,
        "email_id": emailId,
        "upi": upi,
      };
}

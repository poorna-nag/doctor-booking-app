import 'package:flutter/cupertino.dart';

class BlogModel {
  String? pageId;
  String? shopId;
  String? url;
  String? menuName;
  String? hideMenu;
  String? place;
  String? pageName;
  String? title;
  String? heading;
  String? bodytext;
  String? bodytext2;
  String? image;
  String? parent;
  String? sort;
  String? addedOn;
  String? updated;
  String? userIp;
  String? counts;
  String? wht;
  String? icon;
  String? youtube;
  String? keywords;
  String? sectionCss;
  String? mainCss;
  String? its;

  BlogModel({
    this.pageId,
    this.shopId,
    this.url,
    this.menuName,
    this.hideMenu,
    this.place,
    this.pageName,
    this.title,
    this.heading,
    this.bodytext,
    this.bodytext2,
    this.image,
    this.parent,
    this.sort,
    this.addedOn,
    this.updated,
    this.userIp,
    this.counts,
    this.wht,
    this.icon,
    this.youtube,
    this.keywords,
    this.sectionCss,
    this.mainCss,
    this.its,
  });

//  int get count=>this.count;
//  set count(int count){
//    this.count=count;
//  }

  factory BlogModel.fromJSON(Map<String, dynamic> json) {
    return BlogModel(
      pageId: json["page_id"],
      shopId: json["shop_id"],
      url: json["url"],
      menuName: json["menu_name"],
      hideMenu: json["hide_menu"],
      place: json["place"],
      pageName: json["page_name"],
      title: json["title"],
      heading: json["heading"],
      bodytext: json["bodytext"],
      bodytext2: json["bodytext_2"],
      image: json["image"],
      parent: json["parent"],
      sort: json["sort"],
      addedOn: json["added_on"],
      updated: json["updated"],
      userIp: json["user_ip"],
      counts: json["counts"],
      wht: json["wht"],
      icon: json["icon"],
      youtube: json["youtube"],
      keywords: json["keywords"],
      sectionCss: json["sectionCss"],
      mainCss: json["mainCss"],
      its: json["its"],
    );
  }

  static List<BlogModel> getListFromJson(List<dynamic> list) {
    List<BlogModel> unitList =[];
    list.forEach((unit) => unitList.add(BlogModel.fromJSON(unit)));
    return unitList;
  }
}

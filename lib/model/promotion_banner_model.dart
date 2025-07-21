class PromotionBanner {
  String? shopId;
  String? images;
  bool? status;
  String? msg;
  String? path;

  PromotionBanner({this.shopId, this.images, this.status, this.msg, this.path});

  PromotionBanner.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    images = json['images'];
    status = json['status'];
    msg = json['msg'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shop_id'] = shopId;
    data['images'] = images;
    data['status'] = status;
    data['msg'] = msg;
    data['path'] = path;
    return data;
  }
}


class ShowOrderDetail {
  String? subId;
  String? invId;
  String? productId;
  String? variant;
  String? product;
  String? userId;
  String? subDate;
  String? addedOn;
  String? totalSub;
  String? mvId;
  String? shopId;
  String? sub_status;

  ShowOrderDetail({
    this.subId,
    this.invId,
    this.productId,
    this.variant,
    this.product,
    this.userId,
    this.subDate,
    this.addedOn,
    this.totalSub,
    this.mvId,
    this.shopId,
    this.sub_status,
  });

//  int get count=>this.count;
//  set count(int count){
//    this.count=count;
//  }

  factory ShowOrderDetail.fromJSON(Map<String, dynamic> json) {
    return ShowOrderDetail(
      subId: json["sub_id"],
      invId: json["inv_id"],
      productId: json["product_id"],
      variant: json["variant"],
      product: json["product"],
      userId: json["user_id"],
      subDate: json["sub_date"],
      addedOn: json["added_on"],
      totalSub: json["total_sub"],
      mvId: json["mv_id"],
      shopId: json["shop_id"],
      sub_status: json["sub_status"],
    );
  }

  static List<ShowOrderDetail> getListFromJson(List<dynamic> list) {
    List<ShowOrderDetail> unitList = [];
    list.forEach((unit) => unitList.add(ShowOrderDetail.fromJSON(unit)));
    return unitList;
  }
}

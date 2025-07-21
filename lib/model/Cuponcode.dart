class CuponCode {
  String? cc_id;
  String? code;
  String? product_id;
  String? user_id;
  String? category_id;
  String? shop_id;
  String? type;
  String? val;
  String? maxVal;
  String? xdate;
  String? added_on;
  String? minVal;
  String? forv;

  CuponCode({
    this.cc_id,
    this.code,
    this.product_id,
    this.user_id,
    this.category_id,
    this.shop_id,
    this.type,
    this.val,
    this.maxVal,
    this.xdate,
    this.added_on,
    this.minVal,
    this.forv,
  });

  factory CuponCode.fromJSON(Map<String, dynamic> json) {
    return CuponCode(
      cc_id: json["cc_id"],
      code: json["code"],
      product_id: json["product_id"],
      user_id: json["user_id"],
      category_id: json["category_id"],
      shop_id: json["shop_id"],
      type: json["type"],
      val: json["val"],
      maxVal: json["maxVal"],
      xdate: json["xdate"],
      added_on: json["added_on"],
      minVal: json["minVal"],
      forv: json["for"],
    );
  }

  static List<CuponCode> getListFromJson(List<dynamic> list) {
    List<CuponCode> unitList = [];
    list.forEach((unit) => unitList.add(CuponCode.fromJSON(unit)));
    return unitList;
  }
}

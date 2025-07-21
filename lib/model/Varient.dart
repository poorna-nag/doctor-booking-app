class PVariant {
  PVariant({
    this.pvId,
    this.shopId,
    this.pId,
    this.variant,
    this.price,
    this.discount,
  });

  String? pvId;
  String? shopId;
  String? pId;
  String? variant;
  String? price;
  String? discount;



  factory PVariant.fromJSON(Map<String, dynamic> json) {
    return PVariant(
      pvId: json["pv_id"],
      shopId: json["shop_id"],
      pId: json["p_id"],
      variant: json["variant"],
      price: json["price"],
      discount: json["discount"],
    );}


  static List<PVariant> getListFromJson(List<dynamic> list) {
    List<PVariant> unitList =[];
    list.forEach((unit) => unitList.add(PVariant.fromJSON(unit)));
    return unitList;
  }



}

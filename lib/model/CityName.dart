class CityName {
  String? loc_id;
  String? places;
  String? shop_id;
  String? vendor_id;

  CityName({
    this.loc_id,
    this.places,
    this.shop_id,
    this.vendor_id,
  });

  factory CityName.fromJSON(Map<String, dynamic> json) {
    return CityName(
      loc_id: json["loc_id"],
      places: json["places"],
      shop_id: json["shop_id"],
      vendor_id: json["vendor_id"],
    );
  }

  static List<CityName> getListFromJson(List<dynamic> list) {
    List<CityName> unitList = [];
    list.forEach((unit) => unitList.add(CityName.fromJSON(unit)));
    return unitList;
  }
}

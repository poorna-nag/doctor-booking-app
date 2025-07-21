class Slider1 {
  String? galId;
  String? shopId;
  String? img;
  String? place;
  String? status;
  String? title;
  String? description;

  Slider1({
    this.galId,
    this.shopId,
    this.img,
    this.place,
    this.status,
    this.title,
    this.description,
  });

  factory Slider1.fromJSON(Map<String, dynamic> json) {
    return Slider1(
      galId: json["gal_id"],
      shopId: json["shop_id"],
      img: json["img"],
      place: json["place"],
      status: json["status"],
      title: json["title"],
      description: json["description"],
    );
  }

  static List<Slider1> getListFromJson(List<dynamic> list) {
    List<Slider1> unitList = [];
    list.forEach((unit) => unitList.add(Slider1.fromJSON(unit)));
    return unitList;
  }
}

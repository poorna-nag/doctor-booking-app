class Gallery {
  String? galId;
  String? shopId;
  String? img;
  String? place;
  String? status;
  String? title;
  String? description;

  Gallery({
    this.galId,
    this.shopId,
    this.img,
    this.place,
    this.status,
    this.title,
    this.description,
  });

  factory Gallery.fromJSON(Map<String, dynamic> json) {
    return Gallery(
      galId: json["gal_id"],
      shopId: json["shop_id"],
      img: json["img"],
      place: json["place"],
      status: json["status"],
      title: json["title"],
      description: json["description"],
    );
  }

  static List<Gallery> getListFromJson(List<dynamic> list) {
    List<Gallery> unitList = [];
    list.forEach((unit) => unitList.add(Gallery.fromJSON(unit)));
    return unitList;
  }
}

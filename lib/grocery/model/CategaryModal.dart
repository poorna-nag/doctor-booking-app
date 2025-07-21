class Categary {
  String? pcatId;
  String? shopId;
  String? pCats;
  String? img;
  String? parent;
  String? inHome;
  String? pcatStatus;
  String? dates;
  String? ff;

  Categary({
    this.pcatId,
    this.shopId,
    this.pCats,
    this.img,
    this.parent,
    this.inHome,
    this.pcatStatus,
    this.dates,
    this.ff,
  });

  factory Categary.fromJSON(Map<String, dynamic> json) {
    return Categary(
        pcatId: json["pcat_id"],
        shopId: json["shop_id"],
        pCats: json["p_cats"],
        img: json["img"],
        parent: json["parent"],
        inHome: json["inHome"],
        pcatStatus: json["pcat_status"],
        dates: json["dates"],
        ff: json["ff"]);
  }

  static List<Categary> getListFromJson(List<dynamic> list) {
    List<Categary> unitList = [];
    list.forEach((unit) => unitList.add(Categary.fromJSON(unit)));
    return unitList;
  }
}

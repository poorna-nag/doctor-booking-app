class ListModel {
  String? mvId;
  String? name;
  String? company;
  String? address;
  String? city;
  String? pincode;
  String? state;
  String? country;
  String? shopId;
  String? addedOn;
  String? status;
  String? username;
  String? password;
  String? email;
  String? mobile;
  String? gst;
  String? aadhaar;
  String? pan;
  String? lat;
  String? lng;
  String? pp;
  String? whatsapp;
  String? about;
  String? cat;
  String? reviews1;
  String? reviews_total;
  String? radius;

  ListModel({
    this.mvId,
    this.name,
    this.company,
    this.address,
    this.city,
    this.pincode,
    this.state,
    this.country,
    this.shopId,
    this.addedOn,
    this.status,
    this.username,
    this.password,
    this.email,
    this.mobile,
    this.gst,
    this.aadhaar,
    this.pan,
    this.lat,
    this.lng,
    this.pp,
    this.whatsapp,
    this.about,
    this.cat,
    this.reviews1,
    this.reviews_total,
    this.radius,
  });

  factory ListModel.fromJSON(Map<String, dynamic> json) {
    return ListModel(
      mvId: json["mv_id"],
      name: json["name"],
      company: json["company"],
      address: json["address"],
      city: json["city"],
      pincode: json["pincode"],
      state: json["state"],
      country: json["country"],
      shopId: json["shop_id"],
      addedOn: json["added_on"],
      status: json["status"],
      username: json["username"],
      password: json["password"],
      email: json["email"],
      mobile: json["mobile"],
      gst: json["gst"],
      aadhaar: json["aadhaar"],
      pan: json["pan"],
      lat: json["lat"],
      lng: json["lng"],
      pp: json["pp"],
      whatsapp: json["whatsapp"],
      about: json["about"],
      cat: json["cat"],
      reviews1: json["reviews"],
      reviews_total: json["reviews_total"],
      radius: json["delivery_radius"],
    );
  }
  static List<ListModel> getListFromJson(List<dynamic> list) {
    List<ListModel> unitList = [];
    list.forEach((unit) => unitList.add(ListModel.fromJSON(unit)));
    return unitList;
  }
}

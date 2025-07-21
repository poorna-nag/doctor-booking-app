// To parse this JSON data, do
//
//     final address = addressFromMap(jsonString);

class UserAddress {
  String? addId;
  String? userId;
  String? shopId;
  String? label;
  String? fullName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? pincode;
  String? email;
  String? mobile;
  String? lat;
  String? lng;

  UserAddress({
    this.addId,
    this.userId,
    this.shopId,
    this.label,
    this.fullName,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.pincode,
    this.email,
    this.mobile,
    this.lat,
    this.lng,
  });
  factory UserAddress.fromJSON(Map<String, dynamic> json) {
    return UserAddress(
      addId: json["add_id"],
      userId: json["user_id"],
      shopId: json["shop_id"],
      label: json["label"],
      fullName: json["full_name"],
      address1: json["address1"],
      address2: json["address2"],
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"],
      email: json["email"],
      mobile: json["mobile"],
      lat: json["lat"],
      lng: json["lng"],
    );
  }
  static List<UserAddress> getListFromJson(List<dynamic> list) {
    List<UserAddress> unitList = [];
    list.forEach((unit) => unitList.add(UserAddress.fromJSON(unit)));
    return unitList;
  }
}

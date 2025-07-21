class loginModal {
  String? success;
  String? message;
  String? key;
  String? user_id;
  String? name;
  String? email;
  String? username;
  String? address;
  String? city;
  String? pp;
  String? wallet;
  String? gst;
  String? prime;
  String? sex;
  String? dlocationName;
  String? dlocation;
  String? pincode;
  String? lat;
  String? lng;

  @override
  String toString() {
    return 'loginModal{success: $success, message: $message, key: $key, user_id: $user_id, name: $name, email: $email, username: $username, address: $address, city: $city, pp: $pp, wallet: $wallet, gst: $gst, prime: $prime, pincode: $pincode, sex: $sex, dlocationName: $dlocationName, dlocation: $dlocation}';
  }

  loginModal(
    this.success,
    this.message,
    this.key,
    this.user_id,
    this.name,
    this.email,
    this.username,
    this.address,
    this.city,
    this.pp,
    this.wallet,
    this.gst,
    this.prime,
    this.pincode,
    this.sex,
    this.dlocationName,
    this.dlocation,
    this.lat,
    this.lng,
  );

  factory loginModal.fromJson(dynamic json) {
    return loginModal(
      json['success'],
      json['message'],
      json['key'],
      json['user_id'],
      json['name'],
      json['email'],
      json['username'],
      json['address'],
      json['city'],
      json['pp'],
      json['wallet'],
      json['gst'],
      json['prime'],
      json['pincode'],
      json['sex'],
      json['dlocation'],
      json['dlocation'],
      json['lat'],
      json['lng'],
    );
  }
}

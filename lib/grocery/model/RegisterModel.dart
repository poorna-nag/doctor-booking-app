class RegisterModel {
  String? success;
  String? message;
  String? key;
  String? userId;
  String? name;
  String? email;
  String? username;
  String? address;
  String? city;
  String? pp;
  String? wallet;
  String? gst;
  String? dlocation;

  RegisterModel(
      this.success,
      this.message,
      this.key,
      this.userId,
      this.name,
      this.email,
      this.username,
      this.address,
      this.city,
      this.pp,
      this.wallet,
      this.gst,
      this.dlocation);

  @override
  String toString() {
    return 'RegisterModel{success: $success, message: $message, key: $key, userId: $userId, name: $name, email: $email, username: $username, address: $address, city: $city, pp: $pp, wallet: $wallet, gst: $gst, dlocation: $dlocation}';
  }

  factory RegisterModel.fromJson(dynamic json) {
    return RegisterModel(
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
      json['dlocation'],
    );
  }
}

class User {
  String? success;
  String? message;

  User(this.success, this.message);

  factory User.fromJson(dynamic json) {
    return User(json['success'], json['message']);
  }

  @override
  String toString() {
    return '{ ${this.success}, ${this.message} }';
  }
}

class OtpModal {
  String? success;
  String? message;
  String? key;

  OtpModal(this.success, this.message, this.key);

  factory OtpModal.fromJson(dynamic json) {
    return OtpModal(json['success'], json['message'], json['key']);
  }

  @override
  String toString() {
    return '{ ${this.success}, ${this.message}, ${this.key} }';
  }
}

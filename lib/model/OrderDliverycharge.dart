class DeliveryCharge {
  String? success;
  String? Min_Order;
  String? Fee;
  String? Gateway;
  String? COD;
  String? Insta_client_id;
  String? Insta_client_secret;
  String? razorpay_key;
  String? razorpay_sec;
  String? fast_price;
  String? fast_text;

  DeliveryCharge(
    this.success,
    this.Min_Order,
    this.Fee,
    this.Gateway,
    this.COD,
    this.Insta_client_id,
    this.Insta_client_secret,
    this.razorpay_key,
    this.razorpay_sec,
    this.fast_price,
    this.fast_text,
  );

  factory DeliveryCharge.fromJson(dynamic json) {
    return DeliveryCharge(
      json['success'],
      json['Min_Order'],
      json['Fee'],
      json['Gateway'],
      json['COD'],
      json['Insta_client_id'],
      json['Insta_client_secret'],
      json['razorpay_key'],
      json['razorpay_sec'],
      json['fast_price'],
      json['fast_text'],
    );
  }
}

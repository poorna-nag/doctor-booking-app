class DeliveryCharge {
  String success;
  String Min_Order;
  String Fee;
  String Gateway;
  String COD;
  String Insta_client_id;
  String Insta_client_secret;
  String razorpay_key;
  String razorpay_sec;
  String fast_price;
  String fast_text;
  String? phone_pay;
  String? imGatway;

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
    this.phone_pay,
    this.imGatway,
  );

  factory DeliveryCharge.fromJson(dynamic json) {
    return DeliveryCharge(
      json['success'] as String,
      json['Min_Order'] as String,
      json['Fee'] as String,
      json['Gateway'] as String,
      json['COD'] as String,
      json['Insta_client_id'] as String,
      json['Insta_client_secret'] as String,
      json['razorpay_key'] as String,
      json['razorpay_sec'] as String,
      json['fast_price'] as String,
      json['fast_text'] as String,
      json['phonepe_gateway'] as String,
      json['im_gateway'],
    );
  }
}

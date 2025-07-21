class CancleandRefund {
  String? status;
  String? message;
  String? key;

  CancleandRefund(this.status, this.message, this.key);

  factory CancleandRefund.fromJson(dynamic json) {
    return CancleandRefund(
      json['status'],
      json['message'],
      json['key'],
    );
  }

  @override
  String toString() {
    return '{ ${this.status}, ${this.message}, ${this.key} }';
  }
}

class CancleandRefund1 {
  bool? status;
  String? message;
  String? key;

  CancleandRefund1(this.status, this.message, this.key);

  factory CancleandRefund1.fromJson(dynamic json) {
    return CancleandRefund1(
      json['status'],
      json['message'],
      json['key'],
    );
  }

  @override
  String toString() {
    return '{ ${this.status}, ${this.message}, ${this.key} }';
  }
}

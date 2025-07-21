class Invoice1 {
  String? success;
  String? Invoice;

  Invoice1(
    this.success,
    this.Invoice,
  );

  factory Invoice1.fromJson(dynamic json) {
    return Invoice1(json['success'], json['Invoice']);
  }

  @override
  String toString() {
    return '{ ${this.success}, ${this.Invoice} }';
  }
}

class ProductAdded1 {
  String? success;
  String? Product;
  String? Invoice;
  String? Added;

  @override
  String toString() {
    return 'ProductAdded1{success: $success, Product: $Product, Invoice: $Invoice, Added: $Added}';
  }

  ProductAdded1(this.success, this.Product, this.Invoice, this.Added);

  factory ProductAdded1.fromJson(dynamic json) {
    return ProductAdded1(
      json['success'],
      json['Product'],
      json['Invoice'],
      json['Added'],
    );
  }
}

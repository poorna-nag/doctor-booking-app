class InvoiceInvoice {
  InvoiceInvoice({
    this.id,
    this.invoiceId,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.userPer,
    this.userDis,
    this.adminPer,
    this.adminDis,
    this.shopId,
    this.cgst,
    this.sgst,
    this.variant,
    this.color,
    this.size,
    this.image,
    this.prime,
    this.subs,
    this.subsa,
    this.refid,
  });
  String? id;
  String? invoiceId;
  String? productId;
  String? productName;
  String? quantity;
  String? price;
  String? userPer;
  String? userDis;
  String? adminPer;
  String? adminDis;
  String? shopId;
  String? cgst;
  String? sgst;
  String? variant;
  String? color;
  String? size;
  String? image;
  String? prime;
  String? subs;
  String? subsa;
  String? refid;

  factory InvoiceInvoice.fromJSON(Map<String, dynamic> json) {
    return InvoiceInvoice(
      id: json["id"],
      invoiceId: json["invoice_id"],
      productId: json["product_id"],
      productName: json["product_name"],
      quantity: json["quantity"],
      price: json["price"],
      userPer: json["user_per"],
      userDis: json["user_dis"],
      adminPer: json["admin_per"],
      adminDis: json["admin_dis"],
      shopId: json["shop_id"],
      cgst: json["cgst"],
      sgst: json["sgst"],
      variant: json["variant"],
      color: json["color"],
      size: json["size"],
      image: json["image"],
      prime: json["prime"],
      subs: json["subs"],
      subsa: json["subsa"],
      refid: json["refid"],
    );
  }

  static List<InvoiceInvoice> getListFromJson(List<dynamic> list) {
    List<InvoiceInvoice> unitList = [];
    list.forEach((unit) => unitList.add(InvoiceInvoice.fromJSON(unit)));
    return unitList;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "invoice_id": invoiceId,
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "price": price,
        "user_per": userPer,
        "user_dis": userDis,
        "admin_per": adminPer,
        "admin_dis": adminDis,
        "shop_id": shopId,
        "cgst": cgst,
        "sgst": sgst,
        "variant": variant,
        "color": color,
        "size": size,
        "image": image,
        "prime": prime,
        "subs": subs,
        "subsa": subsa,
        "refid": refid,
      };
}

class TrackInvoice {
  TrackInvoice({
    this.id,
    this.clientId,
    this.invoiceTotal,
    this.invoiceSubtotal,
    this.tax,
    this.amountPaid,
    this.amountDue,
    this.notes,
    this.created,
    this.updated,
    this.uuid,
    this.shopId,
    this.states,
    this.name,
    this.mobile,
    this.email,
    this.address,
    this.city,
    this.pincode,
    this.domain,
    this.shipping,
    this.deliveryDate,
    this.adate,
    this.atime,
    this.awbCode,
    this.subs,
    this.refid,
  });
  String? id;
  String? clientId;
  String? invoiceTotal;
  String? invoiceSubtotal;
  String? tax;
  String? amountPaid;
  String? amountDue;
  String? notes;
  String? created;
  String? updated;
  String? uuid;
  String? shopId;
  String? states;
  String? name;
  String? mobile;
  String? email;
  String? address;
  String? city;
  String? pincode;
  String? domain;
  String? shipping;
  String? deliveryDate;
  String? adate;  // Appointment date
  String? atime;  // Appointment time
  String? awbCode;
  String? subs;
  String? refid;

  factory TrackInvoice.fromJSON(Map<String, dynamic> json) {
    return TrackInvoice(
      id: json["id"],
      clientId: json["client_id"],
      invoiceTotal: json["invoice_total"],
      invoiceSubtotal: json["invoice_subtotal"],
      tax: json["tax"],
      amountPaid: json["amount_paid"],
      amountDue: json["amount_due"],
      notes: json["notes"],
      created: json["created"],
      updated: json["updated"],
      uuid: json["uuid"],
      shopId: json["shop_id"],
      states: json["states"],
      name: json["name"],
      mobile: json["mobile"],
      email: json["email"],
      address: json["address"],
      city: json["city"],
      pincode: json["pincode"],
      domain: json["domain"],
      shipping: json["shipping"],
      deliveryDate: json["delivery_date"],
      adate: json["adate"],
      atime: json["atime"],
      awbCode: json["awb_code"],
      subs: json["subs"],
      refid: json["refid"],
    );
  }

  static List<TrackInvoice> getListFromJson(List<dynamic> list) {
    List<TrackInvoice> unitList = [];
    list.forEach((unit) => unitList.add(TrackInvoice.fromJSON(unit)));
    return unitList;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "client_id": clientId,
        "invoice_total": invoiceTotal,
        "invoice_subtotal": invoiceSubtotal,
        "tax": tax,
        "amount_paid": amountPaid,
        "amount_due": amountDue,
        "notes": notes,
        "created": created,
        "updated": updated,
        "uuid": uuid,
        "shop_id": shopId,
        "states": states,
        "name": name,
        "mobile": mobile,
        "email": email,
        "address": address,
        "city": city,
        "pincode": pincode,
        "domain": domain,
        "shipping": shipping,
        "delivery_date": deliveryDate,
        "adate": adate,
        "atime": atime,
        "awb_code": awbCode,
        "subs": subs,
        "refid": refid,
      };
}

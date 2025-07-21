class VendorList {
  List<ListMain>? list;

  VendorList({this.list});

  VendorList.fromJson(Map<String, dynamic> json) {
    if (json['List'] != null) {
      list = <ListMain>[];
      json['List'].forEach((v) {
        list!.add(new ListMain.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['List'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListMain {
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
  String? mobile2;
  String? gst;
  String? aadhaar;
  String? pan;
  String? lock;
  String? lat;
  String? lng;
  String? pp;
  String? whatsapp;
  String? about;
  String? cat;
  String? firebase;
  String? orderStatus;
  String? serviceCats;
  String? credits;
  String? sort;
  String? reviews;
  String? reviewsTotal;
  String? openTime;
  String? closeTime;
  String? showingStatus;

  ListMain(
      {this.mvId,
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
      this.mobile2,
      this.gst,
      this.aadhaar,
      this.pan,
      this.lock,
      this.lat,
      this.lng,
      this.pp,
      this.whatsapp,
      this.about,
      this.cat,
      this.firebase,
      this.orderStatus,
      this.serviceCats,
      this.credits,
      this.sort,
      this.reviews,
      this.reviewsTotal,
      this.openTime,
      this.closeTime,
      this.showingStatus});

  ListMain.fromJson(Map<String, dynamic> json) {
    mvId = json['mv_id'];
    name = json['name'];
    company = json['company'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
    country = json['country'];
    shopId = json['shop_id'];
    addedOn = json['added_on'];
    status = json['status'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    mobile = json['mobile'];
    mobile2 = json['mobile2'];
    gst = json['gst'];
    aadhaar = json['aadhaar'];
    pan = json['pan'];
    lock = json['lock'];
    lat = json['lat'];
    lng = json['lng'];
    pp = json['pp'];
    whatsapp = json['whatsapp'];
    about = json['about'];
    cat = json['cat'];
    firebase = json['firebase'];
    orderStatus = json['order_status'];
    serviceCats = json['service_cats'];
    credits = json['credits'];
    sort = json['sort'];
    reviews = json['reviews'];
    reviewsTotal = json['reviews_total'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    showingStatus = json['showing_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mv_id'] = this.mvId;
    data['name'] = this.name;
    data['company'] = this.company;
    data['address'] = this.address;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['country'] = this.country;
    data['shop_id'] = this.shopId;
    data['added_on'] = this.addedOn;
    data['status'] = this.status;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['mobile2'] = this.mobile2;
    data['gst'] = this.gst;
    data['aadhaar'] = this.aadhaar;
    data['pan'] = this.pan;
    data['lock'] = this.lock;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['pp'] = this.pp;
    data['whatsapp'] = this.whatsapp;
    data['about'] = this.about;
    data['cat'] = this.cat;
    data['firebase'] = this.firebase;
    data['order_status'] = this.orderStatus;
    data['service_cats'] = this.serviceCats;
    data['credits'] = this.credits;
    data['sort'] = this.sort;
    data['reviews'] = this.reviews;
    data['reviews_total'] = this.reviewsTotal;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['showing_status'] = this.showingStatus;
    return data;
  }
}

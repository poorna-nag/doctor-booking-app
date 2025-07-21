class UsableWalletAmount {
  String?  success;
  String?  name;
  String?  img;
  String?  city;
  String?  cat;
  String?  star;
  String?  today;
  String?  month;
  String?  todayc;
  String?  monthc;
  String?  products;
  String?  categories;
  String?  users;
  String?  sms;
  String?  pages;
  String?  blogs;
  String?  images;
  String?  leads;
  String?  reviews;
  String?  faq;
  String?  address;
  String?  contactPerson;
  String?  pincode;
  String?  description;
  String?  mobileNo;
  String?  emailId;
  String?  upi;
  String?  dearning;
  String?  walletCanBeUsed;

  UsableWalletAmount(
      {this.success,
        this.name,
        this.img,
        this.city,
        this.cat,
        this.star,
        this.today,
        this.month,
        this.todayc,
        this.monthc,
        this.products,
        this.categories,
        this.users,
        this.sms,
        this.pages,
        this.blogs,
        this.images,
        this.leads,
        this.reviews,
        this.faq,
        this.address,
        this.contactPerson,
        this.pincode,
        this.description,
        this.mobileNo,
        this.emailId,
        this.upi,
        this.dearning,
        this.walletCanBeUsed});

  UsableWalletAmount.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    name = json['name'];
    img = json['img'];
    city = json['city'];
    cat = json['cat'];
    star = json['star'];
    today = json['today'];
    month = json['month'];
    todayc = json['todayc'];
    monthc = json['monthc'];
    products = json['products'];
    categories = json['categories'];
    users = json['users'];
    sms = json['sms'];
    pages = json['pages'];
    blogs = json['blogs'];
    images = json['images'];
    leads = json['leads'];
    reviews = json['reviews'];
    faq = json['faq'];
    address = json['address'];
    contactPerson = json['contact_person'];
    pincode = json['pincode'];
    description = json['description'];
    mobileNo = json['mobile_no'];
    emailId = json['email_id'];
    upi = json['upi'];
    dearning = json['dearning'];
    walletCanBeUsed = json['wallet_can_be_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['name'] = name;
    data['img'] = img;
    data['city'] = city;
    data['cat'] = cat;
    data['star'] = star;
    data['today'] = today;
    data['month'] = month;
    data['todayc'] = todayc;
    data['monthc'] = monthc;
    data['products'] = products;
    data['categories'] = categories;
    data['users'] = users;
    data['sms'] = sms;
    data['pages'] = pages;
    data['blogs'] = blogs;
    data['images'] = images;
    data['leads'] = leads;
    data['reviews'] = reviews;
    data['faq'] = faq;
    data['address'] = address;
    data['contact_person'] = contactPerson;
    data['pincode'] = pincode;
    data['description'] = description;
    data['mobile_no'] = mobileNo;
    data['email_id'] = emailId;
    data['upi'] = upi;
    data['dearning'] = dearning;
    data['wallet_can_be_used'] = walletCanBeUsed;
    return data;
  }
}

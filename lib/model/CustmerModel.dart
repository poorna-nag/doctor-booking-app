class CustmerModel {
  String? userId;
  String? name;
  String? email;
  String? address;
  String? phone;
  String? city;
  String? regDate;
  String? username;
  String? password;
  String? pp;
  String? wallet;
  String? contacted;
  String? rated;
  String? likes;
  String? userType;
  String? franchise;
  String? shopId;
  String? pincode;
  String? prime;
  String? sponsor;
  String? pDate;
  String? pExpire;
  String? pFee;
  String? aname;
  String? anumber;
  String? bankname;
  String? bankbranch;
  String? ifsc;
  String? atype;
  String? withdrawl;
  String? aadhar;
  String? pan;
  String? dob;
  String? gst;
  String? sex;
  String? payForInstall;
  String? src;
  String? dlocation;
  String? loginType;
  String? lock;
  String? updateAdd;
  String? firebase;
  String? aadharImgF;
  String? aadharImgB;

  CustmerModel({
    this.userId,
    this.name,
    this.email,
    this.address,
    this.phone,
    this.city,
    this.regDate,
    this.username,
    this.password,
    this.pp,
    this.wallet,
    this.contacted,
    this.rated,
    this.likes,
    this.userType,
    this.franchise,
    this.shopId,
    this.pincode,
    this.prime,
    this.sponsor,
    this.pDate,
    this.pExpire,
    this.pFee,
    this.aname,
    this.anumber,
    this.bankname,
    this.bankbranch,
    this.ifsc,
    this.atype,
    this.withdrawl,
    this.aadhar,
    this.pan,
    this.dob,
    this.gst,
    this.sex,
    this.payForInstall,
    this.src,
    this.dlocation,
    this.loginType,
    this.lock,
    this.updateAdd,
    this.firebase,
    this.aadharImgF,
    this.aadharImgB,
  });

  factory CustmerModel.fromJSON(Map<String, dynamic> json) {
    return CustmerModel(
      userId: json["user_id"],
      name: json["name"],
      email: json["email"],
      address: json["address"],
      phone: json["phone"],
      city: json["city"],
      regDate: json["reg_date"],
      username: json["username"],
      password: json["password"],
      pp: json["pp"],
      wallet: json["wallet"],
      contacted: json["contacted"],
      rated: json["rated"],
      likes: json["likes"],
      userType: json["user_type"],
      franchise: json["franchise"],
      shopId: json["shop_id"],
      pincode: json["pincode"],
      prime: json["prime"],
      sponsor: json["sponsor"],
      pDate: json["p_date"],
      pExpire: json["p_expire"],
      pFee: json["p_fee"],
      aname: json["aname"],
      anumber: json["anumber"],
      bankname: json["bankname"],
      bankbranch: json["bankbranch"],
      ifsc: json["ifsc"],
      atype: json["atype"],
      withdrawl: json["withdrawl"],
      aadhar: json["aadhar"],
      pan: json["pan"],
      dob: json["dob"],
      gst: json["gst"],
      sex: json["sex"],
      payForInstall: json["pay_for_install"],
      src: json["src"],
      dlocation: json["dlocation"],
      loginType: json["login_type"],
      lock: json["lock"],
      updateAdd: json["update_add"],
      firebase: json["firebase"],
      aadharImgF: json["aadhar_img_f"],
      aadharImgB: json["aadhar_img_b"],
    );
  }
  static List<CustmerModel> getListFromJson(List<dynamic> list) {
    List<CustmerModel> unitList = [];
    list.forEach((unit) => unitList.add(CustmerModel.fromJSON(unit)));
    return unitList;
  }
}

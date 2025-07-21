class WalletUser {
  String? wId;
  String? wUser;
  String? wIn;
  String? wOut;
  String? wDate;
  String? wBalance;
  String? wType;
  String? wNote;
  String? wInvoiceId;
  String? wTransactionId;
  String? wAddedBy;
  String? addedBy1;
  String? franchise1;
  String? paidto;

  WalletUser({
    this.wId,
    this.wUser,
    this.wIn,
    this.wOut,
    this.wDate,
    this.wBalance,
    this.wType,
    this.wNote,
    this.wInvoiceId,
    this.wTransactionId,
    this.wAddedBy,
    this.addedBy1,
    this.franchise1,
    this.paidto,
  });
  factory WalletUser.fromJSON(Map<String, dynamic> json) {
    return WalletUser(
      wId: json["w_id"],
      wUser: json["w_user"],
      wIn: json["w_in"],
      wOut: json["w_out"],
      wDate: json["w_date"],
      wBalance: json["w_balance"],
      wType: json["w_type"],
      wNote: json["w_note"],
      wInvoiceId: json["w_invoice_id"],
      wTransactionId: json["w_transaction_id"],
      wAddedBy: json["w_added_by"],
      addedBy1: json["added_by1"],
      franchise1: json["franchise1"],
      paidto: json["paidto"],
    );
  }
  static List<WalletUser> getListFromJson(List<dynamic> list) {
    List<WalletUser> unitList = [];
    list.forEach((unit) => unitList.add(WalletUser.fromJSON(unit)));
    return unitList;
  }
}

class Review {
  String? rew_id;
  String? status;
  String? shop_id;
  String? user_id;
  String? review;
  String? dates;
  String? stars;
  String? product;
  String? productName;

  Review({
    this.rew_id,
    this.status,
    this.shop_id,
    this.user_id,
    this.review,
    this.dates,
    this.stars,
    this.product,
    this.productName,
  });

  factory Review.fromJSON(Map<String, dynamic> json) {
    return Review(
        rew_id: json["rew_id"],
        status: json["status"],
        shop_id: json["shop_id"],
        user_id: json["user_id"],
        review: json["review"],
        dates: json["dates"],
        stars: json["stars"],
        product: json["product"],
        productName: json["productName"]);
  }

  static List<Review> getListFromJson(List<dynamic> list) {
    List<Review> unitList = [];
    list.forEach((unit) => unitList.add(Review.fromJSON(unit)));
    return unitList;
  }
}

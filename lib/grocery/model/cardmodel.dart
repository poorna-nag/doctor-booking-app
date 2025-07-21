
class Note {

  int? _id;
  String? _title;
  String? _description;
  String? _price;
  String? _quantity;
  String? _image;

  Note(this._title, this._price, this._quantity,this._image, [this._description]);

  Note.withId(this._id, this._title, this._price, this._quantity,this._image, [this._description]);

  int get id => _id!;

  String get title => _title??"";

  String get description => _description??"";

  String get price => _price??"";

  String get quantity => _quantity??"";
  String get image => _image??"";

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set image(String imagelink) {

      _image = imagelink;

  }

  set price(String price) {
    _price = price;
  }

  set quantity(String qun) {
    _quantity = qun;
  }


  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['image'] = _image;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _price = map['price'];
    _quantity = map['quantity'];
    _image = map['image'];
  }
}










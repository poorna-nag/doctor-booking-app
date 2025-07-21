class AmenitiesModel {
  bool? status;
  String? message;
  Data? data;
  int? total;

  AmenitiesModel({this.status, this.message, this.data, this.total});

  AmenitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Data {
  List<CustomFieldsValue>? customFieldsValue;

  Data({this.customFieldsValue});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['custom_fields_value'] != null) {
      customFieldsValue = <CustomFieldsValue>[];
      json['custom_fields_value'].forEach((v) {
        customFieldsValue!.add(new CustomFieldsValue.fromJson(v));
        print("customFieldsValue add--> ${customFieldsValue!.length}");
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customFieldsValue != null) {
      data['custom_fields_value'] =
          this.customFieldsValue!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomFieldsValue {
  String? povId;
  String? catIds;
  String? productId;
  String? shopId;
  String? mcfId;
  String? fieldsType;
  String? fieldsName;
  String? fieldValue;
  String? createdAt;
  String? updatedAt;

  CustomFieldsValue(
      {this.povId,
      this.catIds,
      this.productId,
      this.shopId,
      this.mcfId,
      this.fieldsType,
      this.fieldsName,
      this.fieldValue,
      this.createdAt,
      this.updatedAt});

  CustomFieldsValue.fromJson(Map<String, dynamic> json) {
    povId = json['pov_id'];
    catIds = json['cat_ids'];
    productId = json['product_id'];
    shopId = json['shop_id'];
    mcfId = json['mcf_id'];
    fieldsType = json['fields_type'];
    fieldsName = json['fields_name'];
    fieldValue = json['field_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pov_id'] = this.povId;
    data['cat_ids'] = this.catIds;
    data['product_id'] = this.productId;
    data['shop_id'] = this.shopId;
    data['mcf_id'] = this.mcfId;
    data['fields_type'] = this.fieldsType;
    data['fields_name'] = this.fieldsName;
    data['field_value'] = this.fieldValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

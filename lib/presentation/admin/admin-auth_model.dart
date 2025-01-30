class AdminAuthModel {
  String? message;
  String? token;
  String? status;
  int? statusCode;
  Data? data;

  AdminAuthModel(
      {this.message, this.token, this.status, this.statusCode, this.data});

  AdminAuthModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? username;
  String? password;
  int? status;
  String? type;
  String? address;
  String? tagline;
  String? phone;
  String? altMobileNumber;
  String? nationality;
  String? uploadId;
  String? establishedDate;
  String? accountTaxPayerId;
  Null? expireDate;
  Null? currentPlan;
  Null? creator;
  Null? updater;
  Null? emailVerifiedAt;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.email,
      this.username,
      this.password,
      this.status,
      this.type,
      this.address,
      this.tagline,
      this.phone,
      this.altMobileNumber,
      this.nationality,
      this.uploadId,
      this.establishedDate,
      this.accountTaxPayerId,
      this.expireDate,
      this.currentPlan,
      this.creator,
      this.updater,
      this.emailVerifiedAt,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    status = json['status'];
    type = json['type'];
    address = json['address'];
    tagline = json['tagline'];
    phone = json['phone'];
    altMobileNumber = json['alt_mobile_number'];
    nationality = json['nationality'];
    uploadId = json['upload_id'];
    establishedDate = json['established_date'];
    accountTaxPayerId = json['account_tax_payer_id'];
    expireDate = json['expire_date'];
    currentPlan = json['current_plan'];
    creator = json['creator'];
    updater = json['updater'];
    emailVerifiedAt = json['email_verified_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['status'] = this.status;
    data['type'] = this.type;
    data['address'] = this.address;
    data['tagline'] = this.tagline;
    data['phone'] = this.phone;
    data['alt_mobile_number'] = this.altMobileNumber;
    data['nationality'] = this.nationality;
    data['upload_id'] = this.uploadId;
    data['established_date'] = this.establishedDate;
    data['account_tax_payer_id'] = this.accountTaxPayerId;
    data['expire_date'] = this.expireDate;
    data['current_plan'] = this.currentPlan;
    data['creator'] = this.creator;
    data['updater'] = this.updater;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

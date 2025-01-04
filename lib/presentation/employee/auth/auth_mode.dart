class AuthModel {
  String? message;
  String? token;
  String? status;
  int? statusCode;
  Data? data;

  AuthModel(
      {this.message, this.token, this.status, this.statusCode, this.data});

  AuthModel.fromJson(Map<String, dynamic> json) {
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
  String? employeeId;
  String? designation;
  String? father;
  String? mother;
  String? address;
  String? blood;
  String? tagline;
  String? creator;
  String? updater;
  String? bloodGroup;
  String? salary;
  int? status;
  String? phone;
  int? userType;
  Null? officeOutTime;
  Null? officeInTime;
  String? email;
  Null? emailVerifiedAt;
  Null? prefix;
  Null? username;
  Null? religion;
  Null? slug;
  Null? nationality;
  Null? nid;
  Null? joiningDate;
  Null? exitDate;
  String? uploadId;
  Null? birth;
  Null? altMobileNumber;
  Null? familyMobileNumber;
  Null? accountTaxPayerId;
  String? gender;
  String? maritalStatus;
  Null? fcmToken;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? lastActive;
  String? statusName;
  String? userTypeName;
  String? genderName;
  String? mStatus;

  Data(
      {this.id,
      this.name,
      this.employeeId,
      this.designation,
      this.father,
      this.mother,
      this.address,
      this.blood,
      this.tagline,
      this.creator,
      this.updater,
      this.bloodGroup,
      this.salary,
      this.status,
      this.phone,
      this.userType,
      this.officeOutTime,
      this.officeInTime,
      this.email,
      this.emailVerifiedAt,
      this.prefix,
      this.username,
      this.religion,
      this.slug,
      this.nationality,
      this.nid,
      this.joiningDate,
      this.exitDate,
      this.uploadId,
      this.birth,
      this.altMobileNumber,
      this.familyMobileNumber,
      this.accountTaxPayerId,
      this.gender,
      this.maritalStatus,
      this.fcmToken,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.lastActive,
      this.statusName,
      this.userTypeName,
      this.genderName,
      this.mStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    employeeId = json['employee_id'];
    designation = json['designation'];
    father = json['father'];
    mother = json['mother'];
    address = json['address'];
    blood = json['blood'];
    tagline = json['tagline'];
    creator = json['creator'];
    updater = json['updater'];
    bloodGroup = json['blood_group'];
    salary = json['salary'];
    status = json['status'];
    phone = json['phone'];
    userType = json['user_type'];
    officeOutTime = json['office_out_time'];
    officeInTime = json['office_in_time'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    prefix = json['prefix'];
    username = json['username'];
    religion = json['religion'];
    slug = json['slug'];
    nationality = json['nationality'];
    nid = json['nid'];
    joiningDate = json['joining_date'];
    exitDate = json['exit_date'];
    uploadId = json['upload_id'];
    birth = json['birth'];
    altMobileNumber = json['alt_mobile_number'];
    familyMobileNumber = json['family_mobile_number'];
    accountTaxPayerId = json['account_tax_payer_id'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    fcmToken = json['fcm_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    lastActive = json['last_active'];
    statusName = json['status_name'];
    userTypeName = json['user_type_name'];
    genderName = json['gender_name'];
    mStatus = json['m_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['employee_id'] = this.employeeId;
    data['designation'] = this.designation;
    data['father'] = this.father;
    data['mother'] = this.mother;
    data['address'] = this.address;
    data['blood'] = this.blood;
    data['tagline'] = this.tagline;
    data['creator'] = this.creator;
    data['updater'] = this.updater;
    data['blood_group'] = this.bloodGroup;
    data['salary'] = this.salary;
    data['status'] = this.status;
    data['phone'] = this.phone;
    data['user_type'] = this.userType;
    data['office_out_time'] = this.officeOutTime;
    data['office_in_time'] = this.officeInTime;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['prefix'] = this.prefix;
    data['username'] = this.username;
    data['religion'] = this.religion;
    data['slug'] = this.slug;
    data['nationality'] = this.nationality;
    data['nid'] = this.nid;
    data['joining_date'] = this.joiningDate;
    data['exit_date'] = this.exitDate;
    data['upload_id'] = this.uploadId;
    data['birth'] = this.birth;
    data['alt_mobile_number'] = this.altMobileNumber;
    data['family_mobile_number'] = this.familyMobileNumber;
    data['account_tax_payer_id'] = this.accountTaxPayerId;
    data['gender'] = this.gender;
    data['marital_status'] = this.maritalStatus;
    data['fcm_token'] = this.fcmToken;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['last_active'] = this.lastActive;
    data['status_name'] = this.statusName;
    data['user_type_name'] = this.userTypeName;
    data['gender_name'] = this.genderName;
    data['m_status'] = this.mStatus;
    return data;
  }
}

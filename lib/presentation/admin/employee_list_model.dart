class EmployeeListModel {
  String? message;
  String? status;
  int? statusCode;
  Data? data;

  EmployeeListModel({this.message, this.status, this.statusCode, this.data});

  EmployeeListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<Data2>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data2>[];
      json['data'].forEach((v) {
        data!.add(new Data2.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data2 {
  int? id;
  String? name;
  String? designation;
  String? father;
  String? mother;
  String? address;
  String? blood;
  String? tagline;
  String? salary;
  int? status;
  String? phone;
  int? userType;
  String? officeOutTime;
  String? officeInTime;
  String? email;
  String? emailVerifiedAt;
  String? prefix;
  String? username;
  String? religion;
  String? slug;
  String? nationality;
  String? nid;
  String? joiningDate;
  String? exitDate;
  int? companyId;
  String? uploadId;
  String? birth;
  String? altMobileNumber;
  String? familyMobileNumber;
  String? accountTaxPayerId;
  String? gender;
  String? maritalStatus;
  String? creator;
  String? updater;
  Null? fcmToken;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? statusName;
  String? userTypeName;
  String? genderName;
  String? mStatus;
  String? currentStatus;

  Data2(
      {this.id,
      this.name,
      this.designation,
      this.father,
      this.mother,
      this.address,
      this.blood,
      this.tagline,
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
      this.companyId,
      this.uploadId,
      this.birth,
      this.altMobileNumber,
      this.familyMobileNumber,
      this.accountTaxPayerId,
      this.gender,
      this.maritalStatus,
      this.creator,
      this.updater,
      this.fcmToken,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.statusName,
      this.userTypeName,
      this.genderName,
      this.mStatus,
      this.currentStatus});

  Data2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    designation = json['designation'];
    father = json['father'];
    mother = json['mother'];
    address = json['address'];
    blood = json['blood'];
    tagline = json['tagline'];
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
    companyId = json['company_id'];
    uploadId = json['upload_id'];
    birth = json['birth'];
    altMobileNumber = json['alt_mobile_number'];
    familyMobileNumber = json['family_mobile_number'];
    accountTaxPayerId = json['account_tax_payer_id'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    creator = json['creator'];
    updater = json['updater'];
    fcmToken = json['fcm_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    statusName = json['status_name'];
    userTypeName = json['user_type_name'];
    genderName = json['gender_name'];
    mStatus = json['m_status'];
    currentStatus = json['current_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['designation'] = this.designation;
    data['father'] = this.father;
    data['mother'] = this.mother;
    data['address'] = this.address;
    data['blood'] = this.blood;
    data['tagline'] = this.tagline;
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
    data['company_id'] = this.companyId;
    data['upload_id'] = this.uploadId;
    data['birth'] = this.birth;
    data['alt_mobile_number'] = this.altMobileNumber;
    data['family_mobile_number'] = this.familyMobileNumber;
    data['account_tax_payer_id'] = this.accountTaxPayerId;
    data['gender'] = this.gender;
    data['marital_status'] = this.maritalStatus;
    data['creator'] = this.creator;
    data['updater'] = this.updater;
    data['fcm_token'] = this.fcmToken;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['status_name'] = this.statusName;
    data['user_type_name'] = this.userTypeName;
    data['gender_name'] = this.genderName;
    data['m_status'] = this.mStatus;
    data['current_status'] = this.currentStatus;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}

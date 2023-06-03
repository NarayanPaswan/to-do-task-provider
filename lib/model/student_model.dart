class StudentsModel {
  int? status;
  Data? data;

  StudentsModel({this.status, this.data});

  StudentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

 
}

class Data {
  num? currentPage;
  // List<Data>? data;
  List<StudentData>? data; // Modify the type to StudentData
  String? firstPageUrl;
  num? from;
  num? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  num? perPage;
  String? prevPageUrl;
  num? to;
  num? total;

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
       data = <StudentData>[]; // Modify the type to StudentData
      json['data'].forEach((v) {
        data!.add(StudentData.fromJson(v)); // Modify the type to StudentData
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

}

class StudentData {
  int? id;
  String? photo;
  String? resume;
  String? name;
  String? contactNumber;
  String? dateOfBirth;
  String? address;
  String? postalCode;
  int? countryId;
  String? countryName;
  int? stateId;
  String? stateName;
  int? cityId;
  String? cityName;
  String? gender;
  String? maritalStatus;
  String? workExperience;
  String? companyName;
  String? designation;
  String? durationFrom;
  String? durationUpto;
  int? userId;
  String? createdAt;
  String? updatedAt;

  StudentData(
      {this.id,
      this.photo,
      this.resume,
      this.name,
      this.contactNumber,
      this.dateOfBirth,
      this.address,
      this.postalCode,
      this.countryId,
      this.countryName,
      this.stateId,
      this.stateName,
      this.cityId,
      this.cityName,
      this.gender,
      this.maritalStatus,
      this.workExperience,
      this.companyName,
      this.designation,
      this.durationFrom,
      this.durationUpto,
      this.userId,
      this.createdAt,
      this.updatedAt});

  StudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    resume = json['resume'];
    name = json['name'];
    contactNumber = json['contact_number'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
    postalCode = json['postal_code'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    workExperience = json['work_experience'];
    companyName = json['company_name'];
    designation = json['designation'];
    durationFrom = json['duration_from'];
    durationUpto = json['duration_upto'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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

 
}

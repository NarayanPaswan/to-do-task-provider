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
  int? currentPage;
  // List<Data>? data;
  List<StudentData>? data; // Modify the type to StudentData
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
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
  String? name;
  String? image;
  String? mobileNo;
  String? dateOfBirth;
  String? gender;
  String? company;
  String? countryId;
  String? countryName;
  String? stateId;
  String? stateName;
  String? cityId;
  String? cityName;
  String? maritalStatus;
  num? userId;
  String? createdAt;
  String? updatedAt;

  StudentData(
      {this.id,
      this.name,
      this.image,
      this.mobileNo,
      this.dateOfBirth,
      this.gender,
      this.company,
      this.countryId,
      this.countryName,
      this.stateId,
      this.stateName,
      this.cityId,
      this.cityName,
      this.maritalStatus,
      this.userId,
      this.createdAt,
      this.updatedAt});

  StudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    mobileNo = json['mobile_no'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    company = json['company'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    maritalStatus = json['marital_status'];
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

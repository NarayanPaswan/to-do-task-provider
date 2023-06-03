class CountryListModel {
  int? status;
  List<Data>? data;

  CountryListModel({this.status, this.data});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }


}

class Data {
  int? id;
  String? countryName;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id, this.countryName, this.status, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }


}

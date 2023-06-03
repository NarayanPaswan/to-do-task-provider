class StateModel {
  int? status;
  List<StateData>? data;

  StateModel({this.status, this.data});

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <StateData>[];
      json['data'].forEach((v) {
        data!.add(StateData.fromJson(v));
      });
    }
  }

 
}

class StateData {
  int? id;
  int? countryId;
  String? stateName;
  String? status;
  String? createdAt;
  String? updatedAt;

  StateData(
      {this.id,
      this.countryId,
      this.stateName,
      this.status,
      this.createdAt,
      this.updatedAt});

  StateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    stateName = json['state_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  
}

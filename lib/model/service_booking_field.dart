class ServiceBookingFieldModel {
  int? status;
  List<Fields>? fields;

  ServiceBookingFieldModel({this.status, this.fields});

  ServiceBookingFieldModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

}

class Fields {
  String? fieldName;
  String? type;

  Fields({this.fieldName, this.type});

  Fields.fromJson(Map<String, dynamic> json) {
    fieldName = json['field_name'];
    type = json['type'];
  }


}

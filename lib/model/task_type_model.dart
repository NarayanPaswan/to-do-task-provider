class TaskTypeModel {
  int? status;
  List<Items>? items;

  TaskTypeModel({this.status, this.items});

  TaskTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
 
}

class Items {
  int? id;
  String? taskName;
  String? taskStatus;

  Items({this.id, this.taskName, this.taskStatus});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['task_name'];
    taskStatus = json['task_status'];
  }

}

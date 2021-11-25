class DataModel {
  String name;
  int count;
  bool isSelect;
  int roleId;


  DataModel({this.name, this.count, this.isSelect, this.roleId});

  DataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    isSelect = json['isSelect'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['isSelect'] = this.isSelect;
    data['roleId'] = this.roleId;
    return data;
  }
}

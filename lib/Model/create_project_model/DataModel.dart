class DataModel {
  String name;
  bool select;

  DataModel({this.name, this.select});

  DataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['select'] = this.select;
    return data;
  }
}

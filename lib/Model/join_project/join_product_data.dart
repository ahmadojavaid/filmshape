class JonProductData {
  List<Data> data;

  JonProductData({this.data});

  JonProductData.fromJson(List<dynamic> dataList) {
    if (dataList != null) {
      data = new List<Data>();
      dataList.forEach((item) {
        print("item $item");
        data.add(new Data.fromJson(item));
      });
      //data=dataList;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;

  Data(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.description,
      this.url,
      this.name});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['description'] = this.description;
    data['url'] = this.url;
    data['name'] = this.name;
    return data;
  }
}

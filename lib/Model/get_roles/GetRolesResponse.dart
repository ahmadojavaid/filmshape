class GetRolesResponseMain {
  List<GetRolesResponse> data;

  GetRolesResponseMain({this.data});

  GetRolesResponseMain.fromJson(List<dynamic> listData) {
    if (listData != null) {
      data = new List<GetRolesResponse>();
      listData.forEach((v) {
        data.add(new GetRolesResponse.fromJson(v));
      });
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

class GetRolesResponse {
  Category category;

  List<RolesData> roles;

  GetRolesResponse({this.category, this.roles});

  GetRolesResponse.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['roles'] != null) {
      roles = new List<RolesData>();
      json['roles'].forEach((v) {
        roles.add(new RolesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;
  String iconUrl;
  bool isExpend;

  Category(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.description,
      this.url,
      this.name,
      this.iconUrl,
      this.isExpend});

  Category.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    name = json['name'];
    iconUrl = json['icon_url'];
    ;
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
    data['icon_url'] = this.iconUrl;
    return data;
  }
}

class RolesData {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;
  Category category;
  String iconUrl;
  bool isChecked = false;

  RolesData(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.description,
      this.url,
      this.name,
      this.category,
      this.isChecked,
      this.iconUrl});

  RolesData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    name = json['name'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    iconUrl = json['icon_url'];
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
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['icon_url'] = this.iconUrl;
    return data;
  }
}

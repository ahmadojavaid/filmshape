class MyProjectFilters {
  CreatorInfo creator;

  MyProjectFilters({this.creator});

  MyProjectFilters.fromJson(Map<String, dynamic> json) {
    creator =
    json['creator'] != null ? new CreatorInfo.fromJson(json['creator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    return data;
  }
}

class CreatorInfo {
  String type;
  String id;

  CreatorInfo({this.type, this.id});

  CreatorInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}
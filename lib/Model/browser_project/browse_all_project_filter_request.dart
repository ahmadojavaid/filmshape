class BrowseAllProjectFilterRequest {
  ProjectType projectType;
  ProjectType genre;
  String createdIcontains;

  BrowseAllProjectFilterRequest(
      {this.projectType, this.genre, this.createdIcontains});

  BrowseAllProjectFilterRequest.fromJson(Map<String, dynamic> json) {
    projectType = json['project_type'] != null
        ? new ProjectType.fromJson(json['project_type'])
        : null;
    genre =
    json['genre'] != null ? new ProjectType.fromJson(json['genre']) : null;
    createdIcontains = json['created__icontains'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projectType != null) {
      data['project_type'] = this.projectType.toJson();
    }
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }
    if(this.createdIcontains!=null)
    data['created__icontains'] = this.createdIcontains;
    return data;
  }
}

class ProjectType {
  String type;
  int id;

  ProjectType({this.type, this.id});

  ProjectType.fromJson(Map<String, dynamic> json) {
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

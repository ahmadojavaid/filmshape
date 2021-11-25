class AddAwardsRequest {
  ProjectsAwards project;
  String title;
  String description;
  String url;
  String awardInstitution;

  AddAwardsRequest({this.project, this.title, this.description, this.url,this.awardInstitution});

  AddAwardsRequest.fromJson(Map<String, dynamic> json) {
    project = json['project'] != null
        ? new ProjectsAwards.fromJson(json['project'])
        : null;
    title = json['title'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.project != null) {
      data['project'] = this.project.toJson();
    }

    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['awarding_institution']=this.awardInstitution;
    return data;
  }
}

class ProjectsAwards {
  String type;
  String id;

  ProjectsAwards({this.type, this.id});

  ProjectsAwards.fromJson(Map<String, dynamic> json) {
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

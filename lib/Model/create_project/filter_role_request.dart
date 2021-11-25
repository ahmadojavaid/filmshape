class FilterRoleRequest {
  Project project;
  Project role;

  FilterRoleRequest({this.project, this.role});

  FilterRoleRequest.fromJson(Map<String, dynamic> json) {
    project =
    json['project'] != null ? new Project.fromJson(json['project']) : null;
    role = json['role'] != null ? new Project.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.project != null) {
      data['project'] = this.project.toJson();
    }
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    return data;
  }
}

class Project {
  String type;
  String id;

  Project({this.type, this.id});

  Project.fromJson(Map<String, dynamic> json) {
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
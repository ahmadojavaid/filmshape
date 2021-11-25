import 'package:Filmshape/Model/create_project/filter_role_request.dart';

class AddRoleRequest {
  Project project;
  Project role;

  AddRoleRequest({this.project, this.role});

  AddRoleRequest.fromJson(Map<String, dynamic> json) {
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

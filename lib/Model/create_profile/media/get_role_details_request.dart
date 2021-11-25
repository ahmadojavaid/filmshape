import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';

class GetRolesProjectRequest {
  RolesCreateProfile project;
  RolesCreateProfile role;

  GetRolesProjectRequest({
    this.project,
    this.role,
  });

  GetRolesProjectRequest.fromJson(Map<String, dynamic> json) {
    project = json['project'] != null
        ? new RolesCreateProfile.fromJson(json['project'])
        : null;
    role = json['role'] != null
        ? new RolesCreateProfile.fromJson(json['role'])
        : null;
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

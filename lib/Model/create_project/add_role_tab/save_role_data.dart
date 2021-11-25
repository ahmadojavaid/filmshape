import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';

class SaveRoleCallRequest {
  RolesCreateProfile role;
  int height;
  int weight;
  RolesCreateProfile gender;
  RolesCreateProfile ethnicity;
  RolesCreateProfile assignee;
  RolesCreateProfile project;
  String description;
  String location;
  String name;
  int salary=0;
  bool expensesPaid;
  bool hideSalary;

  SaveRoleCallRequest({
    this.role,
    this.height,
    this.weight,
    this.gender,
    this.ethnicity,
    this.location,
    this.name,
    this.description,
    this.salary,
    this.expensesPaid,
    this.assignee,
    this.project,
  });

  SaveRoleCallRequest.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    weight = json['weight'];
    gender = json['gender'] != null
        ? new RolesCreateProfile.fromJson(json['gender'])
        : null;
    ethnicity = json['ethnicity'] != null
        ? new RolesCreateProfile.fromJson(json['ethnicity'])
        : null;
    role = json['role'] != null
        ? new RolesCreateProfile.fromJson(json['role'])
        : null;

    assignee = json['assignee'] != null
        ? new RolesCreateProfile.fromJson(json['assignee'])
        : null;

    project = json['project'] != null
        ? new RolesCreateProfile.fromJson(json['project'])
        : null;
    description = json['description'];
    name = json['name'];
    location = json['location'];
    salary = json['salary'];
    expensesPaid = json['expenses_paid'];
    hideSalary = json['hide_salary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.height != null) data['height'] = this.height;
    if (this.weight != null) data['weight'] = this.weight;
    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    if (this.ethnicity != null) {
      data['ethnicity'] = this.ethnicity.toJson();
    }
    if (this.assignee != null) {
      data['assignee'] = this.assignee.toJson();
    }


    if (this.project != null) {
      data['project'] = this.project.toJson();
    }
    if (this.description != null) data['description'] = this.description;

    if (this.location != null) data['location'] = this.location;

    if (this.salary != null) data['salary'] = this.salary;
    if (this.name != null) data['name'] = this.name;

    if (this.expensesPaid != null) data['expenses_paid'] = this.expensesPaid;

    if (this.hideSalary != null) data['hide_salary'] = this.hideSalary;

    return data;
  }
}

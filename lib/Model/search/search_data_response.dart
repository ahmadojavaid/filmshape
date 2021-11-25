import 'package:Filmshape/Model/following_suggestion/suggestion_response.dart';
import 'package:Filmshape/Model/myprojects/my_projects_response.dart';

class SearchListResponse {
  List<ProjectData> projects;
  List<Users> users;
  String query;

  SearchListResponse({this.projects, this.users, this.query});

  SearchListResponse.fromJson(Map<String, dynamic> json) {
    if (json['projects'] != null) {
      projects = new List<ProjectData>();
      json['projects'].forEach((v) {
        projects.add(new ProjectData.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projects != null) {
      data['projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['query'] = this.query;
    return data;
  }
}

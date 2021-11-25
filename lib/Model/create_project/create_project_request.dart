import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';

class CreateProjectRequest {
  RolesCreateProfile status;
  RolesCreateProfile genre;
  RolesCreateProfile project_type;
  String title;
  String type;
  String location;
  String description;
  String media;
  String mediaEmbed;
  CreateProjectRequest({
    this.status,
    this.genre,
    this.type,
    this.project_type,
    this.location,
    this.description,
    this.title,
  });

  CreateProjectRequest.fromJson(Map<String, dynamic> json) {
    genre = json['genre'] != null
        ? new RolesCreateProfile.fromJson(json['genre'])
        : null;
    status = json['status'] != null
        ? new RolesCreateProfile.fromJson(json['status'])
        : null;

    project_type = json['project_type'] != null
        ? new RolesCreateProfile.fromJson(json['project_type'])
        : null;
    title = json['title'];
    type = json['type'];
    location = json['location'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.project_type != null) {
      data['project_type'] = this.project_type.toJson();
    }
    if (this.title != null) data['title'] = this.title;
    if (this.location != null) data['location'] = this.location;
    if (this.description != null) data['description'] = this.description;
    if (this.type != null) data['type'] = this.type;
    if (this.media != null) data['media'] = this.media;
    if (this.mediaEmbed != null) data['media_embed'] = this.mediaEmbed;


    return data;
  }
}

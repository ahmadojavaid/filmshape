class JoinRequest {
  List<RolesCreateProfile> roles;
  RolesCreateProfile project_type;
  RolesCreateProfile genre;
  RolesCreateProfile status;
  String location;

  JoinRequest({
    this.roles,
    this.project_type,
    this.genre,
    this.status,
    this.location,
  });

  JoinRequest.fromJson(Map<String, dynamic> json) {
    if (json['roles'] != null) {
      roles = new List<RolesCreateProfile>();
      json['roles'].forEach((v) {
        roles.add(new RolesCreateProfile.fromJson(v));
      });
    }

    project_type = json['project_type'] != null
        ? new RolesCreateProfile.fromJson(json['project_type'])
        : null;
    genre = json['genre'] != null
        ? new RolesCreateProfile.fromJson(json['genre'])
        : null;
    status = json['status'] != null
        ? new RolesCreateProfile.fromJson(json['status'])
        : null;

    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    if (this.project_type != null) {
      data['project_type'] = this.project_type.toJson();
    }
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }

    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if(this.location!=null)
    data['location'] = this.location;

    return data;
  }
}

class RolesCreateProfile {
  String type;
  int id;

  RolesCreateProfile({this.type, this.id});

  RolesCreateProfile.fromJson(Map<String, dynamic> json) {
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

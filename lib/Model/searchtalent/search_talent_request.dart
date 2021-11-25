class SearchTalentRequest {
  List<RolesCreateProfile> roles;
  RolesCreateProfile gender;
  RolesCreateProfile ethnicity;
  String location;
  int height;
  int weight;

  SearchTalentRequest({
    this.roles,
    this.gender,
    this.ethnicity,
    this.location,
    this.height,
    this.weight
  });

  SearchTalentRequest.fromJson(Map<String, dynamic> json) {
    if (json['roles'] != null) {
      roles = new List<RolesCreateProfile>();
      json['roles'].forEach((v) {
        roles.add(new RolesCreateProfile.fromJson(v));
      });
    }

      gender = json['gender'] != null
        ? new RolesCreateProfile.fromJson(json['gender'])
        : null;
    ethnicity = json['ethnicity'] != null
        ? new RolesCreateProfile.fromJson(json['ethnicity'])
        : null;

    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roles != null) {
      data['roles__in'] = this.roles.map((v) => v.toJson()).toList();
    }

    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }

    if (this.ethnicity != null) {
      data['ethnicity'] = this.ethnicity.toJson();
    }
    if(this.location!=null)
      data['location'] = this.location;

    if(this.height!=null)
      data['height'] = this.height;

    if(this.weight!=null)
      data['weight'] = this.weight;

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

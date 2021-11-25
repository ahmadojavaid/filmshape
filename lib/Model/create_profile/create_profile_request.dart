

class CreateProfileRequest {
  List<RolesCreateProfile> roles;
  int height;
  int weight;
  RolesCreateProfile gender;
  RolesCreateProfile ethnicity;
  String bio;
  String location;
  String full_name;
  String date_of_birth;

  CreateProfileRequest(
      {this.roles,
      this.height,
      this.weight,
      this.gender,
      this.ethnicity,
        this.location,
        this.full_name,
        this.bio,
        this.date_of_birth,


      });

  CreateProfileRequest.fromJson(Map<String, dynamic> json) {
    if (json['roles'] != null) {
      roles = new List<RolesCreateProfile>();
      json['roles'].forEach((v) {
        roles.add(new RolesCreateProfile.fromJson(v));
      });
    }
    height = json['height'];
    weight = json['weight'];
    date_of_birth = json['date_of_birth'];
    gender = json['gender'] != null
        ? new RolesCreateProfile.fromJson(json['gender'])
        : null;
    ethnicity = json['ethnicity'] != null
        ? new RolesCreateProfile.fromJson(json['ethnicity'])
        : null;
    bio = json['bio'];
    location = json['location'];
    full_name = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    if(this.height!=null)
    data['height'] = this.height;
    if(this.weight!=null)
    data['weight'] = this.weight;
    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }
    if (this.ethnicity != null) {
      data['ethnicity'] = this.ethnicity.toJson();
    }
    if(this.bio!=null)
    data['bio'] = this.bio;

    if (this.date_of_birth != null)
      data['date_of_birth'] = this.date_of_birth;

    if(this.location!=null)
    data['location'] = this.location;
    if(this.full_name!=null)
    data['full_name'] = this.full_name;
    if(this.full_name!=null)
      data['full_name'] = this.full_name;


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

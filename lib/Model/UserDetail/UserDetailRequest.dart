class UserDetailRequest {
  String name;
  String contactName;
  String email;
  String countryCode;
  String phone;
  String profilePic;
  String website;
  int verifiedStatus;
  List<String> farmPics;
  List<String> region;
  List<String> variety;
  Elevation elevation;
  int farmSize;
  List<String> process;
  List<String> certifications;
  int isProfileCompleted;

  UserDetailRequest({
    this.name,
    this.contactName,
    this.email,
    this.countryCode,
    this.phone,
    this.profilePic,
    this.website,
    this.verifiedStatus,
    this.farmPics,
    this.region,
    this.variety,
    this.elevation,
    this.farmSize,
    this.process,
    this.certifications,
    this.isProfileCompleted,
  });

  UserDetailRequest.fromJson(Map<String, dynamic> json) {
    print("UserDetailRequest--->${json}");
    name = json['name'];
    contactName = json['contact_name'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    profilePic = json['profile_pic'];
    website = json['website'];
    verifiedStatus = json['verified_status'];
    farmPics = json['farm_pics'].cast<String>();
    region = json['region'].cast<String>();
    variety = json['variety'].cast<String>();
    elevation = json['elevation'] != null
        ? new Elevation.fromJson(json['elevation'])
        : null;
    farmSize = json['farm_size'];
    process = json['process'].cast<String>();
    certifications = json['certifications'].cast<String>();
    isProfileCompleted = json["is_profile_completed"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact_name'] = this.contactName;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['profile_pic'] = this.profilePic;
    data['website'] = this.website;
    data['verified_status'] = this.verifiedStatus;
    data['farm_pics'] = this.farmPics;
    data['region'] = this.region;
    data['variety'] = this.variety;
    if (this.elevation != null) {
      data['elevation'] = this.elevation.toJson();
    }
    data['farm_size'] = this.farmSize;
    data['process'] = this.process;
    data['certifications'] = this.certifications;
    data['is_profile_completed'] = this.isProfileCompleted;
    return data;
  }
}

class Elevation {
  int from;
  int to;

  Elevation({this.from, this.to});

  Elevation.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

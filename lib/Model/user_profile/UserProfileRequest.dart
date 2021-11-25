class UserProfileRequest {
  String name;
  String email;
  String phoneNumber;
  String facebookProviderId;
  String googleProviderId;
  String address;
  String city;
  String state;
  String country;
  String zip;
  String lattitude;
  String longitude;
  String dob;
  int roleId;
  int status;
  String paypal_email;
  String profile_pic;

  UserProfileRequest(
      {this.name,
      this.email,
      this.phoneNumber,
      this.facebookProviderId,
      this.googleProviderId,
      this.address,
      this.city,
      this.state,
      this.country,
      this.zip,
      this.lattitude,
      this.longitude,
      this.dob,
      this.roleId,
      this.status,
      this.paypal_email,
      this.profile_pic});

  UserProfileRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    facebookProviderId = json['facebook_provider_id'];
    googleProviderId = json['google_provider_id'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zip = json['zip'];
    lattitude = json['lattitude'];
    longitude = json['longitude'];
    dob = json['dob'];
    roleId = json['role_id'];
    status = json['status'];
    paypal_email = json['paypal_email'];
    profile_pic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['facebook_provider_id'] = this.facebookProviderId;
    data['google_provider_id'] = this.googleProviderId;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zip'] = this.zip;
    data['lattitude'] = this.lattitude;
    data['longitude'] = this.longitude;
    data['dob'] = this.dob;
    data['role_id'] = this.roleId;
    data['status'] = this.status;
    data['paypal_email'] = this.paypal_email;
    data['profile_pic'] = this.profile_pic;

    return data;
  }
}

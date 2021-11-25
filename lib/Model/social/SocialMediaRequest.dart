class SocialMediaRequest {
  String email;
  String name;
  String providerId;
  int type;
  String phoneNumber;

  SocialMediaRequest(
      {this.email, this.name, this.providerId, this.type, this.phoneNumber});

  SocialMediaRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    providerId = json['provider_id'];
    type = json['type'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['provider_id'] = this.providerId;
    data['type'] = this.type;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

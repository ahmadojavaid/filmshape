class LoginMediaRequest {
  String providerId;
  int type;
  String email;

  LoginMediaRequest({this.providerId, this.type, this.email});

  LoginMediaRequest.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    type = json['type'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider_id'] = this.providerId;
    data['type'] = this.type;
    data['email'] = this.email;
    return data;
  }
}

class RegistrationOtpResponse {
  String message;
  Data data;

  RegistrationOtpResponse({this.message, this.data});

  RegistrationOtpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String token;
  User user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String phoneNumber;
  int roleId;
  int status;
  String paypalEmail;
  int emailVerified;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.roleId,
      this.status,
      this.emailVerified,
      this.paypalEmail,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    roleId = json['role_id'];
    status = json['status'];
    emailVerified = json['email_verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paypalEmail = json['paypal_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['role_id'] = this.roleId;
    data['status'] = this.status;
    data['email_verified'] = this.emailVerified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['paypal_email'] = this.paypalEmail;
    return data;
  }
}

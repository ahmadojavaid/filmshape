class ChangePasswordRequest {
  int userId;
  int otp;
  String password;

  ChangePasswordRequest({this.userId, this.otp, this.password});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    otp = json['otp'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['otp'] = this.otp;
    data['password'] = this.password;
    return data;
  }
}

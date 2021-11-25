class ChangePasswordRequest {
  String password;
  String oldPassword;

  ChangePasswordRequest({this.password,this.oldPassword});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['old_password'] = this.oldPassword;

    return data;
  }
}

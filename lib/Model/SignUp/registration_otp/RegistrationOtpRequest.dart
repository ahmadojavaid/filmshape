class RegistrationOtpRequest {
  String email;
  int otp;

  RegistrationOtpRequest({this.email, this.otp});

  RegistrationOtpRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['otp'] = this.otp;
    return data;
  }
}

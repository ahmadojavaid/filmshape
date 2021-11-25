class ForgotPasswordOtpRequest {
  int otp;
  String email;

  ForgotPasswordOtpRequest({this.otp, this.email});

  ForgotPasswordOtpRequest.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['email'] = this.email;
    return data;
  }
}

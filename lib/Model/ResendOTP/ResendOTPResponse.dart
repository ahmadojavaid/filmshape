class ResendOTPResponse {
  String message;
  int status;
  String otp;

  ResendOTPResponse({this.message, this.status, this.otp});

  ResendOTPResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['otp'] = this.otp;
    return data;
  }
}

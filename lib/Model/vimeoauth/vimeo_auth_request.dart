class VimeoAuthRequest {
  String grantType;
  String code;
  String redirectUri;

  VimeoAuthRequest({this.grantType, this.code, this.redirectUri});

  VimeoAuthRequest.fromJson(Map<String, dynamic> json) {
    grantType = json['grant_type'];
    code = json['code'];
    redirectUri = json['redirect_uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grant_type'] = this.grantType;
    data['code'] = this.code;
    data['redirect_uri'] = this.redirectUri;
    return data;
  }
}

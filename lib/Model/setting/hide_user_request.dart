class HideUserRequest {
  bool hidden;

  HideUserRequest({this.hidden});

  HideUserRequest.fromJson(Map<String, dynamic> json) {
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hidden'] = this.hidden;
    return data;
  }
}

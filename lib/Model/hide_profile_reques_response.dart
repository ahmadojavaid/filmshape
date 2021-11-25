class HideProfileRequestResponse {
  bool hidden;

  HideProfileRequestResponse({this.hidden});

  HideProfileRequestResponse.fromJson(Map<String, dynamic> json) {
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hidden'] = this.hidden;
    return data;
  }
}
class HideSalaryRequest {
  bool private;


  HideSalaryRequest({this.private});

  HideSalaryRequest.fromJson(Map<String, dynamic> json) {
    private = json['private'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['private'] = this.private;

    return data;
  }
}

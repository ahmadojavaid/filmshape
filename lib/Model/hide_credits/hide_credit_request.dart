class HideCreditRequest {
  bool hideCredit;

  HideCreditRequest({this.hideCredit});

  HideCreditRequest.fromJson(Map<String, dynamic> json) {
    hideCredit = json['hide_credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hide_credit'] = this.hideCredit;
    return data;
  }
}
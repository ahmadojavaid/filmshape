class CancelOrderRequest {
  int order_id;
  String reason;

  CancelOrderRequest({this.order_id, this.reason});

  CancelOrderRequest.fromJson(Map<String, dynamic> json) {
    order_id = json['order_id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.order_id;
    data['reason'] = this.reason;
    return data;
  }
}

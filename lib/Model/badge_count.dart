class BadgeCount {
  int count;
  int type;

  BadgeCount({this.count, this.type});

  BadgeCount.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['type'] = this.type;
    return data;
  }
}

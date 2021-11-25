class FollowResponse {
  bool follow;

  FollowResponse({this.follow});

  FollowResponse.fromJson(Map<String, dynamic> json) {
    follow = json['follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['follow'] = this.follow;
    return data;
  }
}

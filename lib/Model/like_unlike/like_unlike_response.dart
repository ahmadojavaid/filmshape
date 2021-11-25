class LikesResponse {
  int likes;

  LikesResponse({this.likes});

  LikesResponse.fromJson(Map<String, dynamic> json) {
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likes'] = this.likes;
    return data;
  }
}

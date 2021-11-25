class CommentRequest {
  String content;
  ReplyTo replyTo;

  CommentRequest({this.content, this.replyTo});

  CommentRequest.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    replyTo = json['reply_to'] != null
        ? new ReplyTo.fromJson(json['reply_to'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    if (this.replyTo != null) {
      data['reply_to'] = this.replyTo.toJson();
    }
    return data;
  }
}

class ReplyTo {
  String type;
  int id;

  ReplyTo({this.type, this.id});

  ReplyTo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

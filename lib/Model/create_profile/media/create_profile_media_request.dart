class UserShowReelRequest {
  String title;
  String description;
  String media;
  String mediaEmbed;
  String url;

  UserShowReelRequest({this.title, this.description, this.media,this.url});

  UserShowReelRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    media = json['media'];
    mediaEmbed = json['media_embed'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.title!=null)
    data['title'] = this.title;
    if(this.description!=null)
    data['description'] = this.description;
    if(this.media!=null)
    data['media'] = this.media;
    if(this.url!=null)
    data['url'] = this.url;
    if(this.mediaEmbed!=null)
      data['media_embed'] = this.mediaEmbed;
      return data;
  }
}

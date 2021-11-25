class ChannelIdResponse {
  String kind;
  String etag;
  PageInfo pageInfo;
  List<Items> items;

  ChannelIdResponse({this.kind, this.etag, this.pageInfo, this.items});

  ChannelIdResponse.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    pageInfo = json['pageInfo'] != null
        ? new PageInfo.fromJson(json['pageInfo'])
        : null;
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['etag'] = this.etag;
    if (this.pageInfo != null) {
      data['pageInfo'] = this.pageInfo.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageInfo {
  int totalResults;
  int resultsPerPage;

  PageInfo({this.totalResults, this.resultsPerPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    totalResults = json['totalResults'];
    resultsPerPage = json['resultsPerPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalResults'] = this.totalResults;
    data['resultsPerPage'] = this.resultsPerPage;
    return data;
  }
}

class Items {
  String kind;
  String etag;
  String id;

  Items({this.kind, this.etag, this.id});

  Items.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['etag'] = this.etag;
    data['id'] = this.id;
    return data;
  }
}

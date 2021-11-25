class VimeoVideosListResponse {
  int total;
  int page;
  int perPage;
  Paging paging;
  List<Data> data;

  VimeoVideosListResponse(
      {this.total, this.page, this.perPage, this.paging, this.data});

  VimeoVideosListResponse.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    perPage = json['per_page'];
    paging =
    json['paging'] != dynamic ? new Paging.fromJson(json['paging']) : dynamic;
    if (json['data'] != dynamic) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    if (this.paging != dynamic) {
      data['paging'] = this.paging.toJson();
    }
    if (this.data != dynamic) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Paging {
  String next;
  String previous;
  String first;
  String last;

  Paging({this.next, this.previous, this.first, this.last});

  Paging.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    previous = json['previous'];
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    data['previous'] = this.previous;
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }
}

class Data {
  String uri;
  String name;
  String description;
  String type;
  String link;
  int duration;
  int width;
  String language;
  int height;
  Embed embed;
  String createdTime;
  String modifiedTime;
  String releaseTime;
  List<String> contentRating;
  User user;
  dynamic parentFolder;
  String lastUserActionEventDate;
  String status;
  String resourceKey;
  Pictures pictures;

  Data(
      {this.uri,
        this.name,
        this.description,
        this.type,
        this.link,
        this.duration,
        this.width,
        this.language,
        this.height,
        this.embed,
        this.createdTime,
        this.modifiedTime,
        this.releaseTime,
        this.contentRating,
        this.pictures,
        this.user,
        this.parentFolder,
        this.lastUserActionEventDate,
        this.status,
        this.resourceKey,
      });

  Data.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    link = json['link'];
    duration = json['duration'];
    width = json['width'];
    language = json['language'];
    height = json['height'];
    embed = json['embed'] != dynamic ? new Embed.fromJson(json['embed']) : dynamic;
    createdTime = json['created_time'];
    modifiedTime = json['modified_time'];
    releaseTime = json['release_time'];
    pictures =
    json['pictures'] != dynamic ? new Pictures.fromJson(json['pictures']) : dynamic;


    parentFolder = json['parent_folder'];
    lastUserActionEventDate = json['last_user_action_event_date'];
    status = json['status'];
    resourceKey = json['resource_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['link'] = this.link;
    data['duration'] = this.duration;
    data['width'] = this.width;
    data['language'] = this.language;
    data['height'] = this.height;

    data['created_time'] = this.createdTime;
    data['modified_time'] = this.modifiedTime;
    data['release_time'] = this.releaseTime;
    data['content_rating'] = this.contentRating;

    if (this.pictures != dynamic) {
      data['pictures'] = this.pictures.toJson();
    }


    if (this.user != dynamic) {
      data['user'] = this.user.toJson();
    }

    data['parent_folder'] = this.parentFolder;
    data['last_user_action_event_date'] = this.lastUserActionEventDate;

    data['status'] = this.status;
    data['resource_key'] = this.resourceKey;

    return data;
  }
}

class Embed {
  bool playbar;
  bool volume;
  bool speed;
  String color;
  dynamic uri;
  String html;

  Embed({ this.playbar,
    this.volume,
    this.speed,
    this.color,
    this.uri,
    this.html,
  });

  Embed.fromJson(Map<String, dynamic> json) {
    playbar = json['playbar'];
    volume = json['volume'];
    speed = json['speed'];
    color = json['color'];
    uri = json['uri'];
    html = json['html'];


    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();

      data['playbar'] = this.playbar;
      data['volume'] = this.volume;
      data['speed'] = this.speed;
      data['color'] = this.color;
      data['uri'] = this.uri;
      data['html'] = this.html;

      return data;
    }
  }
}

class Buttons {
  bool like;
  bool watchlater;
  bool share;
  bool embed;
  bool hd;
  bool fullscreen;
  bool scaling;

  Buttons(
      {this.like,
        this.watchlater,
        this.share,
        this.embed,
        this.hd,
        this.fullscreen,
        this.scaling});

  Buttons.fromJson(Map<String, dynamic> json) {
    like = json['like'];
    watchlater = json['watchlater'];
    share = json['share'];
    embed = json['embed'];
    hd = json['hd'];
    fullscreen = json['fullscreen'];
    scaling = json['scaling'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like'] = this.like;
    data['watchlater'] = this.watchlater;
    data['share'] = this.share;
    data['embed'] = this.embed;
    data['hd'] = this.hd;
    data['fullscreen'] = this.fullscreen;
    data['scaling'] = this.scaling;
    return data;
  }
}







class Pictures {
  String uri;
  bool active;
  String type;
  List<Sizes> sizes;
  String resourceKey;

  Pictures({this.uri, this.active, this.type, this.sizes, this.resourceKey});

  Pictures.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    active = json['active'];
    type = json['type'];
    if (json['sizes'] != dynamic) {
      sizes = new List<Sizes>();
      json['sizes'].forEach((v) {
        sizes.add(new Sizes.fromJson(v));
      });
    }
    resourceKey = json['resource_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    data['active'] = this.active;
    data['type'] = this.type;
    if (this.sizes != dynamic) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    data['resource_key'] = this.resourceKey;
    return data;
  }
}

class Sizes {
  int width;
  int height;
  String link;
  String linkWithPlayButton;

  Sizes({this.width, this.height, this.link, this.linkWithPlayButton});

  Sizes.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    link = json['link'];
    linkWithPlayButton = json['link_with_play_button'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['link'] = this.link;
    data['link_with_play_button'] = this.linkWithPlayButton;
    return data;
  }
}

















class User {
  String uri;
  String name;
  String link;
  String location;
  String gender;
  dynamic bio;
  dynamic shortBio;
  String createdTime;
  List<dynamic> websites;
  bool availableForHire;
  List<String> contentFilter;
  String resourceKey;
  String account;

  User(
      {this.uri,
        this.name,
        this.link,
        this.location,
        this.gender,
        this.bio,
        this.shortBio,
        this.createdTime,
        this.websites,
        this.availableForHire,
        this.contentFilter,
        this.resourceKey,
        this.account});

  User.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    name = json['name'];
    link = json['link'];
    location = json['location'];
    gender = json['gender'];
    bio = json['bio'];
    shortBio = json['short_bio'];
    createdTime = json['created_time'];


    availableForHire = json['available_for_hire'];
       resourceKey = json['resource_key'];
    account = json['account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    data['name'] = this.name;
    data['link'] = this.link;
    data['location'] = this.location;
    data['gender'] = this.gender;
    data['bio'] = this.bio;
    data['short_bio'] = this.shortBio;
    data['created_time'] = this.createdTime;


    data['available_for_hire'] = this.availableForHire;

    data['content_filter'] = this.contentFilter;
    data['resource_key'] = this.resourceKey;
    data['account'] = this.account;
    return data;
  }
}





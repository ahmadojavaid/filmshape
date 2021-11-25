class NotificationResponse {
  List<Seen> seen;
  List<Unseen> unseen;

  NotificationResponse({this.seen, this.unseen});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    if (json['seen'] != null) {
      seen = new List<Seen>();
      json['seen'].forEach((v) {
        seen.add(new Seen.fromJson(v));
      });
    }
    if (json['unseen'] != null) {
      unseen = new List<Unseen>();
      json['unseen'].forEach((v) {
        unseen.add(new Unseen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.seen != null) {
      data['seen'] = this.seen.map((v) => v.toJson()).toList();
    }
    if (this.unseen != null) {
      data['unseen'] = this.unseen.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seen {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  Sender sender;
  Receiver receiver;
  String link;
  String message;
  bool seen;
  bool following;

  Seen(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.sender,
      this.receiver,
      this.link,
      this.message,
      this.seen,
      this.following});

  Seen.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    receiver = json['receiver'] != null
        ? new Receiver.fromJson(json['receiver'])
        : null;
    link = json['link'];
    message = json['message'];
    seen = json['seen'];
    following = json['following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver.toJson();
    }
    data['link'] = this.link;
    data['message'] = this.message;
    data['seen'] = this.seen;
    data['following'] = this.following;
    return data;
  }
}

class Unseen {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  Sender sender;
  Receiver receiver;
  String link;
  String message;
  bool seen;
  bool following;

  Unseen(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.sender,
      this.receiver,
      this.link,
      this.message,
      this.seen,
      this.following});

  Unseen.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    receiver = json['receiver'] != null
        ? new Receiver.fromJson(json['receiver'])
        : null;
    link = json['link'];
    message = json['message'];
    seen = json['seen'];
    following = json['following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver.toJson();
    }
    data['link'] = this.link;
    data['message'] = this.message;
    data['seen'] = this.seen;
    data['following'] = this.following;
    return data;
  }
}

class Sender {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String thumbnailUrl;
  String location;
  String username;
  String fullName;
  int height;
  int weight;
  bool isFeatured;
  String lastSeen;
  bool isStaff;
  bool isVerified;
  String bio;
  int followingNumber;
  int followersNumber;
  bool isOnline;
  String description;
  String url;

  Sender(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.thumbnailUrl,
      this.location,
      this.username,
      this.fullName,
      this.height,
      this.weight,
      this.isFeatured,
      this.lastSeen,
      this.isStaff,
      this.isVerified,
      this.bio,
      this.followingNumber,
      this.followersNumber,
      this.isOnline,
      this.description,
      this.url});

  Sender.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    thumbnailUrl = json['thumbnail_url'];
    location = json['location'];
    username = json['username'];
    fullName = json['full_name'];
    height = json['height'];
    weight = json['weight'];
    isFeatured = json['is_featured'];
    lastSeen = json['last_seen'];
    isStaff = json['is_staff'];
    isVerified = json['is_verified'];
    bio = json['bio'];
    followingNumber = json['following_number'];
    followersNumber = json['followers_number'];
    isOnline = json['is_online'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['location'] = this.location;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['is_featured'] = this.isFeatured;
    data['last_seen'] = this.lastSeen;
    data['is_staff'] = this.isStaff;
    data['is_verified'] = this.isVerified;
    data['bio'] = this.bio;
    data['following_number'] = this.followingNumber;
    data['followers_number'] = this.followersNumber;
    data['is_online'] = this.isOnline;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class Receiver {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String thumbnailUrl;
  String location;
  String username;
  String fullName;
  int height;
  int weight;
  bool isFeatured;
  String lastSeen;
  bool isStaff;
  bool isVerified;
  String bio;
  int followingNumber;
  int followersNumber;
  bool isOnline;
  String description;
  String url;

  Receiver(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.thumbnailUrl,
      this.location,
      this.username,
      this.fullName,
      this.height,
      this.weight,
      this.isFeatured,
      this.lastSeen,
      this.isStaff,
      this.isVerified,
      this.bio,
      this.followingNumber,
      this.followersNumber,
      this.isOnline,
      this.description,
      this.url});

  Receiver.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    thumbnailUrl = json['thumbnail_url'];
    location = json['location'];
    username = json['username'];
    fullName = json['full_name'];
    height = json['height'];
    weight = json['weight'];
    isFeatured = json['is_featured'];
    lastSeen = json['last_seen'];
    isStaff = json['is_staff'];
    isVerified = json['is_verified'];
    bio = json['bio'];
    followingNumber = json['following_number'];
    followersNumber = json['followers_number'];
    isOnline = json['is_online'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['location'] = this.location;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['is_featured'] = this.isFeatured;
    data['last_seen'] = this.lastSeen;
    data['is_staff'] = this.isStaff;
    data['is_verified'] = this.isVerified;
    data['bio'] = this.bio;
    data['following_number'] = this.followingNumber;
    data['followers_number'] = this.followersNumber;
    data['is_online'] = this.isOnline;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

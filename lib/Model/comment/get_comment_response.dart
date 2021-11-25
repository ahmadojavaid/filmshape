import 'package:Filmshape/Model/feed/feed_response.dart';

class GetCommentMainResponse {
  List<Comments> data;

  GetCommentMainResponse({this.data});

  GetCommentMainResponse.fromJson(List<dynamic> dataList) {
    if (dataList != null) {
      data = new List<Comments>();
      dataList.forEach((item) {
        print("item $item");
        data.add(new Comments.fromJson(item));
      });
      //data=dataList;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class GetCommentResponse {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String content;
  Author author;
  List<Reply> replyTo;
  List<Reply> replies;
  List<Author> mentionedUsers;
  List<Author> likedByUserIds;
  List<int> likedBy;

  GetCommentResponse({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.content,
    this.author,
    this.replyTo,
    this.replies,
    this.mentionedUsers,
    this.likedByUserIds,
    this.likedBy});

  GetCommentResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    content = json['content'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;


    if (json['replies'] != null) {
      replyTo = new List<Reply>();
      json['replies'].forEach((v) {
        replyTo.add(new Reply.fromJson(v));
      });
    }

    if (json['replies'] != null) {
      replies = new List<Reply>();
      json['replies'].forEach((v) {
        replies.add(new Reply.fromJson(v));
      });
    }
    if (json['mentioned_users'] != null) {
      mentionedUsers = new List<Author>();
      json['mentioned_users'].forEach((v) {
        mentionedUsers.add(new Author.fromJson(v));
      });
    }

    likedBy = json['liked_by']?.cast<int>();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['content'] = this.content;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.replyTo != null) {
      data['reply_to'] = this.replyTo.map((v) => v.toJson()).toList();
    }


    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
    }
    if (this.mentionedUsers != null) {
      data['mentioned_users'] =
          this.mentionedUsers.map((v) => v.toJson()).toList();
    }
    if (this.likedByUserIds != null) {
      data['liked_by_user_ids'] =
          this.likedByUserIds.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Author {
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

  Author({this.type,
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

  Author.fromJson(Map<String, dynamic> json) {
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


class Reply {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String content;
  Author author;
  List<Reply> mentionedUsers;

/*  List<Reply> likedByUserIds;*/
  List<int> likedBy;
  bool isLike;

  Reply({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.content,
    this.author,
    this.mentionedUsers,
    /*   this.likedByUserIds,*/
    this.likedBy,
    this.isLike
  });

  Reply.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    content = json['content'];
    isLike = json['isLike'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
//    if (json['mentioned_users'] != null) {
//      mentionedUsers = new List<Reply>();
//      json['mentioned_users'].forEach((v) {
//        mentionedUsers.add(new Reply.fromJson(v));
//      });
//    }
    /*   if (json['liked_by_user_ids'] != null) {
      likedByUserIds = new List<Reply>();
      json['liked_by_user_ids'].forEach((v) {
        likedByUserIds.add(new Reply.fromJson(v));
      });
    }*/
    likedBy = json['liked_by']?.cast<int>();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['content'] = this.content;
    data['isLike'] = this.isLike;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.mentionedUsers != null) {
      data['mentioned_users'] =
          this.mentionedUsers.map((v) => v.toJson()).toList();
    }
    /*  if (this.likedByUserIds != null) {
      data['liked_by_user_ids'] =
          this.likedByUserIds.map((v) => v.toJson()).toList();
    }*/

    return data;
  }
}

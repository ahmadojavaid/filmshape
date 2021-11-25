import 'package:Filmshape/Model/feed/feed_response.dart';

class JoinProjectDetailsResponses {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String location;
  String title;

  // String status;
  Genre genre;
  List<Comments> comments;

  Status projectType;
  Creator creator;
  List<int> likedBy;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<ProjectRoleCallss> team;
  String description;
  String url;
  List<Award> awards;
  List<ProjectRoleCallss> projectRoleCalls;
  bool isLike;
  int commentNumber;

  JoinProjectDetailsResponses({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.location,
    this.title,
    this.awards,
    this.genre,
    this.comments,
    this.projectType,
    this.creator,
    this.likedBy,
    this.isFeatured,
    this.media,
    this.description,
    this.projectRoleCalls,
    this.team,
    this.isLike,
    this.url});

  JoinProjectDetailsResponses.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    location = json['location'];
    title = json['title'];
    isLike = json['isLike'];
    //status = json['status'];
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;

    projectType = json['project_type'] != null
        ? new Status.fromJson(json['project_type'])
        : null;

    creator =
    json['creator'] != null ? new Creator.fromJson(json['creator']) : null;

     likedBy = json['liked_by']?.cast<int>();


    if (json['awards'] != null) {
      awards = new List<Award>();
      json['awards'].forEach((v) {
        awards.add(new Award.fromJson(v));
      });
    }

    if (json['top_comments'] != null) {
      comments = new List<Comments>();
      json['top_comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }

    if (json['team'] != null) {
      team = new List<ProjectRoleCallss>();
      json['team'].forEach((v) {
        team.add(new ProjectRoleCallss.fromJson(v));
      });
    }
    if (json['project_role_calls'] != null) {
      projectRoleCalls = new List<ProjectRoleCallss>();
      json['project_role_calls'].forEach((v) {
        projectRoleCalls.add(new ProjectRoleCallss.fromJson(v));
      });
    }

    isFeatured = json['is_featured'];
    media = json['media'];

    description = json['description'];
    url = json['url'];
    mediaEmbed = json['media_embed'];
    commentNumber=json['comments_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['location'] = this.location;
    data['title'] = this.title;
    data['isLike'] = this.isLike;
    // data['status'] = this.status;
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }

    if (this.awards != null) {
      data['awards'] = this.awards.map((v) => v.toJson()).toList();
    }

    if (this.projectType != null) {
      data['project_type'] = this.projectType.toJson();
    }

    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }

    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }


    if (this.team != null) {
      data['team'] = this.team.map((v) => v.toJson()).toList();
    }

    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    data['description'] = this.description;
    data['url'] = this.url;
    if (this.projectRoleCalls != null) {
      data['project_role_calls'] =
          this.projectRoleCalls.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Genre {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;

  Genre({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.description,
    this.url,
    this.name});

  Genre.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['description'] = this.description;
    data['url'] = this.url;
    data['name'] = this.name;
    return data;
  }
}

class Creator {
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

  Creator({this.type,
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

  Creator.fromJson(Map<String, dynamic> json) {
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

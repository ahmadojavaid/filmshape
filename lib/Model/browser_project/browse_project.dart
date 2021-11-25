import 'package:Filmshape/Model/feed/feed_response.dart';

class BrowseProjectResponse {
  List<AllFTMProject> all;
  List<AllFTMProject> featured;
  List<AllFTMProject> topRated;
  List<AllFTMProject> mostViewed;

  BrowseProjectResponse(
      {this.all, this.featured, this.topRated, this.mostViewed});

  BrowseProjectResponse.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = new List<AllFTMProject>();
      json['all'].forEach((v) {
        all.add(new AllFTMProject.fromJson(v));
      });
    }
    if (json['featured'] != null) {
      featured = new List<AllFTMProject>();
      json['featured'].forEach((v) {
        featured.add(new AllFTMProject.fromJson(v));
      });
    }
    if (json['top_rated'] != null) {
      topRated = new List<AllFTMProject>();
      json['top_rated'].forEach((v) {
        topRated.add(new AllFTMProject.fromJson(v));
      });
    }
    if (json['most_viewed'] != null) {
      mostViewed = new List<AllFTMProject>();
      json['most_viewed'].forEach((v) {
        mostViewed.add(new AllFTMProject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.all != null) {
      data['all'] = this.all.map((v) => v.toJson()).toList();
    }
    if (this.featured != null) {
      data['featured'] = this.featured.map((v) => v.toJson()).toList();
    }
    if (this.topRated != null) {
      data['top_rated'] = this.topRated.map((v) => v.toJson()).toList();
    }
    if (this.mostViewed != null) {
      data['most_viewed'] = this.mostViewed.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class All {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String location;
  String title;
  Status status;
  Status genre;
  Status projectType;
  List<Comments> comments;
  Author creator;
  List<int> viewedBy;
  List<int> likedBy;
  List<int> likedByUserIds;
 // List<Managers> managers;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<Null> awards;
  List<ProjectRoleCalls> projectRoleCalls;
  bool isPrivate;
  List<Team> team;
  String description;
  String url;

  All(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.location,
        this.title,
        this.status,
        this.genre,
        this.projectType,
        this.comments,
        this.creator,
        this.viewedBy,
        this.likedBy,
        this.likedByUserIds,
       // this.managers,
        this.isFeatured,
        this.media,
        this.mediaEmbed,
        this.awards,
        this.projectRoleCalls,
        this.isPrivate,
        this.team,
        this.description,
        this.url});

  All.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    location = json['location'];
    title = json['title'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    genre = json['genre'] != null ? new Status.fromJson(json['genre']) : null;
    projectType = json['project_type'] != null
        ? new Status.fromJson(json['project_type'])
        : null;
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    creator =
    json['creator'] != null ? new Author.fromJson(json['creator']) : null;

    viewedBy = json['viewed_by']?.cast<int>();
    likedBy = json['liked_by']?.cast<int>();

   // likedByUserIds = json['liked_by_user_ids'].cast<int>();
//    if (json['managers'] != null) {
//      managers = new List<Managers>();
//      json['managers'].forEach((v) {
//        managers.add(new Managers.fromJson(v));
//      });
//    }
    isFeatured = json['is_featured'];
    media = json['media'];
    mediaEmbed = json['media_embed'];
//    if (json['awards'] != null) {
//      awards = new List<Null>();
//      json['awards'].forEach((v) {
//        awards.add(new Null.fromJson(v));
//      });
//    }
    if (json['project_role_calls'] != null) {
      projectRoleCalls = new List<ProjectRoleCalls>();
      json['project_role_calls'].forEach((v) {
        projectRoleCalls.add(new ProjectRoleCalls.fromJson(v));
      });
    }
    isPrivate = json['is_private'];
    if (json['team'] != null) {
      team = new List<Team>();
      json['team'].forEach((v) {
        team.add(new Team.fromJson(v));
      });
    }
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
    data['location'] = this.location;
    data['title'] = this.title;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
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
//    if (this.viewedBy != null) {
//      data['viewed_by'] = this.viewedBy.map((v) => v.toJson()).toList();
//    }
//    if (this.likedBy != null) {
//      data['liked_by'] = this.likedBy.map((v) => v.toJson()).toList();
//    }
    data['liked_by_user_ids'] = this.likedByUserIds;
//    if (this.managers != null) {
//      data['managers'] = this.managers.map((v) => v.toJson()).toList();
//    }
    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    data['media_embed'] = this.mediaEmbed;
//    if (this.awards != null) {
//      data['awards'] = this.awards.map((v) => v.toJson()).toList();
//    }
    if (this.projectRoleCalls != null) {
      data['project_role_calls'] =
          this.projectRoleCalls.map((v) => v.toJson()).toList();
    }
    data['is_private'] = this.isPrivate;
    if (this.team != null) {
      data['team'] = this.team.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class Status {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;

  Status(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.description,
        this.url,
        this.name});

  Status.fromJson(Map<String, dynamic> json) {
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

class Comments {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String content;
  Author author;
  ReplyTo replyTo;
  List<Replies> replies;
  //List<Null> mentionedUsers;
  List<int> likedByUserIds;
  List<int> likedBy;

  Comments(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.content,
        this.author,
        this.replyTo,
        this.replies,
        //this.mentionedUsers,
        this.likedByUserIds,
        this.likedBy});

  Comments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    content = json['content'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
    replyTo = json['reply_to'] != null
        ? new ReplyTo.fromJson(json['reply_to'])
        : null;
    if (json['replies'] != null) {
      replies = new List<Replies>();
      json['replies'].forEach((v) {
        replies.add(new Replies.fromJson(v));
      });
    }
//    if (json['mentioned_users'] != null) {
//      mentionedUsers = new List<Null>();
//      json['mentioned_users'].forEach((v) {
//        mentionedUsers.add(new Null.fromJson(v));
//      });
//    }
    //likedByUserIds = json['liked_by_user_ids'].cast<int>();
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
      data['reply_to'] = this.replyTo.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
    }
//    if (this.mentionedUsers != null) {
//      data['mentioned_users'] =
//          this.mentionedUsers.map((v) => v.toJson()).toList();
//    }
    data['liked_by_user_ids'] = this.likedByUserIds;

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

  Author(
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

class ReplyTo {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String content;
  Author author;
 // List<Null> mentionedUsers;
  List<int> likedByUserIds;
  List<int> likedBy;

  ReplyTo(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.content,
        this.author,
       // this.mentionedUsers,
        this.likedByUserIds,
        this.likedBy});

  ReplyTo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    content = json['content'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
//    if (json['mentioned_users'] != null) {
//      mentionedUsers = new List<Null>();
//      json['mentioned_users'].forEach((v) {
//        mentionedUsers.add(new Null.fromJson(v));
//      });
//    }
  //  likedByUserIds = json['liked_by_user_ids'].cast<int>();
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
//    if (this.mentionedUsers != null) {
//      data['mentioned_users'] =
//          this.mentionedUsers.map((v) => v.toJson()).toList();
//    }
    data['liked_by_user_ids'] = this.likedByUserIds;

    return data;
  }
}

class Replies {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String content;
  Author author;
 // List<Null> mentionedUsers;
  List<int> likedByUserIds;
  List<int> likedBy;

  Replies(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.content,
        this.author,
       // this.mentionedUsers,
        this.likedByUserIds,
        this.likedBy});

  Replies.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    content = json['content'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
//    if (json['mentioned_users'] != null) {
//      mentionedUsers = new List<Null>();
//      json['mentioned_users'].forEach((v) {
//        mentionedUsers.add(new Null.fromJson(v));
//      });
//    }
//    if (json['liked_by_user_ids'] != null) {
//      likedByUserIds = new List<Null>();
//      json['liked_by_user_ids'].forEach((v) {
//        likedByUserIds.add(new Null.fromJson(v));
//      });
//    }
//    if (json['liked_by'] != null) {
//      likedBy = new List<Null>();
//      json['liked_by'].forEach((v) {
//        likedBy.add(new Null.fromJson(v));
//      });
//    }
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
//    if (this.mentionedUsers != null) {
//      data['mentioned_users'] =
//          this.mentionedUsers.map((v) => v.toJson()).toList();
//    }
//    if (this.likedByUserIds != null) {
//      data['liked_by_user_ids'] =
//          this.likedByUserIds.map((v) => v.toJson()).toList();
//    }
//    if (this.likedBy != null) {
//      data['liked_by'] = this.likedBy.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}

class ProjectRoleCalls {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  Role role;
  Gender gender;
  Ethnicity ethnicity;
  int height;
  int weight;
  int salary;
  bool expensesPaid;
  Author assignee;
  Author author;
  String description;
  String url;

  ProjectRoleCalls(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.role,
        this.gender,
        this.ethnicity,
        this.height,
        this.weight,
        this.salary,
        this.expensesPaid,
        this.assignee,
        this.author,
        this.description,
        this.url});

  ProjectRoleCalls.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    gender =
    json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
    ethnicity = json['ethnicity'] != null
        ? new Ethnicity.fromJson(json['ethnicity'])
        : null;
    height = json['height'];
    weight = json['weight'];
    salary = json['salary'];
    expensesPaid = json['expenses_paid'];
    assignee =
    json['assignee'] != null ? new Author.fromJson(json['assignee']) : null;
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
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
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }
    if (this.ethnicity != null) {
      data['ethnicity'] = this.ethnicity.toJson();
    }
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['salary'] = this.salary;
    data['expenses_paid'] = this.expensesPaid;
    if (this.assignee != null) {
      data['assignee'] = this.assignee.toJson();
    }
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class Role {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;
  Category category;
  String iconUrl;

  Role(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.description,
        this.url,
        this.name,
        this.category,
        this.iconUrl});

  Role.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    name = json['name'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    iconUrl = json['icon_url'];
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
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['icon_url'] = this.iconUrl;
    return data;
  }
}

class Category {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;
  String iconUrl;

  Category(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.description,
        this.url,
        this.name,
        this.iconUrl});

  Category.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    name = json['name'];
    iconUrl = json['icon_url'];
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
    data['icon_url'] = this.iconUrl;
    return data;
  }
}
class Gender {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;

  Gender({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.description,
    this.url,
    this.name});

  Gender.fromJson(Map<String, dynamic> json) {
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

class Ethnicity {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String name;
  String group;

  Ethnicity(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.description,
        this.url,
        this.name,
        this.group});

  Ethnicity.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    name = json['name'];
    group = json['group'];
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
    data['group'] = this.group;
    return data;
  }
}

class AllFTMProject {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String location;
  String title;
  Status status;
  Status genre;
  Status projectType;
  List<Comments> comments;
  Author creator;
  List<int> viewedBy;
  List<int> likedBy;
  List<int> likedByUserIds;
 // List<Managers> managers;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<Award> awards;
  List<ProjectRoleCalls> projectRoleCalls;
  bool isPrivate;
  List<Team> team;
  String description;
  String url;
  bool isLike;

  AllFTMProject(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.location,
        this.title,
        this.status,
        this.genre,
        this.projectType,
        this.comments,
        this.creator,
        this.viewedBy,
        this.likedBy,
        this.likedByUserIds,
     //   this.managers,
        this.isFeatured,
        this.media,
        this.mediaEmbed,
        this.awards,
        this.projectRoleCalls,
        this.isPrivate,
        this.team,
        this.description,
        this.url});

  AllFTMProject.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    location = json['location'];
    title = json['title'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    genre = json['genre'] != null ? new Status.fromJson(json['genre']) : null;
    projectType = json['project_type'] != null
        ? new Status.fromJson(json['project_type'])
        : null;
//    if (json['comments'] != null) {
//      comments = new List<Null>();
//      json['comments'].forEach((v) {
//        comments.add(new Null.fromJson(v));
//      });
//    }
    creator =
    json['creator'] != null ? new Author.fromJson(json['creator']) : null;

    viewedBy = json['viewed_by']?.cast<int>();

    likedBy = json['liked_by']?.cast<int>();

   // likedByUserIds = json['liked_by_user_ids'].cast<int>();
//    if (json['managers'] != null) {
//      managers = new List<Managers>();
//      json['managers'].forEach((v) {
//        managers.add(new Managers.fromJson(v));
//      });
//    }
    isFeatured = json['is_featured'];
    media = json['media'];
    mediaEmbed = json['media_embed'];
//    if (json['awards'] != null) {
//      awards = new List<Null>();
//      json['awards'].forEach((v) {
//        awards.add(new Null.fromJson(v));
//      });
//    }
    if (json['project_role_calls'] != null) {
      projectRoleCalls = new List<ProjectRoleCalls>();
      json['project_role_calls'].forEach((v) {
        projectRoleCalls.add(new ProjectRoleCalls.fromJson(v));
      });
    }
    isPrivate = json['is_private'];
    if (json['team'] != null) {
      team = new List<Team>();
      json['team'].forEach((v) {
        team.add(new Team.fromJson(v));
      });
    }
    description = json['description'];
    url = json['url'];
    isLike = json['isLike'];
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
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }
    if (this.projectType != null) {
      data['project_type'] = this.projectType.toJson();
    }
//    if (this.comments != null) {
//      data['comments'] = this.comments.map((v) => v.toJson()).toList();
//    }
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
//    if (this.viewedBy != null) {
//      data['viewed_by'] = this.viewedBy.map((v) => v.toJson()).toList();
//    }
//    if (this.likedBy != null) {
//      data['liked_by'] = this.likedBy.map((v) => v.toJson()).toList();
//    }
    data['liked_by_user_ids'] = this.likedByUserIds;
//    if (this.managers != null) {
//      data['managers'] = this.managers.map((v) => v.toJson()).toList();
//    }
    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    data['media_embed'] = this.mediaEmbed;
//    if (this.awards != null) {
//      data['awards'] = this.awards.map((v) => v.toJson()).toList();
//    }
    if (this.projectRoleCalls != null) {
      data['project_role_calls'] =
          this.projectRoleCalls.map((v) => v.toJson()).toList();
    }
    data['is_private'] = this.isPrivate;
    if (this.team != null) {
      data['team'] = this.team.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['url'] = this.url;
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

  Creator(
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
class LikedViewedBy {
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

  LikedViewedBy({this.type,
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

  LikedViewedBy.fromJson(Map<String, dynamic> json) {
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


class Team {
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
  bool select;

  Team({this.type,
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
    this.select,
    this.url});

  Team.fromJson(Map<String, dynamic> json) {
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
    select = json['select'];
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
    data['select'] = this.select;
    return data;
  }
}


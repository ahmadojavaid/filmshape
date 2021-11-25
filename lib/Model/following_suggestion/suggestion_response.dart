import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';

class SuggestionResponse {
  List<Users> users;
  List<Projects> projects;

  SuggestionResponse({this.users, this.projects});

  SuggestionResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    if (json['projects'] != null) {
      projects = new List<Projects>();
      json['projects'].forEach((v) {
        projects.add(new Projects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.projects != null) {
      data['projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  List<Roles> roles;
  String username;
  String thumbnailUrl;
  String thumbnail;
  String location;
  String fullName;
  int height;
  int weight;
  List<Roles> following;
  Gender gender;
  Gender ethnicity;
  Showreel showreel;
  bool isFeatured;
  List<Roles> projects;
  List<Roles> roleCallsApplications;
  List<Roles> roleCallsDeclined;
  dynamic lastSeen;
  List<Roles> credits;
  List<RoleCategories> roleCategories;
  bool isStaff;
  bool isVerified;
  String bio;
  bool isOnline;
  bool isFollow = false;

  Users(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.roles,
      this.username,
      this.thumbnailUrl,
      this.thumbnail,
      this.location,
      this.fullName,
      this.height,
      this.weight,
      this.following,
      this.gender,
      this.ethnicity,
      this.showreel,
      this.isFeatured,
      this.projects,
      this.roleCallsApplications,
      this.roleCallsDeclined,
      this.lastSeen,
      this.credits,
      this.roleCategories,
      this.isStaff,
      this.isVerified,
      this.bio,
        this.isFollow,
      this.isOnline});

  Users.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    if (json['roles'] != null) {
      roles = new List<Roles>();
      json['roles'].forEach((v) {
        roles.add(new Roles.fromJson(v));
      });
    }
    username = json['username'];
    thumbnailUrl = json['thumbnail_url'];
    thumbnail = json['thumbnail'];
    location = json['location'];
    fullName = json['full_name'];
    height = json['height'];
    weight = json['weight'];
    if (json['following'] != null) {
      following = new List<Roles>();
      json['following'].forEach((v) {
        following.add(new Roles.fromJson(v));
      });
    }
    gender =
        json['gender'] != null ? new Gender.fromJson(json['gender']) : null;

    ethnicity =
    json['ethnicity'] != null ? new Gender.fromJson(json['ethnicity']) : null;
    showreel = json['showreel'] != null
        ? new Showreel.fromJson(json['showreel'])
        : null;
    isFeatured = json['is_featured'];
    if (json['projects'] != null) {
      projects = new List<Roles>();
      json['projects'].forEach((v) {
        projects.add(new Roles.fromJson(v));
      });
    }
    if (json['role_calls_applications'] != null) {
      roleCallsApplications = new List<Roles>();
      json['role_calls_applications'].forEach((v) {
        roleCallsApplications.add(new Roles.fromJson(v));
      });
    }
    if (json['role_calls_declined'] != null) {
      roleCallsDeclined = new List<Roles>();
      json['role_calls_declined'].forEach((v) {
        roleCallsDeclined.add(new Roles.fromJson(v));
      });
    }
    lastSeen = json['last_seen'];
    if (json['credits'] != null) {
      credits = new List<Roles>();
      json['credits'].forEach((v) {
        credits.add(new Roles.fromJson(v));
      });
    }
    if (json['role_categories'] != null) {
      roleCategories = new List<RoleCategories>();
      json['role_categories'].forEach((v) {
        roleCategories.add(new RoleCategories.fromJson(v));
      });
    }
    isStaff = json['is_staff'];
    isVerified = json['is_verified'];
    bio = json['bio'];
    isOnline = json['is_online'];
    isFollow = json['isFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    data['username'] = this.username;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['thumbnail'] = this.thumbnail;
    data['location'] = this.location;
    data['full_name'] = this.fullName;
    data['height'] = this.height;
    data['weight'] = this.weight;
    if (this.following != null) {
      data['following'] = this.following.map((v) => v.toJson()).toList();
    }
    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }
    if (this.ethnicity != null) {
      data['ethnicity'] = this.ethnicity.toJson();
    }
    if (this.showreel != null) {
      data['showreel'] = this.showreel.toJson();
    }
    data['is_featured'] = this.isFeatured;
    if (this.projects != null) {
      data['projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.roleCallsApplications != null) {
      data['role_calls_applications'] =
          this.roleCallsApplications.map((v) => v.toJson()).toList();
    }
    if (this.roleCallsDeclined != null) {
      data['role_calls_declined'] =
          this.roleCallsDeclined.map((v) => v.toJson()).toList();
    }
    data['last_seen'] = this.lastSeen;
    if (this.credits != null) {
      data['credits'] = this.credits.map((v) => v.toJson()).toList();
    }
    if (this.roleCategories != null) {
      data['role_categories'] =
          this.roleCategories.map((v) => v.toJson()).toList();
    }
    data['is_staff'] = this.isStaff;
    data['is_verified'] = this.isVerified;
    data['bio'] = this.bio;
    return data;
  }
}

class Roles {
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

  Roles(
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

  Roles.fromJson(Map<String, dynamic> json) {
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

  Gender(
      {this.type,
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

class Showreel {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String title;
  List<Roles> comments;
  List<int> likedBy;
  User user;
  String media;
  String description;
  String url;

  Showreel(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.title,
      this.comments,
      this.likedBy,
      this.user,
      this.media,
      this.description,
      this.url});

  Showreel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    title = json['title'];
    if (json['comments'] != null) {
      comments = new List<Roles>();
      json['comments'].forEach((v) {
        comments.add(new Roles.fromJson(v));
      });
    }
    likedBy = json['liked_by']?.cast<int>();

    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    media = json['media'];
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
    data['title'] = this.title;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }

    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['media'] = this.media;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class User {
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
  dynamic lastSeen;
  bool isStaff;
  bool isVerified;
  String bio;
  bool isOnline;
  String description;
  String url;

  User(
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
      this.isOnline,
      this.description,
      this.url});

  User.fromJson(Map<String, dynamic> json) {
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
    data['is_online'] = this.isOnline;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}



class Projects {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  dynamic location;
  String title;
  dynamic status;
  Gender genre;
  dynamic projectType;
  List<Comments> comments;
  Creator creator;
  List<int> viewedBy;
  List<int> likedBy;
  List<dynamic> managers;
  bool isFeatured;
  dynamic media;
  List<dynamic> awards;
  List<dynamic> projectRoleCalls;
  List<LikedBy> team;
  String description;
  String url;
  bool isLike = false;
  int count = 0;

  Projects(
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
        this.managers,
        this.isFeatured,
        this.media,
        this.awards,
        this.projectRoleCalls,
        this.team,
        this.description,
        this.url,
        this.count,
        this.isLike});

  Projects.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    location = json['location'];
    title = json['title'];
    status = json['status'];
    genre = json['genre'] != null ? new Gender.fromJson(json['genre']) : null;
    projectType = json['project_type'];
//    if (json['comments'] != null) {
//      comments = new List<Null>();
//      json['comments'].forEach((v) {
//        comments.add(new Null.fromJson(v));
//      });
//    }
    creator =
    json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
//    if (json['viewed_by']? != null) {
//      viewedBy = new List<Null>();
//      json['viewed_by']?.forEach((v) {
//        viewedBy.add(new Null.fromJson(v));
//      });
//    }
    likedBy = json['liked_by']?.cast<int>();

//    if (json['managers'] != null) {
//      managers = new List<Null>();
//      json['managers'].forEach((v) {
//        managers.add(new Null.fromJson(v));
//      });
//    }
    isFeatured = json['is_featured'];
    media = json['media'];
//    if (json['awards'] != null) {
//      awards = new List<Null>();
//      json['awards'].forEach((v) {
//        awards.add(new Null.fromJson(v));
//      });
//    }
//    if (json['project_role_calls'] != null) {
//      projectRoleCalls = new List<Null>();
//      json['project_role_calls'].forEach((v) {
//        projectRoleCalls.add(new Null.fromJson(v));
//      });
//    }
    if (json['team'] != null) {
      team = new List<LikedBy>();
      json['team'].forEach((v) {
        team.add(new LikedBy.fromJson(v));
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
    data['status'] = this.status;
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }
    data['project_type'] = this.projectType;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }

    if (this.managers != null) {
      data['managers'] = this.managers.map((v) => v.toJson()).toList();
    }
    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    if (this.awards != null) {
      data['awards'] = this.awards.map((v) => v.toJson()).toList();
    }
    if (this.projectRoleCalls != null) {
      data['project_role_calls'] =
          this.projectRoleCalls.map((v) => v.toJson()).toList();
    }
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
    data['is_online'] = this.isOnline;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

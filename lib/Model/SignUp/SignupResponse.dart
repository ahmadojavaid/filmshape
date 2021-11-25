import 'package:Filmshape/Model/browser_project/browse_project.dart';

class SignupResponse {
  String token;
   UserData user;

  SignupResponse({this.token, this.user});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class UserData {
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
  Ethnicity ethnicity;
  Showreel showreel;
  bool isFeatured;
  List<Roles> projects;
  List<Roles> roleCallsApplications;
  List<Roles> roleCallsDeclined;
  String lastSeen;
  List<Roles> credits;
  List<RoleCategories> roleCategories;
  bool isStaff;
  bool isVerified;
  String bio;
  bool isOnline;

  UserData({this.type,
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
    this.isOnline});

  UserData.fromJson(Map<String, dynamic> json) {
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
    ethnicity = json['ethnicity'] != null
        ? new Ethnicity.fromJson(json['ethnicity'])
        : null;
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
    data['is_online'] = this.isOnline;
    return data;
  }
}

class Roles {
  String type;
  int id;
  String created;
  String updated;
  Null createdBy;
  Null updatedBy;
  Null description;
  String url;
  String name;
  Category category;
  String iconUrl;

  Roles({this.type,
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
  Null createdBy;
  Null updatedBy;
  Null description;
  String url;
  String name;
  String iconUrl;

  Category({this.type,
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
  Null createdBy;
  Null updatedBy;
  Null description;
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
  Null createdBy;
  Null updatedBy;
  Null description;
  String url;
  String name;
  String group;

  Ethnicity({this.type,
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

class Showreel {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String title;
  List<Comments> comments;
  List<int> likedBy;
  RoleCategories user;
  String media;
  String description;
  String url;

  Showreel({this.type,
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
    if (json['top_comments'] != null) {
      comments = new List<Comments>();
      json['top_comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    likedBy = json['liked_by']?.cast<int>();

    user =
    json['user'] != null ? new RoleCategories.fromJson(json['user']) : null;
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

class RoleCategories {
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

  RoleCategories({this.type,
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

  RoleCategories.fromJson(Map<String, dynamic> json) {
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


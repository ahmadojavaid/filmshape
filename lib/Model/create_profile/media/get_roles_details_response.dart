class GetRolesMainsDetails {
  List<AddRoleDetails> data;

  GetRolesMainsDetails({this.data});

  GetRolesMainsDetails.fromJson(List<dynamic> dataList) {
    if (dataList != null) {
      data = new List<AddRoleDetails>();
      dataList.forEach((item) {
        print("item $item");
        data.add(new AddRoleDetails.fromJson(item));
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

class GetRolesDetails {
  List<AddRoleDetails> data;

  GetRolesDetails({this.data});

  GetRolesDetails.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AddRoleDetails>();
      json['data'].forEach((v) {
        data.add(new AddRoleDetails.fromJson(v));
      });
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

class AddRoleDetails {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String name;
  Role role;
  Gender gender;
  Gender ethnicity;
  Gender genre;
  Object height;
  Object weight;
  Object salary;
  bool expensesPaid;
  Projects project;
  Creator assignee;
  bool hideSalary;
  Creator author;
  String description;
  String url;

  AddRoleDetails(
      {this.type,
      this.id,
      this.created,
      this.updated,
      this.createdBy,
      this.updatedBy,
      this.name,
      this.role,
      this.gender,
      this.ethnicity,
      this.height,
      this.weight,
      this.salary,
      this.expensesPaid,
      this.project,
      this.assignee,
      this.hideSalary,
      this.author,
      this.description,
      this.url});

  AddRoleDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    name = json['name'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    gender =
    json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
    genre = json['genre'] != null ? new Gender.fromJson(json['genre']) : null;
    ethnicity = json['ethnicity'] != null
        ? new Gender.fromJson(json['ethnicity'])
        : null;
    height = json['height'];
    weight = json['weight'];
    salary = json['salary'];
    expensesPaid = json['expenses_paid'];
    project =
    json['project'] != null ? new Projects.fromJson(json['project']) : null;
    assignee = json['assignee'] != null
        ? new Creator.fromJson(json['assignee'])
        : null;
    hideSalary = json['hide_salary'];
    author =
    json['author'] != null ? new Creator.fromJson(json['author']) : null;

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
    data['name'] = this.name;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }
    if (this.ethnicity != null) {
      data['ethnicity'] = this.ethnicity.toJson();
    }
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['salary'] = this.salary;
    data['expenses_paid'] = this.expensesPaid;
    if (this.project != null) {
      data['project'] = this.project.toJson();
    }
    if (this.assignee != null) {
      data['assignee'] = this.assignee.toJson();
    }
    data['hide_salary'] = this.hideSalary;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['description'] = this.description;
    data['url'] = this.url;
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

  Role({this.type,
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


class Projects {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String location;
  String title;
  Gender genre;
  Gender projectType;
  Creator creator;

  bool isFeatured;
  String media;
  List<Null> awards;
  List<ProjectRoleCalls> projectRoleCalls;
  bool isPrivate;

  String description;
  String url;

  Projects({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.location,
    this.title,
    this.genre,
    this.projectType,
    this.creator,
    this.isFeatured,
    this.media,
    this.awards,
    this.projectRoleCalls,
    this.isPrivate,
    this.description,
    this.url});

  Projects.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    location = json['location'];
    title = json['title'];
    genre =
    json['genre'] != null ? new Gender.fromJson(json['genre']) : null;
    projectType = json['project_type'] != null
        ? new Gender.fromJson(json['project_type'])
        : null;

    creator =
    json['creator'] != null ? new Creator.fromJson(json['creator']) : null;

    isFeatured = json['is_featured'];
    media = json['media'];
    if (json['project_role_calls'] != null) {
      projectRoleCalls = new List<ProjectRoleCalls>();
      json['project_role_calls'].forEach((v) {
        projectRoleCalls.add(new ProjectRoleCalls.fromJson(v));
      });
    }
    isPrivate = json['is_private'];

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
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }
    if (this.projectType != null) {
      data['project_type'] = this.projectType.toJson();
    }

    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }

    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    if (this.projectRoleCalls != null) {
      data['project_role_calls'] =
          this.projectRoleCalls.map((v) => v.toJson()).toList();
    }
    data['is_private'] = this.isPrivate;
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

class ProjectRoleCalls {
  String type;
  int id;
  String created;
  String updated;
  Null createdBy;
  String updatedBy;
  Role role;
  Gender gender;
  Gender ethnicity;
  int height;
  int weight;
  int salary;
  bool expensesPaid;
  Creator assignee;
  Creator author;
  String description;
  String url;

  ProjectRoleCalls({this.type,
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
        ? new Gender.fromJson(json['ethnicity'])
        : null;
    height = json['height'];
    weight = json['weight'];
    salary = json['salary'];
    expensesPaid = json['expenses_paid'];
    assignee = json['assignee'] != null
        ? new Creator.fromJson(json['assignee'])
        : null;
    author =
    json['author'] != null ? new Creator.fromJson(json['author']) : null;
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

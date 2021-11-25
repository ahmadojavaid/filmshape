import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Model/searchtalent/search_talent_response.dart';

class FeedApiResponse {
  List<Feed> feed;
  List<FeaturedProjects> featuredProjects;
  List<FeaturedUsers> featuredUsers;

  FeedApiResponse({this.feed, this.featuredProjects, this.featuredUsers});

  FeedApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['feed'] != null) {
      feed = new List<Feed>();
      json['feed'].forEach((v) {
        feed.add(new Feed.fromJson(v));
      });
    }
    if (json['featured_projects'] != null) {
      featuredProjects = new List<FeaturedProjects>();
      json['featured_projects'].forEach((v) {
        featuredProjects.add(new FeaturedProjects.fromJson(v));
      });
    }
    if (json['featured_users'] != null) {
      featuredUsers = new List<FeaturedUsers>();
      json['featured_users'].forEach((v) {
        featuredUsers.add(new FeaturedUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feed != null) {
      data['feed'] = this.feed.map((v) => v.toJson()).toList();
    }
    if (this.featuredProjects != null) {
      data['featured_projects'] =
          this.featuredProjects.map((v) => v.toJson()).toList();
    }
    if (this.featuredUsers != null) {
      data['featured_users'] =
          this.featuredUsers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feed {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  Author user;
  Project project;
  Roles roleCall;
  String message;
  List<Comments> comments;
  String link;
  List<int> likedBy;
  String mediaEmbed;
  String media;
  int commentNumber;

  Feed({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.user,
    this.project,
    this.roleCall,
    this.message,
    this.comments,
    this.link,
    this.likedBy,
    this.mediaEmbed,
    this.media});

  Feed.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    user = json['user'] != null ? new Author.fromJson(json['user']) : null;
    project =
    json['project'] != null ? new Project.fromJson(json['project']) : null;
    //roleCall = json['role_call'];
    message = json['message'];
    if (json['top_comments'] != null) {
      comments = new List<Comments>();
      json['top_comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    link = json['link'];
    likedBy = json['liked_by']?.cast<int>();

    mediaEmbed = json['media_embed'];
    media = json['media'];
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
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.project != null) {
      data['project'] = this.project.toJson();
    }
    data['role_call'] = this.roleCall;
    data['message'] = this.message;
    if (this.comments != null) {
      data['top_comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['link'] = this.link;

    data['media_embed'] = this.mediaEmbed;
    data['media'] = this.media;
    return data;
  }
}


class FeaturedProjects {
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
  List<LikedBy> managers;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<Award> awards;
  List<ProjectRoleCallss> projectRoleCalls;
  bool isPrivate;
  List<LikedBy> team;
  String description;
  String url;
  bool isLike;
  int commentNumber;

  FeaturedProjects({this.type,
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
    this.mediaEmbed,
    this.awards,
    this.projectRoleCalls,
    this.isPrivate,
    this.team,
    this.description,
    this.isLike,
    this.url});

  FeaturedProjects.fromJson(Map<String, dynamic> json) {
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

    if (json['top_comments'] != null) {
      comments = new List<Comments>();
      json['top_comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    creator =
    json['creator'] != null ? new Author.fromJson(json['creator']) : null;

    viewedBy = json['viewed_by']?.cast<int>();
    likedBy = json['liked_by']?.cast<int>();

    if (json['managers'] != null) {
      managers = new List<LikedBy>();
      json['managers'].forEach((v) {
        managers.add(new LikedBy.fromJson(v));
      });
    }
    isFeatured = json['is_featured'];
    media = json['media'];
    mediaEmbed = json['media_embed'];
    isLike = json['isLike']??false;
    if (json['awards'] != null) {
      awards = new List<Award>();
      json['awards'].forEach((v) {
        awards.add(new Award.fromJson(v));
      });
    }
    if (json['project_role_calls'] != null) {
      projectRoleCalls = new List<ProjectRoleCallss>();
      json['project_role_calls'].forEach((v) {
        projectRoleCalls.add(new ProjectRoleCallss.fromJson(v));
      });
    }
    isPrivate = json['is_private'];
    if (json['team'] != null) {
      team = new List<LikedBy>();
      json['team'].forEach((v) {
        team.add(new LikedBy.fromJson(v));
      });
    }
    description = json['description'];
    url = json['url'];
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
      data['top_comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }

    if (this.managers != null) {
      data['managers'] = this.managers.map((v) => v.toJson()).toList();
    }
    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    data['media_embed'] = this.mediaEmbed;
    data['isLike'] = this.isLike;
    if (this.awards != null) {
      data['awards'] = this.awards.map((v) => v.toJson()).toList();
    }
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

  Status({this.type,
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

class LikedBy {
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

  LikedBy({this.type,
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

  LikedBy.fromJson(Map<String, dynamic> json) {
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

class ProjectRoleCallss {
  String type;
  int id;
  String created;
  String updated;
  LikedBy createdBy;
  String updatedBy;
  Role role;
  Status gender;
  Status ethnicity;
  Object height;
  Object weight;
  Object salary;
  bool expensesPaid;
  Author assignee;
  Author author;
  String description;
  String url;

  ProjectRoleCallss({this.type,
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

  ProjectRoleCallss.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    gender =
    json['gender'] != null ? new Status.fromJson(json['gender']) : null;
    ethnicity =
    json['ethnicity'] != null ? new Status.fromJson(json['ethnicity']) : null;
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

class FeaturedUsers {
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
  Status gender;
  Status ethnicity;
  Showreels showreel;
  bool isFeatured;
  List<Projects> projects;
  List<ProjectRoleCallss> roleCallsApplications;
  List<ProjectRoleCallss> roleCallsDeclined;
  String lastSeen;
  List<Credits> credits;
  List<RoleCategories> roleCategories;
  bool isStaff;
  bool isVerified;
  bool isPro;
  String bio;
  int followingNumber;
  int followersNumber;
  bool isOnline;

  FeaturedUsers({this.type,
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
    this.isPro,
    this.bio,
    this.followingNumber,
    this.followersNumber,
    this.isOnline});

  FeaturedUsers.fromJson(Map<String, dynamic> json) {
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
    gender =
    json['gender'] != null ? new Status.fromJson(json['gender']) : null;
    ethnicity =
    json['ethnicity'] != null ? new Status.fromJson(json['ethnicity']) : null;

    showreel = json['showreel'] != null
        ? new Showreels.fromJson(json['showreel'])
        : null;
    isFeatured = json['is_featured'];
    if (json['projects'] != null) {
      projects = new List<Projects>();
      json['projects'].forEach((v) {
        projects.add(new Projects.fromJson(v));
      });
    }
    if (json['role_calls_applications'] != null) {
      roleCallsApplications = new List<ProjectRoleCallss>();
      json['role_calls_applications'].forEach((v) {
        roleCallsApplications.add(new ProjectRoleCallss.fromJson(v));
      });
    }
    if (json['role_calls_declined'] != null) {
      roleCallsDeclined = new List<ProjectRoleCallss>();
      json['role_calls_declined'].forEach((v) {
        roleCallsDeclined.add(new ProjectRoleCallss.fromJson(v));
      });
    }
    lastSeen = json['last_seen'];
    if (json['credits'] != null) {
      credits = new List<Credits>();
      json['credits'].forEach((v) {
        credits.add(new Credits.fromJson(v));
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
    isPro = json['is_pro'];
    bio = json['bio'];
    followingNumber = json['following_number'];
    followersNumber = json['followers_number'];
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
    data['is_pro'] = this.isPro;
    data['bio'] = this.bio;
    data['following_number'] = this.followingNumber;
    data['followers_number'] = this.followersNumber;
    data['is_online'] = this.isOnline;
    return data;
  }
}

class Showreels {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String title;
  List<LikedBy> comments;
  List<int> likedBy;
  Author user;
  String mediaEmbed;
  String media;
  String description;
  String url;
  int commentNumber;

  Showreels({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.title,
    this.comments,
    this.likedBy,
    this.user,
    this.mediaEmbed,
    this.media,
    this.description,
    this.url});

  Showreels.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    title = json['title'];
    if (json['top_comments'] != null) {
      comments = new List<LikedBy>();
      json['top_comments'].forEach((v) {
        comments.add(new LikedBy.fromJson(v));
      });
    }
    likedBy = json['liked_by']?.cast<int>();

    user = json['user'] != null ? new Author.fromJson(json['user']) : null;
    mediaEmbed = json['media_embed'];
    media = json['media'];
    description = json['description'];
    url = json['url'];
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
    data['title'] = this.title;
    if (this.comments != null) {
      data['top_comments'] = this.comments.map((v) => v.toJson()).toList();
    }

    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['media_embed'] = this.mediaEmbed;
    data['media'] = this.media;
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
  Status status;
  Status genre;
  Status projectType;
  List<LikedBy> comments;
  Author creator;
  List<int> viewedBy;
  List<int> likedBy;
  List<LikedBy> managers;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<Award> awards;
  List<ProjectRoleCalls> projectRoleCalls;
  bool isPrivate;
  List<LikedBy> team;
  String description;
  String url;
  int commentNumber;

  Projects({this.type,
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
    this.mediaEmbed,
    this.awards,
    this.projectRoleCalls,
    this.isPrivate,
    this.team,
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
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    genre = json['genre'] != null ? new Status.fromJson(json['genre']) : null;
    projectType =
    json['genre'] != null ? new Status.fromJson(json['project_type']) : null;

    if (json['top_comments'] != null) {
      comments = new List<LikedBy>();
      json['top_comments'].forEach((v) {
        comments.add(new LikedBy.fromJson(v));
      });
    }
    creator =
    json['creator'] != null ? new Author.fromJson(json['creator']) : null;

    viewedBy = json['viewed_by']?.cast<int>();
    likedBy = json['liked_by']?.cast<int>();

    if (json['managers'] != null) {
      managers = new List<LikedBy>();
      json['managers'].forEach((v) {
        managers.add(new LikedBy.fromJson(v));
      });
    }
    isFeatured = json['is_featured'];
    media = json['media'];
    mediaEmbed = json['media_embed'];
    if (json['awards'] != null) {
      awards = new List<Award>();
      json['awards'].forEach((v) {
        awards.add(new Award.fromJson(v));
      });
    }
    if (json['project_role_calls'] != null) {
      projectRoleCalls = new List<ProjectRoleCalls>();
      json['project_role_calls'].forEach((v) {
        projectRoleCalls.add(new ProjectRoleCalls.fromJson(v));
      });
    }
    isPrivate = json['is_private'];
    if (json['team'] != null) {
      team = new List<LikedBy>();
      json['team'].forEach((v) {
        team.add(new LikedBy.fromJson(v));
      });
    }
    description = json['description'];
    url = json['url'];
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
      data['top_comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }

    if (this.managers != null) {
      data['managers'] = this.managers.map((v) => v.toJson()).toList();
    }
    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    data['media_embed'] = this.mediaEmbed;
    if (this.awards != null) {
      data['awards'] = this.awards.map((v) => v.toJson()).toList();
    }
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

class Credits {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String name;
  Role role;
  Status gender;
  Status ethnicity;
  num height;
  num weight;
  num salary;
  bool expensesPaid;
  Project project;
  Author assignee;
  bool hideSalary;
  Author author;
  String description;
  String url;

  Credits({this.type,
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

  Credits.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    name = json['name'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    gender = json['gender'];
    ethnicity = json['ethnicity'];
    height = json['height'];
    weight = json['weight'];
    salary = json['salary'];
    expensesPaid = json['expenses_paid'];
    project =
    json['project'] != null ? new Project.fromJson(json['project']) : null;
    assignee =
    json['assignee'] != null ? new Author.fromJson(json['assignee']) : null;
    hideSalary = json['hide_salary'];
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
    data['name'] = this.name;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    data['gender'] = this.gender;
    data['ethnicity'] = this.ethnicity;
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

class Project {
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
  List<LikedBy> managers;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<Award> awards;
  List<ProjectRoleCallss> projectRoleCalls;
  bool isPrivate;
  bool isLike;
  List<LikedBy> team;
  String description;
  String url;
  int commentNumber;

  Project({this.type,
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
    this.mediaEmbed,
    this.awards,
    this.projectRoleCalls,
    this.isPrivate,
    this.isLike,
    this.team,
    this.description,
    this.url});

  Project.fromJson(Map<String, dynamic> json) {
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
    genre =
    json['genre'] != null ? new Status.fromJson(json['genre']) : null;
    projectType =
    json['project_type'] != null
        ? new Status.fromJson(json['project_type'])
        : null;
    if (json['top_comments'] != null) {
      comments = new List<Comments>();
      json['top_comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    creator =
    json['creator'] != null ? new Author.fromJson(json['creator']) : null;

    viewedBy = json['viewed_by']?.cast<int>();
    likedBy = json['liked_by']?.cast<int>();

    if (json['managers'] != null) {
      managers = new List<LikedBy>();
      json['managers'].forEach((v) {
        managers.add(new LikedBy.fromJson(v));
      });
    }
    isFeatured = json['is_featured'];
    media = json['media'];
    isLike = json['isLike']??false;
    mediaEmbed = json['media_embed'];
    if (json['awards'] != null) {
      awards = new List<Award>();
      json['awards'].forEach((v) {
        awards.add(new Award.fromJson(v));
      });
    }
    if (json['project_role_calls'] != null) {
      projectRoleCalls = new List<ProjectRoleCallss>();
      json['project_role_calls'].forEach((v) {
        projectRoleCalls.add(new ProjectRoleCallss.fromJson(v));
      });
    }
    isPrivate = json['is_private'];
    if (json['team'] != null) {
      team = new List<LikedBy>();
      json['team'].forEach((v) {
        team.add(new LikedBy.fromJson(v));
      });
    }
    description = json['description'];
    url = json['url'];
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
      data['top_comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }

    if (this.managers != null) {
      data['managers'] = this.managers.map((v) => v.toJson()).toList();
    }
    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
    data['isLike'] = this.isLike;
    data['media_embed'] = this.mediaEmbed;
    if (this.awards != null) {
      data['awards'] = this.awards.map((v) => v.toJson()).toList();
    }
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


class Comments {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String content;
  Author author;
  ReplyToFeed replyTo;
  List<Comments> replies;
  List<LikedBy> mentionedUsers;
  int repliesNumber;

/*  List<LikedBy> likedByUserIds;*/
  List<int> likedBy;
  bool isLike;
  int replies_number;

  Comments({this.type,
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
    /*   this.likedByUserIds,*/
    this.likedBy,
    this.isLike,
    this.replies_number

  });

  Comments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    content = json['content'];
    isLike = json['isLike'];
    replies_number = json['replies_number'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
    replyTo = json['reply_to'] != null
        ? new ReplyToFeed.fromJson(json['reply_to'])
        : null;
    if (json['replies'] != null) {
      replies = new List<Comments>();
      json['replies'].forEach((v) {
        replies.add(new Comments.fromJson(v));
      });
    }
    if (json['mentioned_users'] != null) {
      mentionedUsers = new List<LikedBy>();
      json['mentioned_users'].forEach((v) {
        mentionedUsers.add(new LikedBy.fromJson(v));
      });
    }
    /* if (json['liked_by_user_ids'] != null) {
      likedByUserIds = new List<LikedBy>();
      json['liked_by_user_ids'].forEach((v) {
        likedByUserIds.add(new LikedBy.fromJson(v));
      });
    }*/
    likedBy = json['liked_by']?.cast<int>();
    replies_number=json['replies_number'];

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
    data['replies_number'] = this.replies_number;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.replyTo != null) {
      data['reply_to'] = this.replyTo.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
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

class ReplyToFeed {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String content;
  Author author;
  List<Author> mentionedUsers;

/*  List<Author> likedByUserIds;*/
/*  List<Author> likedBy;*/

  ReplyToFeed({this.type,
    this.id,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.content,
    this.author,
    this.mentionedUsers,
/*    this.likedByUserIds,*/
  });

  ReplyToFeed.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    content = json['content'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
    if (json['mentioned_users'] != null) {
      mentionedUsers = new List<Author>();
      json['mentioned_users'].forEach((v) {
        mentionedUsers.add(new Author.fromJson(v));
      });
    }
    /* if (json['liked_by_user_ids'] != null) {
      likedByUserIds = new List<Author>();
      json['liked_by_user_ids'].forEach((v) {
        likedByUserIds.add(new Author.fromJson(v));
      });
    }*/
    /* if (json['liked_by']? != null) {
      likedBy = new List<Author>();
      json['liked_by']?.forEach((v) {
        likedBy.add(new Author.fromJson(v));
      });
    }*/
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
    if (this.mentionedUsers != null) {
      data['mentioned_users'] =
          this.mentionedUsers.map((v) => v.toJson()).toList();
    }
    /* if (this.likedByUserIds != null) {
      data['liked_by_user_ids'] =
          this.likedByUserIds.map((v) => v.toJson()).toList();
    }*/
    /* if (this.likedBy != null) {
      data['liked_by'] = this.likedBy.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
class Award {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String description;
  String url;
  String title;
  String awardInstitution;

  Award(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.description,
        this.url,
        this.title,
        this.awardInstitution});

  Award.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    description = json['description'];
    url = json['url'];
    title = json['title'];
    awardInstitution = json['awardInstitution'];
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
    data['title'] = this.title;
    data['awardInstitution'] = this.awardInstitution;
    return data;
  }
}
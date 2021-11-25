import 'package:Filmshape/Model/SignUp/SignupResponse.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';

class MyProjectResponse
{
  List<ProjectData> listData=new List<ProjectData>();

  MyProjectResponse();

  MyProjectResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      json.forEach((v) {
        listData.add(new ProjectData.fromJson(v));
      });
    }
  }

}



class ProjectData {
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
  Creator creator;
  List<int> viewedBy;
  List<int> likedBy;
  List<Null> managers;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<Null> awards;
  List<ProjectRoleCalls> projectRoleCalls;
  bool isPrivate;
  List<Team> team=List();
  String description;
  String url;
  bool isLike;
  int likeType;

  ProjectData({this.type,
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
    this.isPrivate,
    this.team,
    this.description,
    this.isLike,
    this.url});

  ProjectData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    location = json['location'];
    title = json['title'];
    isLike = json['isLike']??false;
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    genre = json['genre'] != null ? new Status.fromJson(json['genre']) : null;
    projectType = json['project_type'] != null
        ? new Status.fromJson(json['project_type'])
        : null;
    viewedBy = json['viewed_by']?.cast<int>();
    likedBy = json['liked_by']?.cast<int>();

    creator =
    json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
//    if (json['viewed_by']? != null) {
//      viewedBy = new List<Null>();
//      json['viewed_by']?.forEach((v) {
//        viewedBy.add(new Null.fromJson(v));
//      });
//    }
//    if (json['liked_by']? != null) {
//      likedBy = new List<Null>();
//      json['liked_by']?.forEach((v) {
//        likedBy.add(new Null.fromJson(v));
//      });
//    }
    if (json['top_comments'] != null) {
      comments = new List<Comments>();
      json['top_comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    isFeatured = json['is_featured'];
    media = json['media'];
    isLike = json['isLike']??false;
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
//    if (this.managers != null) {
//      data['managers'] = this.managers.map((v) => v.toJson()).toList();
//    }
    data['is_featured'] = this.isFeatured;
    data['media'] = this.media;
//    if (this.awards != null) {
//      data['awards'] = this.awards.map((v) => v.toJson()).toList();
//    }
//    if (this.projectRoleCalls != null) {
//      data['project_role_calls'] =
//          this.projectRoleCalls.map((v) => v.toJson()).toList();
//    }
    data['is_private'] = this.isPrivate;
    if (this.team != null) {
      data['team'] = this.team.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
  void createTeam(List<String> thumbnails)
  {
    for(var profilePic in thumbnails)
    {
        team.add(Team(thumbnailUrl: profilePic));
    }
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

class ProjectRoleCalls {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  Role role;
  Status gender;
  Ethnicity ethnicity;
  int height;
  int weight;
  int salary;
  bool expensesPaid;
  Creator assignee;
  Creator author;
  String description;
  String url;
  bool hideSalary;

  int count;

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
    this.url,
    this.count

  });

  ProjectRoleCalls.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    gender =
    json['gender'] != null ? new Status.fromJson(json['gender']) : null;
    ethnicity = json['ethnicity'] != null
        ? new Ethnicity.fromJson(json['ethnicity'])
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
    data['hide_salary'] = this.hideSalary;
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

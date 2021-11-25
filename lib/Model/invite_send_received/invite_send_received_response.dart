import 'package:Filmshape/Model/browser_project/browse_project.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/invite_send_received/invite_send_received_response.dart';

class InviteSendReceivedResponse {
  List<Sent> sent;
  List<Sent> received;

  InviteSendReceivedResponse({this.sent, this.received});

  InviteSendReceivedResponse.fromJson(Map<String, dynamic> json) {
    if (json['sent'] != null) {
      sent = new List<Sent>();
      json['sent'].forEach((v) {
        sent.add(new Sent.fromJson(v));
      });
    }
    if (json['received'] != null) {
      received = new List<Sent>();
      json['received'].forEach((v) {
        received.add(new Sent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sent != null) {
      data['sent'] = this.sent.map((v) => v.toJson()).toList();
    }
    if (this.received != null) {
      data['received'] = this.received.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sent {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  Sender sender;
  Receiver receiver;
  RoleCall roleCall;
  String message;
  bool revoked;
  bool accepted;
  bool declined;
  String status;
  bool seen;
  bool invite;
  String titleSent;
  String titleReceived;
  bool rsvp;

  Sent(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.sender,
        this.receiver,
        this.roleCall,
        this.message,
        this.revoked,
        this.accepted,
        this.declined,
        this.status,
        this.seen,
        this.invite,
        this.titleSent,
        this.titleReceived,
        this.rsvp});

  Sent.fromJson(Map<String, dynamic> json) {
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
    roleCall = json['role_call'] != null
        ? new RoleCall.fromJson(json['role_call'])
        : null;
    message = json['message'];
    revoked = json['revoked'];
    accepted = json['accepted'];
    declined = json['declined'];
    status = json['status'];
    seen = json['seen'];
    invite = json['invite'];
    titleSent = json['title_sent'];
    titleReceived = json['title_received'];
    rsvp = json['rsvp'];
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
    if (this.roleCall != null) {
      data['role_call'] = this.roleCall.toJson();
    }
    data['message'] = this.message;
    data['revoked'] = this.revoked;
    data['accepted'] = this.accepted;
    data['declined'] = this.declined;
    data['status'] = this.status;
    data['seen'] = this.seen;
    data['invite'] = this.invite;
    data['title_sent'] = this.titleSent;
    data['title_received'] = this.titleReceived;
    data['rsvp'] = this.rsvp;
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
  num height;
  num weight;
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

class RoleCall {
  String type;
  int id;
  String created;
  String updated;
  String createdBy;
  String updatedBy;
  String name;
  Role role;
  Gender gender;
  Ethnicity ethnicity;
  num height;
  num weight;
  num salary;
  bool expensesPaid;
  Project project;
  // Null assignee;
  bool hideSalary;
  Sender author;
  String description;
  String url;

  RoleCall(
      {this.type,
        this.id,
        this.created,
        this.updated,
        this.createdBy,
        this.updatedBy,
        this.name,
        this.role,
        this.gender,
        //  this.ethnicity,
        this.height,
        this.weight,
        this.salary,
        this.expensesPaid,
        this.project,
        // this.assignee,
        this.hideSalary,
        this.author,
        this.description,
        this.url});

  RoleCall.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    name = json['name'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    gender = json['gender'];
    // ethnicity = json['ethnicity'];
    height = json['height'];
    weight = json['weight'];
    salary = json['salary'];
    expensesPaid = json['expenses_paid'];
    project =
    json['project'] != null ? new Project.fromJson(json['project']) : null;
    //assignee = json['assignee'];
    hideSalary = json['hide_salary'];
    author =
    json['author'] != null ? new Sender.fromJson(json['author']) : null;
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
    //data['ethnicity'] = this.ethnicity;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['salary'] = this.salary;
    data['expenses_paid'] = this.expensesPaid;
    if (this.project != null) {
      data['project'] = this.project.toJson();
    }
    //data['assignee'] = this.assignee;
    data['hide_salary'] = this.hideSalary;
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
  //List<Comments> topComments;
  int commentsNumber;
  Sender creator;
  List<int> likedBy;
 // List<Managers> managers;
  bool isFeatured;
  String media;
  String mediaEmbed;
  List<Award> awards;
  List<ProjectRoleCalls> projectRoleCalls;
  bool isPrivate;
  List<int> viewedBy;
  List<Team> team;
  String description;
  String url;

  Project(
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
        //  this.topComments,
        this.commentsNumber,
        this.creator,
        this.likedBy,
      //  this.managers,
        this.isFeatured,
        this.media,
        this.mediaEmbed,
        this.awards,
        this.projectRoleCalls,
        this.isPrivate,
        this.viewedBy,
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
    genre = json['genre'] != null ? new Status.fromJson(json['genre']) : null;
    projectType = json['project_type'] != null
        ? new Status.fromJson(json['project_type'])
        : null;
//    if (json['top_comments'] != null) {
//      topComments = new List<Null>();
//      json['top_comments'].forEach((v) {
//        topComments.add(new Null.fromJson(v));
//      });
//    }
    commentsNumber = json['comments_number'];
    creator =
    json['creator'] != null ? new Sender.fromJson(json['creator']) : null;
    likedBy = json['liked_by']?.cast<int>();
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
    viewedBy = json['viewed_by'].cast<int>();
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
//    if (this.topComments != null) {
//      data['top_comments'] = this.topComments.map((v) => v.toJson()).toList();
//    }
    data['comments_number'] = this.commentsNumber;
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    data['liked_by'] = this.likedBy;
//    if (this.managers != null) {
//      data['managers'] = this.managers.map((v) => v.toJson()).toList();
//    }
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
    data['viewed_by'] = this.viewedBy;
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
  num height;
  num weight;
  num salary;
  bool expensesPaid;
  Sender assignee;
  Sender author;
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
    gender = json['gender'];
    ethnicity = json['ethnicity'];
    height = json['height'];
    weight = json['weight'];
    salary = json['salary'];
    expensesPaid = json['expenses_paid'];
    assignee = json['assignee'] != null ? new Sender.fromJson(json['assignee']) : null;
    author =
    json['author'] != null ? new Sender.fromJson(json['author']) : null;
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
    data['gender'] = this.gender;
    data['ethnicity'] = this.ethnicity;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['salary'] = this.salary;
    data['expenses_paid'] = this.expensesPaid;
    data['assignee'] = this.assignee;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}


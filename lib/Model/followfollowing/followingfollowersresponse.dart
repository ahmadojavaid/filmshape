import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';

class FollowersFollowingReponse {
  List<FollowFollowingUser> followingFollowers;

  FollowersFollowingReponse({this.followingFollowers});

  FollowersFollowingReponse.fromJson(Map<String, dynamic> json) {
    if (json['following'] != null) {
      followingFollowers = new List<FollowFollowingUser>();
      json['following'].forEach((v) {
        followingFollowers.add(new FollowFollowingUser.fromJson(v));
      });
    }
    if (json['followers'] != null) {
      followingFollowers = new List<FollowFollowingUser>();
      json['followers'].forEach((v) {
        followingFollowers.add(new FollowFollowingUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.followingFollowers != null) {
      data['following'] = this.followingFollowers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowFollowingUser {
  String type;
  int id;
  String created;
  String updated;
  List<RolesData> roles;
  String username;
  String thumbnailUrl;
  String thumbnail;
  String location;
  String fullName;
 // String showreel;
  bool isFeatured;
  bool isStaff;
  bool isVerified;
  String bio;
  int followingNumber;
  int followersNumber;
  bool isOnline;
  bool isFollowing;
  bool isSelect;

  FollowFollowingUser({this.type,
    this.id,
    this.created,
    this.updated,
    this.roles,
    this.username,
    this.thumbnailUrl,
    this.thumbnail,
    this.location,
    this.fullName,
   // this.showreel,
    this.isFeatured,
    this.isStaff,
    this.isVerified,
    this.bio,
    this.followingNumber,
    this.followersNumber,
    this.isOnline,
    this.isFollowing,
    this.isSelect
  });

  FollowFollowingUser.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
    if (json['roles'] != null) {
      roles = new List<RolesData>();
      json['roles'].forEach((v) {
        roles.add(new RolesData.fromJson(v));
      });
    }
    username = json['username'];
    thumbnailUrl = json['thumbnail_url'];
    thumbnail = json['thumbnail'];
    location = json['location'];
    fullName = json['full_name'];
   // showreel = json['showreel'];
    isFeatured = json['is_featured'];

    isStaff = json['is_staff'];
    isFollowing = json['is_following'];
    isVerified = json['is_verified'];
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
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    data['username'] = this.username;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['thumbnail'] = this.thumbnail;
    data['location'] = this.location;
    data['full_name'] = this.fullName;
   // data['showreel'] = this.showreel;
    data['is_featured'] = this.isFeatured;
    data['is_following'] = this.isFollowing;

    data['is_staff'] = this.isStaff;
    data['is_verified'] = this.isVerified;
    data['bio'] = this.bio;
    data['following_number'] = this.followingNumber;
    data['followers_number'] = this.followersNumber;
    data['is_online'] = this.isOnline;
    return data;
  }
}
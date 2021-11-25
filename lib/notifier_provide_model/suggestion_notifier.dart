import 'dart:async';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/followfollowing/followingfollowersresponse.dart';
import 'package:Filmshape/Model/following_suggestion/follow_response.dart';
import 'package:Filmshape/Model/following_suggestion/header.dart';
import 'package:Filmshape/Model/following_suggestion/suggestion_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:flutter/cupertino.dart';

class SuggestionProvider with ChangeNotifier {
  SuggestionResponse suggestedResponse = new SuggestionResponse();
  FollowResponse followresponse = new FollowResponse();
  var _isLoading = false;

  getLoading() => _isLoading;

  getResponse() => suggestedResponse;

  getList() => list;

  List<Object> list = new List();

  Future<dynamic> getData(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
        await APIHandler.get(context: context, url: APIs.suggestionUserUrl);

    print(APIs.suggestionUserUrl);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      SuggestionResponse suggestionResponseData =
          new SuggestionResponse.fromJson(response);
      suggestedResponse = suggestionResponseData;
      list.clear();
      list.add(Header(heading: "Suggested users to follow",
          subHeading: "Keep up to date with talented filmmakers."));
      list.addAll(suggestedResponse.users);
      list.add(SizedBox(height: 40,)); //for space
      list.add(Header(heading: "Project you may like",
          subHeading:  "Like a project to feature its activity on your feed."));
      list.addAll(suggestedResponse.projects);
      completer.complete(suggestionResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> followUser(BuildContext context, int id, int type) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
    await APIHandler.post(context: context,
        url: type == 1 ? APIs.userSuggestionFollow + "$id/follow/" : APIs
            .userSuggestionFollow + "$id/unfollow/");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      FollowResponse loginResponseData =
      new FollowResponse.fromJson(response);
      followresponse = loginResponseData;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> followerFollowing(BuildContext context, String id,
      int type, int pageNo) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
    await APIHandler.get(context: context,
        url: type == 0 ? APIs.userSuggestionFollow +
            "$id/following/?page=$pageNo&per_page=$RESULT_PER_PAGE" : APIs
            .userSuggestionFollow +
            "$id/followers/?page=$pageNo&per_page=$RESULT_PER_PAGE");

    print(APIs.userSuggestionFollow + "$id/follow");
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else if (type == 1) //followers data
        {
      FollowersFollowingReponse followersResponse =
      new FollowersFollowingReponse.fromJson(response);
      completer.complete(followersResponse);
      notifyListeners();
      return completer.future;
    }
    else //following data
        {
      FollowersFollowingReponse followingResponse =
      new FollowersFollowingReponse.fromJson(response);
      completer.complete(followingResponse);
      notifyListeners();
      return completer.future;
    }
  }



  Future<dynamic> likeUnlikeProject(BuildContext context, int id, int type) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
    await APIHandler.post(context: context,
        url: type == 1 ? APIs.likeUnlikeProject + "$id/like/" : APIs
            .likeUnlikeProject + "$id/unlike/");

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    }
    else {
      LikesResponse loginResponseData =
      new LikesResponse.fromJson(response);
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }



  void hideLoader() {
    print(_isLoading);
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    print(_isLoading);
    _isLoading = true;
    notifyListeners();
  }
}

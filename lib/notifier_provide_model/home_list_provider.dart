import 'dart:async';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/awards/add_awards_request.dart';
import 'package:Filmshape/Model/comment/CommentRequest.dart';
import 'package:Filmshape/Model/comment/get_comment_response.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/hide_credits/hide_credit_request.dart';
import 'package:Filmshape/Model/invite_send_received/accept_reject_request.dart';
import 'package:Filmshape/Model/invite_send_received/invite_send_received_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Model/notification/notification_response.dart';
import 'package:Filmshape/Model/search/search_data_response.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:flutter/cupertino.dart';

class HomeListProvider with ChangeNotifier {
  InviteSendReceivedResponse inviteSendReceivedResponse =
      new InviteSendReceivedResponse();

  var _isLoading = false;

  getLoading() => _isLoading;

  getChannelsId() => id;

  String id;

  Future<dynamic> getData(int page, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context,
        url: APIs.feedUrl + "$page&per_page=$RESULT_PER_PAGE");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      FeedApiResponse feedApiResponse = new FeedApiResponse.fromJson(response);
      // loginResponse = loginResponseData;
      completer.complete(feedApiResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> postComments(String id, BuildContext context,
      CommentRequest request, String model) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.comments + "$model/$id/comment/",
        requestBody: request.toJson());

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      Comments loginResponseData = new Comments.fromJson(response);

      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> addAward(
      BuildContext context, AddAwardsRequest request) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context, url: APIs.awards, requestBody: request.toJson());

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      Award award = new Award.fromJson(response);

      completer.complete(award);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> updateAward(
      BuildContext context, AddAwardsRequest request,String awardId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context, url: "${APIs.awards}$awardId/", requestBody: request.toJson());

    hideLoader();
    print("response $response");
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      Award award = new Award.fromJson(response);

      completer.complete(award);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getComments(
      String id, BuildContext context, String model) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.comments + "$model/$id/comments/");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      GetCommentMainResponse loginResponseData =
          new GetCommentMainResponse.fromJson(response);

      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getThreadComments(
    String id,
    BuildContext context,
  ) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.getThreadComment + "$id/thread/");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      GetCommentMainResponse loginResponseData =
          new GetCommentMainResponse.fromJson(response);

      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getReplyComments(
      String id, BuildContext context, String model) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.comments + "Comment/$id/thread/");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      GetCommentMainResponse loginResponseData =
          new GetCommentMainResponse.fromJson(response);

      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getSearchData(String query, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
        await APIHandler.get(context: context, url: APIs.search + "$query");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      SearchListResponse loginResponseData =
          new SearchListResponse.fromJson(response);

      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getNotification(int page, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.notification + "$page");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      NotificationResponse notificationResponse =
          new NotificationResponse.fromJson(response);

      print("notification ${notificationResponse.toJson()}");
      completer.complete(notificationResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getDataSendInvite(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(context: context, url: APIs.sendinvite);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      inviteSendReceivedResponse =
          new InviteSendReceivedResponse.fromJson(response);

      completer.complete(inviteSendReceivedResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> requestAcceptRemove(AcceptRejectInvitation request,
      BuildContext context, REQUESTTYPE requesttype, String id) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response;

    //for accept
    if (requesttype == REQUESTTYPE.ACCEPT) {
      response = await APIHandler.put(
          context: context,
          url: APIs.acceptreject + "$id/",
          requestBody: request.toJson());
    }
    //for request reject
    else if (requesttype == REQUESTTYPE.REJECT) {
      response = await APIHandler.put(
          context: context,
          url: APIs.acceptreject + "$id/",
          requestBody: request.toJson());
    }
    //for delete the request
    else {
      response = await APIHandler.delete(
          context: context, url: APIs.acceptreject + "$id/");
    }

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AcceptRejectInvitation loginResponseData =
          new AcceptRejectInvitation.fromJson(response);

      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> likeUnlikeProjectFeed(
      BuildContext context, int id, int type, String model) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: type == 1
            ? APIs.likeUnlikeProjectFeed + "$model/$id/like/"
            : APIs.likeUnlikeProjectFeed + "$model/$id/unlike/");

    print("url ${APIs.likeUnlikeProjectFeed + "$model/$id/like/"}");

    if (response is APIError) {
      completer.complete(response);

      return completer.future;
    } else {
      LikesResponse loginResponseData = new LikesResponse.fromJson(response);
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> hideCredits(
      BuildContext context, HideCreditRequest request, String creditId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: "${APIs.hideCredits}/$creditId/",
        requestBody: request.toJson());

    print("request ${request.toJson()}");
    print("response $response");
    hideLoader();
    if (response is APIError) {
      completer.complete(response);

    } else {
      completer.complete(response);
      notifyListeners();

    }
    return completer.future;
  }

  Future<dynamic> assignUserToProject(
      BuildContext context,  String roleId,String userId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: "${APIs.assignUserToProject}/$roleId/assign/User/$userId",
       );

    print("request url ${ "${APIs.assignUserToProject}/$roleId/assign/User/$userId/"}");
    print("response $response");
    hideLoader();
    if (response is APIError) {
      completer.complete(response);

    } else {
      completer.complete(response);
      notifyListeners();

    }
    return completer.future;
  }
  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}

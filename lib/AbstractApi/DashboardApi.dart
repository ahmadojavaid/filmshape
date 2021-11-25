import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:new_flutter_mar/Model/AddAccount/AddAccountRequest.dart';
import 'package:new_flutter_mar/Model/UserDetail/UserDetailRequest.dart';
import 'package:new_flutter_mar/Model/cancelorder/CancelOrderRequest.dart';
import 'package:new_flutter_mar/Model/change_setting_password/ChangeSettingPasswordRequest.dart';
import 'package:new_flutter_mar/Model/chatuser/chat_user.dart';
import 'package:new_flutter_mar/Model/device_token_request/DeviceTokenRequest.dart';
import 'package:new_flutter_mar/Model/gameslist/GameSearchList.dart';
import 'package:new_flutter_mar/Model/my_selling/MySellingRequest.dart';
import 'package:new_flutter_mar/Model/report/ReportRequest.dart';
import 'package:new_flutter_mar/Model/user_profile/UserProfileRequest.dart';

abstract class DashboardApi {
  Stream<List<ChatUser>> getChatFriends({@required String userId});

  Future updateGroupMessage({@required ChatUser user, @required String userId});

  Future createChatUser({@required ChatUser user, @required String userId});

  Future<bool> updateDeviceToken(
      {@required String deviceToken,
      @required String userId,
      @required String deviceType});

  Future<bool> resetUnreadMessageCount(
      {@required String userId, @required String chatUserId});

  Future<dynamic> getCategoryList({
    @required BuildContext context,
  });

  Future<dynamic> reportUser({
    @required ReportRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> changeSettingPasswordUser({
    @required ChangeSettingPasswordRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> changeLanguage({
    @required Map requestBody,
    @required BuildContext context,
  });

  @override
  Future updateUserProfile({
    @required UserProfileRequest userDetailRequest,
    @required BuildContext context,
  });

  Future<dynamic> getNotificationList(
      {@required BuildContext context, int page});

  Future<dynamic> readNotification(
      {@required BuildContext context, @required int id});

  Future<dynamic> readAllNotification({@required BuildContext context});

  Future<dynamic> getGamesList(
      {@required BuildContext context,
      @required GameSearchListRequest gameListRequest,
      int page});

  Future<dynamic> addAccount({
    @required AddAccountRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> getGameDetails(
      {@required BuildContext context,
      int id,
      int page,
      @required GameSearchListRequest gameListRequest});

  Future<dynamic> setDeviceToken({
    @required DeviceTokenRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> getMySelling(
      {@required BuildContext context, MySellingRequest request, int page});

  Future<dynamic> deleteMySelling({@required BuildContext context, int id});

  Future<dynamic> cancelOrder({
    @required BuildContext context,
    CancelOrderRequest request,
  });

  Future<dynamic> getOrderList({@required BuildContext context, int page});

  Future<dynamic> getMyFaq({@required BuildContext context, int page});

  Future<dynamic> getCMSPage({@required BuildContext context, int page});

  Future<dynamic> notificationOnOff({
    @required BuildContext context,
  });

  Future<dynamic> getGameFullDetails({@required BuildContext context, int id});

  Future<dynamic> companyLogoUser({
    @required Map requestBody,
    @required BuildContext context,
  });

  Future<dynamic> skipUserProfile({
    @required Map requestBody,
    @required BuildContext context,
  });

  Future<dynamic> isUserApproved({
    @required BuildContext context,
  });

  Future<dynamic> getProfile({
    @required BuildContext context,
  });

  Future<dynamic> getCategories({
    @required BuildContext context,
  });

  Future<dynamic> updateProfile({
    @required UserDetailRequest userDetailRequest,
    @required BuildContext context,
  });
}

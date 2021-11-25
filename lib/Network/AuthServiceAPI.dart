import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_flutter_mar/AbstractApi/AuthAPI.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/ForgotPasswordRequest.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/ForgotPasswordResponse.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/otp_verification/ForgotPasswordOtpRequest.dart';
import 'package:new_flutter_mar/Model/Login/LoginRequest.dart';
import 'package:new_flutter_mar/Model/Login/LoginResponse.dart';
import 'package:new_flutter_mar/Model/Network/APIError.dart';
import 'package:new_flutter_mar/Model/ResendOTP/ResendOTPResponse.dart';
import 'package:new_flutter_mar/Model/SignUp/SignUpRequest.dart';
import 'package:new_flutter_mar/Model/SignUp/SignupResponse.dart';
import 'package:new_flutter_mar/Model/SignUp/registration_otp/RegistrationOtpRequest.dart';
import 'package:new_flutter_mar/Model/SignUp/registration_otp/RegistrationOtpResponse.dart';
import 'package:new_flutter_mar/Model/change_password/ChangePasswordRequest.dart';
import 'package:new_flutter_mar/Model/change_password/ChangePasswordResponse.dart';
import 'package:new_flutter_mar/Model/social/LoginMediaRequest.dart';
import 'package:new_flutter_mar/Model/social/SocialMediaRequest.dart';
import 'package:new_flutter_mar/Network/APIHandler.dart';
import 'package:new_flutter_mar/Utils/APIs.dart';

class AuthServiceAPI extends AuthAPI {
  @override
  // Hits Login api
  Future<dynamic> loginUser({
    @required BuildContext context,
    @required LoginRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.loginUrl,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponse = new LoginResponse.fromJson(response);
      completer.complete(loginResponse);
      return completer.future;
    }
  }

  Future<dynamic> loginSocialUser({
    @required BuildContext context,
    @required LoginMediaRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.loginSocialUrl,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponse = new LoginResponse.fromJson(response);
      completer.complete(loginResponse);
      return completer.future;
    }
  }

  Future<dynamic> signSocialUser({
    @required BuildContext context,
    @required SocialMediaRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.signSocialUrl,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponse = new LoginResponse.fromJson(response);
      completer.complete(loginResponse);
      return completer.future;
    }
  }

  // Hits signup user api
  Future<dynamic> signUpUser({
    @required BuildContext context,
    @required SignUpRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.signUpUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      SignupResponse loginResponse = new SignupResponse.fromJson(response);
      completer.complete(loginResponse);
      return completer.future;
    }
  }

  // Hits signup otp verify Otp api
  Future<dynamic> signUpOTPVerifyUser({
    @required BuildContext context,
    @required RegistrationOtpRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.verifyOTPUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      RegistrationOtpResponse loginResponse =
          new RegistrationOtpResponse.fromJson(response);
      completer.complete(loginResponse);
      return completer.future;
    }
  }

  // Hits change phone email otp verify Otp api
  Future<dynamic> changePhoneEmailOTPVerifyUser({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
      context: context,
      requestBody: requestBody,
      url: APIs.verifyChangePhoneEmailOTPUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      completer.complete(response);
      return completer.future;
    }
  }

  // Hits forgotPassword api
  Future<dynamic> forgotPasswordUser({
    @required BuildContext context,
    @required ForgotPasswordRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.forgotPasswordUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse forgotPasswordResponse =
          new ForgotPasswordResponse.fromJson(response);
      completer.complete(forgotPasswordResponse);
      return completer.future;
    }
  }

  // Hits forgotPassword api
  Future<dynamic> resendforgotPasswordUser({
    @required BuildContext context,
    @required ForgotPasswordRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.resendforgotPasswordUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse forgotPasswordResponse =
          new ForgotPasswordResponse.fromJson(response);
      completer.complete(forgotPasswordResponse);
      return completer.future;
    }
  }

  // Hits forgotPassword api
  Future<dynamic> resendsignupPasswordUser({
    @required BuildContext context,
    @required ForgotPasswordRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.resendsignupPasswordUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse forgotPasswordResponse =
          new ForgotPasswordResponse.fromJson(response);
      completer.complete(forgotPasswordResponse);
      return completer.future;
    }
  }

  // Hits forgotPassword Otp verify api
  Future<dynamic> forgotOTPVerifyUser({
    @required BuildContext context,
    @required ForgotPasswordOtpRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.forgotOTPVerifyUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits forgotPassword Otp verify api
  Future<dynamic> resetPasswordUser({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
      context: context,
      requestBody: requestBody,
      url: APIs.resetPasswordUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ChangePasswordResponse changePasswordResponse =
          new ChangePasswordResponse.fromJson(response);
      completer.complete(changePasswordResponse);
      return completer.future;
    }
  }

  // Hits change Password api
  Future<dynamic> changePasswordUser({
    @required BuildContext context,
    @required ChangePasswordRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.changePasswordUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ChangePasswordResponse changePasswordResponse =
          new ChangePasswordResponse.fromJson(response);
      completer.complete(changePasswordResponse);
      return completer.future;
    }
  }

  // Hits change phone-email api
  Future<dynamic> changePhoneEmail({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.changePhoneEmailUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      completer.complete(response);
      return completer.future;
    }
  }

  // Hits resend Otp api
  Future<dynamic> resendOTPUser({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.resendOTPUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ResendOTPResponse resendOtpResponse =
          new ResendOTPResponse.fromJson(response);
      completer.complete(resendOtpResponse);
      return completer.future;
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_flutter_mar/AbstractApi/AuthAPI.dart';
import 'package:new_flutter_mar/BLocs/BLoc.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/ForgotPasswordRequest.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/otp_verification/ForgotPasswordOtpRequest.dart';
import 'package:new_flutter_mar/Model/Login/LoginRequest.dart';
import 'package:new_flutter_mar/Model/SignUp/SignUpRequest.dart';
import 'package:new_flutter_mar/Model/SignUp/registration_otp/RegistrationOtpRequest.dart';
import 'package:new_flutter_mar/Model/change_password/ChangePasswordRequest.dart';
import 'package:new_flutter_mar/Model/social/LoginMediaRequest.dart';
import 'package:new_flutter_mar/Model/social/SocialMediaRequest.dart';

class AuthBLoc extends BLoc {
  AuthAPI authAPI;

  AuthBLoc({
    @required this.authAPI,
  });

  Future<dynamic> loginUser({
    @required LoginRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.loginUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> loginSocialUser({
    @required LoginMediaRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.loginSocialUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> signupSocialUser({
    @required SocialMediaRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.signSocialUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> signUpUser({
    @required SignUpRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.signUpUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> signUpOTPVerify({
    @required RegistrationOtpRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.signUpOTPVerifyUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> changePhoneEmailOTPVerifyUser({
    @required Map request,
    @required BuildContext context,
  }) async {
    return await authAPI.changePhoneEmailOTPVerifyUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> resendOTP({
    @required Map request,
    @required BuildContext context,
  }) async {
    return await authAPI.resendOTPUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> forgotPassword({
    @required ForgotPasswordRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.forgotPasswordUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> resendforgotPassword({
    @required ForgotPasswordRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.resendforgotPasswordUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> resendsignupPassword({
    @required ForgotPasswordRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.resendsignupPasswordUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> forgotOtpVerify({
    @required ForgotPasswordOtpRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.forgotOTPVerifyUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> changePassword({
    @required ChangePasswordRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.changePasswordUser(
      requestBody: request,
      context: context,
    );
  }

  @override
  void dispose() {
    // implement dispose
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/ForgotPasswordRequest.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/otp_verification/ForgotPasswordOtpRequest.dart';
import 'package:new_flutter_mar/Model/Login/LoginRequest.dart';
import 'package:new_flutter_mar/Model/SignUp/SignUpRequest.dart';
import 'package:new_flutter_mar/Model/SignUp/registration_otp/RegistrationOtpRequest.dart';
import 'package:new_flutter_mar/Model/change_password/ChangePasswordRequest.dart';
import 'package:new_flutter_mar/Model/social/LoginMediaRequest.dart';
import 'package:new_flutter_mar/Model/social/SocialMediaRequest.dart';

abstract class AuthAPI {
  Future<dynamic> loginUser({
    @required LoginRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> loginSocialUser({
    @required LoginMediaRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> signSocialUser({
    @required SocialMediaRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> signUpUser({
    @required SignUpRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> forgotPasswordUser({
    @required ForgotPasswordRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> resendforgotPasswordUser({
    @required ForgotPasswordRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> resendsignupPasswordUser({
    @required ForgotPasswordRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> forgotOTPVerifyUser({
    @required ForgotPasswordOtpRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> resendOTPUser({
    @required Map requestBody,
    @required BuildContext context,
  });

  Future<dynamic> resetPasswordUser({
    @required Map requestBody,
    @required BuildContext context,
  });

  Future<dynamic> changePasswordUser({
    @required ChangePasswordRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> changePhoneEmail({
    @required Map requestBody,
    @required BuildContext context,
  });

  Future<dynamic> signUpOTPVerifyUser({
    @required RegistrationOtpRequest requestBody,
    @required BuildContext context,
  });

  Future<dynamic> changePhoneEmailOTPVerifyUser({
    @required Map requestBody,
    @required BuildContext context,
  });
}

import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/notifier_provide_model/my_profile.dart';


import 'package:Filmshape/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';


import 'notifier_provide_model/create_project_provider.dart';
import 'notifier_provide_model/forgot_provider.dart';
import 'notifier_provide_model/join_project.dart';
import 'notifier_provide_model/login_provider.dart';
import 'notifier_provide_model/signup_provider.dart';
import 'notifier_provide_model/suggestion_notifier.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SingupProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => CreateProfileProvider()),
        ChangeNotifierProvider(
            create: (context) => CreateProfileSecondProvider()),
        ChangeNotifierProvider(create: (context) => SuggestionProvider()),
        ChangeNotifierProvider(create: (context) => ForgotProvider()),
        ChangeNotifierProvider(create: (context) => MyProfileProvider()),
        ChangeNotifierProvider(create: (context) => JoinProjectProvider()),
        ChangeNotifierProvider(create: (context) => CreateProjectProvider()),
        ChangeNotifierProvider(create: (context) => HomeListProvider()),
        ChangeNotifierProvider(create: (context) => FirebaseProvider())
      ],
      child: NotifierProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Define the default brightness and colors.
            primaryColor: AppColors.kPrimaryBlue,
            hintColor: AppColors.kPlaceHolberFontcolor,
          ),
          home: new SplashScreen(),
//          home: ShowCaseWidget(
//            builder: Builder(
//                builder: (context) => MailPage()
//            ),
//          ),
        ),
      ),
    ));

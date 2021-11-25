import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/material.dart';

class ReportViolationScreen extends StatefulWidget {
  @override
  _ReportViolationScreenState createState() => _ReportViolationScreenState();
}

class _ReportViolationScreenState extends State<ReportViolationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarBackButton(onTap: () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                child: new Text(
                  "Report Violation",
                  style: AppCustomTheme.createProfileSubTitle,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: new EdgeInsets.symmetric(horizontal: MARGIN_LEFT_RIGHT),
                child: new Text(
                  "To report violation of our term or any abuse please contact our email address directly here",
                  style: AppCustomTheme.body15Regular
                      .copyWith(color: Colors.grey, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: new EdgeInsets.symmetric(horizontal: MARGIN_LEFT_RIGHT),
                child: Text(
                  'Team@filmshape.com',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

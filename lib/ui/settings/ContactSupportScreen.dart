import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/material.dart';

class ContactSupportScreen extends StatefulWidget {
  @override
  _ContactSupportScreenState createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
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
                  "Contact support",
                  style: AppCustomTheme.createProfileSubTitle,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: new EdgeInsets.symmetric(horizontal: MARGIN_LEFT_RIGHT),
                child: new Text(
                  "We're currenty very small team and we want to help as much as possible so with any querries or issue please message the profile directy below or contact our email",
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
              SizedBox(
                height: 20,
              ),
              Container(
                margin: new EdgeInsets.symmetric(horizontal: MARGIN_LEFT_RIGHT),
                child: new Text(
                  "You can recognise our team by purple dot :)",
                  style: AppCustomTheme.body15Regular
                      .copyWith(color: Colors.grey, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("horseUrl"),
                  ),
                  title: Text('Filmshape Support',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  subtitle: Text('How can I help?',
                      style: AppCustomTheme.body15Regular),
                  onTap: () {
                    print('horse');
                  },
                  selected: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

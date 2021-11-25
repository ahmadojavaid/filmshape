import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/ui/profile/create_profile.dart';

import '../widgets/slide_dots.dart';
import '../widgets/slide_item.dart';

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0,viewportFraction: 0.99);
  String title = "Next";
  var slideList = List<Widget>();


  @override
  void initState() {
    MemoryManagement.init();
    slideList.add(SlideItem(0));
    slideList.add(SlideItem(1));
    slideList.add(SlideItem(2));

    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    _pageController.animateToPage(
        index, duration: Duration(milliseconds: 150), curve: Curves.linear);
    if (index == 0) {
      title = "Next";
    } else if (index == 1) {
      title = "Cool, next!";
    } else {
      title = "Create profile";
    }

    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.white,
        body: Container(
          child: Column(
            children: <Widget>[

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: SvgPicture.asset(
                      AssetStrings.filmLogo,
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                ),
              ),


              Expanded(
                flex: 1,
                child: Container(
                   alignment: Alignment.center,

                  child: PageView.builder(

                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: slideList.length,
                    itemBuilder: (ctx, index) => slideList[index],
                  ),
                ),
              ),


              Container(
                width: (MediaQuery.of(context).size.width*55)/100,
                child: InkWell(
                  borderRadius: new BorderRadius.circular(20.0),
                  onTap: () {
                    if (_currentPage == 2) {
                      MemoryManagement.setScreen(screen: 2);
                      Navigator.pushAndRemoveUntil(
                        context,
                        new CupertinoPageRoute(builder: (
                            BuildContext context) {
                          return new CreateProfile();
                        }),
                            (route) => false,
                      );
                    } else {
                      _onPageChanged(_currentPage + 1);
                    }
                  },
                  child: Container(
                    width: getScreenSize(context: context).width,


                    height: 45.0,
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 4.0,
                          ),
                        ],
                        color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        new SizedBox(
                          width: 40.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        new Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 18.0,
                        ),
                        new SizedBox(
                          width: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < slideList.length; i++)
                      if (i == _currentPage)
                        SlideDots(true)
                      else
                        InkWell(onTap: () {
                          _onPageChanged(
                              i); //change the slide on circle click
                        }, child: SlideDots(false))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

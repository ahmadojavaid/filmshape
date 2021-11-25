import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'items/awards.dart';
import 'items/comment_tab.dart';
import 'items/details_tab.dart';
import 'items/team.dart';

class VideoView extends StatefulWidget {
  @override
  _CoolLoginState createState() => _CoolLoginState();
}

class _CoolLoginState extends State<VideoView> with TickerProviderStateMixin {
  TabController tabBarController;
  int _tabIndex = 0;
  String image;
  final List<Widget> _pages = List();
  final PageController _controller = new PageController();
  List<String> list = new List();

  double currentIndexPage = 0.0;

  @override
  void initState() {
    list.add(AssetStrings.imageMusic);
    list.add(AssetStrings.imageLighting);
    tabBarController =
    new TabController(initialIndex: _tabIndex, length: 4, vsync: this);
  }

  Widget _getPager(String image) {
    return new Image.asset(
      image,
      width: getScreenSize(context: context).width,
      height: 250.0,
      fit: BoxFit.fill,
    );
  }

  var screensize;


  @override
  Widget build(BuildContext context) {
    screensize = MediaQuery
        .of(context)
        .size;
    _pages.clear();
    _pages.add(_getPager(AssetStrings.imageFirst));
    _pages.add(_getPager(AssetStrings.imageSecons));

    return new Container(
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getCommonHeader(list, 0),
            Container(
              margin: new EdgeInsets.only(left: 32.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Expanded(
                    child: new RichText(
                      text: new TextSpan(
                        text: "Randy Ingam",
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: AssetStrings.lotoBoldStyle),
                        children: <TextSpan>[
                          new TextSpan(
                              text: ' has uploaded a new film',
                              style: new TextStyle(
                                  fontFamily: AssetStrings.lotoRegularStyle)),
                        ],
                      ),
                    ),
                  ),

                  new SvgPicture.asset(
                    AssetStrings.like, width: 20, height: 20,
                  ),


                  new Text(
                    " 25k",
                    style: AppCustomTheme.projectDateLikeStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            new SizedBox(
              height: 30.0,
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: screensize.height / 3.2,
                  width: screensize.width,
                  color: Colors.blueGrey,
                  child: new PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      reverse: false,
                      onPageChanged: (int index) {
                        currentIndexPage = index.toDouble();
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _pages[index];
                      }),
                ),
                new Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: new Container(
                      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          new Icon(Icons.play_circle_filled,
                              color: Colors.white, size: 55.0),
                          new Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 30.0)
                        ],
                      ),
                    ))
              ],
            ),
            Container(
              width: screensize.width,
              margin: new EdgeInsets.only(left: 20.0),

              child: new TabBar(
                  indicatorColor: AppColors.kPrimaryBlue,
                  labelStyle: AppCustomTheme.tabSelectedVideoTextStyle,
                  indicatorWeight: 2.5,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppColors.kPrimaryBlue,
                  isScrollable: true,
                  unselectedLabelStyle: AppCustomTheme
                      .tabUnSelectedVideoTextStyle,
                  controller: tabBarController,
                  unselectedLabelColor: AppColors.tabUnselectedBackground,
                  tabs: <Widget>[
                    new Tab(
                      text: "Comments",
                    ),
                    new Tab(
                      text: "Details",
                    ),
                    new Tab(
                      text: "Awards",
                    ),
                    new Tab(
                      text: "Team",
                    )
                  ]),
              ),

            new Container(
              height: 1.0,
              color: AppColors.dividerColor,
            ),
            Container(
              height: 280.0,
              color: Colors.black,

              child: new TabBarView(
                controller: tabBarController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  new CommentTab(),
                  new DetailsTab("", "", "", "", ""),
                  new AwardsTab(),
                  new TeamTab(),
                ],
              ),
            ),
            new Container(
              height: 1,
              color: AppColors.dividerColor,
            ),
            new Container(
              height: 50.0,
              width: screensize.width,
              margin: new EdgeInsets.only(left: 20, right: 20),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  getRowWidget("Like", AssetStrings.like, 1),
                  getRowWidget("Comment", AssetStrings.comment, 2),
                  getRowWidget("Share", AssetStrings.share, 3)
                ],
              ),
            ),
            new Container(
              height: 20,

              decoration: new BoxDecoration(
                color: AppColors.tabBackground,
                border: Border(
                  top: BorderSide(
                      width: 0.6, color: AppColors.dividerColor),
                  bottom: BorderSide(
                      width: 0.6, color: AppColors.dividerColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

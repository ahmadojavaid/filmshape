import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/badge_count.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/common_video_view/video_common_view.dart';
import 'package:Filmshape/ui/home/home_list/first_of_week/feed_media_type.dart';
import 'package:Filmshape/ui/home/home_list/first_of_week/feed_normal_type.dart';
import 'package:Filmshape/ui/home/home_list/first_of_week/first_of_week_home.dart';
import 'package:Filmshape/ui/payment_screen/PaymentScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class HomeList extends StatefulWidget {
  final ValueChanged<Widget> fullScreenWidget;

  HomeList(this.fullScreenWidget, {Key key}) : super(key: key);

  @override
  HomeListState createState() => HomeListState();
}

class HomeListState extends State<HomeList>
    with AutomaticKeepAliveClientMixin<HomeList> {
  List<Object> listHome = new List();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  int _page = 1;
  ScrollController scrollController = new ScrollController();
  var screensize;
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  HomeListProvider provider;
  bool _showLoader = true;

  //for item visibility detector
//  var previousLastVisibleIndex = "0";
//  var firstTime = true;
//  var notSameCallOnce=true;
  int _stopPos = 0;
  Notifier _notifier;

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(const Duration(milliseconds: 300), () {
      hitApi();
    });
    _setScrollListener();
    super.initState();
  }

//to move to inner side  screen
  void moveToScreen(
      Widget screen, ValueSetter<BadgeCount> updateProjectCount) async {
    var status = await Navigator.push<String>(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return screen;
      }),
    );

    if (status != null) {
      updateProjectCount(BadgeCount(type: 2)); // project deleted
    }
  }

  void checkItemVisibility(VisibilityInfo info) {
//    Future.delayed(const Duration(milliseconds: 2000), () {
//      print("pre $previousLastVisibleIndex");
//
//      if (previousLastVisibleIndex != info.key.toString()&&notSameCallOnce) {
//
//        previousLastVisibleIndex = info.key.toString();
//        if (!firstTime) {
//          print("its not same");
//          notSameCallOnce=false;
//          //pauseVideoIfAnyPlaying();
//        } else {
//          firstTime = false;
//        }
//      }
//      else
//      {
//
//        Future.delayed(const Duration(milliseconds: 2000), () {
//          notSameCallOnce=true;
//        });
//
//      }
//      print("post $previousLastVisibleIndex");
//
//    });
  }

  Widget _buildContestList() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        isPullToRefresh = true;
        _loadMore = false;
        await hitApi();
      },
      child: new ListView.builder(
        controller: scrollController,
        padding: new EdgeInsets.all(0.0),
        itemBuilder: (BuildContext context, int index) {
          if (listHome[index] is List<FeaturedUsers>) {
            return getFeaturedUsers(listHome[index]);
          } else if (listHome[index] is int) {
            return VideoView();
          } else if (listHome[index] is Feed) {
            return getFeedTypeView(listHome[index]);
          } else if (listHome[index] is List<FeaturedProjects>) {
            return FirstofWeekHome(listHome[index], widget.fullScreenWidget);
          } else {
            return Container();
          }
        },
        itemCount: listHome.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screensize = MediaQuery.of(context).size;
    _notifier = NotifierProvider.of(context); // to update home screen header
    provider = Provider.of<HomeListProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKeys,
        body: Stack(
          children: <Widget>[
            new Container(
              child: _buildContestList(),
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: _showLoader,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      var currentPos = scrollController.offset.toInt();
      if (currentPos % 50 == 0 && (_stopPos != currentPos)) {
        _stopPos = currentPos;
        print("scroll pos ${currentPos}");
        pauseVideoIfAnyPlaying();
      }
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (listHome.length >= (PAGINATION_SIZE * _page) && _loadMore) {
          isPullToRefresh = true;
          hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  hitApi() async {
    if (!isPullToRefresh) {
      provider.setLoading();
      _showLoader = true;
    }

    if (_loadMore) {
      _page++;
    } else {
      _page = 1;
    }

    var response = await provider.getData(_page, context);
    _showLoader = false;

    if (response is FeedApiResponse) {
      if (_page == 1) {
        listHome.clear();
      }

      if (response.featuredProjects.length > 0) {
        listHome.add(response.featuredProjects);

        print("response.featuredProjects ${response.featuredProjects.length}");
      }
      if (response.featuredUsers.length > 0) {
        listHome.add(response.featuredUsers);
        print("response.featuredUsers ${response.featuredUsers.length}");
      }

      if (response.feed.length > 0) {
        listHome.addAll(response.feed);
        print("response.feed ${response.feed.length}");
      }

      if ((response.featuredProjects.length != null &&
              response.featuredProjects.length > PAGINATION_SIZE) ||
          (response.featuredUsers.length != null &&
              response.featuredUsers.length > PAGINATION_SIZE) ||
          (response.feed.length != null &&
              response.feed.length > PAGINATION_SIZE)) {
        print("load more true");

        _loadMore = true;
      } else {
        print("load more false");
        _loadMore = false;
      }

      /*
      listHome.add(response.featuredUsers);
      listHome.addAll(response.feed);*/

    } else {
      APIError apiError = response;
      print(apiError.error);

      showInSnackBar(apiError.error);
    }
  }

  ValueSetter callBackPayment(int type) {
    widget.fullScreenWidget(PaymentScreen());
  }

  Widget getFeaturedUsers(List<FeaturedUsers> featuredUsers) {
    return Offstage(
      offstage: featuredUsers.length > 0 ? false : true,
      child: new Container(
        color: Colors.white,
        width: screensize.width,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new SizedBox(
              height: 30.0,
            ),
            new Container(
              margin: new EdgeInsets.only(left: 32.0),
              child: new Text(
                "Featured Users",
                style: new TextStyle(
                  fontFamily: AssetStrings.lotoRegularStyle,
                  fontSize: 18,
                ),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            buildFeatureItem(featuredUsers),
            new SizedBox(
              height: 50.0,
            ),
//            Notifier.of(context).register<String>('test',
//                (data) {
//              return isProUser()??false
//                  ? Container()
//                  :
//              UpgradeAccount(callBackPayment);
//            }),
        isProUser()
            ? Container()
            :UpgradeAccount(callBackPayment),

            new SizedBox(
              height: 20.0,
            ),
            new Container(
              height: 20,
              decoration: new BoxDecoration(
                color: AppColors.tabBackground,
                border: Border(
                  top: BorderSide(width: 0.6, color: AppColors.dividerColor),
                  bottom: BorderSide(width: 0.6, color: AppColors.dividerColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getFeedTypeView(Feed feed) {
    print("media url ${feed.mediaEmbed}");
    return feed.mediaEmbed != null
        ? FeedMediaType(feed, widget.fullScreenWidget)
        : FeedNormalType(feed, widget.fullScreenWidget);
  }

  Widget FeatureCard(FeaturedUsers users) {
    List<String> list = new List();

    if (users.roles != null && users.roles.length > 0) {
      for (var item in users.roles) {
        if (!list.contains(item.iconUrl)) {
          list.add(item.iconUrl);

        }
      }
    }

    if (users.thumbnailUrl != null) {
      list.add(users.thumbnailUrl);
    }

    return Container(
      child: InkWell(
        onTap: () {
          goToProfile(context, users.id.toString(), users.fullName);
        },
        child: new Card(
          child: new Container(
            padding: new EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new SizedBox(
                  height: 10.0,
                ),
                new Container(
                  child: new Text(
                    users.fullName != null ? users.fullName : "",
                    style: new TextStyle(
                        fontFamily: AssetStrings.lotoSemiboldStyle,
                        fontSize: 14.0,
                        color: AppColors.kHomeBlack),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                new SizedBox(
                  height: 10.0,
                ),
                Expanded(
                    child: Container(child: getSvgNetworkCacheImage(
                        list, 36, noOfShowing: 5))),
                new SizedBox(
                  height: 10.0,
                ),
                new Container(
                    child: new Text(
                  "${users.projects?.length ?? 0} Active Projects",
                  style: new TextStyle(
                      color: AppColors.tabUnselectedBackground,
                      fontFamily: AssetStrings.lotoSemiboldStyle,
                      fontSize: 13.0),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFeatureItem(List<FeaturedUsers> featuredUsers) {
    var containerHeight = (featuredUsers.length == 1) ? 140.0 : 280.0;
    var crossAxis = (featuredUsers.length == 1) ? 1 : 2;
    return new Container(
      height: containerHeight,
      margin: new EdgeInsets.only(left: 30.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxis,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.7),
        scrollDirection: Axis.horizontal,
        itemCount: featuredUsers.length,
        itemBuilder: (context, index) {
          return FeatureCard(featuredUsers[index]);
        },
      ),
    );
  }

  void pauseVideoIfAnyPlaying() {
    //moving to comment section pause running video if any
    _notifier?.notify('pausevideo', "pausevideo"); //update heading

    //call the pause video notifier with null to avoid frequent call of notifier
    //which might cause to pause resume of video
    Future.delayed(const Duration(milliseconds: 50), () {
      _notifier?.notify('pausevideo', null); //
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class UpgradeAccount extends StatelessWidget {
  final ValueChanged<int> callBackPayment;

  UpgradeAccount(this.callBackPayment);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Container(
          height: 1,
          color: AppColors.dividerColor,
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: getRowWidget("Get featured now", AssetStrings.play, 1,
                color: AppColors.kHomeBlack, callback: callBackPayment)),
        new Container(
          height: 1,
          color: AppColors.dividerColor,
        ),
      ],
    );
  }
}

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/badge_count.dart';
import 'package:Filmshape/Model/browser_project/browse_project.dart';
import 'package:Filmshape/Model/notification/notification_response.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/reply_view_comment.dart';
import 'package:Filmshape/ui/otherprojectdetails/join_project_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  final ValueChanged<Widget> fullScreenWidget;
  final ValueChanged<BadgeCount> badeCountCallback;
  final VoidCallback moveToInviteCallBack;

  NotificationScreen(
      {Key key,
      this.fullScreenWidget,
      this.badeCountCallback,
      this.moveToInviteCallBack})
      : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {


  List<Object> listNotification = new List();
  HomeListProvider provider;
  int _page = 1;
  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  bool isFirstTmeDataLoaded=false;

  //to move to inner side  screen
  void moveToScreen(Widget screen,ValueSetter<BadgeCount> updateProjectCount) async {
    var status=await Navigator.push<String>(
      context,
      new CupertinoPageRoute(
          builder: (BuildContext context) {
            return screen;
          }),
    );

    if(status!=null)
      {
        updateProjectCount(BadgeCount(type: 2));// project deleted
      }
  }

  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (listNotification.length >= (PAGINATION_SIZE * _page) && _loadMore) {
          isPullToRefresh = true;
          getNotification();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  //notification redireciton
  Future<List<Comments>> voidCallBackComments(List<Comments> comments) async {}

  void redirection(String redirect, String name) {
    print("redirection $redirect");
    if (redirect != null && redirect.contains("/")) {
      var data = redirect.split("/");

      String title = data[1];
      String itemId = data[2];
      print("$title");
      print("$itemId");
      for(var record in data)
        {
          print("record $record");
        }

      //move to project details
      if (title == "Feed" || title == "Project") {
        Navigator.push(
          context,
          new CupertinoPageRoute(builder: (BuildContext context) {
            return new JoinProjectDetails(
              int.parse(itemId),
              previousTabHeading: "Join a Project",
              fullScreenWidget: widget.fullScreenWidget,
            );
          }),
        );
      } else if (title == "User") {
        goToProfile(context, itemId,
            name);
      }
      else if (title == "Comment") {
        widget.fullScreenWidget(new ReplyCommentDetails(
          itemId,
          "",
          "Project", null, null, null, fromNotification: true,));
      }

      else if (data.length == 5) {
        widget.moveToInviteCallBack();
      }
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      getNotification();
    });

    _setScrollListener();

    super.initState();
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  //get new notification
  void getNewNotification()
  {
    _refreshIndicatorKey.currentState?.show();
  }


  getNotification() async {
    isFirstTmeDataLoaded=true;//to mark api called first time

    if (!isPullToRefresh) {
      provider.setLoading();
    }

    if (_loadMore) {
      _page++;
    } else {
      _page = 1;
    }

    var response = await provider.getNotification(_page, context);

    if (response != null && response is NotificationResponse) {
      if (_page == 1) {
        listNotification.clear();
      }

      if (response.unseen != null &&
          response.unseen.length < PAGINATION_SIZE) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }
      listNotification.addAll(response.unseen);
      listNotification.addAll(response.seen);


      //update the counter of unseen data in icon
      widget.badeCountCallback(
          BadgeCount(count: response.unseen.length, type: 3));
    } else {
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);
    }
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeListProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  isPullToRefresh = true;
                  _loadMore = false;
                  await getNotification();
                },
                child: ListView.separated(
                  controller: scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (listNotification[index] is Seen) {
                      Seen data = listNotification[index];

                      if (data.following) {
                        return buildItem(data);
                      }
                      else {
                        return _getLikeCommentTile(listNotification[index]);
                      }

                    } else {
                      return _getLikeCommentTile(listNotification[index]);
                    }
                  },
                  itemCount: listNotification.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return _getView();
                  },
                ),
              ),
            ),

            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            (listNotification.length == 0)
                ? new Center(
                child: getNoData("No Notification Found")
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget getBoldText(
      {@required String txtToBold, @required String simpleTxt, @required Seen unseen}) {
    return Row(
      children: <Widget>[


        Expanded(
          child: new RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: "$txtToBold ",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(text: simpleTxt),
              ],
            ),
          ),

        ),


        Offstage(
          offstage: unseen.seen != null && unseen.seen ? true : false,
          child: new Container(
              width: 10.0,
              height: 10.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kPrimaryBlue
              )
          ),
        )
      ],
    );
  }

  Widget _getView() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        new Container(
          height: 1.0,
          color: Colors.blueGrey.withOpacity(0.1),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget buildItem(Seen data) {
    List<String> roles = new List();
//    roles.add("");
//    roles.add("");
    return InkWell(
      onTap: () {
        goToProfile(context, data.sender.id.toString(), data.sender.fullName);
      },
      child: Container(
        margin: new EdgeInsets.only(left: 30.0, right: 30.0),
        color: data.seen != null && data.seen ? Colors.white : AppColors
            .unseenColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              child: IntrinsicHeight(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 45.0,
                      height: 45.0,
                      child: Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              goToProfile(context, data.sender?.id.toString(),
                                  data.sender?.fullName ?? "");
                            },
                            child: new Container(
                                width: 40.0,
                                height: 40.0,
                                child: ClipOval(
                                  child: getCachedNetworkImage(
                                      url:
                                          "${APIs.imageBaseUrl}${data.sender.thumbnailUrl}",
                                      fit: BoxFit.cover),
                                )),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: InkWell(
                              onTap: () {},
                              child: new Container(
                                  padding: new EdgeInsets.all(0.4),
                                  margin: new EdgeInsets.only(
                                      right: 3.0, bottom: 2.0),
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: ClipOval(
                                    child: SvgPicture.asset(
                                      AssetStrings.ic_tick,
                                      color: AppColors.kPrimaryBlue,
                                      width: 17.0,
                                      height: 17.0,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        padding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            getBoldText(
                                txtToBold: "${data.sender.fullName}" ?? "",
                                simpleTxt: "follows you",
                                unseen: data),
                            new SizedBox(
                              height: 3.0,
                            ),
                            Expanded(
                              child: Container(
                                padding: new EdgeInsets.only(right: 10.0),
                                child: new Text(
                                  data.sender.bio ?? "",
                                  style: AppCustomTheme.followingTextStyle
                                      .copyWith(
                                          color:
                                              AppColors.bottomUnselectedText),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: new EdgeInsets.only(top: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (roles.length > 0)
                      ? Container(
                          height: 35, child: getStackItem(roles, 0, 35))
                      : Container(),
                  Expanded(
                    child: new SizedBox(
                      width: 5.0,
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10.0),
                    decoration: new BoxDecoration(
                        border: new Border.all(
                          color: AppColors.kPrimaryBlue,
                          width: 1.0,
                        ),
                        borderRadius: new BorderRadius.circular(16.0)),
                    child: new Text(
                      "Following",
                      style: new TextStyle(
                          color: AppColors.kPrimaryBlue,
                          fontSize: 13.5,
                          fontFamily: AssetStrings.lotoRegularStyle),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16,),
            TimeWidget(dateString: data.created,)
          ],
        ),
      ),
    );
  }

  Widget _getLikeCommentTile(Seen unseen) {

    //  print("message ${unseen.message}");
    return InkWell(
      onTap: () {
        redirection(unseen.link, unseen.sender.fullName);
      },
      child: Container(
        color: unseen.seen != null && unseen.seen ? Colors.white : AppColors
            .unseenColor,
        child: Container(
          margin: new EdgeInsets.only(left: 30.0, right: 30.0),

          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        goToProfile(context, unseen.sender.id.toString(),
                            unseen.sender.fullName);
                      },
                      child: new Container(
                          width: 40.0,
                          height: 40.0,

                          child: ClipOval(
                            child: getCachedNetworkImageWithurl(
                                url: "${unseen.sender.thumbnailUrl}",
                                fit: BoxFit.cover),
                          )),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          alignment: Alignment.centerLeft,
                          child: Html(
                              shrinkToFit: true, data: "${unseen.message}")
                      ),
                    ),
                    Offstage(
                      offstage: unseen.seen != null && unseen.seen
                          ? true
                          : false,
                      child: new Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.only(top: 13),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.kPrimaryBlue
                          )
                      ),
                    )
                  ],
                ),
                TimeWidget(dateString: unseen.created,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class TimeWidget extends StatelessWidget
{

  final String dateString;
  TimeWidget({this.dateString});
  @override
  Widget build(BuildContext context) {
    var createdAt="";
    if (dateString != null) {
      createdAt = "${formatDateStringMyProject(dateString,notiDateFormat)}";
    }
    return new Text(
      createdAt,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: new TextStyle(
        fontFamily: AssetStrings.lotoRegularStyle,
        fontSize: 11.0,
        color: AppColors.kPlaceHolberFontcolor,
      ),
    );
  }

}

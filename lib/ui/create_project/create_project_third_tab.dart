import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/full_view_comment.dart';
import 'package:Filmshape/ui/create_project/common_list_tabs.dart';
import 'package:Filmshape/ui/create_project/third_tab_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateProjectThirdTab extends StatefulWidget {
  final String projectId;
  final bool isRole;
  final ValueChanged<Widget> fullScreenCallBack;
  final ValueSetter<bool> callback;

  CreateProjectThirdTab(this.projectId, this.fullScreenCallBack,
      {Key key, bool this.isRole, this.callback})
      : super(key: key);

  @override
  CommentTabs createState() => CommentTabs();
}

class CommentTabs extends State<CreateProjectThirdTab>
    with AutomaticKeepAliveClientMixin<CreateProjectThirdTab> {
  Color color = Colors.grey.withOpacity(0.7);

  List<ProjectRoleCalls> myTeam = List();

  HomeListProvider provider;
  CreateProfileSecondProvider createProfileSecondProvider;

  GlobalKey<RoleListState> _keyRoleList = new GlobalKey<RoleListState>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setData();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void setData() {
    myTeam.clear();
    if (createProfileSecondProvider.projectResponse.projectRoleCalls != null) {
      myTeam.addAll(createProfileSecondProvider.projectResponse.projectRoleCalls
          .toList());
    }

    _keyRoleList.currentState.setRolesData(myTeam); //update role data

    createProfileSecondProvider.projectResponse?.isLike = false;
    if ((createProfileSecondProvider.projectResponse?.likedBy?.length ?? 0) >
        0) {
      createProfileSecondProvider.projectResponse?.isLike =
          checkLikeUserId(createProfileSecondProvider.projectResponse.likedBy);
    }

    setState(() {});
  }

  Widget videoLinkView(String text, IconData image, Color color, int type) {
    return InkWell(
      onTap: () {},
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 11.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Icon(
              image,
              color: color,
              size: 21.0,
            ),
            new SizedBox(
              width: 12.0,
            ),

            new Text(
              text,
              style: new TextStyle(
                  color: color,
                  fontSize: 17,
                  fontFamily: AssetStrings.lotoRegularStyle),
            ),
          ],
        ),
      ),
    );
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeListProvider>(context);
    createProfileSecondProvider =
        Provider.of<CreateProfileSecondProvider>(context);

    return Stack(
      children: <Widget>[
        new ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            new Container(
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),
                  ThirdTabListItem(widget.fullScreenCallBack),
                  new SizedBox(
                    height: 10.0,
                  ),
                  Offstage(
                      offstage: (createProfileSecondProvider
                                      .projectResponse?.comments?.length ??
                                  0) >
                              0
                          ? false
                          : true,
                      child: attributeHeading("View all comments")),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Container(
                    height: 1,
                    color: AppColors.dividerColor,
                  ),
                  new Container(
                    height: 50.0,
                    margin: new EdgeInsets.only(left: 20, right: 20),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        getRowWidget("Like", AssetStrings.like, 1,
                            callback: voidCallBackCount,
                            color: createProfileSecondProvider
                                            .projectResponse?.isLike !=
                                        null &&
                                    createProfileSecondProvider
                                        .projectResponse?.isLike
                                ? AppColors.kPrimaryBlue
                                : AppColors.kHomeBlack),
                        getRowWidget("Comment", AssetStrings.comment, 2,
                            color: AppColors.kHomeBlack,
                            callback: voidCallBackCount),
                        getRowWidget("Share", AssetStrings.share, 3,
                            color: AppColors.kHomeBlack,
                            callback: voidCallBackCount)
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
                  ),
                  CommonList(
                    widget.projectId,
                    widget.fullScreenCallBack,
                    isRole: widget.isRole,
                    key: _keyRoleList,
                  )
                ],
              ),
            ),
            new SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ],
    );
  }

  Future<ValueSetter> voidCallBackCount(int type) async {
    {
      if (type == 1) {
        if (createProfileSecondProvider.projectResponse != null) {
          int types =
              createProfileSecondProvider.projectResponse.isLike != null &&
                      createProfileSecondProvider.projectResponse.isLike
                  ? 0
                  : 1;
          likeUnlikeApi(createProfileSecondProvider.projectResponse.id, types);
        }
      } else if (type == 2) {
        widget.fullScreenCallBack(new CommentDetails(
          widget.projectId,
          "Project",
          callback: voidCallBackComments,
          callBacklikeUnline: likeUnlikeCommentsCallback,
          fullScreenWidget: widget.fullScreenCallBack,
          callBackLikeProject: voidCallBackLike,
        ));
      } else {
        shareData();
      }
    }
  }

  changeStatus(bool status, Comments comment) {
    if (status) {
      comment?.isLike = true;
      comment?.likedBy?.length = (comment?.likedBy?.length ?? 0) + 1;
    } else {
      comment?.isLike = false;
      comment?.likedBy?.length = (comment?.likedBy?.length ?? 0) - 1;
    }
  }

  Future<ValueSetter> likeUnlikeCommentsCallback(DataModel model) async {
    print("model id ${model.name}");
    print("model select ${model.select}");

    if (createProfileSecondProvider.projectResponse?.comments != null &&
        createProfileSecondProvider.projectResponse?.comments.length > 0) {
      for (int i = 0;
          i < createProfileSecondProvider.projectResponse?.comments.length;
          i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name ==
              createProfileSecondProvider.projectResponse?.comments[i].id
                  .toString()) {
            changeStatus(model.select,
                createProfileSecondProvider.projectResponse?.comments[i]);
          }
        } else {
          if (createProfileSecondProvider.projectResponse?.comments[0] !=
                  null &&
              createProfileSecondProvider
                      .projectResponse?.comments[0].replies.length >
                  0) {
            var data = createProfileSecondProvider
                .projectResponse?.comments[0].replies[0];

            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            } else {
              if (model.name ==
                  createProfileSecondProvider.projectResponse?.comments[i].id
                      .toString()) {
                changeStatus(model.select,
                    createProfileSecondProvider.projectResponse?.comments[i]);
              }
            }
          } else {
            if (model.name ==
                createProfileSecondProvider.projectResponse?.comments[i].id
                    .toString()) {
              changeStatus(model.select,
                  createProfileSecondProvider.projectResponse?.comments[i]);
            }
          }
        }
      }
      /* widget.callback(list);*/
      setState(() {});
    }
  }


  Future<ValueSetter> voidCallBackLike(bool isLIked) async {
    {
      createProfileSecondProvider.projectResponse.isLike = isLIked;

      if (isLIked) {
        createProfileSecondProvider.projectResponse.likedBy.length =
            createProfileSecondProvider.projectResponse.likedBy.length + 1;
      }
      else {
        createProfileSecondProvider.projectResponse.likedBy.length =
            createProfileSecondProvider.projectResponse.likedBy.length - 1;
      }

      setState(() {});
    }
  }

  Future<ValueSetter> voidCallBackComments(Comments comments) async {
    {
      createProfileSecondProvider.projectResponse.comments.insert(0, comments);
      createProfileSecondProvider.projectResponse.moreCommentNo +=
          1; //add 1 more comment count to

      setState(() {});
    }
  }

  Future<bool> likeUnlikeApi(int id, int type) async {
    var response =
        await provider.likeUnlikeProjectFeed(context, id, type, "Project");

    if (response != null && (response is LikesResponse)) {
      createProfileSecondProvider.projectResponse?.likedBy?.length =
          response.likes;

      if (createProfileSecondProvider.projectResponse?.isLike == null) {
        createProfileSecondProvider.projectResponse?.isLike = false;
      }
      createProfileSecondProvider.projectResponse?.isLike =
          !createProfileSecondProvider.projectResponse?.isLike;
    }

    if (widget.callback != null) {
      widget.callback(createProfileSecondProvider.projectResponse?.isLike);
    }

    setState(() {});
  }

  Widget attributeHeading(String text) {
    return InkWell(
      onTap: () {
        widget.fullScreenCallBack(new CommentDetails(
          createProfileSecondProvider.projectResponse.id.toString(),
          "Project",
          callback: voidCallBackComments,
          callBacklikeUnline: likeUnlikeCommentsCallback,
          fullScreenWidget: widget.fullScreenCallBack,
          callBackLikeProject: voidCallBackLike,
        ));
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            border: new Border.all(
                color: AppColors.creatreProfileBordercolor,
                width: INPUT_BOX_BORDER_WIDTH),
            color: Colors.white),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: AssetStrings.lotoRegularStyle,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

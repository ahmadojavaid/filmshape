import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/statelesswidgets/genere_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsTab extends StatefulWidget {
  final String title;
  final String description;
  final String location;
  final String genereName;
  final String projectType;
  final Project project;

  DetailsTab(this.title, this.location, this.genereName, this.description,
      this.projectType,
      {this.project, Key key})
      : super(key: key);

  @override
  DetailsTabState createState() => DetailsTabState();
}

class DetailsTabState extends State<DetailsTab>
    with AutomaticKeepAliveClientMixin<DetailsTab> {
  String genreProject;

  bool offStage = true;
  String role = "";
  String roleMain = "";
  String iconUrl = "";

  @override
  void initState() {
    super.initState();

    if (widget.project != null) {
      if (widget.project.projectRoleCalls.length > 0) {
        ProjectRoleCallss data = widget.project.projectRoleCalls[0];

        if (data.role != null) {
          offStage = false;
          role = data.role.name;
          roleMain = data.role.category.name;
          iconUrl = data.role.iconUrl;
        }
      }
    }

    genreProject =
        "${widget?.genereName ?? ""}${(widget?.projectType ?? "").length > 0 ? "/" : ""}${widget?.projectType ?? ""}";
  }

  void setData(String title, String desc) {
    print("detail tab $title $desc");
//    this._title=title;
//    this._desc=desc;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: new SingleChildScrollView(
            child: Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: new EdgeInsets.only(left: 30.0, top: 35.0),
                    child: new Text(
                      "${widget.title ?? ""}",
                      style: AppCustomTheme.detailTabNameStyle,
                    ),
                  ),
                  Offstage(
                    offstage:
                        widget.location != null && widget.location.length > 0
                            ? false
                            : true,
                    child: Container(
                      margin:
                          new EdgeInsets.only(left: 30.0, top: 5.0, right: 30),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        "${widget.location ?? ""}",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: AssetStrings.lotoRegularStyle,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                  Offstage(
                      offstage: genreProject.length > 1 ? false : true,
                      child: Container(
                          margin: new EdgeInsets.only(left: 30, top: 10),
                          child: GenereWidget(
                            genere: genreProject,
                          ))),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 30.0, top: 12.0, right: 30),
                    alignment: Alignment.topLeft,
                    child: new Text(
                      "${widget.description ?? ""}",
                      style: AppCustomTheme.descriptionDetailTab,
                    ),
                  ),

                  Offstage(
                    offstage: offStage,
                    child: Container(
                      margin: new EdgeInsets.only(left: 30.0, top: 20.0),
                      child: Row(
                        children: <Widget>[
                          Offstage(
                              offstage: iconUrl != null ? false : true,
                              child:
                                  getSvgNetworkImage(url: iconUrl, size: 20.0)),
                          new SizedBox(
                            width: 5.0,
                          ),
                          Offstage(
                            offstage: role != null ? false : true,
                            child: new Text(
                              role != null ? role : "",
                              style: new TextStyle(
                                  color: AppColors.introBodyColor,
                                  fontFamily: AssetStrings.lotoBoldStyle,
                                  fontSize: 14.0),
                            ),
                          ),
                          Expanded(
                            child: Offstage(
                              offstage: roleMain != null ? false : true,
                              child: new Text(
                                roleMain != null ? " ($roleMain)" : "",
                                style: new TextStyle(
                                    color: AppColors.introBodyColor,
                                    fontSize: 13.0,
                                    fontFamily: AssetStrings.lotoRegularStyle),
                                maxLines: 1,
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
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

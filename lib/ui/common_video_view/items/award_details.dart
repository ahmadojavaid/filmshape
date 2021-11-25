import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/create_project/add_awards_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AwardDetails extends StatefulWidget {
  final List<Award> roleCalls;
  bool saveAward;

  AwardDetails({this.roleCalls, this.saveAward});

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<AwardDetails> {
  List<Award> roles = new List();

  _buildContestList() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: new ListView.builder(
          padding: new EdgeInsets.only(bottom: 16.0),
          itemBuilder: (BuildContext context, int index) {
            return getListTileItem(roles[index].title, roles[index], index);
          },
          itemCount: roles.length,
        ),
      ),
    );
  }

  void showAwardBottomSheet(String projectIDs, Award award) async {
    var response = await showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AddAwardsBottomSheet(
                projectIDs,
                award: award,
                saveAward: widget.saveAward,
              ),
            ),
          );
        });
    if (response is Award) {
      for (var data in widget.roleCalls) {
        if (data.id == response.id) {
          data.title = response.title;
          data.url = response.url;
          data.awardInstitution = response.awardInstitution;
          data.description = response.description;

          break;
        }
      }

      setState(() {});
    }
  }

  void setRoleData() {
    roles.clear(); //clear previous list
    // TODO: implement initState

    roles.addAll(widget.roleCalls);
  }

  @override
  Widget build(BuildContext context) {
    setRoleData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarBackButton(onTap: backCallBack),
      body: new Container(
        child: new Column(
          children: <Widget>[
            _buildContestList(),
          ],
        ),
      ),
    );
  }

  VoidCallback backCallBack() {
    Navigator.pop(context);
  }

  Widget getListTileItem(String title, Award award, int index) {
    return InkWell(
      onTap: () {
        showAwardBottomSheet(award.id.toString(), award);
        //_settingModalBottomSheet(award.id.toString());
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(left: 30.0, right: 30.0),
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new SvgPicture.asset(
                  AssetStrings.imgStar,
                  width: 20.0,
                  height: 20.0,
                ),
                new SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Container(
                      child: Text(
                    title,
                    style: new TextStyle(
                        fontFamily: AssetStrings.lotoRegularStyle,
                        fontSize: 16),
                  )),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                  size: 28.0,
                ),
              ],
            ),
          ),
          getDivider(),
        ],
      ),
    );
  }

  Widget getDivider() {
    return new Container(
      height: 1.0,
      color: Colors.grey.withOpacity(0.5),
    );
  }
}

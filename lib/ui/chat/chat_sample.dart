import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/comment/read_more_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatSample extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ChatSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          margin: new EdgeInsets.only(top: 20.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //this will determine if the message should be displayed left or right
              children: [
                InkWell(
                  onTap: () {},
                  child: new Container(
                      width: 35.0,
                      height: 35.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black, width: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: getCachedNetworkImageWithurl(url: "", size: 35),
                      )),
                ),
                new SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  //Wrapping the container with flexible widget
                  child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: AppColors.CommentItemBackground,
                          border: new Border.all(
                            color: AppColors.commentBorder,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              //We only want to wrap the text message with flexible widget
                              child: Container(
                            child: new Text(
                              "Name welijhiohjwiohohqwoirhoiqhroihqoiwhroihqwiorhoiqhwiorhioqwhriohqiohrioqhroiq",
                              style: new TextStyle(
                                  color: AppColors.topTitleColor,
                                  fontSize: 15.0,
                                  fontFamily: AssetStrings.lotoBoldStyle),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          new SizedBox(
                            height: 5.0,
                          ),
                          Flexible(
                            child: ReadMoreText(
                              "fgvfddlfuopjaofjpoajfpojopfjsoafjjasfijasiohfoiahoifhowiashoihaoshfoihasiofhioahfihaishfohsa;osjojodpjaojdjasdj;sajdljslajdljsaldjlsajdlasjdlsajdlajsldjasjdllasjjdllasjdlasjdasldjlasdasd iofhiaohsfiohasiofhioahifohioashifohoiaiofhaiofhioahiahsfohoiashfhafg",
                              trimLines: 4,
                              colorClickableText: AppColors.kGrey,
                              trimMode: TrimMode.Line,
                              style: new TextStyle(
                                color: AppColors.tabCommentColor,
                                fontFamily: AssetStrings.lotoSemiboldStyle,
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.start,
                              trimCollapsedText: '..show more',
                              trimExpandedText: ' show less',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: Text(
                              "12:30 am",
                              style:
                                  TextStyle(fontSize: 11.0, color: Colors.grey),
                            ),
                          ),
                        ],
                      )),
                ),
              ]),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          child: Container(
            padding: new EdgeInsets.only(top: 17.0, right: 20.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: new Icon(Icons.favorite,
                      size: 16.0, color: AppColors.heartColor),
                ),
                new SizedBox(
                  width: 2.0,
                ),
                new Text(
                  "",
                  style: new TextStyle(
                      color: Colors.black87,
                      fontSize: 13.0,
                      fontFamily: AssetStrings.lotoRegularStyle),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

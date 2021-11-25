import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatInputWidget extends StatelessWidget {
  final ValueChanged<int> callBack;
  final TextEditingController messageFieldController;

  ChatInputWidget(this.callBack, this.messageFieldController);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Returns write Message field bar
    return new Container(
      width: getScreenSize(context: context).width,
      decoration: new BoxDecoration(
        border: new Border(
          top: new BorderSide(width: 0.8, color: AppColors.dividerColors),
        ),
      ),
      padding: new EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 12.0,
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              margin: new EdgeInsets.only(left: 15.0, right: 15.0),
              constraints: const BoxConstraints(
                maxHeight: 90.0,
              ),
              child: new TextField(
                controller: messageFieldController,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.fontBlackColor,
                  fontFamily: AssetStrings.lotoRegularStyle,
                ),
                maxLines: null,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  enabledBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(
                      color: AppColors.chatButtonBorder,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(
                      color: AppColors.textColors,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  contentPadding: new EdgeInsets.only(
                      left: 20.0, right: 20, top: 10, bottom: 0),
                  fillColor: AppColors.CommentItemBackground,
                  filled: true,
                  hintText: "Write a message...",
                  hintStyle: new TextStyle(
                      fontSize: 14.0,
                      fontFamily: AssetStrings.lotoRegularStyle,
                      color: AppColors.fontBlackColor),
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
//                      new InkWell(
//                        child: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: new Icon(
//                            Icons.image,
//                            size: 18,
//                            color: AppColors.kAppBlack,
//                          ),
//                        ),
//                        onTap: () {
//                          callBack(2); //for image
//                        },
//                      ),
                      new InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Icon(
                            Icons.send,
                            color: AppColors.kAppBlack,
                            size: 18,
                          ),
                        ),
                        onTap: () {
                          callBack(1); // for chat
                        },
                      ),
                      new SizedBox(
                        width: 11.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          /* new IconButton(
              icon: new Icon(Icons.image,size: 18),
              //onPressed: _imagePicker,
              color: AppColors.kAppBlack,

            ),*/
        ],
      ),
    );
  }
}

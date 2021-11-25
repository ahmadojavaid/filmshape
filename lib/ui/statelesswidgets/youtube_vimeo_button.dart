import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';

class YoutubeVimeoVideoWidget extends StatelessWidget {
  String _youtubeToken;
  String _vimeoToken;
  String _text;
  String _image;
  int _from;

  YoutubeVimeoVideoWidget(this._youtubeToken, this._vimeoToken, this._text,
      this._image, this._from);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: (_from == 1 && _youtubeToken != null)
                ? Colors.red.withOpacity(0.6)
                : (_from == 2 && _vimeoToken != null)
                ? Colors.blue.withOpacity(0.6)
                : Colors.grey.withOpacity(0.6),
            width: INPUT_BOX_BORDER_WIDTH),
      ),
      padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            _image,
            width: 20.0,
            height: 20.0,
            color: (_from == 1 && _youtubeToken != null)
                ? Colors.red.withOpacity(0.6)
                : (_from == 2 && _vimeoToken != null)
                ? Colors.blue.withOpacity(0.6)
                : Colors.black.withOpacity(0.6),
          ),
          new SizedBox(
            width: 12.0,
          ),
          new Text(
            _text,
            style: AppCustomTheme.createAccountLink,
          ),
        ],
      ),
    );
  }
}

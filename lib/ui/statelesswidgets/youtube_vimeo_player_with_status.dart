import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/videoplayer/youtube_vimeo_web_player.dart';

class YoutubeVimeoPlayerWithState extends StatefulWidget
{
  final String _mediaUrl;

  YoutubeVimeoPlayerWithState(this._mediaUrl);

  @override
  _YoutubeVimeoPlayerWithStateState createState() => _YoutubeVimeoPlayerWithStateState();
}

class _YoutubeVimeoPlayerWithStateState extends State<YoutubeVimeoPlayerWithState>
    with AutomaticKeepAliveClientMixin<YoutubeVimeoPlayerWithState>
{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenSize(context: context).height /
          3.2,
      width: getScreenSize(context: context).width,
      child: (widget._mediaUrl != null &&
          widget._mediaUrl.length > 0)
          ? YoutubeViemoVideoPlayer(
          widget._mediaUrl ?? "", null)
          : Container(),
      decoration: new BoxDecoration(
        color: Colors.black.withOpacity(0.8),
      )
      ,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

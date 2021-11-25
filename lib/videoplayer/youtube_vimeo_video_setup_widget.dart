import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/videoplayer/youtube_video.dart';
import 'package:Filmshape/videoplayer/youtube_vimeo_web_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Homepage
class YoutubeVimeoVideoPlayerSetuWizard extends StatefulWidget {
  final String videoUrl;

  YoutubeVimeoVideoPlayerSetuWizard(this.videoUrl,{Key key}):super(key:key);

  @override
  YoutubeVimeoVideoPlayerSetuWizardState createState() => YoutubeVimeoVideoPlayerSetuWizardState();
}

class YoutubeVimeoVideoPlayerSetuWizardState extends State<YoutubeVimeoVideoPlayerSetuWizard>
    with AutomaticKeepAliveClientMixin<YoutubeVimeoVideoPlayerSetuWizard>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<AppYoutubePlayerState> _youtubePlayerKey = GlobalKey();

  bool _isVimeo = true;
  String videoId="";



  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.videoUrl != null && widget.videoUrl.contains("youtube")) {
      videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      _isVimeo = false;
    }
    print("video_url ${widget.videoUrl}, $videoId");

    return Scaffold(
      key: _scaffoldKey,
      body:
      Container(
        child: (widget.videoUrl != null &&
            widget.videoUrl.length > 0)
            ? (_isVimeo) ? YoutubeViemoVideoPlayer(
            widget.videoUrl ?? "", null) : AppYoutubePlayer(videoId,key: _youtubePlayerKey,)
            : Container(),
        decoration: new BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        )
        ,
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

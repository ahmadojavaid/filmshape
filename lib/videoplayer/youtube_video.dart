import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Homepage
class AppYoutubePlayer extends StatefulWidget {
  final String videoId;
  AppYoutubePlayer(this.videoId,{Key key}):super(key:key);
  @override
  AppYoutubePlayerState createState() => AppYoutubePlayerState();
}

class AppYoutubePlayerState extends State<AppYoutubePlayer>
    with AutomaticKeepAliveClientMixin<AppYoutubePlayer>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

//  final List<String> _ids = [
//    'nPt8bK2gbaU',
//    'qiYKD1FZ5YM',
//    'gQDByCdjUXw',
//    'iLnmTe5Q2Qw',
//    '_WoCV4c6XOE',
//    'KmzdUe0RSJo',
//    '6jZDSSZZxjQ',
//    'p2lYr3vM_1w',
//    '7QUtEmBT_-w',
//    '34_PXCzGw1M',
//  ];

  @override
  void initState() {
    super.initState();
    print("video id ${widget.videoId}");
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;


  }

  void listener() {
    print("player status $_isPlayerReady");
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: YoutubePlayer(
        controller: _controller,
        liveUIColor: Colors.amber,
      ),
    );
  }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

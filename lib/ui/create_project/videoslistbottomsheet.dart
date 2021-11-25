import 'package:Filmshape/Model/create_project/youtube_vimeo_video_model.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_videos_list_response.dart';
import 'package:Filmshape/Model/youtube/channel_model.dart';
import 'package:Filmshape/Model/youtube/video_model.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideosListBottomViewDemo extends StatefulWidget {
  final int type; //from youtube or vimeo
  final Channel channel;
  final VimeoVideosListResponse vimeoVideosListResponse;

  VideosListBottomViewDemo(
      this.type, this.channel, this.vimeoVideosListResponse);

  @override
  _BottomViewDemoState createState() => _BottomViewDemoState();
}

class _BottomViewDemoState extends State<VideosListBottomViewDemo> {

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("bottom view called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                InkWell(
                  onTap: () {
                    Navigator.pop(context,"Back");
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                      ),
                      SizedBox(width: 5,),
                      new Text(
                        "Back",
                        style: new TextStyle(color: Colors.black,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                new SizedBox(
                  width: 55.0,
                ),
                new Image.asset(
                  (widget.type == 1)
                      ? AssetStrings.imageYoutube
                      : AssetStrings.imageVimeo,
                  width: 16.0,
                  height: 16.0,
                  color: (widget.type == 1) ? Colors.red : Colors.blue,
                ),
                new SizedBox(
                  width: 10.0,
                ),
                new Text(
                  (widget.type == 1) ? "YouTube" : "Vimeo",
                  style: new TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Expanded(
                  child: new SizedBox(
                    width: 20.0,
                  ),
                ),
//                InkWell(
//                  onTap: () {
//                    showInSnackBar(widget.channel.title);
//                  },
//                  child: new Icon(
//                    Icons.account_circle,
//                    color: Colors.black,
//                    size: 22.0,
//                  ),
//                )
              ],
            ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
            alignment: Alignment.center,
            child: new Text(
              "Select a video for your project",
              style: new TextStyle(color: Colors.black, fontSize: 17.0),
            ),
          ),

//from=1 youtube and from=2 vimeo
          (widget.type == 1)
              ? buildYouTubeContestList()
              : buildVimeoContestList()
        ],
      ),
    ));
  }

  buildYouTubeContestList() {
    return widget.channel != null
        ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
//        if (!_isLoading &&
//            _channel.videos.length != int.parse(_channel.videoCount) &&
//            scrollDetails.metrics.pixels ==
//                scrollDetails.metrics.maxScrollExtent) {
//          _loadMoreVideos();
//        }
              return false;
            },
            child: Expanded(
              child: Container(
                margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),
                child: ListView.builder(
                  itemCount: widget.channel.videos.length,
                  padding: new EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int index) {
                    Video video = widget.channel.videos[index];
                    return buildVideoItem(
                        video.id, video.thumbnailUrl, video.title, 1);
                  },
                ),
              ),
            ),
          )
        : new Container();
  }

  buildVimeoContestList() {
    return widget.vimeoVideosListResponse != null
        ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
//        if (!_isLoading &&
//            _vimeoVideosListResponse.data.length !=
//                _vimeoVideosListResponse.total &&
//            scrollDetails.metrics.pixels ==
//                scrollDetails.metrics.maxScrollExtent) {
//          //_loadMoreVideos();
//        }
              return false;
            },
            child: Expanded(
              child: Container(
                margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),
                child: ListView.builder(
                  itemCount: widget.vimeoVideosListResponse.data.length,
                  padding: new EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int index) {
                    Data video = widget.vimeoVideosListResponse.data[index];
                    var thumbNail = (video.pictures.sizes.length > 3)
                        ? video.pictures.sizes[3].link
                        : video.pictures.sizes[0].link;
                    return buildVideoItem(video.link, thumbNail, video.name, 2);
                  },
                ),
              ),
            ),
          )
        : new Container();
  }

  Widget buildVideoItem(
      String videoUrl, String thumbUrl, String title, int from) {
    return InkWell(
      onTap: () {
        var finalVideoUrl = (from == 1)
            ? "https://www.youtube.com/watch?v=$videoUrl"
            : videoUrl;

        print("thumb url $thumbUrl");
        var response = YoutubeVimeoVideoModel(
            videoUrl: finalVideoUrl, thumbNail: thumbUrl);

        Navigator.pop(context, response);
      },
      child: Container(
        margin: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        height: 110.0,
        child: Card(
          elevation: 2.0,
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(4.0),
                      child: getCachedNetworkImage(
                          url: thumbUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.only(
                            top: 20.0, left: 15.0, right: 5.0),
                        child: new Text(
                          title,
                          style: AppCustomTheme.videoItemTitleStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.only(
                            top: 8.0, left: 15.0, right: 5.0),
                        child: new Text(
                          "My Show",
                          style: AppCustomTheme.suggestedFriendMyReelStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

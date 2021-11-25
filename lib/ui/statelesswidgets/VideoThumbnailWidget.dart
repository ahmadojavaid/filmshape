import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaThumbnailWidget extends StatefulWidget {
  final String mediaUrl;

  MediaThumbnailWidget({@required this.mediaUrl});
  @override
  _MediaThumbnailWidgetState createState() => _MediaThumbnailWidgetState();
}
class _MediaThumbnailWidgetState extends State<MediaThumbnailWidget> {
  String videoThumbNail;
  CreateProfileProvider provider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      getThumnail(widget.mediaUrl);
    });

  }
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileProvider>(context);
    return Container(
        height: 200,
        decoration: (videoThumbNail == null) ? new BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        ) : new BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            image: new DecorationImage(image: new NetworkImage(
                videoThumbNail),
                fit: BoxFit.cover)));
  }

  void getThumnail(String mediaUrl) async
  {
    print("media url $mediaUrl");
    if(mediaUrl!=null)
      {
        videoThumbNail=await getVideoID(mediaUrl);
        print("final url $videoThumbNail");
            setState(() {

            });


      }
  }

  Future<String> getVideoID(String url) async {
    if(url.contains("youtube")) {
      url = url.replaceAll("https://www.youtube.com/watch?v=", "");
      url = url.replaceAll("https://m.youtube.com/watch?v=", "");
      url=url.replaceAll("https://youtube.com/embed/", "");
      print("videoid $url");
      return "https://img.youtube.com/vi/$url/0.jpg";
    }
    else{
      url = url.replaceAll("https://vimeo.com/", "");
     // var response=await provider.getVimeoImages("http://vimeo.com/api/v2/video/198340486.json", context);
     return "https://i.vimeocdn.com/video/$url.jpg";
    }
  }

}
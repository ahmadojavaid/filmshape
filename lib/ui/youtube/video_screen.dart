//import 'package:flutter/material.dart';
//
//class VideoScreen extends StatefulWidget {
//  final String id;
//
//  VideoScreen({this.id});
//
//  @override
//  _VideoScreenState createState() => _VideoScreenState();
//}
//
//class _VideoScreenState extends State<VideoScreen> {
//  YoutubePlayerController _controller;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = YoutubePlayerController(
//      initialVideoId: widget.id,
//      flags: YoutubePlayerFlags(
//        mute: false,
//        autoPlay: true,
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        body: YoutubePlayer(
//          controller: _controller,
//          showVideoProgressIndicator: false,
//          onReady: () {
//            print('Player is ready.');
//          },
//        ),
//      ),
//    );
//  }
//}

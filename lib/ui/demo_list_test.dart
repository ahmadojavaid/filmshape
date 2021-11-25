import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final Set<int> _indexes = SplayTreeSet();
  final ScrollController _scrollController = ScrollController();
  var previousLastVisibleIndex = "0";
  var firstTime = true;
  var notSameCallOnce=true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _doStuff());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      controller: _scrollController,
      cacheExtent: 0, // some kind of brown colored magic is here
      itemBuilder: (context, index) => VisibilityDetector(
          key: Key("$index"),
          onVisibilityChanged: (VisibilityInfo info) {
           // print(" ${info.visibleFraction} of my widget is visible ${info.key.toString()}");


            Future.delayed(const Duration(milliseconds: 2000), () {
              print("pre $previousLastVisibleIndex");

              if (previousLastVisibleIndex != info.key.toString()&&notSameCallOnce) {
                notSameCallOnce=false;
                previousLastVisibleIndex = info.key.toString();
                if (!firstTime) {
                  print("its not same");
                } else {
                  firstTime = false;
                }
              }
              else
                {
                  notSameCallOnce=true;
                }
              print("post $previousLastVisibleIndex");

            });
          },
          child: YourListItem(index: index, indexes: _indexes)),
    );
  }

  void _doStuff() async {
    //print('$_indexes');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class YourListItem extends StatefulWidget {
  final int index;
  final Set<int> indexes;

  YourListItem({@required this.index, @required this.indexes});

  @override
  _YourListItemState createState() => _YourListItemState();
}

class _YourListItemState extends State<YourListItem> {
  @override
  Widget build(BuildContext context) {
    // here is build your list item
    return Container(
      height: (widget.index % 2 == 0) ? 1100 : 500,
      padding: const EdgeInsets.all(8),
      color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(0.5),
      child: Center(child: Text('item ${widget.index}')),
    );
  }

  @override
  void deactivate() {
    widget.indexes.add(widget.index);
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    widget.indexes.remove(widget.index);
    super.didChangeDependencies();
  }
}

import 'package:Filmshape/Utils/AppColors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/src/tweens/delay_tween.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({
    Key key,
   this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
    this.controller,
  })  :
        assert(size != null),
        super(key: key);



  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _SpinKitThreeBounceState createState() => _SpinKitThreeBounceState();
}

class _SpinKitThreeBounceState extends State<AppLoader> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final List<Color> colors = <Color>[AppColors.color1, AppColors.color2,AppColors.color3,AppColors.color4,];
  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 4, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: ScaleTransition(
                scale: DelayTween(begin: 0.0, end: 1.0, delay: i *.1).animate(_controller),
                child: SizedBox.fromSize(size: Size.square(widget.size * 0.5), child: _itemBuilder(i)),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: colors[index], shape: BoxShape.circle));
}

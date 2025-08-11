import 'package:flutter/material.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/layout/views.dart';

class AnimationWidget extends StatefulWidget {
  final Widget? child;
  final bool isScale;
  final bool isOpacity;
  final Axis axis;
  final int? time;
  final double value;
  final Curve curve;
  final Curve scaleCurve;
  final Curve offsetCurve;
  final int? delayed;
  final bool isOpen;

  const AnimationWidget({
    Key? key,
    this.child,
    this.isScale = false,
    this.axis = Axis.horizontal,
    this.time,
    this.value = 100,
    this.curve = Curves.easeOutCubic,
    this.delayed,
    this.isOpacity = true,
    this.scaleCurve = Curves.easeOutCubic,
    this.offsetCurve = Curves.easeOutCubic,
    this.isOpen = false,
  }) : super(key: key);
  @override
  _AnimationWidgetState createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  ///是否延迟
  bool flag = false;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  Future initData() async {
    if (widget.delayed != null) {
      await Future.delayed(Duration(milliseconds: widget.delayed!));
      if (mounted) Future(() => setState(() => flag = true));
    }
  }

  @override
  Widget build(BuildContext context) {
    var view;
    if (isCanRunAnimation || widget.isOpen) {
      switch (widget.axis) {
        case Axis.vertical:
          view = TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: Offset(0, widget.value ?? size(context).width),
              end: Offset(0, 0),
            ),
            duration: Duration(milliseconds: widget.time ?? 400),
            curve: widget.curve,
            child: widget.child,
            builder: (_, t, v) {
              return Transform.scale(
                scale: widget.isScale ? 1 - (t.dy / widget.value ?? size(context).width) : 1,
                child: Transform.translate(offset: t, child: v),
              );
            },
          );
          break;
        case Axis.horizontal:
          view = TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: Offset(widget.value ?? size(context).width, 0),
              end: Offset(0, 0),
            ),
            duration: Duration(milliseconds: widget.time ?? 400),
            curve: widget.curve,
            child: widget.child,
            builder: (_, t, v) {
              return Transform.scale(
                scale: widget.isScale ? 1 - (t.dx / widget.value ?? size(context).width) : 1,
                child: Transform.translate(offset: t, child: v),
              );
            },
          );
          break;
      }
      if (widget.delayed == null) {
        return TweenAnimationBuilder(
          child: view,
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.ease,
          duration: Duration(milliseconds: widget.time ?? 500),
          builder: (_, t, v) {
            return Opacity(opacity: t, child: v);
          },
        );
      } else {
        if (flag) {
          if (widget.isOpacity) {
            return TweenAnimationBuilder(
              child: view,
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.ease,
              duration: Duration(milliseconds: widget.time ?? 500),
              builder: (_, t, v) {
                return Opacity(opacity: t, child: v);
              },
            );
          } else {
            return view;
          }
        } else {
          return Opacity(opacity: 0, child: widget.child);
        }
      }
    } else {
      return widget.child!;
    }
  }
}

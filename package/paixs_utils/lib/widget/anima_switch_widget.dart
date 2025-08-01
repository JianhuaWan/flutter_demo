import 'package:flutter/material.dart';
import '../model/data_model.dart';
import 'animated_switcher_widget.dart';
import 'shimmer_widget.dart';
import 'views.dart';

class AnimatedSwitchBuilder<T> extends StatefulWidget {
  const AnimatedSwitchBuilder({
    Key? key,
    required this.value,
    this.initialState,
    this.builder,
    this.animationTime = 250,
    this.alignment = Alignment.center,
    this.isExd = false,
    required this.errorOnTap,
    this.noDataText = '暂无数据',
    this.noDataView,
    this.errorView,
    this.isCancelOtherState = false,
    this.objectBuilder,
    this.valueBuilder,
    this.valueAndObjBuilder,
    this.listBuilder,
    this.defaultBuilder,
    this.initViewIsCenter = false,
    this.isAnimatedSize = false,
  }) : super(key: key);

  /// 数据对象：用来判断组件显示的状态和异常的信息
  final DataModel<T> value;

  ///过度动画时间：毫秒，如：1000=1秒
  final int animationTime;

  ///初始化状态
  final Widget? initialState;

  /**
   * [四个builder]
   */

  ///包含所有的成功状态
  final Widget Function(List<dynamic>, T, List<T>, int, bool)? builder;

  ///对象成功状态
  final Widget Function(T)? objectBuilder;

  ///value成功状态
  final Widget Function(List<dynamic>)? valueBuilder;

  ///对象的成功状态
  final Widget Function(List<dynamic>, T)? valueAndObjBuilder;

  ///列表成功状态
  final Widget Function(List<T>, int, bool)? listBuilder;

  final Widget Function()? defaultBuilder;

  ///对齐方式
  final AlignmentGeometry alignment;

  ///是否最大化
  final bool isExd;

  ///异常的点击事件
  final void Function() errorOnTap;

  ///没有数据的提示文字
  final String noDataText;

  final Widget? noDataView;
  final Widget? errorView;

  ///是否取消其他状态
  final bool isCancelOtherState;

  final bool initViewIsCenter;

  final bool isAnimatedSize;

  @override
  _AnimatedSwitchBuilderState<T> createState() => _AnimatedSwitchBuilderState<T>();
}

class _AnimatedSwitchBuilderState<T> extends State<AnimatedSwitchBuilder<T>> with TickerProviderStateMixin {
  var view;
  @override
  Widget build(BuildContext context) {
    // Future(() {
    // if ([-1, -2].contains(widget.value.flag)) showToast(widget.value.msg);
    // });
    switch (widget.value.flag) {
      case 0:
        view = widget.initialState ?? buildLoad(isCenter: widget.initViewIsCenter);
        break;
      case 1:
        if (widget.isCancelOtherState) {
          if (widget.defaultBuilder != null) {
            view = widget.defaultBuilder!();
          } else if (widget.valueBuilder != null) {
            view = widget.valueBuilder!(widget.value.value);
          } else if (widget.objectBuilder != null) {
            view = widget.objectBuilder!(widget.value.object!);
          } else if (widget.valueAndObjBuilder != null) {
            view = widget.valueAndObjBuilder!(widget.value.value, widget.value.object!);
          } else if (widget.listBuilder != null) {
            view = widget.listBuilder!(widget.value.list, widget.value.page!, widget.value.hasNext!);
          } else {
            view = widget.builder!(widget.value.value, widget.value.object!, widget.value.list, widget.value.page!, widget.value.hasNext!);
          }
        } else {
          view = widget.errorView ??
              ShimmerWidget(
                text: widget.value.msg,
                key: ValueKey(1),
                color: Colors.transparent,
                callBack: () {
                  setState(() => widget.value.flag = 0);
                  widget.errorOnTap();
                },
              );
        }
        break;
      case 2:
        if (widget.isCancelOtherState) {
          if (widget.defaultBuilder != null) {
            view = widget.defaultBuilder!();
          } else if (widget.valueBuilder != null) {
            view = widget.valueBuilder!(widget.value.value);
          } else if (widget.objectBuilder != null) {
            view = widget.objectBuilder!(widget.value.object!);
          } else if (widget.valueAndObjBuilder != null) {
            view = widget.valueAndObjBuilder!(widget.value.value, widget.value.object!);
          } else if (widget.listBuilder != null) {
            view = widget.listBuilder!(widget.value.list, widget.value.page!, widget.value.hasNext!);
          } else {
            view = widget.builder!(widget.value.value, widget.value.object!, widget.value.list, widget.value.page!, widget.value.hasNext!);
          }
        } else {
          view = widget.noDataView ??
              ShimmerWidget(
                key: ValueKey(2),
                text: widget.noDataText,
                color: Colors.transparent,
              );
        }
        break;
      default:
        if (widget.defaultBuilder != null) {
          view = widget.defaultBuilder!();
        } else if (widget.valueBuilder != null) {
          view = widget.valueBuilder!(widget.value.value);
        } else if (widget.objectBuilder != null) {
          view = widget.objectBuilder!(widget.value.object!);
        } else if (widget.valueAndObjBuilder != null) {
          view = widget.valueAndObjBuilder!(widget.value.value, widget.value
              .object!);
        } else if (widget.listBuilder != null) {
          view = widget.listBuilder!(widget.value.list, widget.value.page!,
              widget.value.hasNext!);
        } else {
          view = widget.builder!(widget.value.value, widget.value.object!,
              widget.value.list, widget.value.page!, widget.value.hasNext!);
        }
        break;
    }
    if (widget.isExd) {
      return Expanded(
        child: AnimatedSwitcherWidget(
          alignment: widget.alignment,
          duration: Duration(milliseconds: widget.animationTime),
          child: widget.isAnimatedSize
              ? AnimatedSize(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  child: view,
                )
              : view,
        ),
      );
    } else {
      return AnimatedSwitcherWidget(
        alignment: widget.alignment,
        duration: Duration(milliseconds: widget.animationTime),
        child: widget.isAnimatedSize
            ? AnimatedSize(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                child: view,
              )
            : view,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/refresh/refresher_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class CustomScroll extends StatefulWidget {
  final List<Widget> headers;
  final Widget Function(int, dynamic)? itemModelBuilder;
  final int? itemCount;
  final DataModel? itemModel;
  final int? crossAxisCount;
  final int? expandedCount;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? cacheExtent;
  final Divider? divider;
  final EdgeInsetsGeometry? headPadding;
  final EdgeInsetsGeometry? itemPadding;
  final Widget? btmWidget;
  final bool? isGengduo;
  final bool? isShuaxin;
  final Widget? refFooter;
  final Widget? refHeader;
  final Future<int> Function(int)? onLoading;
  final Future<int> Function()? onRefresh;
  final Widget Function(double)? onTapWidget;
  final String? btmText;
  final ScrollController? controller;
  final Widget Function()? maskWidget;
  final double? maskHeight;
  final void Function(bool)? onScrollToList;
  const CustomScroll({
    Key? key,
    this.headers = const <Widget>[],
    this.itemModelBuilder,
    this.itemCount,
    this.itemModel,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.divider,
    this.headPadding,
    this.itemPadding,
    this.btmWidget,
    this.isGengduo,
    this.isShuaxin,
    this.refFooter,
    this.refHeader,
    this.onLoading,
    this.onRefresh,
    this.expandedCount,
    this.btmText,
    this.controller,
    this.onTapWidget,
    this.cacheExtent,
    this.maskWidget,
    this.onScrollToList,
    this.maskHeight,
  }) : super(key: key);
  @override
  _CustomScrollState createState() => _CustomScrollState();
}

class _CustomScrollState extends State<CustomScroll> {
  ///首页列表头key
  GlobalKey homeListViewHeadKey = GlobalKey();

  bool isShowMask = false;

  ScrollController con = ScrollController();

  ///底部条
  Widget get btmWidget {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 1,
            width: 56,
            color: Colors.black12,
          ),
          SizedBox(width: 8),
          MyText(widget.btmText ?? '我是有底线的', color: Colors.black26),
          SizedBox(width: 8),
          Container(
            height: 1,
            width: 56,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    (widget.controller ?? con).addListener(() {
      var s = homeListViewHeadKey.currentContext?.findRenderObject()?.parentData.toString();
      var firstMatch = RegExp('\\(.*?, (.*?)\\)').firstMatch(s!);
      var group = double.parse(firstMatch!.group(1)!);
      if (group <= (widget.maskHeight ?? 0.0)) {
        if (!isShowMask) {
          if (widget.onScrollToList == null) {
            setState(() {});
          } else {
            widget.onScrollToList!(true);
          }
        }
        isShowMask = true;
      } else {
        if (isShowMask) {
          if (widget.onScrollToList == null) {
            setState(() {});
          } else {
            widget.onScrollToList!(false);
          }
        }
        isShowMask = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefresherWidget(
          isShuaxin: widget.isShuaxin ?? true,
          isGengduo: widget.isGengduo ?? widget.itemModel?.hasNext,
          footer: widget.refFooter,
          header: widget.refHeader,
          onLoading: () => widget.onLoading!(widget.itemModel!.page!),
          onRefresh: widget.onRefresh,
          child: CustomScrollView(
            controller: widget.controller ?? con,
            physics: BouncingScrollPhysics(),
            cacheExtent: widget.cacheExtent,
            slivers: <Widget>[
              SliverPadding(
                padding: widget.headPadding ?? EdgeInsets.zero,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      // flog('=======$i');
                      return widget.headers[i];
                    },
                    childCount: widget.headers.length,
                  ),
                ),
              ),
              SliverPadding(
                key: homeListViewHeadKey,
                padding: widget.itemPadding ?? EdgeInsets.zero,
                sliver: SliverWaterfallFlow(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      // flog(i);
                      return widget.divider == null
                          ? widget.itemModelBuilder!(i, widget.itemModel?.list[i])
                          : widget.crossAxisCount != null
                              ? widget.itemModelBuilder!(i, widget.itemModel?.list[i])
                              : Column(
                                  children: [
                                    widget.itemModelBuilder!(i, widget.itemModel?.list[i]),
                                    if (i != widget.itemModel!.list.length -
                                        1) widget.divider!,
                                  ],
                                );
                    },
                    childCount: widget.itemModel!.list.length,
                  ),
                  gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.crossAxisCount ?? 1,
                    crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
                    mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
                  ),
                ),
              ),
              if (!widget.itemModel!.hasNext!)
                if (widget.itemModel!.list.length > (widget.expandedCount ??
                    10))
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        return i != 0 ? widget.btmWidget ?? btmWidget : SizedBox();
                      },
                      childCount: 2,
                    ),
                  ),
            ],
          ),
        ),
        if (widget.maskWidget != null)
          if (widget.onScrollToList == null) isShowMask ? widget.maskWidget!
            () : SizedBox() else widget.maskWidget!(),
      ],
    );
  }
}

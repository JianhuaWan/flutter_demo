import 'package:flutter/material.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/refresher_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MyCustomScroll extends StatefulWidget {
  final List<Widget> headers;
  final Widget Function(int, dynamic) itemModelBuilder;
  final int itemCount;
  final DataModel itemModel;
  final int crossAxisCount;
  final int expandedCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Divider divider;
  final EdgeInsetsGeometry headPadding;
  final EdgeInsetsGeometry itemPadding;
  final Widget btmWidget;
  final bool isGengduo;
  final bool isShuaxin;
  final Widget refFooter;
  final Widget refHeader;
  final Future<int> Function(int) onLoading;
  final Future<int> Function() onRefresh;
  final Widget Function(double) onTapWidget;
  final String btmText;
  final ScrollController controller;
  const MyCustomScroll({
    Key key,
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
  }) : super(key: key);
  @override
  _MyCustomScrollState createState() => _MyCustomScrollState();
}

class _MyCustomScrollState extends State<MyCustomScroll> {
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
  Widget build(BuildContext context) {
    return RefresherWidget(
      isShuaxin: widget.isShuaxin ?? true,
      isGengduo: widget.isGengduo ?? widget.itemModel.hasNext,
      footer: widget.refFooter,
      header: widget.refHeader,
      onLoading: () => widget.onLoading(widget.itemModel.page),
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        controller: widget.controller,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: widget.headPadding ?? EdgeInsets.zero,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  flog('=======$i');
                  return widget.headers[i];
                },
                childCount: widget.headers.length,
              ),
            ),
          ),
          SliverPadding(
            padding: widget.itemPadding ?? EdgeInsets.zero,
            sliver: SliverWaterfallFlow(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  flog(i);
                  return widget.divider == null
                      ? widget.itemModelBuilder(i, widget.itemModel.list[i])
                      : widget.crossAxisCount == null || widget.crossAxisCount != 1
                          ? widget.itemModelBuilder(i, widget.itemModel.list[i])
                          : Column(
                              children: [
                                widget.itemModelBuilder(i, widget.itemModel.list[i]),
                                if (i != widget.itemModel.list.length - 1) widget.divider,
                              ],
                            );
                },
                childCount: widget.itemModel.list.length,
              ),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount ?? 2,
                crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
                mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
              ),
            ),
          ),
          if (!widget.itemModel.hasNext)
            if (widget.itemModel.list.length > (widget.expandedCount ?? 10))
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    return i != 0 ? btmWidget : SizedBox();
                  },
                  childCount: 2,
                ),
              ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/refresher_widget.dart';
import 'package:paixs_utils/widget/views.dart';

///列表试图类型
enum ListViewType {
  Builder,
  BuilderExpanded,
  Separated,
  SeparatedExpanded,
}

class MyListView<T> extends StatefulWidget {
  ///列表属性
  final Function(int) item;
  final int itemCount;
  final ListViewType listViewType;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final Divider divider;
  final bool flag;
  final bool reverse;
  final ScrollController controller;
  final DataModel<T> value;
  final Widget Function(T) itemWidget;
  final int expCount;

  ///刷新属性
  final Widget header;
  final Widget footer;
  final bool isShuaxin;
  final bool isGengduo;
  final bool isOnlyMore;
  final Widget expView;
  final Future<int> Function() onLoading;
  final Future<int> Function() onRefresh;

  const MyListView({
    Key key,
    this.item,
    this.listViewType = ListViewType.Builder,
    this.itemCount,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.divider,
    this.flag = true,
    this.controller,
    this.header,
    this.footer,
    @required this.isShuaxin,
    this.isGengduo = false,
    this.onLoading,
    this.onRefresh,
    this.value,
    this.itemWidget,
    this.expCount = 3,
    this.isOnlyMore = false,
    this.expView,
    this.reverse=false,
  }) : super(key: key);
  @override
  _MyListViewState<T> createState() => _MyListViewState<T>();
}

class _MyListViewState<T> extends State<MyListView<T>> {
  ///列表map
  Map<ListViewType, Widget> listviews = {};

  ///底部条
  var container = Container(
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
        MyText('暂无更多', color: Colors.black26),
        SizedBox(width: 8),
        Container(
          height: 1,
          width: 56,
          color: Colors.black12,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    container = widget.expView ?? container;
    listviews = {
      ListViewType.Builder: buildListViewBuilder(),
      ListViewType.BuilderExpanded: buildListViewBuilderExpanded(),
      ListViewType.Separated: buildListViewSeparated(),
      ListViewType.SeparatedExpanded: buildListViewSeparatedExpanded(),
    };
    return NotificationListener<OverscrollIndicatorNotification>(
      child: listviews[widget.listViewType],
      onNotification: handleGlowNotification,
    );
  }

  ///默认列表
  Widget buildListViewBuilder() {
    if (widget.isShuaxin) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(),
        footer: widget.footer ?? buildCustomFooter(),
        child: ListView.builder(
          controller: widget.controller,
          shrinkWrap: widget.flag,
          physics: widget.physics,
          reverse: widget.reverse,
          padding: widget.padding,
          itemCount: widget.itemCount == null ? widget.value.list.length + 1 : widget.itemCount + 1,
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.itemCount >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.item(i);
              }
            } else {
              if (i == widget.value.list.length) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.value.list.length >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.itemWidget(widget.value.list[i]);
              }
            }
          },
        ),
      );
    } else if (widget.isOnlyMore) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(),
        footer: widget.footer ?? buildCustomFooter(),
        child: ListView.builder(
          controller: widget.controller,
          shrinkWrap: widget.flag,
          physics: widget.physics,
          padding: widget.padding,
          reverse: widget.reverse,
          itemCount: widget.itemCount == null ? widget.value.list.length + 1 : widget.itemCount + 1,
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.itemCount >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.item(i);
              }
            } else {
              if (i == widget.value.list.length) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.value.list.length >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.itemWidget(widget.value.list[i]);
              }
            }
          },
        ),
      );
    } else {
      return ListView.builder(
        controller: widget.controller,
        shrinkWrap: widget.flag,
        physics: widget.physics,
        padding: widget.padding,
        itemBuilder: (_, i) => widget.item(i),
        itemCount: widget.itemCount,
      );
    }
  }

  ///带有Expanded的默认列表
  Widget buildListViewBuilderExpanded() {
    return Expanded(
      child: widget.isShuaxin
          ? RefresherWidget(
              isShuaxin: widget.isShuaxin,
              isGengduo: widget.isGengduo,
              onRefresh: widget.onRefresh ?? () async => getTime(),
              onLoading: widget.onLoading ?? () async => getTime(),
              header: widget.header ?? buildClassicHeader(),
              footer: widget.footer ?? buildCustomFooter(),
              child: ListView.builder(
                controller: widget.controller,
                physics: widget.physics,
                padding: widget.padding,
                reverse: widget.reverse,
                itemCount: widget.itemCount == null ? widget.value.list.length + 1 : widget.itemCount + 1,
                itemBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    if (i == widget.itemCount) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.itemCount >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return widget.item(i);
                    }
                  } else {
                    if (i == widget.value.list.length) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.value.list.length >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return widget.itemWidget(widget.value.list[i]);
                    }
                  }
                },
              ),
            )
          : ListView.builder(
              controller: widget.controller,
              physics: widget.physics,
              padding: widget.padding,
              reverse: widget.reverse,
              itemBuilder: (_, i) => widget.item(i),
              itemCount: widget.itemCount,
            ),
    );
  }

  ///带分割线的列表
  Widget buildListViewSeparated() {
    if (widget.isShuaxin) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(),
        footer: widget.footer ?? buildCustomFooter(),
        child: ListView.separated(
          shrinkWrap: widget.flag,
          padding: widget.padding,
          controller: widget.controller,
          physics: widget.physics,
          reverse: widget.reverse,
          itemCount: widget.itemCount == null ? widget.value.list.length + 1 : widget.itemCount + 1,
          separatorBuilder: (_, i) {
            if (widget.itemCount != null) {
              return i == widget.itemCount - 1 ? SizedBox() : widget.divider ?? divider;
            } else {
              return i == widget.value.list.length - 1 ? SizedBox() : widget.divider ?? divider;
            }
          },
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.itemCount >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.item(i);
              }
            } else {
              if (i == widget.value.list.length) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.value.list.length >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.itemWidget(widget.value.list[i]);
              }
            }
          },
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: widget.flag,
        padding: widget.padding,
        controller: widget.controller,
        physics: widget.physics,
        reverse: widget.reverse,
        itemBuilder: (_, i) => widget.item(i),
        separatorBuilder: (_, i) => widget.divider ?? divider,
        itemCount: widget.itemCount,
      );
    }
  }

  ///带有Expanded的分割线列表
  Widget buildListViewSeparatedExpanded() {
    return Expanded(
      child: widget.isShuaxin
          ? RefresherWidget(
              isShuaxin: widget.isShuaxin,
              isGengduo: widget.isGengduo,
              onRefresh: widget.onRefresh ?? () async => getTime(),
              onLoading: widget.onLoading ?? () async => getTime(),
              header: widget.header ?? buildClassicHeader(),
              footer: widget.footer ?? buildCustomFooter(),
              child: ListView.separated(
                controller: widget.controller,
                padding: widget.padding,
                physics: widget.physics,
                reverse: widget.reverse,
                itemCount: widget.itemCount == null ? widget.value.list.length + 1 : widget.itemCount + 1,
                separatorBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    return i == widget.itemCount - 1 ? SizedBox() : widget.divider ?? divider;
                  } else {
                    return i == widget.value.list.length - 1 ? SizedBox() : widget.divider ?? divider;
                  }
                },
                itemBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    if (i == widget.itemCount) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.itemCount >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return widget.item(i);
                    }
                  } else {
                    if (i == widget.value.list.length) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.value.list.length >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return widget.itemWidget(widget.value.list[i]);
                    }
                  }
                },
              ),
            )
          : ListView.separated(
              controller: widget.controller,
              padding: widget.padding,
              physics: widget.physics,
              reverse: widget.reverse,
              itemBuilder: (_, i) => widget.item(i),
              separatorBuilder: (_, i) => widget.divider ?? divider,
              itemCount: widget.itemCount,
            ),
    );
  }
}

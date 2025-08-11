import 'package:flutter/material.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/layout/views.dart';

class TabLinkWidget extends StatefulWidget {
  final List<String>? headers;
  final List<Widget>? listBar;
  final Widget Function(int, dynamic)? headerBar;
  final double? cacheExtent;
  final bool? isScrollable;
  final bool? isBottom;
  final EdgeInsetsGeometry? listPadding;
  final EdgeInsetsGeometry? indicatorPadding;
  final EdgeInsetsGeometry? labelPadding;
  final double? tabBarTop;
  final double? dividerHeight;
  final bool isShadow;
  final ScrollController? con;

  const TabLinkWidget({
    Key? key,
    this.headers,
    this.listBar,
    this.headerBar,
    this.cacheExtent,
    this.isScrollable,
    this.isBottom = false,
    this.listPadding,
    this.indicatorPadding,
    this.labelPadding,
    this.tabBarTop,
    this.dividerHeight,
    this.isShadow = false,
    this.con,
  }) : super(key: key);

  @override
  _TabLinkWidgetState createState() => _TabLinkWidgetState();
}

class _TabLinkWidgetState extends State<TabLinkWidget>
    with TickerProviderStateMixin {
  TabController? tabCon;
  ScrollController con = ScrollController();
  List<Widget> children = [];
  List<GlobalKey<State<StatefulWidget>>>? keyList1;
  List<GlobalKey<State<StatefulWidget>>>? keyList2;
  List<double> keyHeight = [];
  bool flag = true;

  bool isNoShowTabBar = false;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    con = widget.con ?? ScrollController();
    if (widget.tabBarTop != null) isNoShowTabBar = true;
    tabCon = TabController(length: widget.headers!.length, vsync: this);
    keyList1 = widget.headers?.map((_) => GlobalKey()).toList();
    keyList2 = widget.headers?.map((_) => GlobalKey()).toList();
    Future(() {
      List.generate(
          widget.headers!.length,
          (i) => keyHeight.add(
              (keyList1![i].currentContext?.size?.height ?? 0) +
                  (keyList2![i].currentContext?.size?.height ?? 0)));
      keyHeight = List.generate(
          keyHeight.length,
          (i) =>
              keyHeight[i] + keyHeight.sublist(0, i).fold(0, (p, e) => p + e));
    });
    List.generate(widget.headers!.length, (i) {
      if (widget.headerBar != null) {
        children.add(
          Container(
            key: keyList2![i],
            child: widget.headerBar!(i, widget.headers![i]),
          ),
        );
      } else {
        children.add(
          Container(
            key: keyList2![i],
            child: container(i),
          ),
        );
      }
      if (widget.listBar != null) {
        children.add(
          Container(
            key: keyList1![i],
            child: widget.listBar![i],
          ),
        );
      } else {
        children.add(
          Container(
            key: keyList1![i],
            height: 256,
            color: Colors.red,
          ),
        );
      }
    });
    setState(() {});
    con.addListener(() {
      if (widget.tabBarTop != null) {
        if (con.offset +
                widget.tabBarTop! -
                widget.dividerHeight! * 2 -
                padd(context).top +
                2 >
            keyHeight.first) {
          if (isNoShowTabBar != false)
            setState(() {
              isNoShowTabBar = false;
            });
        } else {
          if (isNoShowTabBar != true) {
            setState(() {
              isNoShowTabBar = true;
            });
          }
        }
      }
      if (flag) {
        int indexWhere;
        if (widget.isBottom!) {
          if (widget.tabBarTop == null) {
            indexWhere = keyHeight.lastIndexWhere((w) =>
                    con.offset +
                        (size(context).height - 56 - 40) -
                        padd(context).top -
                        48 >=
                    w) +
                1;
          } else {
            indexWhere = keyHeight.lastIndexWhere((w) =>
                    con.offset +
                        (size(context).height -
                            56 -
                            40 -
                            widget.tabBarTop! * 2) >=
                    w) +
                1;
          }
        } else {
          if (widget.tabBarTop == null) {
            indexWhere = keyHeight.lastIndexWhere((w) => con.offset >= w) + 1;
          } else {
            indexWhere = keyHeight.lastIndexWhere((w) =>
                    con.offset +
                        widget.tabBarTop! -
                        widget.dividerHeight! * 2 +
                        2 >=
                    w) +
                1;
          }
        }
        if (indexWhere > widget.headers!.length - 1) {
          tabCon?.animateTo(widget.headers!.length - 1);
        } else {
          tabCon?.animateTo(indexWhere);
        }
      }
    });
  }

  Container container(int i) {
    return Container(
      height: 48,
      padding: EdgeInsets.only(left: 17),
      child: BigTitleWidget(title: widget.headers![i], isPadding: false),
    );
  }

  Future conAnimateTo(double v) async {
    flag = false;
    await con.animateTo(v,
        duration: Duration(milliseconds: 250), curve: Curves.ease);
    flag = true;
  }

  @override
  Widget build(BuildContext context) {
    children = [];
    keyHeight = [];
    Future(() {
      List.generate(
          widget.headers!.length,
          (i) => keyHeight.add(
              (keyList1?[i].currentContext?.size?.height ?? 0) +
                  (keyList2![i].currentContext?.size?.height ?? 0)));
      keyHeight = List.generate(
          keyHeight.length,
          (i) =>
              keyHeight[i] + keyHeight.sublist(0, i).fold(0, (p, e) => p + e));
    });
    List.generate(widget.headers!.length, (i) {
      if (widget.headerBar != null) {
        children.add(
          Container(
            key: keyList2![i],
            child: widget.headerBar!(i, widget.headers![i]),
          ),
        );
      } else {
        children.add(
          Container(
            key: keyList2![i],
            child: container(i),
          ),
        );
      }
      if (widget.listBar != null) {
        children.add(
          Container(
            key: keyList1![i],
            child: widget.listBar![i],
          ),
        );
      } else {
        children.add(
          Container(
            key: keyList1![i],
            height: 256,
            color: Colors.red,
          ),
        );
      }
    });
    return Stack(
      children: [
        ListView(
          cacheExtent: widget.cacheExtent ?? 99999,
          controller: con,
          padding: widget.listPadding ?? EdgeInsets.only(top: 40),
          children: children,
          physics: BouncingScrollPhysics(),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: !isNoShowTabBar ? 500 : 1000),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          top: !isNoShowTabBar ? widget.tabBarTop ?? 0.0 : -56,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: widget.isShadow
                  ? [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black12,
                      ),
                    ]
                  : [],
              // border: Border(
              //   bottom: BorderSide(
              //     color: Colors.black12,
              //   ),
              // ),
            ),
            alignment: Alignment.centerLeft,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              controller: tabCon,
              isScrollable: widget.isScrollable ?? true,
              onTap: (i) {
                if (i == 0) {
                  conAnimateTo(0);
                } else if (i == widget.headers!.length - 1) {
                  conAnimateTo(con.position.maxScrollExtent);
                } else {
                  if (widget.isBottom!) {
                    if (widget.tabBarTop == null) {
                      conAnimateTo(keyHeight[i - 1] -
                          (size(context).height - 56 - 40) +
                          48 +
                          padd(context).top);
                    } else {
                      conAnimateTo(keyHeight[i - 1] -
                          ((size(context).height - 56 - 40)) +
                          48 -
                          widget.tabBarTop!);
                    }
                  } else {
                    if (widget.tabBarTop == null) {
                      conAnimateTo(keyHeight[i - 1]);
                    } else {
                      conAnimateTo(keyHeight[i - 1] -
                          widget.tabBarTop! +
                          widget.dividerHeight! * 2 +
                          padd(context).top -
                          1);
                    }
                  }
                }
              },
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Color(0xff666666),
              labelColor: Theme.of(context).primaryColor,
              indicatorPadding: widget.indicatorPadding ??
                  EdgeInsets.only(bottom: 10, left: 8, right: 8),
              labelPadding: widget.labelPadding ??
                  EdgeInsets.only(bottom: 10, left: 8, right: 8),
              // tabs: widget.headers.map((m) {
              //   return Tab(text: m);
              // }).toList(),
              tabs: List.generate(widget.headers!.length, (i) {
                return AnimationWidget(
                  delayed: 50 + 100 * i,
                  child: Tab(text: widget.headers![i]),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

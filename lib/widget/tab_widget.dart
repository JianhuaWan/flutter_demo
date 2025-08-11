import 'package:flutter/material.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:paixs_utils/widget/layout/custom_scroll_physics.dart';
import 'package:paixs_utils/widget/navigation/route.dart';

class TabWidget extends StatefulWidget {
  final List<String>? tabList;
  final List<Widget>? tabPage;
  final bool? isScrollable;
  final ScrollPhysics? pagePhysics;
  final bool? isShadow;
  final bool? isPadding;
  final bool? isNoShowTab;
  final TabController? tabCon;

  const TabWidget({Key? key, this.tabList, this.tabPage, this.isScrollable,
    this.pagePhysics, this.isShadow, this.isPadding, this.isNoShowTab = false, this.tabCon}) : super(key: key);
  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  TabController? tabCon;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = widget.tabCon ?? TabController(vsync: this, length: widget
        .tabList!.length);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: !widget.isNoShowTab! ? 40 : 0),
          child: TabBarView(
            physics: widget.pagePhysics ?? (!widget.isNoShowTab! ? PagePhysics
              () : NeverScrollableScrollPhysics()),
            controller: tabCon,
            children: widget.tabPage!,
          ),
        ),
        if (!widget.isNoShowTab!)
          Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: !(widget.isShadow ?? false)
                  ? []
                  : [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black12,
                        spreadRadius: -2,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            child: TabBar(
              controller: tabCon,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: widget.isScrollable ?? false,
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black45,
              indicatorPadding: EdgeInsets.only(bottom: widget.isPadding ?? true ? 4 : 0, left: 2, right: 2),
              labelColor: Theme.of(context).primaryColor,
              physics: BouncingScrollPhysics(),
              // // tabs: widget.tabList.map((m) {
              //   return
              // // }).toList(),
              tabs: List.generate(widget.tabList!.length, (i) {
                return AnimationWidget(
                  delayed: (RouteState.isFromDown ? 100 : 50) + 100 * i,
                  axis: RouteState.isFromDown ? Axis.vertical : Axis.horizontal,
                  child: Tab(text: widget.tabList![i]),
                );
              }),
            ),
          ),
      ],
    );
  }
}

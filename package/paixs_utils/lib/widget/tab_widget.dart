import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/custom_scroll_physics.dart';

class TabWidget extends StatefulWidget {
  final List<String> tabList;
  final List<Widget> tabPage;
  final bool isScrollable;
  final ScrollPhysics pagePhysics;

  const TabWidget({Key key, this.tabList, this.tabPage, this.isScrollable, this.pagePhysics}) : super(key: key);
  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  TabController tabCon;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = TabController(vsync: this, length: widget.tabList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: TabBarView(
            physics: widget.pagePhysics ?? PagePhysics(),
            controller: tabCon,
            children: widget.tabPage,
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
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
            isScrollable: widget.isScrollable ?? true,
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black45,
            labelColor: Theme.of(context).primaryColor,
            tabs: widget.tabList.map((m) {
              return Tab(text: m);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

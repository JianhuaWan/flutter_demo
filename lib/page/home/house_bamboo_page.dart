import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/house_page.dart';
import 'package:flutter_app/net/base_http.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class HouseBambooPage extends StatefulWidget {
  @override
  _HouseBambooPageState createState() => _HouseBambooPageState();
}

class _HouseBambooPageState extends State<HouseBambooPage> {
  var city;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getPageList(isRef: true);
  }

  ///楼盘列表
  var sunpanDm = DataModel(hasNext: false);
  Future<int> getPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetPageList',
      data: {"PageIndex": page, "isSunpan": true},
      isLoading: city != null,
      dialogText: '正在查找$city的笋盘...',
      catchError: (v) => sunpanDm.toError(v),
      success: (v) {
        sunpanDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return sunpanDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(
        context,
        title: '笋盘推荐',
        color: Colors.white,
        isShowBorder: true,
      ),
      body: AnimatedSwitchBuilder(
        value: sunpanDm,
        isAnimatedSize: true,
        errorOnTap: () => this.getPageList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            onRefresh: () => this.getPageList(isRef: true),
            onLoading: () => this.getPageList(page: p),
            item: (i) {
              return WidgetTap(
                onTap: () {
                  jumpPage(LoupanPage(data: list[i]));
                },
                child: AnimationWidget(
                  child: HouseItem(i: i, data: list[i]),
                ),
              );
            },
            itemCount: list.length,
            padding: EdgeInsets.symmetric(vertical: 16),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 27, color: Colors.transparent),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kqsc/page/home/loupan_page.dart';
import 'package:kqsc/provider/provider_config.dart';
import 'package:kqsc/util/http.dart';
import 'package:kqsc/widget/my_custom_scroll.dart';
import 'package:kqsc/widget/tween_widget.dart';
import 'package:kqsc/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class SunpanPage extends StatefulWidget {
  @override
  _SunpanPageState createState() => _SunpanPageState();
}

class _SunpanPageState extends State<SunpanPage> {
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
    return sunpanDm.flag;
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
                child: TweenWidget(
                  child: LoupanItem(i: i, data: list[i]),
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

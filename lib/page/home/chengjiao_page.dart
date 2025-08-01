import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/loupan_page.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class ChengjiaoPage extends StatefulWidget {
  @override
  _ChengjiaoPageState createState() => _ChengjiaoPageState();
}

class _ChengjiaoPageState extends State<ChengjiaoPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getHotList(isRef: true);
  }

  ///成交榜
  var renqibangDm = DataModel();
  Future<int> getHotList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/Hot',
      data: {"PageIndex": page},
      catchError: (v) => renqibangDm.toError(v),
      success: (v) => renqibangDm.addList(v['data'], isRef, v['total']),
    );
    setState(() {});
    return renqibangDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '成交榜', color: Colors.white),
      body: AnimatedSwitchBuilder(
        value: renqibangDm,
        errorOnTap: () => this.getHotList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            physics: BouncingScrollPhysics(),
            onRefresh: () => this.getHotList(isRef: true),
            onLoading: () => this.getHotList(page: p),
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

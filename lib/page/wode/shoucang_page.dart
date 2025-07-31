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

class ShoucangPage extends StatefulWidget {
  @override
  _ShoucangPageState createState() => _ShoucangPageState();
}

class _ShoucangPageState extends State<ShoucangPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiUserFavorite(isRef: true);
  }

  ///收藏
  var shoucangDm = DataModel(hasNext: false);
  Future<int> apiUserFavorite({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/User/Favorite',
      data: {"PageSize": "10", "PageIndex": page},
      catchError: (v) => shoucangDm.toError(v),
      success: (v) {
        shoucangDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return shoucangDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '我的收藏',
        color: Colors.white,
      ),
      body: AnimatedSwitchBuilder(
        value: shoucangDm,
        errorOnTap: () => this.apiUserFavorite(isRef: true),
        noDataText: '暂无收藏',
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            padding: EdgeInsets.symmetric(vertical: 10),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 10, color: Colors.transparent),
            onLoading: () => this.apiUserFavorite(page: p),
            onRefresh: () => this.apiUserFavorite(isRef: true),
            itemCount: list.length,
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
          );
        },
      ),
    );
  }
}

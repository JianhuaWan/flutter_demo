import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/house_page.dart';
import 'package:flutter_app/util/base_http.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
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
    return shoucangDm.flag!;
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
                child: AnimationWidget(
                  child: HouseItem(i: i, data: list[i]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

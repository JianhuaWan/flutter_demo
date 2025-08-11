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

class ClinchDealPage extends StatefulWidget {
  @override
  _ClinchDealPageState createState() => _ClinchDealPageState();
}

class _ClinchDealPageState extends State<ClinchDealPage> {
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
      catchError: (v) {
        // 当请求失败时，手动生成3条默认数据
        List<Map<String, dynamic>> defaultBuildings = [
          {
            'buildingName': '热门楼盘1',
            'images': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=热门1',
            'price': '待定',
            'areaName': '区域1'
          },
          {
            'buildingName': '热门楼盘2',
            'images': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=热门2',
            'price': '25000元/㎡',
            'areaName': '区域2'
          },
          {
            'buildingName': '热门楼盘3',
            'images': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=热门3',
            'price': '30000元/㎡',
            'areaName': '区域3'
          },
        ];
        renqibangDm.addList(defaultBuildings, isRef, defaultBuildings.length);
      },
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

import 'package:flutter/material.dart';
import 'package:flutter_app/net/base_http.dart';
import 'package:flutter_app/widget/text_edit_widget.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

import 'house_page.dart';

class SearchPage extends StatefulWidget {
  final Map? data;
  final bool isZhaofang;

  const SearchPage({
    Key? key,
    this.data,
    this.isZhaofang = false,
  }) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var name;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiBuildingGetPageList(isRef: true);
  }

  ///搜索楼盘
  var sousuoDm = DataModel(hasNext: false);
  Future<int> apiBuildingGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetPageList',
      data: {
        "PageIndex": page,
        if (widget.data != null) "City": widget.data!['city'] ?? '',
        if (widget.data != null) "Budget": widget.data!['shoufu'] ?? '',
        if (widget.data != null) "Layout": widget.data!['jushi'] ?? '',
        if (widget.data != null) "Area": widget.data!['mianji'] ?? '',
        if (widget.data != null) "TotalPrice": widget.data!['zongjia'] ?? '',
        if (widget.data != null) "Commission": widget.data!['fangwei'] ?? '',
        if (name != null) "Name": name,
      },
      catchError: (v) {
        // 当请求失败时，手动生成6条默认数据
        List<Map<String, dynamic>> defaultBuildings = [
          {
            'buildingName': '默认楼盘1',
            'images': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=楼盘1',
            'price': '待定',
            'areaName': '区域1'
          },
          {
            'buildingName': '默认楼盘2',
            'images': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=楼盘2',
            'price': '20000元/㎡',
            'areaName': '区域2'
          },
          {
            'buildingName': '默认楼盘3',
            'images': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=楼盘3',
            'price': '25000元/㎡',
            'areaName': '区域3'
          },
          {
            'buildingName': '默认楼盘4',
            'images': 'https://via.placeholder.com/400x300/96CEB4/FFFFFF?text=楼盘4',
            'price': '18000元/㎡',
            'areaName': '区域4'
          },
          {
            'buildingName': '默认楼盘5',
            'images': 'https://via.placeholder.com/400x300/FFEAA7/FFFFFF?text=楼盘5',
            'price': '22000元/㎡',
            'areaName': '区域5'
          },
          {
            'buildingName': '默认楼盘6',
            'images': 'https://via.placeholder.com/400x300/DDA0DD/FFFFFF?text=楼盘6',
            'price': '30000元/㎡',
            'areaName': '区域6'
          },
        ];
        sousuoDm.addList(defaultBuildings, isRef, defaultBuildings.length);
      },
      success: (v) {
        sousuoDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return sousuoDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(
        context,
        title: widget.data == null ? '楼盘搜索' : '帮我找房',
        color: Colors.white,
        isShowBorder: true,
      ),
      body: Column(
        children: [
          if (widget.data == null)
            Container(
              color: Colors.white,
              child: TextEditWidget(
                hint: '请输入关键词搜索',
                bgColor: Colors.black.withOpacity(0.05),
                onSubmitted: (v) {
                  name = v;
                  setState(() {
                    sousuoDm.flag = 0;
                  });
                  this.apiBuildingGetPageList(isRef: true);
                },
              ),
            ),
          AnimatedSwitchBuilder(
            value: sousuoDm,
            isExd: true,
            isAnimatedSize: true,
            errorOnTap: () => this.apiBuildingGetPageList(isRef: true),
            listBuilder: (list, p, h) {
              return MyListView(
                isShuaxin: true,
                isGengduo: h,
                padding: EdgeInsets.symmetric(vertical: 10),
                listViewType: ListViewType.Separated,
                divider: Divider(height: 27, color: Colors.transparent),
                onLoading: () => this.apiBuildingGetPageList(page: p),
                onRefresh: () => this.apiBuildingGetPageList(isRef: true),
                itemCount: list.length,
                item: (i) => WidgetTap(
                  onTap: () => jumpPage(LoupanPage(data: list[i], isZhaofang: widget.isZhaofang)),
                  child: AnimationWidget(child: HouseItem(i: i, data: list[i])),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

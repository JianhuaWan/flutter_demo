import 'package:flutter/material.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/media/image.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

import 'loupan_page.dart';

class WanquPage extends StatefulWidget {
  @override
  _WanquPageState createState() => _WanquPageState();
}

class _WanquPageState extends State<WanquPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiBuildingGetRecommend(isRef: true);
  }

  ///获取湾区推荐
  var wanquDm = DataModel(hasNext: false);
  Future<int> apiBuildingGetRecommend({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetRecommend',
      data: {
        "city": app.cityCode ?? "-1",
        "PageIndex": page,
      },
      catchError: (v) {
        // 当请求失败时，手动生成5条默认数据
        List<Map<String, dynamic>> defaultBuildings = [
          {
            'buildingName': '默认推荐楼盘1',
            'images': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=推荐1',
            'price': '待定',
            'areaName': '区域1'
          },
          {
            'buildingName': '默认推荐楼盘2',
            'images': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=推荐2',
            'price': '20000元/㎡',
            'areaName': '区域2'
          },
          {
            'buildingName': '默认推荐楼盘3',
            'images': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=推荐3',
            'price': '25000元/㎡',
            'areaName': '区域3'
          },
          {
            'buildingName': '默认推荐楼盘4',
            'images': 'https://via.placeholder.com/400x300/96CEB4/FFFFFF?text=推荐4',
            'price': '18000元/㎡',
            'areaName': '区域4'
          },
          {
            'buildingName': '默认推荐楼盘5',
            'images': 'https://via.placeholder.com/400x300/FFEAA7/FFFFFF?text=推荐5',
            'price': '22000元/㎡',
            'areaName': '区域5'
          },
        ];
        wanquDm.addList(defaultBuildings, isRef, defaultBuildings.length);
      },
      success: (v) {
        wanquDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return wanquDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '湾区推荐',
        color: Colors.white,
      ),
      body: AnimatedSwitchBuilder(
        value: wanquDm,
        errorOnTap: () => this.apiBuildingGetRecommend(isRef: true),
        isAnimatedSize: true,
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            padding: EdgeInsets.all(10),
            listViewType: ListViewType.Separated,
            physics: BouncingScrollPhysics(),
            divider: Divider(height: 10, color: Colors.transparent),
            onLoading: () => this.apiBuildingGetRecommend(page: p),
            onRefresh: () => this.apiBuildingGetRecommend(isRef: true),
            itemCount: list.length,
            item: (i) {
              return WidgetTap(
                isElastic: true,
                onTap: () {
                  jumpPage(LoupanPage(data: list[i]));
                },
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 209,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: WrapperImage(
                              url: list[i]['images'].toString().split(';').first,
                              height: 100,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/img/home_remen.png',
                                  width: 48,
                                  height: 24,
                                  color: Colors.red,
                                ),
                                MyText('No.${i + 1}', color: Colors.white),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 34,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 12),
                              child: MyText(
                                list[i]['buildingName'],
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0x00000000), Color(0xff202020)],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

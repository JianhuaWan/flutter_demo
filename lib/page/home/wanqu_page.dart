import 'package:flutter/material.dart';
import 'package:kqsc/provider/provider_config.dart';
import 'package:kqsc/util/http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

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
      catchError: (v) => wanquDm.toError(v),
      success: (v) {
        wanquDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return wanquDm.flag;
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

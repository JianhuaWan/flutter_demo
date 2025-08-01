import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/loupan_page.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/view/views.dart';
import 'package:flutter_app/widget/my_custom_scroll.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class PinpaiPage extends StatefulWidget {
  @override
  _PinpaiPageState createState() => _PinpaiPageState();
}

class _PinpaiPageState extends State<PinpaiPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getPageList(isRef: true);
  }

  ///品牌优选列表
  var pinpaiDm = DataModel();
  Future<int> getPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Brand/GetPageList',
      data: {"PageIndex": page},
      catchError: (v) => pinpaiDm.toError(v),
      success: (v) => pinpaiDm.addList(v['data'], isRef, v['total']),
    );
    setState(() {});
    return pinpaiDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '品牌甄选',
        color: Colors.white,
      ),
      body: MyCustomScroll(
        itemModel: pinpaiDm,
        headPadding: EdgeInsets.all(16),
        headers: [
          Container(
            height: 34,
            padding: EdgeInsets.symmetric(horizontal: 21),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(56),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 16,
                  color: Color(0xffB4B4B4),
                ),
                SizedBox(width: 8),
                buildTFView(
                  context,
                  hintText: '\t请输入关键词搜索',
                  hintSize: 13,
                  hintColor: Color(0xffB4B4B4),
                  isExp: true,
                ),
              ],
            ),
          ),
        ],
        itemPadding: EdgeInsets.symmetric(horizontal: 16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        crossAxisCount: 2,
        onRefresh: () async => this.getPageList(isRef: true),
        onLoading: (p) async => this.getPageList(page: p),
        itemModelBuilder: (i, v) {
          return WidgetTap(
            isElastic: true,
            onTap: () {
              jumpPage(LoupanList(data: v));
            },
            child: TweenWidget(
              value: 1,
              isScale: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 117,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        child: WrapperImage(
                          urlBuilder: () => v['preview'],
                          height: 101,
                        ),
                      ),
                      Container(
                        color: Colors.black54,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: MyText(
                          v['dictValue'],
                          size: 13,
                          isBold: true,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoupanList extends StatefulWidget {
  final Map? data;

  const LoupanList({Key? key, this.data}) : super(key: key);
  @override
  _LoupanListState createState() => _LoupanListState();
}

class _LoupanListState extends State<LoupanList> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getBuildingPageList(isRef: true);
  }

  ///品牌楼盘列表
  var pinpaiListDm = DataModel();
  Future<int> getBuildingPageList({int page = 1, bool isRef = false}) async {
    flog(widget.data);
    await Request.get(
      '/api/Brand/GetBuildingPageList',
      data: {"brandType": widget.data!['type'], "PageIndex": page},
      catchError: (v) => pinpaiListDm.toError(v),
      success: (v) => pinpaiListDm.addList(v['data'], isRef, v['total']),
    );
    setState(() {});
    return pinpaiListDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: widget.data!['dictValue'], color:
      Colors.white, isShowBorder: true),
      bgColor: Colors.white,
      body: AnimatedSwitchBuilder(
        value: pinpaiListDm,
        noDataText: '暂无楼盘',
        errorOnTap: () => this.getBuildingPageList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            onRefresh: () async => this.getBuildingPageList(isRef: true),
            onLoading: () async => this.getBuildingPageList(page: p),
            padding: EdgeInsets.symmetric(vertical: 8),
            item: (i) {
              return WidgetTap(
                onTap: () => jumpPage(LoupanPage(data: list[i])),
                child: TweenWidget(child: LoupanItem(i: i, data: list[i])),
              );
            },
            itemCount: list.length,
            listViewType: ListViewType.Separated,
            divider: Divider(height: 32, color: Colors.transparent),
          );
        },
      ),
    );
  }
}

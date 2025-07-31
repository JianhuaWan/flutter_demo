import 'package:flutter/material.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/no_sliding_return.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

class BangzhuPage extends StatefulWidget {
  @override
  _BangzhuPageState createState() => _BangzhuPageState();
}

class _BangzhuPageState extends State<BangzhuPage> with NoSlidingReturn {
  var kehuUiList = [
    {'key': '-1', 'value': '全部'},
    {'key': '2', 'value': '注册类'},
    {'key': '3', 'value': '收益类'},
    {'key': '6', 'value': '楼盘类'},
    {'key': '7', 'value': '购房类'},
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '帮助', color: Colors.white),
      body: TabWidget(
        isScrollable: true,
        isPadding: false,
        tabList: kehuUiList.map((m) => m['value']).toList(),
        tabPage: kehuUiList.map((m) {
          return BangzhuItem(m['key']);
        }).toList(),
      ),
    );
  }
}

class BangzhuItem extends StatefulWidget {
  final String mKey;

  const BangzhuItem(this.mKey, {Key key}) : super(key: key);
  @override
  _BangzhuItemState createState() => _BangzhuItemState();
}

class _BangzhuItemState extends State<BangzhuItem> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiInformationGetPageList(isRef: true);
  }

  ///获取帮助
  var bangzhuItemDm = DataModel(hasNext: false);
  Future<int> apiInformationGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Information/GetPageList',
      data: {"type": widget.mKey, "PageIndex": page},
      catchError: (v) => bangzhuItemDm.toError(v),
      success: (v) {
        bangzhuItemDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return bangzhuItemDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitchBuilder(
      value: bangzhuItemDm,
      errorOnTap: () => this.apiInformationGetPageList(isRef: true),
      isAnimatedSize: true,
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          listViewType: ListViewType.Separated,
          divider: Divider(height: 10, color: Colors.transparent),
          onLoading: () => this.apiInformationGetPageList(page: p),
          onRefresh: () => this.apiInformationGetPageList(isRef: true),
          itemCount: list.length,
          item: (i) {
            return Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Text("${i + 1}.${list[i]['title']}"),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        // Html(data: list[i]['content']),
                        // Divider(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     WidgetTap(
                        //       isElastic: true,
                        //       onTap: () async {
                        //         await Future.delayed(Duration(milliseconds: 500));
                        //         showToast('已解决');
                        //       },
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(horizontal: 33, vertical: 9),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(56),
                        //           color: Theme.of(context).primaryColor,
                        //         ),
                        //         child: MyText(
                        //           '已解决',
                        //           color: Colors.white,
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //     WidgetTap(
                        //       isElastic: true,
                        //       onTap: () async {
                        //         await Future.delayed(Duration(milliseconds: 500));
                        //         showToast('未解决');
                        //       },
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(horizontal: 33, vertical: 9),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(56),
                        //           color: Color(0xFFE8E8E8),
                        //         ),
                        //         child: MyText(
                        //           '未解决',
                        //           color: Color(0x80666666),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

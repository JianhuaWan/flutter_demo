import 'package:flutter/material.dart';
import 'package:kqsc/util/http.dart';
import 'package:kqsc/widget/text_edit_widget.dart';
import 'package:kqsc/widget/tween_widget.dart';
import 'package:kqsc/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

import 'loupan_page.dart';

class SousuoPage extends StatefulWidget {
  final Map data;
  final bool isZhaofang;

  const SousuoPage({
    Key key,
    this.data,
    this.isZhaofang = false,
  }) : super(key: key);
  @override
  _SousuoPageState createState() => _SousuoPageState();
}

class _SousuoPageState extends State<SousuoPage> {
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
        if (widget.data != null) "City": widget.data['city'] ?? '',
        if (widget.data != null) "Budget": widget.data['shoufu'] ?? '',
        if (widget.data != null) "Layout": widget.data['jushi'] ?? '',
        if (widget.data != null) "Area": widget.data['mianji'] ?? '',
        if (widget.data != null) "TotalPrice": widget.data['zongjia'] ?? '',
        if (widget.data != null) "Commission": widget.data['fangwei'] ?? '',
        if (name != null) "Name": name,
      },
      catchError: (v) => sousuoDm.toError(v),
      success: (v) {
        sousuoDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return sousuoDm.flag;
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
                  child: TweenWidget(child: LoupanItem(i: i, data: list[i])),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

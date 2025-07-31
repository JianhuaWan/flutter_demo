import 'package:flutter/material.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

class GuanyuPage extends StatefulWidget {
  @override
  _GuanyuPageState createState() => _GuanyuPageState();
}

class _GuanyuPageState extends State<GuanyuPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiProtocolGetProtocolType(isRef: true);
  }

  ///获取协议
  var xieyiDm = DataModel(hasNext: false);
  Future<int> apiProtocolGetProtocolType({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Protocol/GetProtocolType',
      data: {"type": "10"},
      catchError: (v) => xieyiDm.toError(v),
      success: (v) {
        xieyiDm.object = v['data'];
        xieyiDm.setTime();
      },
    );
    setState(() {});
    return xieyiDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(
        context,
        title: '关于',
        color: Colors.white,
        isShowBorder: true,
      ),
      body: AnimatedSwitchBuilder(
        value: xieyiDm,
        errorOnTap: () => this.apiProtocolGetProtocolType(),
        objectBuilder: (obj) {
          return MyListView(
            isShuaxin: false,
            flag: false,
            item: (i) => item[i],
            itemCount: item.length,
          );
        },
      ),
    );
  }

  List<Widget> get item {
    return [
      SizedBox(height: 30),
      TweenWidget(
        axis: Axis.vertical,
        delayed: 20,
        isScale: true,
        value: 200,
        child: Column(
          children: [
            Image.asset(
              'assets/img/logo.png',
              width: 70,
              height: 70,
            ),
            SizedBox(height: 11),
            MyText(
              'flutter_app',
              size: 16,
              isBold: true,
              textAlign: TextAlign.center,
              color: Color(0xff333333),
            ),
            SizedBox(height: 5),
            MyText(
              '版本V${app.packageInfo.version}',
              size: 13,
              textAlign: TextAlign.center,
              color: Color(0xff333333),
            ),
          ],
        ),
      ),
      TweenWidget(
        axis: Axis.vertical,
        delayed: 120,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 28, horizontal: 17),
          // child: Html(
          //   data: xieyiDm.object,
          //   // size: 14,
          //   // color: Color(0xff666666),
          //   // isOverflow: false,
          // ),
        ),
      ),
    ];
  }
}

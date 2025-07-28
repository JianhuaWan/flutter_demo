import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kqsc/page/wode/kehu_page.dart';
import 'package:kqsc/page/wode/setup_page.dart';
import 'package:kqsc/widget/tween_widget.dart';
import 'package:kqsc/widget/widgets.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class MyPage2 extends StatefulWidget {
  @override
  _MyPage2State createState() => _MyPage2State();
}

class _MyPage2State extends State<MyPage2> with AutomaticKeepAliveClientMixin {
  var kehuUiList = [
    [
      {'key': '0', 'value': '待审核'},
      {'key': '1', 'value': '待到访'},
      {'key': '2', 'value': '已到访'},
      {'key': '3', 'value': '已逾期'},
    ],
    [
      {'key': '0', 'value': '已认筹'},
      {'key': '1', 'value': '已认购'},
      {'key': '2', 'value': '已签约'},
      {'key': '3', 'value': '已确认'},
    ],
    [
      {'key': '0', 'value': '已失败'},
      {'key': '1', 'value': '未通过'},
      {'key': '2', 'value': '不通过'},
      {'key': '3', 'value': '待审批'},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      body: Stack(
        children: [
          buildBgView(),
          MyListView(
            isShuaxin: false,
            flag: false,
            item: (i) => item[i],
            itemCount: item.length,
            padding: EdgeInsets.only(top: padd(context).top),
          ),
        ],
      ),
    );
  }

  List<Widget> get item {
    return [
      buildItem1(20, 20),
      buildItem5(),
    ];
  }

  Widget buildItem5() {
    return TweenWidget(
      axis: Axis.vertical,
      curve: ElasticOutCurve(1),
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Color(0xffB0C2CC).withOpacity(0.3),
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText('我的客户', size: 14, isBold: true),
            Divider(),
            for (var i = 0; i < kehuUiList.length; i++)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffDFDFDF).withOpacity(i == 2 ? 0 : 1),
                      width: i == 2 ? 0 : 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(KehuPage());
                        },
                        child: TweenWidget(
                          axis: Axis.vertical,
                          delayed: 20 + 20 * i,
                          value: 50,
                          curve: ElasticOutCurve(1),
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              MyText(kehuUiList[i][0]['value'], isBold: true),
                              MyText(
                                '0',
                                isBold: true,
                                color: Color(
                                  0xffFD6369,
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: 36, width: 1, color: Color(0xffDFDFDF)),
                    Expanded(
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(KehuPage());
                        },
                        child: TweenWidget(
                          axis: Axis.vertical,
                          delayed: 40 + 20 * i,
                          curve: ElasticOutCurve(1),
                          value: 50,
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              MyText(kehuUiList[i][1]['value'], isBold: true),
                              MyText(
                                '0',
                                isBold: true,
                                color: Color(
                                  0xffFD6369,
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: 36, width: 1, color: Color(0xffDFDFDF)),
                    Expanded(
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(KehuPage());
                        },
                        child: TweenWidget(
                          axis: Axis.vertical,
                          delayed: 60 + 20 * i,
                          curve: ElasticOutCurve(1),
                          value: 50,
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              MyText(kehuUiList[i][2]['value'], isBold: true),
                              MyText(
                                '0',
                                isBold: true,
                                color: Color(
                                  0xffFD6369,
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: 36, width: 1, color: Color(0xffDFDFDF)),
                    Expanded(
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(KehuPage());
                        },
                        child: TweenWidget(
                          axis: Axis.vertical,
                          delayed: 80 + 20 * i,
                          curve: ElasticOutCurve(1),
                          value: 50,
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              MyText(kehuUiList[i][3]['value'], isBold: true),
                              MyText(
                                '0',
                                isBold: true,
                                color: Color(
                                  0xffFD6369,
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildItem1(double value, int delayed) {
    return TweenWidget(
      axis: Axis.vertical,
      delayed: delayed,
      value: value,
      isOpacity: true,
      curve: ElasticOutCurve(1),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 17, top: 17),
              child: ClipOval(
                child: WrapperImage(
                  width: 64,
                  urlBuilder: () => '',
                  imageType: ImageType.random,
                  height: 64,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: MyColumn(
                children: [
                  SizedBox(height: 24),
                  Row(
                    children: [
                      MyText(
                        '路江山',
                        size: 16,
                        isBold: true,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56),
                          color: Color(0xffF4CB5A),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: MyText(
                          '中介',
                          color: Colors.white,
                          size: 12,
                          isBold: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  MyText('15577000090', color: Colors.white),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    WidgetTap(
                      isElastic: true,
                      onTap: () {
                        jumpPage(SetupPage());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 8),
                        child: Image.asset(
                          'assets/img/wode_shezhi.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 8)
                  ],
                ),
                Spacer(),
                WidgetTap(
                  isElastic: true,
                  onTap: () {
                    // jumpPage(YaoqingPage());
                    showToast('复制');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(56)),
                    ),
                    padding: EdgeInsets.only(top: 2, bottom: 2, left: 19, right: 16),
                    child: MyText(
                      '复制',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBgView() {
    return TweenWidget(
      isOpacity: true,
      value: 1,
      axis: Axis.vertical,
      child: Container(
        height: 272,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff4A9DF6),
              Color(0x004A9DF6),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

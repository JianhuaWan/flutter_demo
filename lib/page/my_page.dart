import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/page/wode/bangzhu_page.dart';
import 'package:flutter_app/page/wode/baozhang_page.dart';
import 'package:flutter_app/page/wode/dengji_page.dart';
import 'package:flutter_app/page/wode/fensi_page.dart';
import 'package:flutter_app/page/wode/setup_page.dart';
import 'package:flutter_app/page/wode/shangxueyuan_page.dart';
import 'package:flutter_app/page/wode/shoucang_page.dart';
import 'package:flutter_app/page/wode/yaoqing_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/provider/user_provider.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:provider/provider.dart';

import 'wode/kehu_page.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  var caidanList1 = [
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
  ];

  var caidanList2 = [
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
  ];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    userPro.apiCustomerStatistics();
    userPro.apiUserRightsStatistics();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      brightness: Brightness.light,
      body: Selector<UserProvider, UserModel>(
        selector: (_, k) => k.userModel!,
        builder: (_, v, view) {
          return Stack(
            children: [
              buildBgView(),
              MyListView(
                isShuaxin: true,
                expView: Container(),
                header: buildClassicHeader(
                  color: Colors.white,
                ),
                onRefresh: () async {
                  await userPro.refreshToken();
                  await userPro.apiCustomerStatistics();
                  return userPro.apiUserRightsStatistics();
                },
                item: (i) => item[i],
                itemCount: item.length,
                padding: EdgeInsets.only(top: padd(context).top),
                physics: BouncingScrollPhysics(),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> get item {
    return [
      buildItem1(20, 20),
      SizedBox(height: 10),
      buildItem3(100, 100),
      buildItem2(100, 100),
    ];
  }

  TweenWidget buildItem3(double value, int delayed) {
    return TweenWidget(
      axis: Axis.vertical,
      delayed: delayed,
      value: value,
      isOpacity: true,
      curve: ElasticOutCurve(1),
      child: WidgetTap(
        isElastic: true,
        onTap: () => jumpPage(YaoqingPage()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset(
            'assets/img/5ee39872586de@2x@2x.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: WidgetTap(
                isElastic: true,
                onTap: () {
                  if (user.id == null) {
                    jumpPage(PassWordLogin(), isMoveBtm: true);
                  } else {
                    jumpPage(ModifyUserInfo());
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 17, top: 17),
                      child: ClipOval(
                        child: WrapperImage(
                          width: 64,
                          urlBuilder: () => user.portrait,
                          height: 64,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MyColumn(
                        children: [
                          SizedBox(height: 17),
                          Row(
                            children: [
                              MyText(
                                isNull(user, 'nickName', '登录/注册', true),
                                size: 16,
                                isBold: true,
                                color: Colors.white,
                              ),
                              if (user.id != null) SizedBox(width: 5),
                              if (user.id != null)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(56),
                                    color: Color(0xffF4CB5A),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: MyText(
                                    app.zidianDm.object!.isNotEmpty
                                        ? (app.zidianDm.object!
                                            .where((w) =>
                                                w['dictType'] == 'UserLevel')
                                            .firstWhere(
                                                (w) =>
                                                    w['dictKey'] ==
                                                    (user.userLevel == 0
                                                        ? 1
                                                        : user.userLevel),
                                                orElse: () => {
                                                      'dictValue': '未知身份'
                                                    }))['dictValue']
                                        : '未知身份',
                                    color: Colors.white,
                                    size: 12,
                                    nullValue: '未知身份',
                                    isBold: true,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 6),
                          MyText(
                            isNull(user, 'mobile', '登录后可体验更多服务', true),
                            isOverflow: false,
                            color: Colors.white,
                          ),
                          // if (user != null) MyText('邀请码：${user.inviteCode}', color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 17, horizontal: 8),
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
                    jumpPage(YaoqingPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(56)),
                    ),
                    padding:
                        EdgeInsets.only(top: 2, bottom: 2, left: 13, right: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/img/wode_tuiyou.png',
                          width: 14,
                          height: 14,
                        ),
                        SizedBox(width: 5),
                        MyText(
                          'btnClick',
                          color: Theme.of(context!).primaryColor,
                        )
                      ],
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

  Widget buildItem2(double value, int delayed) {
    return TweenWidget(
      axis: Axis.vertical,
      delayed: delayed,
      value: value,
      isOpacity: true,
      curve: ElasticOutCurve(1),
      child: Container(
        margin: EdgeInsets.only(left: 17, right: 17, top: 16, bottom: 10),
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
            MyText('标题', size: 14, isBold: true),
            SizedBox(height: 15),
            Column(
              children: [
                Row(
                  children: List.generate(caidanList1.length, (i) {
                    return Expanded(
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () {
                          switch (i) {
                            case 0:
                              jumpPage(BangzhuPage());
                              break;
                            case 1:
                              jumpPage(FensiPage());
                              break;
                            case 2:
                              jumpPage(BaozhangPage());
                              break;
                            case 3:
                              jumpPage(ShangxueyuanPage());
                              break;
                            default:
                              break;
                          }
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              caidanList1[i]['img']!,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(height: 8),
                            MyText(caidanList1[i]['name'], size: 12)
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 15),
                Row(
                  children: List.generate(caidanList2.length, (i) {
                    return Expanded(
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () async {
                          switch (i) {
                            case 0:
                              jumpPage(ShoucangPage());
                              break;
                            case 1:
                              jumpPage(DengjiPage());
                              break;
                            default:
                              break;
                          }
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              caidanList2[i]['img']!,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(height: 8),
                            MyText(caidanList2[i]['name'], size: 12)
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            )
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

class ZhuanShuKefu extends StatefulWidget {
  final Map data;

  const ZhuanShuKefu(this.data, {Key? key}) : super(key: key);

  @override
  _ZhuanShuKefuState createState() => _ZhuanShuKefuState();
}

class _ZhuanShuKefuState extends State<ZhuanShuKefu>
    with TickerProviderStateMixin {
  TextEditingController con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => close(),
        child: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              TweenWidget(
                axis: Axis.vertical,
                curve: ElasticOutCurve(1),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 76 / 2 + 4),
                      MyText('您的专属客服', size: 18, isBold: true),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: MyText(
                          '微信号：${widget.data['weChat']}',
                          isOverflow: false,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                      BtnWidget(
                        isShowShadow: false,
                        titles: ['取消', '复制去微信添加'],
                        bgColor: Colors.transparent,
                        btnHeight: [8, 10],
                        value: [50, 50],
                        axis: [Axis.vertical, Axis.vertical],
                        curve: [ElasticOutCurve(0.75), ElasticOutCurve(0.75)],
                        time: [500, 500],
                        delayed: [50, 100],
                        onTap: [
                          () => close(),
                          () async {
                            await FlutterClipboard.copy(widget.data['weChat']);
                            showToast('已复制');
                            close();
                          },
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -(76 / 2) - 4,
                left: 0,
                right: 0,
                child: Center(
                  child: TweenWidget(
                    axis: Axis.vertical,
                    delayed: 150,
                    value: 1,
                    time: 500,
                    isScale: true,
                    curve: ElasticOutCurve(1),
                    child: ClipOval(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(4),
                        child: ClipOval(
                          child: WrapperImage(
                            width: 76,
                            height: 76,
                            urlBuilder: () => widget.data['portrait'],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

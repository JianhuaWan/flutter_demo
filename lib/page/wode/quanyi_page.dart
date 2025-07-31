import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/page/wode/tixian_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/widget/no_sliding_return.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:flutter_app/util/http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';

class QuanyiPage extends StatefulWidget {
  final String title;

  const QuanyiPage({
    Key key,
    @required this.title,
  }) : super(key: key);
  @override
  _QuanyiPageState createState() => _QuanyiPageState();
}

class _QuanyiPageState extends State<QuanyiPage> with NoSlidingReturn {
  var description;

  AnimatedDigitController controller = AnimatedDigitController(0);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: Column(
        children: [
          buildTitle(
            context,
            title: widget.title == '可提现' ? '${widget.title}金额' : widget.title,
            color: Colors.white,
            isShowBorder: true,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 17),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: MyText(
                    widget.title == '可提现' ? '${widget.title}总金额 (元)' : '${widget.title}总额 (元)',
                    size: 16,
                    isBold: true,
                    color: Color(0xff2F2F30),
                  ),
                ),
                AnimatedDigitWidget(
                  controller: controller,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  fractionDigits: 2,
                  enableDigitSplit: true,
                )
              ],
            ),
          ),
        ],
      ),
      body: TabWidget(
        isPadding: false,
        isNoShowTab: widget.title == '实际发放' || widget.title == '可提现',
        isShadow: true,
        tabList: ['自购预发放', '下级经纪人预发放'],
        tabPage: [
          QuanyiItemPage(
            isSelf: true,
            title: widget.title,
            callback: (v) {
              description = v;
              controller.resetValue(0);
              controller.addValue(int.parse(description));
            },
          ),
          QuanyiItemPage(isSelf: false, title: widget.title),
          // MyListView(
          //   isShuaxin: true,
          //   itemCount: 20,
          //   padding: EdgeInsets.all(16),
          //   divider: Divider(height: 16, color: Colors.transparent),
          //   listViewType: ListViewType.Separated,
          //   item: (i) {
          //     return Container(
          //       padding: EdgeInsets.all(16),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           buildLineText(
          //             '经纪人姓名：芳华',
          //             '手机号：18134556567',
          //             isBig: true,
          //           ),
          //           Divider(),
          //           buildLineText(
          //             '客户姓名：黎明',
          //             '客户手机号：13499827411',
          //             color: Colors.black54,
          //             isbold: false,
          //             color1: Colors.black54,
          //             isbold1: false,
          //           ),
          //           Divider(height: 8, color: Colors.transparent),
          //           buildLineText(
          //             '购买楼盘：万科',
          //             '购买时间：2019.03.23',
          //             color: Colors.black54,
          //             isbold: false,
          //             color1: Colors.black54,
          //             isbold1: false,
          //           ),
          //           Divider(),
          //           MyText(
          //             '佣金：500.00元',
          //             isBold: true,
          //             size: 16,
          //             color: Color(0xffFD6369),
          //           ),
          //         ],
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(10),
          //         boxShadow: [
          //           BoxShadow(
          //             blurRadius: 6,
          //             color: Color(0x80B0C2CC),
          //             offset: Offset(0, 3),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}

class TanChuang extends StatefulWidget {
  final String id;

  const TanChuang(this.id, {Key key}) : super(key: key);
  @override
  _TanChuangState createState() => _TanChuangState();
}

class _TanChuangState extends State<TanChuang> with TickerProviderStateMixin {
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
          child: TweenWidget(
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
                  MyText('申请提现', size: 18, isBold: true),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: MyText(
                      '提现申请后，将由管理员进行审核，审核通过之后将会通过线下转账方式给您转账！确认申请该佣金提现吗？',
                      isOverflow: false,
                      size: 14,
                    ),
                  ),
                  BtnWidget(
                    isShowShadow: false,
                    titles: ['取消', '确定'],
                    bgColor: Colors.transparent,
                    btnHeight: [8, 10],
                    value: [50, 50],
                    axis: [Axis.vertical, Axis.vertical],
                    curve: [ElasticOutCurve(0.75), ElasticOutCurve(0.75)],
                    time: [500, 500],
                    delayed: [50, 100],
                    onTap: [
                      () => close(),
                      () {
                        close();
                        if (!user.isIdentity) {
                          showToast('请先完成实名认证！');
                          // jumpPage(
                          //   ShimingPage(),
                          //   callback: (v) {
                          //     if (v != null) userPro.refreshToken();
                          //   },
                          // );
                          return;
                        }
                        jumpPage(TixianPage(widget.id));
                      },
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuanyiItemPage extends StatefulWidget {
  final bool isSelf;
  final String title;
  final Function(String) callback;

  const QuanyiItemPage({Key key, this.isSelf = true, this.callback, this.title}) : super(key: key);
  @override
  _QuanyiItemPageState createState() => _QuanyiItemPageState();
}

class _QuanyiItemPageState extends State<QuanyiItemPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiUserRightsGetPageList(isRef: true);
  }

  ///获取权益明细
  var quanyiDm = DataModel(hasNext: false);
  Future<int> apiUserRightsGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/UserRights/GetPageList',
      data: {
        "isSelf": true,
        "Status": {'可提现': 1, '实际发放': 4}[widget.title]
      },
      catchError: (v) => quanyiDm.toError(v),
      success: (v) {
        quanyiDm.addList(v['data'], isRef, v['total']);
        if (widget.callback != null) widget.callback(v['description']);
      },
    );
    setState(() {});
    return quanyiDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      // appBar: buildTitle(
      //   context,
      //   title: '获取权益明细',
      //   color: Colors.white,
      // ),
      body: AnimatedSwitchBuilder(
        value: quanyiDm,
        errorOnTap: () => this.apiUserRightsGetPageList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            padding: EdgeInsets.all(16),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 16, color: Colors.transparent),
            onLoading: () => this.apiUserRightsGetPageList(page: p),
            onRefresh: () => this.apiUserRightsGetPageList(isRef: true),
            physics: BouncingScrollPhysics(),
            itemCount: list.length,
            item: (i) {
              return Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildLineText(
                      '经纪人姓名：${list[i]['agentName']}',
                      '手机号：${list[i]['agentMobile']}',
                      isBig: true,
                    ),
                    Divider(),
                    buildLineText(
                      '客户姓名：${list[i]['realName']}',
                      '客户手机号：${list[i]['mobile']}',
                      color: Colors.black54,
                      isbold: false,
                      color1: Colors.black54,
                      isbold1: false,
                    ),
                    Divider(height: 8, color: Colors.transparent),
                    buildLineText(
                      '购买楼盘：${list[i]['buildingName']}',
                      '',
                      color: Colors.black54,
                      isbold: false,
                      color1: Colors.black54,
                      isbold1: false,
                    ),
                    Divider(height: 8, color: Colors.transparent),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        '购买时间：${toTime(list[i]['buyDateTime'])}',
                        color: Colors.black54,
                      ),
                    ),
                    Divider(),
                    if (widget.title == '可提现')
                      Row(
                        children: [
                          Expanded(
                            child: MyText(
                              '佣金：${{
                                '预发放': list[i]['preProvide'],
                                '可提现': list[i]['preProvide'],
                                '实际发放': list[i]['realProvide'],
                              }[widget.title]}元',
                              isBold: true,
                              size: 16,
                              color: Color(0xffFD6369),
                            ),
                          ),
                          WidgetTap(
                            isElastic: true,
                            onTap: () async {
                              if (list[i]['status'] == 2) {
                                showToast('审核中');
                              } else {
                                showGeneralDialog(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  pageBuilder: (_, __, ___) {
                                    return TanChuang(list[i]['id']);
                                  },
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: list[i]['status'] == 2 ? Colors.black26 : Theme.of(context).primaryColor,
                              ),
                              child: MyText(list[i]['status'] == 2 ? '审核中' : '申请提现', color: Colors.white, textAlign: TextAlign.center, size: 12),
                            ),
                          ),
                        ],
                      )
                    else
                      MyText(
                        '佣金：${{
                          '预发放': list[i]['preProvide'],
                          '可提现': list[i]['canDeposits'],
                          '实际发放': list[i]['realProvide'],
                        }[widget.title]}元',
                        isBold: true,
                        size: 16,
                        color: Color(0xffFD6369),
                      ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Color(0x80B0C2CC),
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Row buildLineText(v, v1, {size, size1, color, color1, isbold, isbold1, bool isBig = false}) {
  return Row(
    children: [
      Expanded(
        child: MyText(
          v ?? '经纪人姓名：芳华',
          isBold: isbold ?? true,
          size: size1,
          color: color ?? Colors.black,
        ),
      ),
      Expanded(
        child: MyText(
          v1 ?? '手机号：18134556567',
          size: size1 ?? 13,
          textAlign: isBig ? TextAlign.end : null,
          isBold: isbold1 ?? true,
          color: color1 ?? Colors.black,
        ),
      )
    ],
  );
}

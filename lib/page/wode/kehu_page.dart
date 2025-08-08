import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/provider/user_provider.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/view/views.dart';
import 'package:flutter_app/widget/my_custom_scroll.dart';
import 'package:flutter_app/widget/no_sliding_return.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:provider/provider.dart';

class KehuPage extends StatefulWidget {
  final bool isUser;
  final int index;

  const KehuPage({Key? key, this.isUser = false, this.index = 0}) : super
      (key: key);
  @override
  _KehuPageState createState() => _KehuPageState();
}

class _KehuPageState extends State<KehuPage> with NoSlidingReturn, TickerProviderStateMixin {
  TabController? tabCon;

  var kehuUiList = [
    {'key': '1', 'value': '待审核'},
    {'key': '2', 'value': '待到访'},
    {'key': '3', 'value': '已到访'},
    {'key': '4', 'value': '已逾期'},
    {'key': '5', 'value': '已认筹'},
    {'key': '6', 'value': '已认购'},
    {'key': '7', 'value': '已签约'},
    {'key': '8', 'value': '已确认'},
    {'key': '9', 'value': '已失败'},
    {'key': '10', 'value': '未通过'},
    {'key': '11', 'value': '不通过'},
    {'key': '12', 'value': '待审批'},
  ];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    var zimuList = ['', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'];
    if (widget.isUser) {
      kehuUiList = [
        {'key': '3', 'value': '已到访', 'key2': zimuList[3]},
        {'key': '6', 'value': '已认购', 'key2': zimuList[6]},
        {'key': '8', 'value': '已确认', 'key2': zimuList[8]},
      ];
      tabCon = TabController(vsync: this, length: kehuUiList.length, initialIndex: widget.index);
      setState(() {});
    } else {
      kehuUiList = [
        {'key': '1', 'value': '已推荐', 'key2': zimuList[1]},
        {'key': '3', 'value': '已到访', 'key2': zimuList[3]},
        {'key': '5', 'value': '已认筹', 'key2': zimuList[5]},
        {'key': '6', 'value': '已认购', 'key2': zimuList[6]},
        {'key': '7', 'value': '已签约', 'key2': zimuList[7]},
        {'key': '8', 'value': '已成交', 'key2': zimuList[8]},
        {'key': '9', 'value': '已退房', 'key2': zimuList[9]},
      ];
      tabCon = TabController(vsync: this, length: kehuUiList.length, initialIndex: widget.index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '我的客户',
        color: Colors.white,
        isShowBorder: true,
      ),
      body: Selector<UserProvider, Map>(
        selector: (_, k) => k.myKehuTongjiDm.object!,
        builder: (_, v, view) {
          return TabWidget(
            tabCon: tabCon,
            isScrollable: !widget.isUser,
            tabList: kehuUiList.map((m) => '${m['value']}(${v[m['key2']]})').toList(),
            tabPage: kehuUiList.map((m) => KehuItem(m)).toList(),
          );
        },
      ),
    );
  }
}

class KehuItem extends StatefulWidget {
  final Map m;

  const KehuItem(this.m, {Key? key}) : super(key: key);
  @override
  _KehuItemState createState() => _KehuItemState();
}

class _KehuItemState extends State<KehuItem> {
  TextEditingController mianjiCon = TextEditingController();
  TextEditingController yongjinCon = TextEditingController();
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiCustomerGetPageList(isRef: true);
  }

  ///获取我的客户列表
  var kehuListDm = DataModel(hasNext: false);
  Future<int> apiCustomerGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Customer/GetPageList',
      data: {
        "Type": "2",
        // "id": user.id,
        // "UserId":user.id,
        "Status": widget.m['key'],
        "PageIndex": page,
      },
      catchError: (v) => kehuListDm.toError('服务器睡着了～'),
      success: (v) => kehuListDm.addList(v['data'], isRef, v['total']),
    );
    setState(() {});
    return kehuListDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: kehuListDm,
      errorOnTap: () => this.apiCustomerGetPageList(isRef: true),
      isAnimatedSize: true,
      listBuilder: (list, p, h) {
        return MyCustomScroll(
          headers: [buildMaskView(widget.m, false)],
          itemPadding: EdgeInsets.all(15),
          mainAxisSpacing: 15,
          onRefresh: () async => this.apiCustomerGetPageList(isRef: true),
          maskWidget: () => buildMaskView(widget.m, true),
          onLoading: (p) => this.apiCustomerGetPageList(page: p),
          itemModel: kehuListDm,
          itemModelBuilder: (i, v) {
            return TweenWidget(
              axis: Axis.vertical,
              value: 1,
              isScale: true,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLineText('经纪人姓名：${v['agentName']}', '手机号：${v['agentMobile']}'),
                    Divider(),
                    MyText('客户姓名：${v['realName']}', size: 13, color: Colors.grey),
                    SizedBox(height: 11),
                    MyText('客户手机号：${v['mobile']}', size: 13, color: Colors.grey),
                    SizedBox(height: 11),
                    MyText('购买楼盘：${v['buildingName']}', size: 13, color: Colors.grey),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: MyText(
                            widget.m['value'] == '已成交' || widget.m['value'] == '已确认' ? '成交时间：${v['buyDateTime']}' : '',
                            size: 13,
                            color: Colors.grey,
                          ),
                        ),
                        WidgetTap(
                          isElastic: true,
                          onTap: () async {
                            await FlutterClipboard.copy(
                              '经纪人姓名：${v['agentName']}\n手机号：${v['agentMobile']}\n客户姓名：${v['realName']}\n客户手机号：${v['mobile']}\n购买楼盘：${v['buildingName']}${widget.m['value'] == '已成交' ? '\n成交时间：${v['buyDateTime']}' : ''}',
                            );
                            showToast('已复制');
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                              border: Border.all(width: 1.5, color: Theme.of(context).primaryColor),
                            ),
                            child: MyText(
                              '复制',
                              color: Theme.of(context).primaryColor,
                              textAlign: TextAlign.center,
                              size: 12,
                            ),
                          ),
                        ),
                        if (widget.m['value'] != '已退房' && widget.m['value'] != '已成交' && widget.m['value'] != '已确认') SizedBox(width: 8),
                        if (widget.m['value'] != '已退房' && widget.m['value'] != '已成交' && widget.m['value'] != '已确认')
                          WidgetTap(
                            isElastic: true,
                            onTap: () async {
                              if (widget.m['value'] == '已签约') {
                                showTc(
                                  onPressed: () {
                                    showTc(
                                      onPressed: () async {
                                        if (mianjiCon.text != '') {
                                          await Request.put(
                                            '/api/Customer/ChangeStatus',
                                            data: {
                                              "id": v['id'],
                                              "status": {
                                                '已推荐': '3',
                                                '已到访': '5',
                                                '已认筹': '6',
                                                '已认购': '7',
                                                '已签约': '8',
                                                '已成交': '9',
                                              }[widget.m['value']],
                                              'area': mianjiCon.text,
                                            },
                                            isLoading: true,
                                            catchError: (v) => showToast(v),
                                            success: (v) {
                                              setState(() {
                                                kehuListDm.flag = 0;
                                              });
                                              this.apiCustomerGetPageList(isRef: true);
                                              userPro.apiCustomerStatistics();
                                              userPro.apiUserRightsStatistics();
                                              // return showToast('已审核');
                                            },
                                          );
                                        } else {
                                          showToast('请输入面积');
                                        }
                                      },
                                      titleView: Row(
                                        children: [
                                          MyText('购买面积(元)'),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black12,
                                                ),
                                              ),
                                              child: buildTFView(
                                                context,
                                                con: mianjiCon,
                                                hintText: '多户型用，隔开',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onCancel: () {
                                    showTc(
                                      onPressed: () async {
                                        if (yongjinCon.text == '') {
                                          showToast('请输入佣金');
                                        } else if (mianjiCon.text == '') {
                                          showToast('请输入面积');
                                        } else {
                                          await Request.put(
                                            '/api/Customer/ChangeStatus',
                                            data: {
                                              "id": v['id'],
                                              "status": {
                                                '已推荐': '3',
                                                '已到访': '5',
                                                '已认筹': '6',
                                                '已认购': '7',
                                                '已签约': '8',
                                                '已成交': '9',
                                              }[widget.m['value']],
                                              'commission': yongjinCon.text,
                                              'area': mianjiCon.text,
                                            },
                                            isLoading: true,
                                            catchError: (v) => showToast(v),
                                            success: (v) {
                                              setState(() {
                                                kehuListDm.flag = 0;
                                              });
                                              this.apiCustomerGetPageList(isRef: true);
                                              userPro.apiCustomerStatistics();
                                              userPro.apiUserRightsStatistics();
                                              // return showToast('已审核');
                                            },
                                          );
                                        }
                                      },
                                      titleView: Column(
                                        children: [
                                          Row(
                                            children: [
                                              MyText('请填写正确的佣金金额(元)'),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                  child: buildTFView(
                                                    context,
                                                    hintText: '',
                                                    con: yongjinCon,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              MyText('购买面积(元)'),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                  child: buildTFView(
                                                    context,
                                                    hintText: '多户型用，隔开',
                                                    con: mianjiCon,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  okText: '是',
                                  cancelText: '否',
                                  titleView: MyText(
                                    '是否确认该笔成交佣金为(',
                                    isOverflow: false,
                                    color: Colors.black,
                                    textAlign: TextAlign.center,
                                    children: [
                                      MyText.ts(v['commission'].toString(), color: Colors.red),
                                      MyText.ts(')元'),
                                    ],
                                  ),
                                );
                              } else {
                                showGeneralDialog(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  pageBuilder: (_, __, ___) {
                                    return KehuTanchuang(
                                      {
                                        '已推荐': '到访',
                                        '已到访': '认筹',
                                        '已认筹': '认购',
                                        '已认购': '签约',
                                        '已签约': '成交',
                                        '已成交': '退房',
                                      }[widget.m['value']]!,
                                      fun: () async {
                                        await Request.put(
                                          '/api/Customer/ChangeStatus',
                                          data: {
                                            "id": v['id'],
                                            "status": {
                                              '已推荐': '3',
                                              '已到访': '5',
                                              '已认筹': '6',
                                              '已认购': '7',
                                              '已签约': '8',
                                              '已成交': '9',
                                            }[widget.m['value']],
                                          },
                                          isLoading: true,
                                          catchError: (v) => showToast(v),
                                          success: (v) {
                                            setState(() {
                                              kehuListDm.flag = 0;
                                            });
                                            this.apiCustomerGetPageList(isRef: true);
                                            userPro.apiCustomerStatistics();
                                            userPro.apiUserRightsStatistics();
                                            // return showToast('已审核');
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: MyText(
                                {
                                  '已推荐': '到访',
                                  '已到访': '认筹',
                                  '已认筹': '认购',
                                  '已认购': '签约',
                                  '已签约': '成交',
                                  '已成交': '退房',
                                }[widget.m['value']],
                                color: Colors.white,
                                textAlign: TextAlign.center,
                                size: 12,
                              ),
                            ),
                          ),
                        if (widget.m['value'] == '已签约') SizedBox(width: 8),
                        if (widget.m['value'] == '已签约')
                          WidgetTap(
                            isElastic: true,
                            onTap: () async {
                              showGeneralDialog(
                                context: context,
                                barrierColor: Colors.transparent,
                                pageBuilder: (_, __, ___) {
                                  return KehuTanchuang(
                                    '退房',
                                    fun: () async {
                                      await Request.put(
                                        '/api/Customer/ChangeStatus',
                                        data: {
                                          "id": v['id'],
                                          "status": 9,
                                        },
                                        isLoading: true,
                                        catchError: (v) => showToast(v),
                                        success: (v) {
                                          setState(() {
                                            kehuListDm.flag = 0;
                                          });
                                          this.apiCustomerGetPageList(isRef: true);
                                          userPro.apiCustomerStatistics();
                                          userPro.apiUserRightsStatistics();
                                          // return showToast('已到访');
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: MyText(
                                '退房',
                                color: Colors.white,
                                textAlign: TextAlign.center,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMaskView(Map m, isShowShadow) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15),
      width: double.infinity,
      child: MyText(m['value']! + '客户：${userPro.myKehuTongjiDm
          .object![m['key2']]}个'),
      decoration: BoxDecoration(
        color: isShowShadow ? Colors.white : Colors.transparent,
        boxShadow: !isShowShadow
            ? []
            : [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black12,
                  spreadRadius: -4,
                  offset: Offset(0, 4),
                ),
              ],
      ),
    );
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
}

class KehuTanchuang extends StatefulWidget {
  final String title;
  final Function? fun;

  const KehuTanchuang(this.title, {Key? key, this.fun}) : super(key: key);
  @override
  _KehuTanchuangState createState() => _KehuTanchuangState();
}

class _KehuTanchuangState extends State<KehuTanchuang> with TickerProviderStateMixin {
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: 76 / 2 + 4),
                  MyText(widget.title, size: 18, isBold: true),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: MyText(
                      {
                        '到访': '确认该客户已到访',
                        '认筹': '确认该客户已认筹',
                        '认购': '确认该客户已认购',
                        '签约': '确认该客户已签约',
                        '成交': '确认该客户已成交',
                        '退房': '确认该客户已退房',
                      }[widget.title],
                      // widget.title == '审核' ? '确认将该客户审核通过' : '确认将该客户到访',
                      isOverflow: false,
                      size: 14,
                      color: Colors.grey,
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
                      () async {
                        widget.fun!()!;
                        close();
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

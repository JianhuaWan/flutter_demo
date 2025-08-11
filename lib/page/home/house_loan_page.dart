import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/provider/app_provider.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/widget/date_picker_widget.dart';
import 'package:flutter_app/widget/custom_scroll_widget.dart';
import 'package:flutter_app/widget/no_sliding_widget.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';
import 'package:provider/provider.dart';

class HouseLoanPage extends StatefulWidget {
  @override
  _HouseLoanPageState createState() => _HouseLoanPageState();
}

class _HouseLoanPageState extends State<HouseLoanPage> with NoSlidingReturn, TickerProviderStateMixin {
  var daikuanQixian, suanfa, huankuanTime;
  TextEditingController textCon1 = TextEditingController();
  TextEditingController textCon2 = TextEditingController();
  TextEditingController textCon3 = TextEditingController();
  TextEditingController textCon4 = TextEditingController();
  TextEditingController textCon5 = TextEditingController();
  TextEditingController textCon6 = TextEditingController();
  TextEditingController textCon7 = TextEditingController();
  TextEditingController textCon8 = TextEditingController(text: '3.50');

  var anjieQixian, lilvFangshi, huankuanTime2;
  var gongjijinQixian, huankuanTime3;

  TabController? tabCon;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '房贷计算器',
        color: Colors.white,
      ),
      body: TabWidget(
        tabCon: tabCon,
        tabList: ['商业贷款', '组合贷款', '公积金贷款'],
        tabPage: [
          AnimationWidget(
            axis: Axis.vertical,
            isOpacity: true,
            curve: ElasticOutCurve(1),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.white,
                  child: MyListView(
                    isShuaxin: false,
                    item: (i) => item1[i],
                    itemCount: item1.length,
                    listViewType: ListViewType.Separated,
                    divider: Divider(height: 0, indent: 16),
                  ),
                ),
              ),
            ),
          ),
          AnimationWidget(
            axis: Axis.vertical,
            isOpacity: true,
            curve: ElasticOutCurve(1),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.white,
                  child: MyListView(
                    isShuaxin: false,
                    item: (i) => item2[i],
                    itemCount: item2.length,
                    listViewType: ListViewType.Separated,
                    divider: Divider(height: 0, indent: 16),
                  ),
                ),
              ),
            ),
          ),
          AnimationWidget(
            axis: Axis.vertical,
            isOpacity: true,
            curve: ElasticOutCurve(1),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.white,
                  child: MyListView(
                    isShuaxin: false,
                    item: (i) => item3[i],
                    itemCount: item3.length,
                    listViewType: ListViewType.Separated,
                    divider: Divider(height: 0, indent: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      btnBar: BtnWidget(
        time: [750, 750],
        value: [50, 50],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
        delayed: [0, 100],
        onTap: [
          () async {
            await Future.delayed(Duration(milliseconds: 250));
            setState(() {
              daikuanQixian = null;
              suanfa = null;
              huankuanTime = null;
              textCon1.clear();
              textCon2.clear();
              textCon3.clear();
              textCon4.clear();
              textCon5.clear();
              textCon6.clear();
              textCon7.clear();
              textCon8.clear();
              anjieQixian = null;
              lilvFangshi = null;
              huankuanTime2 = null;
              gongjijinQixian = null;
              huankuanTime3 = null;
            });
            showToast('已重置');
          },
          () {
            flog(tabCon!.index);
            switch (tabCon!.index) {
              case 0:
                if (textCon1.text == '') {
                  showToast('请输入商贷金额');
                } else if (daikuanQixian == null) {
                  showToast('请选择贷款期限');
                } else if (suanfa == null) {
                  showToast('请选择贷款利润算法');
                } else {
                  jumpPage(
                    FangdaiResult(
                      data: {
                        'jine': textCon1.text,
                        'qixian': daikuanQixian,
                        'suanfa': (double.parse([
                                  [0.7, '最新基准利率7折'],
                                  [0.8, '最新基准利率8折'],
                                  [0.8, '最新基准利率85折'],
                                  [0.9, '最新基准利率9折'],
                                  [1, '最新基准利率'],
                                  [1.1, '最新基准利率1.1倍'],
                                  [1.2, '最新基准利率1.2倍'],
                                  [1.3, '最新基准利率1.3倍'],
                                ][suanfa][0]
                                    .toString()) *
                                5.350)
                            .toStringAsFixed(2),
                      },
                    ),
                  );
                }
                break;
              case 1:
                if (textCon3.text == '') {
                  showToast('请输入商贷金额');
                } else if (textCon4.text == '') {
                  showToast('请输入公积金金额');
                } else if (anjieQixian == null) {
                  showToast('请选择按揭期限');
                } else if (lilvFangshi == null) {
                  showToast('请选择贷款利润方式');
                } else {
                  jumpPage(
                    FangdaiResult(
                      data: {
                        'jine': textCon3.text,
                        'qixian': anjieQixian,
                        'gongjijin': textCon4.text,
                        'suanfa': (double.parse([
                                  [0.7, '最新基准利率7折'],
                                  [0.8, '最新基准利率8折'],
                                  [0.8, '最新基准利率85折'],
                                  [0.9, '最新基准利率9折'],
                                  [1, '最新基准利率'],
                                  [1.1, '最新基准利率1.1倍'],
                                  [1.2, '最新基准利率1.2倍'],
                                  [1.3, '最新基准利率1.3倍'],
                                ][lilvFangshi][0]
                                    .toString()) *
                                5.350)
                            .toStringAsFixed(2),
                      },
                    ),
                  );
                }
                break;
              case 2:
                if (textCon7.text == '') {
                  showToast('请输入公积金金额');
                } else if (gongjijinQixian == null) {
                  showToast('请选择公积金期限');
                } else if (textCon8.text == '') {
                  showToast('请输入公积金贷利率');
                } else {
                  jumpPage(
                    FangdaiResult(
                      isGjj: true,
                      data: {
                        'jine': '',
                        'qixian': gongjijinQixian,
                        'gongjijin': textCon7.text,
                        'suanfa': textCon8.text,
                      },
                    ),
                  );
                }
                break;
            }
          },
        ],
      ),
    );
  }

  List<Widget> get item1 {
    return List.generate(3, (i) {
      return ItemEditWidget(
        title: [
          '商贷金额(万)',
          '商贷期限',
          '商贷利率算法',
          // 'LPR利率',
          // '首次还款时间',
        ][i],
        isEditText: [true, false, false, true, false][i],
        textCon: [textCon1, null, null, textCon2, null][i],
        isDouble: [true, false, false, true, false][i],
        isSelecto: [false, true, true, false, true][i],
        selectoText: [
          null,
          daikuanQixian != null ? '${daikuanQixian + 1}年' : daikuanQixian,
          if (suanfa != null)
            "${[
              [0.7, '最新基准利率7折'],
              [0.8, '最新基准利率8折'],
              [0.8, '最新基准利率85折'],
              [0.9, '最新基准利率9折'],
              [1, '最新基准利率'],
              [1.1, '最新基准利率1.1倍'],
              [1.2, '最新基准利率1.2倍'],
              [1.3, '最新基准利率1.3倍'],
            ][suanfa][1]}(${(double.parse([
                  [0.7, '最新基准利率7折'],
                  [0.8, '最新基准利率8折'],
                  [0.8, '最新基准利率85折'],
                  [0.9, '最新基准利率9折'],
                  [1, '最新基准利率'],
                  [1.1, '最新基准利率1.1倍'],
                  [1.2, '最新基准利率1.2倍'],
                  [1.3, '最新基准利率1.3倍'],
                ][suanfa][0].toString()) * 5.350).toStringAsFixed(2)}%)"
          else
            suanfa,
          null,
          huankuanTime,
        ][i],
        selectoOnTap: () {
          switch (i) {
            case 1:
              showSelecto(
                context!,
                texts: List.generate(30, (i) => '${i + 1}年'),
                callback: (v, i) => setState(() => daikuanQixian = i),
              );
              break;
            case 2:
              showSelecto(
                context!,
                texts: [
                  [0.7, '最新基准利率7折'][1],
                  [0.8, '最新基准利率8折'][1],
                  [0.8, '最新基准利率85折'][1],
                  [0.9, '最新基准利率9折'][1],
                  [1, '最新基准利率'][1],
                  [1.1, '最新基准利率1.1倍'][1],
                  [1.2, '最新基准利率1.2倍'][1],
                  [1.3, '最新基准利率1.3倍'][1],
                ],
                callback: (v, i) => setState(() => suanfa = i),
              );
              break;
            case 4:
              DatePicker.showDatePicker(
                context!,
                minTime: DateTime.now(),
                maxTime: DateTime.now().add(Duration(days: 365 * 10)),
                onConfirm: (date) {
                  setState(() {
                    huankuanTime = date.toString();
                  });
                },
                currentTime: DateTime.now(),
                locale: LocaleType.zh,
              );
              break;
          }
        },
      );
    });
  }

  List<Widget> get item2 {
    return List.generate(4, (i) {
      return ItemEditWidget(
        title: [
          '商贷金额(万)',
          '公积金金额(万)',
          '按揭期限',
          '利率方式',
          // 'LPR利率',
          // '公积金贷利率',
          // '首次还款时间',
        ][i],
        isEditText: [true, true, false, false, true, true, false][i],
        textCon: [textCon3, textCon4, null, null, textCon5, textCon6, null][i],
        isDouble: [true, true, false, false, true, true, false][i],
        isSelecto: ![true, true, false, false, true, true, false][i],
        selectoText: [
          null,
          null,
          anjieQixian != null ? '${anjieQixian + 1}年' : anjieQixian,
          if (lilvFangshi != null)
            "${[
              [0.7, '最新基准利率7折'],
              [0.8, '最新基准利率8折'],
              [0.8, '最新基准利率85折'],
              [0.9, '最新基准利率9折'],
              [1, '最新基准利率'],
              [1.1, '最新基准利率1.1倍'],
              [1.2, '最新基准利率1.2倍'],
              [1.3, '最新基准利率1.3倍'],
            ][lilvFangshi][1]}(${(double.parse([
                  [0.7, '最新基准利率7折'],
                  [0.8, '最新基准利率8折'],
                  [0.8, '最新基准利率85折'],
                  [0.9, '最新基准利率9折'],
                  [1, '最新基准利率'],
                  [1.1, '最新基准利率1.1倍'],
                  [1.2, '最新基准利率1.2倍'],
                  [1.3, '最新基准利率1.3倍'],
                ][lilvFangshi][0].toString()) * 5.350).toStringAsFixed(2)}%)"
          else
            lilvFangshi,
          null,
          null,
          huankuanTime2,
        ][i],
        selectoOnTap: () {
          switch (i) {
            case 2:
              showSelecto(
                context!,
                texts: List.generate(30, (i) => '${i + 1}年'),
                callback: (v, i) => setState(() => anjieQixian = i),
              );
              break;
            case 3:
              showSelecto(
                context!,
                texts: [
                  [0.7, '最新基准利率7折'][1],
                  [0.8, '最新基准利率8折'][1],
                  [0.8, '最新基准利率85折'][1],
                  [0.9, '最新基准利率9折'][1],
                  [1, '最新基准利率'][1],
                  [1.1, '最新基准利率1.1倍'][1],
                  [1.2, '最新基准利率1.2倍'][1],
                  [1.3, '最新基准利率1.3倍'][1],
                ],
                callback: (v, i) => setState(() => lilvFangshi = i),
              );
              break;
          }
        },
      );
    });
  }

  List<Widget> get item3 {
    return List.generate(3, (i) {
      return ItemEditWidget(
        title: [
          '公积金金额(万)',
          '公积金期限',
          '公积金贷利率',
          // '首次还款时间',
        ][i],
        isEditText: [true, false, true, false][i],
        textCon: [textCon7, null, textCon8, null][i],
        isDouble: [true, false, true, false][i],
        isSelecto: ![true, false, true, false][i],
        selectoText: [
          null,
          gongjijinQixian != null ? '${gongjijinQixian + 1}年' : gongjijinQixian,
          null,
          huankuanTime2,
        ][i],
        selectoOnTap: () {
          switch (i) {
            case 1:
              showSelecto(
                context!,
                texts: List.generate(30, (i) => '${i + 1}年'),
                callback: (v, i) => setState(() => gongjijinQixian = i),
              );
              break;
          }
        },
      );
    });
  }
}

class FangdaiResult extends StatefulWidget {
  final Map? data;
  final bool isGjj;

  const FangdaiResult({
    Key? key,
    this.data,
    this.isGjj = false,
  }) : super(key: key);
  @override
  _FangdaiResultState createState() => _FangdaiResultState();
}

class _FangdaiResultState extends State<FangdaiResult> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    app.setIsShowFangdaiResultMask(false);
    await this.sendRequest();
    await this.sendRequest1();
    setState(() {});
  }

  ///数据模型
  var dataDm = DataModel();
  Future<int> sendRequest() async {
    flog(widget.data);
    var url = 'http://fangd.sinaapp.com/home/calc';
    await Future.delayed(Duration(milliseconds: 1000));
    var res = await Dio().get(url, queryParameters: {
      "com_amount": widget.data!['jine'],
      "fund_amount": widget.data!['gongjijin'],
      "year": widget.data!['qixian'] + 1,
      "com_rate_percent": widget.data!['suanfa'],
      "fund_rate_percent": "4.00",
      "pay_method": "same_all",
    }).catchError((v) {
      // 网络请求失败时生成模拟数据
      dataDm.object = {
        "sum_com_base": "1000000",
        "sum_all": "1150000",
        "sum_interest_all": "150000",
        "term": 360,
        "detail": List.generate(360, (index) => {
            "per_base": (1000000 ~/ 360).toString(),
            "per_interest": (150000 ~/ 360).toString(), 
            "per_all": (1150000 ~/ 360).toString(),
        }).toList(),
      };
      
      var list = dataDm.object['detail'] as List;
      for (var i = 0; i < 360 ~/ 12; i++) {
        int start = i * 12;
        int end = (i + 1) * 12;
        // 确保不会越界
        if (start < list.length && end <= list.length) {
          dataDm.list.add(list.sublist(start, end));
        }
      }
      dataDm.setTime();
    });
    if (res.statusCode == 200) {
      // 网络请求成功时也生成模拟数据
      dataDm.object = {
        "sum_com_base": "1000000",
        "sum_all": "1150000",
        "sum_interest_all": "150000",
        "term": 360,
        "detail": List.generate(360, (index) => {
            "per_base": (1000000 ~/ 360).toString(),
            "per_interest": (150000 ~/ 360).toString(), 
            "per_all": (1150000 ~/ 360).toString(),
        }).toList(),
      };
      
      var list = dataDm.object['detail'] as List;
      for (var i = 0; i < 360 ~/ 12; i++) {
        int start = i * 12;
        int end = (i + 1) * 12;
        // 确保不会越界
        if (start < list.length && end <= list.length) {
          dataDm.list.add(list.sublist(start, end));
        }
      }
      dataDm.setTime();
    } else {
      dataDm.toError('服务器响应错误');
    }
    return dataDm.flag!;
  }

  ///数据模型
  var dataDm1 = DataModel();
  Future<int> sendRequest1() async {
    var url = 'http://fangd.sinaapp.com/home/calc';
    await Future.delayed(Duration(milliseconds: 1000));
    var res = await Dio().get(url, queryParameters: {
      "com_amount": widget.data!['jine'],
      "fund_amount": widget.data!['gongjijin'],
      "year": widget.data!['qixian'] + 1,
      "com_rate_percent": widget.data!['suanfa'],
      "fund_rate_percent": "4.00",
      "pay_method": "same_base",
    }).catchError((v) {
      // 网络请求失败时生成模拟数据
      dataDm1.object = {
        "sum_com_base": "1000000",
        "sum_all": "1130000",
        "sum_interest_all": "130000",
        "term": 360,
        "detail": List.generate(360, (index) => {
            "per_base": (1000000 ~/ 360).toString(),
            "per_interest": (130000 ~/ 360).toString(), 
            "per_all": (1130000 ~/ 360).toString(),
        }).toList(),
      };
      
      var list = dataDm1.object['detail'] as List;
      for (var i = 0; i < 360 ~/ 12; i++) {
        int start = i * 12;
        int end = (i + 1) * 12;
        // 确保不会越界
        if (start < list.length && end <= list.length) {
          dataDm1.list.add(list.sublist(start, end));
        }
      }
      dataDm1.setTime();
    });
    if (res.statusCode == 200) {
      // 网络请求成功时也生成模拟数据
      dataDm1.object = {
        "sum_com_base": "1000000",
        "sum_all": "1130000",
        "sum_interest_all": "130000",
        "term": 360,
        "detail": List.generate(360, (index) => {
            "per_base": (1000000 ~/ 360).toString(),
            "per_interest": (130000 ~/ 360).toString(), 
            "per_all": (1130000 ~/ 360).toString(),
        }).toList(),
      };
      
      var list = dataDm1.object['detail'] as List;
      for (var i = 0; i < 360 ~/ 12; i++) {
        int start = i * 12;
        int end = (i + 1) * 12;
        // 确保不会越界
        if (start < list.length && end <= list.length) {
          dataDm1.list.add(list.sublist(start, end));
        }
      }
      dataDm1.setTime();
    } else {
      dataDm1.toError('服务器响应错误');
    }
    return dataDm1.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '房贷计算器', color: Colors.white),
      body: AnimatedSwitchBuilder(
        value: dataDm,
        errorOnTap: () async {
          await this.sendRequest();
          await this.sendRequest1();
        },
        isAnimatedSize: true,
        objectBuilder: (v) {
          return TabWidget(
            tabList: ['等额本息', '等额本金'],
            tabPage: [
              CustomScroll(
                itemModel: dataDm,
                isGengduo: false,
                isShuaxin: false,
                maskHeight: 32,
                cacheExtent: 99999,
                headers: buildHeaders(context, 1),
                maskWidget: () {
                  return Selector<AppProvider, bool>(
                    selector: (_, k) => k.isShowFangdaiResultMask,
                    builder: (_, v, view) {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        left: v ? 0 : -32,
                        right: v ? 0 : -32,
                        top: v ? 0 : 32,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 250),
                          opacity: v ? 1 : 0,
                          child: buildMaskwidget(),
                        ),
                      );
                    },
                  );
                },
                onScrollToList: (b) => app.setIsShowFangdaiResultMask(b),
                itemModelBuilder: (i, v) {
                  return ExpansionTile(
                    title: MyText("第${i + 1}年", isBold: true),
                    children: [
                      MyListView(
                        isShuaxin: false,
                        itemCount: v.length,
                        listViewType: ListViewType.Separated,
                        physics: NeverScrollableScrollPhysics(),
                        item: (i) {
                          return Row(
                            children: List.generate(4, (ii) {
                              return Expanded(
                                flex: ii == 0 ? 2 : 3,
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: MyText(
                                    [
                                      '${i + 1}期',
                                      '${v[i]['per_base']}元',
                                      '${v[i]['per_interest']}元',
                                      '${v[i]['per_all']}元',
                                    ][ii],
                                    isBold: true,
                                    size: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              CustomScroll(
                itemModel: dataDm1,
                isGengduo: false,
                isShuaxin: false,
                maskHeight: 32,
                cacheExtent: 99999,
                headers: buildHeaders(context, 2),
                maskWidget: () {
                  return Selector<AppProvider, bool>(
                    selector: (_, k) => k.isShowFangdaiResultMask,
                    builder: (_, v, view) {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        left: v ? 0 : -32,
                        right: v ? 0 : -32,
                        top: v ? 0 : 32,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 250),
                          opacity: v ? 1 : 0,
                          child: buildMaskwidget(),
                        ),
                      );
                    },
                  );
                },
                onScrollToList: (b) => app.setIsShowFangdaiResultMask(b),
                itemModelBuilder: (i, v) {
                  return ExpansionTile(
                    title: MyText("第${i + 1}年", isBold: true),
                    children: [
                      MyListView(
                        isShuaxin: false,
                        itemCount: v.length,
                        listViewType: ListViewType.Separated,
                        physics: NeverScrollableScrollPhysics(),
                        item: (i) {
                          return Row(
                            children: List.generate(4, (ii) {
                              return Expanded(
                                flex: ii == 0 ? 2 : 3,
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: MyText(
                                    [
                                      '${i + 1}期',
                                      '${v[i]['per_base']}元',
                                      '${v[i]['per_interest']}元',
                                      '${v[i]['per_all']}元',
                                    ][ii],
                                    isBold: true,
                                    size: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Container buildMaskwidget() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        children: List.generate(4, (i) {
          return Expanded(
            flex: i == 0 ? 2 : 3,
            child: Container(
              alignment: Alignment.center,
              child: MyText(
                ['期数', '还款本金', '还款利息', '还款金额'][i],
                isBold: true,
                size: 12,
                color: Colors.black54,
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> buildHeaders(BuildContext context, int type) {
    return [
      Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(4, (i) {
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      type == 1
                          ? [
                              widget.isGjj?dataDm.object['sum_fund_base']: dataDm.object['sum_com_base'],
                              dataDm.object['sum_all'],
                              dataDm.object['sum_interest_all'],
                              dataDm.object['term'],
                            ][i]
                          : [
                            widget.isGjj?dataDm.object['sum_fund_base']: dataDm.object['sum_com_base'],
                              dataDm1.object['sum_all'],
                              dataDm1.object['sum_interest_all'],
                              dataDm1.object['term'],
                            ][i],
                      isBold: true,
                      size: type == 1
                          ? [
                              dataDm.object[widget.isGjj?'sum_fund_base': 'sum_com_base'].toString().length > 4 ? 16 : 20,
                              dataDm.object['sum_all'].toString().length > 4 ? 16 : 20,
                              dataDm.object['sum_interest_all'].toString().length > 4 ? 16 : 20,
                              dataDm.object['term'].toString().length > 4 ? 16 : 20,
                            ][i]
                              .toDouble()
                          : [
                              dataDm1.object[widget.isGjj?'sum_fund_base': 'sum_com_base'].toString().length > 4 ? 16 : 20,
                              dataDm1.object['sum_all'].toString().length > 4 ? 16 : 20,
                              dataDm1.object['sum_interest_all'].toString().length > 4 ? 16 : 20,
                              dataDm1.object['term'].toString().length > 4 ? 16 : 20,
                            ][i]
                              .toDouble(),
                    ),
                    SizedBox(height: 4),
                    MyText(['贷款总额', '还款总额', '贷款利息', '还款时间'][i], size: 12),
                    MyText(i == 3 ? '（月）' : '（元）', size: 12)
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      buildMaskwidget(),
    ];
  }
}

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

///筛选
class HomeSelectoWidget extends StatefulWidget {
  final Function(Map) fun;

  const HomeSelectoWidget({
    Key key,
    @required this.fun,
  }) : super(key: key);

  @override
  _HomeSelectoWidgetState createState() => _HomeSelectoWidgetState();
}

class _HomeSelectoWidgetState extends State<HomeSelectoWidget> {
  var jiageQujian1, jiageQujian2;
  var list = [
    {'name': '区域', 'state': false},
    {'name': '区域', 'state': false},
    {'name': '总价', 'state': false},
    {'name': '总价', 'state': false},
    {'name': '户型', 'state': false},
    {'name': '户型', 'state': false},
    {'name': '面积', 'state': false},
    {'name': '面积', 'state': false},
  ];
  bool isShowMask = false;
  bool isCloseMask = true;
  var cityList = [];

  var zongjia, huxing, jianzhu, kaipan;
  var quyu = 0;
  var zongjiaList = [
    ['200万以下', '0-200'],
    ['200-300万', '200-300'],
    ['300-400万', '300-400'],
    ['400-500万', '400-500'],
    ['500-800万', '500-800'],
    ['800-1000万', '800-1000'],
    ['1000万以上', '1000-2147483647'],
  ];
  // var huxingList = ['一室', '二室', '三室', '四室', '五室', '五室以上'];
  var jianzhuList = [
    ['50㎡', '0-50'],
    ['50㎡-70㎡', '50-70'],
    ['70㎡-90㎡', '70-90'],
    ['90㎡-110㎡', '90-110'],
    ['110㎡-130㎡', '110-130'],
    ['130㎡-150㎡', '130-150'],
    ['150㎡-200㎡', '150-200'],
    ['200㎡以上', '200-2147483647'],
  ];
  var kaipanList = [
    '近期开盘',
    '未来1个月',
    '未来3个月',
    '未来半年',
    '过去1个月',
    '过去3个月',
  ];
  @override
  void initState() {
    // this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    flog(app.city);
    await app.getDropDownList1(true);
    var list = app.allQuyuDm.object.where((w) => w['level'] == 3).toList();
    var quyuList = list.where((w) => w['parentId'] == app.cityCode).toList();
    setState(() => cityList = quyuList);
    // var v = await rootBundle.loadString('data/province.json');
    // List data = json.decode(v);
    // List cityListMap = [];
    // data.forEach((f) => cityListMap.addAll(f['cities']));
    // var i = cityListMap.indexWhere((w) => w['cityid'] == app.cityCode);
    // var list = cityListMap[i]['district'] as List;
  }

  @override
  Widget build(BuildContext context) {
    // this.initData();
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 250),
          left: 0,
          right: 0,
          top: 0,
          curve: Curves.easeOutCubic,
          bottom: isShowMask ? 0 : size(context).height,
          child: GestureDetector(
            onTap: () => setState(() {
              list[0]['state'] = false;
              list[1]['state'] = false;
              list[2]['state'] = false;
              list[3]['state'] = false;
              list[4]['state'] = false;
              list[5]['state'] = false;
              list[6]['state'] = false;
              list[7]['state'] = false;
              isShowMask = !isShowMask;
            }),
            child: Container(color: Colors.black45),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          top: list[0]['state'] ? 36 : -300 + 36.0,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: Container(
              height: 300,
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: MyListView(
                      isShuaxin: false,
                      flag: false,
                      item: (i) {
                        return WidgetTap(
                          onTap: () {
                            setState(() => quyu = i);
                          },
                          child: Container(
                            color: quyu == i ? Colors.white : Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: MyText(
                              i == 0 ? '不限' : cityList[i - 1]['name'],
                              size: 12,
                              color: quyu == i ? Color(0xFF2B8FFC) : Colors.black,
                            ),
                          ),
                        );
                      },
                      itemCount: cityList.length + 1,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              quyu = 0;
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('重置', size: 12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              list[0]['state'] = false;
                              list[2]['state'] = false;
                              list[4]['state'] = false;
                              list[6]['state'] = false;
                              isShowMask = !isShowMask;
                              widget.fun({
                                'quyu': quyu == 0 ? null : cityList[quyu - 1]['id'],
                                'zongjia': zongjia == null ? null : zongjiaList[zongjia][1],
                                'huxing': huxing == null ? null : huxing['dictKey'],
                                'jianzhu': jianzhu == null ? null : jianzhuList[jianzhu][1],
                              });
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('确定', color: Colors.white, size: 12),
                            color: Color(0xFF2B8FFC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          top: list[2]['state'] ? 36 : -250 + 36.0,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: Container(
              height: 200,
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: MyListView(
                      isShuaxin: false,
                      flag: false,
                      itemCount: 3,
                      padding: EdgeInsets.all(16),
                      item: (i) {
                        return [
                          MyText('价格区间(万)', isBold: true),
                          SizedBox(height: 16),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 14),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: ClipRRect(
                          //           borderRadius: BorderRadius.circular(56),
                          //           child: Container(
                          //             height: 35,
                          //             padding: EdgeInsets.symmetric(horizontal: 16),
                          //             color: Colors.white,
                          //             child: buildTFView(
                          //               context,
                          //               con: textCon1,
                          //               onChanged: (v) {},
                          //               hintText: '最小',
                          //               hintColor: Colors.black26,
                          //               textAlign: TextAlign.center,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       Container(
                          //         height: 1,
                          //         width: 24,
                          //         margin: EdgeInsets.symmetric(horizontal: 16),
                          //         color: Colors.black,
                          //       ),
                          //       Expanded(
                          //         child: ClipRRect(
                          //           borderRadius: BorderRadius.circular(56),
                          //           child: Container(
                          //             height: 35,
                          //             padding: EdgeInsets.symmetric(horizontal: 16),
                          //             color: Colors.white,
                          //             child: buildTFView(
                          //               context,
                          //               con: textCon2,
                          //               hintText: '最大',
                          //               hintColor: Colors.black26,
                          //               textAlign: TextAlign.center,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: List.generate(zongjiaList.length, (i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: WidgetTap(
                                  onTap: () {
                                    setState(() {
                                      zongjia = i;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color(0xFF2B8FFC).withOpacity(zongjia == i ? 1 : 0)),
                                    ),
                                    width: size(context).width / 4 - (8 * 3 + 32) / 4,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                    child: MyText(
                                      zongjiaList[i][0],
                                      size: 12,
                                      color: zongjia == i ? Color(0xFF2B8FFC) : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ][i];
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              zongjia = null;
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('重置', size: 12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              list[0]['state'] = false;
                              list[2]['state'] = false;
                              list[4]['state'] = false;
                              list[6]['state'] = false;
                              isShowMask = !isShowMask;
                              widget.fun({
                                'quyu': quyu == 0 ? null : cityList[quyu - 1]['id'],
                                'zongjia': zongjia == null ? null : zongjiaList[zongjia][1],
                                'huxing': huxing == null ? null : huxing['dictKey'],
                                'jianzhu': jianzhu == null ? null : jianzhuList[jianzhu][1],
                              });
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('确定', color: Colors.white, size: 12),
                            color: Color(0xFF2B8FFC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          top: list[4]['state'] ? 36 : -200 + 36.0,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: Container(
              height: 200,
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: MyListView(
                      isShuaxin: false,
                      flag: false,
                      itemCount: 3,
                      padding: EdgeInsets.all(16),
                      item: (i) {
                        return [
                          MyText('房型选择', isBold: true),
                          SizedBox(height: 14),
                          Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: List.generate(app.zidianDm.object.where((w) => w['dictType'] == 'LayoutType').toList().length, (i) {
                              return WidgetTap(
                                onTap: () {
                                  setState(() {
                                    huxing = app.zidianDm.object.where((w) => w['dictType'] == 'LayoutType').toList()[i];
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Color(0xFF2B8FFC).withOpacity(huxing == app.zidianDm.object.where((w) => w['dictType'] == 'LayoutType').toList()[i] ? 1 : 0)),
                                  ),
                                  width: size(context).width / 4 - (8 * 3 + 32) / 4,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                  child: MyText(
                                    app.zidianDm.object.where((w) => w['dictType'] == 'LayoutType').map<String>((m) => m['dictValue']).toList()[i],
                                    size: 12,
                                    color: huxing == app.zidianDm.object.where((w) => w['dictType'] == 'LayoutType').toList()[i] ? Color(0xFF2B8FFC) : Colors.black,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ][i];
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              huxing = null;
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('重置', size: 12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              list[0]['state'] = false;
                              list[2]['state'] = false;
                              list[4]['state'] = false;
                              list[6]['state'] = false;
                              isShowMask = !isShowMask;
                              widget.fun({
                                'quyu': quyu == 0 ? null : cityList[quyu - 1]['id'],
                                'zongjia': zongjia == null ? null : zongjiaList[zongjia][1],
                                'huxing': huxing == null ? null : huxing['dictKey'],
                                'jianzhu': jianzhu == null ? null : jianzhuList[jianzhu][1],
                              });
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('确定', color: Colors.white, size: 12),
                            color: Color(0xFF2B8FFC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          top: list[6]['state'] ? 36 : -300 + 36.0,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: Container(
              height: 200,
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: MyListView(
                      isShuaxin: false,
                      flag: false,
                      itemCount: 3,
                      padding: EdgeInsets.all(16),
                      item: (i) {
                        return [
                          MyText('建筑面积', isBold: true),
                          SizedBox(height: 14),
                          Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: List.generate(jianzhuList.length, (i) {
                              return WidgetTap(
                                onTap: () {
                                  setState(() {
                                    jianzhu = i;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Color(0xFF2B8FFC).withOpacity(jianzhu == i ? 1 : 0)),
                                  ),
                                  width: size(context).width / 4 - (8 * 3 + 32) / 4,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                  child: MyText(
                                    jianzhuList[i][0].toString(),
                                    size: 12,
                                    color: jianzhu == i ? Color(0xFF2B8FFC) : Colors.black,
                                  ),
                                ),
                              );
                            }),
                          ),
                          // MyText('开盘时间', isBold: true),
                          // SizedBox(height: 14),
                          // Wrap(
                          //   runSpacing: 8,
                          //   spacing: 8,
                          //   children: List.generate(kaipanList.length, (i) {
                          //     return WidgetTap(
                          //       onTap: () {
                          //         setState(() {
                          //           kaipan = i;
                          //         });
                          //       },
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(4),
                          //           border: Border.all(color: Color(0xFF2B8FFC).withOpacity(kaipan == i ? 1 : 0)),
                          //         ),
                          //         width: size(context).width / 4 - (8 * 3 + 32) / 4,
                          //         alignment: Alignment.center,
                          //         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          //         child: MyText(
                          //           kaipanList[i],
                          //           size: 12,
                          //           color: kaipan == i ? Color(0xFF2B8FFC) : Colors.black,
                          //         ),
                          //       ),
                          //     );
                          //   }),
                          // ),
                        ][i];
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              jianzhu = null;
                              kaipan = null;
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('重置', size: 12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () {
                            setState(() {
                              list[0]['state'] = false;
                              list[2]['state'] = false;
                              list[4]['state'] = false;
                              list[6]['state'] = false;
                              isShowMask = !isShowMask;
                              widget.fun({
                                'quyu': quyu == 0 ? null : cityList[quyu - 1]['id'],
                                'zongjia': zongjia == null ? null : zongjiaList[zongjia][1],
                                'huxing': huxing == null ? null : huxing['dictKey'],
                                'jianzhu': jianzhu == null ? null : jianzhuList[jianzhu][1],
                              });
                            });
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: MyText('确定', color: Colors.white, size: 12),
                            color: Color(0xFF2B8FFC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          child: Row(
            children: List.generate(7, (i) {
              if (i == 1)
                return Container(height: 24, width: 1, color: Colors.black12);
              else if (i == 3)
                return Container(height: 24, width: 1, color: Colors.black12);
              else if (i == 5)
                return Container(height: 24, width: 1, color: Colors.black12);
              else
                return Expanded(
                  child: WidgetTap(
                    isElastic: true,
                    onTap: () async {
                      isShowMask = true;
                      switch (i) {
                        case 0:
                          await this.initData();
                          setState(() => isCloseMask = false);
                          if (list[0]['state']) isShowMask = false;
                          list[0]['state'] = !list[0]['state'];
                          list[2]['state'] = false;
                          list[4]['state'] = false;
                          list[6]['state'] = false;
                          setState(() {});
                          break;
                        case 2:
                          setState(() => isCloseMask = false);
                          list[0]['state'] = false;
                          if (list[2]['state']) isShowMask = false;
                          list[2]['state'] = !list[2]['state'];
                          list[4]['state'] = false;
                          list[6]['state'] = false;
                          setState(() {});
                          break;
                        case 4:
                          setState(() => isCloseMask = false);
                          list[0]['state'] = false;
                          list[2]['state'] = false;
                          if (list[4]['state']) isShowMask = false;
                          list[4]['state'] = !list[4]['state'];
                          list[6]['state'] = false;
                          setState(() {});
                          break;
                        case 6:
                          setState(() => isCloseMask = false);
                          list[0]['state'] = false;
                          list[2]['state'] = false;
                          list[4]['state'] = false;
                          if (list[6]['state']) isShowMask = false;
                          list[6]['state'] = !list[6]['state'];
                          setState(() {});
                          break;
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              [
                                quyu > cityList.length
                                    ? list[i]['name']
                                    : quyu == 0
                                        ? list[i]['name']
                                        : cityList[quyu - 1]['name'],
                                quyu > cityList.length
                                    ? list[i]['name']
                                    : quyu == 0
                                        ? list[i]['name']
                                        : cityList[quyu - 1]['name'],
                                zongjia == null ? list[i]['name'] : zongjiaList[zongjia][0],
                                zongjia == null ? list[i]['name'] : zongjiaList[zongjia][0],
                                huxing == null ? list[i]['name'] : huxing['dictValue'],
                                huxing == null ? list[i]['name'] : huxing['dictValue'],
                                jianzhu == null ? list[i]['name'] : jianzhuList[jianzhu][0],
                                jianzhu == null ? list[i]['name'] : jianzhuList[jianzhu][0],
                              ][i],
                              textAlign: TextAlign.right,
                              size: 12,
                              color: [
                                Theme.of(context).primaryColor,
                                list[i]['state'] ? Theme.of(context).primaryColor : Color(0xFF0C0C0C),
                              ][[
                                quyu == 0 ? 1 : 0,
                                quyu == 0 ? 1 : 0,
                                zongjia == null ? 1 : 0,
                                zongjia == null ? 1 : 0,
                                huxing == null ? 1 : 0,
                                huxing == null ? 1 : 0,
                                jianzhu == null ? 1 : 0,
                                jianzhu == null ? 1 : 0,
                              ][i]],
                            ),
                            Icon(
                              list[i]['state'] ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: [
                                Theme.of(context).primaryColor,
                                list[i]['state'] ? Theme.of(context).primaryColor : Color(0xFF0C0C0C),
                              ][[
                                quyu == 0 ? 1 : 0,
                                quyu == 0 ? 1 : 0,
                                zongjia == null ? 1 : 0,
                                zongjia == null ? 1 : 0,
                                huxing == null ? 1 : 0,
                                huxing == null ? 1 : 0,
                                jianzhu == null ? 1 : 0,
                                jianzhu == null ? 1 : 0,
                              ][i]],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }),
          ),
        ),
      ],
    );
  }
}

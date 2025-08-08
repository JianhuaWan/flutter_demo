import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/config/common_config.dart';
import 'package:flutter_app/page/shopping_page.dart';
import 'package:flutter_app/util/comon.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/no_sliding_return.dart';
import 'package:flutter_app/widget/tab_link_widget.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/photo_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'loupan_info.dart';
import 'package:http/http.dart' as request;

class LoupanPage extends StatefulWidget {
  final Map data;
  final bool isZhaofang;

  const LoupanPage({
    Key? key,
    required this.data,
    this.isZhaofang = false,
  }) : super(key: key);

  @override
  _LoupanPageState createState() => _LoupanPageState();
}

class _LoupanPageState extends State<LoupanPage> with NoSlidingReturn {
  ScrollController con = ScrollController();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiBuildingGetEntity(isRef: true);
    await this.apiCommentGetPageList(isRef: true);
    await this.apiQuestionGetPageList(isRef: true);
  }

  ///获取楼盘详情
  var loupanDm = DataModel(hasNext: false);

  Future<int> apiBuildingGetEntity({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetEntity',
      data: {"id": widget.data['id']},
      catchError: (v) {
        // 当请求失败时，手动生成默认数据
        Map<String, dynamic> defaultBuildingData = {
          'id': widget.data['id'] ?? 1,
          'buildingName': '默认楼盘名称',
          'consultAvgPrice': 20000,
          'buildType': '住宅',
          'propertyType': '商品房',
          'saleStatus': '在售',
          'buildAddress': '默认地址',
          'cityName': '上海市',
          'areaName': '浦东新区',
          'award': '购房优惠：每平方米立减500元',
          'introduce':
              '这是一个默认的楼盘介绍信息。该楼盘位于市中心繁华地段，交通便利，周边配套设施齐全。小区绿化率高，环境优美，是您理想的居住选择。',
          'hubs': [
            {
              'images':
                  'https://via.placeholder.com/400x300/CCCCCC/FFFFFF?text=默认户型图1',
              'layout': '三室两厅',
              'area': 120,
              'price': 20000,
            },
            {
              'images':
                  'https://via.placeholder.com/400x300/CCCCCC/FFFFFF?text=默认户型图2',
              'layout': '两室一厅',
              'area': 90,
              'price': 18000,
            }
          ],
          'position': '121.473701,31.230402', // 默认位置坐标(上海)
          'agent': {
            'phoneNumber': '400-888-9999',
          },
          'isFavorite': false,
        };
        loupanDm.object = defaultBuildingData;
        loupanDm.setTime();
      },
      success: (v) {
        loupanDm.object = v['data'];
        loupanDm.setTime();
      },
    );
    setState(() {});
    return loupanDm.flag!;
  }

  ///获取楼盘问答
  var wendaDm = DataModel(hasNext: false);

  Future<int> apiQuestionGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Question/GetPageList',
      data: {
        "PageSize": "10",
        "PageIndex": page,
        "buildingId": widget.data['id']
      },
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultQuestions = [
          {
            'id': 1,
            'content': '这个楼盘的最新价格是多少？有没有优惠活动？',
            'userName': '购房者1',
            'replyUserName': '销售顾问',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
            'baseModifyTime':
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
            'level': 1,
            'parentId': 0,
          },
          {
            'id': 2,
            'content': '目前在售的户型有哪些？各自的面积和价格是怎样的？',
            'userName': '购房者2',
            'replyUserName': '销售顾问',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
            'baseModifyTime':
                DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
            'level': 1,
            'parentId': 0,
          },
          {
            'id': 3,
            'content': '周边的配套设施怎么样？交通便利吗？',
            'userName': '购房者3',
            'replyUserName': '销售顾问',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
            'baseModifyTime': DateTime.now().toIso8601String(),
            'level': 1,
            'parentId': 0,
          },
        ];

        List<Map<String, dynamic>> defaultAnswers = [
          {
            'id': 4,
            'content': '您好，目前我们楼盘均价为每平方米20000元，现在有特价房源和首付分期活动，详情请到售楼处咨询。',
            'userName': '购房者1',
            'replyUserName': '销售顾问',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
            'baseModifyTime':
                DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
            'level': 2,
            'parentId': 1,
          },
          {
            'id': 5,
            'content': '我们目前在售的户型有70-120平米的一居室到三居室，具体价格根据楼层和朝向有所不同。',
            'userName': '购房者2',
            'replyUserName': '销售顾问',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
            'baseModifyTime':
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
            'level': 2,
            'parentId': 2,
          },
          {
            'id': 6,
            'content': '项目周边有地铁站、学校和商场，交通非常便利，生活配套齐全。',
            'userName': '购房者3',
            'replyUserName': '销售顾问',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
            'baseModifyTime':
                DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
            'level': 2,
            'parentId': 3,
          },
        ];

        wendaDm.addList(defaultQuestions, isRef, defaultQuestions.length);
        wendaDm.value = defaultAnswers;
      },
      success: (v) {
        wendaDm.addList(v['data'], isRef, v['total']);
        var list = v['data'] as List;
        var list2 = list.where((w) => w['level'] == 2).toList();
        list = list.where((w) => w['level'] == 1).toList();
        wendaDm.addList(list, isRef, v['total']);
        wendaDm.value = list2;
      },
    );
    flog(wendaDm.toJson());
    setState(() {});
    return wendaDm.flag!;
  }

  ///获取楼盘点评
  var loupanDianpingDm = DataModel(hasNext: false);

  Future<int> apiCommentGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Comment/GetPageList',
      data: {
        "PageSize": "10",
        "PageIndex": page,
        "buildingId": widget.data['id'],
      },
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultComments = [
          {
            'id': 1,
            'content': '这个楼盘的地理位置非常优越，交通便利，周边配套设施齐全。',
            'tag': '优点',
            'portrait':
                'https://via.placeholder.com/400x400/CCCCCC/FFFFFF?text=用户1',
            'userName': '用户1',
            'baseCreateTime': DateTime.now().toIso8601String(),
          },
          {
            'id': 2,
            'content': '房子质量不错，但价格略高，希望能有一些优惠活动。',
            'tag': '缺点',
            'portrait':
                'https://via.placeholder.com/400x400/CCCCCC/FFFFFF?text=用户2',
            'userName': '用户2',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
          },
          {
            'id': 3,
            'content': '物业服务很好，小区环境优美，适合居住。',
            'tag': '优点',
            'portrait':
                'https://via.placeholder.com/400x400/CCCCCC/FFFFFF?text=用户3',
            'userName': '用户3',
            'baseCreateTime':
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
          },
        ];
        loupanDianpingDm.addList(
            defaultComments, isRef, defaultComments.length);
      },
      success: (v) {
        loupanDianpingDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return loupanDianpingDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: widget.data == null
          ? Center(child: MyText('暂无数据'))
          : AnimatedSwitchBuilder(
              value: loupanDm,
              errorOnTap: () => this.apiBuildingGetEntity(),
              objectBuilder: (obj) {
                return ScaffoldWidget(
                  btnBar: buildBtnbar(),
                  body: Stack(
                    children: [
                      TabLinkWidget(
                        key: ValueKey(2),
                        con: this.con,
                        headers: [
                          '房源',
                          '楼盘动态',
                          if (loupanDm.object['hubs'].length != 0) '户型介绍',
                          '楼盘点评',
                          '楼盘问答',
                          if (loupanDm.object['position'] != '') '周边配套',
                          '补贴佣金',
                        ],
                        // isScrollable: false,
                        listPadding:
                            EdgeInsets.only(top: padd(context).top + 55),
                        headerBar: (i, v) => Container(
                            height: i == 0 ? 0 : 17, color: Colors.transparent),
                        labelPadding: EdgeInsets.symmetric(horizontal: 16),
                        indicatorPadding: EdgeInsets.only(bottom: 4),
                        tabBarTop: 56 + padd(context).top,
                        dividerHeight: 17,
                        isShadow: true,
                        listBar: [
                          TweenWidget(
                            axis: Axis.vertical,
                            value: 200,
                            time: 1000,
                            curve: ElasticOutCurve(1),
                            child: buildItem1(),
                          ),
                          buildItem001(),
                          if (loupanDm.object['hubs'].length != 0)
                            TweenWidget(
                              axis: Axis.vertical,
                              value: 200,
                              delayed: 100,
                              time: 1000,
                              curve: ElasticOutCurve(1),
                              child: buildItem2(),
                            ),
                          buildItem3(),
                          buildItem4(),
                          if (loupanDm.object['position'] != '') buildItem5(),
                          buildItem002(),
                        ],
                      ),
                      buildTitle(
                        context,
                        title: obj['buildingName'] ?? '楼盘名称',
                        color: Colors.white,
                        rigthWidget: !true && !true
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(Icons.share_outlined),
                              ),
                        rightCallback: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) {
                              return ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Container(
                                  color: Colors.white,
                                  child: Container(
                                    margin: EdgeInsets.all(16),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    child: Row(
                                        children: List.generate(3, (i) {
                                      return Expanded(
                                        child: WidgetTap(
                                          isElastic: true,
                                          onTap: () async {
                                            close();
                                            switch (i) {
                                              case 0:
                                                break;
                                              case 1:
                                                break;
                                              case 2:
                                                buildShowDialog(context);
                                                var res = await request.get(
                                                    Uri.parse(loupanDm
                                                        .object['images']
                                                        .toString()
                                                        .split(';')
                                                        .first));
                                                close();
                                                break;
                                            }
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 16),
                                              Image.asset(
                                                [
                                                  'assets/img/yaoqing_qq.png',
                                                  'assets/img/yaoqing_qq.png',
                                                  'assets/img/yaoqing_qq.png',
                                                ][i],
                                                width: 42,
                                                height: 42,
                                              ),
                                              SizedBox(height: 8),
                                              MyText(
                                                [
                                                  '微信',
                                                  '朋友圈',
                                                  '微博',
                                                ][i],
                                                size: 12,
                                              ),
                                              SizedBox(height: 16),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        isShowBorder: true,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Container buildBtnbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Row(
        children: [
          SizedBox(width: 25),
          Row(
            children: [
              TweenWidget(
                axis: Axis.vertical,
                time: 1000,
                curve: ElasticOutCurve(0.5),
                value: 50,
                delayed: 200,
                child: WidgetTap(
                  isElastic: true,
                  onTap: () {
                    ComonUtil.isLogin(() {
                      setState(() {
                        loupanDm.object['isFavorite'] =
                            !loupanDm.object['isFavorite'];
                      });
                      Request.put(
                        '/api/Building/Favorite',
                        data: {'id': widget.data['id']},
                        catchError: (v) {
                          showToast(v);
                          setState(() {
                            loupanDm.object['isFavorite'] =
                                !loupanDm.object['isFavorite'];
                          });
                        },
                      );
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        loupanDm.object['isFavorite']
                            ? 'assets/img/no_shoucang.png'
                            : 'assets/img/loupan_shoucang.png',
                        width: 22,
                        height: 22,
                      ),
                      SizedBox(height: 6),
                      MyText('收藏', size: 10)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 25),
              TweenWidget(
                axis: Axis.vertical,
                time: 1000,
                delayed: 300,
                curve: ElasticOutCurve(0.5),
                value: 50,
                child: WidgetTap(
                  isElastic: true,
                  onTap: () {
                    if (loupanDm.object['agent'] != null) {
                      phoneTelURL(loupanDm.object['agent']['phoneNumber']);
                    } else {
                      showToast('暂无电话');
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_in_talk_outlined),
                      // Image.asset(
                      //   'assets/img/loupan_tuijian.png',
                      //   width: 22,
                      //   height: 22,
                      // ),
                      SizedBox(height: 6),
                      MyText('电话', size: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 9),
          Expanded(
            child: BtnWidget(
              isShowShadow: false,
              titles: ['管家', '推荐'],
              axis: [Axis.vertical, Axis.vertical],
              time: [1000, 1000],
              value: [50, 50],
              delayed: [400, 500],
              curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
              onTap: [
                () {
                  ComonUtil.isLogin(() async {
                    try {
                      if (loupanDm.object['agent'] != null) {
                        // if (chat.isInit == 0) {
                        //   showToast('请先初始化聊天页面');
                        // } else {
                        Map arg = {
                          "coversationType": 1,
                          "targetId": loupanDm.object['agent']['userId'],
                        };
                        // jumpPage(
                        // ConversationPage(
                        //   arguments: arg,
                        //   data: loupanDm.object,
                        //   msgClick: (v) {
                        //     jumpPage(LoupanPage(data: v));
                        //   },
                        // ),
                        // );
                        // }
                      } else {
                        showToast('暂无管家');
                      }
                    } catch (e) {
                      flog(e.toString());
                      showToast('服务器响应错误');
                    }
                  });
                },
                () {
                  ComonUtil.isLogin(() async {
                    jumpPage(
                      ShoppingPage(
                        isHome: false,
                        data: loupanDm.object,
                      ),
                    );
                  });
                  // phoneTelURL(loupanDm.object['agent']['phoneNumber']);
                }
              ],
            ),
          ),
        ],
      ),
    );
  }

  MyColumn buildItem6() {
    return MyColumn(
      color: Colors.white,
      children: [
        SizedBox(height: 17),
        BigTitleWidget(title: '项目信息'),
        Padding(
          padding: EdgeInsets.only(left: 17, top: 15),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: MyText(
                  '时间线',
                  color: Colors.black54,
                  isBold: true,
                ),
              ),
              Expanded(
                flex: 1,
                child: MyText(
                  '开盘/交付',
                  size: 12,
                  textAlign: TextAlign.center,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                flex: 1,
                child: MyText(
                  '楼栋',
                  size: 12,
                  textAlign: TextAlign.center,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        MyListView(
          isShuaxin: false,
          item: (i) {
            return Container(
              padding: EdgeInsets.only(left: 17, top: 15, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MyText(
                      '2021.03.23',
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MyText(
                      '开盘',
                      size: 12,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MyText(
                      '20栋1单元',
                      size: 12,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: 3,
          physics: NeverScrollableScrollPhysics(),
          listViewType: ListViewType.Separated,
        ),
        Divider(thickness: 1.5, height: 0),
        Padding(
          padding: EdgeInsets.only(left: 17, top: 15),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: MyText(
                  '售卖资格',
                  color: Colors.black54,
                  isBold: true,
                ),
              ),
              Expanded(
                flex: 1,
                child: MyText(
                  '发证时间',
                  size: 12,
                  textAlign: TextAlign.center,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                flex: 1,
                child: MyText(
                  '楼栋',
                  size: 12,
                  textAlign: TextAlign.center,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        MyListView(
          isShuaxin: false,
          item: (i) {
            return Container(
              padding: EdgeInsets.only(left: 17, top: 15, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MyText(
                      '房产售卖资格',
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MyText(
                      '2021.02.03',
                      size: 12,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MyText(
                      '20栋1单元',
                      size: 12,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: 3,
          physics: NeverScrollableScrollPhysics(),
          listViewType: ListViewType.Separated,
        ),
        Divider(thickness: 1.5, height: 0),
        Padding(
          padding: EdgeInsets.only(left: 17, top: 15),
          child: MyText(
            '项目奖励规则',
            color: Colors.black54,
            isBold: true,
          ),
        ),
        MyListView(
          isShuaxin: false,
          item: (i) {
            return Container(
              padding: EdgeInsets.only(left: 17, top: 15, bottom: 15),
              child: MyText(
                loupanDm.object['award'],
                color: Colors.black54,
              ),
            );
          },
          itemCount: 1,
          physics: NeverScrollableScrollPhysics(),
          listViewType: ListViewType.Separated,
        ),
      ],
    );
  }

  MyColumn buildItem5() {
    return MyColumn(
      color: Colors.white,
      padding: EdgeInsets.all(17),
      children: [
        BigTitleWidget(
          isPadding: false,
          title: '周边配套',
        ),
        if (loupanDm.object['position'] != null)
          if (Platform.isAndroid)
            Container(
              height: 130,
              margin: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              // child: MapPage(
              //   longitude: loupanDm.object['position'].toString().split(',')[0],
              //   latitude: loupanDm.object['position'].toString().split(',')[1],
              //   gesturesEnabled: false,
              //   isMove: false,
              // ),
            )
          else if (!widget.isZhaofang)
            Container(
              height: 130,
              margin: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              // child: MapPage(
              //   longitude: loupanDm.object['position'].toString().split(',')[0],
              //   latitude: loupanDm.object['position'].toString().split(',')[1],
              //   gesturesEnabled: false,
              //   isMove: false,
              // ),
            )
          else
            SizedBox(height: 10),
        MyText(
          '位置：',
          size: 12,
          isBold: true,
          color: Colors.grey,
          children: [
            MyText.ts(
              '${loupanDm.object['cityName']}${loupanDm.object['areaName']}${loupanDm.object['buildAddress']}',
              isBold: true,
              size: 12,
              color: Common.black,
            ),
          ],
        ),
        if (loupanDm.object['position'] != null)
          ZhoubianWidget(loupanDm.object),
      ],
    );
  }

  MyColumn buildItem4() {
    return MyColumn(
      color: Colors.white,
      padding: EdgeInsets.all(17),
      children: [
        BigTitleWidget(
          isPadding: false,
          title: '楼盘问答（${wendaDm.list.length}）',
          isShowMore: true,
          onTap: () {
            jumpPage(LoupanWendaPage(data: widget.data));
          },
        ),
        SizedBox(height: 15),
        MyListView(
          isShuaxin: false,
          itemCount: wendaDm.list.length,
          divider: Divider(height: 20),
          physics: NeverScrollableScrollPhysics(),
          listViewType: ListViewType.Separated,
          item: (i) {
            return Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        height: 20,
                        width: 20,
                        color: Color(0xffF95136),
                        alignment: Alignment.center,
                        child: MyText('问', size: 12, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: MyText(
                        wendaDm.list[i]['content'],
                        isBold: true,
                        color: Common.black,
                      ),
                    )
                  ],
                ),
                if (wendaDm.value
                    .where((w) => w['parentId'] == wendaDm.list[i]['id'])
                    .isNotEmpty)
                  SizedBox(height: 11),
                if (wendaDm.value
                    .where((w) => w['parentId'] == wendaDm.list[i]['id'])
                    .isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MyListView(
                      isShuaxin: false,
                      physics: NeverScrollableScrollPhysics(),
                      listViewType: ListViewType.Separated,
                      itemCount: wendaDm.value
                          .where((w) => w['parentId'] == wendaDm.list[i]['id'])
                          .length,
                      item: (ii) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          color: Color(0xffF5F5F5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: WrapperImage(
                                      height: 35,
                                      width: 35,
                                      urlBuilder: () => wendaDm.value
                                          .where((w) =>
                                              w['parentId'] ==
                                              wendaDm.list[i]['id'])
                                          .toList()[ii]['replyUserPortrait'],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          wendaDm.value
                                              .where((w) =>
                                                  w['parentId'] ==
                                                  wendaDm.list[i]['id'])
                                              .toList()[ii]['replyUserName'],
                                          isBold: true,
                                          color: Common.black,
                                        ),
                                        SizedBox(height: 2),
                                        MyText(
                                          toTime(wendaDm.value
                                              .where((w) =>
                                                  w['parentId'] ==
                                                  wendaDm.list[i]['id'])
                                              .toList()[ii]['baseModifyTime']),
                                          size: 9,
                                          color: Common.black,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 8),
                              MyText(
                                wendaDm.value
                                    .where((w) =>
                                        w['parentId'] == wendaDm.list[i]['id'])
                                    .toList()[ii]['content'],
                                size: 12,
                                isOverflow: false,
                                color: Common.black,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                // if (wendaDm.list[i]['replyUserName'] != null) SizedBox(height: 11),
                // if (wendaDm.list[i]['replyUserName'] != null)
                //   Container(
                //     padding: EdgeInsets.all(17),
                //     color: Color(0xffF5F5F5),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             ClipOval(
                //               child: WrapperImage(
                //                 height: 35,
                //                 width: 35,
                //                 urlBuilder: () => wendaDm.list[i]['replyUserPortrait'],
                //               ),
                //             ),
                //             SizedBox(width: 8),
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   MyText(
                //                     wendaDm.list[i]['replyUserName'],
                //                     isBold: true,
                //                     color: Common.black,
                //                   ),
                //                   SizedBox(height: 2),
                //                   MyText(
                //                     toTime(wendaDm.list[i]['baseModifyTime']),
                //                     size: 9,
                //                     color: Common.black,
                //                   ),
                //                 ],
                //               ),
                //             )
                //           ],
                //         ),
                //         SizedBox(height: 8),
                //         MyText(
                //           wendaDm.list[i]['replyUserName'],
                //           size: 12,
                //           isOverflow: false,
                //           color: Common.black,
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            );
          },
        ),
        if (wendaDm.list.isNotEmpty) SizedBox(height: 15),
        WidgetTap(
          isElastic: true,
          onTap: () async {
            ComonUtil.isLogin(() async {
              showSelecto(context!, texts: [
                "房子现在什么价格?",
                "最新有什么优惠政策?",
                "最高返佣多少?",
                "这套房首付是多少?",
                "目前还有哪些户型在售?",
              ], callback: (v, i) {
                Request.post(
                  '/api/Question/Create',
                  data: {
                    "buildingId": widget.data['id'],
                    "content": v,
                    "buildingName": widget.data['buildingName'],
                    "questionType": 0,
                    "baseIsDelete": true,
                    "level": 0,
                  },
                  isLoading: true,
                  catchError: (v) => showToast(v),
                  fail: (v) => showToast(v),
                  success: (v) {
                    showToast('提交成功！');
                    this.apiQuestionGetPageList(isRef: true);
                  },
                );
              });
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12),
            color: Common.smallColor.withOpacity(0.1),
            child: MyText(
              '我要提问',
              isBold: true,
              color: Common.smallColor,
            ),
          ),
        ),
      ],
    );
  }

  MyColumn buildItem3() {
    return MyColumn(
      color: Colors.white,
      padding: EdgeInsets.all(17),
      children: [
        BigTitleWidget(
          isPadding: false,
          title: '楼盘点评（${loupanDianpingDm.list.length})',
          isShowMore: true,
          onTap: () {
            jumpPage(LoupanDianpingPage(data: widget.data));
          },
        ),
        SizedBox(height: 15),
        MyListView(
          isShuaxin: false,
          divider: Divider(height: 20),
          itemCount: loupanDianpingDm.list.length,
          physics: NeverScrollableScrollPhysics(),
          listViewType: ListViewType.Separated,
          item: (i) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: WrapperImage(
                    // imageType: ImageType.random,
                    height: 35,
                    width: 35,
                    urlBuilder: () => loupanDianpingDm.list[i]['portrait'],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: MyColumn(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(56),
                              color: loupanDianpingDm.list[i]['tag'] == '优点'
                                  ? Color(0xffF7DDA9)
                                  : Common.smallColor.withOpacity(0.1),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: MyText(
                              loupanDianpingDm.list[i]['tag'],
                              color: loupanDianpingDm.list[i]['tag'] == '优点'
                                  ? Common.black
                                  : Common.black,
                              size: 12,
                              isBold: true,
                            ),
                          ),
                          Expanded(
                            child: MyText(
                              toTime(
                                  loupanDianpingDm.list[i]['baseCreateTime']),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: MyText(
                          loupanDianpingDm.list[i]['content'],
                          isOverflow: false,
                          color: Common.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        if (loupanDianpingDm.list.isNotEmpty) SizedBox(height: 15),
        WidgetTap(
          isElastic: true,
          onTap: () {
            ComonUtil.isLogin(() async {
              var res = await showGeneralDialog(
                context: context!,
                barrierColor: Colors.transparent,
                pageBuilder: (_, __, ___) {
                  return DianpingTanChuang(widget.data['id'], type: 0);
                },
              );
              if (res != null) {
                this.apiCommentGetPageList(isRef: true);
              }
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12),
            color: Common.smallColor.withOpacity(0.1),
            child: MyText(
              '写评论',
              isBold: true,
              color: Common.smallColor,
            ),
          ),
        ),
      ],
    );
  }

  MyColumn buildItem001() {
    return MyColumn(
      color: Colors.white,
      padding: EdgeInsets.all(17),
      children: [
        BigTitleWidget(
          isPadding: false,
          title: '楼盘动态',
        ),
        SizedBox(height: 15),
        // Html(data: loupanDm.object['projectTrends']),
      ],
    );
  }

  MyColumn buildItem002() {
    flog(loupanDm.object['awardTrends'], '补贴佣金');
    return MyColumn(
      color: Colors.white,
      padding: EdgeInsets.all(17),
      children: [
        BigTitleWidget(
          isPadding: false,
          title: '补贴佣金',
        ),
        SizedBox(height: 15),
        // Html(
        //   data: loupanDm.object['awardTrends'],
        // ),
      ],
    );
  }

  Widget buildItem2() {
    if (loupanDm.object['hubs'].length == 0) {
      return SizedBox();
      // return MyColumn(
      //   color: Colors.white,
      //   padding: EdgeInsets.all(17),
      //   children: [
      //     BigTitleWidget(
      //       isPadding: false,
      //       title: '户型介绍',
      //     ),
      //     Container(
      //       alignment: Alignment.center,
      //       padding: EdgeInsets.symmetric(vertical: 16),
      //       child: MyText('暂无户型', color: Colors.black26),
      //     ),
      //   ],
      // );
    } else {
      return MyColumn(
        color: Colors.white,
        padding: EdgeInsets.all(17),
        children: [
          BigTitleWidget(
            isPadding: false,
            title: '户型介绍',
            isShowMore: true,
            onTap: () => jumpPage(HuxingPage(list: loupanDm.object['hubs'])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: WidgetTap(
              isElastic: true,
              onTap: () {
                jumpPage(
                  PhotoView(
                    images: loupanDm.object['hubs'][0]['images']
                        .toString()
                        .split(';'),
                    isUrl: true,
                  ),
                  isMoveBtm: true,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: WrapperImage(
                  height: 135,
                  urlBuilder: () => loupanDm.object['hubs'][0]['images']
                      .toString()
                      .split(';')[0],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: MyText(
                  '房型：',
                  size: 13,
                  color: Common.black,
                  children: [
                    MyText.ts(
                      '${loupanDm.object['hubs'][0]['layout']}',
                      isBold: true,
                      color: Common.black,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MyText(
                  '面积：',
                  size: 13,
                  textAlign: TextAlign.right,
                  color: Common.black,
                  children: [
                    MyText.ts(
                      '${loupanDm.object['hubs'][0]['area']}㎡',
                      isBold: true,
                      color: Common.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 9),
          MyText(
            '价格：',
            size: 13,
            color: Common.black,
            children: [
              MyText.ts(
                '${loupanDm.object['hubs'][0]['price']}',
                isBold: true,
                color: Color(0xffFF781D),
              ),
            ],
          ),
        ],
      );
    }
  }

  Column buildItem1() {
    return Column(
      children: [
        if (loupanDm.object['introduce'].length > 0)
          LunboWidget(loupanDm.object),
        MyColumn(
          color: Colors.white,
          padding: EdgeInsets.all(17),
          children: [
            Row(
              children: [
                Expanded(
                  child: MyText(
                    loupanDm.object['buildingName'],
                    size: 20,
                    isBold: true,
                    color: Common.black,
                  ),
                ),
                MyText(
                  '均价',
                  size: 12,
                  color: Color(0xffFF6904),
                  children: [
                    MyText.ts(
                      '${loupanDm.object['consultAvgPrice']}',
                      isBold: true,
                      size: 14,
                    ),
                    MyText.ts('元/㎡'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: List.generate(3, (i) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56),
                          border: Border.all(
                              color: Theme.of(context!).primaryColor),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        child: MyText(
                          [
                            loupanDm.object['buildType'],
                            loupanDm.object['propertyType'],
                            loupanDm.object['saleStatus'],
                          ][i],
                          color: Common.smallColor,
                          size: 12,
                        ),
                      );
                    }),
                  ),
                ),
                WidgetTap(
                  isElastic: true,
                  onTap: () => jumpPage(LoupanInfo(data: loupanDm.object)),
                  child: Row(
                    children: [
                      MyText(
                        '项目详情',
                        color: Common.smallColor,
                        isBold: true,
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: Common.smallColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: MyText(
                    '楼盘地址：',
                    size: 16,
                    isBold: true,
                    color: Colors.grey,
                    children: [
                      MyText.ts(
                        loupanDm.object['areaName'],
                        isBold: true,
                        color: Common.black,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MyText(
                    '面积：',
                    size: 16,
                    isBold: true,
                    color: Colors.grey,
                    children: [
                      MyText.ts(
                        '${loupanDm.object['buildingArea']}㎡',
                        isBold: true,
                        color: Common.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/home_chakan.png',
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 4),
                MyText(
                  loupanDm.object['views'],
                  color: Color(0xff666666),
                  isBold: true,
                ),
                SizedBox(width: 28),
                Image.asset(
                  'assets/img/home_fenxiang.png',
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 2),
                MyText(
                  loupanDm.object['shares'],
                  color: Color(0xff666666),
                  isBold: true,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: WidgetTap(
                    onTap: () {
                      ComonUtil.isLogin(() {
                        showGeneralDialog(
                          context: context!,
                          barrierColor: Colors.transparent,
                          pageBuilder: (_, __, ___) {
                            return TanChuang(widget.data['id'], type: 0);
                          },
                        );
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: Theme.of(context!).primaryColor.withOpacity(0.1),
                      child: MyText(
                        '价格变动提醒',
                        isBold: true,
                        color: Common.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: WidgetTap(
                    onTap: () {
                      ComonUtil.isLogin(() {
                        showGeneralDialog(
                          context: context!,
                          barrierColor: Colors.transparent,
                          pageBuilder: (_, __, ___) {
                            return TanChuang(widget.data['id'], type: 1);
                          },
                        );
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: Colors.black.withOpacity(0.05),
                      child: MyText(
                        '开盘提醒',
                        isBold: true,
                        color: Common.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: WidgetTap(
                    isElastic: true,
                    onTap: () {
                      con.jumpTo(con.position.maxScrollExtent);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: Theme.of(context!).primaryColor,
                      child: MyText(
                        '项目奖金规则',
                        isBold: true,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: WidgetTap(
                    isElastic: true,
                    onTap: () {
                      con.jumpTo(con.position.maxScrollExtent);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: Common.smallColor.withOpacity(0.1),
                      child: MyText(
                        loupanDm.object['award'],
                        // '项目奖金最高34100.00元/套',
                        isBold: true,
                        color: Common.smallColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TanChuang extends StatefulWidget {
  final String id;
  final int? type;

  const TanChuang(this.id, {Key? key, this.type}) : super(key: key);

  @override
  _TanChuangState createState() => _TanChuangState();
}

class _TanChuangState extends State<TanChuang> {
  TextEditingController con = TextEditingController();

  var isYuedu = false;

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
            time: 500,
            curve: ElasticOutCurve(1),
            child: GestureDetector(
              onTap: () {},
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
                    MyText(['价格变动提醒', '开盘提醒'][widget.type!],
                        size: 18, isBold: true),
                    SizedBox(height: 14),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: MyText(
                        [
                          '设置后将在楼盘发生价格波动时通过短息实时推送给您,帮您看准买房时机',
                          '设置后将在楼盘开盘时通过短息实时推送给您,帮您看准买房时机',
                        ][widget.type!],
                        size: 14,
                        color: Colors.black45,
                        isOverflow: false,
                      ),
                    ),
                    Container(
                      height: 44,
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black12),
                      ),
                      child: buildTextField(
                        isBig: true,
                        maxLines: 1,
                        hint: '输入订阅手机号码',
                        con: con,
                        borderColor: Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: WidgetTap(
                        onTap: () {
                          setState(() {
                            isYuedu = !isYuedu;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isYuedu
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank,
                              size: 16,
                              color: isYuedu
                                  ? Theme.of(context).primaryColor
                                  : Colors.black26,
                            ),
                            SizedBox(width: 8),
                            MyText(
                              '我已阅读并同意协议',
                              size: 14,
                              color: Color(0xff5C5C5C),
                              isOverflow: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    BtnWidget(
                      isShowShadow: false,
                      titles: ['取消', '立即订阅'],
                      bgColor: Colors.transparent,
                      btnHeight: [10, 12],
                      value: [50, 50],
                      delayed: [0, 50],
                      axis: [Axis.vertical, Axis.vertical],
                      curve: [ElasticOutCurve(1), ElasticOutCurve(1)],
                      onTap: [
                        () => close(),
                        () {
                          if (isYuedu) {
                            if (con.text != '') {
                              Request.put(
                                '/api/Building/Subscribe',
                                data: {
                                  "buildingId": widget.id,
                                  "phoneNumber": con.text,
                                  "subscribeType": widget.type! + 1,
                                },
                                isLoading: true,
                                dialogText: '正在订阅...',
                                catchError: (v) => showToast('订阅失败'),
                                fail: (v) => showToast('订阅失败'),
                                success: (v) {
                                  close();
                                  showToast('订阅成功');
                                },
                              );
                            } else {
                              showToast('请输入订阅的手机号码!');
                            }
                          } else {
                            showToast('请阅读协议!');
                          }
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DianpingTanChuang extends StatefulWidget {
  final String id;
  final String? wentiId;
  final int? type;

  const DianpingTanChuang(this.id, {Key? key, this.type, this.wentiId})
      : super(key: key);

  @override
  _DianpingTanChuangState createState() => _DianpingTanChuangState();
}

class _DianpingTanChuangState extends State<DianpingTanChuang> {
  TextEditingController con = TextEditingController();
  TextEditingController con1 = TextEditingController();

  var isYuedu = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.black38,
          alignment: Alignment.center,
          child: TweenWidget(
            axis: Axis.vertical,
            time: 500,
            curve: ElasticOutCurve(1),
            child: Listener(
              onPointerDown: (v) =>
                  FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyText(['评论', '提问', '回答'][widget.type!],
                          size: 18, isBold: true),
                      SizedBox(height: 14),
                      if (widget.type == 0)
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              color: Colors.black.withOpacity(0.05),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, -2.5),
                                    child: MyText('优点:'),
                                  ),
                                  Expanded(
                                    child: buildTextField(
                                      isBig: true,
                                      maxLines: 5,
                                      fontSize: 14,
                                      contentPadding: EdgeInsets.zero,
                                      hint: '请输入你的意见',
                                      con: con,
                                      borderColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16),
                              child: MyText('不多余200字', size: 12),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              color: Colors.black.withOpacity(0.05),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, -2.5),
                                    child: MyText('缺点:'),
                                  ),
                                  Expanded(
                                    child: buildTextField(
                                      isBig: true,
                                      maxLines: 5,
                                      fontSize: 14,
                                      contentPadding: EdgeInsets.zero,
                                      hint: '请输入你的意见',
                                      con: con1,
                                      borderColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16),
                              child: MyText('不多余200字', size: 12),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.black12),
                              ),
                              child: buildTextField(
                                isBig: true,
                                maxLines: 5,
                                hint: [
                                  '请输入你的评论',
                                  '请输入你的问题',
                                  '请输入你的回答',
                                ][widget.type!],
                                con: con,
                                borderColor: Colors.transparent,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16),
                              child: MyText('不多余200字', size: 12),
                            ),
                          ],
                        ),
                      BtnWidget(
                        isShowShadow: false,
                        titles: ['取消', '确定'],
                        bgColor: Colors.transparent,
                        btnHeight: [10, 12],
                        value: [50, 50],
                        delayed: [0, 50],
                        axis: [Axis.vertical, Axis.vertical],
                        curve: [ElasticOutCurve(1), ElasticOutCurve(1)],
                        onTap: [
                          () => close(),
                          () async {
                            if (con.text == '' && con1.text == '') {
                              showToast('发表一下意见吧!');
                              return;
                            } else {
                              if (con.text != '') {
                                await Request.post(
                                  '/api/Comment/Create',
                                  data: {
                                    "buildingId": widget.id,
                                    "content": con.text,
                                    "tag": "优点",
                                  },
                                  isLoading: true,
                                  catchError: (v) => showToast(v),
                                  fail: (v) => showToast(v),
                                  success: (v) {
                                    showToast('提交成功');
                                  },
                                );
                              }
                              if (con1.text != '') {
                                await Request.post(
                                  '/api/Comment/Create',
                                  data: {
                                    "buildingId": widget.id,
                                    "content": con1.text,
                                    "tag": "缺点",
                                  },
                                  isLoading: true,
                                  catchError: (v) => showToast(v),
                                  fail: (v) => showToast(v),
                                  success: (v) {
                                    showToast('提交成功！');
                                  },
                                );
                              }
                              close(true);
                            }
                          },
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///vr视频
class VrVideoPage extends StatefulWidget {
  final String? url;
  final Map? data;

  const VrVideoPage({Key? key, this.url, this.data}) : super(key: key);

  @override
  _VrVideoPageState createState() => _VrVideoPageState();
}

class _VrVideoPageState extends State<VrVideoPage>
    with TickerProviderStateMixin {
  // WebViewController controller;
  bool flag = false;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    this.initData();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<void> initData() async {
    Future(() async {
      if (widget.data == null)
        await precacheImage(NetworkImage(widget.url!), context!);
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => flag = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      brightness: widget.data == null
          ? flag
              ? Brightness.light
              : Brightness.dark
          : Brightness.dark,
      appBar: widget.data == null
          ? null
          : buildTitle(context, title: widget.data!['title']),
      body: widget.data == null
          ? Center(
              child: AnimatedSize(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                child: flag
                    ? ClipRect(
                        child: Container(
                          height: size(context).height,
                          width: size(context).width,
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        child: buildLoad(),
                      ),
              ),
            )
          : Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height: progress >= 100 ? 0 : 2,
                  width: size(context).width * (progress / 100),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
    );
  }
}

///楼盘问答
class LoupanWendaPage extends StatefulWidget {
  final Map? data;

  const LoupanWendaPage({Key? key, this.data}) : super(key: key);

  @override
  _LoupanWendaPageState createState() => _LoupanWendaPageState();
}

class _LoupanWendaPageState extends State<LoupanWendaPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiQuestionGetPageList(isRef: true);
  }

  ///获取楼盘问答
  var loupanWendaDm = DataModel(hasNext: false);

  Future<int> apiQuestionGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Question/GetPageList',
      data: {
        "PageIndex": page,
        "buildingId": widget.data!['id'],
      },
      catchError: (v) => loupanWendaDm.toError(v),
      success: (v) {
        var list = v['data'] as List;
        var list2 = list.where((w) => w['level'] == 2).toList();
        list = list.where((w) => w['level'] == 1).toList();
        loupanWendaDm.addList(list, isRef, v['total']);
        loupanWendaDm.value = list2;
      },
    );
    setState(() {});
    return loupanWendaDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '楼盘问答',
        color: Colors.white,
      ),
      bgColor: Colors.white,
      btnBar: WidgetTap(
        isElastic: true,
        onTap: () async {
          ComonUtil.isLogin(() async {
            showSelecto(context, texts: [
              "房子现在什么价格?",
              "最新有什么优惠政策?",
              "最高返佣多少?",
              "这套房首付是多少?",
              "目前还有哪些户型在售?",
            ], callback: (v, i) {
              Request.post(
                '/api/Question/Create',
                data: {
                  "buildingId": widget.data!['id'],
                  "content": v,
                  "buildingName": widget.data!['buildingName'],
                  "questionType": 0,
                  "baseIsDelete": true,
                  "level": 0,
                },
                isLoading: true,
                catchError: (v) => showToast(v),
                fail: (v) => showToast(v),
                success: (v) {
                  showToast('提交成功！');
                  this.apiQuestionGetPageList(isRef: true);
                },
              );
            });
          });
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          color: Common.smallColor.withOpacity(0.1),
          margin: EdgeInsets.all(8),
          child: MyText(
            '我要提问',
            isBold: true,
            color: Common.smallColor,
          ),
        ),
      ),
      body: AnimatedSwitchBuilder(
        value: loupanWendaDm,
        errorOnTap: () => this.apiQuestionGetPageList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            expCount: 10,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 20),
            onLoading: () => this.apiQuestionGetPageList(page: p),
            onRefresh: () => this.apiQuestionGetPageList(isRef: true),
            itemCount: list.length,
            item: (i) {
              flog('=============');
              flog(loupanWendaDm.value
                  .where((w) => w['parentId'] == list[i]['id'])
                  .toList());
              return WidgetTap(
                onTap: () async {
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 20,
                            width: 20,
                            color: Color(0xffF95136),
                            alignment: Alignment.center,
                            child: MyText('问', size: 12, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: MyText(
                            list[i]['content'],
                            isBold: true,
                            color: Common.black,
                          ),
                        )
                      ],
                    ),
                    if (loupanWendaDm.value
                        .where((w) => w['parentId'] == list[i]['id'])
                        .isNotEmpty)
                      SizedBox(height: 11),
                    if (loupanWendaDm.value
                        .where((w) => w['parentId'] == list[i]['id'])
                        .isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: MyListView(
                          isShuaxin: false,
                          itemCount: loupanWendaDm.value
                              .where((w) => w['parentId'] == list[i]['id'])
                              .length,
                          physics: NeverScrollableScrollPhysics(),
                          listViewType: ListViewType.Separated,
                          item: (ii) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              color: Color(0xffF5F5F5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: WrapperImage(
                                          height: 35,
                                          width: 35,
                                          urlBuilder: () => loupanWendaDm.value
                                                  .where((w) =>
                                                      w['parentId'] ==
                                                      list[i]['id'])
                                                  .toList()[ii]
                                              ['replyUserPortrait'],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              loupanWendaDm.value
                                                      .where((w) =>
                                                          w['parentId'] ==
                                                          list[i]['id'])
                                                      .toList()[ii]
                                                  ['replyUserName'],
                                              isBold: true,
                                              color: Common.black,
                                            ),
                                            SizedBox(height: 2),
                                            MyText(
                                              toTime(loupanWendaDm.value
                                                      .where((w) =>
                                                          w['parentId'] ==
                                                          list[i]['id'])
                                                      .toList()[ii]
                                                  ['baseModifyTime']),
                                              size: 9,
                                              color: Common.black,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  MyText(
                                    loupanWendaDm.value
                                        .where((w) =>
                                            w['parentId'] == list[i]['id'])
                                        .toList()[ii]['content'],
                                    size: 12,
                                    isOverflow: false,
                                    color: Common.black,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

///楼盘点评
class LoupanDianpingPage extends StatefulWidget {
  final Map? data;

  const LoupanDianpingPage({Key? key, this.data}) : super(key: key);

  @override
  _LoupanDianpingPageState createState() => _LoupanDianpingPageState();
}

class _LoupanDianpingPageState extends State<LoupanDianpingPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiCommentGetPageList(isRef: true);
  }

  ///获取楼盘点评
  var loupanDianpingDm = DataModel(hasNext: false);

  Future<int> apiCommentGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Comment/GetPageList',
      data: {
        "PageIndex": page,
        "buildingId": widget.data!['id'],
      },
      catchError: (v) => loupanDianpingDm.toError(v),
      success: (v) {
        loupanDianpingDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return loupanDianpingDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      resizeToAvoidBottomInset: false,
      appBar: buildTitle(
        context,
        title: '楼盘点评',
        color: Colors.white,
      ),
      bgColor: Colors.white,
      btnBar: WidgetTap(
        isElastic: true,
        onTap: () async {
          ComonUtil.isLogin(() async {
            var res = await showGeneralDialog(
              context: context,
              barrierColor: Colors.transparent,
              pageBuilder: (_, __, ___) {
                return DianpingTanChuang(widget.data!['id'], type: 0);
              },
            );
            if (res != null) {
              this.apiCommentGetPageList(isRef: true);
            }
          });
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          color: Common.smallColor.withOpacity(0.1),
          margin: EdgeInsets.all(8),
          child: MyText(
            '我要点评',
            isBold: true,
            color: Common.smallColor,
          ),
        ),
      ),
      body: AnimatedSwitchBuilder(
        value: loupanDianpingDm,
        errorOnTap: () => this.apiCommentGetPageList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            expCount: 10,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 20),
            onLoading: () => this.apiCommentGetPageList(page: p),
            onRefresh: () => this.apiCommentGetPageList(isRef: true),
            itemCount: list.length,
            item: (i) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: WrapperImage(
                      // imageType: ImageType.random,
                      height: 35,
                      width: 35,
                      urlBuilder: () => loupanDianpingDm.list[i]['portrait'],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: MyColumn(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(56),
                                color: loupanDianpingDm.list[i]['tag'] == '优点'
                                    ? Color(0xffF7DDA9)
                                    : Common.smallColor.withOpacity(0.1),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: MyText(
                                loupanDianpingDm.list[i]['tag'],
                                color: loupanDianpingDm.list[i]['tag'] == '优点'
                                    ? Common.black
                                    : Common.black,
                                size: 12,
                                isBold: true,
                              ),
                            ),
                            Expanded(
                              child: MyText(
                                toTime(
                                    loupanDianpingDm.list[i]['baseCreateTime']),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 9),
                          child: MyText(
                            loupanDianpingDm.list[i]['content'],
                            isOverflow: false,
                            color: Common.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class HuxingPage extends StatefulWidget {
  final List? list;

  const HuxingPage({Key? key, this.list}) : super(key: key);

  @override
  _HuxingPageState createState() => _HuxingPageState();
}

class _HuxingPageState extends State<HuxingPage> {
  @override
  Widget build(BuildContext context) {
    flog(widget.list);
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(context, title: '全部户型'),
      body: MyListView(
        isShuaxin: false,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        divider: Divider(height: 32),
        listViewType: ListViewType.Separated,
        itemCount: widget.list!.length,
        item: (i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: WidgetTap(
                  isElastic: true,
                  onTap: () {
                    jumpPage(
                      PhotoView(
                        images: widget.list![i]['images'].toString().split(';'),
                        isUrl: true,
                      ),
                      isMoveBtm: true,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: WrapperImage(
                      height: 135,
                      urlBuilder: () =>
                          widget.list![i]['images'].toString().split(';')[0],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: MyText(
                      '房型：',
                      size: 13,
                      color: Common.black,
                      children: [
                        MyText.ts(
                          '${widget.list![i]['layout']}',
                          isBold: true,
                          color: Common.black,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: MyText(
                      '面积：',
                      size: 13,
                      textAlign: TextAlign.right,
                      color: Common.black,
                      children: [
                        MyText.ts(
                          '${widget.list![i]['area']}㎡',
                          isBold: true,
                          color: Common.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9),
              MyText(
                '价格：',
                size: 13,
                color: Common.black,
                children: [
                  MyText.ts(
                    '${widget.list![i]['price']}',
                    isBold: true,
                    color: Color(0xffFF781D),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ZhoubianWidget extends StatefulWidget {
  final Map data;

  const ZhoubianWidget(this.data, {Key? key}) : super(key: key);

  @override
  _ZhoubianWidgetState createState() => _ZhoubianWidgetState();
}

class _ZhoubianWidgetState extends State<ZhoubianWidget> {
  var baiduAk = 'hRKrrFUt3OV9YsYsqbgXeBODUq1cNnVV';
  var baiduUrl = 'https://api.map.baidu.com/place/v2/search';
  var meishi = [];
  var jiaotong = [];
  var jiaoyu = [];
  var shangchang = [];
  var position;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    var list = widget.data['position'].toString().split(',');
    position = '${list[1]},${list[0]}';
    await this.getZhoubian();
  }

  ///获取周边
  Future<void> getZhoubian() async {
    var res1 = await Dio().get(
      '$baiduUrl?query=学校&location=$position&radius=2000&output=json&scope=2&page_size=3&ak=$baiduAk',
    );
    meishi = json.decode(res1.data.toString())['results'];
    setState(() {});
    var res2 = await Dio().get(
      '$baiduUrl?query=交通设施,公交&location=$position&radius=2000&output=json&scope=2&page_size=3&ak=$baiduAk',
    );
    jiaotong = json.decode(res2.data.toString())['results'];
    setState(() {});
    var res3 = await Dio().get(
      '$baiduUrl?query=医院&location=$position&radius=2000&output=json&scope=2&page_size=3&ak=$baiduAk',
    );
    jiaoyu = json.decode(res3.data.toString())['results'];
    setState(() {});
    var res4 = await Dio().get(
      '$baiduUrl?query=商场&location=$position&radius=2000&output=json&scope=2&page_size=3&ak=$baiduAk',
    );
    shangchang = json.decode(res4.data.toString())['results'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText('学校', isBold: true),
            MyText(
              '2km内共${meishi.length}个',
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(height: 8),
        MyListView(
          isShuaxin: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: meishi.length,
          padding: EdgeInsets.symmetric(horizontal: 2),
          listViewType: ListViewType.Separated,
          divider: Divider(color: Colors.transparent, height: 4),
          item: (i) {
            return Row(
              children: [
                Expanded(child: MyText('${meishi[i]['name']}', size: 12)),
                MyText(
                  '${meishi[i]['detail_info']['distance']}m',
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText('交通设施', isBold: true),
            MyText(
              '2km内共${jiaotong.length}个',
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(height: 8),
        MyListView(
          isShuaxin: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: jiaotong.length,
          padding: EdgeInsets.symmetric(horizontal: 2),
          listViewType: ListViewType.Separated,
          divider: Divider(color: Colors.transparent, height: 4),
          item: (i) {
            return Row(
              children: [
                Expanded(child: MyText('${jiaotong[i]['name']}', size: 12)),
                MyText(
                  '${jiaotong[i]['detail_info']['distance']}m',
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText('医院', isBold: true),
            MyText(
              '2km内共${jiaoyu.length}个',
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(height: 8),
        MyListView(
          isShuaxin: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: jiaoyu.length,
          padding: EdgeInsets.symmetric(horizontal: 2),
          listViewType: ListViewType.Separated,
          divider: Divider(color: Colors.transparent, height: 4),
          item: (i) {
            return Row(
              children: [
                Expanded(child: MyText('${jiaoyu[i]['name']}', size: 12)),
                MyText(
                  '${jiaoyu[i]['detail_info']['distance']}m',
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText('商场', isBold: true),
            MyText(
              '2km内共${shangchang.length}个',
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(height: 8),
        MyListView(
          isShuaxin: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: shangchang.length,
          padding: EdgeInsets.symmetric(horizontal: 2),
          listViewType: ListViewType.Separated,
          divider: Divider(color: Colors.transparent, height: 4),
          item: (i) {
            return Row(
              children: [
                Expanded(child: MyText('${shangchang[i]['name']}', size: 12)),
                MyText(
                  '${shangchang[i]['detail_info']['distance']}m',
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

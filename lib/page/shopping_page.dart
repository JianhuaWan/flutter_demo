import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/page/wode/kehu_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/date_picker.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/interface.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class ShoppingPage extends StatefulWidget {
  final bool isHome;
  final Map? data;

  const ShoppingPage({Key? key, this.isHome = true, this.data}) : super(key:
  key);
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> with AutomaticKeepAliveClientMixin {
  var kehuXinbie, kehuType, tuijianLoupan, peitongZhuchang;
  DateTime daofangTime = DateTime.now().add(Duration(hours: 1));
  TextEditingController textCon1 = TextEditingController();
  TextEditingController textCon2 = TextEditingController();
  TextEditingController textCon3 = TextEditingController();

  var isSelf = false;

  var tuijianLoupanId;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tuijianLoupan = widget.data == null ? null : widget.data!['buildingName'];
    tuijianLoupanId = widget.data == null ? null : widget.data!['id'];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '标题',
        color: Colors.white,
        isNoShowLeft: widget.isHome,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: TweenWidget(
            axis: Axis.vertical,
            isOpacity: true,
            delayed: 50,
            value: 50,
            curve: ElasticOutCurve(1),
            child: Container(
              color: Colors.white,
              child: MyListView(
                isShuaxin: false,
                item: (i) => item[i],
                itemCount: item.length,
                listViewType: ListViewType.Separated,
                divider: Divider(height: 0, indent: 16),
              ),
            ),
          ),
        ),
      ),
      btnBar: BtnWidget(
        titles: ['重置', '提交'],
        time: [750, 750],
        value: [50, 50],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
        delayed: [0, 100],
        onTap: [
          () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              kehuXinbie = null;
              kehuType = null;
              tuijianLoupan = null;
              daofangTime = DateTime.now().add(Duration(hours: 1));
              peitongZhuchang = null;
              textCon1.clear();
              textCon2.clear();
              textCon3.clear();
            });
          },
          () async {
            Interface.handle(
              context,
              dataModel: tuijianDm,
              isShowDialog: true,
              valueChecking: [
                ValueModel('姓名', textCon1),
                ValueModel('客户性别', kehuXinbie),
                ValueModel('客户电话', textCon2, '', true),
                ValueModel('客户类型', kehuType),
                ValueModel('推荐楼盘', tuijianLoupan),
                ValueModel('到访时间', daofangTime),
                ValueModel('到访人数', textCon3),
              ],
              success: (v) async {
                showToast('推荐成功');
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  kehuXinbie = null;
                  kehuType = null;
                  tuijianLoupan = widget.data == null ? null : widget
                      .data!['buildingName'];
                  tuijianLoupanId = widget.data == null ? null : widget
                      .data!['id'];
                  daofangTime = DateTime.now().add(Duration(hours: 1));
                  peitongZhuchang = null;
                  textCon1.clear();
                  textCon2.clear();
                  textCon3.clear();
                });
                await Future.delayed(Duration(milliseconds: 500));
                jumpPage(KehuPage());
              },
              event: () => this.apiCustomerRecommend(),
            );
          },
        ],
      ),
    );
  }

  ///推荐客户
  var tuijianDm = DataModel(hasNext: false);
  Future<int> apiCustomerRecommend({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/api/Customer/Recommend',
      data: {
        "belongUserId": user.id,
        "isSelf": isSelf,
        "realName": textCon1.text,
        "gender": kehuXinbie == '男' ? 0 : 1,
        "mobile": textCon2.text,
        "customerType": kehuType == '普通客户' ? '2' : '1',
        "expectArriveDate": getIso8601String(daofangTime),
        "peoples": textCon3.text,
        "userId": user.id,
        "status": 1,
        "buildingId": tuijianLoupanId,
        "tag": "string",
      },
      catchError: (v) => tuijianDm.toError(v),
      success: (v) {
        tuijianDm.object = v;
        tuijianDm.setTime();
      },
    );
    return tuijianDm.flag!;
  }

  List<Widget> get item {
    return List.generate(8, (i) {
      return ItemEditWidget(
        title: ['客户名称', '*请输入姓名', '*客户性别', '*客户电话', '*客户类型', '*推荐楼盘', '*预计到访时间', '*到访人数'][i],
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isCheck: i == 0,
        isEditText: i == 1 || i == 3 || i == 7,
        textCon: [null, textCon1, null, textCon2, null, null, null, textCon3, null][i],
        isDouble: [false, false, false, true, false, false, false, true, false][i],
        isSelecto: ![true, true, false, true, false, false, false, true, false][i],
        selectoText: [
          null,
          null,
          kehuXinbie,
          null,
          kehuType,
          tuijianLoupan,
          daofangTime.toString().split('.').first.split(':')[0] + ":" + daofangTime.toString().split('.').first.split(':')[1],
          null,
          peitongZhuchang
        ][i],
        othrOntap: (v) => isSelf = v,
        selectoOnTap: () {
          switch (i) {
            case 2:
              showSelecto(context!, texts: ['男', '女'], callback: (v, i) {
                setState(() {
                  kehuXinbie = v;
                });
              });
              break;
            case 4:
              jumpPage(KehuType(), callback: (v) => setState(() => kehuType = v));
              break;
            case 5:
              if (widget.data == null)
                jumpPage(
                  TuijianLoupan(),
                  callback: (v) => setState(() {
                    tuijianLoupan = v[0];
                    tuijianLoupanId = v[1];
                  }),
                );
              break;
            case 8:
              jumpPage(TuijianLoupan(), callback: (v) => setState(() => peitongZhuchang = v));
              break;
            case 6:
              DatePicker.showDateTimePicker(
                context!,
                minTime: DateTime.now().add(Duration(hours: 1)),
                maxTime: DateTime.now().add(Duration(days: 365 * 10)),
                onConfirm: (date) {
                  setState(() {
                    daofangTime = date;
                  });
                },
                currentTime: DateTime.now().add(Duration(hours: 1)),
                locale: LocaleType.zh,
              );
              break;
          }
        },
      );
    });
  }

  @override
  bool get wantKeepAlive => !true;
}

class KehuType extends StatefulWidget {
  @override
  _KehuTypeState createState() => _KehuTypeState();
}

class _KehuTypeState extends State<KehuType> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '客户类型', color: Colors.white),
      body: MyListView(
        isShuaxin: true,
        padding: EdgeInsets.symmetric(vertical: 8),
        item: (i) => item[i],
        itemCount: item.length,
        listViewType: ListViewType.Separated,
        divider: Divider(height: 8, color: Colors.transparent),
      ),
      btnBar: BtnWidget(
        titles: ['返回', '新增标签'],
        time: [750, 750],
        value: [50, 50],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
        delayed: [0, 100],
        onTap: [
          () => closePage(),
          () {
            showGeneralDialog(
              context: context,
              barrierColor: Colors.transparent,
              pageBuilder: (_, __, ___) {
                return TanChuang();
              },
            );
          },
        ],
      ),
    );
  }

  List<Widget> get item {
    return [
      WidgetTap(
        onTap: () => close('意向客户'),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          color: Colors.white,
          child: MyText('意向客户'),
        ),
      ),
      WidgetTap(
        onTap: () => close('普通客户'),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          color: Colors.white,
          child: MyText('普通客户'),
        ),
      ),
    ];
  }
}

class TanChuang extends StatefulWidget {
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
                  MyText('新增标签', size: 18, isBold: true),
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
                      hint: '请输入您新增的标签名',
                      con: con,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  BtnWidget(
                    isShowShadow: false,
                    titles: ['取消', '确定'],
                    bgColor: Colors.transparent,
                    btnHeight: [8, 10],
                    value: [50, 50],
                    axis: [Axis.vertical, Axis.vertical],
                    curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
                    delayed: [0, 100],
                    onTap: [
                      () => close(),
                      () => close(),
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

class TuijianLoupan extends StatefulWidget {
  @override
  _TuijianLoupanState createState() => _TuijianLoupanState();
}

class _TuijianLoupanState extends State<TuijianLoupan> {
  late int index = -1;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getPageList(isRef: true);
  }

  ///楼盘列表
  var loupanDm = DataModel(hasNext: false);
  Future<int> getPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetPageList',
      data: {"PageSize": 10, "PageIndex": page, "city": ''},
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultBuildings = [
          {
            'buildingName': '默认楼盘1',
            'images': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=楼盘1',
            'price': '待定',
            'areaName': '区域1'
          },
          {
            'buildingName': '默认楼盘2',
            'images': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=楼盘2',
            'price': '待定',
            'areaName': '区域2'
          },
          {
            'buildingName': '默认楼盘3',
            'images': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=楼盘3',
            'price': '待定',
            'areaName': '区域3'
          },
        ];
        loupanDm.addList(defaultBuildings, isRef, defaultBuildings.length);
      },
      success: (v) {
        loupanDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return loupanDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '推荐楼盘', color: Colors.white, isShowBorder: true),
      bgColor: Colors.white,
      body: AnimatedSwitchBuilder(
        value: loupanDm,
        errorOnTap: () => this.getPageList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            onRefresh: () => this.getPageList(isRef: true),
            onLoading: () => this.getPageList(page: p),
            item: (i) {
              return WidgetTap(
                onTap: () {
                  setState(() {
                    index = i;
                  });
                  showTc(
                    title: '确定推荐${loupanDm.list[i]['buildingName']}楼盘吗',
                    onPressed: () {
                      close([loupanDm.list[i]['buildingName'], loupanDm.list[i]['id']]);
                    },
                  );
                },
                child: Row(
                  children: [
                    Expanded(child: LoupanItem(i: i, data: list[i])),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        index == i ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        color: index == i ? Theme.of(context).primaryColor : Colors.black26,
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: list.length,
            padding: EdgeInsets.symmetric(vertical: 16),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 27, color: Colors.transparent),
          );
        },
      ),
    );
  }
}

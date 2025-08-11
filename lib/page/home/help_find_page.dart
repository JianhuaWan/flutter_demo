import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/page/home/search_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/widget/city_picker_widget.dart';
import 'package:flutter_app/widget/no_sliding_widget.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/interface.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class HelpFindPage extends StatefulWidget {
  @override
  _HelpFindPageState createState() => _HelpFindPageState();
}

class _HelpFindPageState extends State<HelpFindPage> with NoSlidingReturn, TickerProviderStateMixin {
  var jushi, suozaidi, suozaidi2, yongjin, suozaidiCode, fangwei;
  TextEditingController textCon1 = TextEditingController();
  TextEditingController textCon2 = TextEditingController();
  TextEditingController textCon3 = TextEditingController();
  TextEditingController textCon4 = TextEditingController();
  TextEditingController textCon5 = TextEditingController();
  TextEditingController textCon6 = TextEditingController();
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
        title: '帮我找房',
        color: Colors.white,
      ),
      body: TabWidget(
        tabCon: tabCon,
        tabList: ['按照首付', '按照总价', '按照佣金'],
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
        titles: ['重置', '提交筛选'],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
        delayed: [0, 100],
        onTap: [
          () async {
            setState(() {
              suozaidi = null;
              suozaidi2 = null;
              yongjin = null;
              textCon1.clear();
              textCon2.clear();
              textCon3.clear();
              textCon4.clear();
              textCon5.clear();
              textCon6.clear();
            });
            showToast('已重置');
          },
          () {
            switch (tabCon!.index) {
              case 0:
                Interface.handle(
                  context,
                  dataModel: tuijianDm,
                  isShowDialog: true,
                  valueChecking: [
                    ValueModel('首付预算', textCon1),
                    ValueModel('居室', jushi),
                    ValueModel('所在地', suozaidi),
                    ValueModel('面积', textCon3),
                  ],
                  success: (v) async {
                    jumpPage(
                      SearchPage(
                        data: {
                          'shoufu': textCon1.text,
                          'jushi': jushi['dictKey'],
                          'city': suozaidiCode,
                          'mianji': textCon3.text,
                        },
                      ),
                    );
                  },
                  event: () => this.apiCustomerRecommend(),
                );
                break;
              case 1:
                Interface.handle(
                  context,
                  dataModel: tuijianDm,
                  isShowDialog: true,
                  valueChecking: [
                    ValueModel('总价预算', textCon4),
                    ValueModel('居室', jushi),
                    ValueModel('所在地', suozaidi2),
                    ValueModel('面积', textCon6),
                  ],
                  success: (v) async {
                    jumpPage(
                      SearchPage(
                        data: {
                          'jushi': jushi['dictKey'],
                          'city': suozaidiCode,
                          'mianji': textCon6.text,
                          'zongjia': textCon4.text,
                        },
                      ),
                    );
                  },
                  event: () => this.apiCustomerRecommend(),
                );
                break;
              case 2:
                if (fangwei == null) {
                  showToast('请选择范围');
                } else {
                  jumpPage(SearchPage(data: {'fangwei': fangwei}));
                }
                break;
            }
          },
        ],
      ),
    );
  }

  ///帮我找房
  var tuijianDm = DataModel(hasNext: false);
  Future<int> apiCustomerRecommend() async {
    tuijianDm.setTime();
    return tuijianDm.flag!;
  }

  List<Widget> get item1 {
    return List.generate(4, (i) {
      return ItemEditWidget(
        title: ['首付预算（万）', '几居室', '房子所在地区', '多大面积（㎡）'][i],
        hint: ['请输入预算', null, null, '请输入面积'][i],
        isEditText: [true, false, false, true][i],
        textCon: [textCon1, null, null, textCon3][i],
        isSelecto: [false, true, true, false][i],
        selectoText: [
          null,
          jushi != null ? jushi['dictValue'] : jushi,
          suozaidi,
          null,
        ][i],
        selectoOnTap: () {
          switch (i) {
            case 1:
              showSelecto(context!, texts: app.zidianDm.object!.where((w) =>
              w['dictType'] == 'LayoutType').map<String>((m) => m['dictValue']).toList(), callback: (v, i) {
                setState(() {
                  jushi = app.zidianDm.object!.where((w) => w['dictType'] ==
                      'LayoutType').toList()[i];
                });
              });
              break;
            case 2:
              // app.showCitySelecto((v, i) {
              //   setState(() {
              //     suozaidi = v;
              //   });
              // });
              FocusScope.of(context!).requestFocus(FocusNode());
              CityPicker.showCityPicker(
                context!,
                selectProvince: (province) {},
                selectCity: (city) => suozaidiCode = city['code'],
                selectArea: (area) {},
                selectAll: (all) async {
                  setState(() {
                    suozaidi = all['name'];
                  });
                },
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
        title: ['总价预算（万）', '几居室', '房子所在地区', '多大面积（㎡）'][i],
        hint: ['请输入预算', '请输入1-5', null, '请输入面积'][i],
        isEditText: [true, false, false, true][i],
        textCon: [textCon4, null, null, textCon6][i],
        isSelecto: [false, true, true, false][i],
        selectoText: [
          null,
          jushi != null ? jushi['dictValue'] : jushi,
          suozaidi2,
          null,
        ][i],
        selectoOnTap: () {
          switch (i) {
            case 1:
              showSelecto(context!, texts: app.zidianDm.object!.where((w) =>
              w['dictType'] == 'LayoutType').map<String>((m) => m['dictValue']).toList(), callback: (v, i) {
                setState(() {
                  jushi = app.zidianDm.object!.where((w) => w['dictType'] ==
                      'LayoutType').toList()[i];
                });
              });
              break;
            case 2:
              FocusScope.of(context!).requestFocus(FocusNode());
              //  var str;
              CityPicker.showCityPicker(
                context!,
                selectProvince: (province) {},
                selectCity: (city) => suozaidiCode = city['code'],
                selectArea: (area) {},
                selectAll: (all) async {
                  setState(() {
                    suozaidi2 = all['name'];
                  });
                },
              );
              break;
          }
        },
      );
    });
  }

  List<Widget> get item3 {
    return List.generate(1, (i) {
      return ItemEditWidget(
        title: '佣金范围',
        isEditText: false,
        isSelecto: true,
        selectoText: fangwei,
        selectoOnTap: () {
          switch (i) {
            case 0:
              showSelecto(
                context!,
                texts: app.zidianDm.object!.where((w) => w['dictType'] == 'Aw'
                    'ardType').map<String>((m) => m['dictValue']).toList(),
                callback: (v, i) => setState(() => fangwei = v),
              );
              break;
          }
        },
      );
    });
  }
}

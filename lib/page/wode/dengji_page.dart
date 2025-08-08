import 'package:flutter/material.dart';
import 'package:flutter_app/page/wode/dengji_item.dart';
import 'package:flutter_app/widget/no_sliding_return.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class DengjiPage extends StatefulWidget {
  @override
  _DengjiPageState createState() => _DengjiPageState();
}

class _DengjiPageState extends State<DengjiPage> with NoSlidingReturn {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '身份等级',
        color: Colors.white,
      ),
      body: TabWidget(
        isPadding: false,
        tabList: ['团员', '高级团员', '明星团长'],
        tabPage: List.generate(3, (i) {
          return DengjiItemPage(userLevel: '${i + 1}');
        }),
      ),
    );
  }

  MyListView<dynamic> buildItem1() {
    return MyListView(
      isShuaxin: false,
      itemCount: 1,
      divider: Divider(height: 16, color: Colors.transparent),
      padding: EdgeInsets.all(16),
      listViewType: ListViewType.Separated,
      item: (i) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img/level_1.png',
                    width: 25,
                    height: 28,
                  ),
                  SizedBox(width: 4),
                  Expanded(child: MyText('初级经纪人', isBold: true, size: 16)),
                  MyText(
                    '等级任务=基础任务+达标任务',
                    size: 12,
                    color: Color(0xff757575),
                  )
                ],
              ),
              Divider(),
              MyText(
                '基础任务',
                isBold: true,
              ),
              SizedBox(height: 10),
              MyText(
                '注册账号',
                size: 13,
                color: Color(0xff757575),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 4,
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: Container(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 4,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              heightFactor: 1,
                              child: Container(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  MyText(
                    '1/1',
                    size: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 76),
                  WidgetTap(
                    isElastic: true,
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 2),
                        child: MyText('已完成', color: Colors.white, size: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22),
              WidgetTap(
                isElastic: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                    child: MyText('已达标当前等级', color: Colors.white, size: 12),
                  ),
                ),
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
  }

  MyListView<dynamic> buildItem2() {
    return MyListView(
      isShuaxin: false,
      itemCount: 1,
      divider: Divider(height: 16, color: Colors.transparent),
      padding: EdgeInsets.all(16),
      listViewType: ListViewType.Separated,
      item: (i) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img/level_1.png',
                    width: 25,
                    height: 28,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: MyText(
                      '高级经纪人LV-2',
                      isBold: true,
                      size: 16,
                    ),
                  ),
                  MyText(
                    '等级任务=基础任务+达标任务',
                    size: 12,
                    color: Color(0xff757575),
                  )
                ],
              ),
              Divider(),
              MyText(
                '基础任务',
                isBold: true,
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(4, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText('注册账号', size: 13, color: Color(0xff757575)),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 4,
                                    child: FractionallySizedBox(
                                      widthFactor: 1,
                                      heightFactor: 1,
                                      child: Container(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 4,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.5,
                                      heightFactor: 1,
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          MyText(
                            '1/1',
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 76),
                          WidgetTap(
                            isElastic: true,
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 2),
                                child: MyText('已完成', color: Colors.white, size: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                    ],
                  );
                }),
              )
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
  }

  MyListView<dynamic> buildItem3() {
    return MyListView(
      isShuaxin: false,
      itemCount: 1,
      divider: Divider(height: 16, color: Colors.transparent),
      padding: EdgeInsets.all(16),
      listViewType: ListViewType.Separated,
      item: (i) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img/level_1.png',
                    width: 25,
                    height: 28,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: MyText(
                      '明星经纪人LV-3',
                      isBold: true,
                      size: 16,
                    ),
                  ),
                  MyText(
                    '等级任务=基础任务+达标任务',
                    size: 12,
                    color: Color(0xff757575),
                  )
                ],
              ),
              Divider(),
              MyText(
                '基础任务',
                isBold: true,
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(4, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText('注册账号', size: 13, color: Color(0xff757575)),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 4,
                                    child: FractionallySizedBox(
                                      widthFactor: 1,
                                      heightFactor: 1,
                                      child: Container(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 4,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.5,
                                      heightFactor: 1,
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          MyText(
                            '1/1',
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 76),
                          WidgetTap(
                            isElastic: true,
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 2),
                                child: MyText('已完成', color: Colors.white, size: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                    ],
                  );
                }),
              )
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
  }

  MyListView<dynamic> buildItem4() {
    return MyListView(
      isShuaxin: false,
      itemCount: 1,
      divider: Divider(height: 16, color: Colors.transparent),
      padding: EdgeInsets.all(16),
      listViewType: ListViewType.Separated,
      item: (i) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img/level_1.png',
                    width: 25,
                    height: 28,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: MyText(
                      '王牌经纪人LV-4',
                      isBold: true,
                      size: 16,
                    ),
                  ),
                  MyText(
                    '等级任务=基础任务+达标任务',
                    size: 12,
                    color: Color(0xff757575),
                  )
                ],
              ),
              Divider(),
              MyText(
                '基础任务',
                isBold: true,
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(4, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText('注册账号', size: 13, color: Color(0xff757575)),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 4,
                                    child: FractionallySizedBox(
                                      widthFactor: 1,
                                      heightFactor: 1,
                                      child: Container(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 4,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.5,
                                      heightFactor: 1,
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          MyText(
                            '1/1',
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 76),
                          WidgetTap(
                            isElastic: true,
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 2),
                                child: MyText('已完成', color: Colors.white, size: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                    ],
                  );
                }),
              )
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
  }
}

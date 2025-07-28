import 'package:flutter/material.dart';
import 'package:kqsc/widget/my_custom_scroll.dart';
import 'package:kqsc/widget/no_sliding_return.dart';
import 'package:kqsc/widget/tab_widget.dart';
import 'package:kqsc/widget/tween_widget.dart';
import 'package:kqsc/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class ShangxueyuanPage extends StatefulWidget {
  @override
  _ShangxueyuanPageState createState() => _ShangxueyuanPageState();
}

class _ShangxueyuanPageState extends State<ShangxueyuanPage> {
  var caidanList = [
    {
      'img': 'assets/img/shangxueyuan_icon1.png',
      'name': '平台介绍',
    },
    {
      'img': 'assets/img/shangxueyuan_icon2.png',
      'name': '房产知识',
    },
    {
      'img': 'assets/img/shangxueyuan_icon3.png',
      'name': '要点必看',
    },
    {
      'img': 'assets/img/shangxueyuan_icon4.png',
      'name': '干货实战',
    },
    {
      'img': 'assets/img/shangxueyuan_icon5.png',
      'name': '学习记录',
    },
  ];

  var itemListStr = ['高级经纪人课程', '明星经纪人课程', '王牌经纪人课程'];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '商学院',
        color: Colors.white,
      ),
      body: MyCustomScroll(
        itemModel: DataModel()
          ..list = List.generate(3, (_) => 1)
          ..hasNext = false,
        headPadding: EdgeInsets.all(16),
        isShuaxin: false,
        headers: [
          Row(
            children: List.generate(caidanList.length, (i) {
              return Expanded(
                child: TweenWidget(
                  delayed: 50 + 100 * i,
                  child: Column(
                    children: [
                      Image.asset(
                        caidanList[i]['img'],
                        height: 38,
                      ),
                      SizedBox(height: 8),
                      MyText(caidanList[i]['name'], isBold: true)
                    ],
                  ),
                ),
              );
            }),
          )
        ],
        mainAxisSpacing: 16,
        itemPadding: EdgeInsets.symmetric(horizontal: 16),
        itemModelBuilder: (i, v) {
          return TweenWidget(
            delayed: 100 + 100 * i,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: MyColumn(
                padding: EdgeInsets.all(12),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyText(
                          itemListStr[i],
                          isBold: true,
                          size: 16,
                        ),
                      ),
                      WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(ShangxueyuanList(index: i, tabList: itemListStr));
                        },
                        child: Container(
                          child: Row(
                            children: [
                              MyText('更多', color: Color(0x80333333)),
                              Icon(Icons.chevron_right_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: WrapperImage(
                                height: 81,
                                urlBuilder: () => '1',
                                imageType: ImageType.random,
                              ),
                            ),
                            SizedBox(height: 10),
                            MyText('身份等级及权益'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: WrapperImage(
                                height: 81,
                                urlBuilder: () => '1',
                                imageType: ImageType.random,
                              ),
                            ),
                            SizedBox(height: 10),
                            MyText('身份等级及权益'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShangxueyuanList extends StatefulWidget {
  final List tabList;
  final int index;

  const ShangxueyuanList({Key key, this.tabList, this.index}) : super(key: key);

  @override
  _ShangxueyuanListState createState() => _ShangxueyuanListState();
}

class _ShangxueyuanListState extends State<ShangxueyuanList> with NoSlidingReturn {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: widget.tabList[widget.index],
        color: Colors.white,
      ),
      body: TabWidget(
        isScrollable: true,
        tabList: widget.tabList,
        isPadding: false,
        tabPage: widget.tabList.map((e) {
          return MyListView(
            isShuaxin: false,
            item: (i) {
              return IntrinsicHeight(
                child: TweenWidget(
                  delayed: 100,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: WrapperImage(
                          height: 81,
                          width: 147,
                          urlBuilder: () => '1',
                          imageType: ImageType.random,
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(e, size: 16),
                          Spacer(),
                          WidgetTap(
                            isElastic: true,
                            onTap: () {},
                            child: Container(
                              child: Row(
                                children: [
                                  MyText('查看详情', color: Color(0x80333333)),
                                  Icon(Icons.chevron_right_rounded, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: 50,
            flag: false,
            padding: EdgeInsets.all(16),
            divider: Divider(height: 32),
            listViewType: ListViewType.Separated,
          );
        }).toList(),
      ),
    );
  }
}

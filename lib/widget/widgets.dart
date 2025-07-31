import 'package:flutter/material.dart';
import 'package:flutter_app/config/common_config.dart';
import 'package:flutter_app/page/home/bangni_page.dart';
import 'package:flutter_app/page/home/chengjiao_page.dart';
import 'package:flutter_app/page/home/fangdai_page.dart';
import 'package:flutter_app/page/home/goufang_ziliao.dart';
import 'package:flutter_app/page/home/loupan_page.dart';
import 'package:flutter_app/page/home/pinpai_page.dart';
import 'package:flutter_app/page/home/renqibang_page.dart';
import 'package:flutter_app/page/home/sunpan_page.dart';
import 'package:flutter_app/page/home/xiaoshoubang_page.dart';
import 'package:flutter_app/page/video_page.dart';
import 'package:flutter_app/view/views.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/custom_scroll_physics.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/photo_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class BigTitleWidget extends StatelessWidget {
  final String title;
  final bool isShowMore;
  final Function onTap;
  final bool isBottom;
  final bool isPadding;

  const BigTitleWidget({Key key, this.title, this.isShowMore, this.onTap, this.isBottom, this.isPadding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPadding ?? true ? EdgeInsets.only(left: 17, bottom: isBottom ?? false ? 17 : 0) : EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            height: 14,
            width: 4,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 8),
          MyText(title ?? '标题', size: 16, isBold: true, color: Common.black),
          Spacer(),
          if (isShowMore ?? false)
            WidgetTap(
              isElastic: true,
              onTap: onTap,
              child: Container(
                padding: isPadding ?? true ? EdgeInsets.symmetric(horizontal: 22) : EdgeInsets.zero,
                child: MyText('更多', isBold: true, color: Common.black),
              ),
            ),
        ],
      ),
    );
  }
}

class CaidanWidget extends StatefulWidget {
  @override
  _CaidanWidgetState createState() => _CaidanWidgetState();
}

class _CaidanWidgetState extends State<CaidanWidget> {
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
    {
      'img': 'assets/img/yaoqing_qq.png',
      'name': 'test',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(caidanList1.length, (i) {
            return Expanded(
              child: WidgetTap(
                isElastic: true,
                onTap: () {
                  switch (i) {
                    case 0:
                      // jumpPage(MapPage(), isMoveBtm: true);
                      break;
                    case 1:
                      jumpPage(SunpanPage());
                      break;
                    case 2:
                      jumpPage(PinpaiPage());
                      break;
                    case 3:
                      jumpPage(FangdaiPage());
                      break;
                    default:
                      jumpPage(BangniPage());
                      // showToast('开发中');
                      break;
                  }
                },
                child: TweenWidget(
                  axis: Axis.vertical,
                  delayed: 200,
                  child: Column(
                    children: [
                      // TweenWidget(
                      //   isScale: true,
                      //   value: 1,
                      //   delayed: 100 + 50 * i,
                      //   curve: ElasticOutCurve(1),
                      //   time: 500,
                      //   child: Image.asset(
                      //     caidanList1[i]['img'],
                      //     width: 40,
                      //     height: 40,
                      //   ),
                      // ),
                      Image.asset(
                        caidanList1[i]['img'],
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 8),
                      MyText(caidanList1[i]['name'], size: 12)
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 18),
        Row(
          children: List.generate(caidanList2.length, (i) {
            return Expanded(
              child: WidgetTap(
                isElastic: true,
                onTap: () {
                  switch (i) {
                    case 0:
                      jumpPage(RenqibangPage());
                      break;
                    case 1:
                      jumpPage(XiaoshoubangPage());
                      break;
                    case 2:
                      jumpPage(ChengjiaoPage());
                      break;
                    case 3:
                      jumpPage(GoufangZiliao(isZige: true));
                      break;
                    default:
                      jumpPage(GoufangZiliao());
                      break;
                  }
                },
                child: TweenWidget(
                  axis: Axis.vertical,
                  delayed: 300,
                  child: Column(
                    children: [
                      // TweenWidget(
                      //   isScale: true,
                      //   value: 1,
                      //   delayed: 300 + 50 * i,
                      //   curve: ElasticOutCurve(1),
                      //   time: 500,
                      //   child: Image.asset(
                      //     caidanList2[i]['img'],
                      //     width: 40,
                      //     height: 40,
                      //   ),
                      // ),
                      Image.asset(
                        caidanList2[i]['img'],
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 8),
                      MyText(caidanList2[i]['name'], size: 12)
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class ZixunWidget extends StatelessWidget {
  final Map data;
  const ZixunWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 17, right: 17, top: 17, bottom: 26),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 109,
          child: Stack(
            children: [
              Positioned.fill(
                child: WrapperImage(
                  url: data['preview'],
                  height: 100,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Image.asset(
                  'assets/img/home_remen.png',
                  width: 48,
                  height: 24,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 34,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 12),
                  child: MyText(
                    data['title'] ?? '深圳湾科技生态园',
                    size: 13,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0xff202020)],
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

class BtnWidget extends StatelessWidget {
  final List<String> titles;
  final List<Function> onTap;
  final List<Axis> axis;
  final List<bool> isScale;
  final List<int> time;
  final List<double> value;
  final List<Curve> curve;
  final List<int> delayed;
  final List<double> btnHeight;
  final bool isShowOnlyOne;
  final bool isShowShadow;
  final Color bgColor;
  final EdgeInsetsGeometry padding;

  const BtnWidget({
    Key key,
    this.titles = const [],
    this.onTap = const [],
    this.isShowOnlyOne = false,
    this.isShowShadow = true,
    this.axis = const [Axis.horizontal, Axis.horizontal],
    this.isScale = const [false, false],
    this.time = const [400, 400],
    this.value = const [100, 100],
    this.curve = const [Curves.easeOutCubic, Curves.easeOutCubic],
    this.delayed = const [null, null],
    this.padding,
    this.bgColor,
    this.btnHeight = const [12, 14],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        boxShadow: isShowShadow ? [BoxShadow(blurRadius: 4, color: Colors.black12)] : [],
      ),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (!isShowOnlyOne)
            Expanded(
              child: TweenWidget(
                axis: axis[0],
                isScale: isScale[0],
                time: time[0],
                value: value[0],
                curve: curve[0],
                delayed: delayed[0],
                isOpacity: true,
                child: WidgetTap(
                  isElastic: true,
                  onTap: onTap.isEmpty ? () {} : onTap[0],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(width: 1.5, color: Theme.of(context).primaryColor),
                    ),
                    padding: EdgeInsets.symmetric(vertical: btnHeight[0]),
                    child: MyText(titles.isEmpty ? '重置' : titles[0], color: Theme.of(context).primaryColor, textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          if (!isShowOnlyOne) SizedBox(width: 16),
          Expanded(
            child: TweenWidget(
              axis: axis[1],
              isScale: isScale[1],
              time: time[1],
              value: value[1],
              curve: curve[1],
              delayed: delayed[1],
              isOpacity: true,
              child: WidgetTap(
                isElastic: true,
                onTap: onTap.isEmpty ? () {} : onTap[1],
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: btnHeight[1]),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: MyText(titles.isEmpty ? '开始计算' : titles[1], color: Colors.white, textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemEditWidget extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final String title;
  final Color titleColor;
  final Color color;
  final Color selectoColor;
  final double titleWidth;
  final TextEditingController textCon;
  final String hint;
  final bool isInt;
  final bool isDouble;
  final bool isAz;
  final bool isEditText;
  final bool isSelecto;
  final bool isShowDivider;
  final String selectoText;
  final Function selectoOnTap;
  final Function(bool) othrOntap;
  final bool isText;
  final dynamic text;
  final bool isNoShowTitle;
  final bool isCheck;
  final bool isBoldTitle;
  final bool isShowJt;
  final MainAxisAlignment selectoMainAxisAlignment;
  final Widget rightChild;

  const ItemEditWidget({
    Key key,
    this.padding,
    this.title,
    this.titleWidth,
    this.textCon,
    this.hint,
    this.isInt = false,
    this.isDouble = false,
    this.isAz = false,
    this.isEditText = false,
    this.isSelecto = false,
    this.selectoOnTap,
    this.selectoText,
    this.isShowDivider = true,
    this.isText = false,
    this.text,
    this.titleColor,
    this.isNoShowTitle = false,
    this.isCheck = false,
    this.isBoldTitle = false,
    this.color,
    this.selectoColor,
    this.rightChild,
    this.isShowJt = true,
    this.selectoMainAxisAlignment,
    this.othrOntap,
  }) : super(key: key);
  @override
  _ItemEditWidgetState createState() => _ItemEditWidgetState();
}

class _ItemEditWidgetState extends State<ItemEditWidget> {
  bool isBenren = false;

  @override
  Widget build(BuildContext context) {
    return WidgetTap(
      onTap: widget.selectoOnTap ?? () {},
      child: Container(
        padding: widget.padding ?? EdgeInsets.all(15),
        color: widget.color,
        child: Row(
          children: [
            if (!widget.isNoShowTitle)
              if (widget.isShowDivider)
                if (widget.title.contains('*'))
                  SizedBox(
                    width: widget.titleWidth ?? 100,
                    child: MyText(
                      '*',
                      isOverflow: false,
                      color: Colors.red,
                      children: [
                        MyText.ts(
                          (widget.title ?? 'text').replaceAll('*', ''),
                          isBold: widget.isBoldTitle,
                          color: widget.titleColor ?? Color(0xff999999),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: widget.titleWidth ?? 100,
                    child: MyText(
                      (widget.title ?? 'text').replaceAll('*', ''),
                      isBold: widget.isBoldTitle,
                      isOverflow: false,
                      color: widget.titleColor ?? Color(0xff999999),
                    ),
                  )
              else
                Expanded(
                  child: MyText(
                    (widget.title ?? 'text').replaceAll('*', ''),
                    isBold: widget.isBoldTitle,
                    color: widget.titleColor ?? Color(0xff999999),
                  ),
                ),
            if (!widget.isNoShowTitle)
              if (widget.isShowDivider)
                Container(
                  height: 19,
                  width: 1,
                  color: Colors.black12,
                ),
            if (widget.isEditText)
              buildTFView(
                context,
                hintText: widget.hint ?? '请输入${widget.title.replaceAll('*', '')}',
                hintColor: Colors.black.withOpacity(0.25),
                isExp: true,
                isInt: widget.isInt,
                isDouble: widget.isDouble,
                isAz: widget.isAz,
                textAlign: TextAlign.right,
                onChanged: (v) => setState(() {}),
                con: widget.textCon,
                textInputAction: TextInputAction.search,
                // onSubmitted: (v) => widget.onSubmitted(v),
              ),
            if (widget.isSelecto)
              Expanded(
                child: Row(
                  mainAxisAlignment: widget.selectoMainAxisAlignment ?? MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: MyText(
                        widget.selectoText ?? '请选择',
                        color: widget.selectoText == null ? Color(0xff999999) : widget.selectoColor ?? Colors.black,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    if (widget.isShowJt)
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                      ),
                  ],
                ),
              ),
            if (widget.text != null)
              Expanded(
                child: MyText(
                  widget.text,
                  isOverflow: false,
                  textAlign: TextAlign.end,
                ),
              ),
            if (widget.isCheck)
              Expanded(
                child: WidgetTap(
                  onTap: () {
                    setState(() {
                      isBenren = !isBenren;
                    });
                    widget.othrOntap(isBenren);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.check_box_outlined,
                        color: isBenren ?? false ? Theme.of(context).primaryColor : Color(0xff999999),
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      MyText('本人看房', color: Color(0xff999999)),
                    ],
                  ),
                ),
              ),
            if (widget.rightChild != null) widget.rightChild,
          ],
        ),
      ),
    );
  }
}

class MyColumn extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;

  const MyColumn({Key key, this.padding, this.children, this.mainAxisSize, this.crossAxisAlignment, this.mainAxisAlignment, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        children: children ?? [],
      ),
    );
  }
}

class LunboWidget extends StatefulWidget {
  final Map data;
  const LunboWidget(this.data, {Key key}) : super(key: key);

  @override
  _LunboWidgetState createState() => _LunboWidgetState();
}

class _LunboWidgetState extends State<LunboWidget> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var pageIndex = 1;
  TabController tabCon;
  PageController pageCon = PageController();

  List<String> imgList = [];
  List pageList = [
    {
      'name': 'VR',
      'data': [],
    },
    {
      'name': '图片',
      'data': [],
    },
    {
      'name': '视频',
      'data': [],
    },
  ];

  @override
  void initState() {
    imgList = widget.data['images'].toString().split(';');
    this.initData();
    super.initState();
  }

  List data = [];

  ///初始化函数
  Future initData() async {
    data = widget.data['introduce'] as List;
    data.forEach((f) {
      switch (f['fileType']) {

        ///图片
        case 4:
          pageList[1]['data'].add(f['fileUrl']);
          break;

        ///视频
        case 2:
          pageList[2]['data'].add(f['fileUrl']);
          break;

        ///VR
        case 3:
          pageList[0]['data'].add(f['fileUrl']);
          break;
      }
    });
    tabCon = TabController(length: 3, vsync: this);
    tabCon.addListener(() {
      setState(() => pageIndex = tabCon.index + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 214,
      child: Stack(
        children: [
          PageView(
            controller: pageCon,
            onPageChanged: (i) => setState(() => pageIndex = i + 1),
            physics: PagePhysics(parent: ClampingScrollPhysics()),
            children: List.generate(data.length, (i) {
              return Stack(
                children: [
                  if (data[i]['fileType'] == 4)
                    Positioned.fill(
                      child: WidgetTap(
                        onTap: () {
                          jumpPage(
                            PhotoView(
                              images: data.where((m) => m['fileType'] == 4).map((m) => m['fileUrl'].toString().split(';').first).toList(),
                              isUrl: true,
                            ),
                            isMoveBtm: true,
                          );
                        },
                        child: WrapperImage(
                          height: 200,
                          urlBuilder: () {
                            return data[i]['fileUrl'].toString().split(';').first;
                          },
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: WrapperImage(
                        height: 200,
                        urlBuilder: () {
                          return {
                            2: data[i]['preview'] ?? widget.data['images'].toString().split(';').first,
                            3: data[i]['preview'] ?? widget.data['images'].toString().split(';').first,
                            4: data[i]['fileUrl'],
                          }[data[i]['fileType']];
                        },
                      ),
                    ),
                  if (data[i]['fileType'] == 3)
                    Container(
                      alignment: Alignment.center,
                      color: Colors.black26,
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(
                            VrVideoPage(
                              url: data[i]['fileUrl'],
                            ),
                            isMoveBtm: true,
                          );
                        },
                        child: Image.asset(
                          'assets/img/loupan_vr.png',
                          width: 82,
                          height: 82,
                        ),
                      ),
                    ),
                  if (data[i]['fileType'] == 2)
                    Container(
                      alignment: Alignment.center,
                      color: Colors.black26,
                      child: WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(
                            VideoApp(
                              videoId: data[i]['fileUrl'],
                              // videoId:'https://pull-hls-f11.douyincdn.com/stage/stream-108850429236084837_or4.m3u8',
                              isPlay: true,
                            ),
                            isMoveBtm: true,
                          );
                        },
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          size: 82,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: 29),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(25),
          //       child: Container(
          //         height: 25,
          //         color: Colors.white.withOpacity(0.9),
          //         child: TabBar(
          //           controller: tabCon,
          //           indicatorSize: TabBarIndicatorSize.tab,
          //           isScrollable: true,
          //           indicatorColor: Theme.of(context).primaryColor,
          //           unselectedLabelColor: Common.black,
          //           indicator: BoxDecoration(
          //             borderRadius: BorderRadius.circular(56),
          //             color: Theme.of(context).primaryColor,
          //           ),
          //           labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          //           labelPadding: EdgeInsets.symmetric(horizontal: 10),
          //           labelColor: Colors.white,
          //           tabs: pageList.map((m) {
          //             return Padding(
          //               padding: EdgeInsets.only(top: 2),
          //               child: Tab(text: m['name']),
          //             );
          //           }).toList(),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 29,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(56),
              child: Container(
                color: Colors.black45,
                padding: EdgeInsets.only(left: 14, right: 14, bottom: 6, top: 5),
                child: MyText(
                  '$pageIndex/${data.length}',
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class LoupanItem extends StatelessWidget {
  final int i;
  final Map data;
  final bool isNoShowTherOther;
  final int index;
  const LoupanItem({Key key, this.i, this.data, this.isNoShowTherOther = false, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: WrapperImage(
                urlBuilder: () => data['images'].toString().split(';').first,
                height: 95,
                width: 106,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyText(
                          isNull(data, 'award'),
                          nullValue: '暂无佣金',
                          // data != null ? data[''] : '最高奖金18000.00元/套',
                          color: Color(0xffD2353A),
                          isBold: true,
                        ),
                      ),
                      if (!isNoShowTherOther)
                        Container(
                          padding: EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 3,
                            bottom: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color([0xffE0F0EF, 0xffF0E0E0][isNull(data, 'saleStatus') == '在售' ? 0 : 1]),
                            borderRadius: BorderRadius.circular(56),
                          ),
                          child: MyText(
                            isNull(data, 'saleStatus'),
                            isBold: true,
                            color: Color(
                              [
                                0xff58AB9D,
                                0xffD2353A,
                              ][isNull(data, 'saleStatus') == '在售' ? 0 : 1],
                            ),
                          ),
                        ),
                    ],
                  ),
                  MyText(isNull(data, 'buildingName', '长城花园'), isBold: true, size: 13),
                  // MyText(data == null ? '未知' : data['area'] ?? '福田区', size: 12, color: Color(0xff666666)),
                  MyText(isNull(data, 'areaName'), size: 12, color: Color(0xff666666)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isNoShowTherOther)
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/home_chakan.png',
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(width: 2),
                            MyText(
                              isNull(data, 'views'),
                              size: 10,
                              color: Color(0xff666666),
                            ),
                            SizedBox(width: 15),
                            Image.asset(
                              'assets/img/home_fenxiang.png',
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(width: 2),
                            MyText(
                              isNull(data, 'shares'),
                              size: 10,
                              color: Color(0xff666666),
                            ),
                          ],
                        ),
                      Expanded(
                        child: MyText(
                          '${data['consultAvgPrice']}元/㎡',
                          color: Color(0xffFF6904),
                          isBold: true,
                          textAlign: isNoShowTherOther ? null : TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isNoShowTherOther)
              Icon(
                i == index ? Icons.check_circle_outline_rounded : Icons.check,
                size: 16,
                color: i == index ? Theme.of(context).primaryColor : Colors.black26,
              )
          ],
        ),
      ),
    );
  }
}

import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/tween_widget.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import '../util/utils.dart';
import '../widget/sheet_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'CPicker_widget.dart';
import 'button.dart';
import 'inkbtn_widget.dart';
import 'my_classicHeader.dart' as myh;
import 'mylistview.dart';
import 'mytext.dart';

///
///全局可用的小功能
///

///分割线
const divider = Divider(
  color: Color(0x10000000),
  thickness: 1,
  indent: 18,
  height: 0,
  endIndent: 18,
);

///屏幕宽高
Size size(context) => MediaQuery.of(context).size;

///屏幕顶部和底部
EdgeInsets padd(context) => MediaQuery.of(context).padding;

///屏幕宽高
Size get pmSize => MediaQuery.of(context!).size;

///屏幕顶部和底部
EdgeInsets get pmPadd => MediaQuery.of(context!).padding;

///选择器
Future showSelecto(
  BuildContext context, {
  void Function(String, int)? callback,
  List texts = const ['不限', '1~3', '3~5'],
}) {
  var value = texts.first;
  var index = 0;
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child: Container(
          height: size(context).width / 1.5,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        print(index);
                        print(value.toString());
                        callback!(value.toString(), index);
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CPickerWidget(
                  onSelectedItemChanged: (i) {
                    index = i;
                    value = texts[i];
                  },
                  children: texts.map(
                    (v) {
                      return Text(
                        v.toString(),
                        style: TextStyle(fontSize: 18),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///选择器
Future showSelectoBtn(
  BuildContext context, {
  void Function(String, int)? callback,
  List texts = const ['不限', '1~3', '3~5'],
}) {
  // var value = texts.first;
  // var index = 0;
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child: Container(
          // height: size(context).width / 1.5,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyListView(
                isShuaxin: false,
                flag: !false,
                listViewType: ListViewType.Separated,
                divider: Divider(height: 0),
                itemCount: texts.length,
                physics: NeverScrollableScrollPhysics(),
                item: (i) {
                  return WidgetTap(
                    isElastic: true,
                    onTap: () {
                      callback!(texts[i], i);
                      close();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      child: MyText(texts[i], size: 16),
                    ),
                  );
                },
              ),
              Divider(height: 0),
              Container(height: 8, color: Colors.black.withOpacity(0.025)),
              WidgetTap(
                isElastic: true,
                onTap: () => close(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: MyText('取消', size: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///选择器
Future showPopup(
  BuildContext context, {
  void Function(List)? callback,
  List<Widget>? children,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showSheetWidget(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => pop(context),
              child: Container(),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children!,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

///选择器
Future showSelectoindex(
  BuildContext context, {
  void Function(String)? callback,
  List texts = const ['不限', '1~3', '3~5'],
}) {
  var value = 0;
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      callback!(value.toString());
                    },
                    child: Text(
                      '确认',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 48,
                magnification: 1.25,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onSelectedItemChanged: (i) => value = i,
                children: texts.map((v) {
                  return Center(
                    child: Text(
                      v.toString(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

///底部悬浮菜单
showSheet(
  BuildContext context, {
  List<Widget> children = const <Widget>[],
  Widget? builder,
}) {
  return showSheetWidget(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return builder != null
          ? builder
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
              ),
            );
    },
  );
}

///加载框
buildShowDialog(
  context, {
  isClose = false,
  String? text,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showDialog(
    context: context,
    barrierDismissible: isClose, //x点击空白关闭
    builder: (_) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          child: LoadingIndicator(
            colors: [Colors.white],
            indicatorType: Indicator.ballPulse,
          ),
        ),
        if (text != null) SizedBox(height: 8),
        if (text != null) MyText(text.toString(), color: Colors.white)
      ],
    ),
  );
}

///加载框
Widget buildLoad({
  ///大小
  double size = 32,
  double radius = 10,

  ///粗细
  double width = 2,

  ///是否居中
  bool isCenter = true,

  ///颜色
  Color? color,
}) {
  if (isCenter) {
    // return Center(
    //   child: CupertinoActivityIndicator(radius: radius),
    // );
    return Center(
      child: Container(
        height: size,
        alignment: Alignment.center,
        child: LoadingIndicator(
          colors: [color ?? Colors.black26],
          indicatorType: Indicator.ballPulse,
        ),
      ),
    );
  } else {
    // return CupertinoActivityIndicator(radius: radius);
    return Container(
      height: size,
      alignment: Alignment.center,
      child: LoadingIndicator(
        colors: [color ?? Colors.black26],
        indicatorType: Indicator.ballPulse,
      ),
    );
  }
}

Widget buildBallPulse({
  Color color = Colors.white54,
  double height = 32,
}) {
  return SizedBox(
    height: height,
    child: LoadingIndicator(
      colors: [color],
      indicatorType: Indicator.ballPulse,
    ),
  );
}

///上拉加载更多的底部
CustomFooter buildCustomFooter({
  Color? color,
}) {
  color = color ?? Colors.black26;
  var dataModel = DataModel(flag: 3);
  return CustomFooter(
    builder: (BuildContext? context, LoadStatus? mode) {
      Widget? body;
      if (mode == LoadStatus.idle) {
        body = Text("上拉加载更多", style: TextStyle(color: color), key: ValueKey(1));
      } else if (mode == LoadStatus.loading) {
        body = Container(
            height: 32,
            child: LoadingIndicator(
                colors: [color!], indicatorType: Indicator.ballPulse));
      } else if (mode == LoadStatus.canLoading) {
        body = Text("松开", style: TextStyle(color: color), key: ValueKey(2));
      } else if (mode == LoadStatus.failed) {
        body = Text("加载失败", style: TextStyle(color: color));
      } else if (mode == LoadStatus.noMore) {
        body = Text("松开", style: TextStyle(color: color));
      }
      return Container(
        height: 56,
        child: AnimatedSwitchBuilder(
          value: dataModel,
          alignment: Alignment.center,
          defaultBuilder: () => body!,
          errorOnTap: () {},
        ),
      );
    },
  );
}

///下拉刷新的头部
myh.MyClassicHeader buildClassicHeader({
  Color? color,
}) {
  color = color ?? Colors.black26;
  return myh.MyClassicHeader(
    height: 56.0,
    textStyle: TextStyle(color: color),
    releaseText: '松开刷新',
    completeText: '刷新成功',
    failedText: '刷新失败',
    idleText: '下拉刷新',
    refreshStyle: RefreshStyle.Follow,
    refreshingIcon: Container(
      height: 32,
      child: LoadingIndicator(
        colors: [color],
        indicatorType: Indicator.ballPulse,
      ),
    ),
  );
}

///初始化显示的试图
Center buildNoDataOrInitView(isInit, [text = '暂无数据', key]) {
  return Center(
    key: ValueKey(key),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (isInit)
          Column(
            children: <Widget>[
              CupertinoActivityIndicator(radius: 8),
              SizedBox(height: 8),
            ],
          ),
        Text(
          isInit ? '请稍候' : text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    ),
  );
}

///初始化显示的试图
Center buildNoDataOrInitView2(isInit, Function() callbackgowuche,
    [text = ''
        '暂无数'
        '据',
    key]) {
  return Center(
    key: ValueKey(key),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (isInit)
          Column(
            children: <Widget>[
              CupertinoActivityIndicator(radius: 8),
              SizedBox(height: 8),
            ],
          ),
        if (!isInit)
          Image.asset(
            'assets/img/mao@2x.png',
            width: 187,
            height: 153,
          ),
        SizedBox(height: 16),
        if (!isInit)
          SizedBox(
            height: 20,
          ),
        Text(
          isInit ? '请稍候' : text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        if (!isInit)
          SizedBox(
            height: 20,
          ),
        if (!isInit)
          GestureDetector(
            onTap: callbackgowuche,
            // app.pageCon.jumpToPage(0);
            // app.changeIndex(0);
            // closePage(count: app.spFlag);

            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 100),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  color: Color(0xffE7011D),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: MyText("马上去购物", color: Colors.white),
            ),
          )
      ],
    ),
  );
}

///标题栏
Widget buildTitle(
  BuildContext context, {
  Color bwColor = const Color(0x20ffffff),
  Color widgetColor = Colors.black,
  Widget? rigthWidget,
  Widget? leftIcon,
  String title = '标题',
  Function()? rightCallback,
  Function? leftCallback,
  bool isHongBao = false,
  bool isNoShowLeft = !true,
  bool isTitleBold = true,
  int s = 0,
  Color? color,
  bool isShowBorder = false,
  bool isAnima = false,
  double sigma = 0.0,
}) {
  return sigma == 0.0
      ? AnimatedContainer(
          duration: Duration(milliseconds: 250),
          color: color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: padd(context).top),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: isShowBorder ? Colors.black12 : Colors.transparent,
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    if (!isNoShowLeft)
                      Stack(
                        children: <Widget>[
                          if (isHongBao)
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Row(
                                children: <Widget>[
                                  InkBtn(
                                    bwColor: bwColor,
                                    onTap: () {
                                      if (leftCallback == null) {
                                        Navigator.pop(context);
                                      } else {
                                        leftCallback();
                                      }
                                    },
                                    child: RouteState.isFromDown
                                        ? Icon(Icons.close)
                                        : SvgPicture.asset(
                                            'package/paixs_utils/assets/svg/back.svg',
                                          ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(56),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      color: widgetColor,
                                      child: MyText('$s'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                splashColor: bwColor,
                                icon: leftIcon ??
                                    (RouteState.isFromDown
                                        ? TweenWidget(
                                            delayed: 300,
                                            time: 750,
                                            axis: Axis.vertical,
                                            curve: ElasticOutCurve(1),
                                            child: Icon(Icons.close),
                                          )
                                        : TweenWidget(
                                            delayed: 300,
                                            time: 750,
                                            value: 50,
                                            curve: ElasticOutCurve(1),
                                            child: SvgPicture.asset(
                                              'package/paixs_utils/assets/svg/back.svg',
                                              width: 20,
                                              height: 20,
                                              color: widgetColor,
                                            ),
                                          )),
                                onPressed: () {
                                  if (leftCallback == null) {
                                    Navigator.pop(context);
                                  } else {
                                    leftCallback();
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    if (rigthWidget != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: rightCallback,
                            radius: 20,
                            child: Container(
                              alignment: Alignment.center,
                              // padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: rigthWidget,
                            ),
                          ),
                        ),
                      ),
                    if (isNoShowLeft || RouteState.isFromDown)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 56),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  List.generate(title.split('').length, (i) {
                                return TweenWidget(
                                  delayed: RouteState.isFromDown
                                      ? 200 + 10 * i
                                      : 50 + 10 * i,
                                  time: 750,
                                  value: RouteState.isFromDown ? 100 : 8,
                                  axis: Axis.vertical,
                                  curve: ElasticOutCurve(1),
                                  child: Text(
                                    title.split('')[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widgetColor,
                                      fontWeight: isTitleBold
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 56),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  List.generate(title.split('').length, (i) {
                                return TweenWidget(
                                  delayed: 200 +
                                      (title.split('').length <= 2 ? 50 : 20) *
                                          i,
                                  time: 750,
                                  value:
                                      (title.split('').length <= 2 ? 48 : 24),
                                  curve: ElasticOutCurve(1),
                                  child: Text(
                                    title.split('')[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widgetColor,
                                      fontWeight: isTitleBold
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: WidgetTap(
                    //     isElastic: true,
                    //     child: Padding(
                    //       padding: EdgeInsets.all(16.0),
                    //       child: Icon(
                    //         Icons.account_circle_outlined,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        )
      : ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              color: color,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: padd(context).top),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: isShowBorder
                              ? Colors.black12
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (!isNoShowLeft)
                          Stack(
                            children: <Widget>[
                              if (isHongBao)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Row(
                                    children: <Widget>[
                                      InkBtn(
                                        bwColor: bwColor,
                                        onTap: () {
                                          if (leftCallback == null) {
                                            Navigator.pop(context);
                                          } else {
                                            leftCallback();
                                          }
                                        },
                                        child: RouteState.isFromDown
                                            ? Icon(Icons.close)
                                            : SvgPicture.asset(
                                                'package/paixs_utils/assets/svg/back.svg',
                                              ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(56),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          color: widgetColor,
                                          child: MyText('$s'),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    splashColor: bwColor,
                                    icon: leftIcon ??
                                        (RouteState.isFromDown
                                            ? TweenWidget(
                                                delayed: 100,
                                                time: 1000,
                                                value: 50,
                                                axis: Axis.vertical,
                                                curve: ElasticOutCurve(1),
                                                child: Icon(Icons.close),
                                              )
                                            : TweenWidget(
                                                delayed: 100,
                                                time: 1000,
                                                value: 50,
                                                curve: ElasticOutCurve(1),
                                                child: SvgPicture.asset(
                                                  'package/paixs_utils/assets/svg/back.svg',
                                                  width: 20,
                                                  height: 20,
                                                  color: widgetColor,
                                                ),
                                              )),
                                    onPressed: () {
                                      if (leftCallback == null) {
                                        Navigator.pop(context);
                                      } else {
                                        leftCallback();
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        if (rigthWidget != null)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: rightCallback,
                                radius: 20,
                                child: Container(
                                  alignment: Alignment.center,
                                  // padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: rigthWidget,
                                ),
                              ),
                            ),
                          ),
                        if (isNoShowLeft || RouteState.isFromDown)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 56),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    List.generate(title.split('').length, (i) {
                                  return TweenWidget(
                                    delayed: 50 + 50 * i,
                                    time: 750,
                                    value: RouteState.isFromDown ? 100 : 8,
                                    axis: Axis.vertical,
                                    curve: ElasticOutCurve(1),
                                    child: Text(
                                      title.split('')[i],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: widgetColor,
                                        fontWeight: isTitleBold
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 56),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    List.generate(title.split('').length, (i) {
                                  return TweenWidget(
                                    delayed: 50 + 50 * i,
                                    time: 750,
                                    value: 16,
                                    curve: ElasticOutCurve(1),
                                    child: Text(
                                      title.split('')[i],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: widgetColor,
                                        fontWeight: isTitleBold
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        // Center(
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 56),
                        //     child: Text(
                        //       title,
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //         color: widgetColor,
                        //         fontWeight: isTitleBold ? FontWeight.bold : FontWeight.normal,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: WidgetTap(
                        //     isElastic: true,
                        //     child: Padding(
                        //       padding: EdgeInsets.all(16.0),
                        //       child: Icon(
                        //         Icons.account_circle_outlined,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}

Future showTc({
  String? title,
  Widget? titleView,
  String? content,
  String cancelText = '取消',
  String okText = '确定',
  Color? okColor,
  bool isClose = true,
  bool isNoCancel = false,
  required Function() onPressed,
  Function()? onCancel,
}) {
  return showGeneralDialog(
    context: context!,
    barrierLabel: "你好",
    barrierColor: Colors.black45,
    // transitionDuration: Duration(milliseconds: 500),
    // transitionBuilder: (_, a1, a2, child) {
    //   return FadeTransition(
    //     opacity: a1.drive(CurveTween(curve: Interval(0.25, 0.5))),
    //     child: ScaleTransition(
    //       scale: a1.drive(CurveTween(curve: ElasticOutCurve(1.75))),
    //       child: child,
    //     ),
    //   );
    // },
    pageBuilder: (_, __, ___) {
      return WillPopScope(
        onWillPop: () => Future(() => isClose),
        child: GestureDetector(
          onTap: () {
            if (isClose) pop(context!);
          },
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (titleView != null)
                            Padding(
                              // padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16)
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 32,
                                  bottom: content == null ? 32 : 16),
                              child: titleView,
                            ),
                          if (title != null)
                            Padding(
                              // padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16)
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 32,
                                  bottom: content == null ? 32 : 16),
                              child: MyText(
                                title,
                                size: 18,
                                isBold: true,
                                isOverflow: false,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (content != null)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 32,
                                  top: title == null ? 32 : 0),
                              child: MyText(
                                content,
                                size: 16,
                                isBold: true,
                                color: Colors.black,
                                isOverflow: false,
                              ),
                            ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            color: Color(0x10000000),
                          ),
                          Row(
                            children: <Widget>[
                              if (!isNoCancel)
                                Expanded(
                                  child: Button(
                                    height: 40,
                                    onPressed: () {
                                      pop(context!);
                                      if (onCancel != null) onCancel();
                                    },
                                    child:
                                        MyText(cancelText, color: Colors.black),
                                  ),
                                ),
                              Container(
                                  height: 32,
                                  width: 1,
                                  color: Color(0x10000000)),
                              Expanded(
                                child: Button(
                                  height: 40,
                                  onPressed: () {
                                    pop(context!);
                                    onPressed();
                                  },
                                  child: MyText(okText,
                                      color: Theme.of(context!)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

///小图
String getSmall([w = 100]) => ''; //?x-oss-process=image/resize,w_$w

///大图
String getBig([w = 500]) => ''; //?x-oss-process=image/resize,w_$w

Future showTc1({
  String? title,
  String? content,
  String cancelText = '取消',
  String okText = '确定',
  Color? okColor,
  bool isClose = true,
  bool isNoCancel = false,
  List<Widget> children = const [],
  String? image,
  double? imgHeight,
  double? imgWidth,
  int type = 0, //0：带图片的弹窗，1：纯文本弹窗
  bool isExp = false,
  bool isCenter = false,
  EdgeInsets? padding,
  bool isImg = false,
  Function()? onPressed,
}) {
  return showGeneralDialog(
    context: context!,
    barrierLabel: "你好",
    barrierColor: Colors.black45,
    barrierDismissible: !isClose,
    pageBuilder: (_, __, ___) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => pop(context!),
          child: Material(
            color: Colors.black.withOpacity(0.0),
            child: Center(
              child: GestureDetector(
                onTap: isImg ? () => close() : () {},
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isExp)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isImg ? 0 : 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      MyListView(
                                        isShuaxin: false,
                                        itemCount: children.length,
                                        listViewType:
                                            ListViewType.SeparatedExpanded,
                                        padding: padding ??
                                            onlyEdgeInset(
                                                0,
                                                type == 0
                                                    ? imgHeight! / 3 + 16
                                                    : 16,
                                                0,
                                                type == 0 ? 40 : 16),
                                        // physics: NeverScrollableScrollPhysics(),
                                        divider: Divider(
                                            height: 16,
                                            color: Colors.transparent),
                                        item: (i) => children[i],
                                      ),
                                      if (type == 0)
                                        Button(
                                          onPressed: () {
                                            close();
                                            onPressed!();
                                          },
                                          isFill: true,
                                          radius: 56,
                                          width: double.infinity,
                                          fillColor: Color(0xffFFD102),
                                          child: MyText(okText,
                                              size: 15, isBold: true),
                                        ),
                                      if (type == 0) SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: isImg ? 0 : 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    MyListView(
                                      isShuaxin: false,
                                      itemCount: children.length,
                                      listViewType: ListViewType.Separated,
                                      // padding: padding ?? onlyEdgeInset(0, type == 0 ? imgHeight / 3 + 16 : 16, 0, type == 0 ? 40 : 16),
                                      // physics: NeverScrollableScrollPhysics(),
                                      divider: Divider(
                                          height: 16,
                                          color: Colors.transparent),
                                      item: (i) {
                                        if (isCenter) {
                                          return Center(child: children[i]);
                                        } else {
                                          return children[i];
                                        }
                                      },
                                    ),
                                  ],
                                ),
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
        ),
      );
    },
  );
}

////标题点击查看更多/双向标题
Widget buildTitleRight({
  String text = '月销售排行',
  Function()? onTap,
  bool isBold = true,
  Widget? rightChild,
  Widget? leftChild,
  Color? bgColor,
  double topheight = 16.0,
  double height = 16.0,
  double width = 16.0,
  double leftPadd = 16.0,
  double rightPadd = 16.0,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      color: bgColor,
      padding: EdgeInsets.only(
          top: height, bottom: height, left: leftPadd, right: rightPadd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (leftChild == null)
            MyText(
              text,
              size: 16,
              isBold: isBold,
            )
          else
            leftChild,
          if (rightChild == null)
            Transform.rotate(
              angle: pi,
              child: SvgPicture.asset(
                'package/paixs_utils/assets/svg/back.svg',
                width: 16,
                height: 16,
                color: Colors.black26,
              ),
            )
          else
            rightChild,
        ],
      ),
    ),
  );
}

///两个文字组合
Widget buildTwoText({
  String leftText = '5级',
  String nullValue = '暂无',
  dynamic rightText = '广州创客股份有限公司',
  Color leftColor = Colors.black,
  Color rightColor = Colors.grey,
}) {
  return MyText(
    '$leftText\t:\t',
    nullValue: nullValue,
    color: leftColor,
    isOverflow: false,
    children: [
      MyText.ts(
        rightText.toString(),
        color: rightColor,
        nullValue: nullValue,
      ),
    ],
  );
}

///圆角输入框
Widget buildTextField({
  double height = 33.0,
  bool enabled = true,
  Color bgColor = const Color(0x10000000),
  String hint = '请输入',
  TextEditingController? con,
  bool isExd = true,
  bool isBig = false,
  bool isRight = false,
  bool isLeft = false,
  bool isTran = false,
  int maxLines = 10,
  double? fontSize,
  Color borderColor = const Color(0x10000000),
  void Function()? onEditingComplete,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  TextInputAction? textInputAction,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  TextInputType? keyboardType,
  FocusNode? focusNode,
  TextStyle? textStyle,
  EdgeInsetsGeometry? contentPadding,
}) {
  if (isLeft) {
    return Expanded(
      child: TextField(
        controller: con,
        enabled: enabled,
        focusNode: focusNode,
        style: TextStyle(fontSize: fontSize),
        // textAlign: TextAlign.end,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          hintText: '$hint\t\t',
          hintStyle: TextStyle(color: Colors.black26, fontSize: fontSize),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isRight) {
    return Expanded(
      child: TextField(
        controller: con,
        enabled: enabled,
        focusNode: focusNode,
        style: TextStyle(fontSize: fontSize),
        textAlign: TextAlign.end,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: '$hint\t\t',
          hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isBig) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: borderColor)),
      child: TextField(
        controller: con,
        enabled: enabled,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        focusNode: focusNode,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: '\t\t$hint',
          contentPadding: contentPadding ?? EdgeInsets.all(8),
          hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isExd) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Container(
            height: height,
            padding: EdgeInsets.only(left: 23),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: borderColor),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: con,
              enabled: enabled,
              focusNode: focusNode,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              onEditingComplete: onEditingComplete,
              style: TextStyle(fontSize: fontSize),
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 8, right: 16),
                counterText: "",
                hintText: '$hint',
                hintStyle: TextStyle(
                  fontSize: fontSize,
                  color: Color(0xffCACBCD),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          Positioned(
            left: 11,
            child: SvgPicture.asset(
              'package/paixs_utils/assets/svg/sousuo.svg',
              width: 14,
              height: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      height: height,
      color: bgColor,
      alignment: Alignment.center,
      child: TextField(
        controller: con,
        enabled: enabled,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        textAlign: TextAlign.center,
        keyboardType: keyboardType,
        style: textStyle,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: '$hint',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

///圆角输入框
Widget buildTextField2({
  double height = 33.0,
  bool enabled = true,
  Color bgColor = const Color(0x10000000),
  String hint = '请输入',
  TextEditingController? con,
  bool isExd = true,
  bool isBig = false,
  bool isRight = false,
  int maxLines = 10,
  double fontSize = 16,
  Color borderColor = const Color(0x10000000),
  void Function()? onEditingComplete,
  void Function(String)? onSubmitted,
  TextInputAction? textInputAction,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  TextInputType? keyboardType,
}) {
  // con = TextEditingController();
  if (isRight) {
    return Expanded(
      child: Container(
        height: 40,
        child: TextField(
          controller: con,
          enabled: enabled,
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.end,
          onSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: '$hint\t\t',
            hintStyle: TextStyle(color: Color(0xffB1B1B1), fontSize: 12),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  } else if (isBig) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: borderColor)),
      child: TextField(
        controller: con,
        enabled: enabled,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: '\t\t$hint',
          contentPadding: EdgeInsets.all(8),
          hintStyle: TextStyle(color: Color(0xffB1B1B1), fontSize: 12),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isExd) {
    return Expanded(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: height,
              color: bgColor,
              padding: EdgeInsets.only(left: 6),
              alignment: Alignment.center,
              child: TextField(
                controller: con,
                enabled: enabled,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                onEditingComplete: onEditingComplete,
                style: TextStyle(fontSize: fontSize),
                inputFormatters: inputFormatters,
                maxLength: maxLength,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16, right: 48),
                  hintText: '\t\t$hint',
                  hintStyle: TextStyle(color: Color(0xffB1B1B1), fontSize: 12),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            child: GestureDetector(
              // onTap: () => onSubmitted(),
              child: SvgPicture.asset(
                'assets/svg/sousuo.svg',
                width: 12,
                height: 12,
                color: Color(0xffB1B1B1),
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: height,
            color: bgColor,
            alignment: Alignment.center,
            child: TextField(
              controller: con,
              enabled: enabled,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 48),
                hintText: '\t$hint',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          child: GestureDetector(
            // onTap: () => onSubmitted(con.text),
            child: SvgPicture.asset(
              'assets/svg/sousuo.svg',
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }
}

RichText buildRow(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    double? titlesize,
    double? contentsize,
    bool? titleisbold,
    bool? contentisbold}) {
  return RichText(
    text: TextSpan(
        text: title,
        style: TextStyle(
            color: titleColor ?? Color(0xff333333),
            fontSize: titlesize ?? 12,
            fontWeight:
                titleisbold == true ? FontWeight.bold : FontWeight.normal),
        children: <InlineSpan>[
          TextSpan(
              text: content,
              style: TextStyle(
                  color: contentColor ?? Color(0xff666666),
                  fontSize: contentsize ?? 12,
                  fontWeight: contentisbold == true
                      ? FontWeight.bold
                      : FontWeight.normal)),
        ]),
  );
}

Row buildRow1(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    double? titlesize,
    double? contentsize}) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
    Container(
      padding: EdgeInsets.only(bottom: 3),
      child: MyText(
        title,
        size: titlesize ?? 12,
        color: titleColor ?? Color(0xff333333),
      ),
    ),
    SizedBox(width: 0),
    Expanded(
      child: MyText(
        content,
        size: contentsize ?? 12,
        isOverflow: true,
        maxLines: 2,
        color: contentColor ?? Color(0xff666666),
      ),
    ),
  ]);
}

///默认文字样式
Widget buildDefText([text = '暂无回复']) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16),
    alignment: Alignment.center,
    child: MyText(text, size: 16, color: Colors.black26),
  );
}

RichText buildRow4(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    double? titlesize,
    double? contentsize}) {
  return RichText(
    text: TextSpan(
        text: title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: titleColor ?? Color(0xff333333),
            fontSize: titlesize ?? 12),
        children: <InlineSpan>[
          TextSpan(
              text: content,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: contentColor ?? Color(0xff666666),
                  fontSize: contentsize ?? 12)),
        ]),
  );
}

Row buildRow2(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    Size? titlesize,
    Size? contentsize}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(bottom: 3),
        child: MyText(
          title,
          size: titlesize != null ? (titlesize as num).toDouble() : 12.0,
          color: titleColor ?? Color(0xff333333),
        ),
      ),
      SizedBox(width: 0),
      Expanded(
        child: MyText(
          content,
          size: contentsize != null ? (titlesize as num).toDouble() : 12.0,
          isOverflow: true,
          maxLines: 50,
          color: contentColor ?? Color(0xff666666),
        ),
      ),
    ],
  );
}

EdgeInsets onlyEdgeInset([
  double left = 0,
  double top = 0,
  double right = 0,
  double bottom = 0,
]) =>
    EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);

BorderRadius onlyRadius([
  double topLeft = 8,
  double topRight = 8,
  double bottomLeft = 8,
  double bottomRight = 8,
]) =>
    BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );

BorderRadius allRadius([double radius = 8]) => BorderRadius.circular(radius);

// 显示加载框的方法
@protected
Future<void> showLoad(VoidFutureCallBack fn) async {
  buildShowDialog(context);
  fn.call().then((value) => pop(context!)).catchError((v) => pop(context!));
}

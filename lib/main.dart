import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
// import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
// import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
// import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart' as blf;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kqsc/page/home/loupan_page.dart';
import 'package:kqsc/page/home_page.dart';
import 'package:kqsc/page/my_page.dart';
import 'package:kqsc/page/shopping_page.dart';
import 'package:kqsc/page/video_page.dart';
import 'package:kqsc/page/wode/xieyi_page.dart';
import 'package:kqsc/page/xiaoxi_page.dart';
import 'package:kqsc/page/zixun_page.dart';
import 'package:kqsc/provider/chat_provider.dart';
import 'package:kqsc/provider/provider_config.dart';
import 'package:kqsc/widget/bnb_widget.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weibo_kit/weibo_kit.dart';
import 'widget/tween_widget.dart';
import 'widget/widgets.dart';
// ignore: implementation_imports
// ignore: implementation_imports

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS || Platform.isAndroid) {
    // await bd.enableFluttifyLog(true);
    // await bd.BmapService.instance.init(iosKey: 'm5LjBSEiEUf4g8z60ys9lRLi9uf5d9xi');
  }
  runApp(MultiProvider(providers: pros, child: MyApp()));
  // PaintingBinding.instance.imageCache.maximumSizeBytes = 5000 << 20;
  //缓存个数 100
  PaintingBinding.instance.imageCache.maximumSize = 1000;
  //缓存大小 50m
  PaintingBinding.instance.imageCache.maximumSizeBytes = 5000 << 20;
  // SystemChrome.setEnabledSystemUIOverlays([]);
  RouteState.isMove = true;
  RouteState.setOffsetState(false);
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails){
        print(flutterErrorDetails.toString());
        return Center(
          child: Text("app出故障了～"),
          );
    };
  // registerWxApi(appId: "wxdbcfb05b07ad1ac3", universalLink: "https://apple.rayt.cc/app/");
  // FlutterQq.registerQQ('101958688');
  Weibo.instance.registerApp(
    appKey: "200851199",
    redirectUrl: 'http://open.weibo.com/apps/200851199/privilege/oauth',
    universalLink: "https://your.univerallink.com/link/",
    scope: [WeiboScope.ALL],
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StyledToast(
      duration: Duration(seconds: 2),
      locale: const Locale('zh'),
      backgroundColor: Colors.black,
      toastAnimation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      toastPositions: StyledToastPosition.center,
      animDuration: Duration(milliseconds: 200),
      child: MaterialApp(
        title: '内当家驻场版',
        navigatorKey: navigatorKey,
        // showPerformanceOverlay: true,
        // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF6F6F6),
          primaryColor: Color(0xFF4A9DF6),
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          splashFactory: InkRipple.splashFactory,
        ),
        home: FlashPage(),
      ),
    );
  }
}

class FlashPage extends StatefulWidget {
  @override
  _FlashPageState createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  Timer timer;

  @override
  void initState() {
    this.init();
    super.initState();
  }

  Future<void> init() async {
    // setIsCanRunAnimation();
    await app.getDropDownList(false);
    await getLocation();
    await userPro.getUserInfo();
    await app.apiDataDictGetDropDownList();
    // await app.getLocalLocation();
    // if (app.lo == null) {
    // await getLocation();
    var isFtoApp = await userPro.isFirstTimeOpenApp();
    timer = Timer.periodic(Duration(seconds: 1), (v) async {
      flog(v.tick);
      if (v.tick == 1) {
        // await Future.delayed(Duration(milliseconds: 500));
        // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      }
      if (v.tick == 3) {
        if (isFtoApp) {
          showGeneralDialog(
            context: context,
            barrierColor: Colors.transparent,
            pageBuilder: (_, __, ___) => UserXiayi(),
          ).then((v) async {
            if (v) {
              await Future.delayed(Duration(milliseconds: 500));
              if (user == null) {
                // jumpPage(PassWordLogin(), isMove: false, isClose: true);
                jumpPage(App(), isMove: false, isClose: true);
              } else {
                await userPro.refreshToken();
                // jumpPage(PassWordLogin(), isMove: false, isClose: true);
                jumpPage(App(), isMove: false, isClose: true);
              }
            }
          });
        } else {
          if (user == null) {
            // jumpPage(PassWordLogin(), isMove: false, isClose: true);
            jumpPage(App(), isMove: false, isClose: true);
          } else {
            await userPro.refreshToken();
            // jumpPage(PassWordLogin(), isMove: false, isClose: true);
            jumpPage(App(), isMove: false, isClose: true);
          }
        }
      }
    });
    // } else {
    //   flog('请获取位置信息');
    // }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.light,
      bgColor: Theme.of(context).primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/qidongtu.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 89.5),
                TweenWidget(
                  isOpen: true,
                  key: ValueKey(Random()),
                  axis: Axis.vertical,
                  // isScale: true,
                  // value: 1,
                  time: 1000,
                  delayed: 500,
                  curve: ElasticOutCurve(1),
                  child: Image.asset(
                    'assets/img/l512.png',
                    width: 106,
                    height: 106,
                  ),
                ),
                SizedBox(height: 16),
                TweenWidget(
                  isOpen: true,
                  key: ValueKey(Random()),
                  axis: Axis.vertical,
                  // isScale: true,
                  // value: 1,
                  time: 1000,
                  delayed: 550,
                  curve: ElasticOutCurve(1),
                  child: MyText(
                    '内当家',
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                TweenWidget(
                  isOpen: true,
                  key: ValueKey(Random()),
                  axis: Axis.vertical,
                  // isScale: true,
                  // value: 1,
                  time: 1000,
                  delayed: 600,
                  curve: ElasticOutCurve(1),
                  child: MyText(
                    '现金补贴最高',
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  List<Widget> pages = [];

  @override
  void initState() {
    this.initJPush();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ///键盘收起自动失焦
      await Future.delayed(Duration(milliseconds: 100));
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //初始化推送
  void initJPush() async {
    bool isLoginin = user != null;
    // if (isLoginin) {
    // MobpushPlugin.updatePrivacyPermissionStatus(true);
    // if (Platform.isIOS) {
    //   MobpushPlugin.setCustomNotification();
    //   MobpushPlugin.setAPNsForProduction(true);
    // }
    // MobpushPlugin.getRegistrationId().then((Map<String, dynamic> ridMap) {
    //   String regId = ridMap['res'].toString();
    //   print('------>#### registrationId: ' + regId);
    // });
    // MobpushPlugin.addPushReceiver(
    //   (v) {
    //     Map<String, dynamic> eventMap = json.decode(v);
    //     Map<String, dynamic> result = eventMap['result'];
    //     int action = eventMap['action'];
    //     flog(result);
    //     switch (action) {
    //       case 1:
    //         showToast('您有一条新消息!');
    //         break;
    //       // case 2:
    //       case 2:
    //         var title = json.decode(result['extrasMap']['pushData'].toString())['title'];
    //         var id = json.decode(result['extrasMap']['pushData'].toString())['Id'];
    //         var type = json.decode(result['extrasMap']['pushData'].toString())['type'];
    //         var url = json.decode(result['extrasMap']['pushData'].toString())['url'];
    //         if (type == '2') {
    //           jumpPage(VideoApp(videoId: url), isMoveBtm: true);
    //         } else {
    //           jumpPage(ZixunInfoPage(data: {'title': title, 'id': id}), isMoveBtm: true);
    //         }
    //         // switch (type) {
    //         //   case "1":
    //         //     jumpPage(ShopOrderDetail(id: id), isMoveBtm: true);
    //         //     break;
    //         //   case "2":
    //         //     jumpPage(ShopOrderDetail(id: id), isMoveBtm: true);
    //         //     break;
    //         //   case "3":
    //         //     jumpPage(ShopOrderDetail(id: id), isMoveBtm: true);
    //         //     break;
    //         // }
    //         break;
    //     }
    //   },
    //   (e) => flog(e.toString(), '失败'),
    // );
    // if (isLoginin) {
    //   MobpushPlugin.setAlias(user.id).then((Map<String, dynamic> aliasMap) {
    //     String res = aliasMap['res'];
    //     String error = aliasMap['error'];
    //     String errorCode = aliasMap['errorCode'];
    //     flog(">>>>>>>>>>>>>>>>>>>>>>>>>>> setAlias -> res: $res error: $error errorCode: $errorCode");
    //   });
    // }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: BnbWidget(callback: (i) {
              // setState(() {});
              app.pageCon.jumpToPage(i);
            }),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: handleGlowNotification,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: app.pageCon,
                children: <Widget>[
                  Stack(
                    children: [
                      if (user != null)
                      HomePage(),
                    ],
                  ),
                  ZixunPage(),
                  ShoppingPage(),
                  // im.HomePage(
                  //   fun: (v){
                  //     showToast(v.toString());
                  //   },
                  // ),
                  // [MyPage(), MyPage2()][getTime() % 2],
                  MyPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserXiayi extends StatefulWidget {
  @override
  _UserXiayiState createState() => _UserXiayiState();
}

class _UserXiayiState extends State<UserXiayi> with TickerProviderStateMixin {
  TextEditingController con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldWidget(
        bgColor: Colors.transparent,
        body: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: TweenWidget(
            axis: Axis.vertical,
            isOpen: true,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText('用户协议和隐私政策', size: 18, isBold: true),
                  Padding(
                    padding: EdgeInsets.all(8),
                    // child: Html(
                    //   data: '''感谢您选择内当家App！<br/>我们非常重视您的个人信息和隐私保护，为了更好地保障您的个人权益，请您务必审慎阅读、充分理解<a href="12">《用户协议》</a>和<a href="11">《隐私政策》</a>各条款，包括但不限于：<br>1.在您使用软件及服务的过程中，向你提供相关基本功能，我们将根据合法、正当、必要的原则，收集或使用必要的个人信息；<br/>2.基于您的授权，我们可能会获取您的地理位置、通讯录、相机等相关软件权限；<br/>3.我们会采取符合标准的技术措施和数据安全措施来保护您的个人信息安全；<br/>4.您可以查询、更正、管理您的个人信息，我们也提供账户注销的渠道；<br/>如您同意以上协议内容，请点击“同意”开始使用我们的产品和服务。''',
                    //
                    //   // defaultTextStyle: TextStyle(color: Colors.black54),
                    //   // linkStyle: TextStyle(color: Theme.of(context).primaryColor),
                    //   // padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    //   style: {
                    //     'a': Style(
                    //       color: Theme.of(context).primaryColor,
                    //     ),
                    //   },
                    //   onLinkTap: (v, _, __, ___) {
                    //     jumpPage(XieyiPage(type: v));
                    //   },
                    // ),
                  ),
                  // Html(
                  //   data: '''感谢您选择内当家App！<br/>我们非常重视您的个人信息和隐私保护，为了更好地保障您的个人权益，请您务必审慎阅读、充分理解<a href="12">《用户协议》</a>和<a href="11">《隐私政策》</a>各条款，包括但不限于：<br>1.在您使用软件及服务的过程中，向你提供相关基本功能，我们将根据合法、正当、必要的原则，收集或使用必要的个人信息；<br/>2.基于您的授权，我们可能会获取您的地理位置、通讯录、相机等相关软件权限；<br/>3.我们会采取符合标准的技术措施和数据安全措施来保护您的个人信息安全；<br/>4.您可以查询、更正、管理您的个人信息，我们也提供账户注销的渠道；<br/>如您同意以上协议内容，请点击“同意”开始使用我们的产品和服务。''',
                  //   defaultTextStyle: TextStyle(color: Colors.black54),
                  //   linkStyle: TextStyle(color: Theme.of(context).primaryColor),
                  //   padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  //   onLinkTap: (v) {
                  //     jumpPage(XieyiPage(type: v));
                  //   },
                  // ),
                  BtnWidget(
                    isShowShadow: false,
                    titles: ['不同意并退出', '同意'],
                    bgColor: Colors.transparent,
                    btnHeight: [10, 12],
                    value: [50, 50],
                    time: [750, 750],
                    delayed: [0, 100],
                    axis: [Axis.vertical, Axis.vertical],
                    curve: [ElasticOutCurve(1), ElasticOutCurve(1)],
                    onTap: [
                      () => exit(0),
                      () {
                        userPro.addFirstTimeOpenAppFlag();
                        close(true);
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

///第一次获取定位的时间
DateTime lastPopTime;

///获取定位
Future getLocation() async {
  // 点击返回键的操作
  if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 3)) {
    lastPopTime = DateTime.now();
    if (await requestPermission()) {
      app.setNullLocation();
      // BmapLocation.instance.listenLocation(mode: LocationAccuracy.High).listen((f) {
      //   if (app.la == null) {
      //     flog(f);
      //     app.la = f.latLng.latitude.toString();
      //     app.lo = f.latLng.longitude.toString();
      //     app.province = f.province.toString();
      //     app.city = f.city.toString();
      //
      //     ///百度定位回调有问题
      //     var list = app.shengshiquDm.object.where((w) => w['name'].toString().contains(f.city)).toList();
      //     app.cityCode = list.isEmpty ? '-1' : list.first['id'];
      //     app.area = f.district.toString();
      //     app.address = f.address.toString();
      //     app.latLng = f.latLng;
      //     app.setLocalLocation();
      //     BmapLocation.instance.stop();
      //   }
      // });
    }
  } else {
    lastPopTime = DateTime.now();
  }
}

///定位权限
Future<bool> requestPermission() async {
  if ((await Permission.location.request()).isGranted) {
    return true;
  } else {
    showToast('请开启定位权限!');
    return false;
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/page/home_page.dart';
import 'package:flutter_app/page/my_page.dart';
import 'package:flutter_app/page/shopping_page.dart';
import 'package:flutter_app/page/zixun_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/widget/bnb_widget.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:provider/provider.dart';
import 'package:weibo_kit/weibo_kit.dart';
import 'widget/tween_widget.dart';
import 'widget/widgets.dart';

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
        title: 'flutter_app',
        navigatorKey: navigatorKey,
        // showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
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
    await app.getDropDownList(false);
    await userPro.getUserInfo();
    await app.apiDataDictGetDropDownList();
    var isFtoApp = await userPro.isFirstTimeOpenApp();
    timer = Timer.periodic(Duration(seconds: 1), (v) async {
      flog(v.tick);
      if (v.tick == 1) {
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
              'assets/img/baozhang.png',
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
                    'assets/img/ic_launcher.png',
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
                    'flutter_app',
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
                    '测试文本',
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
                      HomePage(),
                    ],
                  ),
                  ZixunPage(),
                  ShoppingPage(),
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
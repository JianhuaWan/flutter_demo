import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/widget/flutter_luban.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class YaoqingPage extends StatefulWidget {
  @override
  _YaoqingPageState createState() => _YaoqingPageState();
}

class _YaoqingPageState extends State<YaoqingPage> {
  GlobalKey rootWidgetKey = GlobalKey();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    // var s = await FlutterClipboard.paste();
    // flog(s);
  }

  ///截屏
  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = rootWidgetKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      await Future.delayed(Duration(milliseconds: 500));
      var image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      flog(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.light,
      body: Stack(
        children: [
          RepaintBoundary(
            key: rootWidgetKey,
            child: Container(
              color: Colors.red,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/img/yaoqing_hongbao.png',
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(top: 88),
                      child: Column(
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/img/yaoqing_yuan.png',
                                  height: 104,
                                ),
                                ClipOval(
                                  child: WrapperImage(
                                    width: 70,
                                    urlBuilder: () => user.portrait,
                                    height: 70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: QrImage(
                                data: 'https://app.rayt.cc/user/register.html#/?inviteCode=${user?.inviteCode}',
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Opacity(
                            opacity: 0.0,
                            child: WidgetTap(
                              isElastic: true,
                              onTap: () async {
                                await FlutterClipboard.copy('https://app.rayt.cc/user/register.html#/?inviteCode=${user?.inviteCode}');
                                showToast('复制成功');
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/yaoqing_btn.png',
                                    height: 67,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: MyText(
                                      '复制',
                                      size: 17,
                                      color: Color(0xFFB85822),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/img/yaoqing_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: padd(context).top),
                Center(
                  child: MyText(
                    '邀请新朋友\n注册得好礼',
                    size: 63,
                    isOverflow: false,
                    isBold: true,
                    isXieTi: true,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/img/yaoqing_hongbao.png',
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.only(top: 70),
                          child: Column(
                            children: [
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/img/yaoqing_yuan.png',
                                      height: 87,
                                    ),
                                    ClipOval(
                                      child: WrapperImage(
                                        width: 61,
                                        urlBuilder: () => user.portrait,
                                        height: 61,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: QrImage(
                                    data: 'https://app.rayt.cc/user/register.html#/?inviteCode=${user?.inviteCode}',
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              WidgetTap(
                                isElastic: true,
                                onTap: () async {
                                  await FlutterClipboard.copy('https://app.rayt.cc/user/register.html#/?inviteCode=${user?.inviteCode}');
                                  showToast('复制成功');
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/img/yaoqing_btn.png',
                                      height: 67,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: MyText(
                                        '复制',
                                        size: 17,
                                        color: Color(0xFFB85822),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Row(
                    children: List.generate(4, (i) {
                      return Expanded(
                        child: WidgetTap(
                          isElastic: true,
                          onTap: () async {
                            switch (i) {
                              case 0:
                                buildShowDialog(context);
                                var uint8list = await _capturePng();
                                close();
                                break;
                              case 1:
                                // handleShareToQQ();
                                buildShowDialog(context);
                                var uint8list = await _capturePng();
                                close();
                                break;
                              case 2:
                                buildShowDialog(context);
                                close();
                                break;
                              case 3:
                                if ((await Permission.storage.request()).isGranted) {
                                  buildShowDialog(context);
                                  var uint8list = await _capturePng();
                                  var flag = await ImageGallerySaver
                                      .saveImage(uint8list!, name: '${user?.inviteCode}_${Random().nextInt(9999)}');
                                  flog(flag);
                                  close();
                                  showToast('保存成功');
                                } else {
                                  showToast('保存失败');
                                }
                                break;
                            }
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Image.asset(
                                [
                                  'assets/img/yaoqing_qq.png',
                                  'assets/img/yaoqing_qq.png',
                                  'assets/img/yaoqing_qq.png',
                                  'assets/img/yaoqing_qq.png',
                                ][i],
                                width: 42,
                                height: 42,
                              ),
                              SizedBox(height: 8),
                              MyText(
                                ['item1', 'item2', 'item3', 'save'][i],
                                size: 12,
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          buildTitle(
            context,
            title: '',
            widgetColor: Colors.white,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

// Future<Null> handleShareToQQ() async {
//   ShareQQContent shareContent = new ShareQQContent(
//     title: "测试title",
//     targetUrl: "https://www.baidu.com",
//     summary: "测试summary",
//     imageLocalUrl: "http://inews.gtimg.com/newsapp_bt/0/876781763/1000",
//     // imageUrl: "http://inews.gtimg.com/newsapp_bt/0/876781763/1000",
//   );
//   try {
//     var qqResult = await FlutterQq.shareToQQ(shareContent);
//     var output;
//     if (qqResult.code == 0) {
//       output = "分享成功";
//     } else if (qqResult.code == 1) {
//       output = "分享失败" + qqResult.message;
//     } else {
//       output = "用户取消";
//     }
//     flog(output);
//   } catch (error) {
//     flog("flutter_plugin_qq_example:" + error.toString());
//   }
// }

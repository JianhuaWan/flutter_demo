import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:paixs_utils/config/net/Config.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/media/image.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
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
                    'assets/img/invitation_redpack.png',
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
                                  'assets/img/invitation_circle.png',
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
                                data: Config.BaseUrlDev+'/user/register'
                              '.html#/?inviteCode=${user?.inviteCode}',
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Opacity(
                            opacity: 0.0,
                            child: WidgetTap(
                              isElastic: true,
                              onTap: () async {
                                await FlutterClipboard.copy(Config
                                    .BaseUrlDev +
                                    '/user/register.html#/?inviteCode=${user
                                        ?.inviteCode}');
                                showToast('复制成功');
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/invitation_button.png',
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
              'assets/img/invitation_background.png',
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
                        'assets/img/invitation_redpack.png',
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
                                      'assets/img/invitation_circle.png',
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
                                    data: Config.BaseUrlDev+'/user/register.html#/?inviteCode=${user
                                        ?.inviteCode}',
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              WidgetTap(
                                isElastic: true,
                                onTap: () async {
                                  await FlutterClipboard.copy(
                                      Config.BaseUrlDev+'/user/register.html#/?inviteCode=${user
                                          ?.inviteCode}');
                                  showToast('复制成功');
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/img/invitation_button.png',
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
                                if ((await Permission.storage.request())
                                    .isGranted) {
                                  buildShowDialog(context);
                                  var uint8list = await _capturePng();
                                  var flag = await ImageGallerySaver
                                      .saveImage(uint8list!,
                                      name: '${user?.inviteCode}_${Random()
                                          .nextInt(9999)}');
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
                                  'assets/img/invitation_qq.png',
                                  'assets/img/invitation_qq.png',
                                  'assets/img/invitation_qq.png',
                                  'assets/img/invitation_qq.png',
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

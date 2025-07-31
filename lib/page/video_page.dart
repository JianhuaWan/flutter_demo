import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/widget/flutter_luban.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:weibo_kit/weibo_kit.dart';
import 'package:http/http.dart' as request;

class VideoApp extends StatefulWidget {
  final String videoId;
  final String id;
  final String tag;
  final bool isPlay;
  final Map data;

  const VideoApp({
    Key key,
    this.videoId,
    this.id,
    this.tag = '',
    this.isPlay = false,
    this.data,
  }) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> with AutomaticKeepAliveClientMixin {

  bool flag = true;
  bool videoIsShowflag = false;
  bool likeFlag = false;
  var data = {}; //详情
  bool dzFlag = true; //点赞标示

  Duration _currentPos;

  @override
  void initState() {
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
      // SystemChrome.setEnabledSystemUIOverlays([]);
      this.vedeoListener();
      this.videoInit();
    } else {
      lunTelURL(widget.videoId);
      close();
    }
    super.initState();
  }

  ///初始化视频配置
  Future<void> videoInit() async {
    flog(widget.data);
    await Future.delayed(Duration(milliseconds: 250));
    // if (widget.isPlay) {
    //   Future.delayed(Duration(milliseconds: 100), () {
    //     player.start();
    //     setState(() => flag = false);
    //   });
    // }
  }

  ///视频监听器
  void vedeoListener() {
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Platform.isIOS ? SizedBox() : ScaffoldWidget(brightness: Brightness.light, body: buildItem());
  }

  ///主体
  Widget buildItem() {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: () => startVideo(),
            )
            // : Container(
            //     alignment: Alignment.center,
            //     color: Color(0xFF141414),
            //     child: WrapperImage(
            //       url: '${widget.videoId}?x-oss-process=video/snapshot,t_500,m_fast,w_500',
            //       color: Colors.white,
            //     ),
            //   ),
            ),
        AnimatedSwitcher(
          child: flag ? buildPlayBg() : SizedBox(),
          duration: Duration(milliseconds: 200),
        ),
        AnimatedSwitcher(
          child: flag ? buildPlayBtn() : SizedBox(),
          duration: Duration(milliseconds: 500),
          reverseDuration: Duration(milliseconds: 250),
          switchInCurve: ElasticOutCurve(1),
          switchOutCurve: Curves.easeOutBack,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
        ),
        // if (!widget.isLook)
        //   AnimatedSwitcher(
        //     duration: Duration(milliseconds: 250),
        //     child: data.isNotEmpty ? buildBtns() : SizedBox(),
        //   ),

        if (widget.data != null)
          Positioned(
            right: 24,
            top: padd(context).top + 24,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Container(
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Row(
                            children: List.generate(3, (i) {
                              return Expanded(
                                child: WidgetTap(
                                  isElastic: true,
                                  onTap: () async {
                                    close();
                                    switch (i) {
                                      case 0:
                                        break;
                                      case 1:
                                        break;
                                      case 2:
                                        buildShowDialog(context);
                                        var res = await request.get(Uri.parse(widget.data['preview'].toString().split(';').first));
                                        var imageJpg = Luban.comressImageJpg(res.bodyBytes, 1);
                                        close();
                                        await Weibo.instance.shareImage(
                                          imageData: imageJpg,
                                          text: "#\t内当家\t#\t${widget.data['title']}\t${widget.videoId}\n来自\t@内当家",
                                          imageUri: Uri.dataFromBytes(imageJpg),
                                        );
                                        break;
                                    }
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 16),
                                      Image.asset(
                                        [
                                          'assets/img/yaoqing_wx.png',
                                          'assets/img/yapqing_pyq.png',
                                          // 'assets/img/yaoqing_qq.png',
                                          'assets/img/yaoqing_wb.png',
                                        ][i],
                                        width: 42,
                                        height: 42,
                                      ),
                                      SizedBox(height: 8),
                                      MyText(
                                        [
                                          '微信',
                                          '朋友圈',
                                          '微博',
                                        ][i],
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
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.share_outlined,
                color: Colors.white,
              ),
            ),
          ),
        Positioned(
          left: 24,
          top: padd(context).top + 24,
          child: IconButton(
            onPressed: () => pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 2,
            // width: _currentPos.inMilliseconds == 0 ? 0 : _currentPos.inMilliseconds / player.value.duration.inMilliseconds * size(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor.withOpacity(0.25), Theme.of(context).primaryColor],
              ),
            ),
          ),
        )
      ],
    );
  }

  ///播放和暂停视频
  void startVideo() {
    if (flag) {
      if (mounted) setState(() => flag = false);
    } else {
      if (mounted) setState(() => flag = true);
    }
  }

  ///按钮集
  Align buildBtns() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () => startVideo(),
            child: Container(
              height: size(context).height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 播放按钮
  GestureDetector buildPlayBtn() {
    return GestureDetector(
      onTap: () {
        if (mounted) setState(() => flag = !flag);
      },
      child: Container(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/svg/play_svg.svg',
          width: 56,
          height: 56,
          color: Colors.white54,
        ),
      ),
    );
  }

  // 暂停播放背景
  GestureDetector buildPlayBg() {
    return GestureDetector(
      onTap: () {
        if (mounted) setState(() => flag = !flag);
      },
      child: Container(
        color: Colors.black26,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

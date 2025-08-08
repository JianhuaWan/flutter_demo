import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class UpappWidget extends StatefulWidget {
  final String content;
  final String url;
  final String banben;
  final String pgkVer;

  const UpappWidget(this.content, this.url, this.banben, this.pgkVer,
      {Key? key})
      : super(key: key);

  @override
  _UpappWidgetState createState() => _UpappWidgetState();
}

class _UpappWidgetState extends State<UpappWidget> {
  String apkName = 'app.apk';
  String appPath = '';
  String updateReason = '';
  late ProgressDialog pd;

  /// 下载最新apk包
  Future<void> _executeDownload(BuildContext context, url) async {
    Dio dio = new Dio();
    pd = ProgressDialog(context: context);
    pd.show(
        max: 100,
        msg: '正在下载...',
        progressBgColor: Colors.transparent,
        cancel: Cancel(cancelClicked: () {
          dio.close();
        }));

    final path = await _apkLocalPath;
    await dio.download(url, path + '/' + apkName,
        onReceiveProgress: (received, total) async {
      if (total != -1) {
        ///当前下载的百分比例
        print((received / total * 100).toStringAsFixed(0) + "%");
        double currentProgress = received / total;
        setState(() {
          pd.update(
            value: (currentProgress * 100).toInt(),
            msg: "正在下载...",
          );
          flog(currentProgress);
        });
        if (currentProgress == "100%") {
          pd.close();
          if (await Permission.storage.request().isGranted) {
            _installApk();
          }
        }
      }
    });
  }

  /// 安装apk
  Future<Null> _installApk() async {
    await OpenFile.open(appPath + '/' + apkName);
  }

  /// 获取apk存储位置
  Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    String path = directory!.path + Platform.pathSeparator + 'Download';
    final savedDir = Directory(path);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
    appPath = path;
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => close(),
        child: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: TweenWidget(
            axis: Axis.vertical,
            isOpen: true,
            curve: ElasticOutCurve(1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Transform.translate(
                            offset: Offset(0, -2),
                            child: Image.asset(
                              'assets/img/upgrade_app.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 61,
                            top: 54,
                            right: 110,
                            child: MyText(
                              '${widget.banben}系统升级',
                              size: 26,
                              isBold: true,
                              isOverflow: false,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              widget.content,
                              size: 16,
                            ),
                            Divider(
                              height: 16,
                              color: Colors.transparent,
                            ),
                            WidgetTap(
                              isElastic: true,
                              onTap: () {
                                _executeDownload(context, widget.url);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1684FF),
                                      Color(0xFF3FA9FF)
                                    ],
                                    stops: [0, 1],
                                    begin: Alignment(-0.64, 1),
                                    end: Alignment(0.64, -1),
                                  ),
                                  borderRadius: BorderRadius.circular(56),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Align(
                                  alignment: Alignment(0, 0),
                                  child: MyText(
                                    '立即更新',
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            WidgetTap(
                              onTap: () => close(),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: MyText('取消', size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

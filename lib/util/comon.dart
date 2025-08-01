import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/widget/upapp_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/route.dart';

import 'http.dart';

class ComonUtil {
  static isLogin(Function fun) {
    if (user != null) {
      fun();
    } else {
      showToast('请登录后再操作');
      jumpPage(
        PassWordLogin(),
        isMoveBtm: true,
      );
    }
  }

  ///检测app更新
  static Future<void> checkUpdateApp([bool isToast = false]) async {
    var packageInfo = await PackageInfo.fromPlatform();
    app.packageInfo = packageInfo;
    if (Platform.isIOS) return;
    await Request.get('/api/File/Upgrade',
        isLoading: isToast, data: {"type": "2"}, success: (v) {
      v = v['data'];
      if (int.parse(v['uNumber']) > int.parse(packageInfo.buildNumber)) {
        showGeneralDialog(
          context: context!,
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) {
            return UpappWidget(
              v['remark'],
              v['fileUrl'],
              v['version'],
              packageInfo.version,
            );
          },
        );
      } else {
        if (isToast) showToast('已是最新版');
      }
    });
  }
}

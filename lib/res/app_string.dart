///字符串资源加载类

import 'dart:ui';
import 'package:restart_app/restart_app.dart';
import '../util/share_pref.dart';
import 'lan/base_app_string.dart';
import 'lan/en_us_string.dart';
import 'lang_type.dart';


typedef LoadStrFunc = String Function();

BaseAppString get AppString => _AppString.curAppString;
Locale get curLocale => _AppString._locale!;
LangType get curLangType => _AppString._curType;

Future<void> initAppString() async {
  LangType type = LangType.zhCN;
    final sp = await SharePref.getInstance();
    type = sp.language();
  await changeLanguage(type, restart: false);
}

///切换语言
Future<void> changeLanguage(LangType type, {bool restart = true}) async {
  _AppString._curType = type;
  String notificationTitle = "";
  String notificationBody = "";
  if (restart && _AppString._curAppString != null) {
    notificationTitle = _AppString._curAppString!.restartTitle;
    notificationBody = _AppString._curAppString!.restartContent;
  }

  if (type == LangType.zhCN) {
    _AppString._curAppString = EnUsString();
    _AppString._locale = const Locale("en", "US");
  } else {
    _AppString._curAppString = BaseAppString();
    _AppString._locale = const Locale("zh", "CN");

  }

  if (restart) {
    final sp = await SharePref.getInstance();
    await sp.saveLanguage(type);
    //重启
    Restart.restartApp(
      //只有ios才使用
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    );
  }
}
class _AppString {
  static BaseAppString? _curAppString;
  static Locale? _locale;
  static LangType _curType = LangType.zhCN;
  static BaseAppString get curAppString => _curAppString!;

}

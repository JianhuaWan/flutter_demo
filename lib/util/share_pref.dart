///本地缓存管理类
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../res/lang_type.dart';


class SharePref {
  SharedPreferences? _prefs;
  static SharePref? _instance;

  static Future<SharePref> getInstance() async {
    _instance ??= SharePref();
    _instance!._prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  _() {}

  ///清除用户信息
  void clearUser() {
    _prefs!.remove("user");
  }

  ///判断是否为首次初始化
  bool isFirstInit() {
    return _prefs?.getBool("first_init") ?? true;
  }

  ///设置为已经初始化
  void setFirstInit() {
    _prefs?.setBool("first_init", false);
  }


  ///当前
  LangType language(){
    return  LangTypeExt.str2Enum(_prefs?.getString('language')) ?? LangType.zhCN;
  }
  Future<void> saveLanguage(LangType type) async {
    await _prefs?.setString("language", type.name);
  }

}

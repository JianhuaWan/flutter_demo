import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

///加载动画的统一管理类，避免不断打开新页面，加载动画，提示出现多个的情况
class LoadingManager {

  static LoadingManager? _instance;
  static LoadingManager get instance {
    _instance ??= LoadingManager();
    return _instance!;
  }

  TransitionBuilder init() {
    return EasyLoading.init();
  }
  void showLoading({String? title,  bool? dismissOnTap}) {
    try {
      EasyLoading.show(status: title ?? '加载中...');
    } catch(_){}

  }

  void showError(String title) {
    try {
      EasyLoading.showError(title);
    } catch(_){}
  }

  void showToast(String title) {
    try {
      EasyLoading.showToast(title);
    } catch(_){}
  }
  void dismiss() {
    try {
      EasyLoading.dismiss();
    } catch(_){}
  }
}
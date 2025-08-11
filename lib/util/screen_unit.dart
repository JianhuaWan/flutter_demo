///屏幕尺寸设置类
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as flutter_screen;
import 'package:get/get.dart';

class ScreenUnit {
  static double _paddingTop = 0; ///竖屏情况，顶部安全间隔
  static double _paddingBottom = 0; ///竖屏情况，底部安全间隔

  static flutter_screen.ScreenUtil _screenUtil = flutter_screen.ScreenUtil();

  static double get paddingTop => _paddingTop;
  static double get paddingBottom => _paddingBottom;

  ///获取竖屏情况的上下安全间距
  static void _getPaddingTopAndBottom() {
    if (_screenUtil.orientation == Orientation.portrait) {
      MediaQueryData mqData = MediaQuery.of(Get.context!);
      _paddingTop = mqData.padding.top;
      _paddingBottom = mqData.padding.bottom;
    }
  }
  static void initFullScreenSize(BuildContext context) {
    //先获取竖屏情况的，宽高比例

    if (_screenUtil.orientation == Orientation.landscape) {
      //主要切换到全屏横屏的情况，需要让宽高比跟竖屏一样，需要重新计算宽高
      double screenWidth =  _screenUtil.screenWidth;
      double screenHeight = _screenUtil.screenHeight;
      double width = 393;
      double height = 853;
      double widthRatio = screenHeight / 393;
      double heightRatio = screenWidth / 853;
      width = screenWidth / widthRatio;
      height = screenHeight / heightRatio;
      flutter_screen.ScreenUtil.init(
        context,
        designSize:  Size(width, height),
      );
    }

  }

  ///启动app，需要先进行初始化
  static Widget screenInit(Widget appWidget) {
    Widget child = flutter_screen.ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          _getPaddingTopAndBottom();
          return appWidget;
        });
    return child;
  }

  ///设备的像素密度
  static double? get pixelRatio => _screenUtil.pixelRatio;

  ///设备宽度
  static double get screenWidth => _screenUtil.screenWidth;

  ///设备高度
  static double get screenHeight => _screenUtil.screenHeight;

  ///底部安全区距离，适用于全面屏下面有按键的
  static double get bottomBarHeight => _screenUtil.bottomBarHeight;

  ///状态栏高度 刘海屏会更高
  static double get statusBarHeight => _screenUtil.statusBarHeight;

  ///系统字体缩放比例
  static double get textScaleFactor => _screenUtil.textScaleFactor;
  ///屏幕方向
  static Orientation get orientation => _screenUtil.orientation;

  static double get pageHeight => screenHeight - statusBarHeight - 44;

  static double get topHeight => statusBarHeight + 44;

///24.sp  适配字体
  ///200.r 根据宽度或高度中的较小者进行调整
  ///200.h 根据屏幕高度适配尺寸(一般根据宽度适配即可)
  ///540.w 根据屏幕宽度适配尺寸
  ///12.sm 取12和12.sp中的最小值
  ///0.2.sw 屏幕宽度的0.2倍
  ///0.5.sh 屏幕高度的50%
  ///20.setVerticalSpacing  SizedBox(height: 20 * scaleHeight)
  ///20.horizontalSpace  SizedBox(height: 20 * scaleWidth)

}

extension AppSizeExtension on num {
  double get sp => ScreenUnit._screenUtil.setSp(this);
  double get w => ScreenUnit._screenUtil.setWidth(this);
  double get h => ScreenUnit._screenUtil.setHeight(this);

}

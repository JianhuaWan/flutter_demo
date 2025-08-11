///页面组件基类
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../net/not_network_hint.dart';
import '../util/color_config.dart';
import '../util/loading_manager.dart';
import 'base_page_controller.dart';

export 'package:flutter/material.dart';
export 'package:get/get.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

abstract class BasePage<C extends BasePageController> extends GetView<C> {
  BasePage({super.key}) {
    //监听首帧，然后才进行初始化
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  ///路由动画结束，通知controller更新状态
  void pushFinished() {
      try {
        controller.onRouteFinished();
      } catch(_){}
  }

  void _init() {
    if (controller.checkPageHadInit) {
      return ;
    }
    controller.loadingHint.addListener(() {
      String? loading = controller.loadingHint.value?.hint;
      if (loading == null) {
        LoadingManager.instance.dismiss();
      } else {
        LoadingManager.instance.showLoading(title: loading);
      }
    });
    controller.errHint.addListener(() {
      String? hint = controller.errHint.value?.hint;
      if (hint?.isNotEmpty == true) {
        showToast(hint);
      }
    });
  }

  ///页面关联的controller类
  @override
  C get controller => super.controller;

  ///标题
  String get title => "";

  ///appBar背景颜色
  Color get appBarColor => CommonColor.whiteColor;

  bool get canAddNetworkHint => false;

  ///顶部添加无网提示
  Widget checkAddNetworkHint(Widget child) {
    Widget newChild = child;
    if (canAddNetworkHint) {
      newChild = Stack(
        children: [
          newChild,
          Positioned(top: 0, left: 0, right: 0,
            child: ValueListenableBuilder(
              valueListenable: controller.showNetworkHint,
              builder: (subContext, bool status, Widget? child) {
                  Widget subChild;
                  if (status) {
                    subChild = const NotNetworkHint();
                  } else {
                    subChild = Container();
                  }
                  return subChild;
              },
            ),
          )
        ],
      );
    }
    return newChild;
  }
  @override
  Widget build(BuildContext context) {
    Widget child;
    child = ValueListenableBuilder(valueListenable: controller.routeFinish,
        builder: (subContext, bool status, Widget? child) {
          if (!status) {
            return Container();
          } else {
            return contentBuild(subContext);
          }

        });
    child = checkAddNetworkHint(child);

    // child = addAppBar(child);

    child = addPopScope(child);

    return child;
  }


  ///拦截返回上一页操作
  Widget addPopScope(Widget child) {
    if (limitPop) {
      child = WillPopScope(onWillPop: onWillPop,
          child: child);
    }

    return child;
  }

  bool get limitPop => false;


  Future<bool> onWillPop() {
    return Future.value(!limitPop);
  }


  // Widget addAppBar(Widget child) {
  //   return addAppBarPage(child, title: title, appBarColor: appBarColor,
  //
  //   );
  // }
  ///子类page的view
  Widget contentBuild(BuildContext context) {
    return Container();
  }
}
///页面对应的controller基类
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/hint_model.dart';
import '../net/req_controller.dart';

class BasePageController extends GetxController with ReqController {
  ValueNotifier<HintModel> errHint = ValueNotifier(HintModel(""));
  ValueNotifier<HintModel?> loadingHint = ValueNotifier(null);
  bool _pageHadInit = false;
  ValueNotifier<bool> routeFinish = ValueNotifier(false);
  ///控制无网提示的显示
  ValueNotifier<bool> showNetworkHint = ValueNotifier(false);
  bool get checkPageHadInit {
    if (!_pageHadInit) {
      _pageHadInit = true;
      return false;
    }
    return true;
  }

  ///路由动画结束后的回调
  void onRouteFinished() {
    routeFinish.value = true;
  }
  ///判断路由动画是否结束了
  bool get checkRouteFinished => routeFinish.value;

  void onInitData() {

  }

  @override
  void onClose() {
    errHint.dispose();
    loadingHint.value = null;
    loadingHint.dispose();
    cancelReq();
    super.onClose();
    super.cancel();
  }

}
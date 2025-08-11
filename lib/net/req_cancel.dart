///封装网络请求的cancelToken和页面的Controller
///方便controller销毁时调用cancelToken关闭请求
import 'package:dio/dio.dart';
import 'package:flutter_app/net/req_controller.dart';

typedef ReqCancelCallback = void Function(ReqCancel reqCanel);


abstract class ReqCancelImpl {
  void remove([ReqCancelImpl? impl]);
  void cancel();
}

///管理cancelToken
class ReqCancel extends ReqCancelImpl {
  CancelToken? _cancelToken;
  ReqController? controller;
  CancelToken get cancelToken {
    return _cancelToken ??= CancelToken();
  }

  bool get isNotEmpty => _cancelToken != null;

  void setController(ReqController controller) {
    this.controller = controller;
  }
  @override
  void remove([ReqCancelImpl? impl]) {
    _cancelToken = null;
    controller?.remove(this);
  }

  @override
  void cancel() {
    if (_cancelToken != null && _cancelToken!.isCancelled == false) {
      _cancelToken?.cancel('close');
    }
    remove();
  }

}
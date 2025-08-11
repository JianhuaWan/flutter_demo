import 'package:flutter_app/net/req_cancel.dart';

///对cancelToken进行管理
///主要是页面controller集成该类，页面controller销毁时，关闭当前页面的所有请求

class ReqController implements ReqCancelImpl {
  final List<ReqCancel> _cancelList = <ReqCancel>[];

  void add(ReqCancel item) {
    item.setController(this);
    _cancelList.add(item);

  }
  @override
  void cancel() {
    while (_cancelList.isNotEmpty) {
      final item = _cancelList.removeAt(0);
      item.cancel();
    }
  }

  @override
  void remove([ReqCancelImpl? impl]) {
    if (impl != null) {
      _cancelList.remove(impl);
    }
  }


  void cancelReq() {
    cancel();
  }

}
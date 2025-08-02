import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

export 'package:dio/dio.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class BaseHttp extends DioMixin {
  BaseHttp() {
    options = BaseOptions();
    /// 初始化 加入app通用处理
    transformer=CustomTransformer();
    interceptors..add(HeaderInterceptor());
    init();
  }
  void init();
}
class CustomTransformer extends BackgroundTransformer {
  @override
  Future<String> transformRequest(RequestOptions options) {
    return super.transformRequest(options);
  }

  @override
  Future<dynamic> transformResponse(
      RequestOptions options,
      ResponseBody response,
      ) async {
    // 使用自定义的解析方法
    final String data = await super.transformResponse(options, response) as String;
    if (data.isNotEmpty) {
      try {
        return parseJson(data);
      } catch (e) {
        return data;
      }
    }
    return data;
  }
}
/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.connectTimeout = Duration(milliseconds:1000 * 5);
    options.receiveTimeout = Duration(milliseconds:1000 * 5);
    if(options.data is! FormData){
      options.headers['Content-Type'] = 'application/json';
      // options.headers['Content-Type'] = 'multipart/form-data';
    }    
    handler.next(options);
  }
}

/// 子类需要重写
abstract class BaseResponseData {
  String? code = '0';
  String? message;
  dynamic data;

  bool get success;

  BaseResponseData({this.code, this.message, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $message, data: $data}';
  }
}

/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  String? message;

  NotSuccessException.fromRespData(BaseResponseData respData) {
    message = respData.message!;
  }

  @override
  String toString() {
    return message!;
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}

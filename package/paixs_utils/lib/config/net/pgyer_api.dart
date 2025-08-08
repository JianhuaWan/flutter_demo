import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:paixs_utils/util/utils.dart';
import 'dart:convert' as convert;
import 'Config.dart';
import 'api.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = Config.BaseUrlDev;
    interceptors.add(PgyerApiInterceptor());
  }
}

/// App相关 API
class PgyerApiInterceptor extends InterceptorsWrapper {
  @override
  void  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      log('${options.method}', name: 'Method');
      log('${options.baseUrl}${options.path}', name: 'Url');
      log('${getNull(options.headers['Authorization'])}', name: 'Token');
      if (options.method == 'GET') {
        log(convert.json.encode(options.queryParameters), name: '发送数据');
      } else {
        log(convert.json.encode(options.data), name: '发送数据');
      }
    } catch (e) {
      log(e.toString());
    }

    ///延时请求250毫秒
    handler.next(options);
  }

  getNull(v) => v == '' ? null : v;

}

class ResponseData extends BaseResponseData {
  final RequestOptions options;
  bool get success => code == 'success';

  ResponseData.fromJson(Map<String, dynamic> json, this.options) {
    if (json != null) {
      code = json['resultCode'];
      message = json['resultMsg'];
      data = json['result'];
      if (data is Map) {
        formatDouble(data);
      } else if (data is List) {
        (data as List).forEach((f) => formatDouble(f));
      }
    }
    try {
      var str = options.path.split('/').last;
      log(convert.json.encode(json), name: '接口：${str.substring(0, str.indexOf('?'))}/请求响应');
      try {
        log(convert.json.encode(json['result']['data'][0]), name: '接口：${str.substring(0, str.indexOf('?'))}/序列1的对象');
      } catch (e) {
        // log('暂无序列1', name: '接口：${str.substring(0, str.indexOf('?'))}/序列1的对象');
      } finally {
        log('\n\n', name: '换行');
      }
    } catch (e) {
      var str = options.path.split('/').last;
      log(convert.json.encode(json), name: '接口：$str/请求响应');
      try {
        log(convert.json.encode(json['result']['data'][0]), name: '接口：$str/序列1的对象');
      } catch (e) {
        // log('暂无序列1', name: '接口：$str/序列1的对象');
      } finally {
        log('\n\n', name: '换行');
      }
    }
  }
}

formatDouble(Map data) {
  data.keys.forEach((f) => {if (data[f] is double) data[f] = double.parse((data[f] as double).toStringAsFixed(2))});
}

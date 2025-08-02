import 'dart:convert';

import 'package:flutter_app/provider/provider_config.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/config/net/pgyer_api.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/views.dart';

/// await Request.post('url',
///  data: {},
///  success:(data){},
///  fail:(data){},
///  catchError:(e){}
/// );

class Request {
  static Future<void> post(
      String url, {
        dynamic data,
        bool isToken = true,
        bool isLoading = false,
        Function(dynamic)? success,
        Function(dynamic)? fail,
        Function(dynamic)? catchError,
        String? dialogText,
        Options? option,
      }) async {
    if (isLoading) buildShowDialog(context, text: dialogText);
    var options = Options(headers: {
      'Authorization': isToken ? getUserToken : '',
    });

    try {
      var res = await http.post(url, data: data, options: option ?? options);
      if (isLoading) close();

      if (res != null) {
        if (res.statusCode == 200) {
          if (res.data['tag'] == 1) {
            flog(json.encode(res.data), '成功');
            if (success != null) success(res.data);
          } else {
            flog(res.data, '失败');
            if (catchError != null) catchError(res.data['message'] ?? res.data['Message']);
          }
        } else {
          flog(res.data, '失败');
          if (catchError != null) catchError(res.statusMessage);
        }
      }
    } on DioException catch (e) {
      if (isLoading) close();
      await _handleDioError(e, url, data, success, catchError, fail, options);
    } catch (e) {
      if (isLoading) close();
      if (catchError != null) catchError(e.toString());
    }

    await Future.delayed(Duration(milliseconds: 500));
  }

  static Future<void> _handleDioError(
      DioException e,
      String url,
      dynamic data,
      Function(dynamic)? success,
      Function(dynamic)? catchError,
      Function(dynamic)? fail,
      Options options,
      ) async {
    await error(e, (v, type, code) async {
      flog(v, '异常');
      switch (type) {
        case 1:
          if (code == 401) {
            await userPro.refreshToken();
            await post(
              url,
              data: data,
              catchError: catchError,
              success: success,
              fail: fail,
              option: options,
            );
          } else {
            if (catchError != null) catchError(v);
          }
          break;
        default:
          if (catchError != null) catchError(v);
          break;
      }
    });
  }

  static Future<void> delete(
      String url, {
        dynamic data,
        bool isToken = true,
        bool isLoading = false,
        Function(dynamic)? success,
        Function(dynamic)? fail,
        Function(dynamic)? catchError,
        String? dialogText,
      }) async {
    if (isLoading) buildShowDialog(context, text: dialogText);

    try {
      var res = await http.delete(url, data: data);
      if (isLoading) close();

      if (res != null) {
        if (res.statusCode == 204) {
          if (success != null) success(res.data);
        } else {
          if (fail != null) fail(res.statusMessage);
        }
      }
    } catch (e) {
      if (isLoading) close();
      if (catchError != null) {
        catchError(e);
      } else {
        flog(e, '异常');
        flog(e);
      }
    }
  }

  static Future<void> put(
      String url, {
        dynamic data,
        bool isToken = true,
        bool isLoading = false,
        Function(dynamic)? success,
        Function(dynamic)? fail,
        Function(dynamic)? catchError,
        String? dialogText,
      }) async {
    if (isLoading) buildShowDialog(context, text: dialogText);
    var options = Options(headers: {'Authorization': isToken ? getUserToken : ''});

    try {
      var res = await http.put(url, data: data, options: options);
      if (isLoading) close();

      if (res != null) {
        if (res.statusCode == 200) {
          if (res.data['tag'] == 1) {
            flog(json.encode(res.data), '成功');
            if (success != null) success(res.data);
          } else {
            flog(res.data, '失败');
            if (fail != null) fail(res.data['message']);
          }
        } else {
          flog(res.data, '失败');
          if (fail != null) fail(res.statusMessage);
        }
      }
    } on DioException catch (e) {
      if (isLoading) close();
      await _handleDioError(e, url, data, success, catchError, fail, options);
    } catch (e) {
      if (isLoading) close();
      if (catchError != null) catchError(e.toString());
    }
  }

  static Future<void> patch(
      String url, {
        dynamic data,
        bool isToken = true,
        bool isLoading = false,
        Function(dynamic)? success,
        Function(dynamic)? fail,
        Function(dynamic)? catchError,
        String? dialogText,
      }) async {
    if (isLoading) buildShowDialog(context, text: dialogText);

    try {
      var res = await http.patch(url, data: data);
      if (isLoading) close();

      if (res != null) {
        if (res.statusCode == 200) {
          if (success != null) success(res.data);
        } else {
          if (fail != null) fail(res.statusMessage);
        }
      }
    } catch (e) {
      if (isLoading) close();
      if (catchError != null) {
        catchError(e);
      } else {
        flog(e, '异常');
        flog(e);
      }
    }
  }

  static Future<void> get(
      String url, {
        dynamic data,
        bool isToken = true,
        bool isLoading = false,
        Function(dynamic)? success,
        Function(dynamic)? fail,
        Function(dynamic)? catchError,
        String? dialogText,
      }) async {
    Map<String, dynamic>? map;
    if (isLoading) buildShowDialog(context, text: dialogText);

    if (data != null) {
      map = Map.from(data);
      if (map.keys.toList().contains('City') || map.keys.toList().contains('city')) {
        if (map['city'] == 'null') map['city'] = '';
        if (map['City'] == 'null') map['City'] = '';
      } else {
        map['city'] = app.cityCode;
      }
    }

    var options = Options(headers: {'Authorization': isToken ? getUserToken : ''});

    try {
      var res = await http.get(url, queryParameters: data != null ? map : data, options: options);
      if (isLoading) close();

      if (res != null) {
        if (res.statusCode == 200) {
          if (res.data['tag'] == 1) {
            flog(json.encode(res.data), '成功');
            if (success != null) success(res.data);
          } else {
            flog(res.data, '失败');
            if (catchError != null) catchError(res.data['message'] ?? res.data['Message']);
          }
        } else {
          flog(res.data, '失败');
          if (catchError != null) catchError(res.statusMessage);
        }
      }
    } on DioException catch (e) {
      if (isLoading) close();
      await _handleDioError(e, url, data, success, catchError, fail, options);
    } catch (e) {
      if (isLoading) close();
      if (catchError != null) catchError(e.toString());
    }

    await Future.delayed(Duration(milliseconds: 250));
  }

  ///返回用户token
  static String get getUserToken {
    if (user.id == null) return '';
    return user.token!;
  }
}

class Http {
  static Future<int?> requestList(
      String url, {
        DataModel? dataModel,
        dynamic data,
        bool? isLoading,
        String? dialogText,
        bool isRef = false,
        Function(dynamic)? listFun,
        Function(dynamic)? totalFun,
        Function()? then,
      }) async {
    try {
      await Request.post(
        url,
        data: data,
        catchError: (v) => dataModel?.toError(v),
        isLoading: isLoading ?? false,
        dialogText: dialogText,
        success: (v) => dataModel?.addList(
          listFun != null ? listFun(v) : v['data']['list'],
          isRef,
          totalFun != null ? totalFun(v) : v['data']['totalSize'],
        ),
      );
      if (then != null) then();
      return dataModel?.flag;
    } catch (e) {
      flog(e, 'requestList error');
      return null;
    }
  }
}

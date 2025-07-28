import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:system_info/system_info.dart';
import '../config/net/pgyer_api.dart';
import '../widget/custom_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';

///上传file
Future<String> uploadFile(PickedFile file) async {
  List<int> byteData = await file.readAsBytes();
  List paths = file.path.split("/");
  MultipartFile multipartFile = MultipartFile.fromBytes(
    byteData,
    filename: paths[paths.length - 1],
  );
  FormData formData = FormData.fromMap({"file": multipartFile});
  var response = await http.post<String>('/app/common/addImage', data: formData);
  return response.data;
}

///上传asset
// Future uploadAsset(Asset img) async {
//   ByteData byteData = await img.getByteData(quality: 50);
//   List<int> imageData = byteData.buffer.asUint8List();
//   MultipartFile multipartFile = MultipartFile.fromBytes(
//     imageData,
//     filename: img.name,
//     contentType: MediaType("image", "jpeg"),
//   );
//   FormData formData = FormData.fromMap({"file": multipartFile});
//   var response = await http.post<String>('/app/common/addImage', data: formData);
//   return response.data;
// }

///上传un8
Future<String> uploadUn8(Uint8List img) async {
  MultipartFile multipartFile = MultipartFile.fromBytes(
    img,
    filename: img.length.toString(),
    contentType: MediaType("image", "jpeg"),
  );
  FormData formData = FormData.fromMap({"file": multipartFile});
  var response = await http.post<String>('/resources/upload/', data: formData);
  return response.data;
}

///ios风格-路由跳转
///
///isBtm ： 是否从底部弹出，默认右边
///
///page : 跳转的页面
Future push(
  BuildContext context,
  Widget page, {
  bool isMove = true,
  bool isMoveBtm = false,
  bool isNoClose = true,
  bool isSlideBack = true,
  bool isDelay = true,
  int duration = 400,
  bool opaque = false,
}) async {
  if (isNoClose) {
    return Navigator.push(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
    );
  } else {
    return Navigator.pushAndRemoveUntil(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
      (v) => v == null,
    );
  }
}

Future toPage(
  Widget page, {
  bool isMove = true,
  bool isMoveBtm = false,
  bool isNoClose = true,
  bool isSlideBack = true,
  bool isDelay = true,
  int duration = 400,
  bool opaque = false,
}) async {
  if (isNoClose) {
    return Navigator.push(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
    );
  } else {
    return Navigator.pushAndRemoveUntil(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
      (v) => v == null,
    );
  }
}

/// 调起拨号页
void launchTelURL(phone) async {
  String url = 'tel:' + phone;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showToast('拨号失败！', position: StyledToastPosition.center);
  }
}

///退出当前路由栈
pop(BuildContext context, [map]) async {
  return Navigator.pop(context, map);
}

///退出当前路由栈
close([map]) async {
  return Navigator.pop(context, map);
}

///异常处理
error(e, Function(dynamic, int, int) callback) {
  var error = e as DioError;
  switch (error.type) {
    case DioErrorType.response:
      try {
        if (error.response.data['msg'] == null) {
          callback('服务器连接失败', 1, error.response.statusCode);
        } else {
          callback(error.response.data['msg'], 1, error.response.statusCode);
        }
      } catch (e) {
        callback('服务器连接失败', 1, error.response.statusCode);
      }
      break;
    case DioErrorType.other:
      var str = error.message.contains('SocketException');
      callback(str ? '网络连接失败' : '请求错误', 2, 200);
      break;
    case DioErrorType.connectTimeout:
      callback('连接超时', 3, 200);
      break;
    case DioErrorType.sendTimeout:
      callback('发送超时', 4, 200);
      break;
    case DioErrorType.receiveTimeout:
      callback('接收超时', 5, 200);
      break;
    case DioErrorType.cancel:
      callback('连接被取消', 6, 200);
      break;
  }
}

///选择相册
// Future<List<Asset>> pickImages({maxImages = 9}) async {
//   var list = await MultiImagePicker.pickImages(
//     // 选择图片的最大数量
//     maxImages: maxImages,
//     // 是否支持拍照
//     enableCamera: true,
//     materialOptions: MaterialOptions(
//       // 显示所有照片，值为 false 时显示相册
//       startInAllView: true,
//       allViewTitle: '最近照片',
//       useDetailsView: true,
//       textOnNothingSelected: '没有选择照片',
//       selectionLimitReachedText: '最多只能选择$maxImages张',
//     ),
//   );
//   return list;
// }

/// 调起拨号页
void phoneTelURL(String phone) async {
  String url = 'tel: ' + phone;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showToast('拨号失败！');
  }
}

/// 调起系统
void lunTelURL(String type) async {
  if (await canLaunch(type)) {
    await launch(type);
  } else {
    showToast('失败！');
  }
}

///去除滑动水波纹
bool handleGlowNotification(OverscrollIndicatorNotification notification) {
  if ((notification.leading && true) || (!notification.leading && true)) {
    notification.disallowGlow();
    return true;
  }
  return false;
}

// md5 加密
String generateMd5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

List getTextCon(int count) {
  List textconlist = [];

  for (int a = 0; a < count; a++) {
    var textcon = TextEditingController();
    textconlist.add(textcon);
  }

  return textconlist;
}

String checkTextTrim(var text) {
  if (text != null || text != "" || text.toString() != "null") {
    return text;
  }

  return "";
}

///时间转换
String chatTime(DateTime old) {
  if (old == null) return '-';
  var minute = 1000 * 60; //把分，时，天，周，半个月，一个月用毫秒表示
  var hour = minute * 60;
  var day = hour * 24;
  // var week = day * 7;
  // var month = day * 30;
  var now = DateTime.now().millisecondsSinceEpoch; //获取当前时间毫秒
  var diffValue = now - old.millisecondsSinceEpoch; //时间差
  if (diffValue < 0) return "刚刚";
  var result = '';
  var minC = diffValue ~/ minute; //计算时间差的分，时，天，周，月
  var hourC = diffValue ~/ hour;
  var dayC = diffValue ~/ day;
  // var weekC = diffValue ~/ week;
  // var monthC = diffValue ~/ month;
  // if (monthC >= 1 && monthC <= 3) {
  //   result = "${monthC.toInt()}月前";
  // } else if (weekC >= 1 && weekC <= 4) {
  //   result = "${weekC.toInt()}周前";
  // } else
  if (dayC >= 1 && dayC <= 6) {
    result = "${dayC.toInt()}天前";
  } else if (hourC >= 1 && hourC <= 23) {
    result = "${hourC.toInt()}小时前";
  } else if (minC >= 1 && minC <= 59) {
    result = "${minC.toInt()}分钟前";
  } else if (diffValue >= 0 && diffValue <= minute) {
    result = "刚刚";
  } else {
    var y = old.year.toString().padLeft(4, '0');
    var m = old.month.toString().padLeft(2, '0');
    var d = old.day.toString().padLeft(2, '0');

    var s = old.hour.toString().padLeft(2, '0');
    var f = old.minute.toString().padLeft(2, '0');

    result = '$y-$m-$d\t$s:$f';
  }
  return result;
}

///时间转换第二版
String toTime(date, [bool isParse = true]) {
  DateTime old;
  if (isParse)
    old = DateTime.parse(date);
  else
    old = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (old == null) return '-';
  var minute = 1000 * 60; //把分，时，天，周，半个月，一个月用毫秒表示
  var hour = minute * 60;
  var day = hour * 24;
  var week = day * 7;
  var month = day * 30;
  var now = DateTime.now().millisecondsSinceEpoch; //获取当前时间毫秒
  var diffValue = now - old.millisecondsSinceEpoch; //时间差
  if (diffValue < 0) return "刚刚";
  var result = '';
  var minC = diffValue ~/ minute; //计算时间差的分，时，天，周，月
  var hourC = diffValue ~/ hour;
  var dayC = diffValue ~/ day;
  var weekC = diffValue ~/ week;
  var monthC = diffValue ~/ month;
  if (monthC >= 1 && monthC <= 3) {
    result = "${monthC.toInt()}月前";
  } else if (weekC >= 1 && weekC <= 4) {
    result = "${weekC.toInt()}周前";
  } else if (dayC >= 1 && dayC <= 6) {
    result = "${dayC.toInt()}天前";
  } else if (hourC >= 1 && hourC <= 23) {
    result = "${hourC.toInt()}小时前";
  } else if (minC >= 1 && minC <= 59) {
    result = "${minC.toInt()}分钟前";
  } else if (diffValue >= 0 && diffValue <= minute) {
    result = "刚刚";
  } else {
    var y = old.year.toString().padLeft(4, '0');
    var m = old.month.toString().padLeft(2, '0');
    var d = old.day.toString().padLeft(2, '0');

    var s = old.hour.toString().padLeft(2, '0');
    var f = old.minute.toString().padLeft(2, '0');

    result = '$y-$m-$d\t$s:$f';
  }
  return result;
}

///获取当前时间戳
int getTime() => DateTime.now().millisecondsSinceEpoch;

///时间戳转中文
String toDate(milliseconds) {
  if (milliseconds == 0 || milliseconds == null) {
    return '';
  } else {
    return [
      DateTime.fromMillisecondsSinceEpoch(milliseconds).year,
      DateTime.fromMillisecondsSinceEpoch(milliseconds).month,
      DateTime.fromMillisecondsSinceEpoch(milliseconds).day,
    ].join('-');
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

final context = navigatorKey.currentState.overlay.context;

int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
  if (ignoreTime) {
    int v = a.millisecondsSinceEpoch ~/ 86400000 - b.millisecondsSinceEpoch ~/ 86400000;
    if (v < 0) return -v;
    return v;
  } else {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ 86400000;
  }
}

int toDay(DateTime a, int millisecondsSinceEpoch) {
  return double.parse(
    ((millisecondsSinceEpoch - a.millisecondsSinceEpoch) / 86400000).toString(),
  ).toInt();
}

void flog(v, [String name]) => log(v.toString(), name: name ?? 'flog');

bool isCanRunAnimation = false;

///是否可以运行动画
Future<void> setIsCanRunAnimation() async {
  ///手机内存大于4gb以上的设备均可体验动画
  try {
    isCanRunAnimation = (SysInfo.getVirtualMemorySize() / 1024 / 1024 / 1024) >= 4.0;
  } catch (e) {
    isCanRunAnimation = false;
  }
}

///非空判断
isNull(v, [dynamic value, String nullStr = '暂无', bool isUserModel = false]) {
  if (isUserModel) {
    try {
      return v == null ? nullStr : v[value];
    } catch (e) {
      return v == null ? nullStr : v.toJson()[value];
    }
  } else {
    return v == null ? nullStr : v[value];
  }
}

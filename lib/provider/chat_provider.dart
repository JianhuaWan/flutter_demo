import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';

class ChatProvider extends ChangeNotifier {
  int isInit = 0;

  ///未读消息总数
  int totalUnreadCount = 0;
  void changeTotalUnreadCount(v) {
    totalUnreadCount = v;
    notifyListeners();
  }

  ///获取聊天列表头像和昵称
  var chatListDm = DataModel<Map>(object: {});
  Future<void> changeChatListInfo(String id) async {
    isInit = getTime();
    var randou = Random().nextInt(9999);
    var time = getTime();
    var signature = sha1.convert(utf8.encode('eTqmT9BvLl9sN2$randou$time'));
    var res = await Dio()
        .post(
          'https://api-cn.ronghub.com/user/info.json',
          data: "userId=$id",
          options: Options(
            contentType: "application/x-www-form-urlencoded",
            headers: {
              "RC-App-Key": "m7ua80gbmzhjm",
              "RC-Nonce": randou,
              "RC-Timestamp": time,
              "RC-Signature": signature,
            },
          ),
        )
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((v) => chatListDm.toError('异常'));
    if (res == null) {
      chatListDm.toError('错误');
    } else {
      chatListDm.object["$id"] = {
        "userName": res.data['userName'],
        "userPortrait": res.data['userPortrait'],
      };
      chatListDm.setTime();
    }
    notifyListeners();
  }

  ///修改聊天用户的头像和昵称
  Future<bool> changeChatUserInfo(String id, String name, String icon) async {
    bool flag = false;
    var randou = Random().nextInt(9999);
    var time = getTime();
    var signature = sha1.convert(utf8.encode('eTqmT9BvLl9sN2$randou$time'));
    var res = await Dio()
        .post(
          'https://api-cn.ronghub.com/user/refresh.json',
          data: "userId=$id&name=$name&portraitUri=$icon",
          options: Options(
            contentType: "application/x-www-form-urlencoded",
            headers: {
              "RC-App-Key": "m7ua80gbmzhjm",
              "RC-Nonce": randou,
              "RC-Timestamp": time,
              "RC-Signature": signature,
            },
          ),
        )
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((v) => flag = false);
    if (res == null) {
      flag = false;
    } else {
      flag = true;
    }
    return flag;
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rong/user_data.dart';
import 'package:paixs_utils/util/utils.dart';
import '../im/util/db_manager.dart';
import '../im/util/user_info_datesource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../im/util/event_bus.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  final Function(bool) fun;
  final Function(bool) onFinished;
  final Function(int) onUnreadCount;
  final dynamic Function(Map) msgClick;

  const HomePage({Key key, this.fun, this.onFinished, this.msgClick, this.onUnreadCount}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String pageName = "example.HomePage";
  @override
  void initState() {
    super.initState();
    _initUserInfoCache();
    initPlatformState();
  }

  initPlatformState() async {
    //1.初始化 im SDK

    //2.连接 im SDK
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var info = prefs.get("user");
    flog(info);
    if (info != null && info.toString().length > 0) {
      if (jsonDecode(info)['chatToken'] == '') {
        if (widget.fun != null) widget.fun(false);
      }
    } else {
      if (widget.fun != null) widget.fun(false);
      // Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new LoginPage()), (route) => route == null);
    }
  }

  // 初始化用户信息缓存
  void _initUserInfoCache() {
    DbManager.instance.openDb();
    UserInfoCacheListener cacheListener = UserInfoCacheListener();
    cacheListener.getUserInfo = (String userId) {
      return UserInfoDataSource.generateUserInfo(userId);
    };
    cacheListener.getGroupInfo = (String groupId) {
      return UserInfoDataSource.generateGroupInfo(groupId);
    };
    UserInfoDataSource.setCacheListener(cacheListener);
  }

  @override
  Widget build(BuildContext context) {
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/util/base_http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  ///用户信息(全局)
  UserModel userModel= new UserModel();

  ///保存用户信息到内存
  void setUserModel(data, [String? token]) {
    userModel = UserModel.fromJson(data, token!);
    this.saveUserInfo(userModel!);
    notifyListeners();
  }

  ///本地保存用户信息
  Future<void> saveUserInfo(UserModel _user) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setString('user', jsonEncode(_user));
  }

  ///获取本地保存用户信息
  Future<bool> getUserInfo() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.getString('user');
    if (info == null) {
      return false;
    } else {
      userModel = UserModel.fromJson(jsonDecode(info));
      notifyListeners();
      return true;
    }
  }

  ///刷新token并更新用户信息
  Future<void> refreshToken() async {
    await Request.post(
      '/api/User/RefreshToken',
      isToken: false,
      data: {"token": userModel?.token?.trim()},
      catchError: (v) {},
      success: (v) => setUserModel(v['data']),
    );
  }

  ///是否第一次进入app
  Future<bool> isFirstTimeOpenApp() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.getString('isFirstTimeOpenApp');
    if (info == null) {
      return true;
    } else {
      return false;
    }
  }

  ///第一次进入app创建值
  Future<bool> addFirstTimeOpenAppFlag() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.setString('isFirstTimeOpenApp', 'true');
    return info;
  }

  ///清除用户信息
  Future<bool> cleanUserInfo() async {
    var sp = await SharedPreferences.getInstance();
    await sp.remove('user');
    userModel=new UserModel();
    notifyListeners();
    return true;
  }

  ///获取我的客户统计
  var myKehuTongjiDm = DataModel<Map>(hasNext: false, object: {});
  Future<int> apiCustomerStatistics({int page = 1, bool isRef = false}) async {
    if (userModel.id != null) {
      myKehuTongjiDm.object = {};
      await Request.get(
        '/api/Customer/Statistics',
        catchError: (v) => myKehuTongjiDm.toError(v),
        success: (v) {
          if (v['data'] != null) {
            myKehuTongjiDm.object = v['data'];
            myKehuTongjiDm.setTime();
            notifyListeners();
          } else {
            myKehuTongjiDm.flag = 1;
            notifyListeners();
          }
        },
      );
    }
    return myKehuTongjiDm.flag!;
  }

  ///获取我的权益统计
  var myQuanyiTongjiDm = DataModel<Map>(hasNext: false, object: {});
  Future<int> apiUserRightsStatistics({int page = 1, bool isRef = false}) async {
    if (userModel.id != null) {
      myQuanyiTongjiDm.object = {};
      await Request.get(
        '/api/UserRights/Statistics',
        catchError: (v) {
          myQuanyiTongjiDm.toError(v);
          notifyListeners();
        },
        success: (v) {
          myQuanyiTongjiDm.object = v['data'];
          myQuanyiTongjiDm.setTime();
          notifyListeners();
        },
      );
    }
    return myQuanyiTongjiDm.flag!;
  }


  ///是否第一次进入app
  Future<bool> isFirstTimeShareApp() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.getString('isFirstTimeShareApp');
    if (info == null) {
      return true;
    } else {
      return false;
    }
  }

  ///第一次进入app创建值
  Future<bool> addFirstTimeShareAppFlag() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.setString('isFirstTimeShareApp', 'true');
    return info;
  }
}

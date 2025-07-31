import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/util/http.dart';
import 'package:package_info/package_info.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  ///全局位置坐标数据
  String la, lo, address, province, city, area;
  String provinceCode, cityCode, areaCode;

  ///设置位置未空
  void setNullLocation() {
    la = null;
    lo = null;
    province = null;
    city = null;
    area = null;
    address = null;
    notifyListeners();
  }

  void setState() => notifyListeners();

  ///位置信息保存到本地
  Future<void> setLocalLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('la', la ?? '');
    await sp.setString('lo', lo ?? '');
    await sp.setString('province', province ?? '');
    // await sp.setString('province', provinceCode ?? '');
    await sp.setString('city', cityCode ?? '');
    await sp.setString('area', areaCode ?? '');
    await sp.setString('provinceCode', provinceCode ?? '');
    await sp.setString('cityCode', cityCode ?? '');
    await sp.setString('areaCode', areaCode ?? '');
    await sp.setString('address', address ?? '');
    notifyListeners();
  }

  ///从本地读取位置信息
  Future<void> getLocalLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    la = sp.getString('la') ?? null;
    lo = sp.getString('lo') ?? null;
    province = sp.getString('province') ?? null;
    city = sp.getString('city') ?? null;
    area = sp.getString('area') ?? null;
    provinceCode = sp.getString('provinceCode') ?? null;
    cityCode = sp.getString('cityCode') ?? null;
    areaCode = sp.getString('areaCode') ?? null;
    address = sp.getString('address') ?? null;
    log(la.toString());
    log(lo.toString());
    log(address.toString());
    log(province.toString());
    log(city.toString());
    log(area.toString());
  }

  ///是否显示首页筛选遮罩
  bool isShowHomeMask = false;
  void setIsShowHomeMask(v) {
    isShowHomeMask = v;
    Future(() => notifyListeners());
  }

  ///是否显示房贷计算结果遮罩
  bool isShowFangdaiResultMask = false;
  void setIsShowFangdaiResultMask(v) {
    isShowFangdaiResultMask = v;
    Future(() => notifyListeners());
  }

  ///城市列表index
  var cityListIndex;
  void changeCityListIndex(i) {
    cityListIndex = i;
    notifyListeners();
  }

  ///搜索历史
  List<String> sousuoList = [];
  Future<void> clearSousuoList() async {
    sousuoList.clear();
    var sp = await SharedPreferences.getInstance();
    await sp.setStringList('sousuoList', []);
    notifyListeners();
  }

  // 省市区数据

  var shengshiquDm = DataModel<List>(object: []);
  Future<void> getDropDownList([isLoading = true]) async {
    await Request.get(
      '/api/Area/GetDropDownList',
      isLoading: isLoading,
      data: {"Arealevel": "2"},
      catchError: (v) => shengshiquDm.toError(v),
      success: (v) => shengshiquDm.object = v['data'],
    );
  }

  var allQuyuDm = DataModel<List>(object: []);
  Future<void> getDropDownList1([isLoading = true]) async {
    if (allQuyuDm.object.isEmpty)
      await Request.get(
        '/api/Area/GetDropDownList',
        isLoading: isLoading,
        catchError: (v) => allQuyuDm.toError(v),
        success: (v) => allQuyuDm.object = v['data'],
      );
  }

  ///弹出省市区数据的选择器
  Future<void> showCitySelecto(fun) async {
    if (shengshiquDm.object.isEmpty) await getDropDownList();
    await showSelecto(
      context,
      texts: shengshiquDm.object.map((m) => m['name']).toList(),
      callback: fun,
    );
  }

  ///获取字典数据
  var zidianDm = DataModel<List>(hasNext: false, object: []);
  Future<int> apiDataDictGetDropDownList() async {
    await Request.get(
      '/api/DataDict/GetDropDownList',
      catchError: (v)  {
      // 当请求失败时，手动生成几条默认数据
      List<Map<String, dynamic>> defaultDictData = [
      {
      'dictType': 'NewsType',
      'dictValue': 'tab1',
      'dictKey': 1,
      },
      {
      'dictType': 'NewsType',
      'dictValue': 'tab2',
      'dictKey': 2,
      },
      {
      'dictType': 'NewsType',
      'dictValue': 'tab3',
      'dictKey': 3,
      },
      ];
        zidianDm.object = defaultDictData;
        zidianDm.setTime();
  },
      success: (v) {
        zidianDm.object = v['data'];
        zidianDm.setTime();
      },
    );
    return zidianDm.flag;
  }

  ///首页pageview控制器
  var pageCon = PageController();

  ///底部导航栏索引
  int btmIndex = 0;
  void changeBtmIndex(v) {
    btmIndex = v;
    Future(() {
      notifyListeners();
    });
  }

  // app包信息
  PackageInfo packageInfo;
}

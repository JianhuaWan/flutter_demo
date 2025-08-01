import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/util/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  ///全局位置坐标数据
  String? la, lo, address, province, city, area;
  String? provinceCode, cityCode, areaCode;

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
      catchError: (v) {
        shengshiquDm.object = generateDefaultChinaAreaData();
      },
      success: (v) => shengshiquDm.object = v['data'],
    );
  }

  var allQuyuDm = DataModel<List>(object: []);

  Future<void> getDropDownList1([isLoading = true]) async {
    if (allQuyuDm.object!.isEmpty)
      await Request.get(
        '/api/Area/GetDropDownList',
        isLoading: isLoading,
        catchError: (v) {
          allQuyuDm.object = generateDefaultChinaAreaData();
        },
        success: (v) => allQuyuDm.object = v['data'],
      );
  }

  ///弹出省市区数据的选择器
  Future<void> showCitySelecto(fun) async {
    if (shengshiquDm.object!.isEmpty) await getDropDownList();
    await showSelecto(
      context!,
      texts: shengshiquDm.object!.map((m) => m['name']).toList(),
      callback: fun,
    );
  }

  ///获取字典数据
  var zidianDm = DataModel<List>(hasNext: false, object: []);

  Future<int> apiDataDictGetDropDownList() async {
    await Request.get(
      '/api/DataDict/GetDropDownList',
      catchError: (v) {
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
    return zidianDm.flag!;
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
  PackageInfo? packageInfo;

  // 生成中国所有省市区的默认数据
  List<Map<String, dynamic>> generateDefaultChinaAreaData() {
    // 中国主要省份和城市数据
    List<Map<String, dynamic>> areaData = [
      {
        "id": "110000",
        "name": "北京市",
        "parentId": "0",
        "level": 1,
        "pinyin": "beijing",
        "pinyinInitial": "BJ",
        "sort": 1,
        "remark": "直辖市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "120000",
        "name": "天津市",
        "parentId": "0",
        "level": 1,
        "pinyin": "tianjin",
        "pinyinInitial": "TJ",
        "sort": 2,
        "remark": "直辖市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "130000",
        "name": "河北省",
        "parentId": "0",
        "level": 1,
        "pinyin": "hebei",
        "pinyinInitial": "HB",
        "sort": 3,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "140000",
        "name": "山西省",
        "parentId": "0",
        "level": 1,
        "pinyin": "shanxi",
        "pinyinInitial": "SX",
        "sort": 4,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "150000",
        "name": "内蒙古自治区",
        "parentId": "0",
        "level": 1,
        "pinyin": "neimenggu",
        "pinyinInitial": "NMG",
        "sort": 5,
        "remark": "自治区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "210000",
        "name": "辽宁省",
        "parentId": "0",
        "level": 1,
        "pinyin": "liaoning",
        "pinyinInitial": "LN",
        "sort": 6,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "220000",
        "name": "吉林省",
        "parentId": "0",
        "level": 1,
        "pinyin": "jilin",
        "pinyinInitial": "JL",
        "sort": 7,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "230000",
        "name": "黑龙江省",
        "parentId": "0",
        "level": 1,
        "pinyin": "heilongjiang",
        "pinyinInitial": "HLJ",
        "sort": 8,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "310000",
        "name": "上海市",
        "parentId": "0",
        "level": 1,
        "pinyin": "shanghai",
        "pinyinInitial": "SH",
        "sort": 9,
        "remark": "直辖市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "320000",
        "name": "江苏省",
        "parentId": "0",
        "level": 1,
        "pinyin": "jiangsu",
        "pinyinInitial": "JS",
        "sort": 10,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "330000",
        "name": "浙江省",
        "parentId": "0",
        "level": 1,
        "pinyin": "zhejiang",
        "pinyinInitial": "ZJ",
        "sort": 11,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "340000",
        "name": "安徽省",
        "parentId": "0",
        "level": 1,
        "pinyin": "anhui",
        "pinyinInitial": "AH",
        "sort": 12,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "350000",
        "name": "福建省",
        "parentId": "0",
        "level": 1,
        "pinyin": "fujian",
        "pinyinInitial": "FJ",
        "sort": 13,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "360000",
        "name": "江西省",
        "parentId": "0",
        "level": 1,
        "pinyin": "jiangxi",
        "pinyinInitial": "JX",
        "sort": 14,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "370000",
        "name": "山东省",
        "parentId": "0",
        "level": 1,
        "pinyin": "shandong",
        "pinyinInitial": "SD",
        "sort": 15,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "410000",
        "name": "河南省",
        "parentId": "0",
        "level": 1,
        "pinyin": "henan",
        "pinyinInitial": "HN",
        "sort": 16,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "420000",
        "name": "湖北省",
        "parentId": "0",
        "level": 1,
        "pinyin": "hubei",
        "pinyinInitial": "HB",
        "sort": 17,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "430000",
        "name": "湖南省",
        "parentId": "0",
        "level": 1,
        "pinyin": "hunan",
        "pinyinInitial": "HN",
        "sort": 18,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "440000",
        "name": "广东省",
        "parentId": "0",
        "level": 1,
        "pinyin": "guangdong",
        "pinyinInitial": "GD",
        "sort": 19,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "450000",
        "name": "广西壮族自治区",
        "parentId": "0",
        "level": 1,
        "pinyin": "guangxi",
        "pinyinInitial": "GX",
        "sort": 20,
        "remark": "自治区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "460000",
        "name": "海南省",
        "parentId": "0",
        "level": 1,
        "pinyin": "hainan",
        "pinyinInitial": "HN",
        "sort": 21,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "500000",
        "name": "重庆市",
        "parentId": "0",
        "level": 1,
        "pinyin": "chongqing",
        "pinyinInitial": "CQ",
        "sort": 22,
        "remark": "直辖市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "510000",
        "name": "四川省",
        "parentId": "0",
        "level": 1,
        "pinyin": "sichuan",
        "pinyinInitial": "SC",
        "sort": 23,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "520000",
        "name": "贵州省",
        "parentId": "0",
        "level": 1,
        "pinyin": "guizhou",
        "pinyinInitial": "GZ",
        "sort": 24,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "530000",
        "name": "云南省",
        "parentId": "0",
        "level": 1,
        "pinyin": "yunnan",
        "pinyinInitial": "YN",
        "sort": 25,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "540000",
        "name": "西藏自治区",
        "parentId": "0",
        "level": 1,
        "pinyin": "xizang",
        "pinyinInitial": "XZ",
        "sort": 26,
        "remark": "自治区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "610000",
        "name": "陕西省",
        "parentId": "0",
        "level": 1,
        "pinyin": "shanxi",
        "pinyinInitial": "SX",
        "sort": 27,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "620000",
        "name": "甘肃省",
        "parentId": "0",
        "level": 1,
        "pinyin": "gansu",
        "pinyinInitial": "GS",
        "sort": 28,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "630000",
        "name": "青海省",
        "parentId": "0",
        "level": 1,
        "pinyin": "qinghai",
        "pinyinInitial": "QH",
        "sort": 29,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "640000",
        "name": "宁夏回族自治区",
        "parentId": "0",
        "level": 1,
        "pinyin": "ningxia",
        "pinyinInitial": "NX",
        "sort": 30,
        "remark": "自治区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "650000",
        "name": "新疆维吾尔自治区",
        "parentId": "0",
        "level": 1,
        "pinyin": "xinjiang",
        "pinyinInitial": "XJ",
        "sort": 31,
        "remark": "自治区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "710000",
        "name": "台湾省",
        "parentId": "0",
        "level": 1,
        "pinyin": "taiwan",
        "pinyinInitial": "TW",
        "sort": 32,
        "remark": "省份",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "810000",
        "name": "香港特别行政区",
        "parentId": "0",
        "level": 1,
        "pinyin": "xianggang",
        "pinyinInitial": "HK",
        "sort": 33,
        "remark": "特别行政区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "820000",
        "name": "澳门特别行政区",
        "parentId": "0",
        "level": 1,
        "pinyin": "aomen",
        "pinyinInitial": "MO",
        "sort": 34,
        "remark": "特别行政区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      }
    ];

    return areaData;
  }
}

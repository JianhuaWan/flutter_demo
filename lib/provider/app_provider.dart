import 'package:flutter/material.dart';
import 'package:flutter_app/util/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/layout/views.dart';
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
          {
            'dictType': 'NewsType',
            'dictValue': 'tab4',
            'dictKey': 4,
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
    // 中国主要城市数据（不包含省份）
    List<Map<String, dynamic>> areaData = [
      // 直辖市
      {
        "id": "110000",
        "name": "北京市",
        "parentId": "0",
        "code": "B",
        "level": 1,
        "pinyin": "beijing",
        "pinyinInitial": "B",
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
        "pinyinInitial": "T",
        "code": "T",
        "sort": 2,
        "remark": "直辖市",
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
        "pinyinInitial": "S",
        "code": "S",
        "sort": 3,
        "remark": "直辖市",
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
        "pinyinInitial": "C",
        "code": "C",
        "sort": 4,
        "remark": "直辖市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 河北省城市
      {
        "id": "130100",
        "name": "石家庄市",
        "parentId": "130000",
        "level": 2,
        "pinyin": "shijiazhuang",
        "pinyinInitial": "S",
        "code": "S",
        "sort": 5,
        "remark": "河北省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 山西省城市
      {
        "id": "140100",
        "name": "太原市",
        "parentId": "140000",
        "level": 2,
        "pinyin": "taiyuan",
        "pinyinInitial": "T",
        "code": "T",
        "sort": 6,
        "remark": "山西省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 内蒙古自治区城市
      {
        "id": "150100",
        "name": "呼和浩特市",
        "parentId": "150000",
        "level": 2,
        "pinyin": "huhehaote",
        "pinyinInitial": "H",
        "code": "H",
        "sort": 7,
        "remark": "内蒙古自治区首府",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 辽宁省城市
      {
        "id": "210100",
        "name": "沈阳市",
        "parentId": "210000",
        "level": 2,
        "pinyin": "shenyang",
        "pinyinInitial": "S",
        "code": "S",
        "sort": 8,
        "remark": "辽宁省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "210200",
        "name": "大连市",
        "parentId": "210000",
        "level": 2,
        "pinyin": "dalian",
        "pinyinInitial": "D",
        "code": "D",
        "sort": 9,
        "remark": "辽宁省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 吉林省城市
      {
        "id": "220100",
        "name": "长春市",
        "parentId": "220000",
        "level": 2,
        "pinyin": "changchun",
        "pinyinInitial": "C",
        "code": "C",
        "sort": 10,
        "remark": "吉林省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 黑龙江省城市
      {
        "id": "230100",
        "name": "哈尔滨市",
        "parentId": "230000",
        "level": 2,
        "pinyin": "haerbin",
        "pinyinInitial": "H",
        "code": "H",
        "sort": 11,
        "remark": "黑龙江省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 江苏省城市
      {
        "id": "320100",
        "name": "南京市",
        "parentId": "320000",
        "level": 2,
        "pinyin": "nanjing",
        "pinyinInitial": "N",
        "code": "N",
        "sort": 12,
        "remark": "江苏省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "320500",
        "name": "苏州市",
        "parentId": "320000",
        "level": 2,
        "pinyin": "suzhou",
        "pinyinInitial": "S",
        "code": "S",
        "sort": 13,
        "remark": "江苏省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 浙江省城市
      {
        "id": "330100",
        "name": "杭州市",
        "parentId": "330000",
        "level": 2,
        "pinyin": "hangzhou",
        "pinyinInitial": "H",
        "code": "H",
        "sort": 14,
        "remark": "浙江省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "330200",
        "name": "宁波市",
        "parentId": "330000",
        "level": 2,
        "pinyin": "ningbo",
        "pinyinInitial": "N",
        "code": "N",
        "sort": 15,
        "remark": "浙江省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 安徽省城市
      {
        "id": "340100",
        "name": "合肥市",
        "parentId": "340000",
        "level": 2,
        "pinyin": "hefei",
        "pinyinInitial": "H",
        "code": "H",
        "sort": 16,
        "remark": "安徽省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 福建省城市
      {
        "id": "350100",
        "name": "福州市",
        "parentId": "350000",
        "level": 2,
        "pinyin": "fuzhou",
        "pinyinInitial": "F",
        "code": "F",
        "sort": 17,
        "remark": "福建省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "350200",
        "name": "厦门市",
        "parentId": "350000",
        "level": 2,
        "pinyin": "xiamen",
        "pinyinInitial": "X",
        "code": "X",
        "sort": 18,
        "remark": "福建省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 江西省城市
      {
        "id": "360100",
        "name": "南昌市",
        "parentId": "360000",
        "level": 2,
        "pinyin": "nanchang",
        "pinyinInitial": "N",
        "code": "N",
        "sort": 19,
        "remark": "江西省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 山东省城市
      {
        "id": "370100",
        "name": "济南市",
        "parentId": "370000",
        "level": 2,
        "pinyin": "jinan",
        "pinyinInitial": "J",
        "code": "J",
        "sort": 20,
        "remark": "山东省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "370200",
        "name": "青岛市",
        "parentId": "370000",
        "level": 2,
        "pinyin": "qingdao",
        "pinyinInitial": "Q",
        "code": "Q",
        "sort": 21,
        "remark": "山东省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 河南省城市
      {
        "id": "410100",
        "name": "郑州市",
        "parentId": "410000",
        "level": 2,
        "pinyin": "zhengzhou",
        "pinyinInitial": "Z",
        "code": "Z",
        "sort": 22,
        "remark": "河南省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 湖北省城市
      {
        "id": "420100",
        "name": "武汉市",
        "parentId": "420000",
        "level": 2,
        "pinyin": "wuhan",
        "pinyinInitial": "W",
        "code": "W",
        "sort": 23,
        "remark": "湖北省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 湖南省城市
      {
        "id": "430100",
        "name": "长沙市",
        "parentId": "430000",
        "level": 2,
        "pinyin": "changsha",
        "pinyinInitial": "C",
        "code": "C",
        "sort": 24,
        "remark": "湖南省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 广东省城市
      {
        "id": "440100",
        "name": "广州市",
        "parentId": "440000",
        "level": 2,
        "pinyin": "guangzhou",
        "pinyinInitial": "G",
        "code": "G",
        "sort": 25,
        "remark": "广东省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "440300",
        "name": "深圳市",
        "parentId": "440000",
        "level": 2,
        "pinyin": "shenzhen",
        "pinyinInitial": "S",
        "code": "S",
        "sort": 26,
        "remark": "广东省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "440400",
        "name": "珠海市",
        "parentId": "440000",
        "level": 2,
        "pinyin": "zhuhai",
        "pinyinInitial": "Z",
        "code": "Z",
        "sort": 27,
        "remark": "广东省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 广西壮族自治区城市
      {
        "id": "450100",
        "name": "南宁市",
        "parentId": "450000",
        "level": 2,
        "pinyin": "nanning",
        "pinyinInitial": "N",
        "code": "N",
        "sort": 28,
        "remark": "广西壮族自治区首府",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 海南省城市
      {
        "id": "460100",
        "name": "海口市",
        "parentId": "460000",
        "level": 2,
        "pinyin": "haikou",
        "pinyinInitial": "H",
        "code": "H",
        "sort": 29,
        "remark": "海南省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      {
        "id": "460200",
        "name": "三亚市",
        "parentId": "460000",
        "level": 2,
        "pinyin": "sanya",
        "pinyinInitial": "S",
        "code": "S",
        "sort": 30,
        "remark": "海南省重点城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 四川省城市
      {
        "id": "510100",
        "name": "成都市",
        "parentId": "510000",
        "level": 2,
        "pinyin": "chengdu",
        "pinyinInitial": "C",
        "code": "C",
        "sort": 31,
        "remark": "四川省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 贵州省城市
      {
        "id": "520100",
        "name": "贵阳市",
        "parentId": "520000",
        "level": 2,
        "pinyin": "guiyang",
        "pinyinInitial": "G",
        "code": "G",
        "sort": 32,
        "remark": "贵州省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 云南省城市
      {
        "id": "530100",
        "name": "昆明市",
        "parentId": "530000",
        "level": 2,
        "pinyin": "kunming",
        "pinyinInitial": "K",
        "code": "K",
        "sort": 33,
        "remark": "云南省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 西藏自治区城市
      {
        "id": "540100",
        "name": "拉萨市",
        "parentId": "540000",
        "level": 2,
        "pinyin": "lasa",
        "pinyinInitial": "L",
        "code": "L",
        "sort": 34,
        "remark": "西藏自治区首府",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 陕西省城市
      {
        "id": "610100",
        "name": "西安市",
        "parentId": "610000",
        "level": 2,
        "pinyin": "xian",
        "pinyinInitial": "X",
        "code": "X",
        "sort": 35,
        "remark": "陕西省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 甘肃省城市
      {
        "id": "620100",
        "name": "兰州市",
        "parentId": "620000",
        "level": 2,
        "pinyin": "lanzhou",
        "pinyinInitial": "L",
        "code": "L",
        "sort": 36,
        "remark": "甘肃省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 青海省城市
      {
        "id": "630100",
        "name": "西宁市",
        "parentId": "630000",
        "level": 2,
        "pinyin": "xining",
        "pinyinInitial": "X",
        "code": "X",
        "sort": 37,
        "remark": "青海省省会",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 宁夏回族自治区城市
      {
        "id": "640100",
        "name": "银川市",
        "parentId": "640000",
        "level": 2,
        "pinyin": "yinchuan",
        "pinyinInitial": "Y",
        "code": "Y",
        "sort": 38,
        "remark": "宁夏回族自治区首府",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 新疆维吾尔自治区城市
      {
        "id": "650100",
        "name": "乌鲁木齐市",
        "parentId": "650000",
        "level": 2,
        "pinyin": "wulumuqi",
        "pinyinInitial": "W",
        "code": "W",
        "sort": 39,
        "remark": "新疆维吾尔自治区首府",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 台湾省
      {
        "id": "710000",
        "name": "台北市",
        "parentId": "0",
        "level": 1,
        "pinyin": "taibei",
        "pinyinInitial": "T",
        "code": "T",
        "sort": 40,
        "remark": "台湾省主要城市",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 香港特别行政区
      {
        "id": "810000",
        "name": "香港特别行政区",
        "parentId": "0",
        "level": 1,
        "pinyin": "xianggang",
        "pinyinInitial": "X",
        "code": "X",
        "sort": 41,
        "remark": "特别行政区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      },
      
      // 澳门特别行政区
      {
        "id": "820000",
        "name": "澳门特别行政区",
        "parentId": "0",
        "level": 1,
        "pinyin": "aomen",
        "pinyinInitial": "A",
        "code": "A",
        "sort": 42,
        "remark": "特别行政区",
        "baseVersion": 0,
        "baseModifyTime": DateTime.now().toIso8601String(),
        "baseCreateTime": DateTime.now().toIso8601String(),
      }
    ];

    return areaData;
  }
}

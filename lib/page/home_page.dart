import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/page/home/loupan_page.dart';
import 'package:flutter_app/page/home/wanqu_page.dart';
import 'package:flutter_app/page/zixun_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/appbar_widget.dart';
import 'package:flutter_app/widget/my_custom_scroll.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/media/image.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  ScrollController con = ScrollController();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    app.setIsShowHomeMask(false);
    app.changeBtmIndex(0);
    await this.getBannerList();
    await this.getGuanggaoList();
    await this.apiBuildingGetRecommend();
    await this.apiNewsGetPageList();
    await this.getPageList(isRef: true);
    await Future.delayed(Duration(milliseconds: 2000));

    ///是否第一次分享app
    var isFtsApp = await userPro.isFirstTimeShareApp();
    if (isFtsApp) {
      showGeneralDialog(
        context: context!,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => ShareAppUi(),
      );
    }
  }

  ///轮播图
  var bannerDm = DataModel<List>();

  Future<void> getBannerList() async {
    await Request.get(
      '/api/Banner/GetList',
      data: {"city": app.cityCode ?? "-1"},
      catchError: (v)  {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, String>> defaultBanners = [
          {
            'thumbImage': 'https://via.placeholder.com/800x400/FF0000/FFFFFF?text=Banner+1',
            'content': '',
            'title': '默认横幅1'
          },
          {
            'thumbImage': 'https://via.placeholder.com/800x400/00FF00/000000?text=Banner+2',
            'content': '',
            'title': '默认横幅2'
          },
          {
            'thumbImage': 'https://via.placeholder.com/800x400/0000FF/FFFFFF?text=Banner+3',
            'content': '',
            'title': '默认横幅3'
          },
        ];
        bannerDm.object = defaultBanners;
        bannerDm.setTime();
      },
      success: (v) {
        bannerDm.object = v['data'];
        bannerDm.setTime();
      },
    );
    setState(() {});
  }

  ///广告
  var guanggaoDm = DataModel<List>();

  Future<void> getGuanggaoList() async {
    await Request.get(
      '/api/Advert/GetList',
      data: {"city": app.cityCode ?? "-1"},
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, String>> defaultAds = [
          {
            'thumbImage': 'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=广告1',
            'content': '',
            'title': '默认广告1'
          },
          {
            'thumbImage': 'https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=广告2',
            'content': '',
            'title': '默认广告2'
          },
          {
            'thumbImage': 'https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=广告3',
            'content': '',
            'title': '默认广告3'
          },
        ];
        guanggaoDm.object = defaultAds;
        guanggaoDm.setTime();
      },
      success: (v) {
        guanggaoDm.object = v['data'];
        guanggaoDm.setTime();
      },
    );
    setState(() {});
  }

  ///获取资讯信息列表
  var zixunDm = DataModel(hasNext: false);

  Future<int> apiNewsGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/News/GetPageList',
      data: {"PageIndex": page, "city": app.cityCode ?? "-1"},
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultNews = [
          {
            'preview': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=资讯1',
            'content': '',
            'title': '默认资讯标题1'
          },
          {
            'preview': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=资讯2',
            'content': '',
            'title': '默认资讯标题2'
          },
          {
            'preview': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=资讯3',
            'content': '',
            'title': '默认资讯标题3'
          },
        ];
        zixunDm.addList(defaultNews, isRef, defaultNews.length);
      },
      success: (v) {
        zixunDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return zixunDm.flag!;
  }

  ///获取湾区推荐
  var wanquDm = DataModel(hasNext: false);

  Future<int> apiBuildingGetRecommend(
      {int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetRecommend',
      data: {
        "city": app.cityCode ?? "-1",
        "PageIndex": "1",
      },
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultBuildings = [
          {
            'buildingName': '默认推荐楼盘1',
            'images': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=楼盘1',
          },
          {
            'buildingName': '默认推荐楼盘2',
            'images': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=楼盘2',
          },
          {
            'buildingName': '默认推荐楼盘3',
            'images': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=楼盘3',
          },
        ];
        wanquDm.addList(defaultBuildings, isRef, defaultBuildings.length);
      },
      success: (v) {
        wanquDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return wanquDm.flag!;
  }

  ///地区
  var region;

  ///户型
  var layout;

  ///总价
  var totalPrice;

  ///面积
  var area;

  ///楼盘列表
  var loupanDm = DataModel();

  Future<int> getPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetPageList',
      data: {
        "PageIndex": page,
        if (region != null) "Region": region,
        if (totalPrice != null) "TotalPrice": totalPrice,
        if (layout != null) "Layout": layout,
        if (area != null) "Area": area,
      },
      catchError: (v) {
        // loupanDm.toError(v);
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultBuildings = [
          {
            'buildingName': '默认楼盘1',
            'images': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=楼盘1',
            'price': '待定',
            'areaName': '区域1'
          },
          {
            'buildingName': '默认楼盘2',
            'images': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=楼盘2',
            'price': '待定',
            'areaName': '区域2'
          },
          {
            'buildingName': '默认楼盘3',
            'images': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=楼盘3',
            'price': '待定',
            'areaName': '区域3'
          },
        ];
        loupanDm.addList(defaultBuildings, isRef, defaultBuildings.length);
      },
      success: (v) {
        loupanDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return loupanDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      brightness: Brightness.dark,
      appBar: AppbarWidget(
        callback: (v) async {
          region = null;
          layout = null;
          totalPrice = null;
          area = null;
          if (v != null) {
            bannerDm.flag = 0;
            guanggaoDm.flag = 0;
            zixunDm.flag = 0;
            loupanDm.flag = 0;
            loupanDm.list.clear();

            loupanDm.hasNext = false;
            wanquDm.flag = 0;
            setState(() {});
            await this.getBannerList();
            await this.getGuanggaoList();
            await this.apiBuildingGetRecommend(isRef: true);
            await this.apiNewsGetPageList(isRef: true);
            await this.getPageList(isRef: true);
          }
        },
      ),
      body: MyCustomScroll(
        itemModel: loupanDm,
        headers: headers(),
        expandedCount: -1,
        controller: con,
        onLoading: (p) async => this.getPageList(page: p),
        onRefresh: () async => this.getPageList(isRef: true),
        divider: Divider(height: 32, color: Colors.transparent),
        itemModelBuilder: (i, home) => buildItem(i),
        onScrollToList: (v) => app.setIsShowHomeMask(v),
        maskWidget: ()=>SizedBox(),
      ),
    );
  }

  Widget buildItem(int i) {
    return TweenWidget(
      value: 1,
      isScale: true,
      axis: Axis.vertical,
      child: WidgetTap(
        onTap: () {
          jumpPage(LoupanPage(data: loupanDm.list[i]));
        },
        child: LoupanItem(i: i, data: loupanDm.list[i]),
      ),
    );
  }

  List<Widget> headers() {
    return [
      AnimatedSwitchBuilder(
        value: bannerDm,
        errorOnTap: () => this.getBannerList(),
        initialState: Container(
          height: 192 - 32.0,
          margin: EdgeInsets.all(16),
          key: ValueKey(1),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(5),
          ),
          child: buildLoad(),
        ),
        objectBuilder: (obj) {
          if (obj.length == 0)
            return SizedBox(height: 16);
          else
            return Container(
              height: 192,
              key: ValueKey(2),
              child: Swiper(
                // itemCount: obj.map((f) => f['picUrl']).toList().length,
                itemCount: bannerDm.object!.length,
                pagination: SwiperPagination(
                  margin: EdgeInsets.only(bottom: 24),
                  builder: DotSwiperPaginationBuilder(
                    size: 8,
                    activeSize: 8,
                    // space: 8,
                    activeColor: Theme.of(context!).primaryColor,
                  ),
                ),
                itemBuilder: (_, i) => WidgetTap(
                  isElastic: true,
                  onTap: () {
                    var list = '${bannerDm.object![i]['content']}'.split('&');
                    if (list.length == 2) {
                      flog(list);
                      if (list[0].split('=')[1] == 'building') {
                        jumpPage(
                            LoupanPage(data: {"id": list[1].split('=')[1]}));
                      } else {
                        jumpPage(
                            ZixunInfoPage(data: {"id": list[1].split('=')[1]}));
                      }
                    } else {
                      jumpPage(
                        VrVideoPage(
                          data: {'title': bannerDm.object![i]['title']},
                          url: list.first,
                        ),
                      );
                    }
                  },
                  child: TweenWidget(
                    axis: Axis.vertical,
                    // isScale: true,
                    // value: 1,
                    // time: 500,
                    // curve: ElasticOutCurve(1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: WrapperImage(
                          urlBuilder: () => bannerDm.object![i]['thumbImage'],
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
        },
      ),
      AnimatedSwitchBuilder(
        value: bannerDm,
        initialState: SizedBox(),
        errorOnTap: () => this.getBannerList(),
        isAnimatedSize: true,
        objectBuilder: (_) => CaidanWidget(),
      ),
      AnimatedSwitchBuilder(
        value: guanggaoDm,
        errorOnTap: () => this.getGuanggaoList(),
        isAnimatedSize: true,
        objectBuilder: (obj) {
          if (obj.length == 0)
            return SizedBox(height: 16);
          else
            return TweenWidget(
              axis: Axis.vertical,
              // isScale: true,
              // value: 1,
              // time: 500,
              // curve: ElasticOutCurve(1),
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: WidgetTap(
                  onTap: () {
                    jumpPage(VrVideoPage(url: obj[0]['content'], data: obj[0]));
                  },
                  child: WrapperImage(
                    urlBuilder: () => obj[0]['thumbImage'],
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
        },
      ),
      AnimatedSwitchBuilder(
        value: wanquDm,
        errorOnTap: () => this.apiBuildingGetRecommend(),
        isAnimatedSize: true,
        noDataView: SizedBox(),
        listBuilder: (list, p, h) {
          return TweenWidget(
            axis: Axis.vertical,
            child: Column(
              children: [
                BigTitleWidget(
                  isShowMore: true,
                  title: '标题',
                  onTap: () {
                    jumpPage(WanquPage());
                  },
                ),
                Container(
                  height: 109,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: ListView.separated(
                    separatorBuilder: (_, i) => Container(width: 16),
                    itemCount: list.length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 17, right: 17),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      return WidgetTap(
                        isElastic: true,
                        onTap: () {
                          jumpPage(LoupanPage(data: list[i]));
                        },
                        child: Container(
                          width: size(context).width * 0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 109,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: WrapperImage(
                                      url: list[i]['images']
                                          .toString()
                                          .split(';')
                                          .first,
                                      height: 100,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/img/home_remen.png',
                                          width: 48,
                                          height: 24,
                                          color: Colors.red,
                                        ),
                                        MyText('No.${i + 1}',
                                            color: Colors.white),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 34,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 12),
                                      child: MyText(
                                        list[i]['buildingName'],
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0x00000000),
                                            Color(0xff202020)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      AnimatedSwitchBuilder(
        value: zixunDm,
        errorOnTap: () => this.apiNewsGetPageList(),
        isAnimatedSize: true,
        noDataView: SizedBox(),
        listBuilder: (list, p, h) {
          return TweenWidget(
            axis: Axis.vertical,
            child: Column(
              children: [
                BigTitleWidget(
                  isShowMore: true,
                  onTap: () {
                    app.pageCon.jumpToPage(1);
                    app.changeBtmIndex(1);
                  },
                ),
                WidgetTap(
                  isElastic: true,
                  onTap: () {
                      jumpPage(ZixunInfoPage(data: list[0]));
                  },
                  child: ZixunWidget(data: list[0]),
                ),
              ],
            ),
          );
        },
      ),
      AnimatedSwitchBuilder(
        value: loupanDm,
        errorOnTap: () => this.getPageList(),
        noDataView: SizedBox(),
        isAnimatedSize: true,
        listBuilder: (list, p, h) {
          return BigTitleWidget(title: '标题', isBottom: true);
        },
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}

class ShareAppUi extends StatefulWidget {
  @override
  _ShareAppUiState createState() => _ShareAppUiState();
}

class _ShareAppUiState extends State<ShareAppUi> with TickerProviderStateMixin {
  TextEditingController con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldWidget(
        bgColor: Colors.transparent,
        body: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: TweenWidget(
            axis: Axis.vertical,
            isOpen: true,
            curve: ElasticOutCurve(1),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/img/share_app.png',
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () async {
                      close();
                      userPro.addFirstTimeShareAppFlag();
                      showToast('onclick');
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/img/share_app_btn.png',
                          height: 37,
                        ),
                        MyText(
                          '测试版本',
                          size: 15,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () => close(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/img/share_app_close.png',
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kqsc/page/home/loupan_page.dart';
import 'package:kqsc/page/home/wanqu_page.dart';
import 'package:kqsc/page/shaixuan_page.dart';
import 'package:kqsc/page/video_page.dart';
import 'package:kqsc/page/zixun_page.dart';
import 'package:kqsc/provider/app_provider.dart';
import 'package:kqsc/provider/provider_config.dart';
import 'package:kqsc/util/comon.dart';
import 'package:kqsc/util/http.dart';
import 'package:kqsc/widget/appbar_widget.dart';
import 'package:kqsc/widget/my_custom_scroll.dart';
import 'package:kqsc/widget/tween_widget.dart';
import 'package:kqsc/widget/widgets.dart';
import 'package:paixs_utils/config/net/Config.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
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
    await ComonUtil.checkUpdateApp();

    ///是否第一次分享app
    var isFtsApp = await userPro.isFirstTimeShareApp();
    if (isFtsApp) {
      showGeneralDialog(
        context: context,
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
      catchError: (v) => bannerDm.toError(v),
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
      catchError: (v) => guanggaoDm.toError(v),
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
      catchError: (v) => zixunDm.toError(v),
      success: (v) {
        zixunDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return zixunDm.flag;
  }

  ///获取湾区推荐
  var wanquDm = DataModel(hasNext: false);
  Future<int> apiBuildingGetRecommend({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Building/GetRecommend',
      data: {
        "city": app.cityCode ?? "-1",
        "PageIndex": "1",
      },
      catchError: (v) => wanquDm.toError(v),
      success: (v) {
        wanquDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return wanquDm.flag;
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
        loupanDm.toError(v);
      },
      success: (v) {
        loupanDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return loupanDm.flag;
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
        maskWidget: () {
          return Selector<AppProvider, bool>(
            selector: (_, k) => k.isShowHomeMask,
            builder: (_, v, view) {
              return AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: 0,
                right: 0,
                bottom: 0,
                top: v
                    ? 0
                    : (region != null || totalPrice != null || layout != null || area != null)
                        ? 0
                        : -56,
                child: HomeSelectoWidget(fun: (v) async {
                  region = v['quyu'];
                  totalPrice = v['zongjia'];
                  layout = v['huxing'];
                  area = v['jianzhu'];
                  app.setIsShowHomeMask(false);
                  // loupanDm.list.clear();
                  buildShowDialog(context);
                  await this.getPageList(isRef: true);
                  close();
                }),
              );
            },
          );
        },
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
                itemCount: bannerDm.object.length,
                pagination: SwiperPagination(
                  margin: EdgeInsets.only(bottom: 24),
                  builder: DotSwiperPaginationBuilder(
                    size: 8,
                    activeSize: 8,
                    // space: 8,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                itemBuilder: (_, i) => WidgetTap(
                  isElastic: true,
                  onTap: () {
                    var list = '${bannerDm.object[i]['content']}'.split('&');
                    if (list.length == 2) {
                      flog(list);
                      if (list[0].split('=')[1] == 'building') {
                        jumpPage(LoupanPage(data: {"id": list[1].split('=')[1]}));
                      } else {
                        jumpPage(ZixunInfoPage(data: {"id": list[1].split('=')[1]}));
                      }
                    } else {
                      jumpPage(
                        VrVideoPage(
                          data: {'title': bannerDm.object[i]['title']},
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
                          urlBuilder: () => bannerDm.object[i]['thumbImage'],
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
                  title: '湾区推荐',
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
                                      url: list[i]['images'].toString().split(';').first,
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
                                        MyText('No.${i + 1}', color: Colors.white),
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
                                          colors: [Color(0x00000000), Color(0xff202020)],
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
                    if (list[0]['content'].toString().contains('mp4')) {
                      jumpPage(
                        VideoApp(videoId: list[0]['content'], data: list[0]),
                        isMoveBtm: true,
                      );
                    } else {
                      jumpPage(ZixunInfoPage(data: list[0]));
                    }
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
          return BigTitleWidget(title: '新房甄选', isBottom: true);
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
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/img/share_app_btn.png',
                          height: 37,
                        ),
                        MyText(
                          '一键分享',
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

                  // Html(
                  //   data: '''感谢您选择内当家App！<br/>我们非常重视您的个人信息和隐私保护，为了更好地保障您的个人权益，请您务必审慎阅读、充分理解<a href="12">《用户协议》</a>和<a href="11">《隐私政策》</a>各条款，包括但不限于：<br>1.在您使用软件及服务的过程中，向你提供相关基本功能，我们将根据合法、正当、必要的原则，收集或使用必要的个人信息；<br/>2.基于您的授权，我们可能会获取您的地理位置、通讯录、相机等相关软件权限；<br/>3.我们会采取符合标准的技术措施和数据安全措施来保护您的个人信息安全；<br/>4.您可以查询、更正、管理您的个人信息，我们也提供账户注销的渠道；<br/>如您同意以上协议内容，请点击“同意”开始使用我们的产品和服务。''',
                  //   defaultTextStyle: TextStyle(color: Colors.black54),
                  //   linkStyle: TextStyle(color: Theme.of(context).primaryColor),
                  //   padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  //   onLinkTap: (v) {
                  //     jumpPage(XieyiPage(type: v));
                  //   },
                  // ),
                  // BtnWidget(
                  //   isShowShadow: false,
                  //   titles: ['不同意并退出', '同意'],
                  //   bgColor: Colors.transparent,
                  //   btnHeight: [10, 12],
                  //   value: [50, 50],
                  //   time: [750, 750],
                  //   delayed: [0, 100],
                  //   axis: [Axis.vertical, Axis.vertical],
                  //   curve: [ElasticOutCurve(1), ElasticOutCurve(1)],
                  //   onTap: [
                  //     () => exit(0),
                  //     () {
                  //       userPro.addFirstTimeOpenAppFlag();
                  //       close(true);
                  //     },
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

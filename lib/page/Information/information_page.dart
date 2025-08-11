import 'package:flutter/material.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/widget/custom_scroll_widget.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/media/image.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';

import '../../net/base_http.dart';

class InformationPage extends StatefulWidget {
  final bool isHome;

  const InformationPage({Key? key, this.isHome = true}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    // await this.apiDataDictGetDropDownList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '标题',
        color: Colors.white,
        isNoShowLeft: widget.isHome,
      ),
      body: AnimatedSwitchBuilder<List>(
        value: app.zidianDm,
        errorOnTap: () => app.apiDataDictGetDropDownList(),
        isAnimatedSize: true,
        objectBuilder: (v) {
          return TabWidget(
            isScrollable: true,
            tabList: v
                .where((w) => w['dictType'] == 'NewsType')
                .map<String>((m) => m['dictValue'])
                .toList(),
            tabPage: v
                .where((w) => w['dictType'] == 'NewsType')
                .map((m) => ZixunView(m))
                .toList(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ZixunView extends StatefulWidget {
  final Map data;

  const ZixunView(this.data, {Key? key}) : super(key: key);

  @override
  _ZixunViewState createState() => _ZixunViewState();
}

class _ZixunViewState extends State<ZixunView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiNewsGetPageList(isRef: true);
  }

  ///获取资讯信息列表
  var zixunDm = DataModel(hasNext: false);

  Future<int> apiNewsGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/News/GetPageList',
      data: {"PageIndex": page, "Type": widget.data['dictKey']},
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultNews = [
          {
            'preview':
                'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=资讯1',
            'title': '默认标题1',
            'content': '',
          },
          {
            'preview':
                'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=资讯2',
            'title': '默认标题2',
            'content': '',
          },
          {
            'preview':
                'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=资讯3',
            'title': '默认标题3',
            'content': '',
          },
          {
            'preview':
                'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=资讯1',
            'title': '默认标题1',
            'content': '',
          },
          {
            'preview':
                'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=资讯2',
            'title': '默认标题2',
            'content': '',
          },
          {
            'preview':
                'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=资讯3',
            'title': '默认标题3',
            'content': '',
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      body: AnimatedSwitchBuilder(
        value: zixunDm,
        errorOnTap: () => this.apiNewsGetPageList(isRef: true),
        isAnimatedSize: true,
        noDataText: '暂无${widget.data['dictValue']}',
        listBuilder: (list, p, h) {
          return CustomScroll(
            itemModel: zixunDm,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            itemPadding: EdgeInsets.all(10),
            onRefresh: () => this.apiNewsGetPageList(isRef: true),
            onLoading: (p) => this.apiNewsGetPageList(page: p),
            itemModelBuilder: (i, v) {
              return WidgetTap(
                onTap: () {
                  jumpPage(ZixunInfoPage(data: v));
                },
                child: AnimationWidget(
                  axis: Axis.vertical,
                  delayed: 100 * (i % 3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        WrapperImage(
                          urlBuilder: () => v['preview'],
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        if (widget.data['dictKey'] == 105 ||
                            widget.data['dictKey'] == 106)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black38,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 56,
                              ),
                            ),
                          ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            // height: 34,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(12),
                            child: MyText(
                              list[i]['title'],
                              color: Colors.white,
                              isOverflow: false,
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
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ZixunInfoPage extends StatefulWidget {
  final Map? data;

  const ZixunInfoPage({Key? key, this.data}) : super(key: key);

  @override
  _ZixunInfoPageState createState() => _ZixunInfoPageState();
}

class _ZixunInfoPageState extends State<ZixunInfoPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiNewsGetEntity(isRef: true);
  }

  ///获取资讯详情
  var zixunInfoDm = DataModel(hasNext: false);

  Future<int> apiNewsGetEntity({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/News/GetEntity',
      data: {"id": widget.data!['id']},
      catchError: (v) {
        // 当请求失败时，手动生成默认数据
        zixunInfoDm.object = {
          'title': widget.data!['title'] ?? '默认资讯标题',
          'content': '这是默认的资讯内容。',
          'preview':
              'https://via.placeholder.com/400x300/CCCCCC/FFFFFF?text=默认资讯',
        };
        zixunInfoDm.setTime();
      },
      success: (v) {
        zixunInfoDm.object = v['data'];
        if (zixunInfoDm.object == null)
          zixunInfoDm.toError('暂无数据');
        else
          zixunInfoDm.setTime();
        print(zixunInfoDm.toJson());
      },
    );
    setState(() {});
    return zixunInfoDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: widget.data!['title'] ?? '1',
        color: Colors.white,
      ),
      body: AnimatedSwitchBuilder(
        value: zixunInfoDm,
        errorOnTap: () => this.apiNewsGetEntity(isRef: true),
        objectBuilder: (obj) {
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(10),
              // child: Html(
              //   data: obj['content'],
              // ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/text_edit_widget.dart';
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
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class FensiPage extends StatefulWidget {
  @override
  _FensiPageState createState() => _FensiPageState();
}

class _FensiPageState extends State<FensiPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiUserFans(isRef: true);
  }

  ///我的粉丝
  var fensiDm = DataModel(hasNext: false);
  Future<int> apiUserFans({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Fans/GetPageList',
      data: {"PageIndex": page},
      catchError: (v) => fensiDm.toError(v),
      success: (v) {
        fensiDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return fensiDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      resizeToAvoidBottomInset: false,
      appBar: buildTitle(
        context,
        title: '我的粉丝',
        color: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TextEditWidget(
              hint: '请输入关键词搜索',
              bgColor: Colors.black.withOpacity(0.05),
              onSubmitted: (v) {
                setState(() {
                  fensiDm.flag = 0;
                });
                this.apiUserFans(isRef: true);
              },
            ),
          ),
          AnimatedSwitchBuilder(
            value: fensiDm,
            isExd: true,
            errorOnTap: () => this.apiUserFans(isRef: true),
            isAnimatedSize: true,
            noDataText: '暂无粉丝',
            listBuilder: (list, p, h) {
              return MyListView(
                isShuaxin: true,
                isGengduo: h,
                padding: EdgeInsets.symmetric(vertical: 10),
                listViewType: ListViewType.Separated,
                divider: Divider(height: 10, color: Colors.transparent),
                onLoading: () => this.apiUserFans(page: p),
                onRefresh: () => this.apiUserFans(isRef: true),
                itemCount: list.length,
                item: (i) {
                  return WidgetTap(
                    isElastic: true,
                    onTap: () => jumpPage(FensiInfoPage(list[i]['id'])),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          ClipOval(
                            child: WrapperImage(
                              height: 55,
                              width: 55,
                              urlBuilder: (_) => list[i]['portrait'],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    MyText(
                                      list[i]['nickName'],
                                      isBold: true,
                                      isOverflow: false,
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.only(left: 8, right: 8, top: 1, bottom: 1),
                                      color: Color(0xFF2B8FFC).withOpacity(0.1),
                                      child: MyText(
                                        '男',
                                        isBold: true,
                                        size: 13,
                                        color: Color(0xFF2B8FFC),
                                        isOverflow: false,
                                      ),
                                    ),
                                  ],
                                ),
                                if (list[i]['mobile'] != null) SizedBox(height: 6),
                                if (list[i]['mobile'] != null)
                                  MyText(
                                    list[i]['mobile'],
                                    color: Colors.grey,
                                    size: 12,
                                  ),
                                SizedBox(height: 6),
                                MyText(
                                  '加入时间：${list[i]['baseCreateTime']}',
                                  color: Colors.grey,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                          if (list[i]['mobile'] != null)
                            WidgetTap(
                              isElastic: true,
                              onTap: () {
                                phoneTelURL(list[i]['mobile']);
                              },
                              child: Icon(
                                Icons.phone,
                                color: Color(0xFF2B8FFC),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FensiInfoPage extends StatefulWidget {
  final String id;

  const FensiInfoPage(this.id, {Key? key}) : super(key: key);
  @override
  _FensiInfoPageState createState() => _FensiInfoPageState();
}

class _FensiInfoPageState extends State<FensiInfoPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiFansGetDetail(isRef: true);
  }

  ///粉丝详情
  var fensiInfoDm = DataModel(hasNext: false);
  Future<int> apiFansGetDetail({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Fans/GetDetail',
      data: {"id": widget.id, "date": DateTime.now().toString()},
      catchError: (v) => fensiInfoDm.toError(v),
      success: (v) {
        fensiInfoDm.object = v['data'];
        fensiInfoDm.setTime();
      },
    );
    setState(() {});
    return fensiInfoDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '粉丝详情',
        color: Colors.white,
      ),
      body: AnimatedSwitchBuilder(
        value: fensiInfoDm,
        errorOnTap: () => this.apiFansGetDetail(isRef: true),
        isAnimatedSize: true,
        objectBuilder: (obj) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.white,
                  child: MyListView(
                    isShuaxin: false,
                    item: (i) => List.generate(4, (i) {
                      return ItemEditWidget(
                        title: ['姓名', '电话', '加入时间', '推荐成交数'][i],
                        isSelecto: true,
                        isShowDivider: false,
                        titleColor: Colors.black,
                        selectoColor: Colors.grey,
                        isShowJt: false,
                        selectoText: '${[
                          obj['nickName'],
                          obj['mobile'],
                          obj['baseCreateTime'],
                          obj['recDoneCount'],
                        ][i]}',
                      );
                    })[i],
                    itemCount: 4,
                    listViewType: ListViewType.Separated,
                    divider: Divider(height: 0, indent: 16),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

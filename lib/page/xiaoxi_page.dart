import 'package:flutter/material.dart';
import 'package:flutter_app/util/http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

class XiaoxiPage extends StatefulWidget {
  @override
  _XiaoxiPageState createState() => _XiaoxiPageState();
}

class _XiaoxiPageState extends State<XiaoxiPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiMessageGetPageList(isRef: true);
  }

  ///获取系统消息
  var xiaoxiDm = DataModel(hasNext: false);
  Future<int> apiMessageGetPageList({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Message/GetPageList',
      data: {"id": "318167477655707648"},
      catchError: (v) => xiaoxiDm.toError(v),
      success: (v) {
        xiaoxiDm.addList(v['data'], isRef, v['total']);
      },
    );
    setState(() {});
    return xiaoxiDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '系统消息',
        color: Colors.white,
      ),
      body: AnimatedSwitchBuilder(
        value: xiaoxiDm,
        errorOnTap: () => this.apiMessageGetPageList(isRef: true),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: true,
            isGengduo: h,
            padding: EdgeInsets.symmetric(vertical: 10),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 10, color: Colors.transparent),
            onLoading: () => this.apiMessageGetPageList(page: p),
            onRefresh: () => this.apiMessageGetPageList(isRef: true),
            itemCount: list.length,
            item: (i) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () {
                      jumpPage(
                        ScaffoldWidget(
                          appBar: buildTitle(context, title: '消息详情', isShowBorder: true),
                          bgColor: Colors.white,
                          body: ListView(
                            padding: EdgeInsets.all(16),
                            children: [
                              MyText(
                                list[i]['title'],
                                size: 18,
                                isBold: true,
                              ),
                              SizedBox(height: 8),
                              MyText(
                                '时间：${toTime(list[i]['baseCreateTime'])}',
                                color: Colors.grey,
                              ),
                              Divider(height: 40),
                              // Html(
                              //   data: list[i]['content'],
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: MyText(
                                  list[i]['title'],
                                  color: Colors.grey,
                                  textAlign: TextAlign.left,
                                  isOverflow: false,
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  toTime(list[i]['baseCreateTime']),
                                  color: Colors.grey,
                                  textAlign: TextAlign.end,
                                  isOverflow: false,
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 32),
                          MyText(
                            list[i]['content'],
                            color: Colors.black,
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            isOverflow: false,
                          ),
                        ],
                      ),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

class TixianPage extends StatefulWidget {
  final String id;

  const TixianPage(this.id, {Key key}) : super(key: key);
  @override
  _TixianPageState createState() => _TixianPageState();
}

class _TixianPageState extends State<TixianPage> {
  var fangshi, kaihuhang;
  TextEditingController textCon1 = TextEditingController();
  TextEditingController textCon2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '提现申请',
        color: Colors.white,
        isShowBorder: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: TweenWidget(
          axis: Axis.vertical,
          isOpacity: true,
          delayed: 50,
          value: 50,
          curve: ElasticOutCurve(1),
          child: Container(
            color: Colors.white,
            child: MyListView(
              isShuaxin: false,
              item: (i) => fangshi == '银行卡' ? item[i] : item1[i],
              itemCount: fangshi == '银行卡' ? item.length : item1.length,
              listViewType: ListViewType.Separated,
              divider: Divider(height: 0, indent: 16),
            ),
          ),
        ),
      ),
      btnBar: BtnWidget(
        titles: ['取消', '确认'],
        time: [750, 750],
        value: [50, 50],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
        delayed: [0, 100],
        onTap: [
          () => close(),
          () {
            if (fangshi == null) {
              showToast('请选择转账方式');
            } else if (kaihuhang == null && fangshi == '银行卡') {
              showToast('请选择银行卡开户行');
            } else if (textCon1.text == '') {
              showToast('请输入提现账号');
            } else {
              Request.post(
                '/api/UserRights/Cash',
                data: {
                  "id": widget.id,
                  "userId": user.id,
                  "payment": {'微信': '1', '银行卡': '3', '支付宝': '2'}[fangshi],
                  if (fangshi == '银行卡') "bankType": kaihuhang['dictKey'],
                  "bankCard": textCon1.text,
                },
                isLoading: true,
                catchError: (v) => showToast(v.toString()),
                success: (v) {
                  showToast('提现申请已提交');
                  close();
                },
              );
            }
          },
        ],
      ),
    );
  }

  List<Widget> get item {
    return List.generate(3, (i) {
      return ItemEditWidget(
        titleWidth: 150,
        title: ['选择转账方式', '选择银行卡开户行', '提现账号', '提现密码'][i],
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isEditText: i == 2 || i == 3,
        textCon: [null, null, textCon1, textCon2][i],
        isSelecto: !(i == 2 || i == 3),
        selectoText: [fangshi, kaihuhang == null ? kaihuhang : kaihuhang['dictValue'], null, null][i],
        selectoOnTap: () {
          switch (i) {
            case 0:
              showSelecto(context, texts: ['微信', '银行卡', '支付宝'], callback: (v, i) {
                setState(() {
                  fangshi = v;
                });
              });
              break;
            case 1:
              jumpPage(
                SelectoBank(),
                callback: (v) {
                  setState(() => kaihuhang = v);
                },
              );
              break;
          }
        },
      );
    });
  }

  List<Widget> get item1 {
    return List.generate(2, (i) {
      return ItemEditWidget(
        titleWidth: 150,
        title: ['选择转账方式', '提现账号'][i],
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isEditText: [false, true][i],
        textCon: [null, textCon1][i],
        isSelecto: ![false, true][i],
        selectoText: [fangshi, null][i],
        selectoOnTap: () {
          switch (i) {
            case 0:
              showSelecto(context, texts: ['微信', '银行卡', '支付宝'], callback: (v, i) {
                setState(() {
                  fangshi = v;
                });
              });
              break;
            // case 1:
            //   jumpPage(
            //     SelectoBank(),
            //     callback: (v) {
            //       setState(() => kaihuhang = v);
            //     },
            //   );
            //   break;
          }
        },
      );
    });
  }
}

class SelectoBank extends StatefulWidget {
  @override
  _SelectoBankState createState() => _SelectoBankState();
}

class _SelectoBankState extends State<SelectoBank> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: Column(
        children: [
          buildTitle(
            context,
            title: '选择银行',
            color: Colors.white,
            isShowBorder: true,
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //   color: Colors.white,
          //   child: Container(
          //     height: 34,
          //     padding: EdgeInsets.symmetric(horizontal: 9),
          //     decoration: BoxDecoration(
          //       color: Color(0xffF5F5F5),
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(
          //           Icons.search_rounded,
          //           size: 16,
          //           color: Color(0xffB4B4B4),
          //         ),
          //         SizedBox(width: 4),
          //         buildTFView(
          //           context,
          //           hintText: '\t请输入关键词搜索',
          //           hintSize: 13,
          //           hintColor: Color(0xffB4B4B4),
          //           isExp: true,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Divider(height: 0)
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.white,
          child: MyListView(
            isShuaxin: false,
            item: (i) {
              return ItemEditWidget(
                titleColor: Colors.black,
                isShowDivider: false,
                title: app.zidianDm.object.where((w) => w['dictType'] == 'BankType').toList()[i]['dictValue'],
                selectoOnTap: () {
                  close(app.zidianDm.object.where((w) => w['dictType'] == 'BankType').toList()[i]);
                },
              );
            },
            itemCount: app.zidianDm.object.where((w) => w['dictType'] == 'BankType').length,
            listViewType: ListViewType.Separated,
          ),
        ),
      ),
    );
  }
}

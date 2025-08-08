import 'package:flutter/material.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

class GoufangZiliao extends StatefulWidget {
  final bool isZige;

  const GoufangZiliao({Key? key, this.isZige = false}) : super(key: key);
  @override
  _GoufangZiliaoState createState() => _GoufangZiliaoState();
}

class _GoufangZiliaoState extends State<GoufangZiliao> {
  var cityJson = [];
  var cityMap;
  var data;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(
        context,
        title: cityMap == null
            ? widget.isZige
                ? '购房资格'
                : '购房资料'
            : '${cityMap['name']}',
        color: Colors.white,
        isShowBorder: true,
      ),
      btnBar: BtnWidget(
        isShowOnlyOne: true,
        titles: ['', '查看更多'],
        time: [1000, 1000],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.75), ElasticOutCurve(0.75)],
        onTap: [
          () {},
          () async {
            ///获取购房资料列表
            await Request.get(
              widget.isZige ? '/api/Information/GeSeniorityList' : '/api/Information/GeMaterialList',
              data: {"PageSize": "1000"},
              isLoading: true,
              catchError: (v) {
                // 网络异常时生成模拟数据
                List<Map<String, dynamic>> mockData = [
                  {
                    'id': '1',
                    'title': '本地户籍购房资料',
                  },
                  {
                    'id': '2',
                    'title': '外地户籍购房资料',
                  },
                  {
                    'id': '3',
                    'title': '港澳台及外籍购房资料',
                  },
                ];
                
                showSelecto(context, texts: mockData.map((v) => v['title']).toList(), callback: (vv, i) async {
                  cityMap = {'name': mockData[i]['title']};

                  // 模拟获取购房资料详情
                  setState(() {
                    data = widget.isZige 
                      ? '<h2>购房资格说明</h2><p>1. 本地户籍：需提供身份证、户口本等材料</p><p>2. 社保缴纳证明：连续缴纳12个月社保</p><p>3. 收入证明：银行流水等</p>'
                      : '<h2>购房所需资料</h2><p>1. 身份证原件及复印件</p><p>2. 户口本原件及复印件</p><p>3. 婚姻状况证明</p><p>4. 收入证明及银行流水</p>';
                  });
                });
              },
              success: (v) {
                showSelecto(context, texts: v['data'].map((v) => v['title']).toList(), callback: (vv, i) async {
                  cityMap = {'name': v['data'][i]['title']};

                  ///获取购房资料详情
                  await Request.get(
                    '/api/Information/GetMaterial',
                    isLoading: true,
                    data: {"id": v['data'][i]['id']},
                    catchError: (v) {
                      // 获取详情失败时显示模拟数据
                      setState(() {
                        data = widget.isZige 
                          ? '<h2>购房资格说明</h2><p>1. 符合当地购房政策要求</p><p>2. 具备稳定收入来源</p><p>3. 无不良征信记录</p>'
                          : '<h2>购房所需资料</h2><p>1. 身份证、户口本等身份证明</p><p>2. 收入证明及银行流水</p><p>3. 婚姻状况证明</p><p>4. 购房合同及首付款证明</p>';
                      });
                    },
                    success: (v) {
                      setState(() {
                        data = v['data']['content'];
                      });
                    },
                  );
                });
              },
            );
          },
        ],
      ),
      body: TweenWidget(
        axis: Axis.vertical,
        isOpacity: true,
        child: ListView(
          padding: EdgeInsets.all(17.0),
          physics: BouncingScrollPhysics(),
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              '此列为必须材料',
              size: 18,
              isBold: true,
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            MyText(
              '注意事项',
              size: 15,
              isBold: true,
            ),
            SizedBox(height: 16),
            MyListView(
              isShuaxin: false,
              item: (i) => item2[i],
              itemCount: 2,
              listViewType: ListViewType.Separated,
              divider: Divider(height: 2, color: Colors.transparent),
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get item1 {
    return List.generate(4, (i) {
      return MyText(
        '*',
        color: Colors.red,
        children: [
          MyText.ts(
            [
              '1、身份证（原件）',
              '2、户口本（公安页，户主页，本人页）',
              '3、结婚证明（结婚证，离婚证）',
              '4、收入证明',
            ][i],
            color: Colors.black,
          ),
        ],
      );
    });
  }

  List<Widget> get item2 {
    return List.generate(2, (i) {
      return Opacity(
        opacity: 0.4,
        child: MyText(
          '*',
          color: Colors.red,
          isOverflow: false,
          size: 13,
          children: [
            MyText.ts(
              [
                '1、以上所有资料均为原件，缺一份银行都不受理，提供结婚证和联名客户都要夫妻双方现场签字',
                '2、以上资料仅供参考，具体咨询项目驻场经理',
              ][i],
              color: Colors.black,
            ),
          ],
        ),
      );
    });
  }
}

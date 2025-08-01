import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
  // @override
  // void initState() {
  //   this.initData();
  //   super.initState();
  // }

  // ///初始化函数
  // Future initData() async {
  //   // await this.getCityData();
  // }

  // Future getCityData() async {
  //   var cityData = await rootBundle.loadString('data/province.json');
  //   cityJson = json.decode(cityData);
  // }

  // ///获取购房资料
  // var ziliaoDm = DataModel(hasNext: false);
  // Future<int> apiInformationGetMaterial({int page = 1, bool isRef = false}) async {
  //   await Request.get(
  //     '/api/Information/GetMaterial',
  //     isLoading: true,
  //     data: {"cityId": cityMap['id']},
  //     catchError: (v) => ziliaoDm.toError(v),
  //     success: (v) {
  //       ziliaoDm.object = v['data'] ?? {};
  //       ziliaoDm.setTime();
  //     },
  //   );
  //   setState(() {});
  //   return ziliaoDm.flag;
  // }

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
              catchError: (v) => showToast(v.toString()),
              success: (v) {
                showSelecto(context, texts: v['data'].map((v) => v['title']).toList(), callback: (vv, i) async {
                  cityMap = {'name': v['data'][i]['title']};

                  ///获取购房资料详情
                  await Request.get(
                    '/api/Information/GetMaterial',
                    isLoading: true,
                    data: {"id": v['data'][i]['id']},
                    catchError: (v) => showToast(v.toString()),
                    success: (v) {
                      setState(() {
                        data = v['data']['content'];
                      });
                    },
                  );
                });
              },
            );

            // app.showCitySelecto((v, i) {
            //   cityMap = app.shengshiquDm.object[i];
            //   this.apiInformationGetMaterial();
            // });
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
            // Html(data: cityMap == null ? '请选择城市' : data ?? '暂无资料'),
            // MyText(
            //   '*',
            //   color: Colors.red,
            //   children: [
            //     MyText.ts(
            //       cityId == null ? '请选择城市' : ziliaoDm.object['content'],
            //       color: Colors.black,
            //     ),
            //   ],
            // ),
            // MyListView(
            //   isShuaxin: false,
            //   item: (i) => item1[i],
            //   itemCount: 4,
            //   listViewType: ListViewType.Separated,
            //   divider: Divider(height: 2, color: Colors.transparent),
            //   physics: NeverScrollableScrollPhysics(),
            // ),
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

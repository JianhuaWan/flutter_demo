import 'package:flutter/material.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

class BaozhangPage extends StatefulWidget {
  @override
  _BaozhangPageState createState() => _BaozhangPageState();
}

class _BaozhangPageState extends State<BaozhangPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getData();
  }

  var data = DataModel();
  Future<void> getData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    data.setTime();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.light,
      body: Stack(
        children: [
          Image.asset(
            'assets/img/baozhang.png',
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          ListView(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 80),
              Center(
                child: MyText(
                  '我们的保障',
                  size: 46,
                  color: Colors.white,
                  isBold: true,
                ),
              ),
              Image.asset(
                'assets/img/ic_launcher.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Transform.translate(
                offset: Offset(0, -56),
                child: MyListView(
                  isShuaxin: false,
                  itemCount: 4,
                  listViewType: ListViewType.Separated,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 18, right: 18),
                  divider: Divider(height: 48, color: Colors.transparent),
                  item: (i) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 18, right: 18, bottom: 24, top: 48),
                            alignment: Alignment.center,
                            child: [
                              MyText(
                                '内当家所有平台(网站、APP)所展示的房源信息均为业务团队根据房源实况采集，少量信息来源于网络或其他渠道,尽量做到无误差',
                                size: 15,
                                isOverflow: false,
                              ),
                              MyText(
                                '您可直接将反材料及个人联系方式发送至企业邮箱 ',
                                size: 15,
                                isOverflow: false,
                                children: [
                                  MyText.ts('2216450776@qq.com', color: Color(0xFFF06E6E)),
                                  MyText.ts('， 工作人员收到信息审核无误后会按反馈数量以现金或其他等价物质赔付给你!咨询热线:'),
                                  MyText.ts('13268680202', color: Color(0xFFF06E6E)),
                                ],
                              ),
                              MyText(
                                '''内当家所有平台(网站、APP)所展示的项月介级图文、现频、评价等均客观直实尤其是关于房源位置、面积、设计、装修、价格等内容描述，如存在与事实不符，用户均可反馈。(不包含政策解读、观点陈述、预测性信息)仅限内当家实名注册用户，内当家员工及亲属不参与此次反馈，可通过内部通道沟通!''',
                                size: 15,
                                isOverflow: false,
                              ),
                              MyText(
                                '为了保证公平公正，如发现举报人提供的信息系通过非法或不正当手段获得，或不是以咨询、购房为目的而谋取不正当利益，一经证实将永久取消参加“假一赔百”的赔付资格，且我方保留追究责任的权利。',
                                size: 15,
                                isOverflow: false,
                              ),
                            ][i],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            transform: Matrix4.translationValues(0, -13, 0),
                            child: Image.asset(
                              'assets/img/bz_img2.png',
                              height: 13,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            transform: Matrix4.translationValues(0, -13, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFED049),
                                  Color(0xFFFFA92B),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            child: MyText(['承诺内容', '反馈流程', '保障范围', '特别提醒'][i], size: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          AnimatedSwitchBuilder(
            value: data,
            errorOnTap: (){},
            initialState: Center(
              child: Container(
                color: Colors.white,
                child: buildLoad(),
              ),
            ),
            objectBuilder: (v) => SizedBox(),
          ),
          buildTitle(context, title: '', widgetColor: Colors.white),
        ],
      ),
    );
  }
}

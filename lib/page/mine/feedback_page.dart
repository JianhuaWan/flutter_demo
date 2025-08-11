import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/base_http.dart';
import 'package:flutter_app/util/common_views.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  var textCon = TextEditingController();
  String? version;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(
        context,
        title: '意见反馈',
        color: Colors.white,
        isShowBorder: true,
      ),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        padding: EdgeInsets.all(17),
      ),
      btnBar: BtnWidget(
        isShowOnlyOne: true,
        titles: ['', '确定'],
        time: [1000, 1000],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.75), ElasticOutCurve(0.75)],
        onTap: [
          () {},
          () {
            if (textCon.text == '') {
              showToast('写点什么吧～');
              return;
            }
            Request.post(
              '/api/User/FeedBack',
              data: {
                "token": user.token,
                "userId": user.id,
                "content": textCon.text,
                "version": version,
              },
              isLoading: true,
              catchError: (v) {
                showToast(v.toString());
              },
              fail: (v) {
                showToast(v.toString());
              },
              success: (v) {
                showToast('提交成功');
                close();
              },
            );
          }
        ],
      ),
    );
  }

  List<Widget> get item {
    return [
      AnimationWidget(
        axis: Axis.vertical,
        delayed: 50,
        child: MyText(
          '感谢您对我们的支持和信赖，您的意见将为我们更好的改进产品和服务。',
          size: 14,
          isBold: true,
          isOverflow: false,
          color: Color(0xff333333),
        ),
      ),
      SizedBox(height: 13),
      AnimationWidget(
        axis: Axis.vertical,
        delayed: 100,
        child: Container(
          color: Colors.black.withOpacity(0.05),
          child: buildTFView(
            context!,
            con: textCon,
            hintText: '请写下问题和建议，以便于为你提供更好的服务',
            hintColor: Color(0xffB7B7B7),
            padding: EdgeInsets.all(16),
            maxLines: 10,
          ),
        ),
      ),
      SizedBox(height: 9),
      AnimationWidget(
        axis: Axis.vertical,
        delayed: 150,
        child: MyText('不多于500字', size: 13, color: Color(0xff333333)),
      ),
    ];
  }
}

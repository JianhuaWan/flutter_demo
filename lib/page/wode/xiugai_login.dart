import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/http.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:flutter_app/widget/widgets.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';

///修改登录密码
class XiugaiLogin extends StatefulWidget {
  @override
  _XiugaiLoginState createState() => _XiugaiLoginState();
}

class _XiugaiLoginState extends State<XiugaiLogin> {
  var phoneCon = TextEditingController();
  var phoneCon1 = TextEditingController();
  var phoneCon2 = TextEditingController();
  bool isShowPass = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: LoginTitleWidget(isZhuche: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(item.length, (i) => item[i]),
      ),
      btnBar: BtnWidget(
        titles: ['重置密码', '确认修改'],
        time: [750, 750],
        value: [50, 50],
        axis: [Axis.vertical, Axis.vertical],
        curve: [ElasticOutCurve(0.5), ElasticOutCurve(0.5)],
        delayed: [0, 100],
        onTap: [
          () {
            setState(() {
              phoneCon1.clear();
              phoneCon2.clear();
            });
          },
          () {
            if (phoneCon.text == '') {
              showToast('请输入原密码');
            } else {
              if (phoneCon1.text == '') {
                showToast('请输入新密码');
              } else if (phoneCon2.text == '') {
                showToast('请确认新密码');
              } else if (phoneCon1.text != phoneCon2.text) {
                showToast('两次输入的密码不一致');
              } else {
                Request.post(
                  '/api/User/ChangePassword',
                  data: {
                    "userName": user.userName,
                    "password": generateMd5(phoneCon.text),
                    "newPassword": generateMd5(phoneCon2.text),
                  },
                  isLoading: true,
                  catchError: (v) {
                    showToast(v.toString());
                  },
                  fail: (v) {
                    showToast(v.toString());
                  },
                  success: (v) async {
                    showToast('修改成功');
                    await userPro.cleanUserInfo();
                    jumpPage(PassWordLogin(), isClose: true, isMoveBtm: true);
                  },
                );
              }
            }
          },
        ],
      ),
    );
  }

  List<Widget> get item {
    return [
      TweenWidget(
        delayed: 50,
        axis: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 17, top: 17),
          child: MyText(
            '修改登录密码',
            size: 24,
            isBold: true,
          ),
        ),
      ),
      SizedBox(height: 37),
      Expanded(
        child: TweenWidget(
          delayed: 100,
          axis: Axis.vertical,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: phoneCon,
                  style: TextStyle(fontSize: 14),
                  maxLength: 11,
                  cursorColor: Theme.of(context!).primaryColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    hintText: '\t请输入原密码',
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                Divider(height: 0, color: Colors.black26),
                SizedBox(height: 27),
                TextField(
                  controller: phoneCon1,
                  style: TextStyle(fontSize: 14),
                  maxLength: 11,
                  cursorColor: Theme.of(context!).primaryColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    hintText: '\t请设置新密码',
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                Divider(height: 0, color: Colors.black26),
                SizedBox(height: 27),
                TextField(
                  controller: phoneCon2,
                  style: TextStyle(fontSize: 14),
                  maxLength: 11,
                  cursorColor: Theme.of(context!).primaryColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    hintText: '\t请再次输入新密码',
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                Divider(height: 0, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}

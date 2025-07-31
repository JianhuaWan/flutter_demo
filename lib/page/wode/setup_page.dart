import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kqsc/page/wode/xieyi_page.dart';
import 'package:kqsc/util/comon.dart';
import 'package:kqsc/util/http.dart';
import 'package:kqsc/model/user_model.dart';
import 'package:kqsc/page/wode/fankui_page.dart';
import 'package:kqsc/page/wode/guanyu_page.dart';
import 'package:kqsc/page/wode/shiming_page.dart';
import 'package:kqsc/page/wode/xiugai_login.dart';
import 'package:kqsc/provider/provider_config.dart';
import 'package:kqsc/provider/user_provider.dart';
import 'package:kqsc/widget/tween_widget.dart';
import 'package:kqsc/widget/widgets.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/config/net/pgyer_api.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:provider/provider.dart';

import '../login_page.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  var kehuXinbie, kehuType, tuijianLoupan, daofangTime, peitongZhuchang;
  TextEditingController textCon1 = TextEditingController();
  TextEditingController textCon2 = TextEditingController();
  TextEditingController textCon3 = TextEditingController();

  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '设置',
        color: Colors.white,
        isShowBorder: true,
      ),
      brightness: Brightness.dark,
      btnBar: Selector<UserProvider, UserModel>(
        selector: (_, k) => k.userModel,
        builder: (_, v, view) {
          return v == null
              ? SizedBox()
              : TweenWidget(
                  axis: Axis.vertical,
                  curve: ElasticOutCurve(1),
                  delayed: 800,
                  time: 750,
                  child: WidgetTap(
                    isElastic: true,
                    onTap: () {
                      showTc(
                        onPressed: () async {
                          await Future.delayed(Duration(milliseconds: 250));
                          await userPro.cleanUserInfo();
                          showToast('已退出！');
                          close();
                          // jumpPage(PassWordLogin(), isMoveBtm: true, isClose: true);
                        },
                        title: '确定退出登录吗？',
                      );
                    },
                    child: Container(
                      height: 50,
                      color: Colors.white,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(16),
                      child: MyText(
                        '退出登录',
                        isBold: true,
                        color: Color(0xff666666),
                      ),
                    ),
                  ),
                );
        },
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          TweenWidget(
            axis: Axis.vertical,
            delayed: 300,
            time: 750,
            curve: ElasticOutCurve(1),
            child: ItemEditWidget(
              color: Colors.white,
              isBoldTitle: true,
              title: '修改个人信息',
              isSelecto: true,
              isShowDivider: false,
              titleColor: Color(0xff666666),
              selectoColor: Color(0xff666666),
              selectoText: '',
              selectoOnTap: () {
                if (user == null) {
                  jumpPage(PassWordLogin(), isMoveBtm: true);
                } else {
                  jumpPage(ModifyUserInfo());
                }
              },
            ),
          ),
          SizedBox(height: 16),
          TweenWidget(
            axis: Axis.vertical,
            isOpacity: true,
            delayed: 200,
            time: 750,
            curve: ElasticOutCurve(1),
            child: Container(
              color: Colors.white,
              child: MyListView(
                isShuaxin: false,
                itemCount: 5,
                physics: NeverScrollableScrollPhysics(),
                listViewType: ListViewType.Separated,
                divider: Divider(height: 0, indent: 16),
                item: (i) {
                  return ItemEditWidget(
                    title: [
                      '修改登录密码',
                      // '修改提现密码',
                      '意见反馈',
                      '关于我们',
                      '使用协议',
                      '隐私政策',
                      // '注销账号',
                    ][i],
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                    isShowDivider: false,
                    isBoldTitle: true,
                    titleColor: Color(0xff666666),
                    isSelecto: true,
                    selectoText: '',
                    selectoOnTap: () {
                      switch (i) {
                        case 0:
                          if (user == null) {
                            jumpPage(PassWordLogin(), isMoveBtm: true);
                          } else {
                            jumpPage(XiugaiLogin());
                          }
                          break;
                        case 1:
                          jumpPage(FankuiPage());
                          break;
                        case 2:
                          jumpPage(GuanyuPage());
                          break;
                        case 3:
                          jumpPage(XieyiPage(type: '12'));
                          break;
                        case 4:
                          jumpPage(XieyiPage(type: '11'));
                          break;
                        default:
                          showToast('开发中');
                          break;
                      }
                    },
                  );
                },
              ),
            ),
          ),
          if (Platform.isAndroid) SizedBox(height: 16),
          if (Platform.isAndroid)
            TweenWidget(
              axis: Axis.vertical,
              delayed: 300,
              time: 750,
              curve: ElasticOutCurve(1),
              child: ItemEditWidget(
                color: Colors.white,
                isBoldTitle: true,
                title: '检测更新',
                isSelecto: true,
                isShowDivider: false,
                titleColor: Color(0xff666666),
                selectoColor: Color(0xff666666),
                selectoText: 'V${app.packageInfo.version}',
                selectoOnTap: () async {
                  await ComonUtil.checkUpdateApp(true);
                  // showToast('已是最新版～');
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ModifyUserInfo extends StatefulWidget {
  @override
  _ModifyUserInfoState createState() => _ModifyUserInfoState();
}

class _ModifyUserInfoState extends State<ModifyUserInfo> {
  TextEditingController textCon1 = TextEditingController();
  TextEditingController textCon2 = TextEditingController();

  String xinbie;

  String icon;

  String realName;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    textCon1.text = user.mobile;
    textCon2.text = user.nickName;
    xinbie = user.gender == 0 ? '女' : '男';
    realName =
        user.realName == 'null' || user.realName == '' || user.realName == null
            ? null
            : user.realName;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '修改个人信息',
        color: Colors.white,
        isShowBorder: true,
        rigthWidget: WidgetTap(
          isElastic: true,
          onTap: () async {
            await Request.post(
              '/api/User/Update',
              isLoading: true,
              data: {
                "userId": user.id,
                "userName": textCon2.text,
                "realName": realName,
                "nickName": textCon2.text,
                "gender": xinbie == '男' ? '1' : '0',
                "portrait": icon,
                // "birthday": getIso8601String(),
              },
              catchError: (v) => showToast(v),
              success: (v) async {
                showToast('修改成功');
                chat.changeChatUserInfo(
                    user.id, realName, icon ?? user.portrait);
                userPro.setUserModel(v['data'], user.token);
                // await userPro.refreshToken();
                close();
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MyText(
              '保存',
              size: 16,
              color: Color(0xFF3EBD33),
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.white,
          child: MyListView(
            isShuaxin: false,
            itemCount: 5,
            physics: BouncingScrollPhysics(),
            listViewType: ListViewType.Separated,
            divider: Divider(height: 0, indent: 16),
            item: (i) {
              return ItemEditWidget(
                title: ['头像', '姓名', '手机号码', '昵称', '性别'][i],
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                isShowDivider: false,
                isBoldTitle: true,
                isEditText: i == 2 || i == 3,
                titleColor: Color(0xff666666),
                isSelecto: i == 1 || i == 4,
                textCon: [null, null, textCon1, textCon2, null][i],
                selectoText: [
                  '',
                  realName == null
                      ? [user.realName, '请实名'][user.isIdentity ? 0 : 1]
                      : realName,
                  '',
                  '',
                  xinbie
                ][i],
                rightChild: i == 0
                    ? Row(
                        children: [
                          if (icon == null)
                            user.portrait == null
                                ? MyText('请上传')
                                : ClipOval(
                                    child: WrapperImage(
                                      width: 40,
                                      height: 40,
                                      urlBuilder: () => user.portrait,
                                    ),
                                  )
                          else
                            ClipOval(
                              child: WrapperImage(
                                width: 40,
                                height: 40,
                                urlBuilder: () => icon,
                              ),
                            ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                          ),
                        ],
                      )
                    : null,
                selectoOnTap: () async {
                  switch (i) {
                    case 0:
                      // var imgList = await pickImages(maxImages: 1);
                      // flog(imgList);
                      // if (imgList.isNotEmpty) {
                      //   buildShowDialog(context, isClose: false);
                      //   try {
                      //     var file = await imgList.first.file;
                      //     var data = await uploadImage(file.path);
                      //     setState(() => icon = data);
                      //   } catch (e) {
                      //     showToast('系统异常');
                      //   } finally {
                      //     Navigator.pop(context);
                      //   }
                      // }
                      break;
                    case 1:
                      if (user.isIdentity) {
                        showToast('您已经实名认证了！');
                        return;
                      }
                      jumpPage(
                        ShimingPage(),
                        callback: (v) {
                          if (v != null) {
                            setState(() => realName = v);
                            userPro.refreshToken();
                          }
                        },
                      );
                      break;
                    case 4:
                      showSelecto(context, texts: ['男', '女'], callback: (v, i) {
                        setState(() {
                          xinbie = v;
                        });
                      });
                      break;
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

///上传图片
Future<String> uploadImage(path) async {
  // var path;
  var filename = path.substring(path.lastIndexOf("/") + 1);
  var formData = FormData.fromMap({
    'businessId': user.id,
    'fileModule': 4,
    'file': await MultipartFile.fromFile(path, filename: filename),
  });
  var options = Options(
      contentType: 'multipart/form-data',
      headers: {"Authorization": user.token});
  var response =
      await http.post('/api/File/UploadFile', data: formData, options: options);
  return response.data['data'];
}

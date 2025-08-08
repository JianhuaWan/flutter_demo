import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/util/http.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';

///密码登录
class PassWordLogin extends StatefulWidget {
  @override
  _PassWordLoginState createState() => _PassWordLoginState();
}

class _PassWordLoginState extends State<PassWordLogin> {
  var phoneCon = TextEditingController();
  var yanzhengmaCon = TextEditingController();
  bool isShowPass = !false;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: LoginTitleWidget(),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          item.length,
          (i) => item[i],
        ),
      ),
    );
  }

  List<Widget> get item {
    return [
      Padding(
        padding: EdgeInsets.only(left: 17, top: 17),
        child: MyText(
          '密码登录',
          size: 24,
          isBold: true,
        ),
      ),
      SizedBox(height: 37),
      Expanded(
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
                  hintText: '\t请输入账号',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: yanzhengmaCon,
                      style: TextStyle(fontSize: 14),
                      obscureText: isShowPass,
                      cursorColor: Theme.of(context!).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: '\t请输入账号密码',
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () {
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(
                        !isShowPass ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 27),
              WidgetTap(
                isElastic: true,
                onTap: () async {
                  if (phoneCon.text == '') {
                    showToast('请输入账号!');
                  } else if (yanzhengmaCon.text == '') {
                    showToast('请输入密码!');
                  } else {
                    Request.post(
                      '/api/User/Login',
                      data: {
                        "username": phoneCon.text,
                        "password": generateMd5(yanzhengmaCon.text),
                      },
                      isLoading: true,
                      catchError: (v) {
                        if(v.toString()=="网络连接失败"){
                          UserModel mockUser = UserModel.generateMockUserData();
                          userPro.setUserModel(mockUser.toJson());
                          showToast('登录成功（模拟数据）');
                          jumpPage(App(), isClose: true, isMoveBtm: true);
                        }
                        // showToast(v.toString());
                      },
                      fail: (v) {
                        showToast(v.toString());
                      },
                      success: (v) {
                        userPro.setUserModel(v['data']);
                        showToast('登录成功');
                        jumpPage(App(), isClose: true, isMoveBtm: true);
                      },
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context!).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        '登\t录',
                        size: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetTap(
                    isElastic: true,
                    onTap: () => jumpPage(FindPass()),
                    child: MyText(
                      '忘记密码？',
                      color: Color(0xff878787),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () {
                      jumpPage(PhoneLogin());
                    },
                    child: MyText(
                      '手机快捷登录',
                      color: Theme.of(context!).primaryColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // WeChatAndQqLoginWidget()
            ],
          ),
        ),
      ),
    ];
  }
}

///手机号登录
class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  var phoneCon = TextEditingController();
  var yanzhengmaCon = TextEditingController();
  bool isSend = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: LoginTitleWidget(),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          item.length,
          (i) => item[i],
        ),
      ),
    );
  }

  List<Widget> get item {
    return [
      Padding(
        padding: EdgeInsets.only(left: 17, top: 17),
        child: MyText(
          '手机登录',
          size: 24,
          isBold: true,
        ),
      ),
      SizedBox(height: 37),
      Expanded(
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
                  hintText: '\t请输入手机号',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: yanzhengmaCon,
                      style: TextStyle(fontSize: 14),
                      maxLength: 11,
                      cursorColor: Theme.of(context!).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: '\t请输入验证码',
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () async {
                      if (isSend) {
                        showToast('已发送，请查收!');
                      } else {
                        if (phoneCon.text == '') {
                          showToast('请输入手机号!');
                        } else {
                          RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                          bool matched = exp.hasMatch(phoneCon.text);
                          if (!matched) {
                            showToast('请输入正确的手机号码!');
                            return;
                          }
                          Request.post(
                            '/api/Sms/Send',
                            data: {"phoneNumber": phoneCon.text, "smsType": 1},
                            isLoading: true,
                            catchError: (v) => showToast('验证码发送失败'),
                            fail: (v) => showToast('验证码发送失败'),
                            success: (v) {
                              showToast('已发送，请查收!');
                              setState(() {
                                isSend = true;
                              });
                            },
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: MyText(
                        isSend ? '已发送' : '获取验证码',
                        color: isSend ? Colors.black26 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 27),
              WidgetTap(
                isElastic: true,
                onTap: () async {
                  if (phoneCon.text == '') {
                    showToast('请输入手机号!');
                  } else if (yanzhengmaCon.text == '') {
                    showToast('请输入验证码!');
                  } else {
                    Request.post(
                      '/api/User/QuickLogin',
                      data: {
                        "phoneNumber": phoneCon.text,
                        "verifyCode": yanzhengmaCon.text,
                      },
                      isLoading: true,
                      catchError: (v) {
                        showToast(v.toString());
                      },
                      fail: (v) {
                        showToast(v.toString());
                      },
                      success: (v) {
                        userPro.setUserModel(v['data']);
                        showToast('登录成功');
                        jumpPage(App(), isClose: true, isMoveBtm: true);
                      },
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context!).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        '登\t录',
                        size: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetTap(
                    isElastic: true,
                    onTap: () => close(),
                    child: MyText(
                      '密码登录',
                      color: Theme.of(context!).primaryColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // WeChatAndQqLoginWidget()
            ],
          ),
        ),
      ),
    ];
  }
}

///注册
class RegisterPage extends StatefulWidget {
  final String openId;

  const RegisterPage(this.openId, {Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var phoneCon = TextEditingController();
  var yanzhengmaCon = TextEditingController();
  var passwordCon = TextEditingController();
  var yaoqingmaCon = TextEditingController();
  bool isSend = false;
  bool isShowPass = !false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: LoginTitleWidget(isZhuche: false),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          item.length,
          (i) => item[i],
        ),
      ),
    );
  }

  List<Widget> get item {
    return [
      Padding(
        padding: EdgeInsets.only(left: 17, top: 17),
        child: MyText(
          '注册',
          size: 24,
          isBold: true,
        ),
      ),
      SizedBox(height: 37),
      Expanded(
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
                  hintText: '\t请输入手机号',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: yanzhengmaCon,
                      style: TextStyle(fontSize: 14),
                      maxLength: 11,
                      cursorColor: Theme.of(context!).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: '\t请输入验证码',
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () async {
                      if (isSend) {
                        showToast('已发送，请查收!');
                      } else {
                        if (phoneCon.text == '') {
                          showToast('请输入手机号!');
                        } else {
                          RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                          bool matched = exp.hasMatch(phoneCon.text);
                          if (!matched) {
                            showToast('请输入正确的手机号码!');
                            return;
                          }
                          Request.post(
                            '/api/Sms/Send',
                            data: {"phoneNumber": phoneCon.text, "smsType": 1},
                            isLoading: true,
                            catchError: (v) => showToast('验证码发送失败'),
                            fail: (v) => showToast('验证码发送失败'),
                            success: (v) {
                              showToast('已发送，请查收!');
                              setState(() {
                                isSend = true;
                              });
                            },
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: MyText(
                        isSend ? '已发送' : '获取验证码',
                        color: isSend ? Colors.black26 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordCon,
                      style: TextStyle(fontSize: 14),
                      obscureText: isShowPass,
                      cursorColor: Theme.of(context!).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: '\t请设置密码',
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () {
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(
                        !isShowPass ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 27),
              TextField(
                controller: yaoqingmaCon,
                style: TextStyle(fontSize: 14),
                maxLength: 11,
                cursorColor: Theme.of(context!).primaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  counterText: '',
                  hintText: '\t邀请码（非必填）',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              WidgetTap(
                isElastic: true,
                onTap: () async {
                  if (phoneCon.text == '') {
                    showToast('请输入手机号!');
                  } else {
                    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                    bool matched = exp.hasMatch(phoneCon.text);
                    if (!matched) {
                      showToast('请输入正确的手机号码!');
                      return;
                    }
                    if (yanzhengmaCon.text == '') {
                      showToast('请输入验证码!');
                    } else if (passwordCon.text == '') {
                      showToast('请输入密码');
                    } else {
                      Request.post(
                        '/api/User/Register',
                        data: {
                          "phoneNumber": phoneCon.text,
                          "verifyCode": yanzhengmaCon.text,
                          "password": generateMd5(passwordCon.text),
                          "inviteCode": yaoqingmaCon.text,
                          if (widget.openId != null) "openId": widget.openId,
                        },
                        isLoading: true,
                        catchError: (v) {
                          showToast(v.toString());
                        },
                        fail: (v) {
                          showToast(v.toString());
                        },
                        success: (v) {
                          userPro.setUserModel(v['data']);
                          showToast('登录成功');
                          jumpPage(App(), isClose: true, isMoveBtm: true);
                        },
                      );
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context!).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        '注\t册',
                        size: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetTap(
                    isElastic: true,
                    onTap: () => close(),
                    child: MyText(
                      '密码登录',
                      color: Theme.of(context!).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

///找回密码
class FindPass extends StatefulWidget {
  @override
  _FindPassState createState() => _FindPassState();
}

class _FindPassState extends State<FindPass> {
  var phoneCon = TextEditingController();
  var yanzhengmaCon = TextEditingController();
  var passwordCon = TextEditingController();
  bool isSend = false;
  bool isShowPass = !false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: LoginTitleWidget(isZhuche: false),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          item.length,
          (i) => item[i],
        ),
      ),
    );
  }

  List<Widget> get item {
    return [
      Padding(
        padding: EdgeInsets.only(left: 17, top: 17),
        child: MyText(
          '找回密码',
          size: 24,
          isBold: true,
        ),
      ),
      SizedBox(height: 37),
      Expanded(
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
                  hintText: '\t请输入账号',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: yanzhengmaCon,
                      style: TextStyle(fontSize: 14),
                      maxLength: 11,
                      cursorColor: Theme.of(context!).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: '\t请输入验证码',
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () async {
                      if (isSend) {
                        showToast('已发送，请查收!');
                      } else {
                        if (phoneCon.text == '') {
                          showToast('请输入手机号!');
                        } else {
                          RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                          bool matched = exp.hasMatch(phoneCon.text);
                          if (!matched) {
                            showToast('请输入正确的手机号码!');
                            return;
                          }
                          Request.post(
                            '/api/Sms/Send',
                            data: {"phoneNumber": phoneCon.text, "smsType": 1},
                            isLoading: true,
                            catchError: (v) => showToast('验证码发送失败'),
                            fail: (v) => showToast('验证码发送失败'),
                            success: (v) {
                              showToast('已发送，请查收!');
                              setState(() {
                                isSend = true;
                              });
                            },
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: MyText(
                        isSend ? '已发送' : '获取验证码',
                        color: isSend ? Colors.black26 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordCon,
                      style: TextStyle(fontSize: 14),
                      obscureText: isShowPass,
                      cursorColor: Theme.of(context!).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: '\t请设置新密码',
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () {
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(
                        !isShowPass ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              WidgetTap(
                isElastic: true,
                onTap: () async {
                  if (phoneCon.text == '') {
                    showToast('请输入账号!');
                  } else if (yanzhengmaCon.text == '') {
                    showToast('请输入验证码!');
                  } else if (passwordCon.text == '') {
                    showToast('请输入新密码!');
                  } else {
                    Request.post(
                      '/api/User/ResetPassword',
                      data: {
                        "phoneNumber": phoneCon.text,
                        "password": generateMd5(passwordCon.text),
                        "verifyCode": yanzhengmaCon.text,
                      },
                      isLoading: true,
                      catchError: (v) {
                        showToast(v.toString());
                      },
                      fail: (v) {
                        showToast(v.toString());
                      },
                      success: (v) {
                        // userPro.setUserModel(v['data']);
                        showToast('重置密码成功');
                        close();
                      },
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context!).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        '重置密码',
                        size: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetTap(
                    isElastic: true,
                    onTap: () => close(),
                    child: MyText(
                      '密码登录',
                      color: Theme.of(context!).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

///绑定账号
class BindAccount extends StatefulWidget {
  @override
  _BindAccountState createState() => _BindAccountState();
}

class _BindAccountState extends State<BindAccount> {
  var phoneCon = TextEditingController();
  var yanzhengmaCon = TextEditingController();
  var passwordCon = TextEditingController();
  bool isSend = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: LoginTitleWidget(isZhuche: false),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          item.length,
          (i) => item[i],
        ),
      ),
    );
  }

  List<Widget> get item {
    return [
      Padding(
        padding: EdgeInsets.only(left: 17, top: 17),
        child: MyText(
          '绑定账号',
          size: 24,
          isBold: true,
        ),
      ),
      SizedBox(height: 37),
      Expanded(
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
                  hintText: '\t请输入账号',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: yanzhengmaCon,
                      style: TextStyle(fontSize: 14),
                      maxLength: 11,
                      cursorColor: Theme.of(context!).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: '\t请输入验证码',
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () {
                      if (isSend) {
                        showToast('已发送，请查收!');
                      } else {
                        if (phoneCon.text == '') {
                          showToast('请输入手机号!');
                        } else {
                          RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                          bool matched = exp.hasMatch(phoneCon.text);
                          if (!matched) {
                            showToast('请输入正确的手机号码!');
                            return;
                          }
                          Request.post(
                            '/buyer/getRegisterCode',
                            data: {"mobile": phoneCon.text},
                            isLoading: true,
                            catchError: (v) {
                              showToast(v.toString());
                            },
                            success: (v) {
                              showToast('已发送，请查收!');
                              setState(() {
                                isSend = true;
                              });
                            },
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: MyText(
                        isSend ? '已发送' : '获取验证码',
                        color: isSend ? Colors.black26 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 0, color: Colors.black26),
              SizedBox(height: 30),
              WidgetTap(
                isElastic: true,
                onTap: () async {
                  if (phoneCon.text == '') {
                    showToast('请输入账号!');
                  } else if (yanzhengmaCon.text == '') {
                    showToast('请输入验证码!');
                  } else {
                    Request.post(
                      '/HxServer/login',
                      data: {
                        "username": phoneCon.text,
                        "password": generateMd5(yanzhengmaCon.text),
                      },
                      isLoading: true,
                      catchError: (v) {
                        showToast(v.toString());
                      },
                      fail: (v) {
                        showToast(v.toString());
                      },
                      success: (v) {
                        userPro.setUserModel(v['data']);
                        showToast('登录成功');
                        jumpPage(App(), isClose: true, isMoveBtm: true);
                      },
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context!).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        '登\t录',
                        size: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class WeChatAndQqLoginWidget extends StatelessWidget {
  const WeChatAndQqLoginWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          MyText('其他方式登录', color: Color(0xff878787)),
          SizedBox(height: 28),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WidgetTap(
                isElastic: true,
                onTap: () async {
                  showToast('微信登录');
                },
                child: Image.asset('assets/img/weixin.png', width: 34, height: 34),
              ),
              SizedBox(width: 42),
              WidgetTap(
                isElastic: true,
                onTap: () {
                  // handleQqLogin();
                },
                child: Image.asset(
                  'assets/img/qq_logo.png',
                  width: 34,
                  height: 34,
                ),
              ),
              SizedBox(width: 42),
              WidgetTap(
                isElastic: true,
                onTap: () async {
                },
                child: Image.asset(
                  'assets/img/weibo_logo.png',
                  width: 34,
                  height: 34,
                ),
              ),
            ],
          ),
          SizedBox(height: 38),
        ],
      ),
    );
  }

}

class LoginTitleWidget extends StatelessWidget {
  final bool isZhuche;

  const LoginTitleWidget({Key? key, this.isZhuche = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return buildTitle(
      context,
      title: '',
    );
  }
}

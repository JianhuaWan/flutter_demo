import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';

Widget get errorView {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildBackBtn(),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 33),
                Image.asset(
                  'assets/img/logo.png',
                  width: 117,
                  color: Color(0xff2d273d),
                ),
                SizedBox(height: 4),
                Image.asset(
                  'assets/img/wangzhi.png',
                  width: 68,
                  color: Color(0xff2d273d),
                ),
                SizedBox(height: 78),
                Image.asset(
                  'assets/img/404.png',
                  width: 272,
                  height: 152,
                ),
                SizedBox(height: 30),
                Image.asset(
                  'assets/img/quezaiwai.png',
                  width: 165,
                  height: 17,
                ),
                SizedBox(height: 4),
                Image.asset(
                  'assets/img/quezaiwai_yw.png',
                  width: 155,
                  height: 23,
                ),
                Expanded(
                  child: WidgetTap(
                    isElastic: true,
                    onTap: () => close(),
                    child: Image.asset(
                      'assets/img/fanhui_home.png',
                      width: 183,
                      height: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

///返回按钮
WidgetTap buildBackBtn([color, isPadd = true]) {
  return WidgetTap(
    isElastic: true,
    onTap: () => close(),
    child: Padding(
      padding: EdgeInsets.all(isPadd ? 12 : 0),
      child: Image.asset(
        'assets/img/back.png',
        height: 19,
        width: 11,
        color: color,
      ),
    ),
  );
}

///已收藏
ToastFuture showCollected() {
  return showToastWidget(
    Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/img/shoucang_chenggong.png',
            width: 20,
            height: 20,
          ),
          SizedBox(height: 8),
          MyText('收藏成功', color: Colors.white),
        ],
      ),
    ),
  );
}

///已收藏
ToastFuture showNotCollected() {
  return showToastWidget(
    Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/img/shoucang.png',
            width: 20,
            height: 20,
          ),
          SizedBox(height: 8),
          MyText('取消收藏成功', color: Colors.white),
        ],
      ),
    ),
  );
}

///构建容器背景图片
DecorationImage buildBgImage(String assets) {
  return DecorationImage(image: AssetImage(assets), fit: BoxFit.fill);
}

///构建文本框
Widget buildTFView(
  BuildContext context, {
  bool isExp = false,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  required String hintText,
  void Function(String)? onChanged,
  void Function()? onTap,
  void Function(String)? onSubmitted,
  TextStyle? textStyle,
  TextStyle? hintStyle,
  FocusNode? focusNode,
  TextInputAction? textInputAction,
  double hintSize = 14,
  Color? hintColor,
  double textSize = 14,
  Color? textColor,
  EdgeInsetsGeometry? padding,
  TextEditingController? con,
  TextAlign? textAlign,
  bool isInt = false,
  bool isDouble = false,
  bool isAz = false,
  int maxLines = 1,
  double height = 20,
}) {
  return [
    Expanded(
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        height: height,
        child: TextField(
          focusNode: focusNode ?? null,
          controller: con,
          maxLines: maxLines,
          inputFormatters: [
            // ignore: deprecated_member_use
            // if (isAz) WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")), //只允许输入字母
            // // ignore: deprecated_member_use
            // if (isInt) WhitelistingTextInputFormatter.digitsOnly, //只允许输入数字
            // // ignore: deprecated_member_use
            // if (isDouble) WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入小数
          ],
          style: textStyle ?? TextStyle(fontSize: textSize, color: textColor),
          cursorColor: Theme.of(context).primaryColor,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: hintSize,
              color: hintColor ?? Color(0xff666666),
            ),
            hintText: "$hintText",
            border: OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onChanged,
          onTap: onTap,
          onSubmitted: onSubmitted,
        ),
      ),
    ),
    Container(
      padding: padding ?? EdgeInsets.zero,
      height: height,
      child: TextField(
        focusNode: focusNode ?? null,
        style: textStyle ?? TextStyle(fontSize: textSize, color: textColor),
        cursorColor: Theme.of(context).primaryColor,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        controller: con,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          hintStyle: hintStyle ??
              TextStyle(
                fontSize: hintSize,
                color: hintColor ?? Color(0xff666666),
              ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          hintText: "$hintText",
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
        onTap: onTap,
        onSubmitted: onSubmitted,
      ),
    )
  ][isExp ? 0 : 1];
}

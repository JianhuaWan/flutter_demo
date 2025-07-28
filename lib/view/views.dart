import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

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
        'assets/img/fanhui.png',
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
  @required String hintText,
  void Function(String) onChanged,
  void Function() onTap,
  void Function(String) onSubmitted,
  TextStyle textStyle,
  TextStyle hintStyle,
  FocusNode focusNode,
  TextInputAction textInputAction,
  double hintSize = 14,
  Color hintColor,
  double textSize = 14,
  Color textColor,
  EdgeInsetsGeometry padding,
  TextEditingController con,
  TextAlign textAlign,
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


// Future buildShowModalBottomSheet(
//     BuildContext context,
//     String id,
//     String userId,
//     GlobalKey _globalKey,
//     String title,
//     String description,
//     ShareType shareType) {
//   return showModalBottomSheet(
//     context: context,
//     builder: (_) => Container(
//       height: 160,
//       width: double.infinity,
//       color: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(child: Text("")),
//               Text(
//                 "分享",
//                 style: TextStyle(color: Color(0xff333333), fontSize: 19),
//               ),
//               Expanded(
//                   child: GestureDetector(
//                 onTap: () {
//                   pop(context);
//                 },
//                 child: Container(
//                     alignment: Alignment.centerRight,
//                     padding:
//                         EdgeInsets.only(right: 15, left: 15, top: 8, bottom: 8),
//                     margin: EdgeInsets.only(left: 80),
//                     child: Text("关闭")),
//               )),
//             ],
//           ),
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () {
//                           Map webPath = {
//                             ShareType.BENDI: Config.WebBaseUrl +
//                                 "web/information/getInformation?id=$id&appUid=$userId",
//                             ShareType.GOOD: Config.WebBaseUrl +
//                                 "web/information/getGoodsDetail?id=$id&appUid=$userId",
//                             ShareType.STORE: Config.WebBaseUrl +
//                                 "web/information/getShopDetail?id=$id&appUid=$userId",
//                             ShareType.RED: Config.WebBaseUrl +
//                                 "web/information/getAreaInformation?id=$id&appUid=$userId",
//                             ShareType.FRIST: Config.WebBaseUrl +
//                                 "web/index/index?appUid=$userId"
//                           };
//                           Map miniPath = {
//                             ShareType.BENDI:
//                                 "pages/information/index?appUid=$userId&id=$id&source=detail",
//                             ShareType.GOOD:
//                                 "pages/goodsDetail/index?appUid=$userId&id=$id",
//                             ShareType.STORE:
//                                 "pages/shopDetail/index?appUid=$userId&id=$id",
//                             ShareType.RED:
//                                 "pages/areaInformation/index?appUid=$userId&id=$id&source=detail",
//                             ShareType.FRIST: "pages/index/index?appUid=$userId"
//                           };

//                           if (shareType == ShareType.FRIST) {
//                             // print("----------666-----------");
//                             var model = new WeChatShareMiniProgramModel(
//                                 webPageUrl: webPath[shareType],
//                                 miniProgramType: WXMiniProgramType.RELEASE,
//                                 userName: "gh_6e1e0c36ad7c",
//                                 hdImagePath: WeChatImage.asset(
//                                     "assets/img/shareimg1.jpg"),
//                                 withShareTicket: true,
//                                 path: miniPath[shareType],
//                                 title: title,
//                                 description: description,
//                                 thumbnail: WeChatImage.asset(
//                                     "assets/img/shareimg1.jpg"));

//                             shareToWeChat(model);
                            
//                           } else {
//                             capturePng(_globalKey).then((value) async {
//                               Uint8List list = Uint8List.fromList(
//                                   Luban.comressImageJpg(value, 50));
//                               WeChatImage img = WeChatImage.binary(list);

//                               var model1 = WeChatShareWebPageModel(
//                                   "https://m.cngky.com/tg.html",
//                                   title: "工控云物联网平台",
//                                   description: "平台满足放租工厂、企业基础的定向设备物联租赁需求，如生产监控、设备启动、设备定位（设备超距）、设备销售、设备故障上报、设备续费、工单处理、客户关系维护、商户入驻、设备信息查询",
//                                   thumbnail: img,
//                                   scene: WeChatScene.SESSION);

//                               // var model = new WeChatShareMiniProgramModel(
//                               //     webPageUrl: webPath[shareType],
//                               //     miniProgramType: WXMiniProgramType.RELEASE,
//                               //     userName: "gh_6e1e0c36ad7c",
//                               //     hdImagePath: img,
//                               //     withShareTicket: true,
//                               //     path: miniPath[shareType],
//                               //     title: title,
//                               //     description: description,
//                               //     thumbnail: img);
//                               shareToWeChat(model1).then((value){
//                                       print("shareToWeChat$value");
//                               });
//                             });
//                           }
//                         },
//                         child: Image.asset(
//                           ImgConfig.weixin1,
//                           width: 45,
//                           height: 45,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Text(
//                         "微信好友",
//                         style:
//                             TextStyle(fontSize: 13, color: Color(0xff999999)),
//                       ),
//                       SizedBox(
//                         height: 7,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () {
//                           // print("----------777777-----------");
//                           capturePng(_globalKey).then((value) {
//                              Uint8List list = Uint8List.fromList(
//                                   Luban.comressImageJpg(value, 50));
//                               WeChatImage img = WeChatImage.binary(list);
//                             // ignore: unused_local_variable
//                             var model1 = new WeChatShareWebPageModel(
//                               shareType == ShareType.BENDI
//                                   ? Config.WebBaseUrl +
//                                       "web/information/getInformation?id=$id&appUid=$userId"
//                                   //  ?"http://m.ershengsan.cn/web/login/login?source=1&id=5ed08ec49a0be74b4dedf5a1&appUid=5d2177999a0be718ab32b9ec"
//                                   : shareType == ShareType.GOOD
//                                       ? Config.WebBaseUrl +
//                                           "web/information/getGoodsDetail?id=$id&appUid=$userId"
//                                       : shareType == ShareType.STORE
//                                           ? Config.WebBaseUrl +
//                                               "web/information/getShopDetail?id=$id&appUid=$userId"
//                                           : shareType == ShareType.RED
//                                               ? Config.WebBaseUrl +
//                                                   "web/information/getAreaInformation?id=$id&appUid=$userId"
//                                               : shareType == ShareType.FRIST
//                                                   ? Config.WebBaseUrl +
//                                                       "web/index/index?appUid=$userId"
//                                                   : Config.WebBaseUrl +
//                                                       "web/index/index?appUid=$userId",
//                               scene: WeChatScene.TIMELINE,
//                               title: title,
//                               description: description,
//                               thumbnail: shareType == ShareType.FRIST
//                                   ? WeChatImage.asset("assets/img/gengmore.png")
//                                   : WeChatImage.binary(value),
//                             );

                            
//                               var model2 = WeChatShareWebPageModel(
//                                   "https://m.cngky.com/tg.html",
//                                   title: "工控云物联网平台",
//                                   description: "平台满足放租工厂、企业基础的定向设备物联租赁需求，如生产监控、设备启动、设备定位（设备超距）、设备销售、设备故障上报、设备续费、工单处理、客户关系维护、商户入驻、设备信息查询",
//                                   thumbnail: img,
//                                   scene: WeChatScene.TIMELINE);
//                             shareToWeChat(model2).then((value){
//                               print("shareToWeChat$value");
//                             });
//                           });
//                         },
//                         child: Image.asset(
//                           ImgConfig.pengyouquan1,
//                           width: 43,
//                           height: 43,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Text(
//                         "朋友圈",
//                         style:
//                             TextStyle(fontSize: 13, color: Color(0xff999999)),
//                       ),
//                       SizedBox(
//                         height: 7,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
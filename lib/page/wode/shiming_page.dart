import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kqsc/util/http.dart';
import 'package:kqsc/widget/widgets.dart';
import 'package:paixs_utils/config/net/api.dart';
// import 'package:ocr_plugin/ocr_plugin.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class ShimingPage extends StatefulWidget {
  @override
  _ShimingPageState createState() => _ShimingPageState();
}

class _ShimingPageState extends State<ShimingPage> {
  String _platformVersion;
  Uint8List uint8list;
  var v1, v2, v3, v4, v5;

  @override
  void initState() {
    super.initState();
    initOcrSdk();
  }

  Future<void> initOcrSdk() async {
    // await OcrPlugin.initOcrSdk(
    //   "Vxdt7K6pQSmbWqv5kurdPWML",
    //   "4u3eyX3aHD7BrDsrRhGCIxXy2pS3Y7Mx",
    // );
  }

  ///获取百度云应用token
  Future<String> getToken() async {
    var res = await Dio().get(
      'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=Vxdt7K6pQSmbWqv5kurdPWML&client_secret=4u3eyX3aHD7BrDsrRhGCIxXy2pS3Y7Mx',
    );
    return res.data['access_token'];
  }

  Future getImage() async {
    showSelectoBtn(
      context,
      texts: ['拍摄', '从相册选择'],
      callback: (v, i) async {
        PickedFile image;
        switch (i) {
          case 0:
            image = await ImagePicker().getImage(source: ImageSource.camera);
            break;
          case 1:
            image = await ImagePicker().getImage(source: ImageSource.gallery);
            break;
        }
        if (image != null) {
          try {
            buildShowDialog(context, text: '正在识别...');
            uint8list = await image.readAsBytes();
            setState(() {});
            var imgBase64 = base64.encode(uint8list);
            var token = await this.getToken();
            flog(token);
            var res = await Dio().post(
              'https://aip.baidubce.com/rest/2.0/ocr/v1/idcard?access_token=$token',
              options: Options(contentType: "application/x-www-form-urlencoded"),
              data: {"id_card_side": "front", "image": imgBase64},
            );
            close();
            if (res.data['words_result_num'] == 0) {
              showToast('识别错误');
            } else {
              var result = res.data;
              v1 = result['words_result']['姓名']['words'];
              v2 = result['words_result']['公民身份号码']['words'];
              v3 = result['words_result']['出生']['words'];
              v4 = result['words_result']['性别']['words'];
              v5 = result['words_result']['住址']['words'];
              setState(() {});
            }
            //  = await OcrPlugin.recognize(image.path, "CHN_ENG");
            // print("$result");
            // var decode = json.decode(result);
            // var ocrResult = OcrResult.fromJson(decode);
            // if (ocrResult.returnCode == 0) {
            //   setState(() {
            //     _platformVersion = ocrResult.returnMsg;
            //     v1 = _platformVersion == null
            //         ? '上传证件自动识别姓名'
            //         : _platformVersion.contains('名') && _platformVersion.contains('性')
            //             ? RegExp('名(.*?)性').firstMatch(_platformVersion.replaceAll('\n', '')).group(1)
            //             : '上传证件自动识别姓名';
            //     flog(v1);
            //     v2 = _platformVersion == null
            //         ? '上传证件自动识别证件号'
            //         : _platformVersion.contains('公民身份号码')
            //             ? RegExp('公民身份号码(.*?)\n').firstMatch(_platformVersion).group(1)
            //             : '上传证件自动识别证件号';
            //     v3 = _platformVersion == null
            //         ? '上传证件自动识别出生年月'
            //         : _platformVersion.contains('出生')
            //             ? RegExp('出生(.*?)\n').firstMatch(_platformVersion).group(1)
            //             : '上传证件自动识别出生年月';
            //     v4 = _platformVersion == null
            //         ? '上传证件自动识别性别'
            //         : _platformVersion.contains('性别')
            //             ? RegExp('性别(.*?)民族').firstMatch(_platformVersion).group(1)
            //             : '上传证件自动识别性别';
            //     v5 = _platformVersion == null
            //         ? '上传证件自动识别住址'
            //         : _platformVersion.contains('址')
            //             ? RegExp('址(.*?)公民').firstMatch(_platformVersion.replaceAll('\n', '')).group(1)
            //             : '上传证件自动识别住址';
            //   });
            // } else {
            //   setState(() {
            //     _platformVersion = ocrResult.errorMsg;
            //   });
            // }
          } catch (e) {
            close();
            showToast('请检查您的网络');
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(context, title: '实名认证', color: Colors.white),
      btnBar: BtnWidget(
        isShowOnlyOne: true,
        titles: ['', '提交'],
        isShowShadow: false,
        onTap: [
          () {},
          () async {
            if (v1 != null && v2 != null && v3 != null && v4 != null && v5 != null) {
              await Request.post(
                '/api/User/Certification',
                isLoading: true,
                data: {
                  "realName": v1,
                  "idCard": v2,
                  "birthday": v3,
                  "gender": v4,
                  "address": v5,
                },
                catchError: (v) => showToast(v),
                success: (v) {
                  showToast('提交成功');
                  close(v1);
                },
              );
            } else {
              showToast('未识别出身份证信息');
            }
          }
        ],
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 212,
                color: Color(0xffC1D1E6),
                alignment: Alignment.center,
                child: uint8list != null
                    ? Stack(
                        children: [
                          Image.memory(
                            uint8list,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Container(color: Colors.black26),
                          Positioned(
                            right: 16,
                            top: 16,
                            child: WidgetTap(
                              isElastic: true,
                              onTap: () => this.getImage(),
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : WidgetTap(
                        isElastic: true,
                        onTap: () => this.getImage(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            MyText(
                              '身份证人像照',
                              size: 24,
                              isBold: true,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          MyListView(
            isShuaxin: false,
            physics: NeverScrollableScrollPhysics(),
            item: (i) => item[i],
            itemCount: item.length,
            listViewType: ListViewType.Separated,
            divider: Divider(height: 0, indent: 16),
          ),
        ],
      ),
    );
  }

  List<Widget> get item {
    return List.generate(5, (i) {
      return ItemEditWidget(
        title: ['姓名', '证件号', '出生年月', '性别', '住址'][i],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        isEditText: false,
        isSelecto: true,
        titleColor: Colors.black,
        isShowJt: false,
        titleWidth: 72,
        selectoColor: Colors.black54,
        selectoText: [
          v1 ?? '上传证件自动识别姓名',
          v2 ?? '上传证件自动识别姓名',
          v3 ?? '上传证件自动识别姓名',
          v4 ?? '上传证件自动识别姓名',
          v5 ?? '上传证件自动识别姓名',
        ][i],
      );
    });
  }
}

class OcrResult {
  int returnCode;
  String returnMsg;
  int errorCode;
  String errorMsg;

  OcrResult({this.returnCode, this.returnMsg, this.errorCode, this.errorMsg});

  OcrResult.fromJson(Map<String, dynamic> json) {
    returnCode = json['returnCode'];
    returnMsg = json['returnMsg'];
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnCode'] = this.returnCode;
    data['returnMsg'] = this.returnMsg;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}
